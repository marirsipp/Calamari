function [] = BuildSCFMtx (path0, LineNo, PartName, TorB, StrNominal ,CutRto, SN)

% path = 'C:\Users\Engineer\Documents\MATLAB\TimeDomain\Itr14_1\StrMtrx\';
% LineNo = 'L1';
% PartName = 'TB';
% TorB = 'Top';
% StrNominal = [0.2,0.2,0.1,0.6,0.6,0.3];
% CutRto = 2;
% SN = 1;

path = [path0 'StrMtrx\'];
FileName = [path,'StrMtx_',LineNo,'_',PartName,'_',TorB,'.csv'];

data=importdata(FileName);
Nnode = size(data,1); %Total number of nodes
SCFMtx = zeros(Nnode,13);

SCFMtx(:,1:5) = data(:,1:5); %Node number, x-coord, y-coord, z-coord, thk
SCFMtx(:,13) = SN * ones(Nnode,1); %S-N curve selection

for i=1:6
    
    SY = data(:,(5+(i-1)*3+1));
    SZ = data(:,(5+(i-1)*3+2));
    SYZ = data(:,(5+(i-1)*3+3));
    
    S1 = ((SY+SZ)/2 + ( ((SY-SZ)/2).^2 + SYZ.^2 ).^0.5);
    S2 = ((SY+SZ)/2 - ( ((SY-SZ)/2).^2 + SYZ.^2 ).^0.5);
    
    SCF1 = S1/StrNominal(i);
    SCF2 = S2/StrNominal(i);
    
    for j=1:Nnode
        SCFMtx(j,5+i)= max(abs(SCF1(j)),abs(SCF2(j)));
    end
end

for k=1:Nnode
    
    if  ( SCFMtx(k,9)/SCFMtx(k,10) ) > CutRto %Mx dominated
        SCFMtx(k,12) = 1;
    else if ( SCFMtx(k,9)/SCFMtx(k,10) ) < (1/CutRto) %My dominated
             SCFMtx(k,12) = 2;
        else
             SCFMtx(k,12) = 3; %Mx, My both
        end
    end
    
end
OutputName = [path0,'SCFMtrx\','SCFMtx_',LineNo,'_',PartName,'_',TorB,'.csv'];
csvwrite(OutputName,SCFMtx)
end