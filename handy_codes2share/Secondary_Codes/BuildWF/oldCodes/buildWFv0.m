function buildWF(IPTfile,varargin)
% Build a semi-submersible platform in OrcaFlex!
% Written by Sam Kanner
% Copyright Principle Power Inc., 2016
%% Use an input file to specify properties of platform
if nargin>0
    iptname=IPTfile;
else
    iptname=getIPTname(mfilename);
end
run(iptname);
OForigin=X1; 
%% Define some pretty colors
    red= 0*65536+0*256+255; %red?
    orng= 0*65536+128*256+255; %
    aqua= 255*65536+255*256+0; %
    blue= 255*65536+128*256+0; %
    dblue= 255*65536+0*256+0; %
    grey=96*65536+96*256+96; % 
    white= 255*65536+255*256+255; %white
%% get Platform and Turbine properties
Ptfm=getMyPtfm(PtfmType);
nCol=length(Ptfm.Col.D); %number of columns...
Turbine=getMyTurbine(TurbineType);

%% Get Ultra-Rigid Flexible Model properties
if iAdamantium
    Turbine.Tower.E=Turbine.Tower.E*1e3; % ultra-rigid!
    Ptfm.E=Ptfm.E*1e3; % ultra-rigid!
end

%% Load Model or Make new Model
try
    Model=ofxModel(datfileIN);
    disp([datfileIN 'found. Modifying using ipt file.'])
catch
    Model=ofxModel(); %create empty model
    Model.SaveData(datfileOUT)
    warning([datfileIN ' not found. Starting from scratch.'])
end
%% Change the units to SI!! 
general=Model('General');
general.UnitsSystem='User';
general.LengthUnits='m';
general.MassUnits='kg';
general.ForceUnits='N';
%% Time-stepping stuff
general.LogPrecision='Double';
general.ImplicitTolerance=0.00025;
general.SpectralDensityFundamentalFrequency=0.0005;
%% Load WEP -> defined as a vector of 3D points  (not using KBs so far)
if iWEP
    [WEPpts, WEPlabels,KBpts,KBlabels]=getMyWEP(WEPtype,Ptfm,[-2*Ptfm.Col.Lh/3 0 0]); %defined in the global coordinate
end
if iplot && iWEP
    plotMyWEP(WEPpts,WEPlabels,Ptfm);
end
%% Add LineType properties 
% Cols
ColNames=setCOLLineTypes(Model,Ptfm,iRigid,CaCOL);
% LMBs, UMBs, VBs
TrussNames=setTrussLineTypes(Model,Ptfm,mult,iRigid); %'LMB', 'UMB', 'VBr'
% WEPs
if iWEP
    [WEPNames,CdOrca,WEParea,Cas,CaCtr,TotalAddedM]=setWEPLineType(Ptfm,WEPtype,WEPpts,WEPlabels,nUwep,nX,specWEP,CaWEP,CdWEP,1,Model,iRigid,iWEB) ;
end

% Towers
TowerNames=setTurbineLineTypes(Model,Turbine,iRigid);

%% Rotate Lines (not really necessary, since we'll keep heading to 0)
if iWEP
    WEPpts=Rotate2DMat(WEPpts,-Ptfm.Heading*pi/180);
    %KBpts=Rotate2DMat(KBpts,-Ptfm.Heading*pi/180);
end
Model.SaveData(datfileOUT)

if iRigid
    %setVesselName
    vname='Platform';
else
    vname='';
end

% if strcmp(origin,'Col1')
%     OForigin=[Ptfm.Col.Lh*2/3,0,0]; % is on Col 1
% else
%     OForigin=[0,0,0];
% end
%% Define Col coordinates 

% %loop through all columns
% ColX=zeros(nCol,3);
% Xt=zeros(nCol,3);
% Xb=zeros(nCol,3);
% 
% %% Define two 'cursors' to use when building the columns and buoys 
% %Xt(1,:)=; %current position of top pointer = Col1
% Xt(1,:)=Rotate2DMat(Col1U,-Ptfm.Heading*pi/180); %current position of top pointer = Col1
% %Xb(1,:)= %current position of bottom pointer = Col1
% Xb(1,:)=Rotate2DMat(Col1L,-Ptfm.Heading*pi/180); %current position of bottom pointer = Col1
% 
% %% Define column coordinates
% ColX(1,:)=[Xb(1,1:2) 0];
% %% Define vector angles, positions, (in global system, from 1->2, 2->3, 3-> 1)
WFangles=Ptfm.Col.Az;%[150 270 30]*pi/180 -Ptfm.Heading*pi/180; % equilateral triangle, should be related to Ptfm.Col.L 
% for iC=2:nCol
%     % Get [X,Y] distance to next column
%      newX=[Ptfm.Col.L*cos(WFangles(iC-1)),Ptfm.Col.L*sin(WFangles(iC-1)),0];
%      % Advance cursors
%      Xb(iC,:)=Xb(iC-1,:)+newX;
%      Xt(iC,:)=Xt(iC-1,:)+newX;
%      % Set next column coordinates
%      ColX(iC,:)=[Xb(iC,1:2) 0]; 
% end
% TRpts, like WEPpts is a 3D vector defining the beginning and end
% of each line segement to build
% Geometry of WindFloat model is defined in getMyTruss for
% arbitrary discretiztion and number of VBs.
[TRpts,TRlabels]=getWFpts(nLevel,PtfmType,X1,iRigid,iplot);

%% Find COLs top + bottom + SWL
iColA=find(~cellfun('isempty',strfind(TRlabels,'COL')));
iColB=iColA+1;
Xt=TRpts(iColA,:);
Xb=TRpts(iColB,:);


ColX=[TRpts(iColA,1:2) zeros(nCol,1)]; % at the waterline
if OFver>=10
    Col1U=Xt;%[Ptfm.Col.Lh*2/3,0,0]-OForigin; % build the 'ColX U' 6D buoy at the SWL (that is where 'other damping' is applied in rigid model
    Col1L=Xb;%[Ptfm.Col.Lh*2/3,0,Ptfm.Col.Draft]-OForigin; % build the 'ColX L' 6D buoy at the keel
else
    Col1U=Xt + repmat([0 0 Ptfm.UMB.dL],[nCol,1]) + [0 0 Ptfm.iCol.dL;zeros(nCol-1,3)] ;%[Ptfm.Col.Lh*2/3,0,Ptfm.Col.H+Ptfm.Col.Draft-Ptfm.UMB.dL]-OForigin; % build the 'ColX U' 6D buoy at connection of UMB and ColX
    Col1L=Xb + repmat([0 0 Ptfm.LMB.dL],[nCol,1]);%[Ptfm.Col.Lh*2/3,0,Ptfm.Col.Draft+Ptfm.LMB.dL]-OForigin; % build the 'ColX U' 6D buoy at connection of LMB and ColX
end


%[TRpts,TRlabels]=getMyTruss(linenames,nLevel,Ptfm,ColX,iRigid); % todo: get rid of ColX   
for ibuild=1:2 % need to go through the build twice (something weird in orcaflex about setting coordinates relative on the first build)
   %% Build the trusses, COL,UMB, LMB, VBr
     if OFver>=10
        % Lines can be built before buoys since, the lines are have 'free' ends in OFver>=10 (with line-to-line connections) 
        % Linetypes, line sections, segments and actually building of model
        % performed in buildTrusses
        Model=buildWFTrusses(Model,Ptfm,WEPtype,mult,TRpts,TRlabels,fliplr(WFangles),vname,iRigid,OFver); %flip WFangles due to line az definition
     end  
     %% Build 6DOF buoys or the vessel
    if ~iRigid
         for iC=1:nCol
             iCn=mod(iC,nCol)+1;
              MOI=[0 0 0];
              if OFver>=10
                  iColN=sprintf('COL%d',iC); % connect the buoy to the line (already built)
                  mCol=Model(iColN);
                  connect=iColN;
                  Xr(1)=mCol.EndAX; Xr(2)=mCol.EndAY; Xr(3)=mCol.EndAZ; % I could use getRelX function?
                  
                  XU=Xr-Xt(iC,:); % position of upper buoy  (relative to line)
                  XL=Xr-Xb(iC,:); % position of lower buoy (relative to line)
                  
              else 
                  connect='free';
                  XU=Xt(iC,:);
                  XL=Xb(iC,:);
              end            
              % Actually build the buoys
              buoyU=buildOrca6buoy(Model,sprintf('Col%d U',iC),connect,XU,1e-6,MOI,[0 0 0],red,[0 0 -.2]); 
              buoyL=buildOrca6buoy(Model,sprintf('Col%d L',iC),connect,XL,1e-6,MOI,[0 0 0],dblue) ;
              % ADD SOME LINEAR DAMPING
              if OFver>=10
                  BLD=buoyL; % name of the buoy to add the linear damping to
              else
                  BLD=buoyL;
                  %also add the free buoy representing the K-joint
                  buoyLMB=buildOrca6buoy(Model,sprintf('LMB%d%d',iC,iCn),connect,mean([Xb(iC,:); Xb(iCn,:)],1),1e-6,MOI,[0 0 0],orng) ;

              end
              % Add the linear damping (number come from trial and error of
              % OF models)
              if iLD
                  if exist('LD','var')
                      BLD.UnitDampingForceX=LD(1); BLD.UnitDampingForceY=LD(2); BLD.UnitDampingForceZ=LD(3);
                      BLD.UnitDampingMomentX=LD(4); BLD.UnitDampingMomentY=LD(5); BLD.UnitDampingMomentZ=LD(6); 
                  else
                    disp(['Using Linear Damping Values found in ' PtfmType '_Ptfm.xlsx'])
                    BLD.UnitDampingForceX=Ptfm.LinDampingX(1)/3; BLD.UnitDampingForceY=Ptfm.LinDampingX(2)/3; BLD.UnitDampingForceZ=Ptfm.LinDampingX(3)/3;
                    BLD.UnitDampingMomentX=Ptfm.LinDampingRx(1)/3; BLD.UnitDampingMomentY=Ptfm.LinDampingRx(2)/3; BLD.UnitDampingMomentZ=Ptfm.LinDampingRx(3)/3;
                  end
              end
          end 
         
    else
        %build the vessel -> how can I easily import all of the data into
        %the vessel?       
        buildMyVessel(Model,vname,[0 0 0 0 0 0],Xt,Xb,iFAST,iRigid)
        setVesselType(Model,vname,Ptfm,LD);
    end
     % If we haven't done so already, build the trusses, COL,UMB, LMB, VBr
     if OFver<10
        Model=buildWFTrusses(Model,Ptfm,WEPtype,mult,TRpts,TRlabels,WFangles,vname,iRigid,OFver); 
     end  
     %% Build the RNA (other free buoy)
     if iTurbine
        TowerL=sum(Turbine.Tower.H); % [m] total length of the tower
        TOWpos=Turbine.Tower.Z(1); % height of beginning of tower 
        RNApos=[0 0 TOWpos+TowerL]; %Not sure if this is right. It is located directly at the top of the tower
        if ~iRigid
            if min(size(Turbine.RNA.I))>1
                TurbineI=diag(Turbine.RNA.I);
            else
                TurbineI=Turbine.RNA.I;
            end
            RNA=buildOrca6buoy(Model,'RNA','Free',RNApos,Turbine.RNA.M,TurbineI,Turbine.RNA.COG-[0 0 RNApos(3)],white);
        else
            RNA=buildOrca6buoy(Model,'RNA',vname,RNApos,1e-6,zeros(1,3),Turbine.RNA.COG-[0 0 RNApos(3)],white);
        end
    %buoy=buildOrca6buoy(Model,'RNA','Fixed',[0 0 -100],Turbine.RNA.M,MOI,Turbine.RNA.COG-[0 0 RNApos(3)],pcolor);
    end

    %% Build the WEPs + KBs
    if iWEP
        WEPname=''; %base name of the WEP lines
        FASTorigin=ColX(1,:); % FAST/WEP spreadsheet origin: [0,0,0] is Col 1..
        % Transform excel spreadsheet coordinate system to OrcaFlex coordinate
        % system
        WEPpts=WEPpts+repmat(FASTorigin,[length(WEPpts) 1]); %Must translate WEPpts to get [0,0,0] = platform center
        %KBpts=KBpts+repmat(FASTorigin,[length(KBpts) 1]);
        if OFver>=10
            WEPStiff.AX=ofx.OrcinaInfinity(); % [N-m/deg] Why 0?
            WEPStiff.BX=ofx.OrcinaInfinity(); % [N-m/deg] Why 0?
            WEPStiff.EndATwistingStiffness=ofx.OrcinaInfinity(); % 
            WEPStiff.EndBTwistingStiffness=ofx.OrcinaInfinity(); %
        else
            WEPStiff.AX=0; % [N-m/deg] 0 if both lines are fixed to a different body
            WEPStiff.BX=0; % [N-m/deg] 

        end
        nWEPs=length(WEPpts)/2; %number of line segments ( 2 endpts per line )
        nWEPc=nWEPs/nCol; % number of lines per column
        % Make the lines in the model 
        mylength=zeros(nWEPs,1);
        myaz=zeros(nWEPs,1);
        for kk=1:nWEPs
            iendA=2*(kk-1)+1;
            iendB=2*(kk-1)+2;
            myaz(kk)=mod(atan2(WEPpts(iendB,2)-WEPpts(iendA,2),WEPpts(iendB,1)-WEPpts(iendA,1))*180/pi,360);
            dec0=90; %90 for y pointing up, 90 for x pointing down
            gam0=90; %90 for y pointing up, 0 for x pointing down
            WEPOrient.az=myaz(kk); % default angles, may get overwritten in flexible WEP
            WEPOrient.dec=dec0; %
            WEPOrient.gam=gam0; %
            iC=ceil(kk/nWEPc); % number of column
            
            kCol=sprintf('Col%d L',iC); % need to change position relative to column
            Aname=WEPlabels{iendA};
            lname=[WEPname Aname];
            if ~iRigid
                if iRigidWEP || OFver<10
                    myCol=Model(kCol); Colk(1)= myCol.InitialX ; Colk(2)= myCol.InitialY ; Colk(3)= myCol.InitialZ;
                    AXr=Colk;%[Colk(1:2) WEPpts(iendA,3)]; % z needs to be 0 relative to the col
                    BXr=Colk;%[Colk(1:2) WEPpts(iendB,3)];
                    ConnectA=kCol;
                    ConnectB=kCol;
                    AX=getRelX(Model,ConnectA,WEPpts(iendA,:));
                    BX=getRelX(Model,ConnectB,WEPpts(iendB,:));
                else
                    % Lots of TRIAL AND ERROR to get proper line end
                    % orientation of WEP lines when they are free at one end
                    % (since the line orientation is defined relative to the
                    % one it is connected to)
                    switch WEPtype
                        case 'PAH'
                            if strcmp(Aname(end-1:end),'AA')
                                ConnectA='Free';
                                ConnectB=kCol;
                                AX=WEPpts(iendA,:);
                                BX=getRelX(Model,ConnectB,WEPpts(iendB,:));
                            elseif strcmp(Aname(end-1:end),'AB')
                                ConnectA=kCol;
                                ConnectB='Free';
                                AX=getRelX(Model,ConnectA,WEPpts(iendA,:));
                                BX=WEPpts(iendB,:);
                            elseif strcmp(Aname(end),'H')
                                ConnectA=[WEPname WEPlabels{iendA-2}];
                                ConnectB=sprintf('%s%d%s',WEPname,iC,'AA');
                                AX=[0 0 mylength(kk-1)];
                                BX=[0 0 0];
                                [az2,dec2,gam2]=getaz(myaz(kk),dec0,gam0,myaz(kk-1),0,gam0); % dec1= 0 for y pointing up
                                WEPOrient.az.A=az2;
                                WEPOrient.dec.A=dec2;
                                WEPOrient.gam.A=gam2;
                                AA=Model(ConnectB);
                                [az1,dec1,gam1]=getaz(myaz(kk),dec0,gam0,AA.EndAAzimuth,AA.EndADeclination,AA.EndAGamma);
                                WEPOrient.az.B=180;
                                WEPOrient.dec.B=dec1;
                                WEPOrient.gam.B=180;
                            else
                                ConnectA=[WEPname WEPlabels{iendA-2}];
                                AX=[0 0 mylength(kk-1)];
                                ConnectB='Free';
                                BX=WEPpts(iendB,:);
                                [az,dec,gam]=getaz(myaz(kk),dec0,gam0,myaz(kk-1),0,gam0);% dec1= 0 for y pointing up
                                WEPOrient.az.A=az;
                                WEPOrient.dec.A=dec;
                                WEPOrient.gam.A=gam;
                                WEPOrient.az.B=myaz(kk);
                                WEPOrient.dec.B=dec0;
                                WEPOrient.gam.B=gam0;
                            end
                            
                        case 'HAN'
                            if strcmp(Aname(end-1:end),'AA')
                                ConnectA='Free';
                                ConnectB=kCol;
                                AX=WEPpts(iendA,:);
                                BX=getRelX(Model,ConnectB,WEPpts(iendB,:));
                            elseif strcmp(Aname(end-1:end),'AB')
                                ConnectA=kCol;
                                ConnectB='Free';
                                AX=getRelX(Model,ConnectA,WEPpts(iendA,:));
                                BX=WEPpts(iendB,:);
                            elseif strcmp(Aname(end),'H')
                                WEPstart=WEPlabels{iendA};
                                WEPstr=WEPstart(1:3);
                                ConnectA=[WEPname WEPlabels{iendA-2}];
                                ConnectB=sprintf('%s%d%s',WEPstr,iC,'AA');
                                AX=[0 0 mylength(kk-1)];
                                BX=[0 0 0];
                                [az2,dec2,gam2]=getaz(myaz(kk),dec0,gam0,myaz(kk-1),0,gam0); % dec1= 0 for y pointing up
                                WEPOrient.az.A=az2;
                                WEPOrient.dec.A=dec2;
                                WEPOrient.gam.A=gam2;
                                AA=Model(ConnectB);
                                [az1,dec1,gam1]=getaz(myaz(kk),dec0,gam0,AA.EndAAzimuth,AA.EndADeclination,AA.EndAGamma);
                                WEPOrient.az.B=180;
                                WEPOrient.dec.B=dec1;
                                WEPOrient.gam.B=180;
                            else
                                ConnectA=[WEPname WEPlabels{iendA-2}];
                                AX=[0 0 mylength(kk-1)];
                                ConnectB='Free';
                                BX=WEPpts(iendB,:);
                                [az,dec,gam]=getaz(myaz(kk),dec0,gam0,myaz(kk-1),0,gam0);% dec1= 0 for y pointing up
                                WEPOrient.az.A=az;
                                WEPOrient.dec.A=dec;
                                WEPOrient.gam.A=gam;
                                WEPOrient.az.B=myaz(kk);
                                WEPOrient.dec.B=dec0;
                                WEPOrient.gam.B=gam0;
                            end    
                        case 'foo'
                            % for another type of WEP, probably have to define
                            % the connections and orientations differently
                        otherwise
                            error('Define how you want to make your WEP connections')
                    end
                end
            else
                % connect them to the vessel
                ConnectA=vname;
                ConnectB=vname;
                AX=getRelX(Model,ConnectA,WEPpts(iendA,:));
                BX=getRelX(Model,ConnectB,WEPpts(iendB,:));
            end
            mylength(kk)=sqrt(  sum( (WEPpts(iendA,:)-WEPpts(iendB,:)).^2) ); %exactly the distance between the 2 nodes
            %default WEPtype
            defWEPtype=min([iC nUwep]); 
            nWEPtypes=length(WEPNames)-1-1*iWEB;
            % WEPs just consist of 1 segment!!
                if strcmp(Aname(end-1:end),'EA') && strcmp(WEPtype,'PAH')
                    if OFver>=10
                        jlens=[Ptfm.(WEPtype).LMB.L mylength(kk)-Ptfm.(WEPtype).LMB.L] ; % add node for Web connection
                    else
                        jlens=mylength(kk);
                    end
                    TSL=jlens*1;
                    WEPLtype=2;
                elseif strcmp(Aname(end-1:end),'EB') && strcmp(WEPtype,'PAH')% && iC<3 ) || (strcmp(Aname(2:end),'EA') && iC==3 )  
                    if OFver>=10
                        jlens=[mylength(kk)-Ptfm.(WEPtype).LMB.L Ptfm.(WEPtype).LMB.L] ;
                    else
                        jlens=mylength(kk);
                    end
                    TSL=jlens*1;
                    WEPLtype=2;                    
                elseif sum(strcmp(Aname(end-1),specWEP))
                    jlens=mylength(kk);
                    WEPLtype=defWEPtype+nUwep ;
                    TSL=jlens;
                else
                    jlens=mylength(kk);
                    TSL=jlens;
                    WEPLtype=defWEPtype;
                end

            for jj=1:length(jlens)
                WEPStruct(jj).LineType=WEPNames{WEPLtype};
                WEPStruct(jj).TargetSegmentLength=TSL(jj);
                WEPStruct(jj).Length=jlens(jj);
                WEPLtypeModel=Model(WEPNames{WEPLtype});
                WEPmassSeg(kk,jj)=jlens(jj)*WEPLtypeModel.MassPerUnitLength;
            end
            myWEP=buildOrcaLine(Model,lname,ConnectA,ConnectB,AX,BX,WEPOrient,WEPStiff,WEPStruct);
            myWEP.DrawNodesAsDiscs='Yes';
            clear WEPStruct WEPOrient
        end
        WEPmass=sum(WEPmassSeg,2);
    else
        WEPmass=sum(nWEPs,2);
    end
   %% Build the Tower !!!
   if iTurbine
       if OFver>=10
        TROrient.az.A=0; TROrient.dec.A=180; TROrient.gam.A=0; % build from the top bottom
        TROrient.az.B=0; TROrient.dec.B=0; TROrient.gam.B=0;
       else
           TROrient.az=0; TROrient.dec=180; TROrient.gam=0;
       end
        if iRigid
            TRStiff.AX=0; % [N-m/deg] 
            TRStiff.BX=0; % [N-m/deg] 
        else
            TRStiff.AX=ofx.OrcinaInfinity(); % [N-m/deg] 
            TRStiff.BX=ofx.OrcinaInfinity(); % [N-m/deg] 
        end  

       
        if ~iRigid
             nTow=length(Turbine.Tower.H);
        else
            nTow=length(TowerNames);
        end
        TowerSecMass=zeros(nTow,1);
        for jj=1:nTow
            TowStruct(jj).LineType=TowerNames{nTow-jj+1};
            TowerType=Model(TowStruct(jj).LineType);
            TowerMPUL=TowerType.MassPerUnitLength;
            if ~iRigid
                TowStruct(jj).Length=Turbine.Tower.H(nTow-jj+1);
            else
                TowStruct(jj).Length=sum(Turbine.Tower.H);
            end
            
            TowerSecMass(jj)=TowStruct(jj).Length*TowerMPUL;
            TowStruct(jj).TargetSegmentLength=TowStruct(jj).Length;
        end
        TowerMass=sum(TowerSecMass);
    %    myTower=buildOrcaLine(Model,'Tower','RNA','Col1 U',[0 0 0],[0 0 Ptfm.iCol.dL+Ptfm.UMB.dL],TROrient,TRStiff,TowStruct);
        if OFver>=10
            twrcnct='COL1';
            twrX=[0 0 0];
        else
            twrcnct='Col1 U';
            twrX=[0 0 Ptfm.iCol.dL+Ptfm.UMB.dL];
        end
        
        if ~iRigid
            myTower=buildOrcaLine(Model,'Tower','RNA',twrcnct,[0 0 0],twrX,TROrient,TRStiff,TowStruct);
            myTower.IncludeTorsion='Yes';
            myTower.EndATwistingStiffness = ofx.OrcinaInfinity();
            myTower.EndBTwistingStiffness = ofx.OrcinaInfinity();
        else
            twrX=Xt(1,:);% inner shaft is already extended to tower flange+[0 0 Ptfm.iCol.dL]
            if iFAST
                myTower=buildOrcaLine(Model,'Tower','Platform','Platform',[0 0 0],twrX,TROrient,TRStiff,TowStruct(1));
            else
                myTower=buildOrcaLine(Model,'Tower','Platform','Platform',twrX,twrX+[0 0 sum(Turbine.Tower.H)],TROrient,TRStiff,TowStruct(2));
            end
        end
        myTower.IncludeSeabedFrictionInStatics='No';
        %% Build the point masses on the towers (as clump weights)
        if ~iRigid
            Col1N=myTower.EndBConnection;
            Col1=Model(Col1N);
            if OFver>=10
                zCol1=Col1.EndAZ; 
            else
                zCol1=Col1.InitialZ; %it is not the top of Col 1
            end
            zTowR=myTower.EndAZ; % [m]
            RNAN=myTower.EndAConnection;
            kRNA=Model(RNAN);
            zTowAbs=kRNA.InitialZ; % [m]
            iClear=1; % clear the clumpweights attached to the line on the first pass through, and then reattach them again
            for jj=1:length(Turbine.Flange.Z)
                MOIFl=[0 0 0]; %TOTAL BS
                dc=round(255/length(Turbine.Flange.Z));
                pcolor=(dc*jj)*65536+0*256+255-dc*jj;
                %buoy=buildOrca6buoy(Model,['Tower-' Turbine.Flange.Name{jj}],'Tower',[0 0 zTowAbs+zTowR-Turbine.Flange.Z(jj)],Turbine.Flange.M(jj),MOIFl,[0,0,0],pcolor);
                if iscell(Turbine.Flange.Name)
                    cname=['Tower-' Turbine.Flange.Name{jj}];
                else
                    cname=['Tower-' Turbine.Flange.Name(jj,:)];
                end
                cZ=max([zTowAbs-Turbine.Flange.Z(jj),0]); % bottom flange starts base of tower, but we are building top down
                clump=buildAndAttachClump(Model,cname,cZ,Turbine.Flange.M(jj),'Tower',iClear,pcolor);
                iClear=0;
                %buoy=buildOrca6buoy(Model,['Tower-' Turbine.Flange.Name{jj}],'COL1',[0 0 sum(Turbine.Tower.H)-(Turbine.Flange.Z(jj)-Turbine.Tower.Z(1))],Turbine.Flange.M(jj),MOIFl,[0,0,0],pcolor);
            end
        end
   end
   %% Modify the Mooring
   mod_obj = Model.objects;
   iML=strncmp(cellfun(@(x) x.Name, mod_obj, 'UniformOutput', false),MLname,2);
   ModML = mod_obj(iML); 
   nML=length(ModML);
   if iRigid
       iAngles=pi - (Ptfm.Col.Angle+Ptfm.Col.Angle([2 3 1]))/2;
       iAngles=cumsum(iAngles);
       iAngles=iAngles([3 1 2]);
   else
       iAngles=(Ptfm.Col.Angle+Ptfm.Col.Angle([2 3 1]))/2;
       iAngles=cumsum(iAngles)+[0 pi 0];
       iAngles=iAngles([3 1 2]);
   end
   for jj=1:nML
       jML=Model(ModML{jj}.Name);
      if jj<=3 
         colR=Ptfm.Col.D(jj)/2;
         jAngle=iAngles(jj);
         if iRigid
            xA=ColX(jj,:)+colR*[cos(jAngle) sin(jAngle) 0]+[0 0 -Ptfm.Col.Draft];
         else                 
            xA=colR*[cos(jAngle) sin(jAngle) 0]+[0 0 Ptfm.Col.H];
         end
         jML.EndAX=xA(1); jML.EndAY=xA(2); jML.EndAZ=xA(3);
      end
   end
   %% Build the point masses on the columns (representing the OS and the flats, etc) and ballasts!!
    if ~iRigid
        if isfield(Ptfm,'Secondary')
            nXtra=length(Ptfm.Secondary.M);
        else
            nXtra=0;
        end
        if isfield(Ptfm.Col,'MM')
            [nMass,nCol]=size(Ptfm.Col.MM);
            maxm=max(max(Ptfm.Col.MM));
            minm=min(min(Ptfm.Col.MM));
        else
            minm=0;
            maxm=Ptfm.Mass;
        end
        iClear=ones(nCol,1);  % clear the clumpweights attached to the line on the first pass through, and then reattach them again
        for kk=1:nCol
            kColN=sprintf('COL%d',kk); % get the column line
            kCol=Model(kColN);
            if isfield(Ptfm.Col,'MM')
                for jj=1:nMass
                     MOICol=[0 0 0]; %TOTAL BS
                    if ~isnan(Ptfm.Col.MM(jj,kk))
                        %Sec OS,flats, etc
                        pout=linmap( [minm maxm], [255 0],Ptfm.Col.MM(jj,kk));
                        pcolor=0*65536+round(pout)*256+255; % b, g, r
                        %zM=zAbs+zR-Ptfm.Col.MZ(jj,kk);
                        Xrel=getRelX(Model,kColN,[ColX(kk,1:2) Ptfm.Col.MZ(jj,kk)]);
                        cname=sprintf('Col%d-%s',kk,Ptfm.Col.MN{jj,kk});
                        clump=buildAndAttachClump(Model,cname,Xrel(3),Ptfm.Col.MM(jj,kk),kColN,iClear(kk),pcolor);
                        iClear(kk)=0;
                    end
                end
            end
           % Secondary stuff: equipment, piping (smear over all 3 cols)
            for jj=1:nXtra
                pcolor=0*65536+153*256+76; % b, g, r
                if iscell(Ptfm.Secondary.M)
                    SecondaryZ=Ptfm.Secondary.M{jj,3};
                    SecondaryMass=Ptfm.Secondary.M{jj,2};
                    SecondaryName=Ptfm.Secondary.M{jj,1};
                else
                    SecondaryZ=Ptfm.Secondary.Z(jj);
                    SecondaryMass=Ptfm.Secondary.M(jj);
                    SecondaryName=Ptfm.Secondary.N{jj};
                end
                Xrel=getRelX(Model,kColN,[ColX(kk,1:2) SecondaryZ]);
                %zM=zAbs+zR-Ptfm.Secondary.Z(jj);%+Ptfm.Col.Draft+Ptfm.Col.H;
                cname=sprintf('%s-Col%d',SecondaryName,kk);
                clump=buildAndAttachClump(Model,cname,Xrel(3),SecondaryMass,kColN,iClear(kk),pcolor);
                if ~isfield(Ptfm.Col,'MM')
                    iClear(kk)=0;
                end
            end
            
            % build an extra buoy to take up all the extra mass in the inner col 
            NoS=kCol.NumberOfSections;
            pp=0;
            for jj=1:NoS
                jLTn=kCol.LineType(jj);
                if ~isempty(strfind(jLTn,'Col'))
                    pp=pp+1;
                    jLT=Model(jLTn);
                    jZ=kCol.Length(jj);
                    jMPUL=jLT.MassPerUnitLength;
                    ColM(pp,kk)=jMPUL*jZ;
                end
            end
%             kLTypeN=kCol.LineType(1);
%             kLType=Model(kLTypeN);
%             kMPUL=kLType.MassPerUnitLength;
%             dCol1M=kMPUL*(Ptfm.UMB.dL+Ptfm.iCol.dL); %[kg]


            % add some extra mass back in
%             if isfield(Ptfm.Col,'MM')
%                 acctMass=nansum(Ptfm.Col.MM(:,kk));
%             else
%                 acctMass=0;
%             end
%             if isfield(Ptfm.Col,'M')
%                 colTotMass=Ptfm.Col.M(kk);
%             else
%                 colTotMass=0;%(Ptfm.MassNoTurbine*.88)/3; %TowerMass-Turbine.RNA.M-sum(Turbine.Flange.M)
%             end
%             xtraM=colTotMass-(kk==1)*(TowerMass*0.27)-sum(ColM(:,kk),1)-acctMass; %TowerMass+Turbine.RNA.M+sum(Turbine.Flange.M)
%             pout=linmap( [minm maxm], [255 0],xtraM);
%             pcolor=0*65536+round(pout)*256+255; % b, g, r
%             %zM=zAbs+zR-Ptfm.iCol.MZ(kk);%+Ptfm.Col.Draft+Ptfm.Col.H;
%             if isfield(Ptfm.Col,'MZ')
%                 Xrel=getRelX(Model,kColN,[ColX(kk,1:2) Ptfm.iCol.MZ(kk)]);
%                 clumpN=sprintf('Col%d-%s',kk,Ptfm.iCol.MN{kk});
%             else
%                 Xrel=[0 0 Ptfm.Col.zh-Ptfm.COG(3)];
%                 clumpN=sprintf('Col%d-%s',kk,'Mass');
%             end
%             clump=buildAndAttachClump(Model,clumpN,Xrel(3),xtraM,kColN,iClear(kk),pcolor);
        %% If there's no WEP add mass of WEP as clumpweight
        colHs=sum(Ptfm.iCol.H); %total height of the columns
            if ~iWEP
                WEPclump=buildAndAttachClump(Model,sprintf('WEP%d',kk),colHs(kk),Ptfm.(WEPtype).M,kColN,iClear(kk),grey);
%             elseif isfield(Ptfm.(WEPtype),'M')
%                 if max(WEPmass)>0
%                     if length(Ptfm.(WEPtype).M)>1
%                         XtraWEPmass=Ptfm.(WEPtype).M(kk)-WEPmass(kk);
%                     else
%                         XtraWEPmass=Ptfm.(WEPtype).M-WEPmass(kk);
%                     end
%                     WEPclump=buildAndAttachClump(Model,sprintf('WEP%d-Xtra',kk),colHs(kk),XtraWEPmass,kColN,iClear(kk),grey);
%                 %
%                 end
            end
            %% Ballasts! build Permanent and active ballasts
            % Active
            if isfield(Ptfm,'ABallast')
                kCOG=Ptfm.ABallast.X(:,kk)'-OForigin;
                Xrel=getRelX(Model,kColN,[ColX(kk,1:2) kCOG(3)]);
                %Xrel= [kCOG(1:2)-ColA(1:2) zAbs+zR-kCOG(3)];%+Ptfm.Col.Draft+Ptfm.Col.H];
                clump=buildAndAttachClump(Model,sprintf('%s-Col%d','AB',kk),Xrel(3),Ptfm.ABallast.M(kk),kColN,iClear(kk),aqua);
            end
%             buoy=buildOrca6buoy(Model,sprintf('%s-Col%d','AB',kk),kColN,...
%                             [0 0 Xrel(3)],Ptfm.ABallast.M(kk),MOI,[Xrel(1:2) 0],aqua) ;
            %Permanent Ballast (add in the weight of the turbine, if you
            %want to build the model without the turbine)
            if isfield(Ptfm,'PBallast')
                if iTurbine
                    kCOG=Ptfm.PBallast.X(:,kk)'-OForigin;
                    PBM=Ptfm.PBallast.M(kk);
                else
                    kCOG=[ Ptfm.PBallast.X(1:2,kk)' Ptfm.PBallast.X(3,2)]-OForigin;
                    PBM=Ptfm.PBallast.M(2);
                end
                %Xrel= [kCOG(1:2)-ColA(1:2) zAbs+zR-kCOG(3)];%+Ptfm.Col.Draft+Ptfm.Col.H];
                Xrel=getRelX(Model,kColN,[ColX(kk,1:2) kCOG(3)]);
                clump=buildAndAttachClump(Model,sprintf('%s-Col%d','PB',kk),Xrel(3),PBM,kColN,iClear(kk),blue);
            end
%             buoy=buildOrca6buoy(Model,sprintf('%s-Col%d','PB',kk),kColN,...
%                             [0 0 Xrel(3)],Ptfm.PBallast.M(kk),MOI,[Xrel(1:2) 0],blue) ;
            % Mooring point mass
            if iMoor
                nMoor=length(Ptfm.Mooring.M);
                buoy=buildOrca6buoy(Model,sprintf('%s-%d','Mooring',kk),kColN,...
                    [0 0 -Ptfm.Mooring.Z(kk)+Ptfm.Col.Draft+Ptfm.Col.H],Ptfm.Mooring.M(kk),MOICol,[0,0,0],grey); 
            end
        end

    end
    %% Build Links betwen WEP and LMB
    if OFver>=10 && iWEB
        lnkn='Web'; %base name
        lmbS={'a','b'};
        wepS={'A','B'};
        desaz=0;
        desdec=180; %[deg]
        desgam=0; %[deg] 
        WEBStiff.AX=ofx.OrcinaInfinity(); % [N-m/deg] 
        WEBStiff.BX=ofx.OrcinaInfinity(); % [N-m/deg] 
        WEBStiff.EndATwistingStiffness=ofx.OrcinaInfinity(); % 
        WEBStiff.EndBTwistingStiffness=ofx.OrcinaInfinity(); % 
        for jj=1:nCol
            jN=mod(jj+1,nCol)+1;
            for kk=1:2
                lmbN= jj*(kk==1) + jN*(kk==2);
                lname=sprintf('%s %d%s',lnkn,jj,lmbS{kk});
                ConnectA=sprintf('LMB%d%s',lmbN,lmbS{kk});
                LMBa=Model(ConnectA);
                [azA,decA,gamA]=getaz(desaz,desdec,desgam,LMBa.EndAAzimuth,LMBa.EndADeclination,LMBa.EndAGamma);
                WEBOrient.az.A=180;%azA;
                WEBOrient.dec.A=90;%decA;
                WEBOrient.gam.A=-180;%gamA;

                %LMBaL=LMBa.CumulativeLength(end);
                ConnectB=sprintf('WEP %dE%s',jj,wepS{kk});
                WEPb=Model(ConnectB);
                [azB,decB,gamB]=getaz(desaz,desdec,desgam,WEPb.EndAAzimuth,WEPb.EndADeclination,WEPb.EndAGamma);
                WEBOrient.az.B=270;%azB;
                WEBOrient.dec.B=90;%decB;

                WEPbL=WEPb.CumulativeLength(end);
                WEBStruct(1).LineType=WEPName{3};
                WEBStruct(1).TargetSegmentLength=Ptfm.LMB.dL*1;
                WEBStruct(1).Length=Ptfm.LMB.dL*1.0; 

                if kk==1
                    AX=[0 0 sum(LMBa.Length(1:4))];
                    BX=[0 0 Ptfm.(WEPtype).LMB.L];

                    WEBOrient.gam.B=300;
                elseif kk==2
                    AX=[0 0 sum(LMBa.Length(1:2))];
                    BX=[0 0 WEPbL-Ptfm.(WEPtype).LMB.L];

                    WEBOrient.gam.B=60;

                end
                myWEB=buildOrcaLine(Model,lname,ConnectA,ConnectB,AX,BX,WEBOrient,WEBStiff,WEBStruct);
            end
        end
    end
    Model.SaveData(datfileOUT)
    disp(['Successfully (re)-built model. Saving ' datfileOUT])
end
% [M,COG]=getOFMass(Model,OFver); % need to rewrite this function to take into
% account OFver
% M
% COG+OForigin
end
%% AUXILIARY FUNCTIONS
function myLine=buildOrcaLine(Model,lname,ConnectA,ConnectB,AX,BX,Orient,Stiff,Struct)
    try
        myLine=Model(lname);
        disp(['Modified ' lname])
    catch
        myLine = Model.CreateObject(ofx.otLine, lname);
        disp(['Built ' lname])
    end
    %% Connection:
    myLine.EndAConnection=ConnectA; % connect object and then set relative position
    myLine.EndBConnection=ConnectB;
    try
        myLine.EndAX=AX(1); myLine.EndAY=AX(2); 
    catch
        eA=myLine.EndAConnectionzRelativeTo;
        disp(['Line ' lname 'has End A z relative to ' eA])
    end
    myLine.EndAZ=AX(3); 
    try
        myLine.EndBX=BX(1); myLine.EndBY=BX(2); 
    catch
        eB=myLine.EndBConnectionzRelativeTo;
        disp(['Line ' lname 'has End B z relative to ' eB])
    end
    myLine.EndBZ=BX(3);
    if isfield(Orient.az,'A')
        myLine.EndAAzimuth=Orient.az.A; myLine.EndBAzimuth=Orient.az.B;
    else
        myLine.EndAAzimuth=Orient.az; myLine.EndBAzimuth=Orient.az;
    end
    if isfield(Orient.dec,'A')
        myLine.EndADeclination=Orient.dec.A; myLine.EndBDeclination=Orient.dec.B;
    else
        myLine.EndADeclination=Orient.dec; myLine.EndBDeclination=Orient.dec;
    end
    if isfield(Orient.gam,'A')
        myLine.EndAGamma=Orient.gam.A; myLine.EndBGamma=Orient.gam.B;
    else
        myLine.EndAGamma=Orient.gam; myLine.EndBGamma=Orient.gam;
    end
    % Connection Stiffness:
    if isfield(Stiff,'AX') && ~strcmp(ConnectA,'Free')
        myLine.EndAxBendingStiffness=Stiff.AX;
    end
    if isfield(Stiff,'AY') && ~strcmp(ConnectA,'Free')
        myLine.EndAyBendingStiffness=Stiff.AY;
    end
    if isfield(Stiff,'BX') && ~strcmp(ConnectB,'Free')
        myLine.EndBxBendingStiffness=Stiff.BX;
    end
    if isfield(Stiff,'BY') && ~strcmp(ConnectB,'Free')
        myLine.EndByBendingStiffness=Stiff.BY;
    end
    if isfield(Stiff,'LayAz')
        try
            myLine.LayAzimuth=Stiff.LayAz;
        catch
            myLine.IncludeSeabedFrictionInStatics='No';
            %disp(['IncludeSeabedFrictionInStatics = No, for line: ' lname])
        end
    else
        myLine.IncludeSeabedFrictionInStatics='No';
        %disp(['IncludeSeabedFrictionInStatics = No, for line: ' lname])
    end
    if isfield(Stiff,'EndATwistingStiffness') || isfield(Stiff,'EndBTwistingStiffness')
         myLine.IncludeTorsion='Yes';
    end    
    if isfield(Stiff,'EndATwistingStiffness') && ~strcmp(ConnectA,'Free')
        try
            myLine.EndATwistingStiffness=Stiff.EndATwistingStiffness;
        catch
            myLine.IncludeTorsion='Yes';
            myLine.EndATwistingStiffness=Stiff.EndATwistingStiffness;
        end
    end
    if isfield(Stiff,'EndBTwistingStiffness') && ~strcmp(ConnectB,'Free')
        myLine.EndBTwistingStiffness=Stiff.EndBTwistingStiffness;  
    end
    %% Structure
    nSect=length(Struct);
    myLine.NumberOfSections=nSect;
    for jj=1:nSect
        myLine.Length(jj)=Struct(jj).Length;
        myLine.LineType(jj)=Struct(jj).LineType;
        if isfield(Struct,'NumberOfSegments')
            myLine.NumberOfSegments(jj)=Struct(jj).NumberOfSegments;
        elseif isfield(Struct,'TargetSegmentLength')
            myLine.TargetSegmentLength(jj)=Struct(jj).TargetSegmentLength;
        end
    end
end
function  buoy=buildOrca6buoy(Model,bname,Connect,X,M,MOI,COG,pcolor,COV,vertex,varargin)
%dt=1;
if nargin < 5
    M=1e-6;
end
if nargin<6 
    MOI=[0 0 0];
end
if nargin<7 
    COG=[0 0 0];
end
%this buoy represents the net
if nargin<8
    pcolor= 0*65536+255*256+255; %=yellow
end
if nargin<9
    COV=[0 0 0];
end
if nargin<10
    %draw a cube
    vertex(1,:)=[1 1 1];
    vertex(2,:)=[-1 1 1];
    vertex(3,:)=[-1 -1 1];
    vertex(4,:)=[1 -1 1];
    vertex(5,:)=[1 1 -1];
    vertex(6,:)=[-1 1 -1];
    vertex(7,:)=[-1 -1 -1];
    vertex(8,:)=[1 -1 -1];
end
    %Call the prexisting Orca Model
    try    
        buoy=Model(bname);
        disp(['Modified ' bname])
    catch
        buoy = Model.CreateObject(ofx.ot6DBuoy, bname);
        disp(['Built ' bname])
    end
    buoy.NumberOfVertices=length(vertex);
    for kk=1:length(vertex)
        buoy.VertexX(kk)=vertex(kk,1); buoy.VertexY(kk)=vertex(kk,2); buoy.VertexZ(kk)=vertex(kk,3); 
    end
    buoy.PenColour= pcolor; 
    buoy.BuoyType='Lumped Buoy';
    buoy.Connection=Connect;
    buoy.InitialX=X(1);
    buoy.InitialY=X(2);
    buoy.InitialZ=X(3);
    buoy.Volume=0;
    buoy.Mass=M;
    buoy.Height=.1;
    buoy.MassMomentOfInertiaX=MOI(1);
    buoy.MassMomentOfInertiaY=MOI(2);
    buoy.MassMomentOfInertiaZ=MOI(3);
    buoy.CentreOfMassX=COG(1);
    buoy.CentreOfMassY=COG(2);
    buoy.CentreOfMassZ=COG(3);
    buoy.CentreOfVolumeX=COV(1);
    buoy.CentreOfVolumeY=COV(2);
    buoy.CentreOfVolumeZ=COV(3);
  %  buoy.DegreesOfFreedomInStatics='X,Y,Z';
%     buoy.NumberOfLocalAppliedLoads=1;
%     buoy.LocalAppliedForceX(1)='Net_Force';
%     buoy.ExternalFunctionParameters=sprintf([' # Details of the thing to be controlled: \n'...
%         'ControlledObject = %s \n'...
%         'ControlledVariable = GX-Velocity \n' ...
%         'ControlStartTime = -8 # simulation time controller becomes active \n' ...
%         'MinValue = -1000000 # The minimum net force \n' ...
%         'MaxValue = 1000000  #  The max net force \n'...
%         '# Rotor Geometry \n'...
%         'H_net = %4.2f # (m) Height of each net panel \n'...
%         'L_net = %4.2f # (m) Length of each net panel \n'...
%         'Cd_net= 2 # (-) '],bname,panelH,panelW);
   % Model.SaveData(datfile)
   % pause(dt)
end

function  buoy=buildOrca3buoy(Model,bname,X,M,pcolor,varargin)
%dt=1;
if nargin < 4
    M=1e-6;
end
%this buoy represents the net
if nargin<5
    pcolor= 0*65536+255*256+255; %=yellow
end

    %Call the prexisting Orca Model
    try    
        buoy=Model(bname);
        disp(['Modified ' bname])
    catch
        buoy = Model.CreateObject(ofx.ot3DBuoy, bname);
        disp(['Built ' bname])
    end
    buoy.PenColour= pcolor; 
    buoy.InitialX=X(1);
    buoy.InitialY=X(2);
    buoy.InitialZ=X(3);
    buoy.Volume=0;
    buoy.Mass=M;
    buoy.Height=1;

   % Model.SaveData(datfile)
   % pause(dt)
end
function clump=buildAndAttachClump(Model,cname,Z,M,lname,iClear,pcolor,Cd,Ca,varargin)
if nargin<8
    Cd=[0 0 0];
end
if nargin<9
    Ca=[0 0 0];
end
if nargin<7
    pcolor= 0*65536+255*256+255; %=yellow
end
    try    
        clump=Model(cname);
        disp(['Modified ' cname])
    catch
        clump = Model.CreateObject(ofx.otClumpType, cname);
        disp(['Built ' cname])
    end
    clump.Name=cname;
    clump.Mass=M;
    clump.Volume=1e-6;
    clump.Height=.5;
    clump.AlignWith='Line Axes';
    clump.CdX=Cd(1); clump.CdY=Cd(2); clump.CdZ=Cd(3);
    clump.CaX=Ca(1); clump.CaY=Ca(2); clump.CaZ=Ca(3);
    clump.PenWidth=4;
    clump.PenColour=pcolor;
    try 
        line=Model(lname);
    catch
        disp(['Clump not attached to anything. Please build ' lname ' first'])
        return
    end
    nA=line.NumberOfAttachments;
    if iClear
        nA=0;
    end
    line.NumberOfAttachments=nA+1;
    line.AttachmentType(nA+1)=cname;
    line.Attachmentz(nA+1)=Z;
    line.AttachmentzRel(nA+1)='End A';
end
function setVesselType(Model,vname,Ptfm,LD)
vessel=Model(vname);
VTstr=vessel.VesselType;
if isempty(VTstr)
    VTstr='MyVesselType';
end
try    
    VT=Model(VTstr);
    disp(['Modified ' VTstr])
catch
    VT = Model.CreateObject(ofx.otVesselType, VTstr);
    disp(['Creating ' VTstr])
end
% Structure Tab
% VT.Mass=Ptfm.Mass;
% VT.MomentOfInertiaX=Ptfm.MOI(1); VT.MomentOfInertiaY=Ptfm.MOI(2); VT.MomentOfInertiaZ=Ptfm.MOI(3);
% VT.CentreOfGravityX=PTfm.COG(1); VT.CentreOfGravityZ=PTfm.COG(2); VT.CentreOfGravityZ=PTfm.COG(3);

% Stiffness Tab
%% LINEAR DAMPING
VT.OtherDampingOriginx=2*Ptfm.Col.Lh/3; VT.OtherDampingOriginy=0; VT.OtherDampingOriginz=0;
VT.OtherDampingLinearCoeffx=LD(1); VT.OtherDampingLinearCoeffy=LD(2); VT.OtherDampingLinearCoeffz=LD(3); VT.OtherDampingLinearCoeffRx = LD(4); VT.OtherDampingLinearCoeffRy=LD(5); VT.OtherDampingLinearCoeffRz=LD(6);
%% IMPORT WAMIT COEFFS!
end
function buildMyVessel(Model,vname,X,Xt,Xb,iFAST,iRigid)
    %Call the prexisting Orca Model
    try    
        vessel=Model(vname);
        disp(['Modified ' vname])
    catch
        vessel = Model.CreateObject(ofx.otVessel, vname);
        disp(['Built ' vname])
    end
    vessel.InitialX=X(1);
    vessel.InitialY=X(2);
    vessel.InitialZ=X(3);
    vessel.InitialHeel=X(4);
    vessel.InitialTrim=X(5);
    vessel.InitialHeading=X(6);
    vessel.IncludedInStatics='None';
    vessel.PrimaryMotion='None';
    vessel.IncludeAppliedLoads='Yes';
    if iRigid
        vessel.IncludeWaveLoad1stOrder='Yes';
        vessel.IncludeWaveDriftLoad2ndOrder='Yes';
        vessel.IncludeAddedMassAndDamping='Yes';
        vessel.IncludeOtherDamping='Yes';
    else
        vessel.IncludeWaveLoad1stOrder='No';
        vessel.IncludeWaveDriftLoad2ndOrder='No';
        vessel.IncludeAddedMassAndDamping='No';
        vessel.IncludeOtherDamping='No';
    end
    vessel.IncludeWaveDriftDamping='No';
    vessel.IncludeSumFrequencyLoad='No';
    vessel.IncludeManoeuvringLoad='No';
    vessel.IncludeCurrentLoad='No';
    vessel.IncludeWindLoad='No';
    if iFAST
        vessel.PrimaryMotion='Externally Calculated'; %OrcaFAST
        vessel.ExternallyCalculatedPrimaryMotion='ExtFn';
    else
        vessel.PrimaryMotion='Calculated (6 DOF)'; %OrcaFlex
        vessel.PrimaryMotionIsTreatedAs='Both low and wave frequency';
        vessel.PrimaryMotionDividingPeriod=500; %[s] so says Sandra...
    end
    VTstr=vessel.VesselType;
    VT=Model(VTstr);
    for jj=1:3 
        VT.VertexX(jj)=Xt(jj,1); VT.VertexY(jj)=Xt(jj,2); VT.VertexZ(jj)=Xt(jj,3);
    end
    for jj=1:3 
        VT.VertexX(jj+3)=Xb(jj,1); VT.VertexY(jj+3)=Xb(jj,2); VT.VertexZ(jj+3)=Xb(jj,3);
    end    
    %vertices=[0	0	11; -45.63953878	26.35	11;-45.63953878	-26.35	11; 0	0	-18; -45.63953878	26.35	-18;-45.63953878	-26.35	-18];

end
function buildOrcaLink(Model,lname, EndA,EndB,Stiff,pcolor,varargin)
    if nargin<8
        pcolor= 0*65536+255*256+0; %=green
    end
    try
        myLink=Model(lname);
        disp(['Modified ' lname])
    catch
        myLink = Model.CreateObject(ofx.otLink, lname);
        disp(['Built ' lname])
    end
    myLink.LinkType='Spring/Damper';
    myLink.EndAConnection=EndA.Name;
    myLink.EndBConnection=EndB.Name;
    myLink.EndAzRelativeTo=sprintf('End %s',EndA.Rel);
    myLink.EndBzRelativeTo=sprintf('End %s',EndB.Rel);
    myLink.EndAZ=EndA.Z;
    myLink.EndBZ=EndB.Z;
    
    if length(Stiff)==1
        myLink.LinearSpring = 'Yes';
        myLink.Stiffness=Stiff.K;
        myLink.UnstretchedLength=Stiff.L;
    else
        myLink.LinearSpring = 'No';
        for kk=1:length(Stiff)
            myLink.SpringLength(kk)=Stiff(kk).L;
            myLink.SpringTension(kk)=Stiff(kk).T;
        end
    end
    myLink.PenColour=pcolor;
end
%     %% Change the Mooring Links
%     mod_all = Model.objects;
%     allnames = cellfun( @(obj) obj.typeName, mod_all, 'uni', false);
%     mod_obj=mod_all( strcmp(allnames, 'Link') );
%     uLs=[443.6 443.6 443.6-65]; %[m] unstretched length
%     %uLs=[458.76 458.76 458.76-65]; %[m] unstretched length
%     ias=mod(WFangles-150*pi/180,2*pi);
%     Kmoor=27e3; % stiffness [N/m]
%     for jj=1:length(mod_obj)
%        jLink=mod_obj{jj};
%        disp(['Modified ' jLink.Name])
%        jLink.LinkType = 'Spring/Damper';
%        jLink.EndAConnection=sprintf('Col%d L',jj);
%        jLink.EndAX=Ptfm.Mooring.R*cos(ias(jj)); jLink.EndAY=Ptfm.Mooring.R*sin(ias(jj)); jLink.EndAZ=-Ptfm.LMB.dL;
%        jLink.EndBConnection='Fixed';
%        jLink.EndBX=ColX(jj,1)+(uLs(jj)+Ptfm.Mooring.R)*cos(ias(jj)); jLink.EndBY=ColX(jj,2)+(uLs(jj)+Ptfm.Mooring.R)*sin(ias(jj)); jLink.EndBZ=Ptfm.Col.Draft;       
%        %jLink.EndBConnection='Anchored';
%        %jLink.EndBX=ColX(jj,1)+(uLs(jj)+Ptfm.Mooring.R)*cos(ias(jj)); jLink.EndBY=ColX(jj,2)+(uLs(jj)+Ptfm.Mooring.R)*sin(ias(jj)); jLink.EndBZ=0;       
% 
%        jLink.UnstretchedLength=uLs(jj);
%        jLink.Stiffness=Kmoor;
%     end
    %% Build the Tower !!!
%     TROrient.az=0; TROrient.dec=0; TROrient.gam=0;
%     if iRigid
%         TRStiff.AX=0; % [N-m/deg] 
%         TRStiff.BX=0; % [N-m/deg] 
%     else
%         TRStiff.AX=ofx.OrcinaInfinity(); % [N-m/deg] 
%         TRStiff.BX=ofx.OrcinaInfinity(); % [N-m/deg] 
%     end   
%     nTow=length(Turbine.Tower.H);
%     for jj=1:nTow
%         TowStruct(jj).LineType=TowerNames{jj};
%         TowStruct(jj).Length=Turbine.Tower.H(jj);
%         TowStruct(jj).TargetSegmentLength=1;
%     end
%     myTower=buildOrcaLine(Model,'Tower','Col1 U','RNA',TOWpos,[0 0 0],TROrient,TRStiff,TowStruct);
%     myTower.IncludeTorsion='Yes';
%     myTower.EndATwistingStiffness = ofx.OrcinaInfinity();
%     myTower.EndBTwistingStiffness = ofx.OrcinaInfinity();
%     myTower.IncludeSeabedFrictionInStatics='No';
