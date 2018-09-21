function[] = DispPressure(Itr, path_load, Head, Period, RorI, units, scale)
%Plot frequency domain pressure distribution on WEP and OS
%Need to put element location file in path_load

%Inputs:
% path0 = 'D:\Bingbin\Models\@Round5_WFA\Itr13_NewModel_FreqDm\';
% Itr = 'Itr16_0_LMB'; %Iteration name
% LoadDate = 'Apr21';
% path_load = [path0 '\Loads_' LoadDate '2017\'];
% Head = 0; %Wave heading, deg
% Period = 6; %Wave period, s
% RorI = 'imag'; %Real or imaginary, 'real' or 'imag'
% units.stress = 'Pa';
% units.length = 'm';
% scale = 100; %Scale of the loads when applied to structural model: scale = load_ansys/load_mm

ElemFile = 'ElemLoc_OSWEP.csv'; %Element location file
z0 = -18000; %mm, z value of keel

%Units
unit1 = units.stress; %Stress output unit, 'Pa' - stress in Pa, length in meter; 'MPa' - stress in MPa, length in mm
unit2 = units.length; %Length unit in ElemFile

% path1 = [path0 DampFolder '\Run' num2str(Head) '\Period' num2str(Period)];
path1 = [path_load '\Run' num2str(Head) '\Period' num2str(Period)];

ElemFile1 = [path_load ElemFile];
TotalPrezFile = [path1 '\' Itr '_' RorI '.dat']; %Total pressure
HydroPrezFile = [path1 '\' Itr '_' RorI '.phyd']; %Hydrodynamic pressure
RadPrezFile = [path1 '\' Itr '_' RorI '.prad']; %Radiation pressure
DiffPrezFile = [path1 '\' Itr '_' RorI '.pdif']; %Diffraction pressure

ElemLoc = importdata(ElemFile1);
% DampPrez = xlsread(DampFile1,DampFile,sprintf('F%d:F%d',RowStart,RowEnd));
% NoDampPrez = xlsread(NoDampFile1,NoDampFile,sprintf('F%d:F%d',RowStart,RowEnd));        
% RadPrez = xlsread(DampFile1,DampFile,sprintf('F%d:F%d',RowStart,RowEnd));

data1 = importfile(TotalPrezFile,14,2);
data2 = importfile(HydroPrezFile,3,2);
data3 = importfile(RadPrezFile,3,2);
data4 = importfile(DiffPrezFile,3,2);

if strcmp(unit2,'m')
    result = ElemLoc.data*1000; %convert to mm
elseif strcmp(unit2,'mm')
    result = ElemLoc.data; 
end

if strcmp(unit1,'Pa')
    result(:,5) = data1/ 10^6 * scale; %convert to MPa
    result(:,6) = data2/ 10^6;
    result(:,7) = data3/ 10^6;
    result(:,8) = data4/ 10^6;
elseif strcmp(unit1,'MPa')
    result(:,5) = data1 * scale; %convert to MPa
    result(:,6) = data2;
    result(:,7) = data3;
    result(:,8) = data4;
end

data1=[];
data2=[];
data3=[];
data4=[];

ElemNo = size(result,1);
%%
Ind_WEP=find(result(:,4)==z0);
WEP=result(Ind_WEP,:);

Ind_OS=find(result(:,4)>=z0+200);
OS=result(Ind_OS,:);

% m = 1;
% n = 1;
% 
% for i = 1:ElemNo
%     if result(i,4) == z0
%         WEP(m,:) = result(i,:);
%         m = m+1;
%     elseif result(i,4) >= z0+200
%         OS(n,:) = result(i,:);
%         n = n+1;
%     end
% end
%%
figure(1)
scatter(WEP(:,2),WEP(:,3),10,WEP(:,5),'filled')
axis equal
colorbar
title({'Total Pressure (MPa)';['Run' num2str(Head) 'T' num2str(Period) '\_' RorI ]})
hgsave([path1 '\' 'Total_' 'WEP_' RorI])

figure(2)
scatter(WEP(:,2),WEP(:,3),10,WEP(:,6),'filled')
axis equal
colorbar
title({'Hydrostatic Pressure (MPa)';['Run' num2str(Head) 'T' num2str(Period) '\_' RorI ]})
hgsave([path1 '\' 'Hydro_' 'WEP_' RorI])

figure(3)
scatter(WEP(:,2),WEP(:,3),10,WEP(:,7),'filled')
axis equal
colorbar
title({'Radiation Pressure (MPa)';['Run' num2str(Head) 'T' num2str(Period) '\_' RorI ]})
hgsave([path1 '\' 'Rad_' 'WEP_' RorI])

figure(4)
scatter(WEP(:,2),WEP(:,3),10,WEP(:,8),'filled')
axis equal
colorbar
title({'Diffraction Pressure (MPa)';['Run' num2str(Head) 'T' num2str(Period) '\_' RorI ]})
hgsave([path1 '\' 'Diff_' 'WEP_' RorI])
%%
figure(5)
scatter3(OS(:,2),OS(:,3),OS(:,4),10,OS(:,5),'filled')
axis equal
colorbar
title({'Total Pressure (MPa)';['Run' num2str(Head) 'T' num2str(Period) '\_' RorI ]})
hgsave([path1 '\' 'Total_' 'OS_' RorI])

figure(6)
scatter3(OS(:,2),OS(:,3),OS(:,4),10,OS(:,6),'filled')
axis equal
colorbar
title({'Hydrostatic Pressure (MPa)';['Run' num2str(Head) 'T' num2str(Period) '\_' RorI ]})
hgsave([path1 '\' 'Hydro_' 'OS_' RorI])

figure(7)
scatter3(OS(:,2),OS(:,3),OS(:,4),10,OS(:,7),'filled')
axis equal
colorbar
title({'Radiation Pressure (MPa)';['Run' num2str(Head) 'T' num2str(Period) '\_' RorI ]})
hgsave([path1 '\' 'Rad_' 'OS_' RorI])

figure(8)
scatter3(OS(:,2),OS(:,3),OS(:,4),10,OS(:,8),'filled')
axis equal
colorbar
title({'Diffraction Pressure (MPa)';['Run' num2str(Head) 'T' num2str(Period) '\_' RorI ]})
hgsave([path1 '\' 'Diff_' 'OS_' RorI])

tilefigs
end