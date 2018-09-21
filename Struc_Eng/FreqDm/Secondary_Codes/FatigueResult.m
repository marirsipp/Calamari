function[Result] = FatigueResult(path,GroupName,data,CnntName,SN,thk)
%Reads and stores worst fatigue life results for each connection, element
%that has the worst connection and row number for that element
%Input:
%data - 1st column, element number
%     - 2nd column, x value (mm) of element centroid
%     - 3rd column, y value (mm) of element centroid
%     - 4th column, z value (mm) of element centroid
%     - 5th column, fatigue life on element top surface (year)
%     - 6th column, fatigue life on element bottom surface (year)
%CnntName - Name of the connection
%SN - Name of the S-N curve
%thk - thickness

[a1,ind1] = min(data(:,5));
elem1 = data(ind1,1);
[a2,ind2] = min(data(:,6));
elem2 = data(ind2,1);

Result.Connection = CnntName;
Result.Top.Life = a1;
Result.Top.Elem = elem1;
Result.Top.ElemRow = RowFinder(path,GroupName,elem1,a1,'Top');

Result.Btm.Life = a2;
Result.Btm.Elem = elem2;
Result.Btm.ElemRow = RowFinder(path,GroupName,elem2,a2,'Btm');

Result.SNcurve = SN;
Result.Thk = thk;
end