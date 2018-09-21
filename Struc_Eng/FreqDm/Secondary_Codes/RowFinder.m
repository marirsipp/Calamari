function[RowNo]=RowFinder(path,GroupName,ElemNo,Life,TorB)
%Find the row number for a given element in the group result files
%Input
%path      - path where group result file (e.g. Truss_CG1.csv) is stored
%GroupName - name of result groups (e.g. Truss_CG1, IS_CG2, etc..)
%ElemNo    - element number, approximate when reaches 6-digit (ANSYS output
%            problem)
%Life      - fatigue life of the input element
%TorB      - Top or bottom surface, 'Top' or 'Btm'.

%-----------Test input--------------
% path0 ='C:\Users\Ansys\Documents\MATLAB\FreqDomain\'; 
% ItrNo = 'Itr13_5';
% path = [path0 ItrNo '\Results\'];
% GroupName = 'Truss_CG1';
% ElemNo = 172430;
% Life = 355.86;
% TorB = 'Top';
%-----------Test input--------------

tolerance = 0.001;
StrFile = [path GroupName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1}); %Col1 to 6: ElemNo, x, y, z, Life_Top, Life_Btm
    RowNo = find(StrData(:,1)==ElemNo);
else
    StrFile = [path GroupName '.csv'];
    StrData = importdata(StrFile);
    
    if ElemNo <1e5
        RowNo = find(StrData(:,1)==ElemNo);
    else
        RowNo1 = find(StrData(:,1)==ElemNo);
        if strcmp(TorB,'Top')
            a = find( Life-tolerance < StrData(RowNo1(:),5) & StrData(RowNo1(:),5) < Life+tolerance);
            RowNo = RowNo1(a);
        elseif strcmp(TorB,'Btm')
            a = find( Life-tolerance < StrData(RowNo1(:),6) & StrData(RowNo1(:),6) < Life+tolerance);
            RowNo = RowNo1(a);
        end
    end
end
end