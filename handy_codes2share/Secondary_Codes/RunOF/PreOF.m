function [varargout]=PreOF(Ptfm,Wind,Wave,Cur,General,Turbine,varargin)
%datfile is location of OrcaFAST .dat file
%output dir is the name of temporary directory where a folder will be created with
% Turbine is a structure with:
% Turbine.Code = 'PAR' 'POW' 'SDE' 'SDN'
% Turbine.Name
% Turbine.Yaw=10; 
% Turbine.Weight; 
% Turbine.Tilt; 
% Turbine.Overhang; 
%Wind is a structure with:
% Wind.Dir = 30; (relative to wind direction)
% Wind.Speed = 28;
% Wind.Type = 1; %0 for steady, 1 for turbulent, 2+ for other stuff
% Wind.Seed = 'a'; %a-z correspond to 1-10, not used if 0 Wind_type, Names wind type (EDC, EOG, etc) otherwise.
%Wave is a structure with:
% Wave.Dir = 357;
% Wave.Hs = 8.52;
% Wave.Tp = 12.28;
% Wave.Seed = ceil(rand(1)*1000000); 0 = Single Airy, >0 = Jonswap
%Cur is a structure with:
% Cur.Dir = 0;
% Cur.Speed = 1;
%General is a structure with:
% General.StartTime = -60; some transient time
% General.EndTime = 3600; 1 hr
% General.TempDir=
%varargout{1}= outputdir
datfile=Ptfm.datfile;
%[datfilepath, datfilename] = fileparts(datfile);
%slashes=strfind(datfilepath,filesep);
maindir = General.MainFolder; %datfilepath(1:slashes(end)); % assume that the working directory is one level above where the dat file is
%% Generate inputs if unspecified:
% if nargin<3
%     if nargin==1
%         [outputdir]=GetBoringDirName(maindir); 
%         mkdir(outputdir); % a TEMP### folder will be created
%     end
%     runname=GetBoringRunName(outputdir);
% end
% if nargin<2
%     Ptfm.HeelX=0;
%     Ptfm.HeelY=0;
% end
if nargin<5
    Turbine.Code='PAR'; % assume turbine in parked
    Turbine.Yaw=0; % assume turbine in aligned
    warning('Turbine is Parked')   
    if ~isfield(Turbine,'Name')
        namestr=dir([maindir 'Input_FAST' filesep '*_aero.ipt']);
        if isempty(namestr)
            error('Must have a FAST input file named *_aero.ipt')
        end
        turbinename=namestr.name;
        iname=strfind(turbinename,'_aero.ipt');
        Turbine.Name=turbinename(1:iname-1);
        Turbine.AltName=Turbine.Name;
    end
end
if nargin<4
    [Wind,Wave,Cur,General]=CreateBoringRun(); % everything is set to 0
    warning('Environment is set to null');
end

%% Grab the Orca model
Model = ofxModel(datfile);
% What if there is no vessel?!?!
[WindFloat,WindFloatType]=getWindFloatModel(Model);
%% LINES/SPRINGS
mod_obj = Model.objects;
iLines=strcmp(cellfun(@(x) x.typeName, mod_obj, 'UniformOutput', false),'Line');
iBuoys=strcmp(cellfun(@(x) x.typeName, mod_obj, 'UniformOutput', false),'6D Buoy');
i3DBuoys=strcmp(cellfun(@(x) x.typeName, mod_obj, 'UniformOutput', false),'3D Buoy');

Mod.lines = mod_obj(iLines); % cellfun(@(obj) isa(obj,'ofxLineObject'), mod_obj) Grab all LinesObjects
Mod.buoys= mod_obj(iBuoys);
Mod.ThreeDbuoys= mod_obj(i3DBuoys);
% Break down the mooring with Bridles
Ptfm.ML.OrcaBridle={};
Ptfm.nBr=0;
Ptfm.EC.OrcaBuoy={};
Ptfm.nEC=0;
for jj=1:length(Mod.buoys)
    jB=Mod.buoys{jj};
    jLName=jB.Name;
    iBr=strfind(jLName,Ptfm.ML.BrName);
    if ~isempty(iBr) 
        Ptfm.nBr=Ptfm.nBr+1;
        Ptfm.ML.OrcaBridle{Ptfm.nBr}=jB;
    end
    iBuoy = strfind(jLName,Ptfm.EC.BuoyName);
    if ~isempty(iBuoy) 
        Ptfm.nEC=Ptfm.nEC+1;
        Ptfm.EC.OrcaBuoy{Ptfm.nEC}=jB;
    end
end
% check for 3D buoys
for jj=1:length(Mod.ThreeDbuoys)
    jB=Mod.ThreeDbuoys{jj};
    jLName=jB.Name;
    iBuoy = strfind(jLName,Ptfm.EC.BuoyName);
    if ~isempty(iBuoy) 
        Ptfm.nEC=Ptfm.nEC+1;
        Ptfm.EC.OrcaBuoy{Ptfm.nEC}=jB;
    end
end

% Break down the lines into: Mooring, Turbine/Tower, Everything Else
Ptfm.nML=0; Ptfm.nAn=0; Ptfm.nFl=0;  Ptfm.nBrL=0; Ptfm.nWFL=0; Turbine.nTL=0; Ptfm.nEC=0; Ptfm.EC.nAn=0; Ptfm.EC.nPtfm=0; Ptfm.EC.nBuoy=0;
for jj=1:length(Mod.lines)
    jL=Mod.lines{jj};
    jLName=jL.Name;
    iML=strfind(jLName,Ptfm.ML.Name);
    iTL=any(strncmp(jLName,Turbine.LineNames,min(cellfun(@(c) length(c),Turbine.LineNames)))); %any reason you would have a 
    iEC = strfind(jLName,Ptfm.EC.Name);
    if ~isempty(iML)
        Ptfm.nML=Ptfm.nML+1;
        Ptfm.ML.OrcaLine{Ptfm.nML}=jL;
        ConnectA=jL.EndAConnection;
        ConnectB=jL.EndBConnection;
        if strcmp(ConnectB,'Anchored')
            Ptfm.nAn=Ptfm.nAn+1;
            Ptfm.ML.AnchorLine{Ptfm.nAn}=jL;
        end
        if strcmp(ConnectA,'Platform') && ~strcmp(ConnectB,'Platform')
            % it belongs to a mooring line connected to the
            % platform/fairlead
            Ptfm.nFl=Ptfm.nFl+1;
            Ptfm.ML.FairleadLine{Ptfm.nFl}=jL;
        end        
        if strfind(ConnectB,Ptfm.ML.BrName)
            Ptfm.nBrL=Ptfm.nBrL+1;
            Ptfm.ML.BridleLine{Ptfm.nBrL}=jL;
        end
    elseif ~isempty(iEC)
        Ptfm.nEC=Ptfm.nEC+1;
        Ptfm.EC.OrcaLine{Ptfm.nEC}=jL;
        ConnectA=jL.EndAConnection;
        ConnectB=jL.EndBConnection;
        if strcmp(ConnectB,'Anchored')
            Ptfm.EC.nAn=Ptfm.EC.nAn+1; % number of EC lines anchored to seafloor
            Ptfm.EC.AnchorLine{Ptfm.EC.nAn}=jL;
        end
        if strcmp(ConnectA,'Platform') && ~strcmp(ConnectB,'Platform')
            % it belongs to a cable line connected to the
            % platform
            Ptfm.EC.nPtfm=Ptfm.EC.nPtfm+1;
            Ptfm.EC.PtfmLine{Ptfm.EC.nPtfm}=jL;
        end        
        if strfind(ConnectB,Ptfm.ML.BrName)
            Ptfm.EC.nBuoy=Ptfm.EC.nBuoy+1;
            Ptfm.EC.BuoyLine{Ptfm.EC.nBuoy}=jL;
        end    
        %jMLnum=str2double( Ptfm.ML.OrcaName(strfind(jMLname,Ptfm.ML.Name)+length(Ptfm.ML.Name):end) ); 
    elseif iTL
        %it belongs to a line that represents the turbine
        Turbine.nTL=Turbine.nTL+1;
        Turbine.OrcaLine{Turbine.nTL}=jL;
    else
        %it belongs to a line that represents the platform
        Ptfm.nWFL=Ptfm.nWFL+1;
        Ptfm.OrcaLine{Ptfm.nWFL}=jL;
    end
end
Mod.links = mod_obj(cellfun(@(obj) obj.type==10, mod_obj)); %Grab all Links
%% Determine OrcaFAST or OrcaFlex
% determine what the datfile is set as

if ~isempty(WindFloat)
    PMstr=WindFloat.PrimaryMotion;
    if strcmp(PMstr,'Externally Calculated')
        FAST_default=1;
        FASTtype=WindFloatType.name;
        Orcatype=FASTtype(1:end-5);
        try 
            RealWindFloatType=Model(Orcatype);
            disp('Found OrcaFlex vessel type. Overwriting hydrostatic stiffness terms used in calculation of external loads for FDecay and FExcrn runs ONLY.')
            Kzz=WindFloatType.HydrostaticStiffnessz;
            Kzx=WindFloatType.HydrostaticStiffnessRx;
            Kzy=WindFloatType.HydrostaticStiffnessRy;
            Ptfm.K(3:5)=[Kzz(1) Kzx(2) Kzy(3)]; 
            G=[WindFloatType.CentreOfGravityX WindFloatType.CentreOfGravityY WindFloatType.CentreOfGravityZ]; 
        catch
            G=Ptfm.COG;
            warning('Orcaflex vessel type does not exist in model. Please create one to record stiffness properly')
        end
    elseif strcmp(PMstr,'Calculated (6 DOF)')
        FAST_default=0;
        disp('Found OrcaFlex vessel type. Overwriting hydrostatic stiffness terms used in calculation of external loads for FDecay and FExcrn runs ONLY.')
        Kzz=WindFloatType.HydrostaticStiffnessz;
        Kzx=WindFloatType.HydrostaticStiffnessRx;
        Kzy=WindFloatType.HydrostaticStiffnessRy;
        Ptfm.K(3:5)=[Kzz(1) Kzx(2) Kzy(3)]; 
        G=[WindFloatType.CentreOfGravityX WindFloatType.CentreOfGravityY WindFloatType.CentreOfGravityZ]; 
    elseif strcmp(PMstr,'None')
        FAST_default=0;
    else
        FAST_default=0;
        warning('Not sure what type of simulation you are trying to run. Settin FAST_default 0 for OrcaFlex.')
    end
else
    FAST_default=0; %if there is no vessel, then you are running OrcaFlex
end
   
%% OrcaFlex Vessel <-----> OrcaFAST Vessel
if Ptfm.iFAST ~= FAST_default
    WindFloat=ChangeOF(WindFloat,WindFloatType,Turbine.OrcaLine,Turbine.LineNames,Ptfm.iFAST);
    [WindFloat,WindFloatType]=getWindFloatModel(Model); %update WindFloatType
end
%% Set Linear Damping of Vessel 
if isfield(Ptfm,'LinDampingX') && General.iLD
    oldLDx=WindFloatType.OtherDampingLinearCoeffx;
    if oldLDx~=Ptfm.LinDampingX(1)
        disp(sprintf('New Linear Damping Value in X found. Changing value to %1.3e',Ptfm.LinDampingX(1)))
        WindFloatType.OtherDampingLinearCoeffx=Ptfm.LinDampingX(1);
    end
    oldLDy=WindFloatType.OtherDampingLinearCoeffy;
    if oldLDy~=Ptfm.LinDampingX(2)
        disp(sprintf('New Linear Damping Value in Y found. Changing value to %1.3e',Ptfm.LinDampingX(2)))
        WindFloatType.OtherDampingLinearCoeffy=Ptfm.LinDampingX(2);
    end
    oldLDz=WindFloatType.OtherDampingLinearCoeffz;
    if oldLDz~=Ptfm.LinDampingX(3)
        disp(sprintf('New Linear Damping Value in 3 found. Changing value to %1.3e',Ptfm.LinDampingX(3)))
        WindFloatType.OtherDampingLinearCoeffz=Ptfm.LinDampingX(3);
    end
end
if isfield(Ptfm,'LinDampingRx') && General.iLD
    oldLDRx=WindFloatType.OtherDampingLinearCoeffRx;
    if oldLDRx~=Ptfm.LinDampingRx(1)
        disp(sprintf('New Linear Damping Value in Rx found. Changing value to %1.3e',Ptfm.LinDampingRx(1)))
        WindFloatType.OtherDampingLinearCoeffRx=Ptfm.LinDampingRx(1);
    end
    oldLDRy=WindFloatType.OtherDampingLinearCoeffRy;
    if oldLDRy~=Ptfm.LinDampingRx(2)
        disp(sprintf('New Linear Damping Value in Y found. Changing value to %1.3e',Ptfm.LinDampingRx(2)))
        WindFloatType.OtherDampingLinearCoeffRy=Ptfm.LinDampingRx(2);
    end
    oldLDRz=WindFloatType.OtherDampingLinearCoeffRz;
    if oldLDRz~=Ptfm.LinDampingRx(3)
        disp(sprintf('New Linear Damping Value in 3 found. Changing value to %1.3e',Ptfm.LinDampingRx(3)))
        WindFloatType.OtherDampingLinearCoeffRz=Ptfm.LinDampingRx(3);
    end
end
%% Environment
Environment = Model('Environment');
    %% Get Data from .dat if left unset
    if isnan(Wind.Speed)
        Wind.Speed = Environment.WindSpeed;
        Wind.Dir = Environment.WindDirection;
    end
    %% Drag on Turbine + Ballast Moment
    [Ptfm,Turbine]=getBallastMomentAndTurbineDrag(Ptfm,Turbine,Wind);
    %% WIND for FAST
    if Ptfm.iFAST
        Wind=getWindFile(Wind,General); % get the name of the .wnd or .hh file or sum (see subfunction for logic)
    end
Environment=putWindWaveCur(Wind,Wave,Cur,Ptfm,Environment);
%% TIME
GenModel=Model('General');
GenModel.NumberOfStages=1;
GenModel.StageDuration(1)=General.StartTime; %
SimEndTime=General.EndTime-General.StartTime+GenModel.ActualLogSampleInterval; %(have to include an extra time step due to FAST/Orca interface)
if Ptfm.ML.BreakNum
    if Ptfm.ML.BreakTime> SimEndTime
       error('Your mooring line breaks after the simulation is over. Please modify') 
    end
    GenModel.NumberOfStages=2;
    GenModel.StageDuration(2)= Ptfm.ML.BreakTime; 
    GenModel.StageDuration(3)= SimEndTime-Ptfm.ML.BreakTime; 
else
    GenModel.StageDuration(2)=SimEndTime;% Update the duration of stage 1
end
Environment.SimulationTimeOrigin = General.TimeOrigin; % just in case you want to make things more complicated...

%% North Heading
% only used for visualization purposes- has no effect on the actual
% simulation
if General.OFver<10
    if Ptfm.iFAST
        GenModel.NorthDirection=-Wind.Dir;
    else
        GenModel.NorthDirection=0;
    end
end
%% WindFloat Heading
Ptfm.iChangeHeading=0;
if ~isempty(WindFloat)
    Ptfm.OldHeading=WindFloat.InitialHeading; % equivalent to Rotation3 for a vessel
else
    %how do we get the current orientation from the flexible model?
    Ptfm.OldHeading=0;
end  
if ~isnan(Ptfm.Orientation)
    if Ptfm.Orientation~=Ptfm.OldHeading
        Ptfm.iChangeHeading=1;
    end
    if Ptfm.iFAST
        %in FAST the coordinate system is defined relative to the wind
        %direction
        Ptfm.OrcaHeading = Ptfm.Orientation-Wind.Dir; % the heading in the FAST coordinate system of the platform
    else
        Ptfm.OrcaHeading = Ptfm.Orientation;
    end
else
    % don't change anything, everything is kosher - only have to modify if
    % running FAST
    if ~isempty(WindFloat)
        if Ptfm.iFAST
            Ptfm.OrcaHeading=Ptfm.OldHeading-Wind.Dir;  %rotate the platform due to no directional functionality in FAST
        else
            Ptfm.OrcaHeading=Ptfm.OldHeading; 
        end
    end  
end
%% ROTATE PLATFORM
if Ptfm.iChangeHeading || Ptfm.iFAST
    if ~isempty(WindFloat)
        WindFloat.InitialHeading=Ptfm.OrcaHeading; % this will get overwritten by FAST if running OrcaFAST. Change it just to have consistency between .dat and .sim
    else
        %how to rotate the flexible model? Go through the buoys?
    end
end

%% ROTATE MOORING LINES
if Ptfm.iChangeHeading || Ptfm.iFAST
    % you are running FAST or you are looking at a different heading
    %rotate the mooring lines
    %its a relative rotation, must taken into account original position of
    %mooring lines -> take from 
    rotateLines(Ptfm.ML.AnchorLine,Ptfm.ML.OrcaBridle,Ptfm.OrcaHeading-Ptfm.OldHeading); %Ptfm.ML.OrcaLine,
    if Ptfm.nBr>0
        rotateLines(Ptfm.ML.BridleLine,[],Ptfm.OrcaHeading-Ptfm.OldHeading+360*4); % use >360 to signal flag (not to rotate)
    end
    % Do I want to do anything with the other lines? Like in the flexible
    % model, for instance.
    %% ROTATE EC LINES
    if Ptfm.nEC>0
        rotateLines(Ptfm.EC.AnchorLine,Ptfm.EC.OrcaBuoy,Ptfm.OrcaHeading-Ptfm.OldHeading); %Ptfm.ML.OrcaLine,
        if Ptfm.nBr>0
            rotateLines(Ptfm.EC.BuoyLine,[],Ptfm.OrcaHeading-Ptfm.OldHeading+360*4); % use >360 to signal flag (not to rotate)
        end
    end
end


%% ROTATE RNA+Blades LINES
try
    RNA=Model(Turbine.RNA.Name);
    % upwind-yaw controller! 
catch
    %do I want to apply it 
    warning(['6D buoy named " ' Turbine.RNA.Name '" not found in model. Not applying thrust force'])
end

if Ptfm.iFAST
    %move the tower/turbine lines back (since they are defined relative to the platform and will rotate with the platform) 
    modelRNAheading=-Ptfm.OrcaHeading+Turbine.Yaw-Ptfm.OldHeading;
    rotateLines(Turbine.OrcaLine,[],modelRNAheading); % this may be wrong, due to the intial position of the turbine lines (defined by original wind direction)...
else
    % in OrcaFlex, the lines will rotate with along with the platform
    modelRNAheading=-Ptfm.OrcaHeading+Wind.Dir+Turbine.Yaw-Ptfm.OldHeading;
    rotateLines(Turbine.OrcaLine,[],modelRNAheading);
end
if Wind.Speed && exist('RNA','var')
    disp('Found RNA buoy, changing yaw position assuming upwind turbine')
    RNA.InitialRotation3=mod(modelRNAheading,360);
end
%% Set Decay Force on Model
if General.iFD || General.iFE || General.iLD
    setFakeForceValue(Model,General.DecayForceName,[General.DecayForceTime General.DecayForce],General.DecayForceDOF);
end
%% Thrust force for OrcaFlex Model
if isstr(Ptfm.LAL.F{1})
    [LALdir,fname,fext]=fileparts(Ptfm.LAL.F{1}); % needed to determine what kind of string the LAL is: could be force name, number of filename
else
    LALdir='';
end
if General.DecayForceDOF==7
    if exist('RNA','var')
        nLAL_RNA=RNA.NumberOfLocalAppliedLoads;
        XRNA=getAbsXinOF(Model,Turbine.RNA.Name); %  [RNA.InitialX RNA.InitialY RNA.InitialZ];
        RNA.NumberOfLocalAppliedLoads=nLAL_RNA+1;  
                       % Hammer Test
        RNA.LocalAppliedForceX(nLAL_RNA+1)=Ptfm.GAL.F{1};
        RNA.LocalAppliedForceY(nLAL_RNA+1)=Ptfm.GAL.F{2}; 
    else
        warning('Hammer Test being applied to platform..')
    end
end
if ~Ptfm.iFAST && (Wind.Speed>0)
    HH=getThrust(Wind,Turbine,General);
    disp('Running OrcaFlex with non-zero wind-speed. Setting thrust force on RNA.')
    setFakeForceValue(Model,'ThrustF-X',[HH.t HH.thrust(:,1)],1); 
    setFakeForceValue(Model,'ThrustF-Y',[HH.t HH.thrust(:,2)],2); %always 0 for Orca-flex with 'yaw-controller'
    
        % want the local x-direction pointing downwind wind
%         if ~isempty(WindFloat)
%             WFheading=WindFloat.InitialHeading;
%         else
%             if ~isnan(Ptfm.Orientation)
%                 WFheading=Ptfm.Orientation;
%             else
%                 WFheading=0; %no other information to go on..
%             end
%         end        
    if exist('RNA','var')        
        nLAL_RNA=RNA.NumberOfLocalAppliedLoads;
        XRNA=getAbsXinOF(Model,Turbine.RNA.Name); %  [RNA.InitialX RNA.InitialY RNA.InitialZ];
        RNA.NumberOfLocalAppliedLoads=nLAL_RNA+1;      
        RNA.LocalAppliedLoadOriginX(nLAL_RNA+1)=Turbine.RNA.COP(1)-XRNA(1); % here we assume that the RNA coordinate system is absolute (even though its relative to the Vessel, which is at (0,0,0) anyways
        RNA.LocalAppliedLoadOriginY(nLAL_RNA+1)=Turbine.RNA.COP(2)-XRNA(2);
        RNA.LocalAppliedLoadOriginZ(nLAL_RNA+1)=Turbine.RNA.COP(3)-XRNA(3);
        
        if ~isempty(LALdir)
            Res=load(Ptfm.LAL.F{1}); % load outputs.mat
            if isfield(Res,Turbine.Sensor.Name)
                Load = Res.(Turbine.Sensor.Name);
                if SimEndTime>max(Res.time)
                    error('The simulation you are trying to load is shorter than the current sim')
                end
                [nLt,nLd] =size(Load); 
                for dd=1:nLd
                    if nLt>5000
                        newTime= transpose(linspace(0,SimEndTime,1000));
                        LoadT= interp1(Res.time,Load(:,dd),newTime);
                        Fdata=[newTime LoadT];
                    else
                        Fdata=[Res.time Load(:,dd)];
                    end
                     % ramp the external force so that the weight is not a shock to the model
                    if sum(~isnan(Ptfm.LAL.t))>0
                        Framp = interp1([Ptfm.LAL.t(1),Ptfm.LAL.t(2) Fdata(end,1)],[0 1 1],Fdata(:,1));
                    else
                        Framp = ones(length(Fdata(:,1)),1);
                    end
                    Fdata(:,2) = Framp.*Fdata(:,2);
                    % over Ptfm.LAL.F
                    Fname=[Turbine.Sensor.Name num2str(dd)];
                    Ptfm.LAL.F{dd}=Fname;
                    setFakeForceValue(Model,Fname,Fdata,dd);
                end
                RNA.LocalAppliedForceX(nLAL_RNA+1)=Ptfm.LAL.F{1};
                RNA.LocalAppliedForceY(nLAL_RNA+1)=Ptfm.LAL.F{2};   
                RNA.LocalAppliedForceZ(nLAL_RNA+1)=Ptfm.LAL.F{3}; 
                if nLd>3
                    RNA.LocalAppliedMomentX(nLAL_RNA+1)=Ptfm.LAL.F{4};
                    RNA.LocalAppliedMomentY(nLAL_RNA+1)=Ptfm.LAL.F{5};   
                    RNA.LocalAppliedMomentZ(nLAL_RNA+1)=Ptfm.LAL.F{6}; 
                end
            else
                error([Turbine.Sensor.Name ' does not exist in ' Ptfm.LAL.F{1}])
            end
        else
            if Wind.Speed
                RNA.LocalAppliedForceX(nLAL_RNA+1)='ThrustF-X';
                RNA.LocalAppliedForceY(nLAL_RNA+1)='ThrustF-Y';
            %elseif General.DecayForceDOF==7

            end
        end
    end
end

%% Mooring (break)
if Ptfm.ML.BreakNum
   MLstr=sprintf( '%s%d', Ptfm.ML.Name, Ptfm.ML.BreakNum ) ;
   try
       ML2break=Model( MLstr );
   catch
       error(['A line named ' MLstr ' is not in the model, please add one if you want to break it'])
   end
   ML2break.EndAReleaseStage=2; % Assume that EndA is attached to the platform!
end
%% Mooring (Do some optimization...)
% take into account Ptfm.ML.Length or Ptfm.ML.PreT
if ~isnan(Ptfm.ML.Length)
    [rL,cL]=size(Ptfm.ML.Length);
    if rL==1
        Ptfm.ML.LengthMat=repmat(Ptfm.ML.Length,[Ptfm.nML 1]);
    else
        Ptfm.ML.LengthMat=Ptfm.ML.Length;
    end
    for ii=1:Ptfm.nML
        SecLength=Ptfm.ML.LengthMat(ii,:);
        SecLength=SecLength(~isnan(SecLength));
        nSec=length(SecLength);
        MLstr=sprintf( '%s%d', Ptfm.ML.Name, ii ) ;
        iML=Model(MLstr);
        nSecModel=iML.NumberOfSections;
        if nSec~=nSecModel
           error('Please define the ML_Length vector/matrix to have same number of columns as the number of sections in your OrcaModel')
        else
            for pp=1:nSecModel
                iML.Length(pp)=SecLength(pp);
            end
        end      
    end
end
if ~isempty(Ptfm.ML.Type)
    [rT,cT]=size(Ptfm.ML.Type);
    if rT==1
        Ptfm.ML.TypeMat=repmat(Ptfm.ML.Type,[Ptfm.nML 1]);
    else
        Ptfm.ML.TypehMat=Ptfm.ML.Type;
    end
    for ii=1:Ptfm.nML
        MLstr=sprintf( '%s%d', Ptfm.ML.Name, ii ) ;
        iML=Model(MLstr); 
        SecType=Ptfm.ML.TypeMat(ii,:);
        nSecModel=iML.NumberOfSections;
        if cT~=nSecModel
           error('Please define the ML_Length vector/matrix to have same number of columns as the number of sections in your OrcaModel')
        else
            for pp=1:nSecModel
                iML.LineType(pp)=SecType{pp};
            end
        end
    end
end
%% Last thing to do to mooring is set Pre-Tension
if ~isnan(Ptfm.ML.PreT)
    if length(Ptfm.ML.PreT)< Ptfm.nML
       Ptfm.ML.PreT=repmat(Ptfm.ML.PreT(1),[1 Ptfm.nML]); 
    end
    WindFloat.IncludedInStatics='None';
    InvokeLineSetupWizard(Model);
    for ii=1:Ptfm.nML
        MLstr=sprintf( '%s%d', Ptfm.ML.Name, ii ) ;
        iML=Model(MLstr);
        iML.LineSetupTargetValue = Ptfm.ML.PreT(ii);
    end
    disp('Invoking Line Setup Wizard..')
    Model.InvokeLineSetupWizard()
    WindFloat.IncludedInStatics='6 DOF';
end
%% Local Applied Forces (could be a ballast moment if BallastFlag==0)
if ~isempty(WindFloat)
    nLAL_WF=WindFloat.NumberOfLocalAppliedLoads;
else
    % where do I want to apply the load on the flexible model?
    nLAL_WF=0; % needs to be set for applyAntiThrust
end

if isempty(LALdir)
    if sum(~isnan(Ptfm.LAL.t))>0 && sum(isnan([Ptfm.LAL.F{:}])) <6
        nrows=3; %ramp will be discretized in nrows-2 segments
        tramp=Ptfm.LAL.t(1); %time to start the ramp function
        tstart=Ptfm.LAL.t(2); %time to end the ramp function and start the constant force
        nDOF=find([Ptfm.LAL.F{:}]); % only works for 1-D force
        if ~isempty(nDOF)
            maxF=Ptfm.LAL.F{nDOF};
            General.DecayForceTime =[linspace(tramp,tstart,nrows)'; General.EndTime];
            General.DecayForce=[linspace(0,maxF,nrows)'; maxF];
            General.DecayForceName = 'External Load';
            setFakeForceValue(Model,General.DecayForceName,[General.DecayForceTime General.DecayForce],nDOF);
            Ptfm.LAL.F{nDOF}=General.DecayForceName;
        end
    end
    if ~isnan(Ptfm.LAL.F{1})
             WindFloat.NumberOfLocalAppliedLoads=nLAL_WF+1;
        %static_heel_rot=Rotate2DMat([Ptfm.LMx Ptfm.LMy],Wind.Dir*pi()/180); Concept: rotate moments due to wind direction and then apply locally.
            WindFloat.LocalAppliedLoadOriginX(nLAL_WF+1)=Ptfm.LAL.X(1); %WindFloatType.CentreofGravityX
            WindFloat.LocalAppliedLoadOriginY(nLAL_WF+1)=Ptfm.LAL.X(2);
            WindFloat.LocalAppliedLoadOriginZ(nLAL_WF+1)=Ptfm.LAL.X(3);
            WindFloat.LocalAppliedForceX(nLAL_WF+1) = Ptfm.LAL.F{1};
            WindFloat.LocalAppliedForceY(nLAL_WF+1) = Ptfm.LAL.F{2};
            WindFloat.LocalAppliedForceZ(nLAL_WF+1) = Ptfm.LAL.F{3};
            WindFloat.LocalAppliedMomentX(nLAL_WF+1) = Ptfm.LAL.F{4};
            WindFloat.LocalAppliedMomentY(nLAL_WF+1) = Ptfm.LAL.F{5};
            WindFloat.LocalAppliedMomentZ(nLAL_WF+1) = Ptfm.LAL.F{6};
    end
end
%% Ballast
% fake ballast controller during fatigue
if Ptfm.BallastFlag==2 && Wind.Speed>0
    if Wind.Speed > Turbine.CutIn || Wind.Speed < Turbine.CutOut
        disp('Applying "ballast-induced" local moment on platform, equivalent to cross-product of turbine hub height and anti-thrust force')
    else
         disp('Applying moment on platform, equivalent to drag on tower. Drag on blades currently not taken into account in ballast calculation.')
    end
    applyAntiThrust(Model,WindFloat,Ptfm,nLAL_WF);
end
%% Global Applied Forces (could be a ballast moment if BallastFlag==0)
if sum(~isnan(Ptfm.GAL.t))>0
        nrows=3; %ramp will be discretized in nrows-2 segments
        tramp=Ptfm.GAL.t(1); %time to start the ramp function
        tstart=Ptfm.GAL.t(2); %time to end the ramp function and start the constant force
        nDOF=find([Ptfm.GAL.F{:}]); % only works for 1-D force
        if ~isempty(nDOF)
            maxF=Ptfm.GAL.F{nDOF};
            General.DecayForceTime =[linspace(tramp,tstart,nrows)'; General.EndTime];
            General.DecayForce=[linspace(0,maxF,nrows)'; maxF];
            General.DecayForceName = 'External Load';
            setFakeForceValue(Model,General.DecayForceName,[General.DecayForceTime General.DecayForce],nDOF);
            Ptfm.GAL.F{nDOF}=General.DecayForceName;
        end
end

if ~sum(isnan(Ptfm.GAL.F{1})) && (General.DecayForceDOF<7 || isnan(General.DecayForceDOF))
    if isempty(WindFloat)
        WFBuoy=Model(Ptfm.NonPtfmName);
        nGAL=WFBuoy.NumberOfGlobalAppliedLoads;
        WFBuoy.NumberOfGlobalAppliedLoads=nGAL+1;
        %static_heel_rot=Rotate2DMat([Ptfm.LMx Ptfm.LMy],Wind.Dir*pi()/180); Concept: rotate moments due to wind direction and then apply locally.

        WFBuoy.GlobalAppliedLoadOriginX(nGAL+1)=Ptfm.GAL.X(1); %WFBuoyType.CentreofGravityX
        WFBuoy.GlobalAppliedLoadOriginY(nGAL+1)=Ptfm.GAL.X(2);
        WFBuoy.GlobalAppliedLoadOriginZ(nGAL+1)=Ptfm.GAL.X(3);
        WFBuoy.GlobalAppliedForceX(nGAL+1) = Ptfm.GAL.F{1};
        WFBuoy.GlobalAppliedForceY(nGAL+1) = Ptfm.GAL.F{2};
        WFBuoy.GlobalAppliedForceZ(nGAL+1) = Ptfm.GAL.F{3};
        WFBuoy.GlobalAppliedMomentX(nGAL+1) = Ptfm.GAL.F{4};
        WFBuoy.GlobalAppliedMomentY(nGAL+1) = Ptfm.GAL.F{5};
        WFBuoy.GlobalAppliedMomentZ(nGAL+1) = Ptfm.GAL.F{6};
    else
        nGAL=WindFloat.NumberOfGlobalAppliedLoads;
        WindFloat.NumberOfGlobalAppliedLoads=nGAL+1;
        %static_heel_rot=Rotate2DMat([Ptfm.LMx Ptfm.LMy],Wind.Dir*pi()/180); Concept: rotate moments due to wind direction and then apply locally.

        WindFloat.GlobalAppliedLoadOriginX(nGAL+1)=Ptfm.GAL.X(1); %WindFloatType.CentreofGravityX
        WindFloat.GlobalAppliedLoadOriginY(nGAL+1)=Ptfm.GAL.X(2);
        WindFloat.GlobalAppliedLoadOriginZ(nGAL+1)=Ptfm.GAL.X(3);
        WindFloat.GlobalAppliedForceX(nGAL+1) = Ptfm.GAL.F{1};
        WindFloat.GlobalAppliedForceY(nGAL+1) = Ptfm.GAL.F{2};
        WindFloat.GlobalAppliedForceZ(nGAL+1) = Ptfm.GAL.F{3};
        WindFloat.GlobalAppliedMomentX(nGAL+1) = Ptfm.GAL.F{4};
        WindFloat.GlobalAppliedMomentY(nGAL+1) = Ptfm.GAL.F{5};
        WindFloat.GlobalAppliedMomentZ(nGAL+1) = Ptfm.GAL.F{6};
    end
end


%% Save new OF model as primary.dat
Model.SaveData([General.TempDir 'primary.dat']); % have to save the model within the same function?!?! 

if Ptfm.iFAST
    % Find .hh or .wnd file or runTurbSim if file not found
    %Wind.FileAbs=[Wind.Path,Wind.File]; %file fould .wnd .hh or .sum
    if Wind.Speed
        if round(Wind.Speed)==0
            warning('Running FAST with a wind speed that rounds to 0. Setting to 1 m/s instead.')
            Wind.Speed=1;
        end
        if ~exist(Wind.File,'file')
            if ~exist(Wind.AltFile,'file')
                disp(['TurbSim hh or wnd file: ' Wind.File ' not found. Running TurbSim from turbwindTemplate.inp using current Wind and Turbine parameters.'])
                if ~exist([Wind.TSDir Wind.TSExe],'file')
                    error(['Please put ' Wind.TSExe 'into you TurbSim folder located at: ' Wind.TSDir ])
                end
                if ~isempty(Wind.Grid)
                    % Generate Wind File automatically!!
                    Wind.File = runTurbSim(General.EndTime+General.StartTime,Wind,Turbine);
                else
                    error('Must specify Grid Size in DLC spreadsheet to run TurbSim')
                end
            else
                Wind.File=Wind.AltFile;
                if isfield(Wind,'Filesum')
                    Wind.Filesum = [Wind.AltFile(1:end-4) '.sum'];
                end
            end
        end
    else
        % you are trying to run identically 0 m/s
        %Wind.File = Steady wind 
    end
    %% Extend HH File (if necessary)
    if strcmp(Wind.FileExt,'.hh')
       if General.EndTime>9999
          extendHH(Wind.File); %function to rewrite .hh file if it has stars due to TurbSim 
       end
    end
%% Create Folder for all of the files
    fillRunFolder(maindir,General.TempDir,Ptfm,Wind,Turbine);
%% Rewrite .fst and _ptfm.ipt and  _aero.ipt and tower ipt inside of the temp folder
    [Aerofilename,Twrfilename,Ptfmfilename]=rewriteFST(maindir,General.TempDir,Turbine,Ptfm,General);
    rewritePtfm(General.TempDir,Ptfmfilename,Ptfm);
    rewriteAero(General.TempDir,Aerofilename,Wind);
    rewriteTwr(General.TempDir,Twrfilename,Turbine);
end
%varargout{1}=General.TempDir;
varargout{1}=Wind; %for record-keeping (used)
varargout{2}=Ptfm; %for record-keeping (unused)
varargout{3}=Turbine; %for record-keeping (unused)
end

function [aeroname,twrname,ptfmname]=rewriteFST(maindir,outputdir,Turbine,Ptfm,General)
FASTdir=['Input_FAST' filesep];
%% Rewrite OrcaFAST input file .fst and Platform.ipt and run OrcaFAST
fstfilename=[maindir, FASTdir, Turbine.Name, '_', Turbine.Code, '.fst'];
altfstfilename=[maindir, FASTdir, Turbine.AltName, '_', Turbine.Code, '.fst'];
if exist(fstfilename,'file') && exist(altfstfilename,'file')
    if ~strcmp(fstfilename,altfstfilename)
        warning([Turbine.Name ' and ' Turbine.AltName '.fst files exist in Input_FAST. Picking ' Turbine.Name '_', Turbine.Code, '.fst'])
    end
end
if ~exist(fstfilename,'file')
   if ~exist(altfstfilename,'file')
       error(['Cannot find fst file with name: ' fstfilename ' or ' altfstfilename])
   else
      fstfilename=altfstfilename;
   end
end
inputfst = fopen(fstfilename);
frewind(inputfst);
outputfst = fopen([outputdir 'primary.fst'],'w');
fst_line = 0;

while ~feof(inputfst);
    fst_line = fst_line + 1;
    fst_linecontents = fgetl(inputfst);
    if fst_line == 10 %Change tmax line
        fst_linecontents(1:6) = sprintf('%6.f',General.EndTime+General.StartTime); % Orca goes from -StartTime:EndTime whereas FAST goes from 0:StartTime+EndTime (we then reinterp during post-process)
    elseif fst_line == 27
        if strcmp(Turbine.Code,'SDE') && General.CutInTime>.1*General.EndTime %( it was manually set)
            fst_linecontents(1:6) = sprintf('%6.1f',General.CutInTime+General.StartTime-.2);
        end
    elseif fst_line == 29
        if strcmp(Turbine.Code,'LCK')
            fst_linecontents(1:6) = sprintf('%6.1f',0);
        end
    elseif (fst_line == 40) || (fst_line == 41) || (fst_line == 42) 
        PitManB= str2num(fst_linecontents(1:6));
        if strcmp(Turbine.Code,'SDE') && General.CutInTime>.1*General.EndTime
            fst_linecontents(1:6) = sprintf('%6.1f',General.CutInTime+General.StartTime);
        end
    elseif fst_line == 43 || fst_line == 44 || fst_line == 45 
        PitManE= str2num(fst_linecontents(1:6));
        PitManDT=PitManE-PitManB;
        if strcmp(Turbine.Code,'SDE') && General.CutInTime>.1*General.EndTime
             fst_linecontents(1:6) = sprintf('%6.1f',General.CutInTime+General.StartTime+PitManDT);
        end
    elseif fst_line == 60 %Change GenDOF line
        if strcmp(Turbine.Code,'LCK')
            fst_linecontents(1:5) = 'False';
        else
            fst_linecontents(1:4) = 'True';
        end
    elseif fst_line == 74 %Change NacYaw line
        fst_linecontents(1:6) = num2str(Turbine.Yaw,'%06.1f');
    elseif fst_line == 131
        if Ptfm.iFAST==2
            fst_linecontents(1:4)=sprintf('%4d',0); % fixed platform
        else 
            fst_linecontents(1:4)=sprintf('%4d',3); % floating platform
        end
    elseif fst_line == 132
         ptfm_line=fst_linecontents(1:end);
         iq=strfind(ptfm_line,'"');
         ptfmname=ptfm_line(iq(1)+1:iq(2)-1);
         restofline=ptfm_line(iq(2)+1:end);
         if ~exist([maindir, FASTdir, ptfmname],'file')
             error(['Cannot find input Ptfm file for FAST as specified in fst file: ', maindir, FASTdir, ptfmname])
         end
%          if ~strcmp(ptfmname,Ptfmfilename)
%              warning('Platform file name is not written correctly in fst file. Overwriting platform file name');
%              fst_linecontents=['"' Ptfmfilename '"' restofline];
%          end   
%          
    elseif fst_line == 135
         twr_line=fst_linecontents(1:end);
         iq=strfind(twr_line,'"');
         twrname=twr_line(iq(1)+1:iq(2)-1);
         if ~exist([maindir, FASTdir, ptfmname],'file')
             error(['Cannot find input Twr file for FAST as specified in fst file: ', maindir, FASTdir, twrname])
         end
    elseif fst_line == 157
         blade1_line=fst_linecontents(1:end);
         iq=strfind(blade1_line,'"');
         blade1name=blade1_line(iq(1)+1:iq(2)-1); 
         if ~exist([maindir, FASTdir, ptfmname],'file')
             error(['Cannot find input Blade 1 file for FAST as specified in fst file: ', maindir, FASTdir, blade1name])
         end         
    elseif fst_line == 161
         aero_line=fst_linecontents(1:end);
         iq=strfind(aero_line,'"');
         aeroname=aero_line(iq(1)+1:iq(2)-1); 
         if ~exist([maindir, FASTdir, ptfmname],'file')
             error(['Cannot find input Aero file for FAST as specified in fst file: ', maindir, FASTdir, aeroname])
         end         
    end
    fprintf(outputfst,'%s\n',fst_linecontents);
end
fclose(inputfst);
fclose(outputfst);
end

function rewriteAero(tempdir,aeroname,Wind)
inputfid = fopen([tempdir aeroname]);
input_line = 1;
while ~ feof(inputfid);
    input_linecontents{input_line} = fgetl(inputfid); %#ok<AGROW>
    input_line = input_line + 1;
end
fclose(inputfid);
windfileline=input_linecontents{10};
input_linecontents{10}=regexprep(windfileline,'"(.[^'']*?)"',['"' Wind.FileName Wind.FileExt '"']); % Rewrite the name of the Aerodyn input file
outputfid = fopen([tempdir aeroname],'w'); %rewrite _aero.ipt file
for out_line = 1:input_line-1
    fprintf(outputfid, '%s\n', input_linecontents{out_line});
end
fclose(outputfid);
end

function rewriteTwr(tempdir,twrname,Turbine)
inputfid = fopen([tempdir twrname]);
input_line = 1;
while ~ feof(inputfid);
    input_linecontents{input_line} = fgetl(inputfid); %#ok<AGROW>
    input_line = input_line + 1;
end
fclose(inputfid);
if ~isnan(Turbine.Tower.FAmult)
    input_linecontents{12}(1:7)=sprintf('%1.5f', Turbine.Tower.FAmult); % Rewrite the value of the FA multiplier
end
if ~isnan(Turbine.Tower.SSmult)
    input_linecontents{14}(1:7)=sprintf('%1.5f', Turbine.Tower.SSmult); % Rewrite the value of the SS multiplier
end
outputfid = fopen([tempdir twrname],'w'); %rewrite _aero.ipt file
for out_line = 1:input_line-1
    fprintf(outputfid, '%s\n', input_linecontents{out_line});
end
fclose(outputfid);
end

function rewritePtfm(tempdir,ptfmname,Ptfm)
% ptfmname=[ Turbine.Name '_Ptfm.ipt'];
% altptfmname=[Turbine.AltName '_Ptfm.ipt'];
% if ~exist([tempdir ptfmname],'file')
%    if ~exist([tempdir altptfmname],'file')
%        error(['Cannot find ptfm file with name: ' ptfmname ' or ' altptfmname]) 
%    else
%       ptfmname=altptfmname;
%    end
% end
if ~exist([tempdir ptfmname],'file')
    error(['Cannot find ptfm file with name: ' ptfmname])
end
inputfid = fopen([tempdir ptfmname]);
input_line = 1;
while ~ feof(inputfid);
    input_linecontents{input_line} = fgetl(inputfid); %#ok<AGROW>
    input_line = input_line + 1;
end
fclose(inputfid);
input_linecontents{31}(1:4) = num2str(mod(-round(Ptfm.OrcaHeading),360),'%04d');% num2str(Wind.Dir,'%04d'); % OrcaFAST OVERWRITES whatever InitialHeading you had entered with the negative of this value!
input_linecontents{32}(4) = num2str(Ptfm.BallastFlag);
outputfid = fopen([tempdir ptfmname],'w'); %rewrite _Ptfm.ipt file
for out_line = 1:input_line-1
    fprintf(outputfid, '%s\n', input_linecontents{out_line});
end
fclose(outputfid);
end

function fillRunFolder(maindir,outputdir,Ptfm,Wind,Turbine)
% NEED TO TEST: untested copy inputs function
%% NEED to copy FAST and FASTlinkdll
fastname='FAST.exe';
Files=rdir([maindir 'ORCAFAST*\**\*' fastname]);
if length(Files)<1
    Files=rdir([maindir 'Input_FAST\**\*' fastname]);
    if length(Files)<1
        error(['Cannot find FAST.exe in an ORCAFAST* or an Input_FAST subfolder of ' maindir])
    elseif length(Files)>1
        error('Multiple copies of FAST.exe found in subdirectories of Input_FAST folder')
    end
elseif length(Files)>1
    Files=rdir([maindir 'Input_FAST\**\*' fastname]);  %I want to take fast.exe anyway
    fprintf('Warning: Multiple copies of FAST.exe found in an ORCAFAST* subfolder')  %I replaced the error message for a warning message
end
dllname='FASTlinkDLL.dll';
F2=rdir([maindir 'ORCAFAST*\**\*' dllname]);
if length(F2)<1
     F2=rdir([maindir 'Input_FAST\**\*' dllname]);
     if length(F2)<1
        error(['Cannot find FASTlink.dll in an ORCAFAST* or a Input_FAST subfolder of ' maindir])
     end
end
Files=[Files;F2];
%% Other dlls?
otherdll='lib*md.dll';
Fdll=rdir([maindir 'ORCAFAST*\**\*' otherdll]);
if length(Fdll)<1
     Fdll=rdir([maindir 'Input_FAST\**\*' otherdll]);
     if length(Fdll)<1
        warning(['Cannot find lib*md.dll in an ORCAFAST* or a Input_FAST subfolder of ' maindir])
     end
end
Files=[Files;Fdll];
%% Need to copy .ipts (aero and 
F3=rdir([maindir 'Input_*\**\*.ipt']);
Files=[Files;F3];
%% Need to copy airfoils and put them in an airfoils folder
Fa=rdir([maindir 'Input_*\**\airfoils']);
if length(Fa)<1
    error('Cannot find airfoils folder.')
else
    [AFdir,~,~]=fileparts(Fa(1).name);
end
Fa(1).name=[AFdir filesep];
Files=[Files;Fa(1)];
%% Need to copy controller
Fd=rdir([maindir 'Input_FAST\**\discon_' Turbine.Code '.dll']); % case-insensitive: could be Discon.dll (Windows file names are case-insensitive)
if length(Fd)<1
    error(['Cannot find turbine controller discon_' Turbine.Code '.dll in a subdirectory of Input_FAST folder. Please create one (or copy an old one from a previous project)'])
elseif length(Fd)>1
    error(['Multiple defined controller files discon_' Turbine.Code '.dll in subdirectories of Input_FAST folder. Please remove extraneous files'])
end
Files=[Files;Fd];
%% Need to copy .dat's in FAST folder
Ft=rdir([maindir 'Input_FAST\**\' Turbine.Name '*.dat']); % I don't believe it is case-sensitive
if length(Ft)<1
    Ft=rdir([maindir 'Input_FAST\**\' Turbine.AltName '*.dat']); % I don't believe it is case-sensitive
    if length(Ft)<1
        error(['Cannot find ' Turbine.Name 'or' Turbine.AltName '*.dat files in Input_FAST folder'])
    end
end
Files=[Files;Ft];
copyinps=cell(length(Files),2);
for ii=1:length(Files)
   iName=Files(ii).name;
   if strcmp(iName(end),filesep)
       %you are trying to copy and entire folder
       copyinps{ii,1}=iName;
       iseps=strfind(iName,filesep);
       %output folder name
       fName=iName(iseps(end-1)+1:iseps(end)-1);
       copyinps{ii,2}=[outputdir fName];
   else
       copyinps{ii,1}=Files(ii).name;
       [~,ifname,ext]=fileparts(Files(ii).name);
       %outputfile name
      if strncmp(ifname,'discon',6)
           ifname='discon';
       end
       copyinps{ii,2}=[outputdir ifname ext];
   end
end
if Ptfm.iFAST
    copyinps = [copyinps;{Wind.File, [outputdir Wind.FileName Wind.FileExt]}];
end

%copyfile([maindir '\Input_FAST\*.*'], outputdir) % NEED TO UPDATE: don't want to copy everything!!!
%copyinps = {[maindir '\Wind\'],Wind.File, [outputdir 'turbwind.wnd']; 
%    [maindir '\ORCAFAST_10\FAST_2012IFCompiler\Release\'], 'FAST.exe', [outputdir 'FAST.exe'];
%    [maindir '\ORCAFAST_10\FAST_2012IFCompiler\'],'FASTlinkDLL.dll',[outputdir 'FASTlinkDLL.dll']};
% if Ptfm.BallastFlag && exist([workpath_of '\Input_FAST\discon' inputcode '.dll'],'file') % Check if exists, otherwise use regular
%     copyinps = [copyinps;{[workpath_of '\Input_FAST\'], ['discon' inputcode '.dll'], [tempfolder 'discon.dll']}];
% end
if isfield(Wind,'Filesum')
    copyinps = [copyinps;{Wind.Filesum, [outputdir Wind.FileName '.sum']}];
end

for i = 1:size(copyinps,1);
    [status, message] = copyfile([copyinps{i,1}], copyinps{i,2});
    if ~status
        copyinps{i,1}
        error([copyinps{i,1},': ',message])
    end
end
end

function HH=getThrust(Wind,Turbine,General)
    % load the hh file
    try
        [HH.t,HH.U,HH.Th,HH.W]=readHH([Wind.Path Wind.File]);
         Cut_Off=[60    80    50    30    20    20    20    20    20    20    20];
         WS_cut_off=[4:2:24];
        % interpolate the thrust and apply a moving filter
        HH.F=moving(interp1(Turbine.ThrustTable(:,1),Turbine.ThrustTable(:,2),HH.U),interp1(WS_cut_off,Cut_Off,Wind.Speed,'linear','extrap')); %Convert time to Thrust using 

    catch
        if strcmp(Turbine.Code,'SDE')
            HH.t = [0; General.CutInTime-1; General.CutInTime];
            HH.U=Wind.Speed.*ones(length(HH.t),1);
            HH.U(end)=0;
        else
            HH.t=[0; General.EndTime];
            HH.U=Wind.Speed.*ones(length(HH.t),1);
        end
        HH.F=interp1(Turbine.ThrustTable(:,1),Turbine.ThrustTable(:,2),HH.U);
    end
    %HH.thrust=Rotate2DMat([HH.F zeros(length(HH.F),1)],Wind.Dir*pi()/180); 
    % For Orca-Flex always set thrust force in positive x-direction of the
    % LOCAL coordinate system of the RNA
    HH.thrust=[HH.F 0.0*ones(length(HH.F),1)]; % need a floating point??
    iplot=0;
    if iplot
        [ax,h1,h2]=plotyy(HH.t,HH.F,HH.t,HH.U);
        set(ax(1),'xlim',[0 720],'ylim',[0 1800e3],'ytick',[200e3:200e3:1800e3]);
        set(ax(2),'xlim',[0 720],'ylim',[0 20],'ytick',[2:2:20]);
        grid on
        pause
    end
end

function setFakeForceValue(model,Fname,F,nDOF)
    
try
    ExtF=model(Fname);
catch
    if nDOF<4 || nDOF==7
        model.CreateObject(ofx.otLoadForce, Fname)
    elseif nDOF>=4 && nDOF<=6
        model.CreateObject(ofx.otLoadMoment, Fname)
    end 
    disp(sprintf('Inserted a Variable Data called %s', Fname))
    ExtF=model(Fname);
end
ExtF.NumberOfRows=0; %clear the decay force

[nrows,~]=size(F);
ExtF.NumberOfRows=nrows;

%ramp function- should reduce transient times
ExtF.IndependentValue(1:nrows)=F(:,1); %step times
ExtF.DependentValue(1:nrows)=F(:,2);

end

% function setFakeForceValue(model,Fname,F,nDOF)
% [nrows,foo]=size(F);
% if nDOF>0 && nDOF <=3
%     try
%         DecayForce=model(Fname);
%     catch
%         model.CreateObject(ofx.otLoadForce, Fname);
%         DecayForce=model(Fname);
%         disp(sprintf('Inserted a Variable Data called %s', Fname))
%     end
%     DecayForce.NumberOfRows=nrows;
%     DecayForce.IndependentValue(1:nrows)=F(:,1); %step times
%     DecayForce.DependentValue(1:nrows)=F(:,2);
% elseif nDOF>=4 && nDOF <=6      
%     try
%         DecayMoment=model(Fname);
%     catch
%         model.CreateObject(ofx.otLoadMoment, Fname);
%         DecayMoment=model(Fname);
%         disp(sprintf('Inserted a Variable Data called %s', Fname))
%     end       
%     DecayMoment.NumberOfRows=nrows;
%     DecayMoment.DependentValue(1:nrows)=F(:,2);
%     DecayMoment.IndependentValue(1:nrows)=F(:,1); %step times
% else
%     error('What DOF are you trying to set?!? DOF=1:6')
% end
% end

function applyAntiThrust(Model,WindFloat,Ptfm,nLAL)
% fake ballast controller during fatigue, only used if BallastFlag==2
    if isempty(WindFloat)
        % Using the flexible model... 
        for kk=1:3
            ABname=sprintf('AB-Col%d',kk);
            try
                AB=Model(ABname);
                AB.Mass = Ptfm.AB_Mass(kk); %set mass of active ballast buoy
                %% NEED TO MODIFY BALLAST MOI!!!
            catch
                disp(['Cannot adjust Active Ballast buoys to take into account thrust force, since ' ABname ' does not exist'])
            end
        end
    else
        X1=[WindFloat.InitialX WindFloat.InitialY WindFloat.InitialZ];
        WindFloat.NumberOfLocalAppliedLoads=nLAL+2; % to be safe... could add an extra row unnecessarily, not a big deal.
        %% Apply a thrust force at hub height??
%         WindFloat.LocalAppliedLoadOriginX(nLAL+2)=-Turbine.Overhang-X1(1);
%         WindFloat.LocalAppliedLoadOriginY(nLAL+2)=0-X1(2);
%         WindFloat.LocalAppliedLoadOriginZ(nLAL+2)=Turbine.HubH-X1(3);
%         WindFloat.LocalAppliedForceX(nLAL+2) = Ptfm.anti_thrust(1);
%         WindFloat.LocalAppliedForceY(nLAL+2) = Ptfm.anti_thrust(2);
        %% Apply a moment at platform origin
         WindFloat.LocalAppliedLoadOriginX(nLAL+2)=X1(1);
         WindFloat.LocalAppliedLoadOriginY(nLAL+2)=X1(2);
         WindFloat.LocalAppliedLoadOriginZ(nLAL+2)=X1(3);
         WindFloat.LocalAppliedMomentX(nLAL+2) = Ptfm.anti_moment(1);
         WindFloat.LocalAppliedMomentY(nLAL+2) = Ptfm.anti_moment(2);         
    end       

end
function rotateLines(Lines,Bridles,Dir)
%Dir is in degrees!
%% ROTATE Bridles
nBr=length(Bridles);
if nBr>0
   for jj=1:nBr
       jBr=Bridles{jj};
        Xbr0=[jBr.InitialX jBr.InitialY jBr.InitialZ];
        Thbr0=[jBr.InitialRotation1 jBr.InitialRotation2 jBr.InitialRotation3];
        Xbr1=Rotate2DMat(Xbr0,Dir*pi/180);
        jBr.InitialX=Xbr1(1); jBr.InitialY=Xbr1(2); jBr.InitialZ=Xbr1(3);
        jBr.InitialRotation3=mod(Thbr0(3)+Dir,360);
   end
end
%% Rotate LINES
nLines=length(Lines);
for jj=1:nLines
    rotateA=0; % assume that endA is connected to something that is already being rotated
    rotateB=1; 
    body1=Lines{jj}.EndAConnection;
    body2=Lines{jj}.EndBConnection;
    if strcmp(body1,body2)
        rotateA=1;
    end
    if Dir<=360
        if rotateB
            EndB = [Lines{jj}.EndBX Lines{jj}.EndBY];
            EndBr=Rotate2DMat(EndB,Dir*pi/180);
            Lines{jj}.EndBX =EndBr(1); Lines{jj}.EndBY =EndBr(2);
            EndBAz= Lines{jj}.EndBAzimuth;
            Lines{jj}.EndBAzimuth =  mod(EndBAz + Dir,360);             
        end
        if rotateA
            EndA = [Lines{jj}.EndAX Lines{jj}.EndAY];
            EndAr=Rotate2DMat(EndA,Dir*pi/180);
            Lines{jj}.EndAX =EndAr(1); Lines{jj}.EndAY =EndAr(2);
            EndAAz= Lines{jj}.EndAAzimuth;
            Lines{jj}.EndAAzimuth =  mod(EndAAz + Dir,360); 
        end
    end
    if strcmp(Lines{jj}.IncludeSeabedFrictionInStatics,'Yes') && abs(Dir)>0
        Lines{jj}.LayAzimuth = mod(Lines{jj}.LayAzimuth + Dir,360);
        Lines{jj}.SetLayAzimuth='yes'; %Just to be sure.  this was not obvious to find...
    end 
end

%     for i = 1:length(Mod.links) %Rotate Model Accordingly Moorings if springs.
%         EndBX = Mod.links{i}.EndBX;
%         EndBY = Mod.links{i}.EndBY;
%         Mod.links{i}.EndBX = EndBX * cos(Dir*pi/180) - EndBY * sin(Dir*pi/180);
%         Mod.links{i}.EndBY = EndBX * sin(Dir*pi/180) + EndBY * cos(Dir*pi/180);
%     end
end

function [Ptfm,Turbine]=getBallastMomentAndTurbineDrag(Ptfm,Turbine,Wind)
%estimate the drag force on the tower 
Turbine.Tower.Area=Turbine.Tower.H.*Turbine.Tower.D; 
%Cd_Air=0.7; % should be in defined in TurbineX!!!
%rho_Air=1.280; %[kg/m^3]
Turbine.Tower.Drag=sum(.5*Turbine.AirDensity*Turbine.Tower.Area*Turbine.Tower.Cd*Wind.Speed^2); % [N] does not take into account relative motion of tower
Turbine.Tower.CoP= sum( Turbine.Tower.Area.*(cumsum(Turbine.Tower.H)-Turbine.Tower.H*.5))/sum(Turbine.Tower.Area);

% BALLAST CONTROLLER LOGIC
%BALLAST_FLAG==2 --> Calculate an 'anti-thrust' moment on platform and
%rotate it depending on wind-speed

%BALLAST_FLAG==0 --> Use the GAL or LAL from the DLC spreadsheet

%BALLAST_FLAG==1 --> Use the Ballast controller built-in with FAST (Antoine
%has written it)
if Ptfm.BallastFlag==2 && Wind.Speed>0
    if isfield(Turbine.RNA,'COP')
        thrustX=Turbine.RNA.COP;
    else
        thrustX=[0 0 Turbine.HubH];
    end
    % use a pre-ballast system to get new weights of the active ballast like in fatigue   
    if Wind.Speed > Turbine.CutIn || Wind.Speed < Turbine.CutOut      
        thrustF=interp1(Turbine.ThrustTable(:,1),Turbine.ThrustTable(:,2),Wind.Speed);
        Ptfm.anti_thrust=Rotate2DMat([-thrustF 0],Wind.Dir*pi()/180);
        Ptfm.anti_moment=cross(thrustX,[Ptfm.anti_thrust 0]);
    else
        %use the drag force
        Ptfm.anti_thrust=Rotate2DMat([-Turbine.Tower.Drag 0],Wind.Dir*pi()/180);
        Ptfm.anti_moment=cross(thrustX,[Ptfm.anti_thrust 0]);
    end

elseif Ptfm.BallastFlag==0 && Wind.Speed>0
    if abs(Ptfm.LAL.F{5})>0 || abs(Ptfm.LAL.F{4})>0
        LAM=[Ptfm.LAL.F{4} Ptfm.LAL.F{5} 0];
        warning('Ballast Flag set to 0 and Local pitch moments are non-zero. Using Local moments for Ballast calculation.')
        Ptfm.anti_moment=LAM;
    elseif abs(Ptfm.GAL.F{5})>0 || abs(Ptfm.GAL.F{4})>0
        GAM=[Ptfm.GAL.F{4} Ptfm.GAL.F{5} 0];
        warning('Ballast Flag set to 0 and Global pitch moments are non-zero. Using Local moments for Ballast calculation.')
        Ptfm.anti_moment=GAM;
    else
        warning('Ballast Flag set to 0 and Local and Global pitch moments are set to 0. No righting moment will be applied to model.')
        Ptfm.anti_moment=[0 0 0];
    end
else
    % you are using the FAST ballast controller
    Ptfm.anti_thrust=[0 0];
    Ptfm.anti_moment=[0 0 0]; % this will not be used when writing BallastMass
end

if Wind.Speed>0 && isfield(Ptfm,'BallastW')
    [M(1),M(2),M(3)] = CalBallastWeight(Ptfm.anti_moment(1:2),[Ptfm.Col.Lh*2/3 0],[-Ptfm.Col.Lh*1/3 Ptfm.Col.L/2],[-Ptfm.Col.Lh*1/3 -Ptfm.Col.L/2],Ptfm.BallastW);
else
    M=[0 0 0];
end
Ptfm.AB_Mass=M; % Masses will be equal if there is no anti-moment on the platform
end

function environment=putWindWaveCur(Wind,Wave,Cur,Ptfm,environment)
nWT=environment.NumberOfWaveTrains; 
if nWT>1
    warning([ sprintf('%d',nWT) 'wave trains exist. Modifying first wave train.'])
end
if Wave.Seed
    environment.SelectedWaveTrain = environment.WaveName(1);
    environment.WaveType = Wave.SpectrumType;
    if Ptfm.iFAST
        environment.WaveDirection = Wave.Dir-Wind.Dir;
    else
        environment.WaveDirection = Wave.Dir;
    end
    
    environment.UserSpecifiedRandomWaveSeeds='Yes';
    environment.WaveSeed = Wave.Seed;
    if strcmp(Wave.SpectrumType,'JONSWAP')
        if isfield(Wave,'Gamma')
        environment.WaveGamma = Wave.Gamma;
        else
            disp('Spreading parameter Gamma unspecified for Wind-Sea waves. Setting Gamma=1: JONSWAP -> ISSC = P-M')
            environment.WaveGamma=1;
        end
    end
    environment.WaveNumberOfComponents=100; %these are default different for different versions of Orca
    if strcmp(Wave.SpectrumType,'JONSWAP') || strcmp(Wave.SpectrumType,'ISSC')
        environment.WaveSpectrumMinRelFrequency=.5;
        environment.WaveSpectrumMaxRelFrequency=10.0;
    end
    if isempty(strfind(Wave.SpectrumType,'User'))
        environment.WaveHs = Wave.Hs; %+ .00001; % add negligible current for rayleigh damping
        environment.WaveTp = max([Wave.Tp 1]); % set Wave Tp at the end, cannot be 0
    else
        if ~exist(Wave.SpectrumFile,'file')
            error(['Cannot find Wave Spectrum file specified in INTRODUCTION Tab of OrcaFlex sheet: ' Wave.SpectrumFile ' Please make sure that file exists.'])
        end
        wavedata=load(Wave.SpectrumFile);
        myname=fieldnames(wavedata);
        if length(myname)>1
            error('Impoperly formed wave spectrum file.');
        else
            wavedata=wavedata.(myname{1});
        end
        ncomp=size(wavedata,1); nprops= size(wavedata,2);
        if ~isempty(strfind(Wave.SpectrumType,'Components'))
            if nprops~=4
                error('A User Specified Components Spectrum must have Freq, Period, Amplitude and Phase Lag specified (in that order)')
            else
                environment.WaveNumberOfUserSpecifiedComponents=ncomp;
                environment.WaveUserSpecifiedComponentFrequency = wavedata(:,1);
                environment.WaveUserSpecifiedComponentPeriod = wavedata(:,2);
                environment.WaveUserSpecifiedComponentAmplitude = wavedata(:,3);
                environment.WaveUserSpecifiedComponentPhaseLag = wavedata(:,4);
            end
        else
            %you are running User Specified Spectrum
            if nprops~=2
                error('A User Defined Spectrum must have Spectrum Amplitude and Freq specified (in that order)')
            else
                environment.WaveNumberOfUserSpectralPoints=ncomp;
                environment.WaveSpectrumS=wavedata(:,1);
                environment.WaveSpectrumFrequency=wavedata(:,2);
            end
        end
    end
else
    environment.SelectedWaveTrain = environment.WaveName(1);
    environment.WaveType = 'Single Airy';
    if Ptfm.iFAST
         environment.WaveDirection = Wave.Dir-Wind.Dir;
    else
        environment.WaveDirection = Wave.Dir;
    end
    environment.WaveHeight = Wave.Hs; %+ .00001; % add negligible current for rayleigh damping
    environment.WavePeriod = max([Wave.Tp 1]); %max([Wave.Tp minTp]);
end
if ~isnan(Cur.Speed)
    environment.RefCurrentSpeed = Cur.Speed;
    if Ptfm.iFAST
        environment.RefCurrentDirection = Cur.Dir-Wind.Dir;
    else
        environment.RefCurrentDirection = Cur.Dir;
    end
end
if Wind.Type==0 || Ptfm.iFAST
    environment.WindType = 'Constant';
else
    disp('Leaving OrcaFlex Wind Type alone')
end
if Ptfm.iFAST
    environment.WindDirection = 0; %Always 0 inline with FAST model wind
else
   environment.WindDirection = Wind.Dir;
end
environment.WindSpeed = Wind.Speed;

if Wave.Swell.Hs>0
    if nWT+1==2
        disp(['Adding another wave train with wave height= ' sprintf('%2.2f',Wave.Swell.Hs) 'm, period= ' sprintf('%2.1f',Wave.Swell.Tp) 's, to create the bi-modal spectra.'])
    end
    
    environment.NumberOfWaveTrains=nWT+1; %add a wave train
    if Wave.Swell.Seed
        environment.SelectedWaveTrain = environment.WaveName(nWT+1);
        environment.WaveType = Wave.SpectrumType; % NEED TO ADD CAPABILITY OF A SECOND WAVE TYPE?!?
        if Ptfm.iFAST
            environment.WaveDirection = Wave.Swell.Dir-Wind.Dir;
        else
            environment.WaveDirection = Wave.Swell.Dir;
        end

        environment.UserSpecifiedRandomWaveSeeds='Yes';
        environment.WaveSeed = Wave.Swell.Seed;
        if strcmp(Wave.Swell.SpectrumType,'JONSWAP')
            if isfield(Wave.Swell,'Gamma')
            environment.WaveGamma = Wave.Swell.Gamma;
            else
                disp('Spreading parameter Gamma unspecified for Swell waves. Setting Gamma=1: JONSWAP -> ISSC = P-M')
                environment.WaveGamma=1;
            end
        end
        environment.WaveNumberOfComponents=100; %these are default different for different versions of Orca
        if strcmp(Wave.Swell.SpectrumType,'JONSWAP') || strcmp(Wave.Swell.SpectrumType,'ISSC')
            environment.WaveSpectrumMinRelFrequency=.5;
            environment.WaveSpectrumMaxRelFrequency=10.0;
        end
        if isempty(strfind(Wave.Swell.SpectrumType,'User'))
            environment.WaveHs = Wave.Swell.Hs; %+ .00001; % add negligible current for rayleigh damping
            environment.WaveTp = max([Wave.Swell.Tp 1]); %max([Wave.Tp minTp]); % set Wave Tp at the end, cannot be 0
        else
            wavedata=load(Wave.Swell.SpectrumFile);
            myname=fieldnames(wavedata);
            if length(myname)>1
                error('Impoperly formed wave spectrum file.');
            else
                wavedata=wavedata.(myname{1});
            end
            ncomp=size(wavedata,1); nprops= size(wavedata,2);
            if ~isempty(strfind(Wave.Swell.SpectrumType,'Components'))
                if nprops~=4
                    error('A User Specified Components Spectrum must have Freq, Period, Amplitude and Phase Lag specified (in that order)')
                else
                    environment.WaveNumberOfUserSpecifiedComponents=ncomp;
                    environment.WaveUserSpecifiedComponentFrequency = wavedata(:,1);
                    environment.WaveUserSpecifiedComponentPeriod = wavedata(:,2);
                    environment.WaveUserSpecifiedComponentAmplitude = wavedata(:,3);
                    environment.WaveUserSpecifiedComponentPhaseLag = wavedata(:,4);
                end
            else
                %you are running User Specified Spectrum
                if nprops~=2
                    error('A User Defined Spectrum must have Spectrum Amplitude and Freq specified (in that order)')
                else
                    environment.WaveNumberOfUserSpectralPoints=ncomp;
                    environment.WaveSpectrumS=wavedata(:,1);
                    environment.WaveSpectrumFrequency=wavedata(:,2);
                end
            end
        end
    else
        environment.WaveType = 'Single Airy';
        if Ptfm.iFAST
            environment.WaveDirection = Wave.Swell.Dir-Wind.Dir;
        else
            environment.WaveDirection = Wave.Swell.Dir;
        end
        environment.WaveHeight = Wave.Swell.Hs; %+ .00001; % add negligible current for rayleigh damping
        environment.WavePeriod = max([Wave.Swell.Tp 1]); %max([Wave.Tp minTp]);
    end
%     environment.SelectedWaveTrain = environment.WaveName(nWT+1);
%     environment.WaveType = 'JONSWAP';
    %PSpecified=environment.WaveJONSWAPParameters; 

%     environment.WaveHs = Wave.Swell.Hs;
%     environment.WaveSeed = Wave.Swell.Seed;
%     if Wave.Swell.Seed
%         environment.WaveGamma = Wave.Swell.Gamma;
%     end
%     environment.WaveTp = Wave.Swell.Tp; %max([Wave.Swell.Tp minTp]); %controls Wavefm
end

end

function Wind=getWindFile(Wind,General)
if isfield(Wind,'Seed')
    if isnumeric(Wind.Seed)
        if Wind.Type~=0
            Wind.SeedStr=char(64+Wind.Seed);
            warning('Wind Seed is numeric. Wind Seed should be a string like "A". Its cool, I set it to a letter for you. ')
        end
    elseif ischar(Wind.Seed)
        Wind.SeedStr=Wind.Seed;
    else
        error('Wind_Seed not recognized. Use an integer or a string')
    end
end

if Wind.Type == 0 || Wind.Speed==0 %Steady wind 
    Wind.FileName=['steady_wind' num2str(Wind.Speed, '%02d')];
    Wind.FileDir=[Wind.Path 'SteadyWind\'];
    Wind.FileExt='.wnd';
elseif Wind.Type == 1 % Turbulent Winds
    % if the RunTime is > 1 hr, then use hh file. 
    % else use .wnd file. (we never run POW cases for more than 1 hr)
    if Wind.stdTI==-1 || isnan(Wind.stdTI)
        Wind.FileName = ['turbwind' Wind.ResName '_' num2str(round(Wind.Speed),'%02d') '_' Wind.IECType '_' Wind.SeedStr];
        Wind.FileDir=Wind.TSDir;
        if strcmp(Wind.FileExt,'.') %default = '.'
            if General.EndTime<=4000    
                Wind.FileExt='.wnd';
            else
                Wind.FileExt = '.hh';
            end
        end
    else
        WindTL=Wind.stdTI/Wind.Speed*100;
        Wind.FileName = ['turbwind' Wind.ResName '_' num2str(round(Wind.Speed),'%02d') '_' num2str(round(WindTL*10),'%03d')  Wind.SeedStr];
        Wind.FileDir=Wind.TSDir;
%         if strcmp(Wind.FileExt,'.') %default = '.'
%             if General.EndTime<=4000    
%                 Wind.FileExt='.wnd';
%             else
%                 Wind.FileExt = '.hh';
%             end
%         end
    end
elseif Wind.Type == 2 % User specified in IECWind
    Wind.FileName= Wind.Seed;
    Wind.FileDir = [Wind.Path 'IECWind_v510\'];
    Wind.FileExt = '.wnd';
else % what kind of wind do you want to run??!
    Wind.FileName = ['steady_wind' num2str(Wind.Speed, '%02d') Wind.SeedStr ];
    Wind.FileDir=[Wind.Path 'SteadyWind\'];
    Wind.FileExt = '.wnd';
end
Wind.File=[Wind.FileDir Wind.FileName Wind.FileExt];
Wind.AltFile=[Wind.FileDir strrep(Wind.FileName,'_','') Wind.FileExt];
if strcmp(Wind.FileExt,'.wnd') && Wind.Type == 1 && Wind.Speed>0
     Wind.Filesum = [Wind.TSDir Wind.FileName '.sum'];
end
end

function [Wind,Wave,Cur,General]=CreateBoringRun()
Wind.Dir=0; Wind.Speed=0; Wind.Type=0; Wind.Seed=[];
Wave.Dir=0; Wave.Hs=0; Wave.Tp=1e-6; Wave.Seed=0;
Cur.Dir=0; Cur.Speed=0;
General.StartTime=-60; %some amount of transient 
General.EndTime=3600; %1 hr run?!
end


% function runname=GetBoringRunName(outputdir)
% temp_i = 1;
% runname = sprintf('Run%07d',temp_i);
% while exist([outputdir runname],'dir')
%     temp_i = temp_i + 1;
%     runname = sprintf('Run%07d',temp_i);
% end
% runname=[outputdir filesep];
% end