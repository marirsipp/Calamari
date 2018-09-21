clc 
close all
clear Result
%Plot frequency domain fatigue life results for connections

%Input
path1 = path_rst;

%Thickness info, in mm
ThkFile = [path0 Itr '\' 'thickness.mat'];
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
L_VB = 23367;

XBound = [40238, 0, -25026]; %Maximum x value of the model, platform center, minimum x value
YBound = [37680, 0, -37680]; %Maximum y value of the platform, platform center, minimum y value
ZBound = [12000, 0, -18000]; %Maximum z value of the platform, platform center, minimum z value

TrussCtr_Col1 = [Ctr_Col1(1), Ctr_Col1(2), Z_Keel+EL_UMBtop-R_UMB];
TrussCtr_Col2 = [Ctr_Col2(1), Ctr_Col2(2), Z_Keel+EL_UMBtop-R_UMB];
TrussCtr_Col3 = [Ctr_Col3(1), Ctr_Col3(2), Z_Keel+EL_UMBtop-R_UMB];

DotSize = 50;
tolerance = 30;
tolerance2 = 5;

%%
GroupName = 'OS1_KL';
path2 = [path1 GroupName '\'];
path3 = [path2 'Connection\'];
if ~exist(path3,'dir')
    mkdir(path3)
end

PartName = 'Flat keel Col1';
StrFile = [path2 PartName '.csv'];
StrData = importdata(StrFile);

CnntName = 'KFinIS Col1';
PartThk = Thk.Col1.KFin; %Part thickness
n=1;
SN = 'ABS_E_Air';
data1 = sort_xydist (StrData, 0, R_IS_C1-tolerance2, Ctr_Col1(1), Ctr_Col1(2));
plot2d_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

CnntName = 'KFinOS Col1';
PartThk = Thk.Col1.KFout; %Part thickness
n=2;
SN = 'ABS_E_CP';
data1 = sort_xydist (StrData, R_IS_C1-tolerance2, R_OS_C1+tolerance2, Ctr_Col1(1), Ctr_Col1(2));
plot2d_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

ResultFile = [path1 'Fatigue_Life_' GroupName '.mat'];
save(ResultFile,'Result')

%%
GroupName = 'OS2_KL';
path2 = [path1 GroupName '\'];
path3 = [path2 'Connection\'];
if ~exist(path3,'dir')
    mkdir(path3)
end

PartName = 'Flat keel Col2';
StrFile = [path2 PartName '.csv'];
StrData = importdata(StrFile);

CnntName = 'KFinIS Col2';
PartThk = Thk.Col2.KF; %Part thickness
n=1;
SN = 'ABS_E_Air';
data1 = sort_xydist (StrData, 0, R_IS_C2-tolerance2, Ctr_Col2(1), Ctr_Col2(2));
plot2d_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

CnntName = 'KFinOS Col2';
PartThk = Thk.Col2.KF; %Part thickness
n=2;
SN = 'ABS_E_CP';
data1 = sort_xydist (StrData, R_IS_C2-tolerance2, R_OS_C2+tolerance2, Ctr_Col2(1), Ctr_Col2(2));
plot2d_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

ResultFile = [path1 'Fatigue_Life_' GroupName '.mat'];
save(ResultFile,'Result')
%%
GroupName = 'OS3_KL';
path2 = [path1 GroupName '\'];
path3 = [path2 'Connection\'];
if ~exist(path3,'dir')
    mkdir(path3)
end
%%
PartName = 'Flat keel Col3';
StrFile = [path2 PartName '.csv'];
StrData = importdata(StrFile);

CnntName = 'KFinIS Col3';
PartThk = Thk.Col2.KF; %Part thickness
n=1;
SN = 'ABS_E_Air';
data1 = sort_xydist (StrData, 0, R_IS_C2-tolerance2, Ctr_Col3(1), Ctr_Col3(2));
plot2d_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

CnntName = 'KFinOS Col3';
PartThk = Thk.Col2.KF; %Part thickness
n=2;
SN = 'ABS_E_CP';
data1 = sort_xydist (StrData, R_IS_C2-tolerance2, R_OS_C2+tolerance2, Ctr_Col3(1), Ctr_Col3(2));
plot2d_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);
%%
ResultFile = [path1 'Fatigue_Life_' GroupName '.mat'];
save(ResultFile,'Result')