function [CdOrca,CaOrca,WEPidx,MPUL,varargout] = getWEPproperties(Ptfm,PtfmWEP,WEPpts,WEPlabels,varargin)
if nargin<5
    iplot=0;
else
    iplot=varargin{1};
end
CdOrca=zeros(PtfmWEP.nUwep,1);
WEParea=zeros(PtfmWEP.nUwep,1);
WEPperim=zeros(PtfmWEP.nUwep,1);
CaCtr = zeros(PtfmWEP.nUwep,2); % just XY coords
TotalAddedM = zeros(PtfmWEP.nUwep,1);
MPUL=zeros(PtfmWEP.nUwep,1);
%% get column coordinates
ColX=getColX(Ptfm,[0 0 0]);
%% WEPs!
AX=WEPpts(1:2:end-1,:);
BX=WEPpts(2:2:end,:);
nCol=length(Ptfm.Col.D);
nP=length(AX)/nCol;
j1=1;
CaMult=zeros(PtfmWEP.nUwep,nP);
Cas=zeros(nP,PtfmWEP.nUwep);
CaOrca=zeros(PtfmWEP.nUwep,1+length(PtfmWEP.specWEP));
WEPidx=zeros(PtfmWEP.nUwep,nP);
WEPlengths=zeros(PtfmWEP.nUwep,nP);
for jj=1:PtfmWEP.nUwep
    
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
    if iplot
        figure(10)
        plot(WEP1xp,WEP1yp,'k-o',ColX(jj,1),ColX(jj,2),'ro')
        hold on
        axis equal
    end
    WEParea(jj)=polyarea(WEP1xp,WEP1yp);
    %% Want CdDes*WEParea == CdOrca*Perimeter*CdDiam
    WEPlengths(jj,:)=sqrt(  sum( (WEPjA-WEPjB).^2,2 ) );
    WEPperim(jj)=sum(WEPlengths(jj,:));
    CdOrca(jj)=PtfmWEP.CdDes*WEParea(jj)/(WEPperim(jj)*PtfmWEP.CdDiam);
    %L1=sum(sqrt(  sum( (AX(1:10,:)-BX(1:10,:)).^2,2 ) ),1); %all the distances between the nodes
    
end
%% Added-Mass in flexible model
if isfield(PtfmWEP,'AddedM')
    AddedM=PtfmWEP.AddedM/3; % could weight the added mass of each WEP based on area
end
for jj=1:PtfmWEP.nUwep
    %% Weighted Added-Mass in flexible model
%     RefMassTotal = 1025*pi*(PtfmWEP.D/2)^2* WEPperim;
%     PtfmWEP.Ca=AddedMWEP/RefMassTotal;
    WEPjlabel=WEPlabels(2*j1-1:2:2*j1+nP*2-2); % might be easier just to search for col number
    specidx=zeros(nP,1);
    for pp=1:length(PtfmWEP.specWEP)
        specidxP=cellfun(@(s) strcmp(s(5),PtfmWEP.specWEP{pp}),WEPjlabel); % check on the fifth characters
        specidx=specidx+specidxP;        
    end
    WEPidx(jj,:)=specidx*PtfmWEP.nUwep+jj;
    specidxF=find(specidx); % get index numbers of logical vector
    LE=sum(sqrt(  sum( (AX(specidxF,:)-BX(specidxF,:)).^2,2 ) ),1);
    eX=(WEPperim(jj)-PtfmWEP.nX*LE)/(WEPperim(jj)-LE);
    

    %
    %
    % store mult per line 
    for pp=1:nP
        if specidx(pp)>0
            CaMult(jj,pp)=PtfmWEP.nX;
            %Cas(pp,jj)=CaSpec;
        else
            CaMult(jj,pp)=eX;
            %Cas(pp,jj)=CaNorm;
        end     
    end
    
    RefMass = 1025*pi*(PtfmWEP.D/2)^2* sum(CaMult(jj,:).*WEPlengths(jj,:));
    CaPerWEP= AddedM /RefMass;
    Cas(:,jj) = CaPerWEP*CaMult(jj,:)';
    CaNorm = round(eX*CaPerWEP);
    CaSpec = PtfmWEP.nX*CaPerWEP;
    CaOrca(jj,1) = CaNorm; 

    for pp=1:length(PtfmWEP.specWEP)
        CaOrca(jj,pp+1) = CaSpec; 
    end
    % get the center of each line
    WEPxy=[ mean([WEPjA(:,1) WEPjB(:,1)],2) mean([WEPjA(:,2) WEPjB(:,2)],2)];
    CaCtr(jj,:)=sum(repmat(Cas(:,jj),[1 2]).*WEPxy,1) ./ sum(Cas(:,jj)) - ColX(jj,1:2);
    RefM = 1025*pi*(PtfmWEP.D/2)^2* WEPlengths(jj,:)'; %https://www.orcina.com/SoftwareProducts/OrcaFlex/Documentation/Help/Content/html/LineTheory,HydrodynamicandAerodynamicLoads.htm
    TotalAddedM(jj)= sum(Cas(:,jj).* RefM); % just to check
    MPUL(jj)= PtfmWEP.M(jj)/WEPperim(jj);
    %linenames{jj}= ['WEP' WEPendstr{jj}];
    j1=j1+nP;
end
varargout{1}=CaCtr; varargout{2}=WEParea; varargout{3}=TotalAddedM;
end

%     if iWEB
%         linenamesWEB='WEP_WEB';
%         %% WEBBING  (Lines connecting WEP to LMB)
%         try 
%             WEPB = Model(linenames{nUwep+2});
%         catch
%             WEPB = Model.CreateObject(ofx.otLineType,linenames{nUwep+2});
%         end
%         WEB_EIx=.01*EIxs;
%         setLineType(WEPB,WEPD,0,1e-6,[WEB_EIx ofx.OrcinaDefaultReal()],EAs,Poisson,GJs,[Cdx 0 0],CdDiam,[0 0 0],{0 0 0})
%         linenames={linenames{:},linenamesWEB{:}};
%     end