function TwrBDEL=getTwrBDEL4RunOF(IPTfile)
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
    Hs = Wave_Hs;
    Tp = Wave_Tp;
    Vspd = Wind_Speed;
    Vdir = Wind_Dir;
    Wdir = Wave_Dir;
else
    error('Need to have probability of occurrence of bin in DLC table')
end
nBins=length(Runname);
% if isempty(RotAngle)
%     RotAngle=0;
% end
nT=size(Tfilt,2)+1;
nRot=length(RotAngle);

fname=sprintf('%s_N%d.mat',basename,nBins);

%% Calculate DEL for all 6 DOFs + combined S-S/F-A + Rot Angles
savefile=[fatdir fname];
nFree = 6; % number of DOFs for basebend
nDOF=nFree + max([nRot 1]); %6 DOFs + combined S-S/F-A
Damage=nan(nDOF,nT,nBins); % see setupCalDEL
if ~exist(savefile,'file') || iRun
    for bb=1:nBins
        bfile=[fatdir 'Run' Runname{bb}  filesep basename '_' num2str(bb) '.mat'];
        if ~exist(bfile,'file') || iRedoRain
            matfile=[fatdir 'Run' Runname{bb}  filesep 'outputs.mat'];  %change to RunPrefix once ipt is made obsolete :(
            if ~exist(matfile,'file')
                warning([matfile ' does not exist. Moving on...'])
                Dmg = nan(size(Dmg)); % hopefully its not the first one...
                Meq = nan(size(Meq)); 
            else
                disp(['Found ' matfile '. Loading..'])
                %% LOAD outputs.mat
                Res=load(matfile);
                tstep=mean(diff(Res.time));
                if isfield(Res,'basebend')
                    M=Res.basebend; %time series (ntime x dof)
                elseif isfield(Res,'TwrBsMtRNA')
                    M=TwrBsMtRNA;
                else
                    error('Cannot find basebend or TwrBsMtRNA, must be trying use an old outputs.mat')
                end
                %ntime=size(M,1);
                %% ROTATE BASEBEND into WF frame
                %M(:,1:3) = Rotate2DMat(M(:,1:3), -(360-Wind_Dir(bb))*pi/180);
                %M(:,4:6) = Rotate2DMat(M(:,4:6), -(360-Wind_Dir(bb))*pi/180);
                if iVestas
                    M(:,1:3) = Rotate2DMat(M(:,1:3),-pi/2);
                    M(:,4:6) = Rotate2DMat(M(:,4:6),-pi/2);
                end                
                MNcurve.m = m; MNcurve.N0 = N0; MNcurve.Mu = Mu;
                [Meq,Dmg]=setupCalDEL(M,Tfilt,RotAngle,tstep,MNcurve,FatLifeYrs,Res.CutInTime,n_order);
                
                vars2save={'Meq','Dmg'};
                save(bfile,vars2save{:});
                
            end
        else
            load(bfile)
        end
        Damage(:,:,bb)=Dmg.*Probability(bb)/TotalP; % 
    end
    MomentEq =(nansum(Damage,3) * FatLifeYrs * Mu^m / N0) .^ (1/m); % Using user-defined M-N curve, calculate equivalent moment based on total damage 
    save(savefile,'MomentEq','Damage','Tfilt','RotAngle');
else
    [spath,sname,sext]=fileparts(savefile);
    load(savefile);
    disp(['Found ' sname '. Using data since iRun=0.'])
end
TwrBDEL = Damage;
if iPlot
    plotTwrBfatigue(savefile,nSeeds)
end
if iPolarPlot
    Mstrs={'Mx','My'};
    Ms=[4 5];
    for pp=1:length(Mstrs)
        DmgPerBin=squeeze(Damage(Ms(pp),1,:)); % just grab non-filtered
        iNaNs=~isnan(DmgPerBin);
        figure('name',[ Mstrs{pp} ' DEL vs Vdir, Vspd of' ' bins'],'units','normalized','outerposition',[.1 .1 .8 .9])

        dataMat = [mod(180-Vdir(iNaNs)',360)  Vspd(iNaNs)' Hs(iNaNs)' DmgPerBin(iNaNs)]; % go from Orca convention back to Met convention
        %sort by damage;
        [foo,iSort]=sort(dataMat(:,4),'ascend');
        nout=0;
        dataMat=dataMat(iSort(1:end-nout),:);
        HsStrs=arrayfun(@num2str11f, dataMat(:,3), 'unif', 0);
    %        p1=polar3Plot([rankMat(:,Mxy+3)*pi/180+.5*(rankMat(:,Mxy+1)-max(rankMat(:,Mxy+1))*.5)/max(rankMat(:,Mxy+1)) rankMat(:,Mxy+2) rankMat(:,Mxy+4)],HsStrs,iName,Head);
        p1=polar3Plot([dataMat(:,1)*pi/180+.5*(dataMat(:,3)-max(dataMat(:,3))*.5)/max(dataMat(:,3)) dataMat(:,2) dataMat(:,4)],'Wind','Uspd',HsStrs,1,Heading);
    end
end
end
function str=num2str11f(num)
str=sprintf('%1.1f',num);
end
function plotTwrBfatigue(savefile,nSeeds)
load(savefile); %Damage, MomentEq, Tfilt, RotAngle
[nDOF,nTf,nBins]=size(Damage);
Xstrs={'X','Y','Z'};
nTf=nTf-1;
%% arrays are DOF X nIter x BIN
Allfatigue=nansum(Damage,3); % sum over all the bins/runs, results in nDOF X nTf
%%
nD=size(Damage,2);
colorstr={[0 0 1], [1 0 1],[1 0 0],[0 1 0],[0 1 1],[.6 .6 0],[0 .6 .6],[.3 0 .3],[.6 0 .6],[0 0 1]*.8, [1 0 1]*.8,[1 0 0]*.8,[0 1 0]*.8,[0 1 1]*.8,[.6 .6 0]*.8,[0 .6 .6]*.8,[.3 0 .3]*.8,[.6 0 .6]*.8};
nBins2plot=length(colorstr);
nanbins=0;
nFigs=size(Damage,1);
%find bins that have died
for bb=1:nBins
    if sum(isnan(Damage(1,:,bb)))==nD
        nanbins=nanbins+1;
    end
end
disp(sprintf('You have %d bins that were either not run or died during running',nanbins))
%% Plot by Tfilt
if nTf>0   %Tfilt
    nFigs=6;
    nIter=length(Tfilt);
    Dmg2Plt=Damage(1:nFigs,2:end,:); % for no-rot: 1:6 x nTfilft x nBins
    Fat2Plt=Allfatigue(1:nFigs,2:end); % 6 x nTf
    [DmgSort,binsort]=sort(Dmg2Plt,3,'descend'); 
    for mm=1:nFigs % for each DOF     
        if mm<=6
            figname = sprintf('TowerBase Fatigue-DOF%d',mm);
            %Fig{mm}=figure('name',figname);
        else
            figname = sprintf('TowerBase Fatigue-RXY');
            %Fig{mm}=figure('name',figname);
        end
        iplot=~isnan(Fat2Plt(mm,:)); %remove nans %1  x nTf. why would there be nans in the Tfilt?
        nNm=nansum(iplot);
        FatigueML=squeeze(DmgSort(mm,iplot,1+nanbins:end)); % nIter x nBIN
        if nTf==1
            FatigueMLtotal=cumsum(FatigueML)';
            binML=squeeze(binsort(mm,iplot,1+nanbins:end))'; 
        else
            FatigueMLtotal=cumsum(FatigueML,2); % nIter (sum over the bins)
            binML=squeeze(binsort(mm,iplot,1+nanbins:end)); 
        end
        
        for nn=1:nTf
            xtickstr{nn}=sprintf('T_{low}=%d, T_{high}=%d',Tfilt(1,nn),Tfilt(2,nn));
        end
        if mm<4
            ystr =[ 'Damage Equivalent Load in ' Xstrs{mm} ' [N]'];
        else
            ystr =[ 'Damage Equivalent Moment about ' Xstrs{mm-3} ' [N-m]'];
        end
         Fig = plotTopNBins(figname,nBins2plot,nanbins,FatigueMLtotal,binML,xtickstr,ystr,colorstr,nSeeds);
%         h=zeros(nNm,nBins2plot - (1+nanbins));
%         h(1,1)=plot(1:nD,squeeze(FatigueMLtotal(:,end)),'k--','linewidth',3);
%          
%         hold on
%         for bb=1:nBins2plot%(1+nanbins):nBins2plot
%             %plot vertical lines representing fatigue contribution
%             if bb==1%(1+nanbins)
%                 h(:,bb)=line([1:nIter;1:nIter],[zeros(1,nNm);squeeze(FatigueMLtotal(:,bb))'],'linewidth',6,'color',colorstr{bb});
%             else
%                 h(:,bb)=line([1:nIter;1:nIter],[squeeze(FatigueMLtotal(:,bb-1))';squeeze(FatigueMLtotal(:,bb))'],'linewidth',6,'color',colorstr{bb});
%             end
%             [maxFatML,iNode]=max(FatigueMLtotal(:,end));
% 
%             legstr{bb}=sprintf('Bin #%d-Seed %d', floor( (binML(iNode,bb) -1)/nSeeds)+1,rem(binML(iNode,bb)-1,nSeeds)+1);
%         end
%         legend(h(1,:),legstr);
%         grid on
%         hold off
%         clear legstr
%         xlim([.5 nIter+.5])
%         set(gca,'xtick',1:nIter,'xticklabel',xtickstr)
     end
end
%% Plot by RotAngle
if nDOF>7   
    nRot = nDOF-7;
    Dmg2Plt=Damage(8:end,1,:);
    Fat2Plt=Allfatigue(8:end,1);
    [DmgSort,binsort]=sort(Dmg2Plt,3,'descend');
    
    nIter=length(RotAngle); % comes from saved variable
    figname = sprintf('TowerBase Fatigue-Rot');
    iplot=~isnan(Fat2Plt(1,:)); %remove nans % x nIter
    %nD=size(Dmg2Plt,2);
    nNm=nansum(iplot);
    xstrd=RotAngle; xstr='RotAngle'; 
    
    FatigueML=squeeze(DmgSort(:,iplot,1+nanbins:end)); % nIter x BIN 
    FatigueMLtotal=cumsum(FatigueML,2); % nIter (sum over the bins)
    binML=squeeze(binsort(:,iplot,1+nanbins:end)); 
    for nn=1:nRot
        xtickstr{nn}=sprintf('%s=%d',xstr,xstrd(nn));
    end
    ystr = 'Combined Damage Equivalent Moment [N-m]';
     Fig = plotTopNBins(figname,nBins2plot,nanbins,FatigueMLtotal,binML,xtickstr,ystr,colorstr,nSeeds);
%     h=zeros(nNm,nBins2plot - (1+nanbins));
%     h(1,1)=plot(1:nD,squeeze(FatigueMLtotal(:,end)),'k--','linewidth',3);
% 
%     hold on
%     for bb=1:nBins2plot%(1+nanbins):nBins2plot
%         %plot vertical lines representing fatigue contribution
%         if bb==1%(1+nanbins)
%             h(:,bb)=line([1:nD;1:nD],[zeros(1,nNm);squeeze(FatigueMLtotal(:,bb))'],'linewidth',6,'color',colorstr{bb});
%         else
%             h(:,bb)=line([1:nD;1:nD],[squeeze(FatigueMLtotal(:,bb-1))';squeeze(FatigueMLtotal(:,bb))'],'linewidth',6,'color',colorstr{bb});
%         end
%         [maxFatML,iNode]=max(FatigueMLtotal(:,end));
% 
%         legstr{bb}=sprintf('Bin #%d-Seed %d', floor( (binML(iNode,bb) -1)/nSeeds)+1,rem(binML(iNode,bb)-1,nSeeds)+1);
%     end
%     legend(h(1,:),legstr);
%     grid on
%     hold off
%     clear legstr
%     xlim([.5 nIter+.5])
%     set(gca,'xtick',1:nIter,'xticklabel',xtickstr)
end
%% just Plot DOFs 1:3 and 4:6
Dmg2Plt=Damage(1:6,1,:);
Fat2Plt=Allfatigue(1:6,1);
[DmgSort,binsort]=sort(Dmg2Plt,3,'descend');
for mm=1:2
     if mm==1
         iDOF=1:3;
         ystr = 'Damage Equivalent Load [N]';
     elseif mm==2
         iDOF=4:6;
         ystr = 'Damage Equivalent Moment [N-m]';
     end
    figname = sprintf('TowerBase Fatigue-DOF%d-%d',iDOF(1),iDOF(end));
    nIter=length(iDOF);
    nD=3;
    nNm=3;
    xstrd=iDOF; xstr='DOF';
    for nn=1:nD
        xtickstr{nn}=sprintf('%s=%d',xstr,xstrd(nn));
    end  

    
    FatigueML=squeeze(DmgSort(iDOF,iplot,1+nanbins:end)); % nIter x BIN 
    FatigueMLtotal=cumsum(FatigueML,2); % nIter (sum over the bins)
    binML=squeeze(binsort(iDOF,iplot,1+nanbins:end)); 
    Fig = plotTopNBins(figname,nBins2plot,nanbins,FatigueMLtotal,binML,xtickstr,ystr,colorstr,nSeeds);       
end
       %end


% %% What kind of run you want to do
% if nT>1
%     disp('Setting up a Tower Base Fatigue analysis based on freq filter')
%     iIter=1;
%     nIter=nT;
%     iterStr='Tfilt';
% elseif nRot>1 || RotAngle>0
%     disp('Setting up a Tower Base Fatigue analysis based on angle')
%     iIter=2;
%     nIter=nRot; % add a normal run
%     iterStr='Rot';
% else
%     disp('Setting up a Tower Base Fatigue analysis')
%     iIter=0;
%     nIter=1;
%     iterStr='';
% end
% Tfilt0=Tfilt;
% n_order0=n_order;

%                 %% Loop based on filter or based on RotAngle               
%                 M=[M nan(ntime,1)];  % make room for extra entry
%                 
% 
%                 Dmg=nan(nDOF,1); DmgF=nan(nDOF,nIter);
%                 Meq=nan(nDOF,1); MeqF=nan(nDOF,nIter);
%                 if nT==1
%                     Tfilt=repmat(Tfilt0,[1 nIter]);
%                     n_order=repmat(n_order0,[1 nIter]);
%                 end
%                 for ii=1:nIter
%                     if iIter==1
%                         %% Filtering...
%                         Wn=tstep/(Tfilt(1,ii)/2);
%                         Wn2=tstep/(Tfilt(2,ii)/2);
%                         if Tfilt(1,ii)==0 && isinf(Tfilt(2,ii))
%                             Mfilt=M;
%                         elseif Tfilt(1,ii)==0 && ~isinf(Tfilt(2,ii)) 
%                             [b2,a2] = butter(n_order(ii),Wn2,'high');
%                             Mfilt=filtfilt(b2,a2,M);
%                         elseif isinf(Tfilt(2,ii))  && Tfilt(1,ii)~=0
%                             [b,a] = butter(n_order(ii),Wn); 
%                             Mfilt = filtfilt(b,a,M); 
%                         elseif ~isinf(Tfilt(2,ii)) && Tfilt(1,ii)~=0
%                             [b2,a2] = butter(n_order(ii),Wn2,'high');
%                             [b,a] = butter(n_order(ii),Wn); 
%                             Mfilt = filtfilt(b,a,M); 
%                             Mfilt= filtfilt(b2,a2,Mfilt);
%                         end
%                     %% Rotation...
%                     elseif iIter==2
%                         %you are using rot angle
%                         theta = RotAngle(ii)/180*pi;
%                         Mfilt=M;
%                         Mfilt(:,7) = M(:,4)*cos(theta) + M(:,5)*sin(theta); % 
%                     else
%                         M(:,7) = sqrt(M(:,4).^2+ M(:,5).^2); %
%                         Mfilt(:,7) = sqrt(Mfilt(:,4).^2 + Mfilt(:,5).^2); % 
%                     end
%                     %[Damage1hr,Damage1hrF,ArcLength,LineType]=getMLdamage(matfile,FatLifeYrs,standard,tcutoff,omega); % an array that is max(nNodes) by nML, will have nans for lines with less nodes                    
%                     if ii==1
%                         [Meq(:,ii), Dmg(:,ii)]=CalDEL(M, [], tstep, m, N0, FatLifeYrs, Mu, Res.CutInTime);
%                     end
%                     if iIter>0
%                         [MeqF(:,ii), DmgF(:,ii)]=CalDEL(Mfilt, [], tstep, m, N0, FatLifeYrs, Mu, Res.CutInTime);         
%                     else
%                         DmgF=Dmg;
%                         MeqF=Meq;
%                     end
    
    
% for mm=1:nFigs % for each DOF
%     if iIter==2 && mm<=6
%         Dmg2Plt=Damage;
%         Fat2Plt=Allfatigue;
%     else
%         Dmg2Plt=DamageF;
%         Fat2Plt=AllfatigueF;
%     end
%      [DmgSort,binsort]=sort(Dmg2Plt,3,'descend');
% 
% 
%     if mm<=6
%         Fig{mm}=figure('name',sprintf('TowerBase Fatigue-DOF%d',mm));
%     else
%         if iIter==2
%             Fig{mm}=figure('name',sprintf('TowerBase Fatigue-Rot'));
%         else
%             Fig{mm}=figure('name',sprintf('TowerBase Fatigue-RXY'));
%         end
%     end
%     iplot=~isnan(Fat2Plt(mm,:)); %remove nans % x nIter
%     nNm=nansum(iplot);
%     FatigueML=squeeze(DmgSort(mm,iplot,1+nanbins:end)); % nIter x BIN 
%     FatigueMLtotal=cumsum(FatigueML,2); % nIter (sum over the bins)
% %     % ML specific
% %     ALm=ArcLength(iplot,mm)';
%      binML=squeeze(binsort(mm,iplot,1+nanbins:end)); 
%      h=zeros(nNm,nBins2plot - (1+nanbins));
%      h(1,1)=plot(1:nD,squeeze(FatigueMLtotal(:,end)),'k--','linewidth',3)  ;
%      %legstr{1}=sprintf('Total ML%d', mm);
% %      % ML specific
%     for nn=1:nD
%         switch iIter
%             case 0 
%                 xtickstr{nn}='RotAngle=0';
%             case 1
%                 xtickstr{nn}=sprintf('T_{low}=%d, T_{high}=%d',Tfilt(1,nn),Tfilt(2,nn));
%             case 2
%                 xtickstr{nn}=sprintf('RotAngle=%d',RotAngle(nn));
%         end
%     end
%     hold on
%     for bb=1:nBins2plot%(1+nanbins):nBins2plot
%     %FatigueMLb=cumsum(FatigueML(:,bb),2); % all plot nodes, bb'th bin        
%         %plot vertical lines representing fatigue contribution
%         if bb==1%(1+nanbins)
%             h(:,bb)=line([1:nIter;1:nIter],[zeros(1,nNm);squeeze(FatigueMLtotal(:,bb))'],'linewidth',6,'color',colorstr{bb});
%         else
%             h(:,bb)=line([1:nIter;1:nIter],[squeeze(FatigueMLtotal(:,bb-1))';squeeze(FatigueMLtotal(:,bb))'],'linewidth',6,'color',colorstr{bb});
%         end
%         [maxFatML,iNode]=max(FatigueMLtotal(:,end));
% 
%         legstr{bb}=sprintf('Bin #%d-Seed %d', floor( (binML(iNode,bb) -1)/nSeeds)+1,rem(binML(iNode,bb)-1,nSeeds)+1);
%     end
%     legend(h(1,:),legstr);
%     grid on
%     hold off
%     clear legstr
%     xlim([.5 nIter+.5])
%     set(gca,'xtick',1:nIter,'xticklabel',xtickstr)
%     %axis([0 mAL 0 1])
% end

end
function Fig = plotTopNBins(figname,nBins2plot,nanbins,FatigueMLtotal,binML,xtickstr,ylabelstr,colorstr,nSeeds)
    nD = length(xtickstr);
    Fig = figure('name',figname);
    h=zeros(nD,nBins2plot - (1+nanbins));
    h(1,1)=plot(1:nD,squeeze(FatigueMLtotal(:,end)),'k--','linewidth',3);
%     for nn=1:nD
%         xtickstr{nn}=sprintf('%s=%d',xstr,xstrd(nn));
%     end
    hold on
    for bb=1:nBins2plot%(1+nanbins):nBins2plot
        %plot vertical lines representing fatigue contribution
        if bb==1%(1+nanbins)
            h(:,bb)=line([1:nD;1:nD],[zeros(1,nD);squeeze(FatigueMLtotal(:,bb))'],'linewidth',6,'color',colorstr{bb});
        else
            %size(squeeze(FatigueMLtotal(:,bb-1))')
            %size(squeeze(FatigueMLtotal(:,bb))')
            h(:,bb)=line([1:nD;1:nD],[squeeze(FatigueMLtotal(:,bb-1))';squeeze(FatigueMLtotal(:,bb))'],'linewidth',6,'color',colorstr{bb});
        end
        [maxFatML,iNode]=max(FatigueMLtotal(:,end));
        legstr{bb}=sprintf('Bin #%d-Seed %d', floor( (binML(iNode,bb) -1)/nSeeds)+1,rem(binML(iNode,bb)-1,nSeeds)+1);
    end
    legend(h(1,:),legstr);
    grid on
    hold off
    clear legstr
    xlim([.5 nD+.5])
    set(gca,'xtick',1:nD,'xticklabel',xtickstr)
    ylabel(ylabelstr)
end