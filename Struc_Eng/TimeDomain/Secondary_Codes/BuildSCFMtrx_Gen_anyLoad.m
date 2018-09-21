function [] = BuildSCFMtrx_Gen_anyLoad (path_str, path_SCF, LineNo, PartName, TorB, StrNominal ,CutRto,Loads)

%Create SCF matrix for a certain connection from stress matrix
%Input:
%path_str  - path for stress matrix
%path_sCF  - path for outputing SCF matrix
%LineNo    - connection number
%PartName  - connecting member name
%TorB      - Top or bottom surface where the stresses are output
%StrNominal- Nominal stress defined at the tower base, MPa
%CutRto    - Ratio of stress when determining dominating load case

FileName = [path_str,'StrMtx_',LineNo,'_',PartName,'_',TorB,'.csv'];

rst=importdata(FileName);
Nnode = size(rst.data,1); %Total number of nodes
SCFMtx = zeros(Nnode,12);
header = cell(1,12);

SCFMtx(:,1:5) = rst.data(:,1:5); %Node number, x-coord, y-coord, z-coord, thk
header(1:5) = rst.textdata(1:5);
    for i = 1:length(Loads)
    header(5+i)   = {['SCF_' Loads{i}]};
    end
header(12) = {'MxorMy'};

for i=1:length(Loads)
    
    SY = rst.data(:,(5+(i-1)*3+1));
    SZ = rst.data(:,(5+(i-1)*3+2));
    SYZ = rst.data(:,(5+(i-1)*3+3));
    
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

OutputFile = [path_SCF,'SCFMtx_',LineNo,'_',PartName,'_',TorB,'.csv'];
format1 = ['%8s',',', repmat(['%6s',','],1,3), '%7s']; % Node_num, X-cord, Y-cord, Z-cord, thk(mm)
for  i=1:length(Loads)
    format1 = [format1,',','%',int2str(3+1+length(Loads{1})),'s']; % SCF_'Load'
end
format1 = [format1 ,',','%7s','\n']; % MxorMy
format2 = ['%10.0f', repmat([',','%10.3f'],1,3), ',', '%6.1f', repmat([',','%10.3f'],1,6),',','%2.0f','\n'];

fid = fopen(OutputFile,'w');
fprintf(fid,format1, header{1:12});
for n=1:Nnode
    fprintf(fid,format2, SCFMtx(n,:));
end
fclose(fid);
end