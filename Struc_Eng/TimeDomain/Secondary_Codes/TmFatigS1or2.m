function[FatigLife] = TmFatigS1or2 (tstep,imat,path0,strBatch,ItrNo,LineNo,PartName,TorB,ColNs)
% Calculation of fatigue damage based on time history of maximum principal
% stress (S1) or minimum principal stress (S2) for each run

%--------------------------------Input-------------------------------------
%General path for load data
path1 = [ path0 strBatch '\'];
a0 = [path1 strBatch '.txt'] ; %Bin probability file
if imat == 1
    filedat = strcat([path1,strBatch,'.mat']); %Load time history file
end

%General path for stress data
path2 = [ path0 ItrNo '\'];
Strfile = strcat([path2,LineNo,'_',PartName,'_',TorB,'_','StrMtx','.csv']);

% path3 = [ path2 'Test' '\'];
% Strfile = strcat([path3,LineNo,'_',PartName,'_',TorB,'_','StrMtx','.csv']);

ThkColN = ColNs(1); %Thickness column number
StrColN1 = ColNs(2); %Normal stress starting column number
StrColN2 = ColNs(3); %Normal stress ending column number
SNColN = ColNs(4); %SN curve info column number

%Read bin probability file
fid0 = fopen(a0,'r');
percent = fscanf(fid0,'%f',[1 Inf]);
fclose(fid0)
proba=percent/100;
nrun = length(proba);
ampratio = 1/sum(proba);

%Read stress matrix 
data = importdata(Strfile);
% importfile(Strfile);
StrNm = data(:,StrColN1:StrColN2); %Normal stress matrix 
Thk = data(:,ThkColN); %Thkness of each member where hot spots locate
SN = data(:,SNColN); % SN curve selection

DamageS1 = TmFatigSDmg (tstep, imat, filedat, proba, nrun, StrNm, Thk, SN, 1);
DamageS2 = TmFatigSDmg (tstep, imat, filedat, proba, nrun, StrNm, Thk, SN, 2);

for i = 1:size(DamageS1,1) %Per run
    for j = 1:size(DamageS1,2) %Per hot spot
        if DamageS1(i,j) >= DamageS2(i,j)
            DamageS1or2 (i,j) = DamageS1(i,j);
        else
            DamageS1or2 (i,j) = DamageS2(i,j);
        end
    end
end

for j = 1:size(DamageS1,2) %Per hot spot
    FatigLife (1,j) = 1 / sum(ampratio* proba'.*DamageS1(:,j));
    FatigLife (2,j) = 1 / sum(ampratio* proba'.*DamageS2(:,j));
    FatigLife (3,j) = 1 / sum(ampratio* proba'.*DamageS1or2(:,j));
end

Result(:,1:ThkColN-1) = data(:,1:ThkColN-1);
Result(:,ThkColN:ThkColN+2) = FatigLife';
OutputName = [path0,ItrNo,'\',strBatch,'\','TmFatigue\','S1or2\',LineNo,'_',PartName,'_',TorB,'_','S1or2.csv'];
csvwrite(OutputName,Result)

end