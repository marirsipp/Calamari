function[] = BuildStrMtrx_Gen(path_norm, path_str, LineNo, PartName, TorB, Thk, axisTT)

%Create stress matrix for a certain connection from directional stress
%output from ANSYS
%Input:
%path_norm - path where normal stresses output from ANSYS are stored
%path_str  - path for outputing stress matrix
%LineNo    - connection number
%PartName  - connecting member name
%TorB      - Top or bottom surface where the stresses are output
%Thk       - member thickness, mm
%axisTT    - through-thickness axis, corresponding stress close to 0
%SN        - SN curve for the current connection

fileFx = [path_norm, LineNo,'_',PartName,'_',TorB,'_Fx','.csv'];
fileFy = [path_norm, LineNo,'_',PartName,'_',TorB,'_Fy','.csv'];
fileFz = [path_norm, LineNo,'_',PartName,'_',TorB,'_Fz','.csv'];

fileMx = [path_norm, LineNo,'_',PartName,'_',TorB,'_Mx','.csv'];
fileMy = [path_norm, LineNo,'_',PartName,'_',TorB,'_My','.csv'];
fileMz = [path_norm, LineNo,'_',PartName,'_',TorB,'_Mz','.csv'];

rstFx = importdata(fileFx);
rstFy = importdata(fileFy);
rstFz = importdata(fileFz);
rstMx = importdata(fileMx);
rstMy = importdata(fileMy);
rstMz = importdata(fileMz);

Nnode = size(rstFx.data,1); 
StrMtx(:,1:4) = rstFx.data(:,1:4); %Node number, x-coord, y-coord, z-coord
StrMtx(:,5) = Thk * ones(Nnode,1); %Thickness, mm

header = cell(1,23);
header(1:4) = rstFx.textdata(1:4);
header{5} = 'thk(mm)';

if strcmp(axisTT,'x')
    StrCol = [6,7,9]; %Column number for S_Y, S_Z, S_YZ
    header(6:8)   = {'Sy_Fx','Sz_Fx','Syz_Fx'};
    header(9:11)  = {'Sy_Fy','Sz_Fy','Syz_Fy'};
    header(12:14) = {'Sy_Fz','Sz_Fz','Syz_Fz'};
    header(15:17) = {'Sy_Mx','Sz_Mx','Syz_Mx'};
    header(18:20) = {'Sy_My','Sz_My','Syz_My'};
    header(21:23) = {'Sy_Mz','Sz_Mz','Syz_Mz'};
elseif strcmp(axisTT,'y')
    StrCol = [5,7,10]; %Column number for S_X, S_Z, S_XZ
    header(6:8)   = {'Sx_Fx','Sz_Fx','Sxz_Fx'};
    header(9:11)  = {'Sx_Fy','Sz_Fy','Sxz_Fy'};
    header(12:14) = {'Sx_Fz','Sz_Fz','Sxz_Fz'};
    header(15:17) = {'Sx_Mx','Sz_Mx','Sxz_Mx'};
    header(18:20) = {'Sx_My','Sz_My','Sxz_My'};
    header(21:23) = {'Sx_Mz','Sz_Mz','Sxz_Mz'};
elseif strcmp(axisTT,'z')
    StrCol = [5,6,8]; %Column number for S_X, S_Y, S_XY
    header(6:8)   = {'Sx_Fx','Sy_Fx','Sxy_Fx'};
    header(9:11)  = {'Sx_Fy','Sy_Fy','Sxy_Fy'};
    header(12:14) = {'Sx_Fz','Sy_Fz','Sxy_Fz'};
    header(15:17) = {'Sx_Mx','Sy_Mx','Sxy_Mx'};
    header(18:20) = {'Sx_My','Sy_My','Sxy_My'};
    header(21:23) = {'Sx_Mz','Sy_Mz','Sxy_Mz'};
else
    disp('Check input for through thickness axis')
end

StrMtx(:,6:8) = rstFx.data(:,StrCol); 
StrMtx(:,9:11) = rstFy.data(:,StrCol);
StrMtx(:,12:14) = rstFz.data(:,StrCol);
StrMtx(:,15:17) = rstMx.data(:,StrCol); 
StrMtx(:,18:20) = rstMy.data(:,StrCol);
StrMtx(:,21:23) = rstMz.data(:,StrCol);

OutputFile = [path_str,'StrMtx_',LineNo,'_',PartName,'_',TorB,'.csv'];
format1 = ['%8s',',', repmat(['%6s',','],1,3), '%7s', repmat([',','%5s',',','%5s',',','%6s'],1,6),'\n'];
format2 = ['%10.0f', repmat([',','%10.3f'],1,3), ',', '%6.1f', repmat([',','%10.6f'],1,18),'\n'];
fid = fopen(OutputFile,'w');
fprintf(fid,format1, header{1:23});
for n=1:Nnode
    fprintf(fid,format2, StrMtx(n,:));
end
fclose(fid);
end