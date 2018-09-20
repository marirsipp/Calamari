function varargout=RunOF(runInfo,runList)
%% Description
% Takes a cell array of input variables and runs OrcaFlex or OrcaFAST. See
% User's Guide for more information
%% Variables2Define
% RunInfo [structure] = see example DLC spreadsheet on GitHub  
% RunList [structure] = see example DLC spreadsheet on GitHub 
%% Preamble
% Written by Sam Kanner, with snippets from Alan Lum's RunOFv* codes
% Copyright Principle Power Inc., 2016
%% Get project-specific information
if isempty(runInfo)
    %backwards-compatible, grrrr....
    iptname=getIPTname(mfilename);
    run(iptname);
else
    defaultVarnames=fieldnames(runInfo);
    for jj=1:length(defaultVarnames)
         eval([defaultVarnames{jj} '=' 'runInfo.(defaultVarnames{jj})' ';']) %remove the high level structure 'runInfo'
    end
end

General.iAgain=0; % run another iteration? default = no (see PostOF-> PostLD for criteriaa for another iteration)
%% SETUP variables: See excel spreadsheet for names of variables being used
% input_list=varargin;
% [varnames,General.iFat]=getMyInputs(input_list);
varnames=fieldnames(runList);
for jj=1:length(varnames)
    runVar=setDefaultValue(varnames{jj},runList.(varnames{jj}));
    %variables in the DLC sheet have precedence over values set in
    %'Introduction' sheet
    
    if iscell(runList.(varnames{jj}))
        %then its not empty
        runVar=runList.(varnames{jj});
    elseif ~sum(isnan(runList.(varnames{jj}))) %
        runVar=runList.(varnames{jj}); % overwrite 'Introduction' values with those found in DLC sheet
    end
    eval([varnames{jj} '=' 'runVar' ';'])
end
General.RunFolder=RunFolder;
General.RunPrefix=RunPrefix;
General.RunFlag=setDefaultValue('Run_Flag',1);
%% Datfile check   
if ~exist('Datfile','var')
    error('Datfile is unspecified. Please specify datfile in DLC spreadsheet or RunOFipt.m file')
end
if isnan(Datfile(1)) || isempty(Datfile)
    error('Datfile is unspecified. Please specify datfile in DLC spreadsheet or RunOFipt.m file')
end
datfile=Datfile; % I know, case-sensitive is crappy...
%% OrcaFlex version
OrcaDll=getOrcaDll(datfile); %points to the dll you want to have
desAPIver=1.0;
if isfield(runInfo,'OrcaFlexVer')
    desAPIver= str2double(regexp(runInfo.OrcaFlexVer,['\d+\.\d*'],'match'));
    if isempty(desAPIver)
        desAPIver=str2double(regexp(runInfo.OrcaFlexVer,['\d*'],'match'));
    end
end
if desAPIver==1
    desAPIver=str2double(regexp(OrcaDll,'\d+\.\d*','match'));
end
Cofxdir=which('ofx'); % this will be on the matlabpath
iOF=strfind(Cofxdir,'OrcaFlex');
iOFseps=strfind(Cofxdir,filesep);
baseAPIdir=Cofxdir(1:iOF+length('OrcaFlex'));
endAPIdir=Cofxdir(iOF+length('OrcaFlex')+1:iOFseps(end)-1);
ofxdirs=rdir(baseAPIdir,'regexp(name,[''\.''],''match'') '); % lists all directories in the OrcaFlex folder with a decimal in their name
% what if you have multiple OrcFxAPI on your matlabpath? That's dumb...
%APIpath=allpaths{iAPIpath};
APIpath=[baseAPIdir endAPIdir];
APIver=str2double(regexp(endAPIdir,['\d+\.\d*'],'match'));

% you may have multiple versions of OrcaFlex installed on your PC
ofxvers86=str2double(regexp([ofxdirs.name],['\d+\.\d*'],'match'));
ofxvers=ofxvers86(ofxvers86~=86);
%iseps=strfind(ofxdirs(1).name,filesep);
%ofxvers= arrayfun(@(s) str2double(s.name(iseps(end)+1:end)),ofxdirs);
if sum(isnan(ofxvers))
    error('oh shit you somehow have orcaflex versions with different pathnames?')
end
%choose the max version
[latestofx,iofmax]=max(ofxvers);
oldestofx=min(ofxvers);
%check if the latest version is on the matlab path
if APIver~=desAPIver %<latestofx
    %you are not on the latest API dir
    rmpath(APIpath)
    APIpath=[baseAPIdir regexprep(endAPIdir,['\d+\.\d*'],sprintf('%1.1f',desAPIver))];
    addpath(APIpath)
end

allpaths=strread(matlabpath,'%s','delimiter',';');
iAPIpath=find(not(cellfun('isempty', strfind(allpaths,baseAPIdir))));
disp(['Using OrcaFlex software v' ofx.DLLVersion ' with MATLAB API in ' allpaths{iAPIpath}])
General.OFver=desAPIver;
%% Find the main working directory
[datfilepath, datfilename] = fileparts(datfile); %datfilepath does not include filesep
slashes=strfind(datfilepath,filesep);
General.MainFolder = datfilepath(1:slashes(end)); % assume that the working directory is one level above where the dat file is
%% Get the RunName
General.RunName=Runname; %direct from the spreadsheet
%% Create Directory in RunFolder
resultsdir=[General.MainFolder General.RunFolder filesep];
if ~exist(resultsdir,'dir')
    disp([resultsdir ' not found. Creating one'])
    mkdir(resultsdir);
end
rundir=[resultsdir General.RunPrefix General.RunName filesep];
if ~exist(rundir,'dir')
    mkdir(rundir);
end

%% Get Turbine and Platform (incl OF file) properties:
% Determined in project-specific ipt.m file
if exist('TurbineName','var')
    Turbine=getMyTurbine(TurbineName);
    Turbine.Name=TurbineName;
    Turbine.AltName=strrep(TurbineName,'_','');
else
    Turbine.Name='';
    Turbine.AltName='';
end
if exist('PlatformName','var')
    Ptfm=getMyPtfm(PlatformName);
end
Ptfm.datfile=datfile;    
disp(['Using Orcaflex model: ' datfilename])
if exist('K','var')
    Ptfm.K=K;
end
if exist('F_des','var')
    Ptfm.F_des=F_des;
end
if exist('X_des','var')
    Ptfm.X_des=X_des;
end
%% Get OrcaFlex or OrcaFAST flag
if ~exist('FAST_Flag_default','var') % if it specified in ipt, set it as default
    FAST_Flag_default=0; 
end
Ptfm.iFAST=setDefaultValue('FAST_Flag',FAST_Flag_default); % assume you are running OrcaFlex if not specified
General.iFat=0; %initialize fatigue_flag (set to 1 if inputcode is not specified)
%% Setup OF RUN

if General.RunFlag
    %% Create Temporary Working Directory
    tempdir=MakeTempDirName(General.MainFolder); %includes filesep at end

    %% RAO, Free-Decay, or Force-Excursion?
    % "Special" runnames contain: RAO, FDecay, or FExcrn (case-sensitive)
    General.iRAO=~isempty(strfind(General.RunName,'RAO')); 
    General.iFD=~isempty(strfind(General.RunName,'FDecay'));
    General.iFE=~isempty(strfind(General.RunName,'FExcrn'));
    General.iLD=~isempty(strfind(General.RunName,'LDfind'));
    General.iSpecial = General.iRAO | General.iFD | General.iFE | General.iLD; % logical for a "special" run
    % WIND
    Wind.Dir=setDefaultValue('Wind_Dir',0);
    Wind.Type=setDefaultValue('Wind_Type',0);
    Wind.Seed=setDefaultValue('Wind_Seed','');
    Wind.Speed=setDefaultValue('Wind_Speed',NaN);
    Wind.Grid=setDefaultValue('Wind_Grid','');
    Wind.FileExt=setDefaultValue('Wind_FileType','wnd'); % let's use wnd by default
    Wind.FileExt = ['.' Wind.FileExt]; 
    Wind.ResName='';
    if ~isempty(Wind.Grid)
        Wind.ResName=sprintf('%02dx%02d',Wind.Grid,Wind.Grid);%''; % Ilias can write his crazy gridsize file name here 
    end
    %% Create missing variables from truncated Fatigue input_list
    TmpCode=setDefaultValue('Inputcode','');
    if isempty(TmpCode) && ~General.iSpecial
        disp('Inputcode not set. Assuming fatigue run')
        General.iFat=1;
        if ~exist('Ballast_Flag','var')
            Ballast_Flag=2; % IS THIS TRUE FOR ALL FUTURE PROJECTS?!?! 
        end
        if Wind.Speed < Turbine.CutIn || Wind.Speed > Turbine.CutOut
            TmpCode = 'PAR';
        else
            TmpCode = 'POW';
        end
        disp(['Using input code ' TmpCode ' based on turbine cut-in and cut-out speeds.'])
    elseif isempty(TmpCode) && Ptfm.iFAST
        warning('Turbine Code: Inputcode not set. Default is PAR');
        TmpCode = 'PAR';
    end
    Turbine.Code=TmpCode;
    %% Transform Alan's input_list to new structures:
    % Wind structure for TurbSim
    Wind.stdTI=setDefaultValue('Wind_stdTI',NaN); % if Wind_stdTI is specified in the spreadsheet it will be used instead of TIchar for TurbSim run
    Wind.IECType=setDefaultValue('Wind_IECType','NTM'); % NTM, ETM, EWM1, EWM50
    Wind.TIchar=setDefaultValue('Wind_TIchar','C');
    Wind.Shear= setDefaultValue('Wind_Shear',.14);
    Wind.TSExe= setDefaultValue('TurbSim_Name','TurbSim64.exe ');
    Wind.Path = [General.MainFolder 'Wind' filesep]; % ASSUME there is a folder called WIND in the main directory
    if ~exist(Wind.Path,'dir')
        mkdir(Wind.Path)
    end
    Wind.TSDir=[Wind.Path 'TurbSim' filesep]; % ASSUME there is a folder called TurbSim in the Wind directory    
    if ~exist(Wind.TSDir,'dir')
        mkdir(Wind.TSDir)
    end
    
    Wind.INPname=setDefaultValue('Wind_INPname','turbwindTemplate.inp');
    minTp= 1e-1; % Cannot have WaveTp or WavePeriod be 0 in OrcaFlex. 
    % WAVE
    Wave.Dir=setDefaultValue('Wave_Dir',0);
    Wave.Hs=setDefaultValue('Wave_Hs',0);
    Wave.Tp=setDefaultValue('Wave_Tp',minTp); % cannot have 0 Tp in OrcaFlex 
    Wave.Seed=setDefaultValue('Wave_Seed',0);
    if Wave.Seed
        Wave.Gamma=setDefaultValue('Wave_Gamma',2.4);
        Wave.SpectrumType=setDefaultValue('Wave_Spectrum','JONSWAP');
        Wave.SpectrumFile=setDefaultValue('Wave_Spectrum_File','');
    end   
    % SWELL
    Wave.Swell.Hs=setDefaultValue('Swell_Hs',0,' Secondary wave train only added if Swell_Hs>0.');
    if Wave.Swell.Hs
        Wave.Swell.Tp=setDefaultValue('Swell_Tp',minTp);
        Wave.Swell.Dir=setDefaultValue('Swell_Dir',0);
        Wave.Swell.Seed=setDefaultValue('Swell_Seed',0);
        if Wave.Swell.Seed
            Wave.Swell.Gamma=setDefaultValue('Swell_Gamma',1.0,' Spreading parameter Gamma unspecified for Swell waves. Setting Gamma=1: JONSWAP -> ISSC = P-M');
            Wave.Swell.SpectrumType=setDefaultValue('Swell_Spectrum','JONSWAP');
            Wave.Swell.SpectrumFile=setDefaultValue('Swell_Spectrum_File','');
        end
    else
        disp('Do not worry, a secondary wave train has NOT been added.')
    end
    % CURRENT
    Cur.Dir=setDefaultValue('Cur_Dir',Wind.Dir);
    Cur.Speed=setDefaultValue('Cur_Spd',Wind.Speed*0.03,' Setting current speed to 3% of wind speed, in line with wind direction.');
    % MOORING
    Ptfm.ML.Length=setDefaultValue('ML_Length',NaN);
    Ptfm.ML.Type=setDefaultValue('ML_Type',{});
    Ptfm.ML.PreT=setDefaultValue('ML_PreTension',NaN);
    Ptfm.ML.Name= setDefaultValue('ML_Name','ML');
    Ptfm.ML.BrName=setDefaultValue('Br_Name','Bridle');
    % ELECTRICAL CABLE
    Ptfm.EC.Name = setDefaultValue('EC_Name','EC');
    Ptfm.EC.BuoyName = setDefaultValue('EC_BuoyName','Buoy');
    % PLATFORM
    Ptfm.Orientation = setDefaultValue('Orientation',NaN); %change the platform orientation (absolute)
        % PLATFORM external forces
    % LOCAL
    Ptfm.LAL.X=setDefaultValue('LAL_X',zeros(1,3));
    Ptfm.LAL.F(1:6)=setDefaultValue('LAL_Mag',{nan}); % NOTE Loads are a 1x6 cell so that they can take strings if necessary!
    Ptfm.LAL.t = setDefaultValue('t_LAL',[NaN NaN]);
    Ptfm.GAL.X=setDefaultValue('GAL_X',zeros(1,3));
    Ptfm.GAL.F(1:6)=setDefaultValue('GAL_Mag',{nan});  % NOTE Loads are a 1x6 cell so that they can take strings if necessary!
    Ptfm.GAL.t = setDefaultValue('t_GAL',[NaN NaN]);
    Ptfm.BallastFlag=setDefaultValue('Ballast_Flag',0);
    % LINEAR DAMPING
    % BALLAST
    %% Apllied Moment to counteract thrust
    % get the 'anti-moment' on the platform as well as the tower drag
    if strcmp(Turbine.Code,'SDE') && ~Ptfm.iFAST
        disp('Found an OrcaFlex shutdown case, setting Ballast Flag to 2.')
        Ptfm.BallastFlag=2;
    end
    %[Ptfm,Turbine]=getBallastMomentAndTurbineDrag(Ptfm,Turbine,Wind);
    if ~isfield(Ptfm,'BallastW')
        Ptfm.BallastW=0;
    end
    % FLEXIBLE MODEL
    Ptfm.NonPtfmName = setDefaultValue('NonPtfmName','Col1 U'); % name of buoy that external forces/moments can be applied on
    Turbine.RNA.Name = setDefaultValue('RNA_Name','RNA');% name of buoy that external forces/moments can be applied on
    Turbine.Sensor.Name = setDefaultValue('Sensor_Name','');
    %% TURBINE
    Turbine.LineNames=setDefaultValue('Turbine.LineNames',{'Tower','blade','Blade'});
    Turbine.Yaw=setDefaultValue('Nacyaw',0);
    % Turbine inputs for TurbSim
    Turbine.Class=setDefaultValue('TurbineClass',1);
    Turbine.Tower.FAmult = setDefaultValue('Tower_FAmult',NaN);
    Turbine.Tower.SSmult = setDefaultValue('Tower_SSmult',NaN);
    %% Mooring (break)
    Ptfm.ML.BreakNum=setDefaultValue('MoorBreak_MLnumber',0);
    Ptfm.ML.BreakTime=setDefaultValue('MoorBreak_Time',0);
    %% GENERAL
    General.StartTime=setDefaultValue('StartTime',20.0); %email from Orcina :  in your original file it was only 0.001s. This means that the wave height will be ramped up from zero to the full specified height over only 0.001s. Such a rapid increase in hydrodynamic loading can cause transients, which can affect model convergence so I decided to increase the build-up period to try and reduce these transients. For a regular wave we would typically recommend that the build-up period was around one wave period in duration
    General.EndTime=setDefaultValue('RunTime',360.0);
    General.CutInTime=setDefaultValue('CutInTime',0.1*General.EndTime,'(using 10% of total run time)');
    General.CutOutTime=setDefaultValue('CutOutTime',General.EndTime,'(using total run time)');
    General.TimeOrigin=setDefaultValue('Time_Origin',0);
    General.TempDir=tempdir;
    General.SaveSim=setDefaultValue('Save_Sim',1);
    General.OutputFlag=setDefaultValue('Output_Flag',1,'(for outputs.mat time series)');
    General.OutputStatsFlag=setDefaultValue('OutputStats_Flag',1,'(for stats.mat time series)');
    General.iKeepWnd = setDefaultValue('iKeepWnd',0);
    if General.iFat && General.OutputFlag==1
        %General.RunFolder=['ForFatigue' filesep Date '_Runs' ]; %OVERWRITE RUNFOLDER for normal fatigue
    end

    %% Free-Decay & Force-Excursion
    General.DecayForceDOF = NaN; % defauly to not running a Decay-Force DOF
    if General.iFD || General.iFE 
        Runnum=str2double(regexp(General.RunName,['\d+\.?\d*'],'match')); % see getFDFERunList -> RunOF_BATCH for naming convention
        if sum(~isnan(Runnum))>1
            nDOF=Runnum(end-1);
            nIter=Runnum(end);
        elseif sum(~isnan(Runnum))==1
            nDOF=Runnum(1);
            nIter=1;
            if General.iFE
                iplus=General.RunName(end)=='+';
                imin=General.RunName(end)=='-';
                isign=-1*imin+ 1*iplus;
                if isign==0
                    error('Must using Runname convention of "FExcrn#_-" or "FExcrn#_+"to run Force Excursions')
                end
            end
        else
            error('Must using Runname convention of "FDecay#_#" to run Free-Decays')
        end
        try
            X_des=Ptfm.X_des(nIter,nDOF);
        catch
            error('Free-Decay naming system is weird. Check getFDFELDRunList -> RunOF_BATCH. Make sure X_des is set in RunOFipt.m')
        end
        PerX=[150 ; 150 ; 15 ; 30 ; 30 ; 150; 3]; % Approximate natural freq of modes (just used to estimate duration of sim); 7DOF = tower
        General.DecayForceDOF=nDOF;
        if nDOF<4 || nDOF==7
            General.DecayForceName='DecayForce';   
        else
            General.DecayForceName='DecayMoment';
        end
        maxTh=max(Turbine.ThrustTable(:,2)) ;
        if General.iFD 
            if nDOF<7
                disp('Running a Free-Decay Test')
                nPer=8;
                nrows=10; %ramp will be discretized in nrows-2 segments
                tramp=0; %time to start the ramp function
                tstart=100; %time to end the ramp function and start the constant fofce
                tstop=200;% constant until tstop-1, 0 at tstop 
                General.DecayForceTime =[linspace(tramp,tstart,nrows-2)'; tstop-1; tstop];
                approxF=Ptfm.K(nDOF)*X_des;
                General.DecayForce=[linspace(0,approxF,nrows-2)'; approxF; 0];
                General.CutInTime= tstop;
                disp(['Overwriting Cut-In time to be when force has stopped being applied at ' num2str(tstop) 's.'])
            else
                disp('Running a Hammer Test')
                nPer=25;
                tramp = 0;
                tstart=.1; %time to start the impulse function
                tstop=.3;% %time to end the impulse function
                General.DecayForceTime =[tramp; tstart;  tstop-.1; tstop];
                General.DecayForce=[0;maxTh;maxTh;0];
                General.CutInTime= 10; % needs some time to settle 
                disp(['Overwriting Cut-In time to be when force has stopped being applied at ' num2str(tstop) 's.'])
            end
        else
            disp('Running a Force-Excursion Test')
                Fs=F_des.*[maxTh maxTh Ptfm.K(3)*Ptfm.X_des(2,3)...
                Ptfm.K(4)*Ptfm.X_des(2,4) Ptfm.K(5)*Ptfm.X_des(2,5) 2*Ptfm.Col.Lh*maxTh/3];
            nPer=25;
            % applied force
            nSteps=6;
            dF=Fs(nDOF)/nSteps;
            tstop=0;
            tend=nPer*PerX(nDOF);
            dT=tend/nSteps;
            Ts=(repmat([dT dT],[nSteps 1]).*repmat([1:nSteps]',[1 2])+[zeros(nSteps,1) ones(nSteps,1)])';
            Fs=(repmat([dF dF],[nSteps 1]).*repmat([0:nSteps-1]',[1 2]))';
            Ts=Ts(:);
            stairT=[0;Ts(1:end-1)];
            stairF=isign*Fs(:);
            %nrows=100; %ramp will be discretized in nrows-2 segments 
            %rampvector=linspace(0,1,nrows-1)';
            General.DecayForceTime = stairT;%tend*[rampvector*.8; 1]; % constant until .8*tend
            General.DecayForce= stairF;%isign*[rampvector; 1]; 
        end
        General.EndTime= nPer*PerX(nDOF)+tstop;
        General.CutOutTime= General.EndTime;
        disp(['Overwriting RunTime to obtain approximately ' num2str(nPer) ' oscillations (equivalent to ' num2str(round(General.EndTime)) ') in this Free-Decay/Force Excursion.'])  
        Ptfm.GAL.F={0,0,0,0,0,0};
        if nDOF<7
            Ptfm.GAL.F{nDOF}=General.DecayForceName; % leverage existing infrastructure
        else
            Ptfm.GAL.F{nIter}=General.DecayForceName; % leverage existing infrastructure
        end
        Ptfm.GAL.X=Ptfm.COG; % COG from Excel file! I could also use the COG from the model...
    end 
    %% Create input File
    if General.RunFlag==2
         General.TempDir=rundir; %overwrite tempdir: you've already run the simulation, want to recreate opt and ipt     
    end
   
    %% Create everything you need for an OF Run
    disp(['Setting up Run: ' General.RunName])
    [Wind,Ptfm,Turbine]=PreOF(Ptfm,Wind,Wave,Cur,General,Turbine);
    %% Store all data in .ipt file so it could be rerun
     iptFile=GenerateIPTfromInputList(Ptfm,Wind,Wave,Cur,General,Turbine);
    if General.RunFlag==1
        %% Execute OF CODE
        disp(['Executing Run: ' General.RunName])
        iSuccess=ExecuteOF(General.TempDir,Ptfm.iFAST);
    else
        iSuccess=1;
    end
else
    General.RunName=Runname;
    General.OutputFlag=1; %if you're just post-processing then you want Outputs
    iSuccess=1;
end

if ~iSuccess
    General.OutputFlag=9999; %if the run has not been completed, set output flag to error code
else
    %% Generate inputs if run has not been setup 
    if length(varnames)<2 || ~General.RunFlag
        General.TempDir=rundir;
        iptFile=''; %does not get called in PostOF if tempdir==resultsdir
        if exist('TurbineName','var') && exist('PlatformName','var')
            [~,Wind,Wave,Cur,General,~]=generateInputListfromOPT([rundir General.RunPrefix Runname '.opt'],General,Ptfm,Turbine);
        else
            % grab Turbine and Ptfm from the opt file
            [Ptfm,Wind,Wave,Cur,General,Turbine]=generateInputListfromOPT([rundir General.RunPrefix Runname '.opt'],General);
        end
    end
end
%% POST-PROCESS Results
switch General.OutputFlag
    case 1      
%         if desAPIver~=latestofx        
%             newAPIpath=[baseAPIdir regexprep(endAPIdir,['\d+\.\d*'],sprintf('%1.1f',desAPIver))];
%             addpath(newAPIpath);
%             rmpath(APIpath)
%             APIpath=newAPIpath;
%         end
        %disp(['Post-Processing Run: ' General.RunName ' with OrcaFlex v' ofx.DLLVersion])
        [RunStatus,General]=PostOF(General.TempDir,rundir,iptFile,Ptfm,Turbine,Wind,Wave,Cur,General);
    case 2
        %RunStatus=PostOF_Flexible(tempdir,rundir,iptFile,Ptfm,Turbine,Wind,Wave,Cur,General);
        RunStatus=1;
    case 0
        RunStatus=0;
        disp('Output Flag set to 0, skipping post-process routine')
    case 9999
        RunStatus=0;
        disp('Run Failed, skipping post-process routine. Open OrcaFlex file for details.')
end
if RunStatus
    fclose all; %Just in case
    if ~strcmp(tempdir,rundir)
        try
            rmdir(tempdir,'s') %error with opening .sim due to FASTlinkDLL.dll why?!?
            disp('Post-Process was successful, removing temp directory')
        catch 
            disp('Post-Process was successful, but cannot remove temp directory')
        end
    else
        disp('Post-Process was successful, modified run directory')
    end
end
varargout{1}=RunStatus;
varargout{2}=General;
end


function outputdir=MakeTempDirName(maindir)
temp_i = 1;
outputdir = sprintf('TEMP%03d',temp_i);
while exist([maindir filesep outputdir],'dir')
    temp_i = temp_i + 1;
    outputdir = sprintf('TEMP%03d',temp_i);
end
outputdir=[maindir outputdir filesep];
mkdir(outputdir);
end

function OrcaDll=getOrcaDll(datfile)
OrcaDlls=rdir('C:\Program Files (x86)\Orcina\OrcaFlex\*\OrcFxAPI\Win32\**\*','strfind(name,''OrcFxAPI.dll'')');
if isempty(OrcaDlls)
    OrcaDlls=rdir('D:\Program Files (x86)\Orcina\OrcaFlex\*\OrcFxAPI\Win32\**\*','strfind(name,''OrcFxAPI.dll'')');
    if isempty(OrcaDlls)
        error('Where is your OrcFxAPI.dll? Should be on your C: drive')
    end
end
if length(OrcaDlls)>1
    if strfind(datfile,'Flexible')
        disp('You are running a flexible model, using Orca>10.0')
        i10=arrayfun(@(s) ~isempty(strfind(s.name,'10')),OrcaDlls);
        if sum(i10)>1
            OrcaDll=OrcaDlls(find(i10,1,'first')).name;
            disp(['More than 1 OrcaFlex version > 10.0 found. Using ' OrcaDll ])
        else
            OrcaDll=OrcaDlls(i10).name;
        end
    else
        i9=arrayfun(@(s) ~isempty(strfind(s.name,'9')),OrcaDlls);
        if sum(i9)>1
            OrcaDll=OrcaDlls(find(i9,1,'first')).name;
            disp(['More than 1 OrcaFlex version 9.* found. Using ' OrcaDll ])
        else
            OrcaDll=OrcaDlls(i9).name;
        end
    end
else
    OrcaDll=OrcaDlls.name;
end
end
