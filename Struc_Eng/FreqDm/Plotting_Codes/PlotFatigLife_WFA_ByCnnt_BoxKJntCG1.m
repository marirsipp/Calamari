clc 
clear all

%Plat fatigue life results for connections

%Input
path0 ='C:\Users\Ansys\Documents\MATLAB\FreqDomain\'; 
ItrNo = 'Itr13_7';
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
EL_BoxLMBtop = 3000;

R_IS_C1 = 3250;
R_IS_C2 = 2250;
R_OS_C1 = 6000;
R_OS_C2 = 5750;
R_LMB = 1100;
R_UMB = 900;

L_LMBmidcan = 10000;
L_LMBcolcan = 8000; %Approximate number
L_UMBcolcan = 10000; %Approximate number
L_VBcolcan = 9500; %Approximate number
L_VBmidcan = 3900; %Approximate number
L_VB = 23367;
L_LMBbox = 5300;
L_VBBox = 2800; %Approximate number

XBound = [40238, 0, -25026]; %Maximum x value of the model, platform center, minimum x value
YBound = [37680, 0, -37680]; %Maximum y value of the platform, platform center, minimum y value
ZBound = [12000, 0, -18000]; %Maximum z value of the platform, platform center, minimum z value

TrussCtr_Col1 = [Ctr_Col1(1), Ctr_Col1(2), Z_Keel+EL_UMBtop-R_UMB];
TrussCtr_Col2 = [Ctr_Col2(1), Ctr_Col2(2), Z_Keel+EL_UMBtop-R_UMB];
TrussCtr_Col3 = [Ctr_Col3(1), Ctr_Col3(2), Z_Keel+EL_UMBtop-R_UMB];

LMB12Ctr = [0.5*(Ctr_Col1(1)+Ctr_Col2(1)), 0.5*(Ctr_Col1(2)+Ctr_Col2(2)), Z_Keel+EL_LMBbtm+R_LMB];
LMB13Ctr = [0.5*(Ctr_Col1(1)+Ctr_Col3(1)), 0.5*(Ctr_Col1(2)+Ctr_Col3(2)), Z_Keel+EL_LMBbtm+R_LMB];
LMB23Ctr = [0.5*(Ctr_Col3(1)+Ctr_Col2(1)), 0.5*(Ctr_Col3(2)+Ctr_Col2(2)), Z_Keel+EL_LMBbtm+R_LMB];

DotSize = 50;
tolerance = 30;

%%
% ------------------ First group - trusses cans -------------------------
GroupName = 'BoxKJnt_CG1';
path2 = [path1 GroupName '\'];
path3 = [path2 'Connection\'];
%%
PartName = 'LMB12 mid';
PartThk = Thk.KJnt.LMB12; %Part thickness
StrFile = [path2 PartName '.csv'];
StrData = importdata(StrFile);

data1 = sort_xydist(StrData, 0, L_LMBbox/2, LMB12Ctr(1), LMB12Ctr(2)); %Box can part

CnntName = 'LMB12 KJoint';
n=1;
SN = 'ABS_E_CP';
data2 = sort_zval (data1,Z_Keel+EL_LMBbtm+1.0*R_LMB, Z_Keel+EL_LMBbtm+2*R_LMB);
plot_TopBtm_FatigLife(data2,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data2, CnntName, SN, PartThk);

CnntName = 'LMB12 Brkt';
n=2;
SN = 'ABS_E_CP';
data2 = sort_zval (data1,Z_Keel+EL_LMBbtm, Z_Keel+EL_LMBbtm+1.0*R_LMB);
plot_TopBtm_FatigLife(data2,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data2, CnntName, SN, PartThk);

data1 = [];
data2 = [];
close all

CnntName = 'LMB12 Trans';
n=3;
SN = 'ABS_E_CP';
data1 = sort_xydist(StrData, L_LMBbox/2, L_LMBmidcan, LMB12Ctr(1), LMB12Ctr(2)); %Transient part
plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

data1 = [];
data2 = [];
close all
%%
PartName = 'LMB13 mid';
PartThk = Thk.KJnt.LMB12;
StrFile = [path2 PartName '.csv'];
StrData = importdata(StrFile);

data1 = sort_xydist(StrData, 0, L_LMBbox/2, LMB13Ctr(1), LMB13Ctr(2)); %Box can part

CnntName = 'LMB13 KJoint';
n=4;
SN = 'ABS_E_CP';
data2 = sort_zval (data1,Z_Keel+EL_LMBbtm+1.0*R_LMB, Z_Keel+EL_LMBbtm+2*R_LMB);
plot2d_TopBtm_FatigLife(data2,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName,data2,CnntName, SN, PartThk);

CnntName = 'LMB13 Brkt';
n=5;
SN = 'ABS_E_CP';
data2 = sort_zval (data1,Z_Keel+EL_LMBbtm, Z_Keel+EL_LMBbtm+1.0*R_LMB);
plot2d_TopBtm_FatigLife(data2,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName,data2,CnntName, SN, PartThk);

data1 = [];
data2 = [];
close all

CnntName = 'LMB13 Trans';
n=6;
SN = 'ABS_E_CP';
data1 = sort_xydist(StrData, L_LMBbox/2, L_LMBmidcan, LMB13Ctr(1), LMB13Ctr(2)); %Transient part
plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

data1 = [];
data2 = [];
close all
%%
PartName = 'LMB23 mid';
PartThk = Thk.KJnt.LMB23;
StrFile = [path2 PartName '.csv'];
StrData = importdata(StrFile);

data1 = sort_xydist(StrData, 0, L_LMBbox/2, LMB23Ctr(1), LMB23Ctr(2)); %Box can part

CnntName = 'LMB23 KJoint';
n=7;
SN = 'ABS_E_CP';
data2 = sort_zval (data1,Z_Keel+EL_LMBbtm+1.0*R_LMB, Z_Keel+EL_LMBbtm+2*R_LMB);
plot_TopBtm_FatigLife(data2,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName,data2,CnntName, SN, PartThk);

CnntName = 'LMB23 Brkt';
n=8;
SN = 'ABS_E_CP';
data2 = sort_zval (data1,Z_Keel+EL_LMBbtm, Z_Keel+EL_LMBbtm+1.0*R_LMB);
plot_TopBtm_FatigLife(data2,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName,data2,CnntName, SN, PartThk);

CnntName = 'LMB23 Trans';
n=9;
SN = 'ABS_E_CP';
data1 = sort_xydist(StrData, L_LMBbox/2, L_LMBmidcan, LMB23Ctr(1), LMB23Ctr(2)); %Transient part
plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

data1 = [];
data2 = [];
close all
%%
PartName = 'VB12lwr';
PartThk = Thk.KJnt.VB; %Part thickness
StrFile = [path2 PartName '.csv'];
StrData = importdata(StrFile);

CnntName = 'VB12lwr Box';
n=10;
SN = 'ABS_E_CP';
data1 = sort_xyzdist(StrData, 0, L_VBBox, LMB12Ctr); %Box can part
plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

CnntName = 'VB12lwr Trans';
n=11;
SN = 'ABS_E_CP';
data1 = sort_xyzdist(StrData, L_VBBox, L_VB, LMB12Ctr); %Box can part
plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);
data1 = [];
close all

%%
PartName = 'VB13lwr';
PartThk = Thk.KJnt.VB; %Part thickness
StrFile = [path2 PartName '.csv'];
StrData = importdata(StrFile);

CnntName = 'VB13lwr Box';
n=12;
SN = 'ABS_E_CP';
data1 = sort_xyzdist(StrData, 0, L_VBBox, LMB13Ctr); %Box can part
plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

CnntName = 'VB13lwr Trans';
n=13;
SN = 'ABS_E_CP';
data1 = sort_xyzdist(StrData, L_VBBox, L_VB, LMB13Ctr); %Box can part
plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);
data1 = [];
close all
%%
PartName = 'VB23lwr';
PartThk = Thk.KJnt.VB; %Part thickness
StrFile = [path2 PartName '.csv'];
StrData = importdata(StrFile);

CnntName = 'VB23lwr Box';
n=14;
SN = 'ABS_E_CP';
data1 = sort_xyzdist(StrData, 0, L_VBBox, LMB23Ctr); %Box can part
plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

CnntName = 'VB23lwr Trans';
n=15;
SN = 'ABS_E_CP';
data1 = sort_xyzdist(StrData, L_VBBox, L_VB, LMB23Ctr); %Box can part
plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);
data1 = [];
close all
%%
ResultFile = [path1 'Fatigue_Life_' GroupName '.mat'];
save(ResultFile,'Result')