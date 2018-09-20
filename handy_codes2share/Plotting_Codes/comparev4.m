function comparev4(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Release V4. Let you choose what heading to plot for WAMIT file type 2,3,4 6 and 8.
% 03-03-07, originally written by Dominique Roddier
% Rewritten by Sam Kanner
% Property of Principle Power Inc
% 07-15-16
% and WAMIT file type 6p!
% Updated 05-15-17
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clear some plots
delete(get(0,'Children'));

%set legend props
titl    = 'Legend';
lines = 1;
nSim=1;
iLoop=true;
Plot.iPer=1;
Plot.iContour=0;
Plot.PtfmName=[];
while iLoop
    if nargin>0
        % if filenames are entered manually
        nSim=nargin;
        for jj=1:length(varargin)
            fullfile=varargin{jj};
            dots=strfind(fullfile,'.');
            ixlsx=strfind(fullfile,'xlsx');
            if isempty(dots) || ~isempty(ixlsx)
                % you've entered a platform spreadsheet
                fullfile=which([varargin{jj} '_Ptfm.xlsx']);
                [foo, fnamex, extx] = fileparts(fullfile);
                nSim=nSim-1;
                Plot.iContour=1;
                Plot.iPer=0;
                Plot.PtfmName=varargin{jj};
            end
            slashes=strfind(fullfile,filesep);
            out_name{jj}=fullfile(slashes(end)+1:end);
            [mypath{jj}, filename{jj}, ext{jj}] = fileparts(fullfile);
            mypath{jj}=[mypath{jj} filesep];
        end
        iLoop=false;
    else
        % no filenames entered, ask to get filenames manually
        %outside loop, stopped when no more data files are needed
        % rotate through styles for plots
        if nSim==1
            filetypes={'*.1;*.2;*.3;*.4;*.6;*.6p;*.8;*.9;*.rao;'};
        end
        %get datafile
        [out_name{nSim}, mypath{nSim}] = uigetfile(filetypes,'Input Wamit output file for data');
        [foo, filename{nSim}, ext{nSim}] = fileparts(out_name{nSim});
         %legend stuff
        prompts{nSim}=sprintf('Name of File #%d:',nSim);
        
        Legend(nSim)  = inputdlg(prompts{nSim},titl,lines,{'WAMIT'},'on');
        nstr = questdlg('Plot Another File?','Compare Simulations');
        if strcmp(nstr, 'Yes')
            nSim=nSim+1;
            filetypes={ext{1}};
        else
            iLoop=false;
        end
    end
end

%% Go through each file
headings=0:360;
periods=1:100;
for ss=1:nSim
    if nargin>0
        prompts{ss}=sprintf('Name of File #%d:',ss);
        fooname=out_name{ss};
        fooname=strrep(fooname,'_','-');
        defs{ss}=fooname(1:end-2);
    end
    %read in file
    sfile=[mypath{ss}, out_name{ss}];
    s = find(sfile=='.');
    if strcmp(sfile(s+1:end),'rao')
        suffix=4;
    else
        suffix = int8(str2double(regexp(sfile(s+1:end),'\d*','match')));% int8(str2double(sfile(s+1:end)));
    end
 %% Get the data into a structure
    Data(ss)=getWAMITData(sfile);
    headings=intersect(headings,unique(Data(ss).Heading));
    periods=intersect(periods,unique(Data(ss).Per));
    if isempty(headings)
        error('No common headings between all files')
    end
end
if size(headings,2)>1
    headings=headings'; % turn it into a column vector
end
%% Determine which data to plot
for ss=1:nSim
    %makeWAMITplot(suffix,Data)
    if length(headings)>1
        % if you are in a data file that has headings, ask which headings
        % to plot
        if(ss==1)
            iprint = questdlg('Plot all headings?');
            k = strcmp(iprint,'No');
            if (k==1)
                %allheadings=vertcat(Data(:).Heading);
                %headings=unique(allheadings); %[Xs(1:Data.NoPer:Data.NoHeading*Data.NoPer,2)];
                headstr=num2str(headings);
                [HeadSelec,ok] = listdlg('PromptString','highlight the headings to plot','ListString',headstr); %HeadSelec=iHead
                HeadSelect= headings(HeadSelec);
                
                NoHeadSelec=length(HeadSelec);
%                 for j=0:5
%                     HeadSelect =[HeadSelect HeadSelec+j*Data.NoHeading];
%                 end
            else
                NoHeading=length(headings);
                NoHeadSelec=NoHeading;
                HeadSelect=headings;
            end
        end
    else
        HeadSelect=headings;
        NoHeadSelec=1;
    end
    Data(ss).MaxNoFig=NoHeadSelec*Data(ss).NoFig;
    if suffix==6 && (ss==1)
 
        Plot.periods=periods;
        if ~Plot.iContour
            iprint6 = questdlg('How do you want to format plots?','Format Question','By Wave Period','By Field Points','Both','Both');
            if strcmp(iprint6,'By Field Points');
                Plot.iPer=0;
                Plot.iContour=1;
            elseif strcmp(iprint6,'Both');
                Plot.iContour=1;
            end
        end
        % read .fpt 
        fptSuffix='.fpt';
        if exist([mypath{ss} filename{ss} fptSuffix],'file')
            GpXYZ=readXYZfile([mypath{ss} filename{ss} fptSuffix]);
            Data(ss).XYZ=GpXYZ(:,2:4);
            Data(ss).GpNo=GpXYZ(:,1);
        else
            warning(['Cannot find ' filename{ss} fptSuffix ' file. Cannot make contour plot']);
            Plot.iContour=0;
        end
        if Plot.iContour
            if isempty(Plot.PtfmName)
                PtfmName = inputdlg('Name of WindfloatX','Define Platform Geometry ',1,{'WFA'},'on');
                Plot.PtfmName=PtfmName{1};
            end
            iregprint = questdlg('Do you want to plot an irregular wave field?');
            Plot.ireg = strcmp(iregprint,'Yes');
            if Plot.ireg
                cprompt={'Significant Wave Height [m]','Wave Period [s]','Wave Seed [-]','Wave Gamma [-]'};
                ctitle='Define JONSWAP parameters ';
                cdefault={'2','10','1','3.3'};
                Consts = inputdlg(cprompt,ctitle,1,cdefault,'on');
                Plot.WaveH=str2double(Consts{1});
                Plot.WavePer=str2double(Consts{2});
                Plot.WaveSeed = str2double(Consts{3});    
                Plot.WaveGamma = str2double(Consts{4}); 
            else
                perstr=num2str(periods);
                [PerSelec,ok] = listdlg('PromptString','highlight the period you want to plot','ListString',perstr); %HeadSelec=iHead
                Plot.WavePer= periods(PerSelec);
            end
        end
    end
    Plot.RAOtype=1;
    if ~isempty(strfind(filename{ss},'RNA'))
        Plot.RAOtype=2;
    elseif ~isempty(strfind(filename{ss},'TWR'))
        Plot.RAOtype=3;
    elseif ~isempty(strfind(filename{ss},'KEEL'))
        Plot.RAOtype=4;        
    end
%return to initial while, unless done
end

if nargin>0 && ~Plot.iContour
    Legend = inputdlg(prompts,titl,lines,defs,'on');
else
    Legend = out_name(1);
end
%% Plot!
plotWAMITData(Data,Legend,HeadSelect,suffix,Plot)
end

function plotWAMITData(Data,Legend,HeadSelect,suffix,Plot)
nColors=100;
mycmap=getcmap(nColors,{'dblue','blue','white','red','dred'});
markerstr = {'+','.','o','d','s','^','v','<','>'};
colorstr={[0 0 1], [1 0 1],[1 0 0],[0 1 0],[0 1 1],[.6 .6 0],[0 .6 .6],[.3 0 .3],[.6 0 .6]};
lm=length(markerstr);
xlab='Wave Period [s]';
nSim=length(Data);
dofnames={'Surge','Sway','Heave','Roll','Pitch','Yaw'};
xnames={'x','y','z','x','y','z'};
Fnames={'F','F','F','M','M','M'};
Anames={'A','A','A','\alpha','\alpha','\alpha'};
UFnames={'N/m','N/m','N/m','N-m/m','N-m/m','N-m/m'};
UAnames={'m^2/m-s','m^2/m-s','m^2/m-s','rad^2/m-s','rad^2/m-s','rad^2/m-s'};
for ss=1:nSim
        mn = mod(ss - 1,lm) + 1;
        mp= lm-abs(mod(ss-1,2*(lm-1))-(lm-1)); %sawtooth signal! 1 -> lm -> 1 -> lm
        pstr=[markerstr{mp} '-' ];
        nFig=Data(ss).NoFig;
    for ii= 1:length(HeadSelect)
        if suffix>1
            tstr = sprintf('Wave heading: %d deg',HeadSelect(ii) );
        else
            tstr='';
        end
    
        ih=Data(ss).Heading==HeadSelect(ii);
        for pp=1:nFig %  
            iFig=(ii-1)*nFig+pp;
            switch suffix
                case 1
                    ai=unique([Data(ss).DOFi Data(ss).DOFj],'rows');
                    ip=Data(ss).DOFi==ai(pp,1);
                    ih=Data(ss).DOFj==ai(pp,2);
                    it=ip & ih;
                    lstr='Hydrodynamic coeffs in direction ';
                    label = sprintf('%s %d,%d',lstr,ai(pp,1),ai(pp,2)); %just the DOF  
                    xx=Data(ss).Per(it);
                    if pp==1 && ii==1
                        cprompt={'Seawater density [kg/m^3]:','L, WAMIT length [m]'};
                        ctitle=['Inputs constants for ' Legend{ss}];
                        cdefault={'1025','1'};
                        Consts = inputdlg(cprompt,ctitle,1,cdefault,'on');
                    end
                    Rho=str2double(Consts{1});
                    L_WAMIT=str2double(Consts{2});
                    if ai(pp,1)<=3 && ai(pp,2)<=3
                        Anum=Rho*L_WAMIT^3;
                        Bnum=Rho*L_WAMIT^3*2*pi./xx;
                        ylabs(pp,:)={'Added Mass [kg]', 'Damping [kg/s]'};
                    elseif (ai(pp,1)<=3 && ai(pp,2)>3 ) || (ai(pp,1)>3 && ai(pp,2)<=3) 
                        Anum=Rho*L_WAMIT^4;
                        Bnum=Rho*L_WAMIT^4*2*pi./xx;
                        ylabs(pp,:)={'Added Mass [kg-m]', 'Damping [kg-m/s]'}; 
                    elseif ai(pp,1)>3 && ai(pp,2)>3
                        Anum=Rho*L_WAMIT^5;
                        Bnum=Rho*L_WAMIT^5*2*pi./xx;
                        ylabs(pp,:)={'Added Moment of Inertia [kg^2-m]', 'Damping [kg^2-m/s]'}; 
                    end
                    yy=Data(ss).A(it)*Anum;
                    zz=Data(ss).B(it).*Bnum;
                    
                    lsize=220;
                    figname= [label ',', tstr];
                case {2,3}                    
                    lstr='Exciting force in direction ';
                    label = sprintf('%s %d',lstr,pp); %just the direction
                    ip=Data(ss).DOFi==pp;
                    it=ip & ih;
                    if pp==1 && ii==1
                        cprompt={'Seawater density [kg/m^3]:','g, gravity [m/s^2]','L, WAMIT length [m]'};
                        ctitle=['Inputs constants for ' Legend{ss}];
                        cdefault={'1025','9.80665','1'};
                        Consts = inputdlg(cprompt,ctitle,1,cdefault,'on');
                    end
                    Rho=str2double(Consts{1});
                    g=str2double(Consts{2});
                    L_WAMIT=str2double(Consts{3});                    
                    if pp <=3
                        Xnum=Rho*g*L_WAMIT^3;
                        ylabs(pp,:)={'|Wave-Exciting Force /A_o| [N/m]', 'Phase [deg]'};
                    else
                        Xnum=Rho*g*L_WAMIT^4;
                        ylabs(pp,:)={'|Wave-Exciting Moment /A_o| [N]', 'Phase [deg]'};
                    end
                    yy=Data(ss).ModX(it)*Xnum;
                    xx=Data(ss).Per(it);
                    zz=Data(ss).PhX(it); 
                    lsize=220;
                    figname= [label ',', tstr];
                case 4
                    if Plot.RAOtype==1
                        lstr='RAO in direction';
                        ylabs={'|RAO| [-]', 'RAO Phase [deg]'}; 
                        figname= sprintf('%s RAO, WaveDir %d' ,dofnames{pp},HeadSelect(ii));
                    elseif Plot.RAOtype==2
                        lstr='Direction';
                        ylabs={[Anames{pp} '_' xnames{pp} '[' UAnames{pp} ']'], 'Phase [deg]'}; 
                        if pp<=3
                            ARname=Anames{pp};
                        else
                            ARname=['R' Anames{pp-3}];
                        end
                        figname= sprintf('RNA-Accel_%s%s, WaveDir %d' ,ARname,xnames{pp},HeadSelect(ii));
                    elseif Plot.RAOtype==3
                        lstr='Direction';
                        ylabs={[Fnames{pp} '_' xnames{pp} '[' UFnames{pp} ']'], 'Phase [deg]'}; 
                        figname= sprintf('TWR-BaseMoment_%s%s, WaveDir %d' ,Fnames{pp},xnames{pp},HeadSelect(ii));
                    elseif Plot.RAOtype==4
                        lstr='Column';
                        ylabs={' Head [m/m]', 'Phase [deg]'}; 
                        figname= sprintf('Keel-Head_Col%d, WaveDir %d' ,pp,HeadSelect(ii));
                    end
                        
                    label = sprintf('%s %d',lstr,pp); %just the DOF
                    ip=Data(ss).DOFi==pp;
                    it=ip & ih;
                    yy=Data(ss).ModRAO(it);
                    xx=Data(ss).Per(it);
                    zz=Data(ss).PhRAO(it);
                    
                    lsize=180;
                    
                case 6
                    ixyz=find(Data(ss).GpNo==pp);
                    lstr='GridPoint:';
                    label = sprintf('%s (%2.1f, %2.1f)',lstr,Data(ss).XYZ(ixyz,1),Data(ss).XYZ(ixyz,2)); %just the DOF
                    ip=Data(ss).GPoint==pp;
                    it=ip & ih;
                    yy=Data(ss).ModA(it);
                    xx=Data(ss).Per(it);
                    zz=Data(ss).PhA(it);
                    ylabs={'|Wave Amplitude| [-]', 'Wave Phase [deg]'}; 
                    lsize=180;
                    figname= sprintf('Grid Point %d, WaveDir %d', pp,HeadSelect(ii));
                
                case {8,9}
                    %for each heading combination
                        % for each DOF
                    
                    ai=unique(Data(ss).DOFi);
                    iDOF=mod(pp-1,Data(ss).NoDOFs)+1;
                    nDOF=ai(iDOF);
                        
                    ip=Data(ss).DOFi==nDOF;
                    it=ip & ih;     
                    
                    yy=Data(ss).ModF(it);
                    xx=Data(ss).Per(it);
                    zz=Data(ss).PhF(it);
                     % 1, 2, 6, 1, 2, 6, ...
                    lstr='Force in direction ';
                    if suffix==8
                        lstr2='from momentum';
                    else
                        lstr2='from pressure int';
                    end
                    label = sprintf('%s %d %s ',lstr,nDOF,lstr2); %just the DOF
                    
                    figname= [label ',', tstr];
    
                    if nDOF<=3
                        ylabs={'|Drift Force| [-]', 'Phase [deg]'}; 
                    else
                        ylabs={'|Drift Moment| [-]', 'Phase [deg]'}; 
                    end 
                    lsize=220;                    
                otherwise
                % what am i trying to plot?
            end
            [nlab,foo]=size(ylabs);
            plab=(nlab>1)*(pp-1)+1;
            if Plot.iPer
                h = figure(iFig);
                hname=get(h,'name');
                if isempty(hname)
                    set(h,'name',figname);
                end
            
                subplot(2,1,1)
                plot(xx,yy,pstr,'color',colorstr{mn},'markerfacecolor',colorstr{mn},'markeredgecolor',colorstr{mp})
                %xlabel(xlab);
                ylabel(ylabs{plab,1});
                grid on
                hold on

                uicontrol('Style','text','Position',[10 10 lsize 15],'String',label,'backgroundcolor',[1 1 1],'FontWeight','bold')
                subplot(2,1,2)
                plot(xx,zz,pstr,'color',colorstr{mn},'markerfacecolor',colorstr{mn},'markeredgecolor',colorstr{mp})
                xlabel(xlab);
                ylabel(ylabs{plab,2});
                grid on
                hold on

                if ss==nSim
                    subplot(2,1,1)
                    title(tstr)
                    legend(Legend,0);
                    hold off
                end
            end
        end
        if suffix==6 && Plot.iContour
           %create contour plot 
           xg=Data(ss).XYZ(:,1); yg=Data(ss).XYZ(:,2); zg=Data(ss).XYZ(:,3);
           [xxg,yyg]=meshgrid(xg,yg);
           % 
           if Plot.ireg
               wavestr=sprintf('Irregular Wave, Tp = %1.1f sec,',Plot.WavePer);
                periods=Plot.periods;
           else
               wavestr=sprintf('Regular Wave, %1.1f sec',Plot.WavePer);
               periods=Plot.WavePer;
           end
           WaveAmp=nan(length(xg),length(periods));
           WavePh=nan(length(xg),length(periods));
           NoGp=length(unique(Data(ss).GPoint));
           if NoGp~=length(xg)
               error('Number of grid points in XYZ file does not match gridpoints in .6 file')
           end
           Vq=nan(length(xg),length(yg),length(periods));
           rng(Plot.WaveSeed); % initialize the random number generator, so that it is repeatble between runs
           for itt=1:length(periods)
                ip=Data(ss).Per==periods(itt);
                wi=2*pi/periods(itt);
                if Plot.ireg
                    if itt==length(periods)
                        dw=2*pi/periods(itt-1)- 2*pi/periods(itt)  ; %backwards difference
                    else 
                         dw=2*pi/periods(itt) - 2*pi/periods(itt+1)  ; %forwards difference
                    end
                    try
                        if itt==1
                            [AOrca,wOrca,phOrca,lam]=getWaveData(Plot.WaveH,Plot.WavePer,'JONSWAP',Plot.WaveSeed,Plot.WaveGamma);
                            dwOrca=diff(wOrca);
                        end
                        %find when current period (as defined in .6p, for instance)
                        % is closest to a frequency used by Orca (which is determined via propietary algorithm
                        % (don't want to interpolate because of randomness of phases
                        iwOrca=find( min( abs(wOrca-wi))== abs(wOrca-wi) );
                        if iwOrca==length(wOrca)
                            dw=dwOrca(end);
                        else
                            dw=dwOrca(iwOrca);
                        end
                        Ai=AOrca(iwOrca);
                        ph=phOrca(iwOrca);
                    catch
                        disp('No Orca Dongle detected, using rand for random phases')
                        Wave.Hs=Plot.WaveH; Wave.Tp=Plot.WavePer; Wave.Gam=Plot.WaveGamma;
                        Si=waveLibrary(wi,Wave,'JONSWAP');
                        %Si=JONSWAP(wi,Plot.WaveH,Plot.WavePer,Plot.WaveGamma);
                        Ai=sqrt(2*Si*dw);
                        ph= -360 + 720.*rand(1); % [-360, 360] 
                    end
                else
                    Ai=1;
                    ph=0;
                end
                it=ip & ih; % indices corresponding to a given period and heading
                % go through each point in the XYZ file-> assume there are
                % no repeats                
                for igp=1:NoGp
                    gGP=Data(ss).GpNo(igp); % current grid number
                    ipp=Data(ss).GPoint==gGP; %gridpoint index in .6 file
                    ipgp=ipp & it;
                    %% call OrcaFlex to get spectra?
                    WaveAmp(igp,itt)=Ai*Data(ss).ModA(ipgp); % r+d amplitude is re-normalized by wave amplitude
                    WavePh(igp,itt)=ph+Data(ss).PhA(ipgp); % phase is added to incident wave amplitude phase
                end
                Vq(:,:,itt)=griddata(xg,yg,WaveAmp(:,itt).*sind(WavePh(:,itt)),xxg,yyg);
           end
           figname= sprintf('%s WaveDir= %d',wavestr,HeadSelect(ii));
           if ~isempty(Plot.PtfmName)
               Ptfm=getMyPtfm(Plot.PtfmName);
               [WFpts,WFlabels]=getWFpts({'COL','UMB','LMB','VB','VB'},[1 1 2 1 1],Plot.PtfmName,[2*Ptfm.Col.Lh/3 0 0],1,1);
               hf=gcf;
               view([0 90])
           else
               hf=figure('name',figname);
               grid on
           end
           
           hold on
           axis equal
           %contour(xg,yg,sum(Vq,3));
           c1=sum(WaveAmp.*sind(WavePh),2);
           c1ex=max(abs(c1));
           for gg=1:NoGp
                pc=interp1(transpose(linspace(-c1ex,c1ex,nColors)),mycmap,c1(gg),'linear');
                plot3(xg(gg),yg(gg),0,'o','markerfacecolor',pc,'markeredgecolor','k','markersize',12)
           end
           set(hf,'name', figname)
           xlabel('x-coordinate');
           ylabel('y-coordinate');
           %% make colorbar
           colormap(mycmap)
           hc=colorbar;
           ylabel(hc, 'Wave Amp [m]')
            %colorbar label
            nTick=4;   
            cf=1;
            tc=round( linspace(-c1ex,c1ex,nTick+1)/cf*10)/10;
            for cc=1:1:nTick+1
                tclabel{cc}=num2str(tc(cc));
            end
            hctick=get(hc,'Ytick');
            set(hc,'Ytick',linspace(hctick(1),hctick(end),nTick+1),'yticklabel',tclabel);
           %
           %
        end
    end

end
end

function GpXYZ=readXYZfile(wamitfile)
    fiddat = fopen(wamitfile);
    %read header line and discard it
    dataline = fgetl(fiddat);
    [c,count]=fscanf(fiddat,'%i %f %f %f ',[4 inf]);
     Xs = sortrows(c',[3 2 1]);
     GpXYZ=Xs;
     fclose(fiddat);    
end
