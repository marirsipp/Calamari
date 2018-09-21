clc 
close all
clear Result
clear Elem2run

%Plot fatigue life results for connections

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
EL_KeelGdr = 1250;

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
L_LMBring = 2400; %Approximate, Offset of LMB rings from the center of LMBmid can
L_LMBtoering = 2800;

L_VBtotal = sqrt((EL_UMBtop-R_UMB-EL_LMBbtm-R_LMB)^2 + (ColSpace/2)^2);
L_VB = 23367;
L_VBcolcan1 = 9544.7; %Exact number
L_VBmidcan1 = L_VBtotal-L_VB-L_VBcolcan1; %Exact number

Dist_LMBRings = [9020 12724 16419 20114]; %Distance of LMB rings from Column center
Dist_FBSplice = 17343;

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
tolerance = 15;

%% Group Info
% GroupName = 'RingVbar_CG2';
GroupName = 'LMB_FB';
path2 = [path1 GroupName '\'];
path3 = [path2 'Connection\'];
if ~exist(path3,'dir')
    mkdir(path3)
end
GroupFile = [path1 GroupName '.mat'];
if exist(GroupFile,'file')
    rst = load(GroupFile);
    fname = fieldnames(rst);
    GroupData = rst.(fname{1});
else
    GroupFile = [path1 GroupName '.csv'];
    GroupData = importdata(StrFile);
end
%% FB Col1
PartName = 'FB Col1';
StrFile = [path2 PartName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path2 PartName '.csv'];
    StrData = importdata(StrFile);
end

PartThk = Thk.Nominal.FB; %Part thickness
if isfield(Thk.Nominal,'FBsplice')
    PartThk1 = Thk.Nominal.FBsplice;
else
    PartThk1 = PartThk;
end

% CnntName = 'FBinIS Col1';
% PartThk = Thk.Nominal.FB; %Part thickness
% n = 1;
% SN = 'ABS_E_Air';
% data1 = sort_xydist (StrData, 0, R_IS_C1, Ctr_Col1(1), Ctr_Col1(2));
% plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
% Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

CnntName = 'FBinOS Col1';
CnntThk = PartThk;
n = 2;
SN = 'ABS_E_CP';
target = 125;

data1 = sort_xydist (StrData, R_IS_C1, R_OS_C1, Ctr_Col1(1), Ctr_Col1(2));
CnntData = data1;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

data1 = sort_xydist (StrData, R_OS_C1, ColSpace/2, Ctr_Col1(1), Ctr_Col1(2));
% CnntName = 'FBinLMB Col1';
% PartThk = Thk.Nominal.FB; %Part thickness
% n = 3;
% SN = 'ABS_E_Air';
% data2 = sort_zval (data1, Z_Keel+EL_LMBbtm+tolerance, Z_Keel+2*EL_LMBbtm);
% plot_TopBtm_FatigLife(data2,path3,CnntName,DotSize)
% Result{n} = FatigueResult(path1, GroupName, data2, CnntName, SN, PartThk);

data2 = sort_zval (data1, Z_Keel, Z_Keel+EL_LMBbtm-tolerance);

CnntName = 'FBout LMBcan Col1';
CnntThk = PartThk;
n = 4;
SN = 'ABS_E_CP';
target = 125;

data3 = sort_xydist (data2, 0, L_LMBcolcan, Ctr_Col1(1),Ctr_Col1(2));
CnntData = data3;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'FBout Ring1 Col1';
CnntThk = PartThk;
n = 5;
SN = 'ABS_E_CP';
target = 125;

data3 = sort_xydist (data2, L_LMBcolcan, (Dist_LMBRings(1)+Dist_LMBRings(2))/2,Ctr_Col1(1),Ctr_Col1(2));
CnntData = data3;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'FBout Ring2 Col1';
CnntThk = PartThk;
n = 6;
SN = 'ABS_E_CP';
target = 125;

data3 = sort_xydist (data2, (Dist_LMBRings(1)+Dist_LMBRings(2))/2, (Dist_LMBRings(2)+Dist_LMBRings(3))/2,Ctr_Col1(1),Ctr_Col1(2));
CnntData = data3;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'FBout Ring3 Col1';
CnntThk = PartThk;
n = 7;
SN = 'ABS_E_CP';
target = 125;

% data3 = sort_xydist (data2, (Dist_LMBRings(2)+Dist_LMBRings(3))/2,(Dist_LMBRings(3)+Dist_LMBRings(4))/2,Ctr_Col1(1),Ctr_Col1(2));
data3 = sort_xydist (data2, (Dist_LMBRings(2)+Dist_LMBRings(3))/2, Dist_FBSplice,Ctr_Col1(1),Ctr_Col1(2));
CnntData = data3;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'FBout Ring4 Col1';
CnntThk = PartThk1;
n = 8;
SN = 'ABS_E_CP';
target = 125;

% data3 = sort_xydist (data2, (Dist_LMBRings(3)+Dist_LMBRings(4))/2, ColSpace,Ctr_Col1(1),Ctr_Col1(2));
data3 = sort_xydist (data2, Dist_FBSplice, ColSpace,Ctr_Col1(1),Ctr_Col1(2));
CnntData = data3;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

%% FB Col2
PartName = 'FB Col2';
StrFile = [path2 PartName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path2 PartName '.csv'];
    StrData = importdata(StrFile);
end

PartThk = Thk.Nominal.FB; %Part thickness
if isfield(Thk.Nominal,'FBsplice')
    PartThk1 = Thk.Nominal.FBsplice;
else
    PartThk1 = PartThk;
end

% CnntName = 'FBinIS Col2';
% PartThk = Thk.Nominal.FB; %Part thickness
% n = 9;
% SN = 'ABS_E_Air';
% data1 = sort_xydist (StrData, 0, R_IS_C2, Ctr_Col2(1), Ctr_Col2(2));
% plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
% Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

CnntName = 'FBinOS Col2';
CnntThk = PartThk;
n = 10;
SN = 'ABS_E_CP';
target = 125;

data1 = sort_xydist (StrData, R_IS_C2, R_OS_C2, Ctr_Col2(1), Ctr_Col2(2));
CnntData = data1;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

data1 = sort_xydist (StrData, R_OS_C2, ColSpace/2, Ctr_Col2(1), Ctr_Col2(2));

% CnntName = 'FBinLMB Col2';
% PartThk = Thk.Nominal.FB; %Part thickness
% n = 11;
% SN = 'ABS_E_Air';
% data2 = sort_zval (data1, Z_Keel+EL_LMBbtm+tolerance, Z_Keel+2*EL_LMBbtm);
% plot_TopBtm_FatigLife(data2,path3,CnntName,DotSize)
% Result{n} = FatigueResult(path1, GroupName, data2, CnntName, SN, PartThk);

data2 = sort_zval (data1, Z_Keel, Z_Keel+EL_LMBbtm-tolerance);

CnntName = 'FBout LMBcan Col2';
CnntThk = PartThk;
n = 12;
SN = 'ABS_E_CP';
target = 125;

data3 = sort_xydist (data2, 0, L_LMBcolcan, Ctr_Col2(1),Ctr_Col2(2));
CnntData = data3;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'FBout Ring1 Col2';
CnntThk = PartThk;
n = 13;
SN = 'ABS_E_CP';
target = 125;

data3 = sort_xydist (data2, L_LMBcolcan, (Dist_LMBRings(1)+Dist_LMBRings(2))/2,Ctr_Col2(1),Ctr_Col2(2));
CnntData = data3;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'FBout Ring2 Col2';
CnntThk = PartThk;
n = 14;
SN = 'ABS_E_CP';
target = 125;

data3 = sort_xydist (data2, (Dist_LMBRings(1)+Dist_LMBRings(2))/2, (Dist_LMBRings(2)+Dist_LMBRings(3))/2,Ctr_Col2(1),Ctr_Col2(2));
CnntData = data3;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'FBout Ring3 Col2';
CnntThk = PartThk;
n = 15;
SN = 'ABS_E_CP';
target = 125;

% data3 = sort_xydist (data2, (Dist_LMBRings(2)+Dist_LMBRings(3))/2,(Dist_LMBRings(3)+Dist_LMBRings(4))/2,Ctr_Col2(1),Ctr_Col2(2));
data3 = sort_xydist (data2, (Dist_LMBRings(2)+Dist_LMBRings(3))/2, Dist_FBSplice,Ctr_Col2(1),Ctr_Col2(2));
CnntData = data3;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'FBout Ring4 Col2';
CnntThk = PartThk1;
n = 16;
SN = 'ABS_E_CP';
target = 125;

% data3 = sort_xydist (data2, (Dist_LMBRings(3)+Dist_LMBRings(4))/2, ColSpace,Ctr_Col2(1),Ctr_Col2(2));
data3 = sort_xydist (data2, Dist_FBSplice, ColSpace,Ctr_Col2(1),Ctr_Col2(2));
CnntData = data3;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

%% FB Col3
PartName = 'FB Col3';
StrFile = [path2 PartName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path2 PartName '.csv'];
    StrData = importdata(StrFile);
end

PartThk = Thk.Nominal.FB; %Part thickness
if isfield(Thk.Nominal,'FBsplice')
    PartThk1 = Thk.Nominal.FBsplice;
else
    PartThk1 = PartThk;
end

% CnntName = 'FBinIS Col3';
% PartThk = Thk.Nominal.FB; %Part thickness
% n = 17;
% SN = 'ABS_E_Air';
% data1 = sort_xydist (StrData, 0, R_IS_C2, Ctr_Col3(1), Ctr_Col3(2));
% plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
% Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk);

CnntName = 'FBinOS Col3';
CnntThk = PartThk;
n = 18;
SN = 'ABS_E_CP';
target = 125;

data1 = sort_xydist (StrData, R_IS_C2, R_OS_C2, Ctr_Col3(1), Ctr_Col3(2));
CnntData = data1;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

data1 = sort_xydist (StrData, R_OS_C2, ColSpace/2, Ctr_Col3(1), Ctr_Col3(2));

% CnntName = 'FBinLMB Col3';
% PartThk = Thk.Nominal.FB; %Part thickness
% n = 19;
% SN = 'ABS_E_Air';
% data2 = sort_zval (data1, Z_Keel+EL_LMBbtm+tolerance, Z_Keel+2*EL_LMBbtm);
% plot_TopBtm_FatigLife(data2,path3,CnntName,DotSize)
% Result{n} = FatigueResult(path1, GroupName, data2, CnntName, SN, PartThk);

data2 = sort_zval (data1, Z_Keel, Z_Keel+EL_LMBbtm-tolerance);

CnntName = 'FBout LMBcan Col3';
CnntThk = PartThk;
n = 20;
SN = 'ABS_E_CP';
target = 125;

data3 = sort_xydist (data2, 0, L_LMBcolcan, Ctr_Col3(1),Ctr_Col3(2));
CnntData = data3;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'FBout Ring1 Col3';
CnntThk = PartThk;
n = 21;
SN = 'ABS_E_CP';
target = 125;

data3 = sort_xydist (data2, L_LMBcolcan, (Dist_LMBRings(1)+Dist_LMBRings(2))/2,Ctr_Col3(1),Ctr_Col3(2));
CnntData = data3;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'FBout Ring2 Col3';
CnntThk = PartThk;
n = 22;
SN = 'ABS_E_CP';
target = 125;

data3 = sort_xydist (data2, (Dist_LMBRings(1)+Dist_LMBRings(2))/2, (Dist_LMBRings(2)+Dist_LMBRings(3))/2,Ctr_Col3(1),Ctr_Col3(2));
CnntData = data3;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'FBout Ring3 Col3';
CnntThk = PartThk;
n = 23;
SN = 'ABS_E_CP';
target = 125;

% data3 = sort_xydist (data2, (Dist_LMBRings(2)+Dist_LMBRings(3))/2, (Dist_LMBRings(3)+Dist_LMBRings(4))/2,Ctr_Col3(1),Ctr_Col3(2));
data3 = sort_xydist (data2, (Dist_LMBRings(2)+Dist_LMBRings(3))/2, Dist_FBSplice,Ctr_Col3(1),Ctr_Col3(2));
CnntData = data3;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'FBout Ring4 Col3';
CnntThk = PartThk1;
n = 24;
SN = 'ABS_E_CP';
target = 125;

% data3 = sort_xydist (data2, (Dist_LMBRings(3)+Dist_LMBRings(4))/2, ColSpace,Ctr_Col3(1),Ctr_Col3(2));
data3 = sort_xydist (data2, Dist_FBSplice, ColSpace,Ctr_Col3(1),Ctr_Col3(2));
CnntData = data3;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);


%% Save Results
ResultFile = [path1 'Fatigue_Life_' GroupName '.mat'];
save(ResultFile,'Result')
ElemFile = [path1 GroupName '_ELem2Run.mat'];
save(ElemFile,'Elem2run')