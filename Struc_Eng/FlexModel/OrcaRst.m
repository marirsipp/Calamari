function[rst,disp] = OrcaRst(path_orca,output_time)

cd(path_orca)

H_Col2 = 29;
L_LMB = 52.7;
% output_time = 99;
row_Col2 = [2 66];
row_LMB = [67 138];

fnames = dir('*wall*');
wall = importdata(fnames.name);
fnames = dir('*x-Bend*');
xbend = importdata(fnames.name);
fnames = dir('*y-Bend*');
ybend = importdata(fnames.name);
fnames = dir('*x-Shear*');
xshear = importdata(fnames.name);
fnames = dir('*y-Shear*');
yshear = importdata(fnames.name);
fnames = dir('*X.csv*');
X = importdata(fnames.name);
fnames = dir('*Y.csv*');
Y = importdata(fnames.name);
fnames = dir('*Z.csv*');
Z = importdata(fnames.name);

time = wall.data(1,:);
output_col = find(time==output_time);

%Column results
for row = row_Col2(1):row_Col2(2)
    arc1(row-(row_Col2(1)-1))=str2double(wall.textdata{row,2});
end
rst.Col2(:,1) = H_Col2 - arc1';
rst.Col2(:,2:4) = [wall.data(row_Col2(1):row_Col2(2),output_col),-yshear.data(row_Col2(1):row_Col2(2),output_col),-xbend.data(row_Col2(1):row_Col2(2),output_col)];
disp.Col2(:,1) = rst.Col2(:,1);
disp.Col2(:,2:4) = [X.data(row_Col2(1):row_Col2(2),output_col),Y.data(row_Col2(1):row_Col2(2),output_col),Z.data(row_Col2(1):row_Col2(2),output_col)];

%LMB results
for row = row_LMB(1):row_LMB(2)
    arc2(row-(row_LMB(1)-1))=str2double(wall.textdata{row,2});
end
rst.LMB(:,1) = L_LMB - arc2';
rst.LMB(:,2:4) = [wall.data(row_LMB(1):row_LMB(2),output_col),-xshear.data(row_LMB(1):row_LMB(2),output_col),ybend.data(row_LMB(1):row_LMB(2),output_col)];
disp.LMB(:,1) = rst.LMB(:,1);
disp.LMB(:,2:4) = [X.data(row_LMB(1):row_LMB(2),output_col),Y.data(row_LMB(1):row_LMB(2),output_col),Z.data(row_LMB(1):row_LMB(2),output_col)];
end
