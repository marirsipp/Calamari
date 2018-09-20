function [Amp,Ph,T,Xd]=getFStats(time,X,filt)
%make sure time and X are columns
if size(time,2)>size(time,1)
    time=time';
end
[nT,nDim]=size(X);
if size(time,1)~=nT
    time=time';
end
% if size(X,2)>size(X,1)
%     X=X';
% end
Amp=nan(1,nDim);
Ph=nan(1,nDim);
T=nan(1,nDim);
%% Get Maximums
for ii=1:nDim
    [Xd(ii).Max,Xd(ii).iMax]=lmax(X(:,ii),filt);
    Xd(ii).MaxZero=Xd(ii).Max-mean(X(:,ii));

%% Get Minimums
    [Xd(ii).Min,Xd(ii).iMin]=lmin(X(:,ii),filt);
    Xd(ii).MinZero=Xd(ii).Min-mean(X(:,ii)); % don't want to cross 0 when taking log

    % use the mins like Dominique?
    ndec=min([length(Xd(ii).iMax) length(Xd(ii).iMin)]);
    if length(Xd(ii).iMax)>ndec
        Xd(ii).Max=Xd(ii).Max(1:ndec);
        Xd(ii).MaxZero=Xd(ii).MaxZero(1:ndec);
        Xd(ii).iMax=Xd(ii).iMax(1:ndec);
    end
    if length(Xd(ii).iMin)>ndec
        Xd(ii).Min=Xd(ii).Min(1:ndec);
        Xd(ii).MinZero=Xd(ii).MinZero(1:ndec);
        Xd(ii).iMin=Xd(ii).iMin(1:ndec);
    end
    tM=diff(time(Xd(ii).iMax));
    tN=diff(time(Xd(ii).iMin));
    
    Amp(1,ii)=mean(Xd(ii).Max- Xd(ii).Min)/2;
    
    %% Copy from Decay.m
    T(1,ii)=mean(mean([tM tN],2),1);
    Ph(1,ii)=mean(mod(time(Xd(ii).iMax),T(1,ii)));
end
end