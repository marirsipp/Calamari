function [WFpts,WFlabels]=getWFpts(linenames,nLevel,PtfmName,X1,iR,iPlot,iBuoy,WEPtype,OFver,varargin)
% INPUTS:
% linenames = cell array giving the members of a single WF frame. The most
% common is {'COL','UMB','LMB','VB','VB'};
%
% nLevel = numerical array with size [nLines x 1], of number of segments per line,
% 
% PtfmName = String containing reference to WindFloatX spreadsheet/matfile
%
% X1 = [1 x 3] vector containing location of intersection of Col 1 with
% SWL
%
% iR = (logical) if TRUE, then line members will stop at shells; if FALSE,
% line members continue through to intersection points
% 
% iPlot = (logical) if TRUE, a pretty 3D figure of your WF is generated
%
% OUTPUTS:
% WFpts = [nLines*3*2 x 3] vector containing beginning and end locations of
% all line members
%
% WFlabels = {nLines*3*2 x 1} cell array containing names of line members 
% 
if nargin<2
    nLevel=ones(1,5);
end
% Ptfm is structure about platform geometry obtained from getMyPtfm('')
% (this function calls the spreadsheet contained in the WindFloatX
% repository)
if nargin<3
    PtfmName='WFA';
end
Ptfm=getMyPtfm(PtfmName);
%Ptfm.Heading=90*pi/180;
% ColX is an array (nCol x 3) where the i'th row is the XYZ of the center
% of the keel of the i'th column. 
if nargin<4
    X1=[0,0,0]; %center of column 1 is at [0,0,0]
end
if nargin<5
    iR=0; % iR= iRigid = 1 for regular WF model (with vessel), linenames will stop at outer shell 
    % if iR =0, linenames intersect with each other. 
end
if nargin<6
    iPlot=0; % see a 3D view of your stick figure WindFloat
end
if nargin<7
    iBuoy=0; % don't build the buoys (used in OrcaFlex)
end
if nargin<8 
    % don't do anything
else
    if isempty(WEPtype)
       % don't do anything 
    else
        [WEPpts, WEPlabels,KBpts,KBlabels]=getMyWEP(WEPtype,Ptfm); %defined in the global coordinate
    end
    % need to rotate
end
if nargin<9
    OFver=10;
end
%%%%%%%-------------------- BEGIN CODE-----------------%%%%%%%%
if Ptfm.Col.Draft>0
    Ptfm.Col.Draft=-1*Ptfm.Col.Draft;
end
%linenames={'COL','UMB','LMB','VB','VB'}; % order
ltrs={'a','b','c','d','e','f','g','h','i','j','k','l'};
nL=length(linenames);
if length(nLevel) ~=nL
    error('define a discretization level for each type of line')
end
ColX=getColX(Ptfm,X1);
nCol=length(Ptfm.Col.D);
if iPlot
    h1=figure('name','WindFloat 3D View');
    %h2=figure('name','WindFloat Elevation View');
%     axis equal
%     hold on
%     xlabel('Easting (m)')
%     ylabel('From MWL (m)')
    iaz=[0:pi/1280:2*pi];
    nC=36;
    for ii=1:nCol
        [Xc,Yc,Zc]=cylinder(Ptfm.Col.D(ii)*.5,nC);
        figure(h1)
        plot3(ColX(ii,1)+.5*Ptfm.Col.D(ii)*cos(iaz),ColX(ii,2)+.5*Ptfm.Col.D(ii)*sin(iaz),Ptfm.Col.zh*ones(length(iaz),1),'r-') 
        hold on
        
        surf(Xc+repmat(ColX(ii,1),size(Xc)),Yc+repmat(ColX(ii,2),size(Xc)),repmat([Ptfm.Col.zh;Ptfm.Col.Draft],[1 size(Xc,2)] ),'facealpha',.4 ,'edgecolor','none')
        plot3(ColX(ii,1)+.5*Ptfm.Col.D(ii)*cos(iaz),ColX(ii,2)+.5*Ptfm.Col.D(ii)*sin(iaz),Ptfm.Col.Draft*ones(length(iaz),1),'r-') 
    end
    plot(mean(ColX(:,1)),mean(ColX(:,2)),'x','markersize',16)
    grid on
    axis equal
    xlabel('Easting (m)')
    ylabel('Northing (m)')
end

[nCol,foo]=size(ColX);
ColX=[ColX;ColX];
nP=2*sum(nLevel); % number of points per column
pts=nan(nCol*nP,3);
labels=cell(nCol*nP,1);
ColH=Ptfm.Col.H;
MBH=ColH-Ptfm.UMB.dL-Ptfm.LMB.dL;
id= atan2( Ptfm.UMB.dL - (ColH-Ptfm.LMB.dL), Ptfm.Col.L/2-Ptfm.VBr.dL); % declination angle from UMB of the angle of the v-brace (<0)

if length(Ptfm.Col.L)==1
    id=repmat(id,[1 nCol]);
    Ptfm.Col.L=repmat(Ptfm.Col.L,[1 nCol]);
end
if length(Ptfm.Col.D)==1
    Ptfm.Col.D=repmat(Ptfm.Col.D,[1 nCol]);
end
if length(Ptfm.LMB.D)==1
    Ptfm.LMB.D=repmat(Ptfm.LMB.D,[1 nCol]);
end
dX=[0,0,0];
BuoyU=zeros(nCol,3);
BuoyL=zeros(nCol,3);
% 3 V-braces??
nVB= sum(ismember(linenames,'VB'));
for iC=1:nCol
    iCn=mod(iC,3)+1;
    ColD=Ptfm.Col.D(iC); % diameter of i'th col
    ColDn=Ptfm.Col.D( mod(iC,3)+1 ); % diameter of (i+1)'th col
    ia=atan2( (ColX(iC+1,2) - ColX(iC,2)), (ColX(iC+1,1) - ColX(iC,1))   ); % azimuthal angle from iC'th col to (iC+1)'th col
    lenMB=sqrt((ColX(iC+1,2) - ColX(iC,2))^2 + (ColX(iC+1,1) - ColX(iC,1))^2 ) -iR*.5*(ColD+ColDn);
    vb=0;
    for jj=1:nL %COL,UMB, LMB, VB, VB, (VB?)
        AX=[ ColX(iC,1:2) Ptfm.Col.Draft+ ColH-Ptfm.UMB.dL]; % current position of cursor on UMB/COL CL on i'th column
        AX=AX+dX;
        avec=[cos(ia) sin(ia) 0]; %default is azimuthal
        jline=linenames{jj};
        jlev=nLevel(jj);
        if strcmp(jline(2:end),'MB')
            % top projection-x,top projection-y, side projection-z
            len=[lenMB lenMB 0]; 
            lnum=iC;
            d1=ColD/2*avec*iR;
            %dn=ColDn/2*avec; 
        elseif strcmp(jline,'VB')
            vb=vb+1; %v-brace number on the current building planes, goes 1,2..., nVB (resets to 0 for every building plane)          
            jColR=.5*ColD*(vb==1)+.5*ColDn*(vb==nVB); % for the first VB use the i'th diameter, for the last VB use the (i+1)'th diameter
            jid= -Ptfm.VBr.id1(iC)*(vb==1)-Ptfm.VBr.id2(iC)*(vb==nVB);          % for the first VB use the i'th diameter, for the last VB use the (i+1)'th diameter
            lenXY= Ptfm.Col.L(iC)*(1/nVB)-Ptfm.VBr.dL-iR*jColR-iR*Ptfm.LMB.D(iC)/(2*tan(-jid));
            lenZ=MBH-Ptfm.VBr.dZ-iR*jColR*tan(-jid)-iR*Ptfm.LMB.D(iC)*.5;            
            len=[lenXY lenXY sqrt(lenXY^2+lenZ^2)];
            lnum=2*(iC-1)+vb; % vbrace number
            %% ASSUME V-Brace goes in zig-zag pattern
            if mod(vb,2) %odd v-brace number
                avec=[avec(1:2) sin(jid)]; %angle going down...
                d1=ColD/2*[avec(1:2) tan(jid)]*iR+[0,0,-Ptfm.VBr.dZ];
            else  % even v-brace number
                avec=[cos(pi+ia) sin(pi+ia) sin(jid)]; %angle going down, but building it backwards...
                d1=ColDn/2*[avec(1:2) tan(jid)]*iR+[0,0,-Ptfm.VBr.dZ];
                % move from hull centerline on LMB to next VB
                %VBd=(Ptfm.LMB.D/(2*tan(-id)) +Ptfm.VBr.dL);
                %d1=[VBd VBd Ptfm.LMB.D*.5].*[avec(1:2) sin(pi/2)];
            end
        elseif strcmp(jline,'COL')
            BuoyU(iC,:)=AX;
            if iC==1
                 d1=[0 0 Ptfm.UMB.dL+Ptfm.iCol.dL]; % build the inner shaft-tower base
                 len =[0 0 Ptfm.Col.H+Ptfm.iCol.dL]; 
                 %d1=[0 0 0]; % build the inner shaft-tower base
                 %len =[0 0 Ptfm.Col.H-Ptfm.UMB.dL]; 
            else
                d1=[0 0 Ptfm.UMB.dL];
                len =[0 0 Ptfm.Col.H]; 
            end
            
            avec=[avec(1:2) sin(-pi/2)];
            lnum=iC;
            
        end
        %% Build nLevel(jj) segments per each Line
        lseg=len/jlev;
        lseg0=lseg;
        AX=AX+d1; % move the cursor to the initial position (e.g. outer shell of Col i)
        for ii=1:jlev
            if strcmp(jline(2:end),'MB') && iR                 
                if mod(jlev+1,2) % even number of segments
                    % if its closer to beginning column , add the
                    % difference
                    jColDiff=.5*(ColD-ColDn)/jlev; 
                    %bnum=2*(iC-1)+ii;
                    %enum=2*iC-mod(ii-1,jlev);
                    cnum=round(ii/(jlev+1));
                    inum=cnum + ~cnum*-1;
                    lseg=lseg0+inum*jColDiff*[1 1 0];
                end
            end
            BX=AX+lseg.*avec; %move the cursor along
            if jlev==1
                lend='';
            else
                lend=ltrs{ii};
            end 
            lname=sprintf('%s%d%s',jline,lnum,lend);
            % put them in order by linetype - VB needs to be at the end of linenames{} in order for this numbering to work properly!!
            iP=nCol*2*sum(nLevel(1:(jj-1)))+(iC-1)*2*jlev+ 2*(ii-1)+1;
            if strcmp(jline,'VB')
                iVB=find(ismember(linenames,'VB'));
                iP=nCol*nVB*sum(nLevel(1:iVB(1)-1))+2*jlev*(lnum-1)+ 2*(ii-1)+1;
            end
            if ii==1
                iP1=iP;
                if jlev==1
                    iP2=iP+1;
                end
            elseif ii==jlev
                iP2=iP+1;
            end
            pts( iP:iP+1,:)=[AX;BX];
            labels{iP}=lname;
            labels{iP+1}='';
            AX=BX; %move the cursor along
        end
        %% Advance the cursor
        %AX=[AX+dn*iR]; % move the cursor out to the center of the next column
        if strcmp(jline,'UMB')
            % move from cursor from UMB to LMB
            dX=[0,0, Ptfm.UMB.dL-ColH+Ptfm.LMB.dL];            
%         elseif jj==2
%             % move from cursor from LMB to VB (back up to UMB)
%             dX=[0,0,0];% -Ptfm.LMB.dL+ColH-Ptfm.UMB.dL];
        elseif strcmp(jline,'VB') && vb==1
            % move the cursor to hull centerline on LMB if you're on the
            % first VBrace
            %dX=[avec(1:2)*Ptfm.Col.L*.5, Ptfm.UMB.dL-ColH+Ptfm.LMB.dL];
            %move the cursor to the next column
            dX=Ptfm.Col.L(iC)*[avec(1:2) 0];
        elseif strcmp(jline,'COL')
            dX=[0,0,0];
            %figure(h2)
            %plot(pts(iP1:iP2,2),pts(iP1:iP2,3),'ko-')
        else
            dX=[0,0,0];
        end
        if iPlot
            figure(h1)
            plot3(pts(iP1:iP2,1),pts(iP1:iP2,2),pts(iP1:iP2,3),'ko-','linewidth',2)
        end
    end
    if iPlot
        figure(h1)
%         iXm=mean([OStopA(iC,1) OStopB(iC,1)]);
%         iYm=mean([OStopA(iC,2) OStopB(iC,2)]);
        iXm=mean([ColX(iC,1) ColX(iCn,1)]);
        iYm=mean([ColX(iC,2) ColX(iCn,2)]);
        UMBz=Ptfm.Col.Draft+ ColH-Ptfm.UMB.dL;
        dMB=Ptfm.UMB.dL-ColH+Ptfm.LMB.dL;
        plot3([iXm iXm],[iYm iYm] ,[UMBz UMBz+dMB],'k-.')
    end
end

UpLow={'U','L'};
BUpts=zeros(nCol*length(UpLow),3);
BUlabels=cell(nCol*length(UpLow),1);
for ii=1:nCol
    BuoyUName=sprintf('%s%d %s',linenames{1},ii,UpLow{1});
    BuoyLName=sprintf('%s%d %s',linenames{1},ii,UpLow{2});
    dX=[0,0, Ptfm.UMB.dL-ColH+Ptfm.LMB.dL];
    BuoyL(ii,:)=BuoyU(ii,:)+dX;
    BUpts(length(UpLow)*(ii-1)+1: length(UpLow)*ii,:)=[BuoyU(ii,:);BuoyL(ii,:)];
    BUlabels(length(UpLow)*(ii-1)+1: length(UpLow)*ii)={BuoyUName;BuoyLName};
end 
if iBuoy
    if OFver<10
        WFpts=[BUpts;pts]; %  % build buoys first
        WFlabels=[BUlabels;labels];
    else
        WFpts=[pts;BUpts];  % build buoys second
        WFlabels=[labels;BUlabels];
    end
else
    WFpts=pts;
    WFlabels=labels;
end

if exist('WEPpts','var')
    BOTpts=[WEPpts;KBpts] ;
    nWFpts=size(BOTpts,1);
    BOTpts=BOTpts+repmat(X1,[nWFpts 1]);
    for ii=1:2:length(BOTpts)
        plot3(BOTpts(ii:ii+1,1),BOTpts(ii:ii+1,2),BOTpts(ii:ii+1,3),'ko-')
    end
    WFpts=[WFpts;BOTpts];
    WFlabels=[WFlabels;WEPlabels;KBlabels];
end
if size(WFpts,1)~=size(WFlabels)
    error('Number of WFpts does not equal Number of WFlabels. Look into vertcat of cell array')
end
end