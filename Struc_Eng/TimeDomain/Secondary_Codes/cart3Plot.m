function p1=cart3Plot(dataMat,names,iName,zStr)
nTick=4; cf=1;
if size(dataMat,2)>2
    zAxis=1;
    xs = dataMat(:,1); ys = dataMat(:,3); zs = dataMat(:,2);
else
    zAxis=0;
    xs = dataMat(:,1); ys = dataMat(:,2); 
end

nColors=100;
mycmap=getcmap(nColors,{'dgreen','green','yellow','orange','red','dred'});
nSim=length(xs);

fHand=gcf;
%aHand=axes('parent',fHand);

hold on
for ii=1:nSim
    if zAxis
        pc=interp1(transpose(linspace(min(zs),max(zs),nColors)),mycmap,zs(ii),'linear');
    else
        pc = [0 0 0];
    end
    p1=plot(xs(ii),ys(ii),'o');
    set(p1,'markerfacecolor',pc,'markersize',4,'markeredgecolor','none');% make it clearer: 'markeredgecolor','k',
    if iName && ~isnan(ys(ii))
        text(xs(ii),ys(ii),names{ii},'fontsize',6)
    end
end

hold off
grid on

%colorbar label
if zAxis
    % legend
    colormap(mycmap)
    hc=colorbar;
    tc=round( linspace(min(zs),max(zs),nTick+1)/cf*10)/10;
    for cc=1:1:nTick+1
        tclabel{cc}=num2str(tc(cc),'%1.1E');
    end
    ylabel(hc,zStr,'interpreter','latex')
    set(hc,'Ytick',linspace(1,nColors,nTick+1),'yticklabel',tclabel)
end
end