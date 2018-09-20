function plotMyWEP(WEPpts,WEPlabels,Ptfm)
origin= [0 0 0];%[Ptfm.Col.Lh*2/3 0 0];
Ncol=3;
WEPpts=WEPpts+repmat(origin,[length(WEPpts) 1]);
nWEPs=length(WEPpts)/2; %number of line segments ( 2 endpts per line )
nWEPc=nWEPs/Ncol; % number of lines per column
figure(99)
clf
hold on
iaz=[0:pi/1280:2*pi];
for kk=1:nWEPs
    iendA=2*(kk-1)+1;
    iendB=2*(kk-1)+2;
    plot(WEPpts(iendA,1),WEPpts(iendA,2),'ko') 
    plot(WEPpts(iendA:iendB,1),WEPpts(iendA:iendB,2),'b-')
    text(mean(WEPpts(iendA:iendB,1)) ,mean(WEPpts(iendA:iendB,2)),WEPlabels{iendA})
end
%ColX=zeros(4,2);
ColX=getColX(Ptfm,[0 0 0]);
%WFangles=[150 270 30]*pi/180;
for ii=1:Ncol
   %ColX(ii+1,:)= ColX(ii,:)+[Ptfm.Col.L(ii)*cos(WFangles(ii)) Ptfm.Col.L(ii)*sin(WFangles(ii))];
   
   plot(ColX(ii,1)+.5*Ptfm.Col.D(ii)*cos(iaz),ColX(ii,2)+.5*Ptfm.Col.D(ii)*sin(iaz),'r-') 
end
grid on
axis equal
hold off

end