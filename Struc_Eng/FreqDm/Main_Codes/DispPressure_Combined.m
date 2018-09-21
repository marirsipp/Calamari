clc
close all
clear all

%Path for pressure load folder
path0 = 'D:\Bingbin\Models\@Round5_WFA\Itr13_NewModel_FreqDm\';
Itr = 'Itr13_10'; %Iteration name
LoadDate = 'Apr10';

path_load = [path0 '\Loads_' LoadDate '2017\'];

Head = 90; %Wave heading, deg
Period = 3; %Wave period, s

ElemFile = 'ElemLoc_OSWEP.csv'; %Element location file
z0 = -18000; %mm, z value of keel

%Units
unit1 = 'Pa'; %Stress output unit, 'Pa' - stress in Pa, length in meter; 'MPa' - stress in MPa, length in mm
unit2 = 'mm';
scale = 100;

% path1 = [path0 DampFolder '\Run' num2str(Head) '\Period' num2str(Period)];
path1 = [path_load '\Run' num2str(Head) '\Period' num2str(Period)];

ElemFile1 = [path_load ElemFile];

RorI = 'real';
TotalPrezFile1 = [path1 '\' Itr '_' RorI '.dat']; %Total pressure
HydroPrezFile1 = [path1 '\' Itr '_' RorI '.phyd']; %Hydrodynamic pressure
RadPrezFile1 = [path1 '\' Itr '_' RorI '.prad']; %Radiation pressure
DiffPrezFile1 = [path1 '\' Itr '_' RorI '.pdif']; %Diffraction pressure

RorI = 'imag';
TotalPrezFile2 = [path1 '\' Itr '_' RorI '.dat']; %Total pressure
HydroPrezFile2 = [path1 '\' Itr '_' RorI '.phyd']; %Hydrodynamic pressure
RadPrezFile2 = [path1 '\' Itr '_' RorI '.prad']; %Radiation pressure
DiffPrezFile2 = [path1 '\' Itr '_' RorI '.pdif']; %Diffraction pressure

ElemLoc = importdata(ElemFile1);
if strcmp(unit2,'m')
    result = ElemLoc.data*1000; %convert to mm
elseif strcmp(unit2,'mm')
    result = ElemLoc.data; 
end
ElemNo = size(result,1);

data1_real = importfile(TotalPrezFile1,14);
data1_imag = importfile(TotalPrezFile2,14);
data1 = (data1_real.^2 + data1_imag.^2).^0.5;
data1_real=[];
data1_imag=[];

data2_real = importfile(HydroPrezFile1,3);
data2_imag = importfile(HydroPrezFile2,3);
data2 = (data2_real.^2 + data2_imag.^2).^0.5;
data2_real=[];
data2_imag=[];

data3_real = importfile(RadPrezFile1,3);
data3_imag = importfile(RadPrezFile2,3);
data3 = (data3_real.^2 + data3_imag.^2).^0.5;
data3_real=[];
data3_imag=[];

data4_real = importfile(DiffPrezFile1,3);
data4_imag = importfile(DiffPrezFile2,3);
data4 = (data4_real.^2 + data4_imag.^2).^0.5;
data4_real=[];
data4_imag=[];

if strcmp(unit1,'Pa')
    result(:,5) = data1 / 10^6 * scale; %convert to MPa
    result(:,6) = data2;
    result(:,7) = data3;
    result(:,8) = data4;
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

%%
m = 1;
n = 1;

for i = 1:ElemNo
    if result(i,4) == z0
        WEP(m,:) = result(i,:);
        m = m+1;
    elseif result(i,4) >= z0+200
        OS(n,:) = result(i,:);
        n = n+1;
    end
end
%%
figure(1)
scatter(WEP(:,2),WEP(:,3),10,WEP(:,5),'filled')
axis equal
colorbar
title({'Total Pressure (MPa)';['Run' num2str(Head) 'T' num2str(Period) '\_' 'Combined' ]})
hgsave([path1 '\' 'Total_' 'WEP_' 'Combined'])

figure(2)
scatter(WEP(:,2),WEP(:,3),10,WEP(:,6),'filled')
axis equal
colorbar
title({'Hydrodynamic Pressure (MPa)';['Run' num2str(Head) 'T' num2str(Period) '\_' 'Combined' ]})
hgsave([path1 '\' 'Hydro_' 'WEP_' 'Combined'])

figure(3)
scatter(WEP(:,2),WEP(:,3),10,WEP(:,7),'filled')
axis equal
colorbar
title({'Radiation Pressure (MPa)';['Run' num2str(Head) 'T' num2str(Period) '\_' 'Combined' ]})
hgsave([path1 '\' 'Rad_' 'WEP_' 'Combined'])

figure(4)
scatter(WEP(:,2),WEP(:,3),10,WEP(:,8),'filled')
axis equal
colorbar
title({'Diffraction Pressure (MPa)';['Run' num2str(Head) 'T' num2str(Period) '\_' 'Combined' ]})
hgsave([path1 '\' 'Diff_' 'WEP_' 'Combined'])
%%
figure(5)
scatter3(OS(:,2),OS(:,3),OS(:,4),10,OS(:,5),'filled')
axis equal
colorbar
title({'Total Pressure (MPa)';['Run' num2str(Head) 'T' num2str(Period) '\_' 'Combined' ]})
hgsave([path1 '\' 'Total_' 'OS_' 'Combined'])

figure(6)
scatter3(OS(:,2),OS(:,3),OS(:,4),10,OS(:,6),'filled')
axis equal
colorbar
title({'Hydrodynamic Pressure (MPa)';['Run' num2str(Head) 'T' num2str(Period) '\_' 'Combined' ]})
hgsave([path1 '\' 'Hydro_' 'OS_' 'Combined'])

figure(7)
scatter3(OS(:,2),OS(:,3),OS(:,4),10,OS(:,7),'filled')
axis equal
colorbar
title({'Radiation Pressure (MPa)';['Run' num2str(Head) 'T' num2str(Period) '\_' 'Combined' ]})
hgsave([path1 '\' 'Rad_' 'OS_' 'Combined'])

figure(8)
scatter3(OS(:,2),OS(:,3),OS(:,4),10,OS(:,8),'filled')
axis equal
colorbar
title({'Diffraction Pressure (MPa)';['Run' num2str(Head) 'T' num2str(Period) '\_' 'Combined' ]})
hgsave([path1 '\' 'Diff_' 'OS_' 'Combined'])

% close all
