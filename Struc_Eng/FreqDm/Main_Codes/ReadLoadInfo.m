function[Result] = ReadLoadInfo(path_load,Itr,Heading,Line_Acel,Line_FM)
%Read frequency domain load info: applied acceleration and total
%force/moment

%Path for pressure load folder
% path0 = 'D:\Bingbin\Models\@Round5_WFA\Itr13_NewModel_FreqDm\';
% Itr = 'Itr13_6'; %Iteration name
% LoadDate = 'Jul06';
% Heading = 'Run240'; %Wave heading, deg
% Line_Acel - no. of line in the .info file where the acceleration is listed
% Line_FM - no. of line in the .info file where the force and moment are listed

if ~exist('Line_Acel','var')
    Line_Acel = 9; %based on the current(Oct,2017)format
end
if ~exist('Line_FM','var')
    Line_FM = 24; %based on the current(Oct,2017)format, f/m using ANSYS area
end

T_start = 3; %Starting wave period, s
T_end = 30; %Ending wave period, s

%Header
accel_header = {'Ax_real','Ay_real','Az_real','Rx,real','Ry_real','Rz_real', ...
    'Ax_imag','Ay_imag','Az_imag','Rx_imag','Ry_imag','Rz_imag'};
accel_unit = [repmat({'[m/s^2]'},[1,3]),repmat({'[rad/s^2]'},[1,3]),repmat({'[m/s^2]'},[1,3]),repmat({'[rad/s^2]'},[1,3])];
force_header = {'Fx_real','Fy_real','Fz_real','Mx,real','My_real','Mz_real', ...
    'Fx_imag','Fy_imag','Fz_imag','Mx_imag','My_imag','Mz_imag'};
force_unit = [repmat({'[kN]'},[1,3]),repmat({'[kN-m]'},[1,3]),repmat({'[kN]'},[1,3]),repmat({'[kN-m]'},[1,3])];

%path_load = [path0 'Loads_' LoadDate '2016\'];
file_real = ['Run' Itr '_real.info'];
file_imag = ['Run' Itr '_imag.info'];
T = T_start:1:T_end;

for n = 1:length(T)
    path_file = [path_load '\' Heading '\Period' num2str(T(n))];
    cd(path_file)
    
    fid = fopen(file_real);
    LineNo = 1;
    while ~feof(fid)
        tline = fgets(fid);
        if LineNo == Line_Acel % Line_Acel = 9 for current format
            [A1 A2 A3 A4 A5 A6] = strread(tline,'%f %f %f %f %f %f');
            A_real(n,:) = [A1 A2 A3 A4 A5 A6]; %m/s^2, rad/s^2
        elseif LineNo == Line_FM % Line_FM = 24 for current format
            [F1 F2 F3 F4 F5 F6] = strread(tline,'%f %f %f %f %f %f');
            F_real(n,:) = [F1 F2 F3 F4 F5 F6]/1000; %kN, kNm
        end
        LineNo = LineNo + 1;
    end
    fclose(fid);
    
    fid = fopen(file_imag);
    LineNo = 1;
    while ~feof(fid)
        tline = fgets(fid);
        if LineNo == Line_Acel
            [A1 A2 A3 A4 A5 A6] = strread(tline,'%f %f %f %f %f %f');
            A_imag(n,:) = [A1 A2 A3 A4 A5 A6]; %m/s^2, rad/s^2
        elseif LineNo == Line_FM
            [F1 F2 F3 F4 F5 F6] = strread(tline,'%f %f %f %f %f %f');
            F_imag(n,:) = [F1 F2 F3 F4 F5 F6]/1000; %kN, kNm
        end
        LineNo = LineNo + 1;
    end
    fclose(fid);
end

Accel = [A_real,A_imag];
Force = [F_real,F_imag]*1000; %N, Nm

Result.info.periods = {'Wave periods';'[s]'};
Result.info.accel = [accel_header; accel_unit];
Result.info.force = [force_header; force_unit];

Result.periods = T';
Result.accel = Accel;
Result.force = Force;
end
