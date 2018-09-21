function p1=polar3Plot(dataMat,thname,rname,names,iName,Head)
nTick=4;
cf=1;
ths=mod(-dataMat(:,1),2*pi); % transform from OrcaFlex to oceanographic (TOWARDS, +CW)
ys=dataMat(:,2); zs=dataMat(:,3);
nColors=100;
mycmap=getcmap(nColors,{'dgreen','green','yellow','orange','red','dred'});
nSim=length(ths);
thf = 0 : .01 : 2 * pi;

fHand=gcf;
aHand=axes('parent',fHand);
P = polar(thf, max(ys) * ones(size(thf))*1.01,'parent',aHand);

% Get the handles of interest (using volatile info above).
hands = findall(fHand,'parent', aHand, 'Type', 'text');
hands = hands(strncmp('  ', get(hands,'String'), 2));
hands = sort(hands);
% Relabel from inside out.
yls=[1:length(hands)]*ceil(max(ys))/length(hands);
az=225*pi/180;
% Platform heading
Plfm_Trnsfrm=mod(-Head,360)*pi/180; % go from OrcaFlex to normal

azlines=Plfm_Trnsfrm+[15:30:345]*pi/180;
for ii = 1:length(hands);
  ylab=  sprintf('%s=%2.1f',rname,yls(ii));
  set(hands(ii),'String', ylab,'position',[1.1*yls(ii)*cos(az) 1.1*yls(ii)*sin(az)])
end
set(P, 'Visible', 'off');
% find all of the lines in the polar plot
 h = findall(gcf,'type','line');
% % remove the handle for the polar plot line from the array
idel=zeros(length(h),1);
for hh=1:length(h)
%     if h(hh) == P
        ydh= get(h(hh),'yd');
        if ydh(1) ==0;
            idel(hh)=1;
        end
%     end
end
h(logical(idel)) = [];
% % delete all other lines
delete(h);
hold on
for ii=1:nSim
    pc=interp1(transpose(linspace(min(zs),max(zs),nColors)),mycmap,zs(ii),'linear');
    p1=polar(ths(ii),ys(ii),'o');
    set(p1,'markerfacecolor',pc,'markersize',4);% make it clearer: 'markeredgecolor','k',
    if iName && ~isnan(zs(ii))
        text(ys(ii)*cos(ths(ii)),ys(ii)*sin(ths(ii)),names{ii},'fontsize',6)
    end
end

Lpfm=ceil(max(ys))/5;
Lhp=Lpfm*sqrt(3)/2;
Xpfm=[0 2*Lhp/3; -Lpfm/2 -Lhp/3; Lpfm/2 -Lhp/3];
Xpfm=[Xpfm; Xpfm(1,:)];
Xr=Rotate2DMat(Xpfm,Plfm_Trnsfrm-pi/2); % take into account 0 going N
Xth=angle(Xr(:,1) + 1i*(Xr(:,2)));
XR=abs(Xr(:,1) + 1i*(Xr(:,2)));
for pp=1:3
   line([Xr(pp,1) Xr(pp+1,1) ],[Xr(pp,2) Xr(pp+1,2) ],'linewidth',2','linestyle','-','color','r')
end
wf=polar(Xth(1),XR(1),'ro');
set(wf,'markerfacecolor','r','markeredgecolor','r','markersize',6);
% legend
colormap(mycmap)
hc=colorbar;
hold off
view([90 -90]) %OrcaFlex convention
%grid on

titleStr=sprintf('Heading %d \n %s Heading (TOWARDS)',Head,thname);
title(titleStr)
for pp=1:length(azlines)
   line(ceil(max(ys))*[0 cos(azlines(pp))],ceil(max(ys))*[0 sin(azlines(pp))],'linewidth',2','linestyle','--','color','k')
end
%colorbar label
tc=round( linspace(min(zs),max(zs),nTick+1)/cf*10)/10;
for cc=1:1:nTick+1
    tclabel{cc}=num2str(tc(cc),'%1.1E');
end
ylabel(hc,'DEL','interpreter','latex')
set(hc,'Ytick',linspace(1,nColors,nTick+1),'yticklabel',tclabel)


end