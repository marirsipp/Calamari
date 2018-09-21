function [Meq,Dmg]=setupCalDEL(M,Tfilt,RotAngle,tstep,MNcurve,FatLifeYrs,TransTime,n_order,varargin)
% This function supercedes DmgEquvLoads
% M is a matrix nT x nDOF, correponding to timeseries of (base-bending) moment
% Output is [ nDOF + length(RotAngle) ]  x length(Tfilt)+1 of equivalent moment:
% DOF | Unfiltered  | T1 filt | T2filt | ...
% ----|-------------|---------|--------| ...
%  1  |     Meq1    |Meq1F-t1 |Meq1F-t2| ..
% ... |             |         |        | . ...
%  6  |     Meq6    |Meq6F-t1 |Meq6F-t2| ..
% Rot1|   MeqRot1   |MeqR1-t1v|MeqR1-t1| ..
% ... |             |         |        | . ...
% RotN|   MeqRotN   |MeqRN-t1 |MeqRN-t1| ..
if nargin<8
    n_order=5;
end
nTf = size(Tfilt,2) + 1; % no time filter is the first column
nRot=max([length(RotAngle) 1]);
if length(n_order)~=nRot
    n_order= repmat(n_order(1),[1 nRot]);
end
[nT,nFree] = size(M);
M = [M nan(nT,nRot)]; % add in space for rotational angles
if nFree>=5 
    for rr = 1:nRot 
        if nRot>1
            %you are using rot angle
            theta = RotAngle(rr)/180*pi;
            M(:,nFree+rr) = M(:,4)*cos(theta) + M(:,5)*sin(theta); % 
        else
            M(:,nFree+rr) = sqrt(M(:,4).^2+ M(:,5).^2); %
        end
    end
end
nDOF = nFree + nRot; % = size(M,2); % added in rotational 

Dmg=nan(nDOF,nTf); 
Meq=nan(nDOF,nTf); 
%for ff=1:nDOF
%% Run the Code!
[Meq(:,1), Dmg(:,1)]=CalDEL(M, [], tstep, MNcurve.m, MNcurve.N0, FatLifeYrs, MNcurve.Mu, TransTime);
for tt = 1:nTf-1
    %% Filtering...
    Wn=tstep/(Tfilt(1,tt)/2);
    Wn2=tstep/(Tfilt(2,tt)/2);
    if Tfilt(1,tt)==0 && isinf(Tfilt(2,tt))
        Mfilt=M;
    elseif Tfilt(1,tt)==0 && ~isinf(Tfilt(2,tt)) 
        [b2,a2] = butter(n_order(tt),Wn2,'high');
        Mfilt=filtfilt(b2,a2,M);
    elseif isinf(Tfilt(2,tt))  && Tfilt(1,tt)~=0
        [b,a] = butter(n_order(tt),Wn); 
        Mfilt = filtfilt(b,a,M); 
    elseif ~isinf(Tfilt(2,tt)) && Tfilt(1,tt)~=0
        [b2,a2] = butter(n_order(tt),Wn2,'high');
        [b,a] = butter(n_order(tt),Wn); 
        Mfilt = filtfilt(b,a,M); 
        Mfilt= filtfilt(b2,a2,Mfilt);
    end 
    % Run the code on the filtered
    [Meq(:,tt+1), Dmg(:,tt+1)]=CalDEL(Mfilt, [], tstep, MNcurve.m, MNcurve.N0, FatLifeYrs, MNcurve.Mu, TransTime);  
end
        
%end                        
                        
                        


end