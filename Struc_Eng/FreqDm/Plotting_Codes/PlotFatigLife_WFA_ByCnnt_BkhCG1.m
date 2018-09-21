clc 
clear all

%Plat fatigue life results for connections

%Input
path0 ='C:\Users\Ansys.000\Documents\MATLAB\FreqDomain\'; 
ItrNo = 'Itr13_10_noTwr';
path1 = [path0 ItrNo '\Results\'];
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
EL_TBbtm = 28750;
EL_OSins_Col1 = 20400;

R_IS_C1 = 3250;
R_IS_C2 = 2250;
R_OS_C1 = 6000;
R_OS_C2 = 5750;
R_LMB = 1100;
R_UMB = 900;

L_LMBmidcan = 9000;
L_LMBcolcan = 8000; %Approximate number
L_UMBcolcan = 10000; %Approximate number
L_VBcolcan = 9500; %Approximate number
L_VBmidcan = 3900; %Approximate number

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
tolerance2 = 500;

%%
GroupName = 'Bkh_CG1';
path2 = [path1 GroupName '\'];
path3 = [path2 'Connection\'];
%%
PartName = 'Bkh Col1';
PartThk = Thk.Col1.Bkh; %Part thickness
StrFile = [path2 PartName '.csv'];
StrData = importdata(StrFile);

CnntName = 'Bkh TF Col1';
n = 1;
SN = 'ABS_E_Air';
data1 = sort_zval (StrData, Z_Keel+EL_TBbtm, ZBound(1));
plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

CnntName = 'Bkh IS Col1';
n = 2;
SN = 'ABS_E_Air';
data1 = sort_xydist (StrData, 0, R_IS_C1+tolerance2, Ctr_Col1(1), Ctr_Col1(2));
plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

%%
ResultFile = [path1 'Fatigue_Life_' GroupName '.mat'];
save(ResultFile,'Result')