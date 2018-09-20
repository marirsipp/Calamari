function MLfatigue=getMLfatigue(IPTfile)
% FatLifeYrs=25;
% nSeeds=6;
% iRun=1;
% iRedoRain=0;
run(IPTfile);
if ~strcmp(fatdir(end),filesep)
    fatdir=[fatdir filesep];
end
[runInfo,runList]= readRunList(DLCspreadsheet,sheetnum); %load dlc spreadsheet
varnames=fieldnames(runList);
for jj=1:length(varnames)
    for pp=1:length(runList)
        try
            eval([varnames{jj} '(pp)=' 'runList(pp).(varnames{jj})' ';'])
        catch
            eval([varnames{jj} '{pp}=' 'runList(pp).(varnames{jj})' ';'])
        end
    end
end
if exist('Probability','var') && isnumeric(Probability)
    TotalP=sum(Probability); % should be 1....
else
    error('Need to have probability of occurrence of bin in DLC table')
end
if ~exist('specLines','var') 
    specLines.Types={''}; %backward compatibility 
end

nBins=length(Runname);
%bfile1=[fatdir 'Run' Runname{1}  filesep 'MLfatigue_' standard '.mat'];
% just run once to get proper dimensions
% matfile1=[fatdir 'Run' Runname{1}  filesep 'outputs.mat'];  %change to RunPrefix once ipt is made obsolete :(
matfile1=[fatdir basename Runname{1}  filesep 'outputs.mat'];  %CG: changed to basename (defined in IPT)
damageMat=getMLdamage(matfile1,FatLifeYrs,standard,tcutoff,omega,specLines,1); % an array that is nNodes by nML
disp('Initializing variables. Check to make sure your Special LineTypes are recognized. If it is OK, press a button to loop through all bins.')
        pause

[nNodes,nML]=size(damageMat);
Damage25yr=nan(nNodes,nML,nBins);
Damage25yrF=nan(nNodes,nML,nBins);
fname=sprintf('%s_N%d_%s.mat',basename,nBins,standard);
savefile=[fatdir fname];
start_time = now;
tid = tic;
if iRedoRain && iRun
    handle_wait = waitbar(0, 'Initializing...','CreateCancelBtn', 'abort = 1;','CloseRequestFcn',@my_closereq);
    set(handle_wait, 'name', 'Running ML fatiuge...', 'units', 'normalized', 'Position', [.4,.4,.25,.15])
end
if ~exist(savefile,'file') || iRun
    for bb=1:nBins
%         bfile=[fatdir 'Run' Runname{bb}  filesep 'MLfatigue_' standard '.mat'];
        bfile=[fatdir basename Runname{bb}  filesep 'MLfatigue_' standard '.mat']; %CG: changed to basename (defined in IPT)
        if ~exist(bfile,'file') || iRedoRain 
            if iRedoRain && iRun
                if bb==1
                    waitbar((bb-1)/nBins, handle_wait, sprintf('Bin %i of %i... %3.0f%% Complete...', bb, nBins, (bb-1)/nBins*100));
                else
                    hw=waitbar((bb-1)/nBins, handle_wait, sprintf('Run %i of %i... %3.0f%% Complete...\nPrevious run duration: %3.2f seconds. \nEstimated completion time: %s', bb, nBins,(bb-1)/nBins*100,toc(tid)/(bb-1),datestr(start_time + (now-start_time)/(jj-1)*nBins,'mmm dd, HH:MM:SS')),'CreateCancelBtn');
                    if getappdata(hw,'canceling')
                        break
                    end
                end
            end
%             matfile=[fatdir 'Run' Runname{bb}  filesep 'outputs.mat'];  %change to RunPrefix once ipt is made obsolete :(
            matfile=[fatdir  basename  Runname{bb}  filesep 'outputs.mat'];  %CG: changed to basename (defined in IPT)
            if ~exist(matfile,'file')
                warning([matfile ' does not exist. Moving on...'])
                Damage1hr = nan(size(Damage1hr)); % hopefully its not the first one...
                Damage1hrF = nan(size(Damage1hr));
            else
                [Damage1hr,Damage1hrF,ArcLength,LineType]=getMLdamage(matfile,FatLifeYrs,standard,tcutoff,omega,specLines); % an array that is max(nNodes) by nML, will have nans for lines with less nodes
                save(bfile,'Damage1hr','Damage1hrF','ArcLength','LineType');
            end
        else
            disp(['Loading ' 'MLfatigue_' standard '.mat from ' Runname{bb}])
            load(bfile)
        end
        Damage25yr(:,:,bb)=Damage1hr*24*365*FatLifeYrs*Probability(bb)/TotalP;
        Damage25yrF(:,:,bb)=Damage1hrF*24*365*FatLifeYrs*Probability(bb)/TotalP;        
    end
    save(savefile,'Damage25yr','Damage25yrF','ArcLength','LineType');
else
    load(savefile);
end
if iRedoRain && iRun
    delete(handle_wait)
    sprintf('Simulations completed at %s. Elapsed time: %3.2f seconds for %i runs. Average time of %3.2f seconds per run.', datestr(now, 'HH:MM:SS'), toc(tid), nBins, toc(tid)/nBins)
    clear handle_wait 
end
Allfatigue=nansum(Damage25yr,3); % sum over all the bins/runs
AllfatigueF=nansum(Damage25yrF,3);
%% arrays are NODES X ML X BIN
iNplot=[1 2 3];
nD=size(Damage25yr,2);

%% Plot Damage as function of ArcLength for all mooring lines
colorstr={[0 0 1], [1 0 1],[1 0 0],[0 1 0],[0 1 1],[.6 .6 0],[0 .6 .6],[.3 0 .3],[.6 0 .6],[0 0 1]*.8, [1 0 1]*.8,[1 0 0]*.8,[0 1 0]*.8,[0 1 1]*.8,[.6 .6 0]*.8,[0 .6 .6]*.8,[.3 0 .3]*.8,[.6 0 .6]*.8};

figNum=1;
if sum(ismember(iNplot,figNum))
    figure(figNum)
    for mm=1:nML
        iplot=~isnan(AllfatigueF(:,mm));
        plot(ArcLength(iplot,mm),AllfatigueF(iplot,mm),'linestyle','-','color',colorstr{mm},'linewidth',2)
        hold on
        legstr{mm}=sprintf('ML%d',mm);
    end
    grid on
    xlabel('Arc Length (m)')
    ylabel('Damage')
    mAL=max(max(ArcLength));
    line([0 mAL],[0.5 0.5],'color','k','LineWidth',2,'linestyle','--')
    legstr{mm+1} = 'Fatigue FOS';
    axis([0 mAL 0 1])
    legend(legstr{:})
    hold off
end
%% Find out which node/linetype was the major contributer
figNum=2;
if sum(ismember(iNplot,figNum))
    figure(figNum)
    [MLfatigue,iNode]=max(AllfatigueF,[],1);
    plot(1:nML,MLfatigue,'ko','markerfacecolor','k','markersize',12)
    maxML=max(MLfatigue);
    for mm=1:nML
        text(mm+.05,MLfatigue(mm),sprintf('Arc-Length = %2.1f m',ArcLength(iNode(mm),mm)) )
        text(mm+.1,MLfatigue(mm)+maxML*.02,sprintf('Type = %s',LineType{iNode(mm),mm}) )
    end
    grid on
    line([0 nML+1],[0.5 0.5],'color','k','LineWidth',2,'linestyle','--')
    axis([0 nML+1 0 1])
end

%% show bins that contribute the most to the damage
figNum=3;
if sum(ismember(iNplot,figNum))
    [FatSort,binsort]=sort(Damage25yrF,3,'descend');

    nanbins=0;
    for bb=1:nBins
        if sum(isnan(FatSort(1,:,bb)))==nD
            nanbins=nanbins+1;
        end
    end
    nBins2plot=length(colorstr);
    for mm=1:nD
        figure(2+mm)
        iplot=~isnan(Allfatigue(:,mm)); %remove nans
        nNm=nansum(iplot);
        ALm=ArcLength(iplot,mm)';
        FatigueML=squeeze(FatSort(iplot,mm,1+nanbins:end)); % NODES x BIN 
        binML=squeeze(binsort(iplot,mm,1+nanbins:end)); 
        FatigueMLtotal=cumsum(FatigueML,2); % % NODES x BIN 
        h=zeros(length(ALm),nBins2plot - (1+nanbins));
        h(1,1)=plot(ALm,squeeze(FatigueMLtotal(:,end)),'k--','linewidth',3)  ;
        legstr{1}=sprintf('Total ML%d', mm);
        hold on
        for bb=1:nBins2plot%(1+nanbins):nBins2plot
        %FatigueMLb=cumsum(FatigueML(:,bb),2); % all plot nodes, bb'th bin        
            %plot vertical lines representing fatigue contribution
            if bb==1%(1+nanbins)
                h(:,bb)=line([ALm;ALm],[zeros(1,nNm);squeeze(FatigueMLtotal(:,bb))'],'linewidth',3,'color',colorstr{bb});
            else
                h(:,bb)=line([ALm;ALm],[squeeze(FatigueMLtotal(:,bb-1))';squeeze(FatigueMLtotal(:,bb))'],'linewidth',3,'color',colorstr{bb});
            end
            [maxFatML,iNode]=max(FatigueMLtotal(:,end));

            legstr{bb}=sprintf('Bin #%d-Seed %d', floor( (binML(iNode,bb) -1)/nSeeds)+1,rem(binML(iNode,bb)-1,nSeeds)+1);
        end
        legend(h(1,:),legstr);
        grid on
        hold off
        clear legstr
        %axis([0 mAL 0 1])
    end
end
end