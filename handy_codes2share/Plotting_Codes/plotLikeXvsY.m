function plotLikeXvsY(OutS,runs,varX,varY,seedvar,plotstr,figdir)
h2s='max';
ylabelstr=getSeedLabel(varY);
xlabelstr=getSeedLabel(varX);
nruns=length(runs);
allrunames=fieldnames(OutS(1).(varX)); % some seed names in here
ndirsX=length(OutS(1).(varX).(allrunames{1}).Mean);
ndirsY=length(OutS(1).(varY).(allrunames{1}).Mean);
if ndirsX>1 || ndirsY>1
    error(['You are trying to plot ' varX ' vs ' varY ', which has a length of ' num2str(ndirsX) ' and ' num2str(ndirsY) '. Please choose to plot scalar variables.']) 
end
figname=[varX 'v' varY];
h1=figure('Position',[0+15*1 0 800 800],'name',figname);
hold all;
mymaxX=nan(nruns,1);
mymaxY=nan(nruns,1);
for ii=1:nruns
   seedstr=['Seed' sprintf('%d',runs(ii)) h2s];
   runnum = OutS.(seedvar).(seedstr);
   runstr{ii}=['Run' sprintf('%d',runnum)];
   mymaxX(ii)=OutS.(varX).(runstr{ii}).Max; 
   mymaxY(ii)=OutS.(varY).(runstr{ii}).Max; 
end
title([varX '  vs ' varY])
P1=polyfit(mymaxX,mymaxY,1);
fitX=linspace(min(mymaxX),max(mymaxX),1000);
fitY=P1(1)*fitX+P1(2);
plot(mymaxX,mymaxY,'ko','markerfacecolor','w','markersize',6)
hold on
for ii=1:nruns
   text(mymaxX(ii)+max(mymaxX)*.001,mymaxY(ii)-max(mymaxY)*.001,runstr{ii},'fontsize',6) 
end
%text(.5*max(mymaxX),.2*max(mymaxY),sprintf('fit=%2.2e*x+%2.2e',P1(1),P1(2)))
grid on
ylabel(ylabelstr)
xlabel(xlabelstr)
cfigname=[figdir, plotstr '_' figname,  '.png'];
print(h1,'-dpng',cfigname,'-r300')
crop(cfigname)
end