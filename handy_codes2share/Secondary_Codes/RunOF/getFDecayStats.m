function [amp,dec,dampratio,T,Xm,iM,Xn,iN]=getFDecayStats(time,X,filt)
%make sure time and X are columns
if size(time,2)>size(time,1)
    time=time';
end
if size(X,2)>size(X,1)
    X=X';
end
atleast=0.05;
%% Get Maximums
[Xm,iM]=lmax(X,filt);
Xm=Xm';
if max(X)==X(1)
    Xm=[X(1); Xm]; % a little cheat for the free-decay tests where we know we're at a max at t=release
    iM=[1 iM];
end
newfilt=filt;
while isempty(Xm)
    newfilt=newfilt/10;
    [Xm,iM]=lmax(X,newfilt);
end
XmZero=Xm-mean(X);
Xm=Xm(abs(XmZero)>abs(XmZero(1))*atleast);% amplitude must be at least 10% of max to keep
iM=iM(abs(XmZero)>abs(XmZero(1))*atleast);
XmZero=Xm-mean(X);
%% Get Minimums
[Xn,iN]=lmin(X,filt);
Xn=Xn';
if time(iN(1))<time(iM(1))
    Xn=Xn(2:end);
    iN=iN(2:end);
end
newfilt=filt;

while isempty(Xn)
    newfilt=newfilt/10;
    [Xn,iN]=lmin(X,newfilt);
end
XnZero=Xn-mean(X);
Xn=Xn(abs(XnZero)>abs(XnZero(1))*atleast);% amplitude must be at least 10% of max to keep
iN=iN(abs(XnZero)>abs(XnZero(1))*atleast);
XnZero=Xn-mean(X); % don't want to cross 0 when taking log
% use the mins like Dominique?
ndec=min([length(iM) length(iN)]);
if length(iM)>ndec
    Xm=Xm(1:ndec);
    XmZero=XmZero(1:ndec);
    iM=iM(1:ndec);
end
if length(iN)>ndec
    Xn=Xn(1:ndec);
    XnZero=XnZero(1:ndec);
    iN=iN(1:ndec);
end
tM=diff(time(iM));
tN=diff(time(iN));

%% Ref = CFD approach to roll damping of ship with bilge keel with experimental validation, AOR 55, 2016
% Sec 3.4
ampM=mean([Xm(1:end-1)  Xm(2:end)],2);
ampN=mean([Xn(1:end-1) Xn(2:end)],2);
amp=[ampM ;ampN];
decM= log(XmZero(1:end-1)./ XmZero(2:end) );
decN= log(XnZero(1:end-1)./ XnZero(2:end) );
dec=[decM ;decN];
dampratioM=1./sqrt(1+ (2*pi./decM).^2); 
dampratioN=1./sqrt(1+ (2*pi./decN).^2); 
dampratio=[dampratioM ;dampratioN];
%% Copy from Decay.m
T=mean([tM tN],2);
X1=X(iM(2:end))-X(iN(2:end));
X2=X(iM(1:end-1))-X(iN(1:end-1));
%from wikipedia: https://en.wikipedia.org/wiki/Logarithmic_decrement
% dec=log(X2./X1);
% dampratio=100./sqrt(1+ (2*pi./dec).^2); % actual damping/critical damping
% dampratio=100*dec./sqrt( (2*pi)^2 +dec.^2);
% % twopi=2*abs(log(-1));
% % dec=100*log(X2./X1)/twopi; %dec
% amp=(X2+X1)/4;



% dt=mean(diff(time));
% %findpeaks(X,'minpeakdistance',12)
% 
% Tm=mean(diff(time(iM)));
% Tn=mean(diff(time(iN)));
% T=mean([Tm Tn]);
% if iplot
%     figure('name',tstr)
%     plot(time,X,'k-',time(iM),Xm,'r+',time(iN),Xn,'rx')
% end
% X1s=Xm(1:end-1); X2s=Xm(2:end); 
% dec=log(X1s./X2s);
% b=100*1./sqrt(1+(2*pi./dec).^2); % damping ratio as a percent of critical (b=100 is critical damping)
end