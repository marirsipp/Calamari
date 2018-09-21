function[] = FatigueResultSummary(path1, GroupName)
%Summarize fatigue life results from frequency domain screening
%Recording connection name, worst fatigue life, worst element
%number, worst element row number for both top and bottom surface

%Input
% path0 ='C:\Users\Ansys.000\Documents\MATLAB\FreqDomain\'; 
% ItrNo = 'Itr13_10_NewLoad';
% path1 = [path0 ItrNo '\Results_Mthd3\'];
% GroupName = 'Truss_CG1';

ResultFile = [path1 'Fatigue_Life_' GroupName '.mat'];
load(ResultFile)
Sum1 = [];
Sum1{1,1} = 'Cnnt_Name'; %Result header
Sum1{1,2} = 'SN_Curve';
Sum1{1,3} = 'Act_Thk'; %Actual thickness of the part
Sum1{1,4} = 'Life_Top';
Sum1{1,5} = 'Elem_Top';
Sum1{1,6} = 'Row_Top';
Sum1{1,7} = 'Life_Btm';
Sum1{1,8} = 'Elem_Btm';
Sum1{1,9} = 'Row_Btm';

CnntNo = size(Result,2);
m=1;
for n=1:CnntNo
    if ~isempty(Result{n})
        Sum1{m+1,1}=Result{n}.Connection;
        Sum1{m+1,2}=Result{n}.SNcurve;
        Sum1{m+1,3}=Result{n}.Thk;
        Sum1{m+1,4}=Result{n}.Top.Life;
        Sum1{m+1,5}=Result{n}.Top.Elem;
        Sum1{m+1,6}=Result{n}.Top.ElemRow;
        Sum1{m+1,7}=Result{n}.Btm.Life;
        Sum1{m+1,8}=Result{n}.Btm.Elem;
        Sum1{m+1,9}=Result{n}.Btm.ElemRow;
        m=m+1;
    end
end

OutFile = [path1 GroupName '_Summary.xls'];
xlswrite(OutFile,Sum1)
end