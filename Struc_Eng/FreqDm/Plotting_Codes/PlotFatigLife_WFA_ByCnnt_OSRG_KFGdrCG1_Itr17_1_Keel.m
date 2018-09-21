clc 
% clear all

%Plat fatigue life results for connections

%Input
path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr_17_2_Keel';
path1 = [path0 ItrNo '\Results_Mthd6\'];
% path1 = [path0 ItrNo '\Results\ABS\'];
% path1 = [path0 ItrNo '\Results\DNV\'];
% path1 = [path0 ItrNo '\Results\Mar11\'];

%Thickness info, in mm
ThkFile = [path0 ItrNo '\' 'thickness.mat'];
load(ThkFile)

%Geometry parameters, in mm
Ctr_Col1 = [30426, 0, -18000];
Ctr_Col2 = [-15214, 26350, -18000];
Ctr_Col3 = [-15214, -26350, -18000];

ColSpace = 52700;

Z_Keel = -18000; %Measured from free surface
EL_Top = 29000;
EL_PlfmBtm = 6000;
EL_LMBbtm = 800;
EL_UMBtop = 28500;
EL_KeelGdr = 1250;

R_IS_C1 = 3250;
R_IS_C2 = 2250;
R_OS_C1 = 6000;
R_OS_C2 = 5750;
R_LMB = 1100;
R_UMB = 900;
R_Ring_C2 = R_IS_C2 - 500;
R_KFCirGdr_C1 = 1000;
R_KFCirGdr_C2 = 1000;

L_LMBmidcan = 10000;
L_LMBcolcan = 8000; %Approximate number
L_UMBcolcan = 10000; %Approximate number
L_VBcolcan = 9500; %Approximate number
L_VBmidcan = 3900; %Approximate number
L_LMBring = 2400; %Approximate, Offset of LMB rings from the center of LMBmid can
L_LMBtoering = 2800;

L_VBtotal = sqrt((EL_UMBtop-R_UMB-EL_LMBbtm-R_LMB)^2 + (ColSpace/2)^2);
L_VB = 23367;
L_VBcolcan1 = 9544.7; %Exact number
L_VBmidcan1 = L_VBtotal-L_VB-L_VBcolcan1; %Exact number

XBound = [40238, 0, -25026]; %Maximum x value of the model, platform center, minimum x value
YBound = [37680, 0, -37680]; %Maximum y value of the platform, platform center, minimum y value
ZBound = [12000, 0, -18000]; %Maximum z value of the platform, platform center, minimum z value

TrussCtr_Col1 = [Ctr_Col1(1), Ctr_Col1(2), Z_Keel+EL_UMBtop-R_UMB];
TrussCtr_Col2 = [Ctr_Col2(1), Ctr_Col2(2), Z_Keel+EL_UMBtop-R_UMB];
TrussCtr_Col3 = [Ctr_Col3(1), Ctr_Col3(2), Z_Keel+EL_UMBtop-R_UMB];

KJnt12_Ctr = 0.5*(Ctr_Col1 + Ctr_Col2) + [0,0, EL_LMBbtm + R_LMB];
KJnt13_Ctr = 0.5*(Ctr_Col1 + Ctr_Col3) + [0,0, EL_LMBbtm + R_LMB];
KJnt23_Ctr = 0.5*(Ctr_Col2 + Ctr_Col3) + [0,0, EL_LMBbtm + R_LMB];

DotSize = 50;
tolerance = 30;

%%
GroupName = 'OSRG_CG1';
path2 = [path1 GroupName '\'];
path3 = [path2 'Connection\'];
%%
PartName = 'OSRG Col1';
StrFile = [path2 PartName '.csv'];
StrData = importdata(StrFile);

CnntName = 'OSRG atTruss Col1';
PartThk = Thk.Col1.RGbtm; %Part thickness
n = 1;
SN = 'ABS_E_CP';
StrData(:,7) = cart2pol(StrData(:,2)-Ctr_Col1(1), StrData(:,3)-Ctr_Col1(2), StrData(:,4)); %Add angle in Col2 cylindrical coord sys
data1 = sort_angle (StrData, 130, 180);
data2 = sort_angle (StrData, -180, -130);
data3 = [data1;data2];

plot_TopBtm_FatigLife(data3,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data3, CnntName, SN, PartThk);
%%
CnntName = 'OSRGbk Col1';
PartThk = Thk.Col1.RGbtm; %Part thickness
n = 2;
SN = 'ABS_E_CP';
data4 = sort_angle (StrData, -130, 130);
plot_TopBtm_FatigLife(data4,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data4, CnntName, SN, PartThk);

data1 = [];
data2 = [];
data3 = [];
data4 = [];
%%
PartName = 'OSRG Col2';
StrFile = [path2 PartName '.csv'];
StrData = importdata(StrFile);

CnntName = 'OSRG atTruss Col2';
PartThk = Thk.Col2.RGbtm; %Part thickness
n = 3;
SN = 'ABS_E_CP';
StrData(:,7) = cart2pol(StrData(:,2)-Ctr_Col2(1), StrData(:,3)-Ctr_Col2(2), StrData(:,4)); %Add angle in Col2 cylindrical coord sys
data1 = sort_angle (StrData, -110, -10);

plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);
%%
CnntName = 'OSRGbk Col2';
PartThk = Thk.Col2.RGbtm; %Part thickness
n = 4;
SN = 'ABS_E_CP';
data2 = sort_angle (StrData, -180, -110);
data3 = sort_angle (StrData, -10, 180);
data4 = [data2;data3];

plot_TopBtm_FatigLife(data4,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data4, CnntName, SN, PartThk);

data1 = [];
data2 = [];
data3 = [];
data4 = [];
%%
PartName = 'OSRG Col3';
StrFile = [path2 PartName '.csv'];
StrData = importdata(StrFile);

CnntName = 'OSRG atTruss Col3';
PartThk = Thk.Col2.RGbtm; %Part thickness
n = 5;
SN = 'ABS_E_CP';
StrData(:,7) = cart2pol(StrData(:,2)-Ctr_Col3(1), StrData(:,3)-Ctr_Col3(2), StrData(:,4)); %Add angle in Col2 cylindrical coord sys
data1 = sort_angle (StrData, 10, 110);

plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);
%%
CnntName = 'OSRGbk Col3';
PartThk = Thk.Col2.RGbtm; %Part thickness
n = 6;
SN = 'ABS_E_CP';
data2 = sort_angle (StrData, -180, 10);
data3 = sort_angle (StrData, 110, 180);
data4 = [data2;data3];

plot_TopBtm_FatigLife(data4,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data4, CnntName, SN, PartThk);

data1 = [];
data2 = [];
data3 = [];
data4 = [];

%%
ResultFile = [path1 'Fatigue_Life_' GroupName '.mat'];
save(ResultFile,'Result')

%%
GroupName = 'KFGdr_CG1';
path2 = [path1 GroupName '\'];
path3 = [path2 'Connection\'];
%%
PartName = 'KFGdr Col1';
StrFile = [path2 PartName '.csv'];
StrData = importdata(StrFile);

CnntName = 'KF CirGdr Col1';
PartThk = Thk.Col1.KFCirc; %Part thickness
n = 1;
SN = 'ABS_E_Air';

data1 = sort_xydist (StrData, 0, R_KFCirGdr_C1+tolerance, Ctr_Col1(1), Ctr_Col1(2));

plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

CnntName = 'KFGdr In Col1';
PartThk = Thk.Col1.KFGdr; %Part thickness
n = 2;
SN = 'ABS_E_Air';

data1 = sort_xydist (StrData, R_KFCirGdr_C1+tolerance, R_IS_C1, Ctr_Col1(1), Ctr_Col1(2));

plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

CnntName = 'KFGdr Out Col1';
PartThk = Thk.Col1.KFGdr; %Part thickness
n = 3;
SN = 'ABS_E_CP';

data1 = sort_xydist (StrData, R_IS_C1, R_OS_C1+tolerance, Ctr_Col1(1), Ctr_Col1(2));

plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

%%
PartName = 'KFGdr Col2';
StrFile = [path2 PartName '.csv'];
StrData = importdata(StrFile);

CnntName = 'KF CirGdr Col2';
PartThk = Thk.Col2.KFCirc; %Part thickness
n = 4;
SN = 'ABS_E_Air';

data1 = sort_xydist (StrData, 0, R_KFCirGdr_C2+tolerance, Ctr_Col2(1), Ctr_Col2(2));

plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

CnntName = 'KFGdr In Col2';
PartThk = Thk.Col2.KFGdr; %Part thickness
n = 5;
SN = 'ABS_E_Air';

data1 = sort_xydist (StrData, R_KFCirGdr_C2+tolerance, R_IS_C2, Ctr_Col2(1), Ctr_Col2(2));

plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

CnntName = 'KFGdr Out Col2';
PartThk = Thk.Col2.KFGdr; %Part thickness
n = 6;
SN = 'ABS_E_CP';

data1 = sort_xydist (StrData, R_IS_C2, R_OS_C2+tolerance, Ctr_Col2(1), Ctr_Col2(2));

plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

%%
PartName = 'KFGdr Col3';
StrFile = [path2 PartName '.csv'];
StrData = importdata(StrFile);

CnntName = 'KF CirGdr Col3';
PartThk = Thk.Col2.KFCirc; %Part thickness
n = 7;
SN = 'ABS_E_Air';

data1 = sort_xydist (StrData, 0, R_KFCirGdr_C2+tolerance, Ctr_Col3(1), Ctr_Col3(2));

plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

CnntName = 'KFGdr In Col3';
PartThk = Thk.Col2.KFGdr; %Part thickness
n = 8;
SN = 'ABS_E_Air';

data1 = sort_xydist (StrData, R_KFCirGdr_C2+tolerance, R_IS_C2, Ctr_Col3(1), Ctr_Col3(2));

plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

CnntName = 'KFGdr Out Col3';
PartThk = Thk.Col2.KFGdr; %Part thickness
n = 9;
SN = 'ABS_E_CP';

data1 = sort_xydist (StrData, R_IS_C2, R_OS_C2+tolerance, Ctr_Col3(1), Ctr_Col3(2));

plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);
%%
GroupName = 'Gir_WEP_Col3';
StrFile = [path1 GroupName '.csv'];
StrData = importdata(StrFile);
data1 = sort_yval(StrData,min(YBound),0); %All LMBs
data1 = sort_xval(data1,min(XBound),0);
CnntName = 'Gir WEP Col3';
plot_TopBtm_FatigLife(data1,path1,CnntName,DotSize)
%%
GroupName = 'Keel_Flat';
StrFile = [path1 GroupName '.csv'];
StrData = importdata(StrFile);

Part504 = 'Flat keel Col1';
Str_part504 = sort_zval(StrData,Z_Keel,Z_Keel+tolerance1);
FatigLife5(4,:) = min(Str_part504(:,5:6));
plot2d_TopBtm_FatigLife (Str_part504,path1,Part504,40)

OutputName = [path1,Part504,'.csv'];
csvwrite(OutputName,Str_part504)

GroupName = 'Keel_Flat';
StrFile = [path1 GroupName '.csv'];
StrData = importdata(StrFile);

Part506 = 'Flat keel Col2';
Str_part506 = sort_zval(StrData,Z_Keel,Z_Keel+tolerance1);
FatigLife5(6,:) = min(Str_part506(:,5:6));
plot2d_TopBtm_FatigLife (Str_part506,path1,Part506,40)

OutputName = [path1,Part506,'.csv'];
csvwrite(OutputName,Str_part506)

GroupName = 'Keel_Flat';
StrFile = [path1 GroupName '.csv'];
StrData = importdata(StrFile);

Part508 = 'Flat keel Col3';
data1 = sort_yval(StrData,min(YBound),0); %All LMBs
data1 = sort_xval(data1,min(XBound),0);
FatigLife5(8,:) = min(Str_part508(:,5:6));
plot2d_TopBtm_FatigLife (Str_part508,path1,Part508,40)

OutputName = [path1,Part508,'.csv'];
csvwrite(OutputName,Str_part508)

close all
StrData = [];
%%
ResultFile = [path1 'Fatigue_Life_' GroupName '.mat'];
save(ResultFile,'Result')