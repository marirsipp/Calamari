function [ NCH,NC ] = rainflowdotexe( timeseries )
%C THIS IS A RAINFLOW ANALYZER.  GIVEN A TIME HISTORY, IT WILL COUNT
% C THE HALF AND FULL CYCLES ASSOCIATED WITH THE HISTORY.  THIS IS
% C BASED ON AN ALGORITHM BY LUTES WHICH IS VERY EFFICIENT.  DETAILS OF
% C THE ALGORITHM ARE IN JJZ'S MASTER'S THESIS.
% CONVERTED TO FORTRAN AND TESTED - 12/18/91.
% CHANGED 5/11/93 TO ACCEPT 2 VALUES RIGHT NEXT TO EACH TO EACH OTHER
% C TO BE EXACTLY THE SAME
% This software was borrowed by DGR from his former employer
% This software was re-coded into MATLAB, because it was slow AF.
% Copyright Sam Kanner, Principle Power Inc, 2016. 

% INPUTS:
% timeseries is a vector of a timeseries of arbitrary length

% OUTPUTS:
% NCH is a vector containing the amplitudes of the half-cycles
% NC is a vector containing the amplitudes of the full-cycles
% Initialize
nPts=length(timeseries);
V=zeros(nPts,1);
T=zeros(nPts,1);
NC=nan(nPts,1); % amplitude of full cycles
nNC=0;
NCH = nan(nPts,1); % amplitude of half cycles
nNCH=0;
EXT=0;
%cks=zeros(nPts,1);
K=1;
IPP=0;
%% GET STATS OF TIMESERIES
 xmean=mean(timeseries);
% tmpi=nan(nPts,4);
% for ii=1:4
%     tmpi(:,ii)=timeseries.^ii;
% end
% xmomi=sum(tmpi,1)/nPts;
% xstdev=std(timeseries);
% xskew=(xmomi(3)-3*xmean*xmomi(2)+2*xmean^3)/xstdev^3;
% xkurt=(xmomi(4)-4*xmean*xmomi(3)+6*xmomi(2)*xmean^2-3*xmean^4)/xstdev^4;

if size(timeseries,1)==1
    x=double(timeseries'-xmean); % make a column vector
else
    x=double(timeseries-xmean);
end

%% check for exact duplicates
x1=x(1:end-1); x2=x(2:end);
idup=[0;x2-x1==0]; % change the second value, if necessary
ndup=sum(idup);
niter=1;
nxmax = floor(log(abs(max(x)))./log(10));
nxeps = floor(log(eps('single'))./log(10)); % double would probably be fine..
dx=1e-10;
while ndup
    disp(sprintf('Found %d duplicates, adding %1.1E to the idential data on Iteration %d', ndup,dx*10^(max([nxeps nxmax])+niter-1),niter))    
    offvec=dx*10^(max([nxeps nxmax])+niter-1)*[1:ndup]';% *10^(niter-1)  [1+1e-6:1e-6:1+ndup*1e-6]';
    x(logical(idup))=x(logical(idup))+offvec;% cheapo way to change the repeated value(s), if necessary%1.00000001;
    x1=x(1:end-1); x2=x(2:end);
    idup=[0;x2-x1==0]; % change the second value, if necessary
    ndup=sum(idup);
    niter=niter+1;
end
%% count zero-crossings
zflag=[0; 1*(x2>0 & x1<0) + -1*(x2<0 & x1>0)]; %downwards crossing is -1, upwards is +1
nZrx=sum(abs(zflag));

%% find peaks/valleys
xn2=[x(1);x(1); x(1:end-2)]; xn1=[x(1); x(1:end-1)]; xn=x(1:end);
PCK=(xn-xn1).*(xn1-xn2); % if you have a sign change between the current and the past
pks = PCK < 0;
nPks= sum(abs(pks));
iPks= find(pks);

if ~isempty(iPks)
    %% RUN ALGORITHM
    KF = (xn1(iPks(1))-x(1))/abs(xn1(iPks(1))-x(1)); % Why does the first sign matter?
    V(1) = x(1)*KF; % first peak
    T(1) = 0;  % first trough
    PRP = T(1);%V(1); % no idea how to initialize..
    for ii=1:nPks
       PK = xn1(iPks(ii))*KF; %
       if EXT==0 %pks( iPks(ii)) == 1 % extrema is a MAX
           [T,IPP,K,NC,NCH,nNC,nNCH,EXT]=range1(PK,T,V,K,IPP,PRP,NC,NCH,nNC,nNCH);
       elseif EXT==1 %pks( iPks(ii)) == -1 % extrema is a MIN
           [V,IPP,PRP,K,NC,NCH,nNC,nNCH,EXT]=range2(PK,T,V,K,IPP,PRP,NC,NCH,nNC,nNCH);
       end
    end

    %% Close out remaining cycles
    if EXT==0
        if KF*x(end)>0
            PK=x(end)*KF;
            [T,IPP,K,NC,NCH,nNC,nNCH,EXT]=range1(PK,T,V,K,IPP,PRP,NC,NCH,nNC,nNCH);
            PK=0;
            [V,IPP,PRP,K,NC,NCH,nNC,nNCH,EXT]=range2(PK,T,V,K,IPP,PRP,NC,NCH,nNC,nNCH);
        else
            PK = 0;
            [T,IPP,K,NC,NCH,nNC,nNCH,EXT]=range1(PK,T,V,K,IPP,PRP,NC,NCH,nNC,nNCH);
        end
    else
        if KF*x(end)>0
            PK=0;
            [V,IPP,PRP,K,NC,NCH,nNC,nNCH,EXT]=range2(PK,T,V,K,IPP,PRP,NC,NCH,nNC,nNCH);
        else
            PK=x(end)*KF;
            [V,IPP,PRP,K,NC,NCH,nNC,nNCH,EXT]=range2(PK,T,V,K,IPP,PRP,NC,NCH,nNC,nNCH);
            PK=0;
            [T,IPP,K,NC,NCH,nNC,nNCH,EXT]=range1(PK,T,V,K,IPP,PRP,NC,NCH,nNC,nNCH);
        end
    end

    K1 = K - ~EXT;
    for ii=1:K1
        RA = T(ii) - V(ii);
        [NCH,nNCH]=keepRA(RA,NCH,nNCH);
    end
    if IPP ~=0
        RA = PRP- V(1);
        [NCH,nNCH]=keepRA(RA,NCH,nNCH);
    end
    if K~=1
        for ii=2:K
            RA = T(ii-1) - V(ii);
            [NCH,nNCH]=keepRA(RA,NCH,nNCH);      
        end  
    end

else
    % you tried to rainflow count a constant...
end
NC=NC(1:nNC);
NCH=NCH(1:nNCH);
end

function [T,IPP,K,NC,NCH,nNC,nNCH,EXT]=range1(PK,T,V,K,IPP,PRP,NC,NCH,nNC,nNCH)
% T is a vector of peaks
% V is a vector of valleys?
PP=PK; % previous peak?
EXT=1; 
if K == 1
    % BEGIN  -------2140---------
    T(1) = PP; 
    if IPP~=1 || PRP>T(1)
        return
    end
    RA = PRP-V(1);
    IPP = 0;
    [NCH,nNCH]=keepRA(RA,NCH,nNCH);
     % END -------2140---------
else
    for IZ=2:K
        if T(K+1-IZ)>PP
            K=K+2-IZ; %2160
            T(K)= PP;
            return % break the for loop
        end
        RA = T(K+1-IZ) - V(K+2 - IZ); % full cycle: amp -  next trough
        [NC,nNC]=keepRA(RA,NC,nNC);
    end
    if IPP==0 || PRP>PP
        %skip ahead
    else
        RA = PRP-V(1);
        [NCH,nNCH]=keepRA(RA,NCH,nNCH);
        IPP = 0;
    end
    % BEGIN  -------2130---------
    K=1;
    % BEGIN  -------2140---------
    T(1) = PP; 
    if IPP~=1 || PRP>T(1)
        return
    end
    RA = PRP-V(1);
    IPP = 0;
    [NCH,nNCH]=keepRA(RA,NCH,nNCH);
 % END -------2180---------
end
end

function [V,IPP,PRP,K,NC,NCH,nNC,nNCH,EXT]=range2(PK,T,V,K,IPP,PRP,NC,NCH,nNC,nNCH)
VV= PK;
EXT=0;
for IZ = 1:K
    if VV > V(K+1-IZ)
        % BEGIN  -------3150---------
        K = K+2 - IZ;
        V(K) = VV;
        return
    else
        RA = T(K+1 - IZ) - V(K+1-IZ); % full cycle: amp - current trough
        if IZ<K || IPP == 1
            % BEGIN  -------3100---------
            [NC,nNC]=keepRA(RA,NC,nNC);
%             nNC=sum(~isnan(NC));
%             NC(nNC+1)=RA;%full(RA,NC);           
        else
             [NCH,nNCH]=keepRA(RA,NCH,nNCH);
             IPP = 1;
             PRP = T(1);
             K = 1;
             V(1) = VV;
             return
        end   
    end
end
K = 1;
V(1) = VV;
end

function [NC,nNC]=keepRA(RA,NC,nNC)
if RA<0
    error('Uh oh, something is wrong, you are strengthening your structure somehow. Please contact your system administrator')
end
nNC=nNC+1;
NC(nNC)=RA;
end