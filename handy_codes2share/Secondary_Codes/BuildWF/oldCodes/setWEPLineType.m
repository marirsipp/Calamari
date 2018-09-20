function [linenames,varargout]=setWEPLineType(Ptfm,WEPtype,WEPpts,WEPlabels,nUwep,nX,specWEP,CaTotal,CdDes,varargin)
%iBuild,Model,iRigid,iWEB,CaTotal,CdDes,nX,specWEP,nUwep)
if nargin<=9
    iBuild=0;
    iRigid=1;
else
    iBuild=varargin{1};
    Model=varargin{2};
    iRigid=varargin{3};
    iWEB=varargin{4};
end
%% TODO: look at calc_wep_plate_area function
WEPD=.305; % How to get buoyancy of WEP?
CdDiam=.305; %[m] Isn't this arbitrary?!?
AddedMWEP=2.1E7/3;
if nUwep==1
    WEPendstr={''};
elseif nUwep==2
    WEPendstr={'1','23'};
else
  WEPendstr={'1','2','3'}; 
end
CdOrca=zeros(nUwep,1);
WEParea=zeros(nUwep,1);
CaCtr = zeros(nUwep,2); % just XY coords
TotalAddedM = zeros(nUwep,1);
%% get column coordinates
ColX=getColX(Ptfm,[0 0 0]);
%% WEPs!
AX=WEPpts(1:2:end-1,:);
BX=WEPpts(2:2:end,:);
nCol=length(Ptfm.Col.D);
nP=length(AX)/nCol;
j1=1;
Cas=zeros(nP,nUwep);
for jj=1:nUwep
    
    WEPjA=AX(j1:j1+nP-1,:);
    WEPjB=BX(j1:j1+nP-1,:);
    % get column coordinates
    %get column cut-out
    iab=atan2(WEPjA(2,2)-ColX(jj,2),WEPjA(2,1)-ColX(jj,1))-2*pi;
    iaa=atan2(WEPjB(1,2)-ColX(jj,2),WEPjB(1,1)-ColX(jj,1));
    iad=-pi/128;
    ia1=transpose(iaa:iad:iab);
    coljr=Ptfm.Col.D(jj)*.5*[cos(ia1) sin(ia1)]+repmat(ColX(jj,1:2),[length(ia1) 1]);
    % correct order
    WEP1x=[WEPjA(2:end,1);WEPjA(1,1);WEPjB(1,1)];
    WEP1y=[WEPjA(2:end,2);WEPjA(1,2);WEPjB(1,2)];
    
    WEP1xp=[WEP1x;coljr(:,1)];
    WEP1yp=[WEP1y;coljr(:,2)];
%     figure(10)
%     plot(WEP1xp,WEP1yp,'k-o',ColX(jj,1),ColX(jj,2),'ro')
%     hold on
%     axis equal
    WEParea(jj)=polyarea(WEP1xp,WEP1yp);
    %% Want CdDes*WEParea == CdOrca*Perimeter*CdDiam
    WEPperim=sum(sqrt(  sum( (WEPjA-WEPjB).^2,2 ) ),1);
    CdOrca(jj)=CdDes*WEParea(jj)/(WEPperim*CdDiam);
    %L1=sum(sqrt(  sum( (AX(1:10,:)-BX(1:10,:)).^2,2 ) ),1); %all the distances between the nodes
    %% Extra Added-Mass in flexible model
%     RefMassTotal = 1025*pi*(WEPD/2)^2* WEPperim;
%     CaTotal=AddedMWEP/RefMassTotal;
    WEPjlabel=WEPlabels(2*j1-1:2:2*j1+nP*2-2); % might be easier just to search for col number

    specidx=zeros(nP,1);
    for pp=1:length(specWEP)
        specidxP=cellfun(@(s) strcmp(s(5),specWEP{pp}),WEPjlabel); % check on the fifth characters
        specidx=specidx+specidxP;
        
    end
    specidxF=find(specidx); % get index numbers of logical vector
    LE=sum(sqrt(  sum( (AX(specidxF,:)-BX(specidxF,:)).^2,2 ) ),1);
%CaTotal=500;%500 %Sandra = 600
%CmT=900.0; % Sandra = 1000 -> Don't need anything but Ca+1
%nX=2.75; %3.8 multiplier for the Ca on line E, 3.92 is max
    eX=(WEPperim-nX*LE)/(WEPperim-LE);
% nX*CaT
% eX*CaT
% pause
% center of added mass
        % get the center of each line
        WEPxy=[ mean([WEPjA(:,1) WEPjB(:,1)],2) mean([WEPjA(:,2) WEPjB(:,2)],2)];
        
        for pp=1:nP
            if specidx(pp)>0
                Cas(pp,jj)=nX*CaTotal;
            else
                Cas(pp,jj)=round(eX*CaTotal);
            end     
        end
        CaCtr(jj,:)=sum(repmat(Cas(:,jj),[1 2]).*WEPxy,1) ./ sum(Cas(:,jj)) - ColX(jj,1:2);
        RefMass = 1025*pi*(WEPD/2)^2* sqrt(  sum( (WEPjA-WEPjB).^2,2 ) ); %https://www.orcina.com/SoftwareProducts/OrcaFlex/Documentation/Help/Content/html/LineTheory,HydrodynamicandAerodynamicLoads.htm
        TotalAddedM(jj)= sum(Cas(:,jj).* RefMass);
    
    linenames{jj}= ['WEP' WEPendstr{jj}];
    j1=j1+nP;

    if iBuild
     %% SET WEP line characteristics depending on type of model    
        if iRigid
            WEPD=10e-6;
            MPUL(jj)=10e-6 ; % [kg/m] taken into account in WAMIT import
            EIxs=1e9; %[N-m^2] 
            EAs=1e-12; %[N] doesn't matter since it follows the vessel
            GJs=1e9; % [N-m^2] 
            Cdx=0; % [-] 
            Cdy=CdOrca(jj); % [-]
            CdD=CdDiam; %[m]
            Ca= [0 0 0]; % [-] 
            Cm= {ofx.OrcinaDefaultReal,ofx.OrcinaDefaultReal,ofx.OrcinaDefaultReal}; % [-]
            Poisson = .5;
        else
            MPUL(jj)= Ptfm.(WEPtype).M(jj)/WEPperim; %[74.00] ; %  careful [kg/m]
            EIxs = [1e12]; % [N-m^2] How should we choose this for the WEP?!? 
            EAs=[700e6]; %[N] How should we choose this for the WEP?!? 
            GJs = [1e12] ; % [N-m^2] How did Sandra choose this?!?
            Cdx=[0]; %[-] 
            Cdy=CdOrca(jj); % [-] Local axes of WEP nodes has y pointing up!
            Ca = [0 round(eX*CaTotal) 0];
            Cm= {ofx.OrcinaDefaultReal,ofx.OrcinaDefaultReal,ofx.OrcinaDefaultReal}; % [-]
            Poisson = .3; % [-] How did Sandra choose this?!?
        end 

        try 
            WEP = Model(linenames{jj});
        catch
            WEP = Model.CreateObject(ofx.otLineType,linenames{jj});
        end
        %% Build the damn thing... 
        setLineType(WEP,WEPD,0,MPUL(jj),[EIxs ofx.OrcinaDefaultReal()],EAs,Poisson,GJs,[Cdx Cdy 0],CdDiam,Ca,Cm)
    end
end
varargout{1}=CdOrca;
varargout{2}=WEParea;
varargout{3} = Cas;
varargout{4} = CaCtr;
varargout{5} = TotalAddedM;
%% Special WEP lines for Flexible Model
if ~iRigid && iBuild
    
    %% WEP lines with extra added-mass
    for jj=1:nUwep
        linenamesE{jj}=['WEP' WEPendstr{jj} '_E'];
        Ca = [0 nX*CaTotal  0];
        Cm= {ofx.OrcinaDefaultReal,ofx.OrcinaDefaultReal,ofx.OrcinaDefaultReal}; % [-]
        %Cm = {nX*CmT ofx.OrcinaDefaultReal() 0};
        try 
            WEPE = Model(linenamesE{jj});
        catch
            WEPE = Model.CreateObject(ofx.otLineType,linenamesE{jj});
        end
        setLineType(WEPE,WEPD,0,MPUL(jj),[EIxs*1 ofx.OrcinaDefaultReal()],EAs,Poisson,GJs,[Cdx Cdy 0],CdDiam,Ca,Cm)
    end
    linenames={linenames{:},linenamesE{:}};
    if iWEB
        linenamesWEB='WEP_WEB';
        %% WEBBING  (Lines connecting WEP to LMB)
        try 
            WEPB = Model(linenames{nUwep+2});
        catch
            WEPB = Model.CreateObject(ofx.otLineType,linenames{nUwep+2});
        end
        WEB_EIx=.01*EIxs;
        setLineType(WEPB,WEPD,0,1e-6,[WEB_EIx ofx.OrcinaDefaultReal()],EAs,Poisson,GJs,[Cdx 0 0],CdDiam,[0 0 0],{0 0 0})
        linenames={linenames{:},linenamesWEB{:}};
    end

end    
end