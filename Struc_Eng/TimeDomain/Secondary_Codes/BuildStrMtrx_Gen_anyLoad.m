function[] = BuildStrMtrx_Gen_anyLoad(path_norm, path_str, LineNo, PartName, TorB, Thk, axisTT,Loads, StrScale)

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
%Loads     - {'Fx';'Fy';'Fz';'Mx';'My';'Mz'} or {'Fx1';'Fx2';'Fy1';'Fy2';'Fz1';'Fz2'}

for i = 1:length(Loads)
    % Get files names for each load of that connection
    files.(Loads{i}) = [path_norm, LineNo,'_',PartName,'_',TorB,['_' Loads{i}],'.csv'];
    % Load file
    rst.(Loads{i})  = importdata(files.(Loads{i}));
end

Nnode = size(rst.(Loads{1}).data,1); 
StrMtx(:,1:4) = rst.(Loads{1}).data(:,1:4); %Node number, x-coord, y-coord, z-coord
StrMtx(:,5) = Thk * ones(Nnode,1); %Thickness, mm

header = cell(1,23);
header(1:4) = rst.(Loads{1}).textdata(1:4);
header{5} = 'thk(mm)';

% Create matrix headers
if strcmp(axisTT,'x') % if through-thickness is x, then keep Y, Z and YZ
    StrCol = [6,7,9]; %Column number for S_Y, S_Z, S_YZ
    for i = 1:length(Loads)
    header(6+(i-1)*3:6+(i-1)*3+2)   = {['Sy_' Loads{i}],['Sz_' Loads{i}],['Syz_' Loads{i}]};
    end
elseif strcmp(axisTT,'y') % if through-thickness is y, then keep X, Z and XZ
    StrCol = [5,7,10]; %Column number for S_X, S_Z, S_XZ
    for i = 1:length(Loads)
    header(6+(i-1)*3:6+(i-1)*3+2)   = {['Sx_' Loads{i}],['Sz_' Loads{i}],['Sxz_' Loads{i}]};
    end
elseif strcmp(axisTT,'z') % if through-thickness is z, then keep X, Y and XY
    StrCol = [5,6,8]; %Column number for S_X, S_Y, S_XY
    for i = 1:length(Loads)
    header(6+(i-1)*3:6+(i-1)*3+2)   = {['Sx_' Loads{i}],['Sy_' Loads{i}],['Sxy_' Loads{i}]};
    end
else
    disp('Check input for through thickness axis')
end

% Keep data for stress matrix
for i = 1:length(Loads)
    StrMtx(:,6+(i-1)*3:6+(i-1)*3+2) = rst.(Loads{i}).data(:,StrCol)*StrScale.(Loads{i}); 
end

% output csv file
OutputFile = [path_str,'StrMtx_',LineNo,'_',PartName,'_',TorB,'.csv'];
format1 = ['%8s',',', repmat(['%6s',','],1,3), '%7s', repmat([',','%5s',',','%5s',',','%6s'],1,6),'\n'];
format2 = ['%10.0f', repmat([',','%10.3f'],1,3), ',', '%6.1f', repmat([',','%10.6e'],1,18),'\n'];
fid = fopen(OutputFile,'w');
fprintf(fid,format1, header{1:23}); % header writter in file
for n=1:Nnode % same format than previously: pne line per node, each with its stress matrix
    fprintf(fid,format2, StrMtx(n,:));
end
fclose(fid);
end