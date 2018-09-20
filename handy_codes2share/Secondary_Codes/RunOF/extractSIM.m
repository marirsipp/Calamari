function [Res,Units]=extractSIM(SIMname,Ptfm,Turbine, varargin)
disp(['Extracting results from ' SIMname ['.sim']])
% full inputs = SIMname,Ptfm,Turbine, General,Wind,trackpointsCOL,trackpointsWEP
if nargin<4 % only really need to specify .sim file, Turbine geometry and Platform geometry
    iRunOF=0;
    t_trans=0; % doesn't matter since yawfix doesn't get output anyways
elseif nargin==4
    General = varargin{1};
    t_trans=General.CutInTime; % [s] time to start the mean yaw calculation
elseif nargin==5
    General = varargin{1};
    Wind = varargin{2};
    trackpointsCOL =[];
    trackpointsWEP = [];
    trackpointsKEEL = [];
    iRunOF=1;
    t_trans=General.CutInTime; % [s] time to start the mean yaw calculation
else
    General = varargin{1};
    Wind = varargin{2};
    trackpointsCOL = varargin{3};
    trackpointsWEP = varargin{4};
    trackpointsKEEL = varargin{5};
    iRunOF=1;
    t_trans=General.CutInTime; % [s] time to start the mean yaw calculation
end
t_start=0;

Res.yawfix=0;
WFname='Platform';  % hard-coded names in the OrcaFlex model
RNAname='RNA'; % hard-coded names in the OrcaFlex model
Bname='COL1 U'; % hard-coded names in the OrcaFlex model
BnameAlt = 'Col1 U';
%MLname='ML'; % hard-coded names in the OrcaFlex model
WEPname='WEP'; % hard-coded names in the OrcaFlex model
%ECname = 'EC'; % hard-coded from French office
dFname='DecayForce'; % hard-coded from PreOF -> Why do I need other options for the decay force name?
dMname='DecayMoment';% hard-coded from PreOF
Res.ShortFlag = 1;
Units=[];
if exist([ SIMname '.sim'],'file')
    resh_mod = ofxModel([SIMname '.sim']);
    Res.state=resh_mod.state; %5 = simulation stopped unstable, 4 = Simulation Stopped, 3= Sim running, 2= Static, 1 = Running Statics, 0 = Reset
    %% End Time
    timedata = resh_mod.simulationTimeStatus;
    timeend = floor(timedata.CurrentTime - 1);
    if timeend<t_trans
        t_trans=0; %overwrite t_trans if the run is very short
    end
    if  Res.state~= 5 
        Res.ShortFlag = 0;
        %% Get Line+Vessel Information
        resh_obj = resh_mod.objects;
        resh_lines = resh_obj(cellfun(@(obj) isa(obj,'ofxLineObject'), resh_obj)); %Grab all LinesObjects
        iplat=0;
        ibuoy=0;
        irna=0;
        for jj=1:length(resh_obj)
            igenC=strfind(resh_obj{jj}.Name,'General');
            if ~isempty(igenC)
                igen=jj;
            end
            ienvC=strfind(resh_obj{jj}.Name,'Environment');
            if ~isempty(ienvC)
                ienv=jj;
            end
            iplatC=strcmp(resh_obj{jj}.Name,WFname);
            if iplatC>0
                iplat=jj;
            end
            ibuoyC=strcmp(resh_obj{jj}.Name,Bname);
            ibuoyCalt=strcmp(resh_obj{jj}.Name,BnameAlt);
            if ibuoyC>0 || ibuoyCalt >0
                ibuoy=jj;
            end
            irnaC=strcmp(resh_obj{jj}.Name,RNAname);
            if irnaC>0
                irna=jj;
            end
        end
        resh_gen = resh_obj{igen}; %General
        resh_env = resh_obj{ienv}; %Environment
        if iplat>0
            resh_platform = resh_obj{iplat};
        elseif ibuoy>0
            resh_platform = resh_obj{ibuoy};
        end
        if irna
            resh_rna = resh_obj{irna};
        end
        %resh_platform = resh_mod('Platform'); % Manual input string name to find vessel    
        
        %% Time!
        try
            Res.time = resh_gen.TimeHistory('Time',ofx.Period(t_start,timeend))';
            Units.time={'sec'};
        catch
            error( [SIMname '.sim file cannot be opened: try opening it in OrcaFlex to see what is wrong.'])
        end
        dt = Res.time(2) - Res.time(1); % FIXED time step!!
        %% Wave elevation at Model origin (Column 1)
        Res.waveel =resh_env.TimeHistory('Elevation', ofx.Period(t_start,timeend), ofx.oeEnvironment(0,0,0))';
        nT=length(Res.waveel);
        Units.waveel={'m'};
        %% Mean Yaw position (oriented relative to Global coordinate system)
        % Only Rotate Results if running FAST!!!
        if iRunOF
           Res.yawfix = Wind.Dir*Ptfm.iFAST + mean(getOFDisplacement(resh_platform,[t_trans timeend],[-Ptfm.Col.Lh*2/3,0,0],[],6)); % resh_platform.TimeHistory('Rotation 3',ofx.Period(t_trans,timeend)),Minus first minute
        end
        %% Mooring
        [Res,Units] = extractML(Res,Units,resh_lines,resh_mod,[t_start timeend],Wind,Ptfm,WFname,iRunOF);

        %% Decay Force/Decay Moment
        Res.DecayForceTime=0; Res.DecayForce=0; Units.DecayForceTime ={'s'}; Units.DecayForce={'N'};
        try 
            if isfield(General,'DecayForceName')
                decayF=resh_mod(General.DecayForceName); 
                %nrows=decayF.NumberOfRows;
                Res.DecayForceTime=decayF.IndependentValue';
                Res.DecayForce=decayF.DependentValue';
            end
        catch
            % hard-coded for backwards compatibility??!?
            try
               decayF=resh_mod(dFname);
            catch
                try
                    decayF=resh_mod(dMname);
                catch
                    disp(['Neither ' dFname ' nor ' dMname ' found in model. Setting to 0 in post-processor.'])
                end
            end
            if exist('decayF','var')
                Res.DecayForceTime=decayF.IndependentValue';
                Res.DecayForce=decayF.DependentValue'; 
            else
                Res.DecayForceTime=0;
                Res.DecayForce=0;
            end
        end    
        % Wave properties - regular/irregular wave(s)
        waveCs=resh_mod.waveComponents;
        if size(waveCs,2)<1
            %then there is no wave train -> 
            nWaves=1;
            Res.wavecomp=zeros(1,3*nWaves); 
        else
            iwave=double([waveCs(:).WaveTrainIndex]')+ones(length(waveCs),1); %index starts at 0, ala python
            [nWCs,iWCs]=histc(iwave,unique(iwave));
            maxNWC=max(nWCs);
            nWaves=length(nWCs);
            Res.wavecomp=zeros(maxNWC,3*nWaves); % freq_wavetrain1, amp_wavetrain1, ph_wavetrain1, freq_wavetrain2, amp_wavetrain2, etc..
            for jj=1:nWaves
                jwave=iWCs==jj;
                Res.wavecomp(1:nWCs(jj),3*(jj-1)+1) = [waveCs(jwave).Frequency]'; % [1/s] (not rad/sec!!)
                Res.wavecomp(1:nWCs(jj),3*(jj-1)+2) = [waveCs(jwave).Amplitude]'; %[m]
                Res.wavecomp(1:nWCs(jj),3*(jj-1)+3) = [waveCs(jwave).PhaseLagWrtSimulationTime]'; % [deg]          
            end  
        end
        Units.wavecomp=(repmat({'1/s','m','deg'},[1 nWaves]));

        Xstrs={'X','Y','Z'};
        xstrs={'x','y','z'};
        X1=[resh_platform.InitialX resh_platform.InitialY resh_platform.InitialZ];
        try
            X6=resh_platform.InitialHeading;
        catch
            X6=resh_platform.InitialRotation3;
        end
        if irna
            RNA6=resh_rna.InitialRotation3; % already relative if rigid
        end
        
        TowerM=sum(Turbine.Tower.M)+sum(Turbine.Flange.M);
        TowerCOGz=(sum((Turbine.Tower.Z+Turbine.Tower.H*.5).*Turbine.Tower.M) +sum(Turbine.Flange.M.*Turbine.Flange.Z))/TowerM;
        dTowerCOGzTwrBs=TowerCOGz-Turbine.Tower.Z(1);
        TowerCOG=[0 0 TowerCOGz]; %OrcaFlex System
        
        for kk=1:3
            %% Displacements at platform origin
            
            %Res.motion(:,kk) = resh_platform.TimeHistory(Xstrs{kk},ofx.Period(t_start,timeend), ofx.oeVessel(-Ptfm.Col.Lh*2/3,0,0));
            Res.motion(:,kk) = getOFDisplacement(resh_platform,[t_start timeend],[-Ptfm.Col.Lh*2/3,0,0]-X1,X6,kk);
            Units.motions{1,kk}='m'; % use the name that is saved in ResTable (hardcoded by Jerica + Alan
            Res.motionHubH(:,kk) = getOFDisplacement(resh_platform,[t_start timeend],[0,0,Turbine.HubH]-X1,X6,kk);
            Units.motionsHubH{1,kk}='m';
            if isfield(Turbine.RNA,'COG')
                RNACOG=Turbine.RNA.COG;
            else
                RNACOG=Turbine.Tower.Z(1);
                warning('Turbine RNA COG not set. motionsRNA and TwrBsMtRNA are incorrect.')
            end
            Res.motionRNA(:,kk) = getOFDisplacement(resh_platform,[t_start timeend],RNACOG-X1,X6,kk);
            Units.motionsRNA{1,kk}='m';           
            Res.motionTwrB(:,kk) = getOFDisplacement(resh_platform,[t_start timeend],[0,0,Turbine.Tower.Z(1)]-X1,X6,kk);
            Units.motionsTwrB{1,kk}='m';
            % get rotational motion from Orca: THIS WILL GET REWRITTEN BY
            % ROTATIONS CALCULATED BY FAST (if they exist) since they are in the proper
            % coordinate system
            Res.motion(:,kk+3) = getOFDisplacement(resh_platform,[t_start timeend],[-Ptfm.Col.Lh*2/3,0,0]-X1,X6,kk+3);
            Units.motions{1,kk+3}='deg';
            %Res.motionHubH(:,kk+3) = getOFDisplacement(resh_platform,[t_start timeend],[0,0,Turbine.HubH]-X1,kk+3);
            %Units.motionsHubH{1,kk+3}='deg';
            %Res.motionTwrB(:,kk+3) = getOFDisplacement(resh_platform,[t_start timeend],[0,0,Turbine.Tower.Z(1)]-X1,kk+3);
            %Units.motionsTwrB{1,kk+3}='deg';
            %% Velocities at platform origin
            if iplat>0
                Res.velocity(:,kk) = resh_platform.TimeHistory(['G' Xstrs{kk} '-Velocity'],ofx.Period(t_start,timeend), ofx.oeVessel(-Ptfm.Col.Lh*2/3,0,0));                
                Res.velocityHubH(:,kk) = resh_platform.TimeHistory(['G' Xstrs{kk} '-Velocity'],ofx.Period(t_start,timeend), ofx.oeVessel(0,0,Turbine.HubH));
                Res.velocityTwrB(:,kk) = resh_platform.TimeHistory(['G' Xstrs{kk} '-Velocity'],ofx.Period(t_start,timeend), ofx.oeVessel(0,0,Turbine.Tower.Z(1)));
                %Res.velocityRNA(:,kk) = resh_platform.TimeHistory(['G' Xstrs{kk} '-Velocity'],ofx.Period(t_start,timeend), ofx.oeVessel(RNACOG));
                Res.velocity(:,kk+3) = resh_platform.TimeHistory([xstrs{kk} '-Angular Velocity'],ofx.Period(t_start,timeend), ofx.oeVessel(-Ptfm.Col.Lh*2/3,0,0))*180/pi;  %[deg/s]

                %Res.velocityHubH(:,kk+3) = resh_platform.TimeHistory([xstrs{kk} '-Angular Velocity'],ofx.Period(t_start,timeend), ofx.oeVessel(0,0,Turbine.HubH))*180/pi;  %[deg/s]
                %Res.velocityTwrB(:,kk+3) = resh_platform.TimeHistory([xstrs{kk} '-Angular Velocity'],ofx.Period(t_start,timeend), ofx.oeVessel(0,0,Turbine.Tower.Z(1)))*180/pi;  %[deg/s]
            elseif ibuoy>0
                Res.velocity(:,kk) = resh_platform.TimeHistory(['G' Xstrs{kk} '-Velocity'],ofx.Period(t_start,timeend), ofx.oeBuoy([-Ptfm.Col.Lh*2/3,0,0]-X1));
                Res.velocityHubH(:,kk) = resh_platform.TimeHistory(['G' Xstrs{kk} '-Velocity'],ofx.Period(t_start,timeend), ofx.oeBuoy([0,0,Turbine.HubH]-X1));
                Res.velocityTwrB(:,kk) = resh_platform.TimeHistory(['G' Xstrs{kk} '-Velocity'],ofx.Period(t_start,timeend), ofx.oeBuoy([0,0,Turbine.Tower.Z(1)]-X1));  
                %Res.velocityRNA(:,kk) = resh_platform.TimeHistory(['G' Xstrs{kk} '-Velocity'],ofx.Period(t_start,timeend), ofx.oeBuoy(RNACOG-X1)); 
                Res.velocity(:,kk+3) = resh_platform.TimeHistory([xstrs{kk} '-Angular Velocity'],ofx.Period(t_start,timeend), ofx.oeBuoy([-Ptfm.Col.Lh*2/3,0,0]-X1))*180/pi;  %[deg/s]
                %Res.velocityHubH(:,kk+3) = resh_platform.TimeHistory([xstrs{kk} '-Angular Velocity'],ofx.Period(t_start,timeend), ofx.oeBuoy([0,0,Turbine.HubH]-X1))*180/pi;  %[deg/s]
                %Res.velocityTwrB(:,kk+3) = resh_platform.TimeHistory([xstrs{kk} '-Angular Velocity'],ofx.Period(t_start,timeend), ofx.oeBuoy([0,0,Turbine.Tower.Z(1)]-X1))*180/pi; %[deg/s]
            end
            Units.velocity{1,kk}='m/s';
            Units.velocityHubH{1,kk}='m/s';
            Units.velocityTwrB{1,kk}='m/s';
            Units.velocityRNA{1,kk}='m/s';
            Units.velocity{1,kk+3}='deg/s';
            %Units.velocityHubH{1,kk+3}='deg/s';
            %Units.velocityTwrB{1,kk+3}='deg/s';
                %% Estimate acceleration from backwards differentiation of velocity.
            %Add last value in again to make array the same length as others
            Res.accel(:,kk) = [diff(Res.velocity(:,kk))/dt; (Res.velocity(end,kk) - Res.velocity(end-1,kk))/dt];
            Units.accel{1,kk}='m/s^2';
            Res.accelHubH(:,kk) = [diff(Res.velocityHubH(:,kk))/dt; (Res.velocityHubH(end,kk) - Res.velocityHubH(end-1,kk))/dt];
            Units.accelHubH{1,kk}='m/s^2';
            Res.accelTwrB(:,kk) = [diff(Res.velocityTwrB(:,kk))/dt; (Res.velocityTwrB(end,kk) - Res.velocityTwrB(end-1,kk))/dt];
            Units.accelTwrB{1,kk}='m/s^2';
            Res.accelTwrCOG(:,kk) =  resh_platform.TimeHistory([xstrs{kk} '-Acceleration rel. g'],ofx.Period(t_start,timeend), ofx.oeVessel(TowerCOG-X1)); 
            Res.accelTwrCOG(:,kk+3) = resh_platform.TimeHistory([xstrs{kk} '-Angular Acceleration'],ofx.Period(t_start,timeend), ofx.oeVessel(TowerCOG-X1)); 
            Units.accelTwrCOG{1,kk}='m/s^2';     
            Units.accelTwrCOG{1,kk+3}='rad/s^2'; 
            %% RNA Acceleration is in local frame of RNA
            if irna
                RNARelCoG=[resh_rna.CentreOfMassX resh_rna.CentreOfMassY resh_rna.CentreOfMassZ];
                Res.accelRNA(:,kk) = resh_rna.TimeHistory([xstrs{kk} '-Acceleration rel. g'],ofx.Period(t_start,timeend), ofx.oeBuoy(RNARelCoG)); 
                Res.accelRNA(:,kk+3) = resh_rna.TimeHistory([xstrs{kk} '-Angular Acceleration'],ofx.Period(t_start,timeend), ofx.oeBuoy(RNARelCoG)); 
                Units.accelRNA{1,kk}='m/s^2';
                Units.accelRNA{1,kk+3}='rad/s^2';
            end
            %rotations
            Res.accel(:,kk+3) = [diff(Res.velocity(:,kk+3))/dt; (Res.velocity(end,kk+3) - Res.velocity(end-1,kk+3))/dt];  %[deg/s^2]
            Units.accel{1,kk+3}='deg/s^2';
            % rotational acceleration on a rigid body is independent of the
            % location of the point on the rigid body. Just use 'accel' for
            % any angular accelerations!
            

            %% only vessel has access to wave forces
            if iplat>0
                %% 1st order wave forces/moments in LOCAL system
                Res.waveforce(:,kk) = resh_platform.TimeHistory(['Wave (1st order) L' xstrs{kk} '-Force'], ofx.Period(t_start,timeend));
                Units.waveforce{1,kk}='N';
                Res.waveforce(:,kk+3) = resh_platform.TimeHistory(['Wave (1st order) L' xstrs{kk} '-Moment'], ofx.Period(t_start,timeend));
                Units.waveforce{1,kk+3}='N-m';
                %% 2nd order wave forces/moments in LOCAL system
                Res.wavedrift(:,kk) = resh_platform.TimeHistory(['Wave Drift (2nd order) L' xstrs{kk} '-Force'], ofx.Period(t_start,timeend));
                Units.wavedrift{1,kk}='N';
                Res.wavedrift(:,kk+3) = resh_platform.TimeHistory(['Wave Drift (2nd order) L' xstrs{kk} '-Moment'], ofx.Period(t_start,timeend));
                Units.wavedrift{1,kk+3}='N-m';
                %% 1st order added-mass/damping in LOCAL system
                Res.addedmassdamp(:,kk) = resh_platform.TimeHistory(['Added Mass & Damping L' xstrs{kk}  '-Force'], ofx.Period(t_start,timeend));
                Units.addedmassdamp{1,kk}='N';
                Res.addedmassdamp(:,kk+3) = resh_platform.TimeHistory(['Added Mass & Damping L' xstrs{kk}  '-Moment'], ofx.Period(t_start,timeend));
                Units.addedmassdamp{1,kk+3}='N-m';
                %% Hydrostatic stiffness forces in LOCAL system
                Res.hydrostiff(:,kk) = resh_platform.TimeHistory(['Hydrostatic Stiffness L' xstrs{kk} '-Force'], ofx.Period(t_start,timeend));
                Units.hydrostiff{1,kk}='N';
                Res.hydrostiff(:,kk+3) = resh_platform.TimeHistory(['Hydrostatic Stiffness L' xstrs{kk} '-Moment'], ofx.Period(t_start,timeend));
                Units.hydrostiff{1,kk+3}='N-m';
                %% 'Other damping' forces in LOCAL system
                Res.otherdamping(:,kk) = resh_platform.TimeHistory(['Other Damping L' xstrs{kk} '-Force'], ofx.Period(t_start,timeend));
                Units.otherdamping{1,kk}='N';
                Res.otherdamping(:,kk+3) = resh_platform.TimeHistory(['Other Damping L' xstrs{kk} '-Moment'], ofx.Period(t_start,timeend));
                Units.otherdamping{1,kk+3}='N-m';
            end
        end 
        %% Tower Base Bending Moment Induced Moment 
        %RNA6=mod(Wind.Dir+180-X6,360); % azimuthal angle of upwind turbine!
        %get the acceleration at the tower COG
        
        TowerDzCOG=abs(Turbine.Tower.Z+Turbine.Tower.H*.5-TowerCOGz);
        TowerIz=sum(Turbine.Tower.M*.5.*((Turbine.Tower.D/2).^2 + (Turbine.Tower.D/2-Turbine.Tower.t).^2)); % Iz is the sum
        
        TowerIxy=Turbine.Tower.M/12.*(3*( (Turbine.Tower.D/2).^2 + (Turbine.Tower.D/2-Turbine.Tower.t).^2)+Turbine.Tower.H.^2) + Turbine.Tower.M.*TowerDzCOG.^2;
        FlangeIxy=Turbine.Flange.M.*(Turbine.Flange.Z-TowerCOGz).^2;
        TowerIxy=sum(TowerIxy)+sum(FlangeIxy);
        if min(size(Turbine.RNA.I))>1
            RNAI=Turbine.RNA.I;
        else
            RNAI=diag(Turbine.RNA.I);
        end
        TowerRNAM=Turbine.RNA.M+TowerM;
        TowerRNACOG=(TowerM*TowerCOG+Turbine.RNA.M*Turbine.RNA.COG)/TowerRNAM;
        
        %TowerRNAI=RNAI+;
        if irna
        RotRNAaz=[cosd(RNA6) -sind(RNA6) 0; sind(RNA6) cosd(RNA6) 0; 0 0 1];       
        TowerIMat=[TowerM*eye(3) zeros(3);zeros(3) diag([TowerIxy TowerIxy TowerIz])];
        RNAIMat=[Turbine.RNA.M*eye(3) zeros(3);zeros(3) RNAI];
        dRNACOGTwrBs=Turbine.RNA.COG-[0 0 Turbine.Tower.Z(1)]; % distance between RNA COG and Tower Base (moment arm)
        MtMat = [-dRNACOGTwrBs(3)*sind(RNA6)  -dRNACOGTwrBs(3)*cosd(RNA6)  dRNACOGTwrBs(2)*cosd(RNA6)+dRNACOGTwrBs(1)*sind(RNA6);...
                 dRNACOGTwrBs(3)*cosd(RNA6)  -dRNACOGTwrBs(3)*sind(RNA6)  dRNACOGTwrBs(2)*sind(RNA6)-dRNACOGTwrBs(1)*cosd(RNA6);...
                 -dRNACOGTwrBs(2)  dRNACOGTwrBs(1) 0];     
        MtMatFull=[RotRNAaz zeros(3); MtMat RotRNAaz];
        TwrMat=[0 -dTowerCOGzTwrBs 0; dTowerCOGzTwrBs 0 0; 0 0 0]; 
        TwrMatFull=[eye(3) zeros(3); TwrMat eye(3)];
        FTwrRNA=zeros(length(Res.time),6);
        FTwrTwr=zeros(length(Res.time),6);
        for tt=1:length(Res.time)
            FTwrRNA(tt,:)=-transpose(RNAIMat*Res.accelRNA(tt,:)'); % talk to BYu for explanation of minus sign...
            FTwrTwr(tt,:)=-transpose(TowerIMat*Res.accelTwrCOG(tt,:)');
            Res.TwrBsMtRNA(tt,:) = transpose(MtMatFull*FTwrRNA(tt,:)') + transpose(TwrMatFull*FTwrTwr(tt,:)');
        end
        else
            Res.TwrBsMtRNA = nan(length(Res.time),6);
        end
        Units.TwrBsMtRNA(1,:)={'N','N','N','N-m','N-m','N-m'};
       
        %% Extract Line Member results in the .sim
        if iRunOF
            lineGroups={[WEPname '1'],[WEPname '2'],[WEPname '3']}; % could add VB or LMB for instance
            nGroups=length(lineGroups);
            nLines=length(resh_lines);
            nDOF=6;
            Res.line_table = cell (nLines+nGroups,3);%table of line name and 6dof forces
            flineGroup=zeros(nT,nGroups*nDOF);
            iGroup=nan(nLines,1);
            for ii = 1:nLines
                line = resh_lines{ii};
                fA=zeros(nT,3); fB=zeros(nT,3);
                for kk=1:3
                    fA(:,kk) = line.TimeHistory(['End G' Xstrs{kk} '-Force'], ofx.Period(t_start, timeend), ofx.oeEndA);
                    fB(:,kk) = -line.TimeHistory(['End G' Xstrs{kk} '-Force'], ofx.Period(t_start, timeend), ofx.oeEndB);
                end
                %fAr=Rotate2DMat(fA,(Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180);
                %fBr=Rotate2DMat(fB,(Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180);
                %fline(:,1:3) = fAr + fBr;
                ma = [(line.EndAX - line.EndBX) (line.EndAY - line.EndBY) (line.EndAZ - line.EndBZ)]/2; %Positive mean A > B, line goes from B to A in positive direction, to end A is positive, to end B is negative

                fline(:,1:3) = Rotate2DMat(fA + fB, (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180) ;
                fline(:,4:6) = Rotate2DMat( cross(repmat(ma,[nT,1]), fA) + cross(repmat(-ma,[nT,1]),fB) ,  (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180 );  
                
                Res.line_table{ii,1} = ['line' line.Name];
                Res.line_table{ii,2} = fline;
                Res.line_table{ii,3} = {'N','N','N','N-m','N-m','N-m'};
                %tf = any(~cellfun('isempty',strfind(x,'xc'))) 
                for pp=1:nGroups
                    if ~isempty(strfind(line.Name,lineGroups{pp}))
                        iGroup(ii)=pp;
                    end
                end
                if ~isnan(iGroup(ii))
                    flineGroup(:,(iGroup(ii)-1)*nDOF+1:(iGroup(ii)-1)*nDOF+nDOF) = flineGroup(:,(iGroup(ii)-1)*nDOF+1:(iGroup(ii)-1)*nDOF+nDOF) + fline;
                end
                
            end
            for ii=1:nGroups
                Res.line_table{nLines+ii,1} = ['Total' lineGroups{ii}];
                Res.line_table{nLines+ii,2} = flineGroup(:,(ii-1)*nDOF+1:(ii-1)*nDOF+nDOF);
                Res.line_table{nLines+ii,3} = {'N','N','N','N-m','N-m','N-m'};
            end
        end
        if iplat && iRunOF
            for jj = 1:size(trackpointsWEP,1)
                Res.WEPtrack(:,jj) = resh_platform.TimeHistory('Sea Surface Clearance',ofx.Period(t_start,timeend),ofx.oeVessel(trackpointsWEP(jj,1),trackpointsWEP(jj,2),trackpointsWEP(jj,3))); %#ok<AGROW>
                Units.WEPtrack{1,jj}='m';
            end
            for jj = 1:size(trackpointsCOL,1)
                Res.COLtrack(:,jj) = resh_platform.TimeHistory('Sea Surface Clearance',ofx.Period(t_start,timeend),ofx.oeVessel(trackpointsCOL(jj,1),trackpointsCOL(jj,2),trackpointsCOL(jj,3))); %#ok<AGROW>
                Units.COLtrack{1,jj}='m';
            end
            for jj = 1:size(trackpointsKEEL,1)
                Res.KEELtrack(:,jj) = resh_platform.TimeHistory('Sea Surface Clearance',ofx.Period(t_start,timeend),ofx.oeVessel(trackpointsKEEL(jj,1),trackpointsKEEL(jj,2),trackpointsKEEL(jj,3))); 
                Units.KEELtrack{1,jj}='m';
            end
        end
    else
        % Simulation is unstable
    end
else
    warning('.SIM does not exist in TEMP folder')
end
end


function [Res,Units] = extractML(Res,Units,resh_lines,resh_mod,T,Wind,Ptfm,WFname,iRunOF)
nT=length(Res.waveel);
Xstrs={'X','Y','Z'};
t_start=T(1); timeend =T(2);
Res.nML=0; Res.nEC=0;
%% Extract ML/EC Lines from Model  
for jj=1:length(resh_lines)
    iML=strfind(resh_lines{jj}.Name,Ptfm.ML.Name);
    if ~isempty(iML)
        jMLname=resh_lines{jj}.Name;
        %jMLnum=str2double( jMLname(strfind(jMLname,MLname)+length(MLname):end) );
        Res.nML=Res.nML+1;
        orcaMLname{Res.nML} = jMLname;
    end
    iEC=strfind(resh_lines{jj}.Name,Ptfm.EC.Name);
    if ~isempty(iEC)
        jECname=resh_lines{jj}.Name;
        Res.nEC=Res.nEC+1;
        orcaECname{Res.nEC} = jECname;
    end
end
 %% Mooring forces 
for jj=1:(Res.nML + Res.nEC)
    if jj<=Res.nML
        jline=jj;
        jnumcell=regexp(orcaMLname{jline},'\d*','match');
        if ~isempty(jnumcell)
            jnum=str2double(jnumcell{1});
        else
            warning('Mooring Lines labeled incorrectly, use "ML#"')
            jnum = jline;
        end
        lname='ml';
        OrcaLine = resh_mod(orcaMLname{jline}); %
        charML(jj)=characterizeML(resh_mod,orcaMLname{jj},WFname,[t_start timeend]); % just based on geometry
    else
        jline=jj-Res.nML;
        jnumcell=regexp(orcaECname{jline},'\d*','match');
        if ~isempty(jnumcell)
            jnum=str2double(jnumcell{1});
        else
            warning('Electrical Cable lines labeled incorrectly, use "EC#"')
            jnum = jline;
        end
        lname='ec';
        OrcaLine = resh_mod(orcaECname{jline}); 
    end
    jls=sprintf('%s%d',lname,jnum);  
    if OrcaLine.type == 6 
        nSec=OrcaLine.NumberOfSections;
        nSeg=nan(nSec,1);
        ncumL=nan(nSec,1);
        nType=cell(nSec,1);
        %loop through each of the line sections
        for pp=1:nSec
            tmp=OrcaLine.NumberOfSegments(pp);
            nSeg(pp,1)=double(tmp);
            ncumL(pp,1)=OrcaLine.CumulativeLength(pp);  
            nType{pp,1}=OrcaLine.LineType(pp);
        end
        ncumL=[0; ncumL];
        %dX=nSeg./nL; % distance between each node
        % scalars
        Res.(jls).PreT(:,1) = OrcaLine.TimeHistory('Effective Tension',ofx.Period(0), ofx.oeEndA); %only care about the build-up!!!
        %loop through every single node
        pTDP=nan(nT,sum(nSeg)+1);
        for pp=1:sum(nSeg)+1
            %Res.(jls).AnchorEffT(:,1) = OrcaLine.TimeHistory('Effective Tension',ofx.Period(t_start,timeend), ofx.oeEndB);
            Res.(jls).EffT(:,pp) = OrcaLine.TimeHistory('Effective Tension',ofx.Period(t_start,timeend), ofx.oeNodeNum(pp)); % length= number of nodes (nseg+1)
            ArcLengthT = OrcaLine.TimeHistory('Arc Length',ofx.Period(t_start,timeend), ofx.oeNodeNum(pp));
            Res.(jls).ArcL(1,pp)=ArcLengthT(1); %its constant in time
            iType=ArcLengthT(1)>=ncumL(1:end-1) &  ArcLengthT(1) <ncumL(2:end);
            if sum(iType)==0
               %maybe you're on the last node
               iType=ArcLengthT(1)>ncumL(1:end-1) &  ArcLengthT(1) <=1.001*ncumL(2:end);
            end    
            %if pp<=sum(nSeg)
                Res.(jls).LineType{1,pp}=nType{iType}; 
            %end
            %% TDP
            pTDP(:,pp) = OrcaLine.TimeHistory('Vertical Seabed Clearance',ofx.Period(t_start,timeend), ofx.oeNodeNum(pp)); 
        end
        zGr=0.1;
        for tt=1:nT
            %go through each time step and find TDP
            tTDP = pTDP(tt,:);
            iGr=find(tTDP<zGr,1,'first');
            Res.(jls).ArcLTDP(tt,1) = Res.(jls).ArcL(1,iGr);
        end 
        %[point1s,iGrNode]=max(pTDP,[],2); % takes first occurence!
        Res.(jls).TopAngle(:,1) = OrcaLine.TimeHistory('Declination',ofx.Period(t_start,timeend), ofx.oeEndA);
        Res.(jls).UpliftAngle(:,1) = OrcaLine.TimeHistory('Declination',ofx.Period(t_start,timeend), ofx.oeEndB); 
        Res.(jls).AnchorAngle(:,1) = OrcaLine.TimeHistory('Azimuth',ofx.Period(t_start,timeend), ofx.oeEndB);
        
        % Add in other mooring line/electrical cable sensors here @Aula
    end
    for kk=1:3
        if OrcaLine.type == 6 %is a line type == 6
            %vectors
            Res.(jls).TopT(:,kk) = OrcaLine.TimeHistory(['End G' Xstrs{kk} '-Force'],ofx.Period(t_start,timeend), ofx.oeEndA);
            Res.(jls).AnchorT(:,kk) = OrcaLine.TimeHistory(['End G' Xstrs{kk} '-Force'],ofx.Period(t_start,timeend), ofx.oeEndB);
        elseif OrcaLine.type== 10 %is a spring type == 10 (calculates instantaneous force)
            Res.(jls).TopT(:,kk) = OrcaLine.TimeHistory('Tension',ofx.Period(t_start,timeend), ofx.oeEndA) .* (OrcaLine.TimeHistory(['End A ' Xstrs{kk}],ofx.Period(t_start,timeend), ofx.oeEndA) - OrcaLine.TimeHistory(['End B ' Xstrs{kk}],ofx.Period(t_start,timeend), ofx.oeEndA))./OrcaLine.TimeHistory('Length',ofx.Period(t_start,timeend), ofx.oeEndA);
        end
    end
    if iRunOF
        %rotated forces
        Res.([jls 'r']).TopT(:,1:3) = Rotate2DMat(Res.(jls).TopT(:,1:3) , (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180);
        Res.([jls 'r']).AnchorT(:,1:3) = Rotate2DMat(Res.(jls).AnchorT(:,1:3) , (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180);
    end
    Units.(jls).PreT={'N'};
    %Units.(jls).AnchorEffT={'N'};
    Units.(jls).EffT={'N'};
    Units.(jls).ArcL={'m'};
    Units.(jls).ArcLTDP={'m'};
    Units.(jls).LineType={'str'};
    Units.(jls).TopAngle={'deg'};
    Units.(jls).UpliftAngle={'deg'};
    Units.(jls).AnchorAngle={'deg'};

    Units.(jls).TopT={'N','N','N'};
    Units.(jls).AnchorT={'N','N','N'};
    %% characterize ML
    charfields=fieldnames(charML(jj));
    for qq=1:length(charfields)
        Res.(jls).(charfields{qq}) = charML(jj).(charfields{qq});
        if strcmp(charfields{qq},'R')
            Units.(jls).(charfields{qq}) = {'m'};
        elseif strcmp(charfields{qq},'Mt')
             Units.(jls).(charfields{qq}) = {'kg'};
        else
            Units.(jls).(charfields{qq}) = {'-'};
        end
    end
end

end
function charML=characterizeML(Model,MLname,WFname,T,iEC,varargin)
% return a structure with values corresponding to intrisic properties of a
% given mooring line
% End A connected to Fairlead!
% End B connected Anchor (for now..)
if nargin<5
    iEC=0; % ML by default
end
%% Orca
pnStaticState = int32(32004); %dug around in Orca-Matlab code
%% WindFloat
try
    WF=Model(WFname);
    charML.iRigid=1;
catch
    charML.iRigid=0;
end
if charML.iRigid
    X0=WF.InitialX; Y0=WF.InitialY; Z0=WF.InitialZ;

    %% Environment
    Env=Model('Environment');
    WD=Env.WaterDepth;
    %% ML
    ML=Model(MLname);
    nSec=ML.NumberOfSections;
    nSeg=nan(nSec,1);
    nL=nan(nSec,1);
    ncumL=nan(nSec,1);
    nType=cell(nSec,1);
    nMass=nan(nSec,1);
    % looping over sections
    for pp=1:nSec
        tmp=ML.NumberOfSegments(pp);
        nSeg(pp,1)=double(tmp);
        nL(pp,1)=ML.Length(pp);
        ncumL(pp,1)=ML.CumulativeLength(pp);  % could also use cumsum?
        LTstr=ML.LineType(pp);
        nType{pp,1}=LTstr;
    end
    ncumL=[0; ncumL];
    % looping over all nodes
    nNodes=sum(nSeg)+1;
    ArcL=nan(nNodes,1);
    segL=nan(nNodes-1,1);
    segArcL=nan(nNodes-1,1); % at center of segment, where lumped mass is applied
    Mass=nan(nNodes-1,1); %based on segment
    Stiff=nan(nNodes-1,1); %based on segment
    Length=nan(nNodes-1,1); % based on segment
    LineType=cell(nNodes-1,1);
    % node #1 starts at arclength=0
    Theta= ML.RangeGraph('Declination',ofx.Period(pnStaticState));
    Theta1= Theta.Mean(1)-90; % depends on the definition of the the EndA axes
    ArcLengthT= ML.TimeHistory('Arc Length',ofx.Period(pnStaticState), ofx.oeNodeNum(1));
    ArcL(1,1)=ArcLengthT(1); % 0 
    % Attachments
    NoA=ML.NumberOfAttachments; 
    cwMass=zeros(max([NoA 1]),1); %do not make an empty array
    cwArcL=zeros(max([NoA 1]),1);
    cwSegL=zeros(max([NoA 1]),1);
    bForce=zeros(max([NoA 1]),1); %do not make an empty array
    bArcL=zeros(max([NoA 1]),1);
    cc=0;
    for pp=1:nNodes-1
        %index by segment
        ArcLengthT = ML.TimeHistory('Arc Length',ofx.Period(pnStaticState), ofx.oeNodeNum(pp+1));
        ArcL(pp+1,1)=ArcLengthT(1); %it is constant, arc length of pth node
        segL(pp,1)= ArcL(pp+1,1)-ArcL(pp,1);
        segArcL(pp,1) = ArcL(pp,1) + segL(pp,1)/2;
        iType=segArcL(pp,1)>ncumL(1:end-1) & segArcL(pp,1) <ncumL(2:end);
    %     if sum(iType)==0
    %        %maybe you're on the last node
    %        iType=ArcLengthT(1)>ncumL(1:end-1) &  ArcLengthT(1) <=ncumL(2:end);
    %     end
        LTstr=nType{iType};
        LT=Model(LTstr);
        MPUL=LT.MassPerUnitLength;
        EA = LT.EA; % axial stiffness of segment
        if MPUL>=1e3
            % it is essentially a clumpweight
            cc=cc+1;
            cwArcL(cc,1)=segArcL(pp,1);
            cwSegL(cc,1)= segL(pp,1);
            cwMass(cc,1)=segL(pp,1)*MPUL;

            MPUL=0; %do not double count
        end
        Mass(pp,1)=segL(pp,1)*MPUL; % mass per segment of line (not including attachments, if there is any)
        if isnumeric(EA)
            Stiff(pp,1) = EA;
        else
            %it is a string, need to linearize lookup table somehow
            Stiff(pp,1) = NaN;
        end
    end
    bb=0;
     %% Attachements!
    for ii=1:NoA
        iAT=ML.AttachmentType(ii);
        iATobj=Model(iAT);
        aMass=iATobj.Mass; 
        aVol= iATobj.Volume; 
        aNetMass=aMass-1025*aVol;
        if aNetMass>0
            cc=cc+1;
            %it is a clumpweight
            cwArcL(cc,1)=ML.Attachmentz(ii);
            cwMass(cc,1)=aNetMass; %[kg]
        else
            bb=bb+1;
            %it is a buoyancy module
            bArcL(bb,1)=ML.Attachmentz(ii);
            bMass(bb,1)=aNetMass; %[kg] <0
            bForce(bb,1)=-aNetMass*9.8;  %[N]
        end
    end
    %% Touchdown Node!
%     MLClearance=ML.RangeGraph('Seabed Clearance',ofx.Period(pnStaticState));
        MLClearance=ML.RangeGraph('Vertical Seabed Clearance',ofx.Period(pnStaticState));

    Z = MLClearance.Mean; %, [1 x nNodes]; min, max are empty for static state
    % call touchdown first node when clearance is <= 0
    grounded=find(Z<=0.1);
    if isempty(grounded)
        grounded=length(Z);
    end
    k=grounded(1); % node number
    Lk = ArcL(k);
    %% Touchdown Node during extreme event!
%     MLClearanceFt=ML.RangeGraph('Seabed Clearance',ofx.Period(T(1),T(2)));
    MLClearanceFt=ML.RangeGraph(' Vertical Seabed Clearance',ofx.Period(T(1),T(2)));

    Zmax = MLClearanceFt.Max; %, [1 x nNodes]; min, max are empty for static state
    grmax=find(Zmax<=0.1);
    if isempty(grmax)
        grmax=length(Z);
    end
    kmax=grmax(1); % node number
    LkMax = ArcL(kmax);
    % clumpweight w.r.t. touchdown nodes
    cwgrounded=find(cwArcL>=Lk);
    if ~isempty(cwgrounded)
        cwk=cwgrounded(1); %first cw index after touchdown point
    else
        %no clumpweights
        cwk=1; %set to an index;
    end
    cwgrmax=find(cwArcL>=LkMax);
    if ~isempty(cwgrmax)
        cwkmax=cwgrmax(1); %first cw index after touchdown point
    else
        %no clumpweights
        cwkmax=1; %set to an index;
    end
    %% Post-process properties
    Lt=sum(nL); % or sum(Length) or ncumL(end)
    Mt=sum(Mass) + sum(cwMass); 
    Bt=sum(bForce); %[N]
    aX=NaN; aY=NaN; aZ=NaN; bZ=NaN; R=NaN; % need to come up with something for bridle..
    if strcmp(ML.EndAConnection,WFname)
        % you have a fairlead!
        aZ = WD+Z0+ML.EndAZ;
        % convert to global using WF orientation
        aXr=Rotate2DMat([ML.EndAX ML.EndAY],WF.InitialHeading*pi/180); % defined relative to platform
        aX=aXr(1)+X0; aY=aXr(2)+Y0; % convert to global
    end
    if strcmp(ML.EndBConnection,'Anchored')
        bX=ML.EndBX; bY=ML.EndBY; bZ=ML.EndBZ;
        dX=aX-bX; dY=aY-bY;
        R=sqrt( dX^2+dY^2);
    end
    H=aZ-bZ;

    L=sqrt(H^2+R^2);
    Lstar = (sum(Mass .* segArcL) + sum(cwMass.*cwArcL)) / Mt; % arclength where the center of mass of line is. 
    cwLstar = (sum(cwMass.*cwArcL)) / sum(cwMass); % arclength where the center of mass of the clumpweights. 
    bLstar = (sum(bForce.*bArcL)) / Bt;  
    
    % save to structure
    charML.SegArcL = segArcL;
    charML.SegL = segL;
    charML.EA=Stiff;
    charML.R = R;
    charML.Lk = Lk/Lt;
    charML.LkMax = LkMax/Lt;
    charML.Lt=Lt;
    charML.barL= (Lt-L)/(R+H-L);
    charML.Theta1=Theta1; % 'top-angle'
    charML.Mt=Mt;
    charML.cwL=sum(cwSegL);
    charML.cwMt=sum(cwMass);
    charML.Mf= (sum(Mass(1:k-1)) + sum(cwMass(1:cwk-1)) )/Mt;
    charML.MfMax=(sum(Mass(1:kmax-1))+ sum(cwMass(1:cwkmax-1)))/Mt;
    charML.Mg=( sum(Mass(k:end)) + sum(cwMass(cwk:end)))/Mt;
    charML.MgMax=(sum(Mass(kmax:end))+sum(Mass(cwkmax:end)))/Mt;
    charML.mstar=(max([Mass; cwMass]) - min(Mass) ) / max([Mass; cwMass]) ;
    charML.barLstar = (Lstar -Lk)/(Lt-Lk); % goes from 0 at touchdown point to 1 at anchor point
    charML.cwLstar = (cwLstar -Lk)/(Lt-Lk); % goes from 0 at touchdown point to 1 at anchor point
    % Buoyancy
    charML.nB=bb;
    charML.Bt=Bt;
    charML.bLstar = (bLstar -Lk)/(Lt-Lk); % goes from 0 at touchdown point to 1 at anchor point
end
end