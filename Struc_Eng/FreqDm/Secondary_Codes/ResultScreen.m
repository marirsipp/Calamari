function[Result] = ResultScreen(path,GroupData,Cnntdata,GroupName,SN,thk,target)
%Reads and screen elements that have life smaller than target for each 
%connection, the element id and row number of each element in group result 
%file are stored
%Input:
%path - path where group result file (e.g. Truss_CG1.csv/.mat) is stored
%GroupData - fatigue result data of the group (e.g. Truss_CG1)
%CnntData - fatigue result data of the connection (e.g. LMB12 mid)
%data format - 1st column, element number
%     - 2nd column, x value (mm) of element centroid
%     - 3rd column, y value (mm) of element centroid
%     - 4th column, z value (mm) of element centroid
%     - 5th column, fatigue life on element top surface (year)
%     - 6th column, fatigue life on element bottom surface (year)
%GroupName - Name of the group
%SN - Name of the S-N curve
%thk - thickness (mm)
%target - target fatigue life (year)

rst_top = Cnntdata(Cnntdata(:,5)<target,:);
rst_btm = Cnntdata(Cnntdata(:,6)<target,:);

if ~isempty(rst_top)
    [rf1,row_top] = ismember(rst_top(:,1),GroupData(:,1));
    rf2 = ismember(GroupData(:,1),rst_top(:,1));
    if nnz(rf1) ~= nnz(rf2) %if there are repeating element numbers in the group data 
        N_elem = size(rst_top,1);
        row_top = zeros(N_elem,1);
        for nn = 1:N_elem
            ElemNo = rst_top(nn,1);
            Life = rst_top(nn,5);
            row_top(nn,1) = RowFinder(path,GroupName,ElemNo,Life,'Top');
        end
    end
    Result.Top.Life = rst_top(:,5);
    Result.Top.Loc = rst_top(:,2:4);
    Result.Top.Elem =  rst_top(:,1);
    Result.Top.ElemRow = row_top;
else
    Result.Top = [];
end
if ~isempty(rst_btm)
    [rf1,row_btm] = ismember(rst_btm(:,1),GroupData(:,1));
    rf2 = ismember(GroupData(:,1),rst_btm(:,1));
    if nnz(rf1) ~= nnz(rf2)
        N_elem = size(rst_btm,1);
        row_btm = zeros(N_elem,1);
        for nn = 1:N_elem
            ElemNo = rst_btm(nn,1);
            Life = rst_btm(nn,5);
            row_btm(nn,1) = RowFinder(path,GroupName,ElemNo,Life,'Btm');
        end
    end
    Result.Btm.Life = rst_btm(:,6);
    Result.Btm.Loc = rst_btm(:,2:4);
    Result.Btm.Elem =  rst_btm(:,1);
    Result.Btm.ElemRow = row_btm;
else
    Result.Btm = [];
end

Result.SNcurve = SN;
Result.Thk = thk;
end