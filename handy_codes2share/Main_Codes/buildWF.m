function buildWF(IPTfile,varargin)
% Build a semi-submersible platform in 200 lines in OrcaFlex!
% Written by Sam Kanner
% Copyright Principle Power Inc., 2016, rewritten July 2017
if nargin>0
    iptname=IPTfile;
%     if strcmp(IPTfile(end-1:end),'.m')
%         iptname=iptname(1:end-2);
%     end
else
    iptname=getIPTname(mfilename);
end
run(iptname);
OForigin=X1; 
global nVB
nVB=2; 
global nCol
nCol=3;
%% get Platform and Turbine properties
Ptfm=getMyPtfm(PtfmType); %nCol=length(Ptfm.Col.D); %number of columns...
% save variables
Ptfm.Emult = Emult; Ptfm.X1 = X1;
Ptfm.iRigid=iRigid; Ptfm.(WEPtype).nUwep=nUwep;  Ptfm.(WEPtype).specWEP = specWEP; Ptfm.(WEPtype).nX = nX; 
Ptfm.(WEPtype).CdDes = CdWEP;  Ptfm.(WEPtype).CdDiam = CdDiam; Ptfm.(WEPtype).D = WEPD;
Ptfm.iLD = iLD; Ptfm.LD = LD;
% How to specify added mass of lines
if exist('AddedMassZ','var')
    Ptfm.(WEPtype).AddedM=AddedMassZ;
elseif exist('CaWEP','var')
    Ptfm.(WEPtype).CaTotal = CaWEP;
end
%% Set Added Mass Properties (can be set as an input)
if exist('CaCOL','var')
    Ptfm.Col.Ca=CaCOL;
else
    Ptfm.Col.Ca=0.8;
end
if exist('CdCOL','var')
    Ptfm.Col.Cd=CdCOL;
else
    Ptfm.Col.Cd=0.65;
end

if exist('CaTruss','var')
    Ptfm.VBr.Ca=CaTruss; Ptfm.LMB.Ca=CaTruss; Ptfm.UMB.Ca=0;
else
    Ptfm.VBr.Ca=1; Ptfm.LMB.Ca=1; Ptfm.UMB.Ca=0;
end
if exist('CdTruss','var')
    Ptfm.VBr.Cd=CdTruss; Ptfm.LMB.Cd=CdTruss; Ptfm.UMB.Cd=CdTruss;
else
    Ptfm.VBr.Cd=1.2; Ptfm.LMB.Cd=1.2; Ptfm.UMB.Cd=1.2;
end

Turbine=getMyTurbine(TurbineType); nLines=length(linenames);
if length(nLevel)~=nLines
    error('Length of discretization vector: nLevel must equal number of lines in: linenames')
end

%% Get some pretty colors
colorstr={'dblue','blue','yellow','orange','red','dred','white'};
nColors=length(colorstr);
mycmap=getcmap(nColors,colorstr); % r,g,b goes from 0 to 1
OFcolors=sum(repmat([65536 256 1],[nColors,1]).*255.*[mycmap(:,3) mycmap(:,2) mycmap(:,1)],2); %

%% Get Ultra-Rigid Flexible Model properties
if iAdamantium
    Turbine.Tower.E=Turbine.Tower.E*1e3; % ultra-rigid!
    Ptfm.E=Ptfm.E*1e3; % ultra-rigid!
end

%% Load Model or Make new Model
if iOF
    try
        Model=ofxModel(datfileIN);
        disp([datfileIN 'found. Modifying using ipt file.'])
    catch
        Model=ofxModel(); %create empty model
        Model.SaveData(datfileOUT)
        warning([datfileIN ' not found. Starting from scratch.'])
    end


    %% Change the units to SI!! 
    general=Model('General'); general.UnitsSystem='User'; general.LengthUnits='m'; general.MassUnits='kg'; general.ForceUnits='N';
    %% Time-stepping stuff
    general.LogPrecision='Double'; general.ImplicitTolerance=0.00025; general.SpectralDensityFundamentalFrequency=0.0005;
else
    Model =[];
end
%% Get points of all (non-WEP, non-KB) line members
[WFpts,WFlabels]=getWFpts(linenames,nLevel,PtfmType,X1,iRigid,iplot,~iRigid,'',OFver); % contains buoys (if necessary) and line endpoints
%% Load WEP -> defined as a vector of 3D points  (not using KBs so far)
if iWEP
    [WEPpts, WEPlabels,KBpts,KBlabels]=getMyWEP(WEPtype,Ptfm,OForigin+[-2*Ptfm.Col.Lh/3 0 0]); %defined in the global coordinate
    WFpts=[WFpts;KBpts;WEPpts]; WFlabels=[WFlabels;KBlabels;WEPlabels];
end
if iplot && iWEP
    plotMyWEP(WEPpts,WEPlabels,Ptfm);
end
[Ptfm.(WEPtype).Cd ,Ptfm.(WEPtype).Ca,Ptfm.(WEPtype).idx,Ptfm.(WEPtype).MPUL] = getWEPproperties(Ptfm,Ptfm.(WEPtype),WEPpts,WEPlabels);
%% Load RNA + Tower
if iTower
    Turbine.iRNA=iRNA; Turbine.iTower=iTower; Turbine.iBlades=iBlades;
    Turbine.Tower.Ca = 0;  Turbine.Tower.Cd = 0.7;
   [WFpts,WFlabels,Turbine]= getTurbineProperties(WFpts,WFlabels,Turbine);
end
n2build=sum(~isempty(WFlabels));
%% Build your vessel!
if iRigid
    %buildMyVessel(Model,vname,[0 0 0 0 0 0],Xt,Xb,iRigid)
    %setVesselType(Model,vname,Ptfm,LD);
    % TODO: IMPORT WAMIT COEFFS!
end
%% Build your lines and buoys!
lnameprev=''; GAXold=zeros(1,3); GBXold=zeros(1,3);
for ibuild=1:2 % need to go through the build twice (something weird in orcaflex about setting coordinates relative on the first build) 
    il=1;
    while il<=length(WFlabels)
        GAX=WFpts(il,:);
        lname=WFlabels{il};
        ltrs=regexp(lname,'[a-zA-Z]+','match');
        if ~isempty(ltrs)
            BaseType=ltrs{1};
        end
        colnumstr=regexp(lname,'\d','match');
        colnum=str2double(colnumstr);
        itmp=strfind(linenames,BaseType);
        iLevel=find(not(cellfun('isempty', itmp)));
        if ~isempty(iLevel)
            llevel=nLevel(iLevel);
        else
            llevel=[];
        end
        if iRigid
            ConnectA=vname; ConnectB=vname;
        else
            if il+2<length(WFlabels)
                lnamenext=WFlabels{il+2};
            else
                lnamenext='';
            end
            [ConnectA,ConnectB]=getFlexibleConnect(BaseType,OFver,lnameprev,lname,lnamenext);
        end
        if iOF
            AX=getRelX(Model,ConnectA,GAX);
        end
        if isempty(WFlabels{il+1})
            %then you are building a line
            GBX = WFpts(il+1,:);  
            llen=sqrt(  sum( (GBX-GAX).^2) ); %total length between points 
            Orient=getLineOrient(lname,Model,Ptfm,iRigid,OFver,[GAX;GBX],ConnectA,ConnectB,[GAXold;GBXold]);
            Stiff=getLineStiff(lname,iRigid,iOF);
            Struct = getLineStruct(lname,llevel,llen,Ptfm,Turbine,Ptfm.(WEPtype));
            makeLineTypes(Model,lname,Struct.AllTypes,Ptfm,Turbine);
            if iOF
                BX=getRelX(Model,ConnectB,GBX); 
                myLine=buildOrcaLine(Model,lname,ConnectA,ConnectB,AX,BX,Orient,Stiff,Struct);
            end
            il=il+2;
            GBXold=GBX;
        else
            if iOF
                %then you are building a buoy
                LD=zeros(1,6);
                if ~isempty(strfind(lname,'COL')) || ~isempty(strfind(lname,'Col'))
                    M=1e-2; MOI=[0 0 0]; COG = [0 0 0];
                    pcolor=0*65536+round(0)*256+255;
                    AX(4)=180; AX(5)=0; AX(6)=180; % match global coords
                    if ~isempty(strfind(lname,' L')) && Ptfm.iLD
                        LD = Ptfm.LD;
                    end
                    pts=[];
                elseif strcmp(lname,'RNA')
                    M=Turbine.RNA.M;
                    MOI=diag(Turbine.RNA.I);
                    COG=Turbine.RNA.COG-AX(1:3);
                    AX(5)= Turbine.Tilt*180/pi; AX(6)=0;
                    RNAV=[abs(Turbine.Overhang)*.5 2 (Turbine.RNA.H)*.5];
                    pts=   repmat(RNAV,[8 1]).*  [1 1 1 ; -2 1 1 ; -2 -1 1; 1 -1 1; 1 1 -1; -2 1 -1; -2 -1 -1; 1 -1 -1];
                else
                    M=1e-2; MOI=[0 0 0]; COG = [0 0 0];
                    pcolor=0*65536+round(0)*256+255;
                    pts=[];
                end
                myBuoy=buildOrca6buoy(Model,lname,ConnectA,AX,M,MOI,COG,LD,pcolor,pts);
            end
            il=il+1;
        end
        lnameprev=lname; GAXold=GAX; 
    end
    if iOF
        %% Move your mooring lines
        if iBuildMoor
            Model=buildMooring(Model,Ptfm,MLname,X1,OFver,iRigid);
        end
        if iAlignMoor
            Model=modifyMooring(Model,Ptfm,MLname,X1,iRigid);
        end
        % % Mooring point mass ??
        %% Add in Secondary Steel + Ballast
        Model=addSecondarySteelAndBallast(Model,Ptfm,Turbine,OFcolors);
        %% Best be saving your model
        Model.SaveData(datfileOUT)
    end
    disp(['Successfully (re)-built model. Saving ' datfileOUT])
end
end

function [ConnectA,ConnectB]=getFlexibleConnect(BaseType,OFver,lname0,lname1,lname2)
nVB=2; % number of V-braces per side
global nCol
colnumstr=regexp(lname1,'\d','match');
ltrs=regexp(lname1,'[a-zA-Z]+','match');
if length(ltrs)>1
    LevelNum=int8(ltrs{2})-96; % 'a' = 1; 'b' = 2... 
end
lnum=str2double(colnumstr);
iC=lnum;  % default 
if strcmp(BaseType,'VB')
    iC=ceil(lnum/nVB); % overwrite iC definition
end
iCn = mod(iC,nCol)+1;
switch BaseType
    case 'COL'
        if ~isempty(strfind(lname1,' U')) || ~isempty(strfind(lname1,' L'))
            % then it is a buoy
            if OFver<10
                ConnectA = 'Free';
                ConnectB = '';
            else
                ConnectA = sprintf('Col%d',iC);
                ConnectB= '';
            end
        else
            if OFver<10
                ConnectA = sprintf('Col%d U',iC);
                ConnectB = sprintf('Col%d L',iC);
            else
                ConnectA = 'Free';
                ConnectB = 'Free';
            end
        end
    case 'RNA'
        ConnectA='Free';
        if OFver<10
            ConnectB = 'Col1 U';
        else
            ConnectB = 'COL1';
        end
    case 'UMB'
        if OFver<10
            ConnectA = sprintf('Col%d U',iC);
            ConnectB = sprintf('Col%d L',iC);
        else
            ConnectA = sprintf('COL%d',iC);
            ConnectB = sprintf('COL%d',iCn);
        end
    case 'LMB'
        if LevelNum==1
            if OFver<10
                ConnectA = sprintf('Col%d U',iC);
                ConnectB = sprintf('Col%d L',iC);
            else
                 ConnectA = sprintf('Col%d',iC);
                 ConnectB = 'Free';
            end
        elseif LevelNum==2
            if OFver<10
                ConnectA = 'foo'; % K joint?
                ConnectB = sprintf('Col%d L',iC);
            else
                 ConnectA = lname0;
                 ConnectB = sprintf('COL%d',mod(iC,3)+1);
            end
        end 
    case 'VB'
        iCol=mod(floor(lnum/nVB),nCol)+1;% column that the v-brace emanates from iCol=mod(floor(lnum/nVB),nCol)+1;% column that the v-brace emanates from
        if OFver<10
        else
%           ConnectA=colname{iCol};
%           ConnectB=sprintf('LMB%da',iC);
            ConnectA=sprintf('COL%d',iCol);%sprintf('Col%d %s',iCol,'U');
            ConnectB=sprintf('LMB%da',iC);
        end
    case 'WEP'
        if OFver<10
            ConnectA = sprintf('Col%d L',iC);
            ConnectB = sprintf('Col%d L',iC);
        else
             if isempty(strfind(lname2,colnumstr{:})) % AA % could also determine if it lies on OS perimeter
                 ConnectA = lname0;
                 ConnectB = sprintf('Col%d L',iC);
             elseif isempty(strfind(lname0,BaseType)) ||  isempty(strfind(lname0,colnumstr{:})) % AB
                 ConnectA = sprintf('Col%d L',iC);
                 ConnectB = 'Free';
%              elseif isempty(lname3) && ~isempty(lname2) % second to last
%                  ConnectA=lname0;
%                  ConnectB=lname2;
             else
                 ConnectA=lname0;
                 ConnectB = 'Free';
             end
        end
    case 'Tower'
       if OFver<10
       else
           ConnectA='COL1';
           ConnectB='RNA';
       end
    case 'Blade'
        if OFver<10
        else
            ConnectA = 'RNA';
            ConnectB = 'RNA';
        end
    case 'ML'
        if OFver<10
        else
            ConnectA = sprintf('Col%d',iC);
        end
        ConnectB='Anchored';
end
end

function makeLineTypes(Model,lname,LineTypes,Ptfm,Turbine)
nVB=2;global nCol
%%  Define some stuff
maxt=.125; % 125mm is a lot!
mint=.01; % 10 mm is very thin!
p1=[153 255];
isCol=0;
isTruss=0;
if Ptfm.iRigid
    Poisson = .5;
else
    Poisson = .3;
end 
%% ID the line
ltrs=regexp(lname,'[a-zA-Z]+','match');
lnum=str2double(regexp(lname,'\d+','match')); % assume that only number in line name refers to column number!! (ie Col1, or LMB1a)
BaseType=ltrs{1};
%% Make custom changes based on linename
switch BaseType
    case 'COL'
        StructName = 'Col';
        SecStructName = 'iCol';
        isCol=1;
        Struct=Ptfm;
        colnum=lnum;
    case 'VB'
        baselinename=[BaseType 'r'];
        StructName=baselinename; 
        SecStructName=baselinename; 
        colnum=mod(floor(lnum/nVB),nCol)+1;
        isTruss=1;
        Struct=Ptfm;
    case {'LMB','UMB'}
        StructName=BaseType;
        SecStructName=BaseType;
        isTruss=1;
        colnum=lnum;
        Struct=Ptfm;
    case 'WEP'
        StructName=Ptfm.WEP{:};
        SecStructName=StructName;
        WEPtype=Ptfm.WEP{:};
        %MPULtypes = repmat(Ptfm.(WEPtype).MPUL,[1 length(Ptfm.(WEPtype).specWEP)]);
        colnum=lnum;
        nSPwep=length(Ptfm.(WEPtype).specWEP)+1;
        Struct=Ptfm;
    case {'Tower','Blade'}
        Struct=Turbine;
        StructName=BaseType;
        SecStructName=BaseType;
        %colnum = str2double(regexp(lname,'Section (\d+)','tokens','once'));
    otherwise
        StructName=BaseType;
        SecStructName=BaseType;
        colnum=lnum;
end
LevelNum=[];

nTypes=length(LineTypes);
%% Loop through all linetypes used
for jj=1:nTypes
    %% Default values
    Emult=1;
    iFake=0;
    LTname=LineTypes{jj};
    thick=str2double(regexp(LTname, '_(\d+)mm', 'tokens', 'once'))/1000; % [m]
    % look for a Col Num
    %colstrcell=regexp(LTname, ' (\d+)_', 'tokens', 'once');
    %colstr=colstrcell{:};
    %colnum=lnum;%str2double(colstr(1)); % 23 -> 2
    pout=linmap( [mint maxt], [255 0],thick);
    %% look for a "Fake" line (only exists in Flexible model)
    Estrcell=regexp(LTname, '_(\d+)E', 'tokens', 'once');
    if ~isempty(Estrcell)
        iFake=1;        
        Emult=str2double(Estrcell{:});
    end
     %% Set Properties
     if strcmp(BaseType,'Tower')
         OD = Struct.(SecStructName).D(jj);
         ODbuoy = OD;
     elseif strcmp(BaseType,'Blade')
         OD = Struct.(SecStructName).D;
         ODbuoy = OD; iFake=1; 
     else
         if length(Struct.(SecStructName).D)>1
             if Struct.(SecStructName).D(colnum)==0
                OD = Struct.(StructName).D(colnum);
                ODbuoy = OD+2*isCol*thick;
             else
                OD = Struct.(SecStructName).D(colnum);
                ODbuoy = Struct.(StructName).D(colnum)+2*isCol*thick;
             end
        else
            OD = Struct.(SecStructName).D;
            ODbuoy = Struct.(StructName).D;
         end
     end
    ODstruct = OD;
    A= pi*((ODstruct/2).^2 - ((ODstruct-2*thick)/2) .^2); % area properties 
    if ~Ptfm.iRigid
        if ~strcmp(BaseType,'WEP')
            OD=ODbuoy;
           if strcmp(BaseType,'Blade')
            EI(1) = [1e12]; % [N-m^2] How should we choose this for the WEP?!? 
            EI(2) = ofx.OrcinaDefaultReal();             EA=[700e6]; %[N] How should we choose this for the WEP?!?
            GJ = [1e12] ;
           else
                %% Derived Properties
                ID = ODstruct-(~isCol)*2*thick; % [m] yes, it is weird we define the cols by ID
                % Bending Stiffness
                EI(1)= Emult*Ptfm.E * pi/4*((ODstruct/2).^4 - ((ODstruct-2*thick)/2) .^4);
                EI(2) = ofx.OrcinaDefaultReal();
                % Axial Stiffness
                EA=Emult*Ptfm.E*A; 
                if strcmp(BaseType,'Tower')
                    MPUL = Turbine.Tower.M(jj)./Turbine.Tower.H(jj);%get directly from spreadsheet (in case there is a change in density (like a crown)
                else
                    MPUL=Ptfm.Density*A; %[kg/m]
                end
                % Torsional Stiffness
                GJ=2*EI(1)*.3845; % % [N-m^2]
           end
            CdD = ODbuoy;
            % Added Mass + Inertia
            Ca(1)=Struct.(StructName).Ca;  Ca(2)= ofx.OrcinaDefaultReal(); Ca(3)=0; %[-]
            Cm{1}=ofx.OrcinaDefaultReal(); Cm{2}=ofx.OrcinaDefaultReal(); Cm{3}=ofx.OrcinaDefaultReal();        


            if iFake
                % Overwrite buoyancy
                ODbuoy = 1e-2;
                ID = 0;
                MPUL=1e-1; % need to have a little bit so that Modal Analysis still works!
            end
                % Drag + Lift
            Cd(1) = Struct.(StructName).Cd*(~iFake);
            Cd(2) = ofx.OrcinaDefaultReal();
            Cd(3) = Struct.(StructName).Cd*(~iFake | ~isCol);% 0*isCol + 1.2*isTruss*(~iFake);
            
        else
            ODbuoy = OD;
            [uWEP,spWEP]=getWEPidxs(lname,Ptfm.(WEPtype));
%             uWEP=mod(jj,Ptfm.(WEPtype).nUwep)+1
%             spWEP=mod(jj,nSPwep)+1
%             LTname
            ID = 0;            
            MPUL = Ptfm.(WEPtype).MPUL(uWEP);
            EI(1) = [1e12]; % [N-m^2] How should we choose this for the WEP?!? 
            EI(2) = ofx.OrcinaDefaultReal();
            EA=[700e6]; %[N] How should we choose this for the WEP?!?
            GJ = [1e12] ; % [N-m^2] How should we choose this for the WEP?!?
            Cd(1) = 0 ; Ca(1) = 0;
            Cd(2) = Ptfm.(WEPtype).Cd(uWEP); 
            Cd(3) = 0; Ca(3) = 0;
            CdD= Ptfm.(WEPtype).CdDiam;
            Ca(2) = Ptfm.(WEPtype).Ca(uWEP,spWEP+1);
            Cm= {ofx.OrcinaDefaultReal,ofx.OrcinaDefaultReal,ofx.OrcinaDefaultReal}; % [-]
            pout=linmap( [0 50], [0 255 ],spWEP*25+5*uWEP);   
        end
    else
        %  buoyancy is taken into account in the vessel (WAMIT import)
        ODbuoy = 10e-6;
        ID=0; EI = [1e9 1e9];
        CdD = ODbuoy;
        Ca=[ 0 0 0]; 
        Cm{1}=ofx.OrcinaDefaultReal(); Cm{2}=ofx.OrcinaDefaultReal(); Cm{3}=ofx.OrcinaDefaultReal();
        % Drag + Lift
        Cd(1) = Struct.(StructName).Cd;
        Cd(2) = ofx.OrcinaDefaultReal();
        Cd(3) = Struct.(StructName).Cd*(~isCol);% 0*isCol + 1.2*isTruss*(~iFake);
    end

    
    %% Aero/Hydro Properties

    
    %% Make a pretty color
    if iFake
        p1u=interp1([1 10],p1,Emult);
        pcolor= p1u*65536+0*256+p1u; % purple
    else
        pcolor=0*65536+round(pout)*256+255;
    end
    %% Make the LineType
    try 
        LT = Model(LTname);
    catch
        disp(['Creating: ' LTname])
        LT = Model.CreateObject(ofx.otLineType,LTname);
    end
    setLineType(LT,ODbuoy,ID,MPUL,EI,EA,Poisson,GJ,Cd,CdD,Ca,Cm,pcolor);
end

% 
%     if Ptfm.iCol.D(jj)>0
%         iColD=Ptfm.iCol.D(jj);
%         iColt=Ptfm.iCol.t(kk,jj);
%     else
%         iColD=Ptfm.Col.D(jj);
%         iColt=Ptfm.Col.t(jj);
%     end


end
function [uWEP,spWEP]=getWEPidxs(lname,PtfmWEP)
    lstrs=regexp(lname,'[a-zA-Z]+','match');
    iC=str2double(regexp(lname,'\d+','match'));
    WEPstrs=PtfmWEP.Pts(:,1);
    ibl=strfind(WEPstrs,'"');
    iWEPbl=find(not(cellfun('isempty', ibl)));
    WEPstrsU=WEPstrs(iWEPbl(1)+1:iWEPbl(2)-1);
    nonum=cellfun(@(s) s(2:end),WEPstrsU,'uniformoutput',0);
    iSec=find(strcmp(nonum,lstrs{2}));
    %itmp=strfind(WEPstrsU,lstrs{2});
    %iSec=find(not(cellfun('isempty', itmp)))
    nuWEP=min([iC PtfmWEP.nUwep]); 
    WEPidx=PtfmWEP.idx(nuWEP,iSec) ;
    uWEP =mod((PtfmWEP.nUwep-1)+WEPidx,PtfmWEP.nUwep)+1; % corresponds to unique WEP number  {'1','23'}..
    spWEP=floor(((PtfmWEP.nUwep-1)+WEPidx)/PtfmWEP.nUwep)-1; % corresponds to special WEP letters { 'CA','CB',...
end

function [WFpts,WFlabels,Turbine]=getTurbineProperties(WFpts,WFlabels,Turbine)

    % turbine starts where col1 ends (
    BotTower = WFpts(strcmp(WFlabels,'COL1'),:); TopTower = BotTower + [0 0 sum(Turbine.Tower.H)];
    if BotTower(3)<Turbine.Tower.Z(1)-.5 || BotTower(3)>Turbine.Tower.Z(1)+.1
        error('The end of COL 1 does not equal the beginning of the Turbine Tower in the TurbineX spreadsheet')
    end
    GXRNA = [0 0 Turbine.RNA.COP(3)]; % where the the thrust force is applied
    if Turbine.iRNA 
        WFpts = [WFpts; GXRNA ];% ;
        WFlabels = {WFlabels{:}, 'RNA' };
    end
    if Turbine.iTower
        WFpts = [WFpts;  BotTower ; TopTower];
        WFlabels = {WFlabels{:}, 'Tower', ''};
    end
        %
    % TODO: add in blades
    Turbine.nBlades=3;
    Turbine.Blade.Ca=[0]; Turbine.Blade.Cd =[0.7]; Turbine.Blade.D = 6;
    GXHub = GXRNA + [-abs(Turbine.Overhang) 0 0]; % should point in the -X dir
    aBlade=[0:120:240]*pi/180;
    GXbladeTip=zeros(Turbine.nBlades,3);
    if Turbine.iBlades
        for bb=1:Turbine.nBlades
            GXbladeTip(bb,:)= GXHub + Turbine.Blade.L*[0 sin(aBlade(bb)) cos(aBlade(bb))];
            WFpts=[WFpts; GXHub; GXbladeTip(bb,:)];
            WFlabels= {WFlabels{:},sprintf('Blade%d',bb),''};
        end
    end
end
function LineStruct=getLineStruct(lname,llevel,llen,Ptfm,Turbine,PtfmWEP)
nVB=2;
% get line section, lengths, linetypes and discretizations
%% Default naming/numbering scheme
ltrs=regexp(lname,'[a-zA-Z]+','match');
lnum=str2double(regexp(lname,'\d+','match')); % assume that only number in line name refers to column number!! (ie Col1, or LMB1a)
BaseType=ltrs{1};
LevelNum=[];
nCol=length(Ptfm.Col.D);
if length(ltrs)>1
    SecType=ltrs{2};
    LevelNum=int8(SecType)-96; % 'a' = 1; 'b' = 2... 
end
if strcmp(BaseType,'VB')
    % VB numbering goes from 1,2,.. nCol*nVB
    iC=ceil(lnum/nVB); % overwrite iC definition
    iCn=mod(iC,nCol)+1;
elseif strcmp(BaseType,'WEP')
    iC=lnum; % only number matches column number
    iCn=mod(iC,nCol)+1; % unused
    % how to extract WEP type from label
    [uWEP,spWEP]=getWEPidxs(lname,PtfmWEP);
else
    iC=lnum;  % default column number of EndA
    iCn=mod(iC,nCol)+1; % default column number of EndB (gets overwritten for V-brace)
end
%% Common Geometry Parameters
Ra=Ptfm.iCol.D(iC)*.5;
Rb=Ptfm.iCol.D(iCn)*.5;
ODID=.5*(Ptfm.Col.D(iC)-Ptfm.iCol.D(iC));  % distance between outershell and inner shaft of ColA
ODIDn=.5*(Ptfm.Col.D(iCn)-Ptfm.iCol.D(iCn)); % distance between outershell and inner shaft of ColB
%% Defaults
baselinename=BaseType; % default value
StructName=BaseType;
startFakeSecs=[];
endFakeSecs=[];
%% Add in the 'fake' sections (inside of OS or IS, for instance)
switch BaseType
    case 'COL'
        StructName='iCol';
        SecStructName='Col';
        if lnum==1
            baselinename = 'Col 1';
        else
            baselinename = 'Col 23';
        end
    case {'UMB', 'LMB'}
        if ~Ptfm.iRigid
            if isempty(LevelNum)
                if Ra>0
                    startFakeSecs=[Ptfm.Emult(2) Ptfm.Emult(1)];
                else
                    startFakeSecs=Ptfm.Emult(1);
                end
                if Rb>0
                    endFakeSecs=[Ptfm.Emult(1) Ptfm.Emult(2)];
                else
                    endFakeSecs=Ptfm.Emult(1);
                end
            else
                if LevelNum==1
                    if Ra>0
                        startFakeSecs=[Ptfm.Emult(2) Ptfm.Emult(1)];%FakeLineSegEnding=sprintf('_%dE',mult(2)); 
                    else
                        startFakeSecs=Ptfm.Emult(1);
                    end
                elseif LevelNum==llevel
                    if Rb>0
                        endFakeSecs=[Ptfm.Emult(1) Ptfm.Emult(2)];
                    else
                        endFakeSecs=Ptfm.Emult(1);
                    end
                end
            end
        end
        baselinename=BaseType;
    case 'VB'
        if ~Ptfm.iRigid
            if isempty(LevelNum)
                startFakeSecs=Ptfm.Emult(2);
                endFakeSecs=Ptfm.Emult(2);
            else
                if LevelNum==1
                   startFakeSecs=Ptfm.Emult(2);
                elseif LevelNum==llevel
                   endFakeSecs=Ptfm.Emult(2);
                end
            end
        end
        baselinename=[BaseType 'r'];
        StructName=baselinename; 
    case 'WEP'
        % a single WEP line only consists of 1 linetype
        if PtfmWEP.nUwep==1
            LineEndStr={''};
        elseif PtfmWEP.nUwep==2
            LineEndStr={'1','23'};
        else
          LineEndStr={'1','2','3'}; 
        end
        baselinename= BaseType;
        LineSecEnding = [LineEndStr{uWEP}];  
        if spWEP 
            LineSecEnding =[ LineSecEnding sprintf('_%dx',round(PtfmWEP.nX(spWEP)*10))]; % different added mass props (could have a vector), using existing infrastructure
        end
        nSec=1;
        colv=1;
    case 'Blade'
        nSec=2; colv=1; LineSecs={'_drag','_drag0'};
    case 'Tower'
        baselinename='';
    otherwise
end

if ~isempty(startFakeSecs)
    for pp=1:length(startFakeSecs)
        LineSecEnding = sprintf('_%dmm_%dE',round(1000*Ptfm.(StructName).t(1)) ,startFakeSecs(pp)); % this is not the proper thickness call.
        LineStruct.AllTypes{pp}= [baselinename LineSecEnding];
    end
else
    pp=0;
end
if isfield(Ptfm,StructName)
    if isfield(Ptfm.(StructName),'t')
        % COL, LMB, UMB
        [nSec,colv]=size(Ptfm.(StructName).t);
    end
elseif isfield(Turbine,StructName)
    if isfield(Turbine.(StructName),'t')
        %Tower
        [nSec,colv]=size(Turbine.(StructName).t);
    end
end

for ss=1:nSec
    if isfield(Ptfm,StructName)

        if colv>1
            if Ptfm.(StructName).t(ss,iC)~=0
                LineSecEnding=sprintf('_%dmm',round(1000*Ptfm.(StructName).t(ss,iC)) );% old js, name of LineType sections, hardcoded from getTrussLineTypes
            else
                LineSecEnding=sprintf('_%dmm',round(1000*Ptfm.(SecStructName).t(ss,iC)) );
            end
        else
            if isfield(Ptfm.(StructName),'t')
                if Ptfm.(BaseType).t(ss)~=0
                    LineSecEnding=sprintf('_%dmm',round(1000*Ptfm.(StructName).t(ss)) );
                else
                    LineSecEnding=sprintf('_%dmm',round(1000*Ptfm.(SecStructName).t(ss)) );
                end 
            end
        end
        
    else
        if isfield(Turbine.(StructName),'t')
            LineSecEnding=sprintf('%s_%dmm',Turbine.(StructName).Name(ss,:),round(1000*Turbine.(StructName).t(ss)) );
        else
            %blade
            LineSecEnding = LineSecs{ss};
        end
    end
    LineStruct.AllTypes{ss+pp}=[baselinename LineSecEnding];
end

%     % WEP
%     for ss=1:length(LineEndStr)
%         LineStruct.AllTypes{ss+pp} = [baselinename LineEndStr{ss}];
%     

if ~isempty(endFakeSecs)
    for ff=1:length(endFakeSecs)
        if isfield(Ptfm.(StructName),'t')
            LineSecEnding=sprintf('_%dmm_%dE',round(1000*Ptfm.(StructName).t(end)),endFakeSecs(ff));
        else
            LineSecEnding=sprintf('_%dE',endFakeSecs(ff));
        end
        LineStruct.AllTypes{ss+pp+ff}=[baselinename LineSecEnding];
    end
end
%% Specify the sections
if ~Ptfm.iRigid
    switch BaseType
        case 'COL'
            dL=[Ptfm.iCol.dL+Ptfm.UMB.dL Ptfm.UMB.dL Ptfm.UMB.dL]; %[Col1 Col2 Col3]
            AirGap=Ptfm.Col.H-abs(Ptfm.Col.Draft)+[Ptfm.iCol.dL 0 0];
            nLevels=size(Ptfm.iCol.H,1);
            if nLevels>2
                LineStruct.Length=[dL(iC) Ptfm.iCol.H(1,iC)-dL(iC) AirGap(iC)-Ptfm.iCol.H(1,iC) Ptfm.iCol.H(2,iC)-(AirGap(iC)-Ptfm.iCol.H(1,iC)) Ptfm.iCol.H(3:end-1,iC) (Ptfm.iCol.H(end,iC)-Ptfm.LMB.dL) Ptfm.LMB.dL];
                LineStruct.NumberOfSegments=[2 2 2 14 2 2];
                LineStruct.iType=[1 1  2 2:nLevels-1 nLevels nLevels];
            else
                LineStruct.Length=[dL(iC) Ptfm.iCol.H(1,iC)-dL(iC)-Ptfm.LMB.dL Ptfm.LMB.dL];
                LineStruct.NumberOfSegments=[2 20 2];
                LineStruct.iType=nLevels*ones(1,length(LineStruct.Length));
            end
        case {'UMB','LMB'} 
            %% FIRST HALF of MB
            FirstLength=[];
            FirstDiscret=[];
            if Ra>0
                FirstLength=[FirstLength Ra];
                FirstDiscret=[FirstDiscret 1];
            end
            FirstLength=[FirstLength ODID   llen-Ra-ODID ]; %llen-Ra-Rb-ODID-ODIDn
            FirstDiscret=[FirstDiscret 1 10 ];
            % if Struct Sections exist, then overwrite
            if isfield(Ptfm.(StructName),'L')
                % TODO: fix this for specified MB lengths
                FirstLength=[Ra, ODID, Ptfm.(StructName).L(1,iC)-ODID, Ptfm.(StructName).L(2:end-1,iC)']; %[Ra, ODID, Ptfm.(StructName).L(1,iC)-ODID, Ptfm.(StructName).L(2:end-1,iC)',Ptfm.(StructName).L(end,iC)-ODIDn, ODIDn,  Rb]
                FirstDiscret=[2, 1, 1, 10*ones(1,length(Ptfm.(StructName).L(2:end-1,iC)))];
            end
            %% Second HALF of MB
            SecondLength=[];
            SecondDiscret=[];
            if Rb>0
                SecondLength=[SecondLength Rb];
                SecondDiscret=[SecondDiscret 1];
            end
            SecondLength=[SecondLength ODIDn   llen-Rb-ODIDn ];
            SecondDiscret=[SecondDiscret 1 10];
            if isfield(Ptfm.(StructName),'L')
                % define lengths of line sections
                 % IS OS Can1 UMB 
                 % TODO: fix this for specified MB lengths
                SecondLength=[Rb, ODIDn, Ptfm.(StructName).L(1,iC)-ODIDn, Ptfm.(StructName).L(2:end-1,iC)']; %[Ra, ODID, Ptfm.(StructName).L(1,iC)-ODID, Ptfm.(StructName).L(2:end-1,iC)',Ptfm.(StructName).L(end,iC)-ODIDn, ODIDn,  Rb]
                SecondDiscret=[2, 1, 1, 10*ones(1,length(Ptfm.(StructName).L(2:end-1,iC)))];
            end
            %% Put halfs together
            if isempty(LevelNum)
                FlipSecondL=fliplr(SecondLength);
                LineStruct.Length=[FirstLength(1:end-1)  FirstLength(end)+FlipSecondL(1)-llen FlipSecondL(2:end)];              
                LineStruct.NumberOfSegments= [FirstDiscret(1:end-1) fliplr(SecondDiscret)];
            elseif LevelNum==1
                LineStruct.Length = FirstLength;
                LineStruct.NumberOfSegments= FirstDiscret;
            elseif LevelNum==2
                LineStruct.Length = fliplr(SecondLength);
                LineStruct.NumberOfSegments = fliplr(SecondDiscret);
            end

            LineStruct.iType=1:length(LineStruct.AllTypes);
        case 'VB'
            %VB number definition
            vnum=mod((nVB-1)+lnum,nVB)+1;
            iCol=mod(floor(lnum/nVB),nCol)+1;% column that the v-brace emanates from
            if isfield(Ptfm.VBr,'id1')
                if mod(vnum,2) %odd numbered vnums   
                    id=-Ptfm.VBr.id1(iC);
                else
                    id=-Ptfm.VBr.id2(iC);
                end
            else
                id= atan2( Ptfm.UMB.dL - (Ptfm.Col.H-Ptfm.LMB.dL), Ptfm.Col.L/2-Ptfm.VBr.dL); % declination angle from UMB of the angle of the v-brace (<0)
            end

            IDL=.5*Ptfm.iCol.D(iCol)/cos(-id);
            if IDL==0
               IDL=.5*Ptfm.Col.D(iCol)/cos(-id); % do something different to the outer shell
            end
            LMBL=.5*Ptfm.LMB.D(iCol)/sin(-id);
            if isfield(Ptfm.VBr,'L')
                LineStruct.Length=[IDL Ptfm.VBr.L(:,iCol)' LMBL];
                LineStruct.NumberOfSegments=[1 1 5*ones(1,length(Ptfm.VBr.L(2:end-1,iCol))) 1 1];%IDL Ptfm.VBr.L(1,iCol) .2*Ptfm.VBr.L(2:end-1,iCol)' Ptfm.VBr.L(end,iCol) LMBL];
            else
                LineStruct.Length=[IDL llen-IDL-LMBL LMBL];
                LineStruct.NumberOfSegments=[1 4 1];%[IDL (llen-IDL-LMBL)*.25 LMBL];
            end
            LineStruct.iType=1:length(LineStruct.AllTypes);
        case 'Tower'
            LineStruct.Length = Turbine.Tower.H;
            LineStruct.iType=1:length(LineStruct.AllTypes);
            LineStruct.NumberOfSegments = ones(length(LineStruct.AllTypes),1);
        case 'Blade'
            LineStruct.Length = llen;
            LineStruct.iType=1;
            LineStruct.NumberOfSegments=1;
        otherwise
            LineStruct.iType=1:length(LineStruct.AllTypes); % each WEP line only consists of 1 lineType for now
            LineStruct.Length = llen;
            LineStruct.NumberOfSegments = ones(1,length(LineStruct.AllTypes));
    end
else
    LineStruct.Length = llen;
    LineStruct.NumberOfSegments = 1;
    LineStruct.iType=1;
end
LineStruct.LineType = LineStruct.AllTypes(LineStruct.iType);
LineStruct.TargetSegmentLength=LineStruct.Length./LineStruct.NumberOfSegments;
end

% function Line=getLineProps(lnames,iRigid)
% 
% end
function Stiff=getLineStiff(lname,iRigid,iOF)
if iRigid
    Stiff.AX=0; % [N-m/deg] 
    Stiff.BX=0; % [N-m/deg] 
else
    if iOF
        Stiff.AX=ofx.OrcinaInfinity(); % [N-m/deg] 
        Stiff.BX=ofx.OrcinaInfinity(); % [N-m/deg] 
        Stiff.EndATwistingStiffness=ofx.OrcinaInfinity(); % 
        Stiff.EndBTwistingStiffness=ofx.OrcinaInfinity(); % 
    else
        % UNUSED!! (only when debuggin on Mac)
        Stiff.AX=0; % [N-m/deg] 
        Stiff.BX=0; % [N-m/deg] 
    end
end
end
function Orient=getLineOrient(lname,Model,Ptfm,iRigid,OFver,lpts,ConnectA,ConnectB,varargin)
nVB=2;nCol=3;
if nargin>8
    lptsA = varargin{1};
else
    lptsA=zeros(2,3);
end
lnum=str2double(regexp(lname,'\d','match'));
laz=mod(atan2(lpts(2,2)-lpts(1,2),lpts(2,1)-lpts(1,1)),2*pi);
ltrs=regexp(lname,'[a-zA-Z]+','match');
GAX=lpts(1,:);
GBX=lpts(2,:);
if ~isempty(ltrs)
    BaseType=ltrs{1};
end
 %% Define default orientation properties
Orient.az=0;
Orient.dec=0; %[deg]
Orient.gam=0; %[deg] 
if ~iRigid
switch BaseType
    case 'Tower'
       if OFver>=10
            Orient.az.A=0; Orient.dec.A=180; Orient.gam.A=0;
            Orient.az.B=0; Orient.dec.B=0; Orient.gam.B=0;
           %[Orient.az.A,Orient.dec.A,Orient.gam.A,Orient.az.B,Orient.dec.B,Orient.gam.B]=getAzInOF(Model,lname,GAX,GBX,ConnectA,ConnectB,'+X');
       else
           Orient.az=0; Orient.dec=180; Orient.gam=0;
       end
   case 'Blade'
%        laz=mod(atan2(lpts(2,3)-lpts(1,3),lpts(2,2)-lpts(1,2)),2*pi);
%             Orient.az.A=90; Orient.dec.A=mod(laz*180/pi,180); Orient.gam.A=0; % build from the top bottom
%             Orient.az.B=90; Orient.dec.B=mod(laz*180/pi,180); Orient.gam.B=0;
        [Orient.az.A,Orient.dec.A,Orient.gam.A,Orient.az.B,Orient.dec.B,Orient.gam.B]=getAzInOF(Model,lname,GAX,GBX,ConnectA,ConnectB,'','+X'); % y points into the wind
    case 'COL'
%         if ~iRigid
%             Orient.az=0;
%             Orient.dec=180; %[deg], line is built going from top to bottom
%             Orient.gam=0; %[deg] 
%         end
        [Orient.az.A,Orient.dec.A,Orient.gam.A,Orient.az.B,Orient.dec.B,Orient.gam.B]=getAzInOF(Model,lname,GAX,GBX,ConnectA,ConnectB,'+X');
    case {'UMB','LMB'}
        if ~iRigid
           Orient.az.A=180-mod(laz*180/pi,360); Orient.az.B =Orient.az.A;
           Orient.dec.A=90; Orient.dec.B=Orient.dec.A;
           Orient.gam.A=0;  Orient.gam.B= Orient.gam.A;
           if OFver>9
               if strcmp(ConnectB,'Free')
                   %LMB#a
                   Orient.az.B=mod(laz*180/pi,360);
                   Orient.dec.B=90;
                   Orient.gam.B=180; %[deg]
               elseif ~isempty(strfind(ConnectA,'LMB'))
                   % LMB#b
                    Orient.az.A=0;
                    Orient.dec.A=0;
                    Orient.gam.A=0;
               else
                   % UMBs
               end
           else
               % connected to buoys
           end
        else
            % rigid model
        end
    case 'VB'
        %iC=mod(floor(lnum/nVB),nCol)+1;% column that the v-brace emanates from
        iC=ceil(lnum/nVB); % number of frame that you're in
        if mod(lnum,2) %odd numbered vnums   
            id=-Ptfm.VBr.id1(iC);
        else
            id=-Ptfm.VBr.id2(iC);
        end
        if OFver>9
            if mod(lnum,2) %odd numbered vnums
                Orient.az.A=mod(180-laz*180/pi,360); %[deg]
                Orient.dec.A=(pi/2+id)*180/pi; % something feels wrong here
                Orient.gam.A=0;
                Orient.az.B=180;
                Orient.dec.B=-id*180/pi;  % something feels wrong here, the dec of both ends should be equal when connections are set to Free
                Orient.gam.B=180;   
            else
                Orient.az.A=mod(180-laz*180/pi,360); %[deg] who knows why!??!
                Orient.dec.A=(pi/2+id)*180/pi; % something feels wrong here
                Orient.gam.A=180;
                Orient.az.B=180;
                Orient.dec.B=180+id*180/pi; % something feels wrong here
                Orient.gam.B=180;
            end
        else
            if mod(lnum,2) %odd numbered vnums
                Orient.az=mod(laz*180/pi,360);
            else
                Orient.az=mod(180+laz*180/pi,360);
            end
            Orient.dec=-id*180/pi+90;
            Orient.gam=0;
        end
    case 'WEP'
        if OFver>=10
            [Orient.az.A,Orient.dec.A,Orient.gam.A,Orient.az.B,Orient.dec.B,Orient.gam.B]=getAzInOF(Model,lname,GAX,GBX,ConnectA,ConnectB,'','+Z');
        end
end
end
end
function Model=buildMooring(Model,Ptfm,MLname,X1,OFver,iRigid)
ColX=getColX(Ptfm,[2*Ptfm.Col.Lh/3 0 0]);
if isfield(Ptfm,'ML1')
    WFXnames=fieldnames(Ptfm);
    iML=strncmp(WFXnames,MLname,length(MLname));
    MLnames=WFXnames(iML);
    nML=length(MLnames);
   if Ptfm.iRigid
       iAngles=pi - (Ptfm.Col.Angle+Ptfm.Col.Angle([2 3 1]))/2;
       iAngles=cumsum(iAngles);
       iAngles=iAngles([3 1 2]);
   else
       iAngles=(Ptfm.Col.Angle+Ptfm.Col.Angle([2 3 1]))/2;
       iAngles=cumsum(iAngles)+[0 pi 0];
       iAngles=iAngles([3 1 2]);
   end
    for jj=1:nML
        jAngle=mod(atan2(ColX(jj,2),ColX(jj,1)),2*pi);
        jName=MLnames{jj};
        colR=Ptfm.Col.D(jj)/2;
        AX = [ColX(jj,1),ColX(jj,2),-abs(Ptfm.Col.Draft)] + colR*[cos(jAngle) sin(jAngle) 0]; %-norm(AX(1:2),2)
        AXr=colR*[cos(jAngle) sin(jAngle) 0]+[0 0 Ptfm.Col.H+Ptfm.iCol.dL*(jj==1)];
        zAnchored=0.141; % wtf? where does this come from?
        BX = [-2*Ptfm.Col.Lh/3 0 zAnchored] + (Ptfm.(jName).Radius)*[cos(jAngle) sin(jAngle) 0]; % mooring radius taken from the center of platform
        
        [ConnectA,ConnectB]=getFlexibleConnect(MLname,OFver,'',jName,'');
        nSec=size(Ptfm.(jName).Sec);
        for pp=1:nSec
            Struct.Length(pp) = Ptfm.(jName).Sec{pp,2};
            Struct.LineType{pp} = Ptfm.(jName).Sec{pp,1};
            try 
                foo=Model(Struct.LineType{pp});
            catch
                error('Mooring Line Type does not exist in model. Best to create it using Orca Wizard first.')
            end
            if Struct.Length(pp)<10
                Struct.TargetSegmentLength(pp) = floor(Struct.Length(pp)/5);
            elseif Struct.Length(pp)>=10 && Struct.Length(pp)<50
                Struct.TargetSegmentLength(pp) = floor(Struct.Length(pp)/10);
            elseif Struct.Length(pp)>=50 && Struct.Length(pp)<200
                Struct.TargetSegmentLength(pp) = floor(Struct.Length(pp)/15);
            else
                Struct.TargetSegmentLength(pp) = floor(Struct.Length(pp)/20);
            end
            
        end
        Orient=getLineOrient(jName,Model,Ptfm,iRigid,OFver,[AXr;BX],ConnectA,ConnectB);
        Stiff=getLineStiff(jName,1,1); %always want 0 connetion stiffness
        if iRigid
            Convert2Col=[1 1 1];
        else
            Convert2Col=[-1 1 1]; %end Col axes are x-axis is negative
        end
        myLine=buildOrcaLine(Model,jName,ConnectA,ConnectB,AXr.*Convert2Col,BX,Orient,Stiff,Struct);
    end
else
    error('Cannot build mooring if it does not exist in WFX spreadsheet.')
end

end
function Model=modifyMooring(Model,Ptfm,MLname,X1,iRigid)
    mod_obj = Model.objects;
    ColX=getColX(Ptfm,X1);
   iML=strncmp(cellfun(@(x) x.Name, mod_obj, 'UniformOutput', false),MLname,2);
   ModML = mod_obj(iML); 
   nML=length(ModML);
   if Ptfm.iRigid
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
end

function Model=addSecondarySteelAndBallast(Model,Ptfm,Turbine,OFcolors)
 %% Build the point masses on the columns (representing the OS and the flats, etc) and ballasts!!
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
 ColX=getColX(Ptfm,Ptfm.X1);
nCol=length(Ptfm.Col.D);
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

    % build an extra buoy to take up all the extra mass in the
    % inner col ??
        
    %% Active Ballast
    if isfield(Ptfm,'ABallast')
        kCOG=Ptfm.ABallast.X(:,kk)'-Ptfm.X1;
        Xrel=getRelX(Model,kColN,[ColX(kk,1:2) kCOG(3)]);
        pcolor=255*65536+255*256+0; % b, g, r
        %Xrel= [kCOG(1:2)-ColA(1:2) zAbs+zR-kCOG(3)];%+Ptfm.Col.Draft+Ptfm.Col.H];
        clump=buildAndAttachClump(Model,sprintf('%s-Col%d','AB',kk),Xrel(3),Ptfm.ABallast.M(kk),kColN,iClear(kk),pcolor);
    end
     %% Permanent Ballast
    %Permanent Ballast (add in the weight of the turbine, if you
    %want to build the model without the turbine)
    if isfield(Ptfm,'PBallast')
        if Turbine.iTower
            kCOG=Ptfm.PBallast.X(:,kk)'-Ptfm.X1;
            PBM=Ptfm.PBallast.M(kk);
        else
            kCOG=[ Ptfm.PBallast.X(1:2,kk)' Ptfm.PBallast.X(3,2)]-Ptfm.X1;
            PBM=Ptfm.PBallast.M(2);
        end
        pcolor=255*65536+255*256+0; % b, g, r
        %Xrel= [kCOG(1:2)-ColA(1:2) zAbs+zR-kCOG(3)];%+Ptfm.Col.Draft+Ptfm.Col.H];
        Xrel=getRelX(Model,kColN,[ColX(kk,1:2) kCOG(3)]);
        clump=buildAndAttachClump(Model,sprintf('%s-Col%d','PB',kk),Xrel(3),PBM,kColN,iClear(kk),OFcolors(1));
    end
end
% TOWER Point Masses
if Turbine.iTower
    nFlange=length(Turbine.Flange.M);
    iClear=zeros(nFlange,1); iClear(1)=1;
    for nn=1:nFlange
       %nCOG = [0 0 Turbine.Flange.Z(nn)+]+Ptfm.X1;
       %Xrel=getRelX(Model,'Tower',nCOG);
       clump=buildAndAttachClump(Model,['Tower-' Turbine.Flange.Name(nn,:)],Turbine.Flange.Z(nn),Turbine.Flange.M(nn),'Tower',iClear(nn),OFcolors(1));
    end
end
end
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
    nSect=length(Struct.Length);
    myLine.NumberOfSections=nSect;
    for jj=1:nSect
        myLine.Length(jj)=Struct.Length(jj);
        myLine.LineType(jj)=Struct.LineType{jj};
        if isfield(Struct,'TargetSegmentLength') 
           myLine.TargetSegmentLength(jj)=Struct.TargetSegmentLength(jj);
        elseif isfield(Struct,'NumberOfSegments') 
             myLine.NumberOfSegments(jj)=Struct.NumberOfSegments(jj);
        end
    end
    %% Drawing
    if ~isempty(strfind(lname,'WEP')) || ~isempty(strfind(lname,'ML')) 
    else
        myLine.DrawNodesAsDiscs='Yes';
    end
end

function buildMyVessel(Model,vname,X,Xt,Xb,iRigid)
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
%     if iFAST
%         vessel.PrimaryMotion='Externally Calculated'; %OrcaFAST
%         vessel.ExternallyCalculatedPrimaryMotion='ExtFn';
%     else
        vessel.PrimaryMotion='Calculated (6 DOF)'; %OrcaFlex
        vessel.PrimaryMotionIsTreatedAs='Both low and wave frequency';
        vessel.PrimaryMotionDividingPeriod=500; %[s] so says Sandra...
   %end
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

function  buoy=buildOrca6buoy(Model,bname,Connect,X,M,MOI,COG,LD,pcolor,vertex,varargin)
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
if nargin<8
    LD=zeros(1,6);
end
%this buoy represents the net
if nargin<9
    pcolor= 0*65536+255*256+255; %=yellow
end
% if nargin<10
%     COV=[0 0 0];
% end
COV=[0 0 0];
if length(X)<4
    X=[X zeros(1,3)];
end
if nargin<10
    ivert=1;
else
    if isempty(vertex)
        ivert=1;
    else
        ivert=0;
    end
end
if ivert
    %draw a cube by default
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
    buoy.InitialRotation1=X(4);
    buoy.InitialRotation2=X(5);
    buoy.InitialRotation3=X(6);
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
    buoy.UnitDampingForceX = LD(1); buoy.UnitDampingForceY = LD(2); buoy.UnitDampingForceZ = LD(3);
    buoy.UnitDampingMomentX = LD(4); buoy.UnitDampingMomentY = LD(5); buoy.UnitDampingMomentZ = LD(6);
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
            %[CaU,foo,wunique(PtfmWEP.CaOrca);
%             WEPstrs=PtfmWEP.Pts(:,1);
%             ibl=strfind(WEPstrs,'"');
%             iWEPbl=find(not(cellfun('isempty', ibl)));
%             WEPstrsU=WEPstrs(iWEPbl(1)+1:iWEPbl(2)-1);
%             itmp=strfind(WEPstrsU,SecType);
%             iWEP=find(not(cellfun('isempty', itmp)));
            %nWEPtypes=length(LineStruct.AllTypes);
            %nEtypes=nWEPtypes-Ptfm.nUwep;
%             if ~isempty(LineEndStr)
%                 %AllTypesTrunc=cellfun(@(x) x(1:min([length(x) length(baselinename)+2])), AllTypes, 'UniformOutput', false);
%                 colnumcellstr=regexp(LineStruct.AllTypes,[baselinename '(\d+)'], 'tokens', 'once');
%                 itmp=strfind([colnumcellstr{:}],num2str(iC));
%                 iWEPtype=find(not(cellfun('isempty', itmp)));
%                 
%                 Enumcell=cellfun(@(x) str2double(x),regexp(LineStruct.AllTypes,'_(\d+)', 'tokens', 'once'),'UniformOutput', false);
%                 %itmp=strfind(AllTypesTrunc,num2str(iC));
%                 %iWEPtype=find(not(cellfun('isempty', itmp)));
%                 if iWEPtype>1
%                     if ~isempty(strfind(PtfmWEP.specWEP,SecType))
%                         ispecWEPtmp=strfind(PtfmWEP.specWEP,SecType);
%                         ispecWEP=find(not(cellfun('isempty', ispecWEPtmp)));
%                         LineStruct.iType=iWEPtype(1+ispecWEP);
%                     else
%                         LineStruct.iType=iWEPtype(1);
%                     end
%                 else
%                     LineStruct.iType=iWEPtype(1);
%                 end                        
%             else
%                 LineStruct.iType=1; 
%             end
%         dec0=90; %90 for y pointing up, 90 for x pointing down
%         gam0=90; %90 for y pointing up, 0 for x pointing down
%         Orient.az=laz*180/pi; % default angles, may get overwritten in flexible WEP
%         Orient.dec=dec0; %
%         Orient.gam=gam0; %
%         lazA=mod(atan2(lptsA(2,2)-lptsA(1,2),lptsA(2,1)-lptsA(1,1)),2*pi);
%         [az,dec,gam]=getaz(laz*180/pi,dec0,gam0,lazA*180/pi,0,gam0);
%         if ~iRigid
%             Orient.az.A=az;
%             Orient.dec.A=dec;
%             Orient.gam.A=gam;
%             Orient.az.B=laz*180/pi;
%             Orient.dec.B=dec0;
%             Orient.gam.B=gam0;
%         end
%         if ~isempty(strfind(ConnectA,'Col')) || ~isempty(strfind(ConnectB,'Col')) % second to last line                                
% %             AA=Model(ConnectB);
% %             [az1,dec1,gam1]=getaz(laz,dec0,gam0,AA.EndAAzimuth,AA.EndADeclination,AA.EndAGamma);
% %             Orient.az.B=180;
% %             Orient.dec.B=dec1;
% %             Orient.gam.B=180;
%         else
%             Orient.az.A=az;
%             Orient.dec.A=dec;
%             Orient.gam.A=gam;
%             Orient.az.B=laz;
%             Orient.dec.B=dec0;
%             Orient.gam.B=gam0;            
%         end