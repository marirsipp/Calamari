function[Life_method_BV] = SpectralFatigue_Mthd8(path_itr, path_str, Metocean_Filename, theta0, wave_theta, Part, AllSNcurve, Mthd6Ipt, unit,scale, RunType)
%Analysis Method 6:
%spectral analysis based on bi-model wave Hs/Tp/Wave Dir fatigue bins, 
%closed form fatigue damage calculation
%Life_method_ABS = fatigue life (years) calc using ABS Fatigue Assesment
%and recorded environmental Hs/Tp/Wave Direction statistics 

%% Input parameters
Year_Length = 60*60*24*365.25; %seconds

if strcmp(RunType,'all') || strcmp(RunType,'sel')
    
    PartName = Part.Name;
    PartThk = Part.Thk;
    TorB = Part.Surf;
    SNcurve = AllSNcurve.(Part.SNname);
    
    %SN curve information
    SQ = SNcurve.S0;
    A = SNcurve.A;
    m = SNcurve.m;
    r = SNcurve.r;
    C = SNcurve.C;
    a = 0.926-0.033*m;
    b = 1.587*m - 2.323;
    Tref = SNcurve.t_ref; %reference thickness (mm)
    Texp = SNcurve.kcorr; % reference thickness exponent    
    if PartThk < Tref
        PartThk = Tref; %there is no gain from being thinner than reference thickness
    end
    
elseif strcmp(RunType,'hsp')
    
    PartName = Part.Name;
    PartThk = Part.Thk;
    TorB = Part.Surf;
    SNnames = Part.SNname;
    RowHsp = Part.ElemRow;
    NoHsp = length(RowHsp);
    for nn=1:NoHsp
        SNcurve = AllSNcurve.(SNnames{nn});
        SQ(nn,1) = SNcurve.S0;
        A(nn,1) = SNcurve.A;
        m(nn,1) = SNcurve.m;
        r(nn,1) = SNcurve.r;
        C(nn,1) = SNcurve.C;
        a(nn,1) = 0.926-0.033*m(nn);
        b(nn,1) = 1.587*m(nn) - 2.323;
        Tref(nn,1) = SNcurve.t_ref; 
        Texp(nn,1) = SNcurve.kcorr;
        if PartThk(nn) < Tref(nn,1)
            PartThk(nn) = Tref(nn,1); %there is no gain from being thinner than reference thickness
        end
    end    
end

periods = Mthd6Ipt.periods; %sec
Gamma1 = Mthd6Ipt.gamma1; 
Gamma2 = Mthd6Ipt.gamma2;
fr = 1./periods;  %1/sec

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
        pause
        if size(Shs1.Shs0,3) ~= length(simulated_wave_theta)
            error('Warning: RAO results stored not matching input wave headings, check input file')
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
            Shs0(:,kk,jj) = StrWvTransfer3(simulated_wave_theta(jj),(1./fr(kk)),path_str,PartName,TorB, unit,scale);  % Transfer Function, with thickness correction on stress.            
        end
        Shs1.(['Run' num2str(simulated_wave_theta(jj))]) = Shs0(:,:,jj);
    end
    Shs1.PartElemInfo = ElemInfo(path_str, PartName, simulated_wave_theta(1), unit);
    save(TransferFile,'-struct','Shs1')    
end
clear Shs1

if strcmp(RunType,'all')
    Shs = Shs0.*(PartThk/Tref)^Texp;
elseif strcmp(RunType,'hsp') 
    Shs0_hsp = Shs0(RowHsp,:,:);
    Shs = 0*Shs0_hsp;
    for nn=1:NoHsp
        Shs(nn,:,:) = Shs0_hsp(nn,:,:).*(PartThk(nn)/Tref(nn))^Texp(nn);
    end
elseif strcmp(RunType,'sel')
    RowHsp = Part.ElemRow;
    Shs0_sel = Shs0(RowHsp,:,:);
    Shs = Shs0_sel.*(PartThk/Tref)^Texp;
end
    
clear Shs0 Shs0_hsp Shs0_sel
NoElem = size(Shs, 1);  
mu = zeros(NoElem,1,'double');
seastate3 = zeros(NoElem,NoBin,'double');
if strcmp(RunType,'hsp')
    Sp_str_test = zeros(NoElem, length(fr),NoBin);
    eps_test = zeros(NoElem,NoBin);
    lam_test = zeros(NoElem,NoBin);
    f0_test = zeros(NoElem,NoBin);
end

%% Loop through Simulated fatigue bins

for i = Simulated_Bin

    disp(['........ Calculating fatigue damage of Bin No.' num2str(i)])
    tstart=tic;
    
    WDir_index1 = loc1(i);
    WDir_index2 = loc2(i);
    
%     Gamma1 = 1;
%     Gamma2 = 2.2;
    
    Wave1.Hs=Hs1(i); Wave1.Tp=Tp1(i);Wave1.Gam=Gamma1;
    Wave2.Hs=Hs2(i); Wave2.Tp=Tp2(i);Wave2.Gam=Gamma2;
    
    S1 = waveLibrary(2*pi*fr,Wave1,'JONSWAP');
    S2 = waveLibrary(2*pi*fr,Wave2,'JONSWAP');
    sp1=S1*2*pi; %[m^2/Hz]
    sp2=S2*2*pi;  %[m^2/Hz]

    %Convert to stress spectra, and determine 0th, 2nd, and 4th
    %spectral moment of stress response process
    area = zeros (NoElem, 1);
    area2 = zeros (NoElem, 1);
    area4 = zeros (NoElem, 1);
    Sp_str = zeros(NoElem, length(fr));    
    if (WDir_index1 ~= 0) && (WDir_index2 == 0)
        for k = 1:(length(fr)-1)
            %multiply wave spectral density by transfer function to arrive
            %at stress spectrum (MPa^2/Hz).  Integrate over this
            %spectrum
            area  = Shs(:,k,WDir_index1).^2*sp1(k)*(fr(k+1)-fr(k)) + area; %% UNITS MPa^2
            area2 = Shs(:,k,WDir_index1).^2*sp1(k)*(fr(k+1)-fr(k))*fr(k)^2 + area2; % MPa^2.*Hz^2
            area4 = Shs(:,k,WDir_index1).^2*sp1(k)*(fr(k+1)-fr(k))*fr(k)^4 + area4; % MPa^2.*Hz^2
            if strcmp(RunType,'hsp') 
                Sp_str(:,k)= Shs(:,k,WDir_index1).^2.*sp1(k); %Recording stress spectrum
            end
        end
    elseif (WDir_index1 ==0) && (WDir_index2 ~= 0)
        for k = 1:(length(fr)-1)
            area  = Shs(:,k,WDir_index2).^2*sp2(k)*(fr(k+1)-fr(k)) + area; %% UNITS MPa^2
            area2 = Shs(:,k,WDir_index2).^2*sp2(k)*(fr(k+1)-fr(k))*fr(k)^2 + area2; % MPa^2.*Hz^2
            area4 = Shs(:,k,WDir_index2).^2*sp2(k)*(fr(k+1)-fr(k))*fr(k)^4 + area4; % MPa^2.*Hz^2
            if strcmp(RunType,'hsp')
                Sp_str(:,k)= Shs(:,k,WDir_index2).^2.*sp2(k);
            end
        end
    else
        for k = 1:(length(fr)-1)
            area  = Shs(:,k,WDir_index1).^2*sp1(k)*(fr(k+1)-fr(k)) + Shs(:,k,WDir_index2).^2*sp2(k)*(fr(k+1)-fr(k)) + area; %% UNITS MPa^2
            area2 = Shs(:,k,WDir_index1).^2*sp1(k)*(fr(k+1)-fr(k))*fr(k)^2 + Shs(:,k,WDir_index2).^2*sp2(k)*(fr(k+1)-fr(k))*fr(k)^2 + area2; % MPa^2.*Hz^2
            area4 = Shs(:,k,WDir_index1).^2*sp1(k)*(fr(k+1)-fr(k))*fr(k)^4 + Shs(:,k,WDir_index2).^2*sp2(k)*(fr(k+1)-fr(k))*fr(k)^4 + area4; % MPa^2.*Hz^2
            if strcmp(RunType,'hsp')
                Sp_str(:,k)= Shs(:,k,WDir_index1).^2.*sp1(k) + Shs(:,k,WDir_index2).^2.*sp2(k);
            end
        end
    end
    if strcmp(RunType,'hsp')
        Sp_str_test(:,:,i) = Sp_str;
        Sp_wv1_test(i,:) = sp1;
        Sp_wv2_test(i,:) = sp2;
    end
    
    %0th, 2nd, and 4th spectral moment at i condition
    SpectralMoment0 = area; % MPa^2
    SpectralMoment2 = area2; % MPa^2.*Hz^2
    SpectralMoment4 = area4; % MPa^2.*Hz^4

    %% BV Spectral-Based Fatigue Assesment Method
    f0 = (SpectralMoment2./SpectralMoment0).^0.5; %ABS 6.5
    epsilon = (1-SpectralMoment2.^2./(SpectralMoment0.*SpectralMoment4)).^0.5; %ABS 6.6
    lambda = a + (1-a).*(1-epsilon).^b; % ABS 6.13
    nu = (SQ./(2.*(2)^0.5.*(SpectralMoment0).^0.5)).^2; %BV 6.3.3
    mu = gammainc(m/2+1,nu)+(A/C)*(2.*(2*SpectralMoment0)).^(r-m).*(gamma(r/2+1)- gammainc(r/2+1,nu))/gamma(m/2+1); %BV 6.3.3
    seastate3(:,i) = Prob(i)*Year_Length./A.*(2.*(2*SpectralMoment0).^0.5).^m.*mu.*gamma(m/2+1); % BV 6.3.3
    
    if strcmp(RunType,'hsp')
        eps_test(:,i) = epsilon;
        lam_test(:,i) = lambda;
        f0_test(:,i) = f0;
    end
    telapsed=toc(tstart);
    disp(['It took ' num2str(telapsed) 's for running Bin No.' num2str(i)])
    t_bin(i) = telapsed;
    
end

Life_method_BV = 1./(sum(seastate3,2)); % ABS bilinear curve
save([path_itr 'ElapsedTime.mat'],'t_bin')

%% Output results
if strcmp(RunType,'hsp')
    for p = 1:NoElem
        ElemRst{p}.CnntName = char(Part.CnntName(p,1));
        ElemRst{p}.Method = 6;
        ElemRst{p}.TotalLife = Life_method_ABS(p);
        ElemRst{p}.DmgPerBin = seastate3(p,:);
        ElemRst{p}.Heading = simulated_wave_theta;
        ElemRst{p}.Period = periods;
        ElemRst{p}.Metocean = met;
        ElemRst{p}.StrRAO = Shs(p,:,:);
        ElemRst{p}.StrSpc = Sp_str_test(p,:,:);
        ElemRst{p}.WavSpc1 = Sp_wv1_test;
        ElemRst{p}.WavSpc2 = Sp_wv2_test;
        ElemRst{p}.Epsilon = eps_test(p,:);
        ElemRst{p}.Lambda = lam_test(p,:);
        ElemRst{p}.ExpFreq = f0_test(p,:);
    end
    PartResultFile = [path_itr '\Results_Mthd6\' PartName '\ElemResult_' TorB '_Method6_Bin' num2str(NoBin) '.mat' ]; 
    save (PartResultFile, 'ElemRst')
end

end