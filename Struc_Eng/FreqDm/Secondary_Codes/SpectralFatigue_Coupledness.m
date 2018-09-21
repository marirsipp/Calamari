function Damage = SpectralFatigue_Coupledness(IPTfile)
run(IPTfile);
%% load metocean
if iDLC
    [runInfo,runList]= readRunList(DLCspreadsheet,sheetnum); %load dlc spreadsheet
    varnames=fieldnames(runList);
    for jj=1:length(varnames)
        for pp=1:length(runList)
            try
                eval([varnames{jj} '(pp)=' 'runList(pp).(varnames{jj})' ';'])
            catch
                eval([varnames{jj} '{pp}=' 'runList(pp).(varnames{jj})' ';'])
            end
        end
    end

    if exist('Probability','var') && isnumeric(Probability)
        envnames = {'Wave_Hs','Wave_Tp','Wave_Dir','Wind_Speed','Wind_Dir'};
        dlcdata = {'Probability',envnames{:}};
        if exist('Swell_Dir','var')
            disp('Found a bimodal fatigue run')
            dlcdata = {dlcdata{:}, 'Swell_Dir','Swell_Hs','Swell_Tp'};
        else
            disp('Unimodal fatigue run')
        end
        Runnames=Runname;
        dlcdata = {dlcdata{:}, 'Runnames'};
    else
        error('Need to have probability of occurrence of bin in DLC table')
    end
else  
    binfiles=dir(bindir);
    for jj=1:length(binfiles)
        jname=binfiles(jj).name;
        binstr =  regexp(jname,'_N\d*_','match');
        if length(binstr)==1
            jbinnum = str2num(binstr{1}(3:end-1));
        else
            jbinnum = nan;
        end
        if jbinnum == binnum
            binfile = [bindir jname] ;
        end
    end
    % just unimodal for now...
    [Probability,Wave_Hs,Wave_Tp,Wave_Dir,Wind_Dir,Wind_Speed] = parseCSV(binfile);
    envnames = {'Wave_Hs','Wave_Tp','Wave_Dir','Wind_Speed','Wind_Dir'};
    dlcdata = {'Probability',envnames{:}};
end

nBins = length(Probability);
TotalP = sum(Probability);
%%%%%%%%%%%%%----------------- Load Timeseries -------------------%%%%%%
if WaveSeed
    waveBB = getBB(rundirWAVE,runtype,varname,iExtract,WaveSeed); % time domain response as a function of wave dir, tp, hs 
else
    waveBB = getBB(rundirWAVE,runtype,varname,iExtract,dot4file); % time domain response as a function of wave dir, tp, hs 
end
windBB = getBB(rundirWIND,'TurbWIR',varname,iExtract); % time domain response as a function of wind dir, wind speed

nFree = 6; % number of DOFs for basebend
nRot = length(RotAngle);
nDOF=nFree + max([nRot 1]); %6 DOFs + combined S-S/F-A

nTf=size(Tfilt,2)+1;

Damage=nan(nDOF,nTf,nBins); % see setupCalDEL
MeqPerBin=nan(nDOF,nTf,nBins); 

savefile = [fatdir basename '.mat'];
if ~exist(savefile,'file') || iRun
    for ii =1:nBins
        for pp = 1: length(envnames)
            eval(['enum = ' envnames{pp} '(ii);'])
            disp1{pp} = [envnames{pp} ' = ' num2str(enum) ', '];
        end
        disp(['Searching for proper RAO and WIR for Bin #: ' num2str(ii) ' ' disp1{:} ])

%         %%%%%%%%%%%%%----------------- Lookup wind-induced PSD -------------------%%%%%%
        Sp2_str = findBB(windBB,[Wind_Speed(ii) Wind_Dir(ii)],{'Wind_Speed','Wind_Dir'},varname); % [nTime x 6]  lookup proper stress 
        fr = findBB(windBB,[Wind_Speed(ii) Wind_Dir(ii)],{'Wind_Speed','Wind_Dir'},'OutputFreq');
        nFr = length(fr);
        delfr = diff(fr);

        if iPlot && ii == 1
            % WIND SPD - TODO try to divide out Wind-speed SpecDen to get TF
            InputFreq = findBB(windBB,[Wind_Speed(ii) Wind_Dir(ii)],{'Wind_Speed','Wind_Dir'},'InputFreq'); % [nTime x 6]  
            InputPSD = findBB(windBB,[Wind_Speed(ii) Wind_Dir(ii)],{'Wind_Speed','Wind_Dir'},'InputPSD'); 
            figure('name','Turbulent Wind PSD')
            loglog(InputFreq,InputPSD)
        end
        %%%%%%%%%%%%%----------------- Lookup wave-induced timeseries or TWR-RAO -------------------%%%%%%
        if WaveSeed
            Sp1_str = findBB(waveBB,[Wave_Hs(ii) Wave_Tp(ii) Wave_Dir(ii)],{'Wave_Hs','Wave_Tp','Wave_Dir'},varname); % [nTime x 6]  lookup proper stress timeseries 
            fftIn = findBB(waveBB,[Wave_Hs(ii) Wave_Tp(ii) Wave_Dir(ii)],{'Wave_Hs','Wave_Tp','Wave_Dir'},'InputFreq'); % [nTime x 6]  lookup proper waveel timeseries 
        else
            [str1,RAO_Wave_Tp] = findBB(waveBB,[Wave_Hs(ii) nan Wave_Dir(ii)],{'Wave_Hs','Wave_Tp','Wave_Dir'},varname); % [nRAOfr x 6]  lookup proper stress timeseries 
            RAOfr = flipud(1./RAO_Wave_Tp); %[Hz] in increasing freq
            str1 = flipud(str1);
            %str1 = interp1(RAOfr,str1,fr'); % [nFr x 6]
            Wave1.Hs=Wave_Hs(ii); Wave1.Tp= Wave_Tp(ii); 
            if length(Wave_Gamma) == nBins
                Wave1.Gam=Wave_Gamma(ii);
            else
                Wave1.Gam = Wave_Gamma;
            end
            S1 = waveLibrary(2*pi*RAOfr,Wave1,'JONSWAP'); %[nFreq x 1]
            S1=S1*2*pi; %[m^2/Hz]
            Sp1_str = str1.^2.*repmat(S1,[1 nFree]); % [nFr x 6]  % (N,N,N,N-m,N-m,N-m)^2 / (m/s)
            if iPlot
                figure('name','Wave Spectrum+Wave-Induced')
                subplot(3, 1, 1)
                plot(RAOfr,S1)
                title('Wave Spectrum')
                subplot(3, 1, 2)
                plot(RAOfr,str1.^2)
                title('Wave-Induced PSD')
                subplot(3, 1, 3)
                plot(RAOfr,Sp1_str)
            end
        end
        if iPlot
            figure('name', 'Wave-Induced/Wind-Induced')
            subplot(2, 1, 1)
            plot(fr,Sp2_str)
            ylim([0 10e15])
            xlim([0 1])
            title('Wind-induced')
            subplot(2, 1, 2)
            plot(RAOfr,Sp1_str)
            title('Wave-induced')
        end
        %%%%%%%%%%%%%----------------- Calculate Stress TF -------------------%%%%%%
        if ~WaveSeed
            Sp2_str = interp1(fr,Sp2_str,RAOfr); % downsample
            fr2ifft  = RAOfr'; nFrIFFT = length(fr2ifft); delfr2ifft = diff(fr2ifft);% row vectors
        else
            fr2ifft = fr; nFrIFFT = nFr; delfr2ifft = delfr;
        end
        time = [0:dT:EndTime]'; nT = length(time);

        Sp_str= Sp1_str + Sp2_str; % sum up the two stress spectra [fr x nDOF_sensor]
          % figure(99)
          % plot(fr2ifft,Sp1_str(:,5),fr2ifft,Sp2_str(:,5),fr2ifft,Sp_str(:,5))
       %%%%%%%%%%%%%----------------- Take IFFT  -------------------%%%%%%
        rand_ph=2*pi*rand(1,nFrIFFT);
        stress_ph = 2*pi*repmat(fr2ifft,[nT 1]).*repmat(time,[1 nFrIFFT]) + repmat(rand_ph,[nT 1]); % time x freq

        %%%%%%%%%%%%%----------------- RainFlow Count -------------------%%%%%%
        M = zeros(nT,nFree);
        for pp=1:nFree
            stress_amp = sqrt(2*repmat(Sp_str(1:end-1,pp)',[nT 1]).*repmat(delfr2ifft,[nT 1])); % time x freq 
            M(:,pp)= sum(stress_amp.*sin(stress_ph(:,1:end-1)),2); % time x 1          
        end
        fftM = fft(M,[],1);
        FS = 1/dT;
        inrange = ceil((nT+1)/2); %range of frequency
        ft = (0:inrange-1)*FS/nT; %frequency
        if iPlot
             figure('name','Stress timeseries')
             subplot(2,1,1)
             plot(time,M(:,4))
             legend('Recreated')
             title('Roll Moment')
             subplot(2,1,2)
             plot(time,M(:,5))
             legend('Recreated')
             title('Pitch Moment') 
        end        
        %% Borrowed from getTwrBDEL4RunOF
        MNcurve.m = m; MNcurve.N0 = N0; MNcurve.Mu = Mu;
        CutTime = 0; % its just an IFFT!
        disp('Running Rainflow Counting')
        [Meq,Dmg]=setupCalDEL(M,Tfilt,RotAngle,dT,MNcurve,FatLifeYrs,CutTime,n_order);
        Damage(:,:,ii)=Dmg.*Probability(ii)/TotalP; % 
        MeqPerBin(:,:,ii) = Meq; % Bingbin wants to see unweighted Meq 
    end
    MomentEq =(nansum(Damage,3) * FatLifeYrs * Mu^m / N0) .^ (1/m); % Using user-defined M-N curve, calculate equivalent moment based on total damage 
    disp(['Saving ' savefile ])
    save(savefile,'MomentEq','Damage','MeqPerBin','Tfilt','RotAngle',dlcdata{:});
else
    [spath,sname,sext]=fileparts(savefile);
    load(savefile);
    disp(['Found ' sname '. Using data since iRun=0.'])
end
%%%%%%%%%%%%%----------------- Sum up to get Fatigue Life -------------------%%%%%%
if iPlot
    %% ------------ Plot by Ranking --------------%%
    plotTwrBfatigueByRank(savefile,nSeeds)
end
if iPolarPlot || iCartPlot
    %% ------------ Plot with Polar or Cartesian plots to see trends --------------%%
    plotTwrBfatiguePolarOrCart(IPTfile,savefile);
end
end

function [bb,varargout] = findBB(BB,envalues, envnames,varname)
BBvars = fieldnames(BB);
nRuns = length(BB);
%ibb = ones(nRuns,1); % default is to take them all
BB2use = BB;
for pp = 1:length(envnames)
    if sum( cellfun( @(s) ~isempty(strfind(s,envnames{pp})), BBvars  ) )
        BBvals = [BB2use(:).(envnames{pp})]';
        if ~isnan(envalues(pp))
            if ~isempty(strfind(envnames{pp},'Dir'))
                enval = mod(envalues(pp),360);
            else
                enval = envalues(pp);
            end
            ibb = min(abs(BBvals - enval)) == abs(BBvals - enval)  ;
            BB2use = BB2use(logical(ibb));
        end
    end
end
if sum(ibb) == 1
    for pp =1:length(envnames)
        disp(['Matching ' envnames{pp} ': ' num2str(envalues(pp)) ' to ' num2str(BB2use.(envnames{pp}))])
    end
elseif sum(ibb)>6
    for pp =1:length(envnames)
        if ~isnan(envalues(pp))
            disp(['Matching ' envnames{pp} ': ' num2str(envalues(pp)) ' to ' num2str(mean([BB2use.(envnames{pp})]))])
        end
    end
end
if sum(ibb)>6
    % you've found a bunch of periods
    bb = [BB2use.(varname)];   
    bb = reshape(bb,[size(BB(1).(varname),2) sum(ibb) ] )';
    Tps = [BB2use.Wave_Tp]';
    varargout{1} = Tps;
elseif sum(ibb)>1 && sum(ibb)<6 
    ib = find(ibb);
     bb = BB(ib(1)).(varname); %its right in the middle
elseif sum(ibb)==1;
    bb = BB2use.(varname);
else
    bb = zeros(size(BB(1).(varname)));
    warning('A sim was not found closest to this bin')
end
end

function [Prob,Wave_Hs,Wave_Tp,Wave_Dir,Wind_Dir,Wind_Speed] = parseCSV(binfile)
nHead = 8;
fid = fopen(binfile,'r');
for ii =1:nHead
    foo = fgetl(fid);
end
C = textscan(fid,'%d, %f, %f, %f, %f, %f, %f, %f,');
Prob = C{2} / sum(C{2});
Wave_Hs = C{4};
Wave_Tp = C{5};
Wave_Dir = C{6};
Wind_Dir = C{7};
Wind_Speed = C{8};
fclose(fid);
end
    % % This looks a lot like a normal tower-base fatigue
    % bfile=[fatdir 'Run' Runname{bb}  filesep basename '_' num2str(bb) '.mat'];
    % if ~exist(bfile,'file') || iRedoRain
    %     matfile=[fatdir 'Run' Runname{bb}  filesep 'outputs.mat'];  %change to RunPrefix once ipt is made obsolete :(
    %     if ~exist(matfile,'file')
    %         warning([matfile ' does not exist. Moving on...'])
    %         Dmg = nan(size(Dmg)); % hopefully its not the first one...
    %         Meq = nan(size(Meq)); 
    %     else
    %         disp(['Found ' matfile '. Loading..'])
    %         %% LOAD outputs.mat
    %         Res=load(matfile);
    %         tstep=mean(diff(Res.time));
    %         if isfield(Res,'basebend')
    %             M=Res.basebend; %time series (ntime x dof)
    %         elseif isfield(Res,'TwrBsMtRNA')
    %             M=TwrBsMtRNA;
    %         else
    %             error('Cannot find basebend or TwrBsMtRNA, must be trying use an old outputs.mat')
    %         end             
    %         [Meq,Dmg]=setupCalDEL(M,Tfilt,RotAngle,tstep,MNcurve,FatLifeYrs,Res.CutInTime,n_order);
    %         vars2save={'Meq','Dmg'};
    %         save(bfile,vars2save{:});
    %     end
    % else
    %     load(bfile)
    % end
    %     Damage(:,:,ii)=Dmg.*Prob(ii)/TotalP; % 
    % MeqPerBin(:,:,ii) = Meq; % Bingbin wants to see unweighted Meq 
