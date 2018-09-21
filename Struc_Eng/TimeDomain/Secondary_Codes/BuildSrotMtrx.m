function[] = BuildSrotMtrx(path_norm, path_str, CnntName, Thk, axisTT, StrDir, Loads, LoadValues)

%Create rotated stress matrix for a certain connection from directional 
%stress output from ANSYS, only for Mx and My case
%Input:
%path_norm - path where normal stresses output from ANSYS are stored
%path_str  - path for outputing stress matrix
%CnntName  - connection name, composed by LineNo_PartName_TorB, e.g. L13_FB1_Btm
%            LineNo - connection number
%            PartName - connecting member name
%            TorB - Top or bottom surface where the stresses are output
%Thk       - member thickness, mm
%axisTT    - through-thickness axis, corresponding stress close to 0
%StrDir    - Desired stress direction, degree

[flag,indFx] = ismember('Fx',Loads);
[flag,indFy] = ismember('Fy',Loads);
[flag,indMx] = ismember('Mx',Loads);
[flag,indMy] = ismember('My',Loads);

fileFx = [path_norm, CnntName,'_Fx','.csv'];
fileFy = [path_norm, CnntName,'_Fy','.csv'];
fileMx = [path_norm, CnntName,'_Mx','.csv'];
fileMy = [path_norm, CnntName,'_My','.csv'];

rstFx = importdata(fileFx);
rstFy = importdata(fileFy);
rstMx = importdata(fileMx);
rstMy = importdata(fileMy);

Nnode = size(rstMx.data,1); 
SrotMtx(:,1:4) = rstMx.data(:,1:4); %Node number, x-coord, y-coord, z-coord
SrotMtx(:,5) = Thk * ones(Nnode,1); %Thickness, mm

Ntheta = length(StrDir);
header = cell(1,5+Ntheta*4);
header(1:4) = rstMx.textdata(1:4);
header{5} = 'thk(mm)';

for k = 1:Ntheta
    if StrDir(k)<10;
        angle{k} = ['00' num2str(StrDir(k))];
    elseif StrDir(k)<100;
        angle{k} = ['0' num2str(StrDir(k))];
    else
        angle{k} = num2str(StrDir(k));
    end
    header(5+(k-1)*4+1) = {['S' angle{k} '_Fx(MPa)']};
    header(5+(k-1)*4+2) = {['S' angle{k} '_Fy(MPa)']};
    header(5+(k-1)*4+3) = {['S' angle{k} '_Mx(MPa)']};
    header(5+(k-1)*4+4) = {['S' angle{k} '_My(MPa)']};
end

if strcmp(axisTT,'x')
    StrCol = [6,7,9]; %Column number for S_Y, S_Z, S_YZ
elseif strcmp(axisTT,'y')
    StrCol = [5,7,10]; %Column number for S_X, S_Z, S_XZ
elseif strcmp(axisTT,'z')
    StrCol = [5,6,8]; %Column number for S_X, S_Y, S_XY
else
    disp('Check input for through thickness axis')
end

%Stress matrix due to unit loading (1kN or 1kNm)
StrMtx_Fx = rstFx.data(:,StrCol)/LoadValues(indFx); 
StrMtx_Fy = rstFy.data(:,StrCol)/LoadValues(indFy);
StrMtx_Mx = rstMx.data(:,StrCol)/LoadValues(indMx);
StrMtx_My = rstMy.data(:,StrCol)/LoadValues(indMy);

for n = 1:Ntheta
    SrotMtx(:,5+(n-1)*4+1) = RotateStress(StrMtx_Fx(:,1),StrMtx_Fx(:,2),StrMtx_Fx(:,3),StrDir(n));
    SrotMtx(:,5+(n-1)*4+2) = RotateStress(StrMtx_Fy(:,1),StrMtx_Fy(:,2),StrMtx_Fy(:,3),StrDir(n));
    SrotMtx(:,5+(n-1)*4+3) = RotateStress(StrMtx_Mx(:,1),StrMtx_Mx(:,2),StrMtx_Mx(:,3),StrDir(n));
    SrotMtx(:,5+(n-1)*4+4) = RotateStress(StrMtx_My(:,1),StrMtx_My(:,2),StrMtx_My(:,3),StrDir(n));
end

OutputFile = [path_str,'SrotMtx_',CnntName,'.csv'];
format1 = ['%8s',',', repmat(['%6s',','],1,3), '%7s', repmat([',','%12s'],1,Ntheta*4),'\n'];
format2 = ['%10.0f', repmat([',','%10.3f'],1,3), ',', '%6.1f', repmat([',','%10.6e'],1,Ntheta*4),'\n'];
fid = fopen(OutputFile,'w');
fprintf(fid,format1, header{1:5+Ntheta*4});
for n=1:Nnode
    fprintf(fid,format2, SrotMtx(n,:));
end
fclose(fid);

end