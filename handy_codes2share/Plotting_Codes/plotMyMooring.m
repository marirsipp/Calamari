function varargout=plotMyMooring(simdir,figtype,iName,varargin)
% simdir is a directory where many .sim files exist.
%figtype can be 2 numbers, first number is x-axis, second number is
%coloring
% if iName is an integer>0, it will plot a string of the simname with:
% the first 5 letters of the simname followed by the last iName characters of the simname 

% function creates 3 plots, first is max anchor tension, second is std of yaw, third is platform offset,
% each as a function of.... 
% -> total mass (1.0)
%   -> cw mass (1.1)
%   -> static hanging mass (1.2)
%   -> extreme hanging mass (1.3)
%   -> center of mass of the concentrated weight (1.4)

% -> length of line, normalized, Lbar (2.0)
%   -> top angle (2.1)
%   -> touchdown point-static, along arc-length (2.2)
%   -> touchdown point-extreme, along arc-length (2.3)
%   -> 'length' of concentrated mass (2.4)

% -> pretension (3.0)

% -> total buoyancy (4.0)
%   -> number of buoyancy modules (4.1)
%   -> center of buoyancy modules (4.4)
%   -> Length of polyester of ML1 (4.5)
%   -> Center of polyester of ML1 (4.6)

% -> min stiffness (5.0)
Ptfm=getMyPtfm('WFA');
Turbine=getMyTurbine('Vestas_8MW');
linetypesOI={'Chain','Dyneema','Polyester','Wire'}; %find the total lengths 

if nargin==1
    figtype=simdir;
    simdir= uigetdir([],'Select folder where .sims are located');
    iName=0;
elseif nargin<3
    iName=0;
end
if ~strcmp(simdir(end),filesep)
    simdir = [simdir filesep];
end
files=dir([simdir '*.sim']);
ss=0; %successful sim counter
for ff=1:length(files)
    jname=files(ff).name;
    matname=[simdir jname(1:end-4) '.mat'];
    if ~exist(matname,'file') 
        [Res,Units]=extractSIM([simdir jname(1:end-4)],Ptfm,Turbine);  
        if Res.state~=5
            XY=sqrt(Res.motion(:,1).^2+Res.motion(:,2).^2);
            icuttime=Res.time>Res.time(end)*.15;
            timess=Res.time(icuttime);
            Yaw=Res.motion(icuttime,6);
            MLnames=fieldnames(Res.ml1);
            MLnames={MLnames{:},'motionsXY','yaw'};
            nMLn=length(MLnames);
            %Moor_Table=cell(nMLn*Res.nML,3);
            for jj=1:Res.nML
                mls=sprintf('ml%d',jj);
                for qq=1:nMLn
                    qName=MLnames{qq};
                    if strcmp(qName(end),'T')
                        [maxT,maxiTime]=max(Res.(mls).(qName),[],1);% get max tension for each node
                        fData.([mls qName]) = maxT;
                        fData.([mls qName 'time']) = Res.time(maxiTime);
                    elseif strcmp(qName,'motionsXY')
                        fData.motionsXY= max(XY)-XY(1);
                    elseif strcmp(qName,'yaw')    
                        fData.stdYaw=std(Yaw);
                    elseif strcmp(qName,'EA')
                        fData.([mls 'minEA'])=min(Res.(mls).EA);
                    else                        
                         fData.([mls qName]) = Res.(mls).(qName);
                    end
                    for ll=1:length(linetypesOI)
                        iML= logical(~cellfun('isempty',strfind(Res.(mls).LineType,linetypesOI{ll})));
                        %find the total length of a linetype
                        fData.([mls linetypesOI{ll} 'L']) = sum(Res.(mls).SegL(iML));
                        % center of line 
                        fData.([mls linetypesOI{ll} 'ArcL']) = sum( Res.(mls).SegArcL(iML).*Res.(mls).SegL(iML) )/sum(Res.(mls).SegL(iML));
                    end
                end
        %         for pp=1:nMLn
        %             %name, data, unit
        %             Moor_Table(pp+nMLn*(jj-1),:)={[mls MLnames{pp}], Res.(mls).(MLnames{pp}),Units.(mls).(MLnames{pp})}; % would this work for cell arrays of strings?
        %         end
            end 
            fData.Name=jname(1:end-4);
        else
            fData=[];
        end
        save(matname,'fData')
    else
        load(matname);
    end
    if ~isempty(fData)
        ss=ss+1;
        OutS(ss)=fData;
    end
end
varargout{1}=OutS;
makeMLplots(OutS,figtype,iName) 
end

function makeMLplots(OutS,figtype,iName)
figtypec=nan;
if length(figtype)>1
    figtypec=figtype(2);
    figtype=figtype(1);
end
%try to find some meaning in the ML sweeps
nSim=length(OutS);
prestr='ml1'; % name of worst mooring line
len = arrayfun(@(s) size(s.([prestr 'EffT']),2), OutS);
nNodes=max(len);

%% important data
XY=nan(nSim,1);
AllTen=nan(nSim,nNodes);
AnTen=nan(nSim,1);
FlTen=nan(nSim,1);
PreT=nan(nSim,1);
stdYaw=nan(nSim,1);
Theta1=nan(nSim,1);
barL=nan(nSim,1);
Lt=nan(nSim,1);
Bt=nan(nSim,1);
nB=nan(nSim,1);
cwL=nan(nSim,1);
Lk=nan(nSim,1);
LkMax=nan(nSim,1);
cwLstar=nan(nSim,1);
bLstar=nan(nSim,1);
Mt=nan(nSim,1);
EA=nan(nSim,1);
chainL=nan(nSim,1);
chainArcL=nan(nSim,1);
polyL=nan(nSim,1);
polyArcL=nan(nSim,1);
dyL = nan(nSim,1);
dyArcL = nan(nSim,1);
NameStr=cell(nSim,1);
for ss=1:nSim
    if ~isempty(OutS(ss).([prestr 'barL']))
        XY(ss,1)=OutS(ss).('motionsXY'); % max offset
        stdYaw(ss,1)=OutS(ss).('stdYaw'); % max offset
        barL(ss,1)=OutS(ss).([prestr 'barL']); % measure of catenary shape
        Theta1(ss,1)=mod(OutS(ss).([prestr 'Theta1']),89.99999); % Top angle (0 = horizontal, 90= vertical down)
        Lt(ss,1)=OutS.([prestr 'Lt']);
        Lk(ss,1)=Lt(ss,1)*OutS(ss).([prestr 'Lk']);
        LkMax(ss,1)=Lt(ss,1)*OutS(ss).([prestr 'LkMax']);
        cwLstar(ss,1)=(Lt(ss,1)-Lk(ss,1))*OutS(ss).([prestr 'cwLstar'])+Lk(ss,1); % [m] arc-length position of center of clumpweights
        bLstar(ss,1)=(Lt(ss,1)-Lk(ss,1))*OutS(ss).([prestr 'bLstar'])+Lk(ss,1); % [m] arc-length position of center of buoyancy modules
        EA(ss,1)=OutS(ss).([prestr 'minEA']); %[tef?] min EA -> like a rope
        Mt(ss,1)=OutS(ss).([prestr 'Mt']); %[kg?] total mass
        nB(ss,1)=OutS(ss).([prestr 'nB']); %[-] number of buoyancy modules
        Bt(ss,1)=OutS(ss).([prestr 'Bt']); %[N] total buoyancy force
        cwMt(ss,1)=OutS(ss).([prestr 'cwMt']); %[kg?] total clumpweight mass
        cwL(ss,1)=OutS(ss).([prestr 'cwL']); 
        MfKg(ss,1)=Mt(ss,1)*OutS(ss).([prestr 'Mf']); %[kg?] total hanging mass-static
        MfMaxKg(ss,1)=Mt(ss,1)*OutS(ss).([prestr 'MfMax']); %[kg?] total hanging mass - extreme event
        sNodes=size(OutS(ss).([prestr 'EffT']),2);
        PreT(ss,1)=OutS(ss).([prestr 'PreT']);
        EffT=OutS(ss).([prestr 'EffT']);
        AllTen(ss,1:sNodes)=EffT;
        FlTen(ss,1) = EffT(1);
        AnTen(ss,1) = EffT(end);
        
        chainL(ss,1)=OutS(ss).([prestr 'ChainL']);
        chainArcL(ss,1)=OutS(ss).([prestr 'ChainArcL']);
        polyL(ss,1)=OutS(ss).([prestr 'PolyesterL']);
        polyArcL(ss,1)=OutS(ss).([prestr 'PolyesterArcL']);
        dyL(ss,1)=OutS(ss).([prestr 'DyneemaL']);
        dyArcL(ss,1)=OutS(ss).([prestr 'DyneemaArcL']);        
        myName=OutS(ss).Name;
        %ius=strfind(fullName,'_');
        if length(myName)>10
            myName=[myName(1:5) myName(end-iName:end)];
        end
        NameStr{ss,1}=myName;
    end
end

nColors=100;
mycmap=getcmap(nColors,{'dgreen','green','yellow','orange','red','dred'});
ygoal=315;

h1=figure(1); clf; hold on
h2=figure(2); clf; hold on
h3=figure(3); clf; hold on
% h4=figure(4); clf; hold on
% h5=figure(5); clf; hold on
% h6=figure(6); clf; hold on
y1=AnTen;
y1str= 'Anchor Tension (tef)';
y2=stdYaw;
y2str= 'StDev Yaw (deg)';
y3=XY;
y3str= 'Platform Horizontal Offset (m)';
x1f=1;
switch figtype
    case 1
        x1=Mt/1e3;
        xstr= 'Total Mass (t)';
    case 1.1
        x1=cwMt/1e3;
        xstr= ' Total concentrated mass (t)';
    case 1.2
        x1=MfKg/1e3;
        xstr= ' Total hanging mass - static position (t)';
    case 1.3
        x1=MfMaxKg/1e3;
        xstr= ' Total hanging mass - extreme position (t)';
    case 1.4
        x1=cwLstar;
        xstr='Location of concentrated weight, arc-length distance from FL (m)';% ('fairlead (0) $\rightarrow \bar{L}^* \rightarrow$ anchor (1)';
    case 2
        x1 = barL;
        xstr='$\bar{L} \rightarrow$ catenary (-)';
    case 2.1
        x1=Theta1;
        xstr='Top Angle (from horizontal, deg)';
    case 2.2
        x1=Lk;
        xstr = 'Static Touchdown point (m arc-length)';
    case 2.3
        x1=LkMax;
        xstr='Static Touchdown point (m arc-length)';
    case 2.4
        x1=cwL;
        xstr='Length of concentrated mass (m)';
    case 3
        x1=PreT;
        xstr='Pre-tension (tef)';
    case 4
        x1= Bt/(1e3*9.8);
        xstr = 'Total Buoyancy (tef)';
    case 4.1
        x1 = nB;
        xstr = 'Number of Buoyancy Modules (-)';
    case 4.4
        x1=bLstar;
        xstr='Center of Buoyancy, arc-length distance from FL (m)';% ('fairlead (0) $\rightarrow \bar{L}^* \rightarrow$ anchor (1)';
    case 4.5
        x1=polyL;
        xstr='Total Length of Polyester (m)';
    case 4.6
        x1=polyArcL;
        xstr='Center of Polyester along arc-length (m)';
    case 5.0
        x1=EA;
        xstr = 'Rope axial stiffness (tef)';
end
cf=1;
switch figtypec
    case 1
        c1=Mt;
        cf=1e3;
        cstr= 'Total Mass (t)';
    case 1.1
        c1=cwMt;
        cf=1e3;
        cstr= ' Total concentrated mass (t)';
    case 1.2
        c1=MfKg;
        cf=1e3;
        cstr= ' Total hanging mass - static position (t)';
    case 1.3
        c1=MfMaxKg;
        cf=1e3;
        cstr= ' Total hanging mass - extreme position (t)';        
    case 1.4
        c1=cwLstar;
        cstr='Location of concentrated weight, arc-length distance from FL (m)';% ('fairlead (0) $\rightarrow \bar{L}^* \rightarrow$ anchor (1)';
    case 2
        cstr='$\bar{L} \rightarrow$ catenary';
        c1 = barL;
    case 2.1
        cstr='Top Angle (from horizontal, deg)';
        c1=Theta1;
    case 2.2
        c1=Lk;
        cstr = 'Static Touchdown point (m arc-length)';
    case 2.3
        c1=LkMax;
        cstr='Static Touchdown point (m arc-length)';
     case 2.4
        c1=cwL;
        cstr='Length of concentrated mass (m)';    
    case 3
        c1=PreT;
        cstr='Pre-tension (tef)';
    case 4
        c1= Bt/(1e3*9.8);
        cstr = 'Total Buoyancy (tef)';
    case 4.1
        c1 = nB;
        cstr = 'Number of Buoyancy Modules (-)';
    case 4.4
        c1=bLstar;
        cstr='Center of Buoyancy, arc-length distance from FL (m)';% ('fairlead (0) $\rightarrow \bar{L}^* \rightarrow$ anchor (1)';
    case 4.5
        c1=polyL;
        cstr='Total Length of Polyester (m)';
    case 4.6
        c1=polyArcL;
        cstr='Center of Polyester along arc-length (m)';
    case 5.0
        c1=EA;
        cstr = 'Rope axial stiffness (tef)';
end
for ii=1:nSim
    if ~isnan(barL(ii))
        
%         pMaxf=interp1(transpose(linspace(min(MfMaxKg),max(MfMaxKg),nColors)),mycmap,MfMaxKg(ii),'linear');
%         pMf=interp1(transpose(linspace(min(MfKg),max(MfKg),nColors)),mycmap,MfKg(ii),'linear');
%         pTh=interp1(transpose(linspace(min(Theta1),max(Theta1),nColors)),mycmap,Theta1(ii),'linear');
%         pAnt=interp1(transpose(linspace(min(AnTen),max(AnTen),nColors)),mycmap,AnTen(ii),'linear');
        if ~isnan(figtypec) 
            pc=interp1(transpose(linspace(min(c1),max(c1),nColors)),mycmap,c1(ii),'linear');
            figure(h1)
            p1=plot(x1(ii),y1(ii),'o','markerfacecolor',pc,'markeredgecolor','k','markersize',8);
            colormap(mycmap)
            hc=colorbar;
            if iName
                text(x1(ii)*1.01,y1(ii),NameStr{ii,1},'fontsize',8)
            end
            figure(h2)
            p2=plot(x1(ii),y2(ii),'o','markerfacecolor',pc,'markeredgecolor','k','markersize',8);
            colormap(mycmap)
            hc2=colorbar;
            if iName
                text(x1(ii)*1.01,y2(ii),NameStr{ii,1},'fontsize',8)
            end
            figure(h3)
            p3=plot(x1(ii),y3(ii),'o','markerfacecolor',pc,'markeredgecolor','k','markersize',8);
            colormap(mycmap)
            hc3=colorbar;   
            if iName
                text(x1(ii)*1.01,y3(ii),NameStr{ii,1},'fontsize',8)
            end
%             case 4
%                 figure(h4)
%                 p4=plot(PreT(ii),XY(ii),'o','markerfacecolor',pTh,'markeredgecolor','k','markersize',8);
%                 colormap(mycmap)
%                 hc4=colorbar;
%             case 5
%                 figure(h5)
%                 p4=plot(Theta1(ii),XY(ii),'o','markerfacecolor',pAnt,'markeredgecolor','k','markersize',8);
%                 colormap(mycmap)
%                 hc5=colorbar;        
%             case 6
%                 figure(h6)
%                 
        end
    end
end
if ~isnan(figtypec)
    nTick=4;
    %colorbar label
    tc=round( linspace(min(c1),max(c1),nTick+1)/cf*10)/10;
    for cc=1:1:nTick+1
        tclabel{cc}=num2str(tc(cc));
    end
end
% %total mass label
% tmass=round( linspace(min(Mt),max(Mt),nTick+1)/1e3);
% for cc=1:1:nTick+1
%     masslabel{cc}=num2str(tmass(cc));
% end
% %total mass label
% tmaxf=round( linspace(min(MfMaxKg),max(MfMaxKg),nTick+1)/1e3);
% for cc=1:1:nTick+1
%     mfmaxlabel{cc}=num2str(tmaxf(cc));
% end
% % hanging mass label
% tmf=round( linspace(min(MfKg),max(MfKg),nTick+1)/1e3);
% for cc=1:nTick+1
%     mflabel{cc}=num2str(tmf(cc));
% end
% % top-angle label
% antf=round( linspace(min(AnTen),max(AnTen),nTick+1));
% for cc=1:nTick+1
%     antlabel{cc}=num2str(antf(cc));
% end
% % top-angle label
% thf=round( linspace(min(Theta1),max(Theta1),nTick+1));
% for cc=1:nTick+1
%     thlabel{cc}=num2str(thf(cc));
% end
%% Anchor tension
figure(h1)
if isnan(figtypec)
    [x1,ix]=sort(x1,'ascend');
    p1=plot(x1,y1(ix),'k-o','markerfacecolor','k');
end
xlabel(xstr,'fontsize',12,'interpreter','latex')
ylabel(y1str)
xl=xlim;
line([xl(1) xl(2)],[ygoal ygoal],'linestyle','--')
if ~isnan(figtypec)
    ylabel(hc,cstr,'interpreter','latex')
    set(hc,'Ytick',linspace(1,nColors,nTick+1),'yticklabel',tclabel)
end
hold off
grid on

%% Std Dev of Yaw
figure(h2)
if isnan(figtypec)
    p2=plot(x1,y2(ix),'k-o','markerfacecolor','k');
end
xlabel(xstr,'fontsize',12,'interpreter','latex')
ylabel(y2str)

xl=xlim;
yl=ylim;
line([xl(1) xl(2)],[3 3],'linestyle','--')
if ~isnan(figtypec)
    ylabel(hc2,cstr,'interpreter','latex')
    set(hc2,'Ytick',linspace(1,nColors,nTick+1),'yticklabel',tclabel)
end
% text(nanmean(Lk), yl(2)*.8,'static touchdown point')
% text(nanmean(LkMax), yl(2)*.8,'extreme touchdown point')
% line([ nanmean(Lk) nanmean(Lk)],[yl(1) yl(2)],'linestyle',':','color','b')
% line([nanmean(LkMax) nanmean(LkMax)],[yl(1) yl(2)],'linestyle',':','color','r')
hold off
grid on

%% Platform Offset
figure(h3)
if isnan(figtypec)
    p3=plot(x1,y3(ix),'k-o','markerfacecolor','k');
end
xlabel(xstr,'fontsize',12,'interpreter','latex')
ylabel(y3str)

xl=xlim;
line([xl(1) xl(2)],[20 20],'linestyle','--')
if ~isnan(figtypec)
    ylabel(hc3,cstr,'interpreter','latex')
    set(hc3,'Ytick',linspace(1,nColors,nTick+1),'yticklabel',tclabel)
end
hold off
grid on

% %% Pretension & platform offset
% figure(h4)
% xlabel('Pre-tension (tef)','fontsize',12,'interpreter','latex')
% ylabel('Platform Horizontal Offset (m)')
% ylabel(hc4,'Top Angle (deg)')
% xl=xlim;
% line([xl(1) xl(2)],[13 13],'linestyle','--')
% set(hc4,'Ytick',linspace(1,nColors,nTick+1),'yticklabel',thlabel)
% hold off
% grid on
% 
% %
% figure(5)
% xlabel('Top Angle (deg)','fontsize',12,'interpreter','latex')
% ylabel('Platform Horizontal Offset (m)')
% set(hc5,'Ytick',linspace(1,nColors,nTick+1),'yticklabel',antlabel)
% ylabel(hc5,'Max Anchor Tenson (eft)')
% grid on
% 
% %
% figure(6)
% plot(XY,AnTen, 'ko')
% xl=xlim;
% yl=ylim;
% line([xl(1) xl(2)],[300 300],'linestyle','--')
% line([13 13],[yl(1) yl(2)],'linestyle','--')
% 
% xlabel('Platform Horizontal Offset (m)')
% ylabel('Anchor Tension, ML1 (tef)')
% grid on
end