function Life_method_ABS = SpectralFatigue_Mthd7(path_itr, path_str, Metocean_Filename, theta0, wave_theta, Part, AllSNcurve, Mthd7Ipt, unit,scale1, RunType, SeedNo)

%Analysis Method 7:
%analysis based on bi-model wave fatigue bins, 
%Life_method_ABS = fatigue life (years) calc using ABS Fatigue Assesment
%and recorded environmental Hs/Tp/Wave Direction statistics 
%Construct principle stress time series from directional stress time
%series??

%Input set for debugging
% load([path0 SNfile])
% Metocean_Filename = MetData_File;
% AllSNcurve = SNcurve;
% clear SNcurve
% Mthd7Ipt = InputMthd7;
% scale1 = scale;

%% BEGIN should be moved to input file
dt = Mthd7Ipt.dt;
time_end = Mthd7Ipt.totaltime;
periods = Mthd7Ipt.periods; % should be converted to an input vector (for finer discretization)
gam1 = Mthd7Ipt.gamma1; 
gam2 = Mthd7Ipt.gamma2; 
%% END should be moved to input file

time=[0:dt:time_end]';
nT=length(time);
Year_Length = 60*60*24*365.25; %seconds

% Part information
PartName = Part.Name;
PartThk = Part.Thk;
TorB = Part.Surf;
    
%% SN curve information
if strcmp(RunType,'all') || strcmp(RunType,'sel')
    SNcurve{1} = AllSNcurve.(Part.SNname);
    Tref = SNcurve{1}.t_ref; %reference thickness (mm)
    Texp = SNcurve{1}.kcorr; % reference thickness exponent    
    if PartThk < Tref
        PartThk = Tref; %there is no gain from being thinner than reference thickness
    end
    
elseif strcmp(RunType,'hsp')
    SNnames = Part.SNname;
    RowHsp = Part.ElemRow;
    NoHsp = length(RowHsp);
    for nn=1:NoHsp
        SNcurve1{nn} = AllSNcurve.(SNnames{nn});
        Tref(nn,1) = SNcurve1{nn}.t_ref;
        Texp(nn,1) = SNcurve1{nn}.kcorr;
        if PartThk(nn) < Tref(nn,1)
            PartThk(nn) = Tref(nn,1); %there is no gain from being thinner than reference thickness
        end
    end    
end

fr = 1./periods;  %1/sec
nFr=length(fr);
%% Fatigue bin information
%Read in metocean data
[pathstr, name, ext, versn] = fileparts(Metocean_Filename); 
if strcmp(ext,'.mat')
    met=load(Metocean_Filename);
    
    %First wave train

    Hs1 = met.Wave_Hs;
    Tp1 = met.Wave_Tp;
    Dir1 = met.Wave_Dir;
    
    %Second wave train
    try
        Hs2 = met.Swell_Hs;
        Tp2 = met.Swell_Tp;
        Dir2 = met.Swell_Dir;
    catch
        Hs2 = zeros(size(Hs1));
        Tp2 = zeros(size(Tp1));
        Dir2 = ones(size(Dir1))*theta0;
    end
    
    Prob = met.Probability;
    if abs(sum(Prob)-1) >=1e-3
        disp('Sum of probablity of all bins not equal to 1, check input')
        pause
    end
    NoBin = length(Prob); %Total number of bins
    
    MetConv = met.DirConv;
else
    error('The code is not ready to deal with other metocean data format yet ;p Ask your metocean contact for the correct format of bins')
end


%% get simulated wave directions
% simulated_wave_theta will have the convention relative to platform 
[Simulated_Bin,simulated_wave_theta,loc1,loc2] = getSimWaveDirs(Hs1,Hs2,Dir1,Dir2,wave_theta,theta0,MetConv);
%% Compute transfer function
%pre-calculate the transfer in one of a few pre-considered wave headings
TransferFile = [path_itr PartName '_' TorB '_Shs0.mat'];
if exist(TransferFile,'file')
    disp('Using exisitng Shs0 file for stress RAO. Check if the results are up to date')
    Shs1 = load(TransferFile);    
    if ~isfield(Shs1,'Shs0')
        for mm = 1:length(simulated_wave_theta)
            Shs0(:,:,mm)=Shs1.(['Run' num2str(simulated_wave_theta(mm))]);
        end
    else
        disp('Warning: RAO results stored are in an old format, makes sure you understand the change of process')
        %pause        
        if size(Shs1.Shs0,3) ~= length(simulated_wave_theta)
            error('Warning: RAO results stored not matching all required wave headings, check input file')
        end
        %trying to be backward compatible with old stress RAO storing
        %format (storing in the order of platform relative heading [0, 330, 300, ... 30] or any subset of that
        Shs0 = NaN(size(Shs1.Shs0));
        if ismember(0,simulated_wave_theta) 
            Shs0(:,:,1)=Shs1.Shs0(:,:,1);
            [B,IX] = sort(simulated_wave_theta(2:end),'descend');
            Shs0(:,:,2:end) = Shs1.Shs0(:,:,IX+1);
        else
            [B,IX] = sort(simulated_wave_theta,'descend');
            Shs0 = Shs1.Shs0(:,:,IX);
        end
        
    end
else
    for jj = 1:length(simulated_wave_theta)
        %frequencies considered
        disp(['..... Reading stress RAO of ' PartName ' for wave heading ' num2str(simulated_wave_theta(jj)) ' degree.'])
        for kk = 1:length(fr)
            Shs0(:,kk,jj) = StrWvTransfer3(simulated_wave_theta(jj),(1./fr(kk)),path_str,PartName,TorB, unit,scale1);  % Transfer Function, with thickness correction on stress.            
        end
        Shs1.(['Run' num2str(simulated_wave_theta(jj))]) = Shs0(:,:,jj);
    end    
    Shs1.PartElemInfo = ElemInfo(path_str, PartName, simulated_wave_theta(1), unit);
    save(TransferFile,'-struct','Shs1')
end
clear Shs1

% create refined spectrum to estimate the tail of the spectrum better
frf=linspace(1/periods(end),1/periods(1),Mthd7Ipt.Nfreq );
frf=fliplr(frf);
nFrf=length(frf);

if strcmp(RunType,'all')
    Shs = Shs0.*(PartThk/Tref)^Texp; % thickness correction
elseif strcmp(RunType,'hsp')
    Shsf=nan(NoHsp,length(frf),length(simulated_wave_theta));
    Shs0_hsp = Shs0(RowHsp,:,:);
    Shs = 0*Shs0_hsp;
    for nn=1:NoHsp
        Shs(nn,:,:) = Shs0_hsp(nn,:,:).*(PartThk(nn)/Tref(nn))^Texp(nn);
        for jj = 1:length(simulated_wave_theta)
            % interpolate the stress spectrum
            Shsf(nn,:,jj)=interp1(fr,Shs(nn,:,jj),frf);
        end
    end
elseif strcmp(RunType,'sel')
    RowHsp = Part.ElemRow;
    Shs0_sel = Shs0(RowHsp,:,:);
    Shs = Shs0_sel.*(PartThk/Tref)^Texp;
end
    
% pre-allocate 
NoElem = size(Shs, 1);
if strcmp(RunType,'all') || strcmp(RunType,'sel')
    SNcurve1 = repmat(SNcurve,[NoElem,1]);
end
%mu = zeros(NoElem,1,'double');
%seastate3 = zeros(NoElem,NoBin,'double');
telapsed=0;
DSL = zeros(NoElem,NoBin);
if strcmp(RunType,'hsp')
    Sp_str_test = zeros(NoElem, nFr,NoBin);
    Spf_str_test = zeros(NoElem, nFrf,NoBin);
    Str_time_test = zeros(NoElem, nT,NoBin);
    Sp_wv1_test = zeros(NoBin, length(fr));
    Sp_wv2_test = zeros(NoBin, length(fr));
end
%% Loop through Simulated fatigue bins
for ii = Simulated_Bin % don't use i bingbin, it is a built-in matlab variable (sqrt(-1))
    disp(['........ Calculating fatigue damage of Bin No.' num2str(ii) ', Last Bin took ' num2str(round(telapsed/60)) ' min. ' sprintf('ETA = %2.1f hrs.',(NoBin-ii)*telapsed/3600)])
    tstart=tic;
    % coarser wave spectrum
    Wave1.Hs=Hs1(ii); Wave1.Tp=Tp1(ii);Wave1.Gam=gam1;
    Wave2.Hs=Hs2(ii); Wave2.Tp=Tp2(ii);Wave2.Gam=gam2;
    S1 = waveLibrary(2*pi*fr,Wave1,'JONSWAP');
    S2 = waveLibrary(2*pi*fr,Wave2,'JONSWAP');
    S1=S1*2*pi; %[m^2/Hz]
    S2=S2*2*pi;  %[m^2/Hz]
    
    if strcmp(RunType,'hsp') 
        % refined wave spectrum
        Wave1f.Hs=Hs1(ii); Wave1f.Tp=Tp1(ii);Wave1f.Gam=gam1;
        Wave2f.Hs=Hs2(ii); Wave2f.Tp=Tp2(ii);Wave2f.Gam=gam2;
        S1f = waveLibrary(2*pi*frf,Wave1f,'JONSWAP');
        S2f = waveLibrary(2*pi*frf,Wave2f,'JONSWAP');
        S1f=S1f*2*pi; %[m^2/Hz]
        S2f=S2f*2*pi;  %[m^2/Hz]
    end

	WDir_index1 = loc1(ii);
    WDir_index2 = loc2(ii);
    i1=0;
    i2=0;
    if WDir_index1 ~= 0 
    	i1=1;
    else
    	WDir_index1=1; % dummy number for index
	end
    if WDir_index2 ~= 0 
    	i2=1;
    else
    	WDir_index2=1;
	end
%%	Convert to stress spectra, and determine 0th, 2nd, and 4th
    %spectral moment of stress response process
    Sp1_str = zeros(NoElem, nFr);   
    Sp2_str = zeros(NoElem, nFr);  
	Sp_str = zeros(NoElem, nFr); 
    delfr=diff(fr);
    for kk = 1:nFr
		Sp1_str(:,kk)= Shs(:,kk,WDir_index1).^2.*S1(kk); %Recording stress spectrum
		Sp2_str(:,kk)= Shs(:,kk,WDir_index2).^2.*S2(kk);
		Sp_str(:,kk)= Sp1_str(:,kk)*i1 + Sp2_str(:,kk)*i2;	
    end
    
    if strcmp(RunType,'hsp')&& strcmp(Mthd7Ipt.RefSpec,'y')
        Sp1f_str = zeros(NoElem, nFrf);   
        Sp2f_str = zeros(NoElem, nFrf);  
        Spf_str = zeros(NoElem, nFrf); 

        for kk=1:nFrf
            Sp1f_str(:,kk)=Shsf(:,kk,WDir_index1).^2.*S1f(kk); %Recording stress spectrum 
            Sp2f_str(:,kk)=Shsf(:,kk,WDir_index2).^2.*S2f(kk); %
            Spf_str(:,kk)= Sp1f_str(:,kk)*i1 + Sp2f_str(:,kk)*i2;    
        end
        
        Sp_str_test(:,:,ii) = Sp_str;
        Sp_wv1_test(ii,:) = S1;
        Sp_wv2_test(ii,:) = S2;
        Spf_str_test(:,:,ii) = Spf_str;
    elseif strcmp(RunType,'hsp')
        Sp_str_test(:,:,ii) = Sp_str;
        Sp_wv1_test(ii,:) = S1;
        Sp_wv2_test(ii,:) = S2;
    end
%         figure(10)
%     plot(2*pi*fr,Sp_str(1,:),'k-o',2*pi*frf,Spf_str(1,:),'r.-')
%     legend('Broadband','Narrow-band')
%     xlabel('Freq (rad/sec)')
%     ylabel('Spectrum')
%     pause

    % area0=trapz(fr, Sp_str, 2);
    % area2=trapz(fr, Sp_str.*fr.^2, 2);
    % area4=trapz(fr, Sp_str.*fr.^4, 2);

    %% Sample spectrum to create time series
    % do I want to sample the two different spectra
	
    rand_ph=2*pi*rand(1,nFr);
    stress_ph = 2*pi*repmat(fr,[nT 1]).*repmat(time,[1 nFr]) + repmat(rand_ph,[nT 1]);
    randf_ph=2*pi*rand(1,nFrf);
    stressf_ph = 2*pi*repmat(frf,[nT 1]).*repmat(time,[1 nFrf]) + repmat(randf_ph,[nT 1]);
    %% RAINFLOW COUNTING
    for pp=1:NoElem 
        % uncomment for rainflow counting of the coarse output spectrum
       
        if ~strcmp(Mthd7Ipt.RefSpec,'y')
            stress_amp = sqrt(2*repmat(Sp_str(pp,1:end-1),[nT 1]).*repmat(delfr,[nT 1])); % time x freq 
            stress_t= sum(stress_amp.*sin(stress_ph(:,1:end-1)),2); % time x 1
        else         
            stressf_amp = sqrt(2*repmat(Spf_str(pp,1:end-1),[nT 1]).*repmat(diff(frf),[nT 1])); % time x freq 
            stress_t= sum(stressf_amp.*sin(stressf_ph(:,1:end-1)),2); % time x 1
        end
        
        DSL(pp,ii) = runRainflowExe(stress_t, SNcurve1{pp})* Year_Length/time_end * Prob(ii); 
%         if strcmp(RunType,'hsp') %Save for result study
%             Str_time_test(pp,:,ii) = stress_t';
%         end
    end
    telapsed=toc(tstart);
end
Life_method_ABS = 1./sum(DSL,2);

%% Output results
if strcmp(RunType,'hsp')
    for p = 1:NoElem
        ElemRst{p}.CnntName = char(Part.CnntName(p,1));
        ElemRst{p}.Method = 7;
        ElemRst{p}.TotalLife = Life_method_ABS(p);
        ElemRst{p}.DmgPerBin = DSL(p,:);
        ElemRst{p}.Heading = simulated_wave_theta;
        ElemRst{p}.Period = periods;
        ElemRst{p}.Metocean = met;
        ElemRst{p}.StrRAO = Shs(p,:,:);
        ElemRst{p}.StrSpc = Sp_str_test(p,:,:);
        ElemRst{p}.FreqRef = frf;
        ElemRst{p}.StrRefSpc = Spf_str_test(p,:,:);
        ElemRst{p}.WavSpc1 = Sp_wv1_test;
        ElemRst{p}.WavSpc2 = Sp_wv2_test;
%         ElemRst{p}.StrTmSrs = Str_time_test(pp,:,:);
    end
    path_part = [path_itr '\Results_Mthd7\Seed' num2str(SeedNo) '\' PartName '\'];
    if ~exist(path_part,'dir')
        mkdir(path_part)
    end
    PartResultFile = [path_part '\ElemResult_' TorB '_Method7_Bin' num2str(NoBin) '.mat' ];
    save (PartResultFile, 'ElemRst','-v7.3')
end

end

% Verification plots, uncomment for figures

    % area0=trapz(fr, Sp_str(1,:), 2);
    % area2=trapz(fr, Sp_str(1,:).*(fr).^2, 2);
    % area4=trapz(fr, Sp_str(1,:).*(fr).^4, 2);
    % area0f=trapz(frf, Spf_str, 2);
    % area2f=trapz(frf, Spf_str.*(frf).^2, 2);
    % area4f=trapz(frf, Spf_str.*(frf).^4, 2);
    % epsilonf=sqrt(1-area2f^2/(area0f*area4f));
    % epsilon=sqrt(1-area2^2/(area0*area4));

     % [lmf, imdf]=lmax(stressf_t);
     %    [lnf, indf]=lmin(stressf_t);
     %    lmnf = abs([lmf lnf]);
     %    nBin=40;
     %    binfran=linspace(0,max(lmf),nBin);
     %    [binf,ibinf]=histc(lmf,binfran);
     %    [binN,binX]=hist(lmf,nBin);
     %    xx=binfran;
     %    rayl=xx/(area0f).*exp(-xx.^2/(2*area0f));
     %    figure(11)
     %    plot(time,stressf_t,'r-',time,stress_t,'k-',time(imdf),lmf,'rx')
     %    legend('Narrow-band','Broad-band','Peaks')
     %    figure(12)
     %    clf
     %    %plot(binfran,binf/sum(binf),xx,rayl,'r-')
     %    pdfbin = binN/(sum(binN)*mean(diff(binX)));
     %    pdfs = moving(pdfbin,3);
     %    bar(binX,pdfbin)
     %    hold on
     %    plot(xx,rayl,'r-o',binX,pdfs,'b-')
     %    hold off
     %    legend('PDF of peaks','Rayleigh fcn','Smoothed PDF')

