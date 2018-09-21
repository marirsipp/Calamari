function RankDELfromRAO(matfile)
% load in a DEL_bin.mat
varnames={'Wdmg','Meq'};
strnames={'Weighted','Unweighted'};
iName=1; %write wave heading in scatter plot
[parentdir,filename,foo]=fileparts(matfile);
[bar,RunName,foo]=fileparts(parentdir);
RunParams=str2double(regexp(RunName,'\-?\d*','match'));
% various parameters
Orient=RunParams(1); 
% dT=RunParams(2)/10; 
% Lt=RunParams(3); 
% dTp=RunParams(4)/10;

%% LOAD data
load(matfile); % DEL.TBload, DEL.Prob,DEL.Meq,
vars2save={'DEL'};
nDOF=6;
%rawfields=fieldnames(rawdata);
nTotBins=length(DEL.Prob);
alldata=nan(nTotBins,9); % Hs Tp WaveDir DEL1-6

for ss=1:length(varnames) % Meq or Dmg
    vars2save = {vars2save{:}, varnames{ss}};

    for nn = 1:nTotBins
        svar = DEL.(varnames{ss});
        bDEL = svar(:,nn);
        bdata=[DEL.Hs(nn) DEL.Tp(nn) DEL.Wdir(nn) transpose(bDEL(1:nDOF))];
        alldata(nn,:)=bdata;
    end

    
    ibins=nan(nTotBins,nDOF);
    rank_celldata=cell(nTotBins,nDOF);
    %rankdata(1,1)={'Hs','Tp','Wdir'};
    for qq=1:nDOF
       [foo,ibins(:,qq)]=sort(alldata(:,3+qq),'descend'); 
       sortdata=alldata(ibins(:,qq),:);
       for pp=1:nTotBins
           rank_celldata{pp,qq}=[sortdata(pp,1:3) sortdata(pp,3+qq)];
       end

    end
    eval([varnames{ss} '=rank_celldata;']); % really terrible syntax...
    save(matfile,vars2save{:},'-append')
    %% PLOT
    rankMat=cell2mat(rank_celldata); % matrix = [Hs Tp Wdir DELx Hs Tp Wdir DELy Hs Tp Wdir DELz Hs Tp Wdir DELRx Hs Tp Wdir DELRy Hs Tp Wdir DELRz]
    %% PLOT RANK BARS
    plotRankBars(rankMat,strnames{ss},varnames{ss});
    
    %% PLOT scatter (like getTwrBfatigue)
    Mstrs={'Mx','My'};
    Ms=[4 5];
    for pp=1:length(Mstrs)
        Mxy=4*(Ms(pp)-1) ;
        figure('name',[ strnames{ss} Mstrs{pp} ' DEL vs Hs+Tp of' ' bins'],'units','normalized','outerposition',[.1 .1 .8 .9])
        WaveDirStrs=strread(num2str(rankMat(:,Mxy+3)'),'%s');
        HsStrs=arrayfun(@num2str, rankMat(:,Mxy+1), 'unif', 0);
        %p1=scatter3Plot([rankMat(:,Mxy+2) rankMat(:,Mxy+1)+.2*(rankMat(:,Mxy+3)-90)/180 rankMat(:,Mxy+4)],WaveDirStrs,iName);
        
        p1=polar3Plot([rankMat(:,Mxy+3)*pi/180+.5*(rankMat(:,Mxy+1)-max(rankMat(:,Mxy+1))*.5)/max(rankMat(:,Mxy+1)) rankMat(:,Mxy+2) rankMat(:,Mxy+4)],'Wave','Tp',HsStrs,iName,Orient);
    end
end
end

function plotRankBars(rankMat,strname,varname)
%% plot rank bars (like getTwrBfatigue)
    figure('name',['Rank-ordered ' strname ' bins'])
 nDOF=6;
    cumMat=cumsum(rankMat);
    TtlDEL=cumMat(end,4:4:end);
    colorstr={[0 0 1], [1 0 1],[1 0 0],[0 1 0],[0 1 1],[.6 .6 0],[0 .6 .6],[.3 0 .3],[.6 0 .6],[0 0 1]*.8, [1 0 1]*.8,[1 0 0]*.8,[0 1 0]*.8,[0 1 1]*.8,[.6 .6 0]*.8,[0 .6 .6]*.8,[.3 0 .3]*.8,[.6 0 .6]*.8};
    nBins2plot=length(colorstr);
    for bb=1:nBins2plot%(1+nanbins):nBins2plot
        %plot vertical lines representing fatigue contribution
        bc=mod(bb-1,nBins2plot)+1;
        if bb==1%(1+nanbins)
            y1s=zeros(1,nDOF);
        else
            y1s=cumMat(bb-1,4:4:end)./TtlDEL;
        end
        y2s=cumMat(bb,4:4:end)./TtlDEL;
        h(:,bb)=line([1:nDOF;1:nDOF],[y1s;y2s],'linewidth',6,'color',colorstr{bc});
        ybars=mean([y1s;y2s],1);
        for qq=1:nDOF
            qind=4*(qq-1)+1;
            text(qq-.5,ybars(qq),sprintf('H_s%2.1f T_p%2.1f Dir%d',rankMat(bb,qind),rankMat(bb,qind+1),rankMat(bb,qind+2)),'color',colorstr{bc})
        end
        %legstr{bb}=
    end
    ylabel(['% of Total ' varname])
    %legend(h(1,:),legstr);
    grid on
    hold off
    %clear legstr
    xlim([.5 nDOF+.5])
    set(gca,'xtick',1:nDOF,'xticklabel',{'F_x','F_y','F_z','M_x','M_y','M_z'})
end
function p1=scatter3Plot(dataMat,names,iName)
nTick=4;
cf=1;
xs=dataMat(:,1); ys=dataMat(:,2); zs=dataMat(:,3);
nColors=100;
mycmap=getcmap(nColors,{'dgreen','green','yellow','orange','red','dred'});
nSim=length(xs);
for ii=1:nSim
    pc=interp1(transpose(linspace(min(zs),max(zs),nColors)),mycmap,zs(ii),'linear');
    hcf=gcf;
    p1=plot(xs(ii),ys(ii),'o','markerfacecolor',pc,'markeredgecolor','k','markersize',5);
    hold on
    if iName
        text(xs(ii)*1.01,ys(ii),names{ii},'fontsize',6)
    end
end
hold off
%colorbar label
tc=round( linspace(min(zs),max(zs),nTick+1)/cf*10)/10;
for cc=1:1:nTick+1
    tclabel{cc}=num2str(tc(cc));
end
ylabel(hc,'DEL','interpreter','latex')
set(hc,'Ytick',linspace(1,nColors,nTick+1),'yticklabel',tclabel)
end

