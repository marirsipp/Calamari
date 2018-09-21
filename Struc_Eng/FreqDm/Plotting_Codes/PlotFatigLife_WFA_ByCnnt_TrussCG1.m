clc 
close all
clear Result
clear Elem2run
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

%% GroupInfo
% ------------------ First group - trusses cans -------------------------
% GroupName = 'Truss_CG1';
GroupName = 'LMB_Can';
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
%% K-Joint - LMB12 mid
if strcmp(GroupName, 'Truss_CG1')
    PartName = 'LMB12 mid';
    PartThk = Thk.KJnt.LMB12; %Part thickness
    StrFile = [path2 PartName '.mat'];
    if exist(StrFile,'file')
        rst = load(StrFile);
        fname = fieldnames(rst);
        StrData = rst.(fname{1});
    else
        StrFile = [path2 PartName '.csv'];
        StrData = importdata(StrFile);
    end

    CnntName = 'LMB12 KJoint';
    n=1;
    SN = 'API_WJ_CP';
    CnntThk = PartThk;
    target = 125;

    data1 = sort_zval (StrData,Z_Keel+EL_LMBbtm+1.2*R_LMB, Z_Keel+EL_LMBbtm+2*R_LMB);
    CnntData = data1;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'LMB12 Brkt';
    n=2;
    SN = 'ABS_E_CP';
    CnntThk = PartThk;
    target = 125;

    data1 = sort_zval (StrData,Z_Keel+EL_LMBbtm, Z_Keel+EL_LMBbtm+0.8*R_LMB);
    CnntData = data1;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    data1 = [];
    close all
%% K-Joint - LMB13 mid
    PartName = 'LMB13 mid';
    PartThk = Thk.KJnt.LMB12;
    StrFile = [path2 PartName '.mat'];
    if exist(StrFile,'file')
        rst = load(StrFile);
        fname = fieldnames(rst);
        StrData = rst.(fname{1});
    else
        StrFile = [path2 PartName '.csv'];
        StrData = importdata(StrFile);
    end

    CnntName = 'LMB13 KJoint';
    n=3;
    SN = 'API_WJ_CP';
    CnntThk = PartThk;
    target = 125;

    data1 = sort_zval (StrData,Z_Keel+EL_LMBbtm+1.2*R_LMB, Z_Keel+EL_LMBbtm+2*R_LMB);
    CnntData = data1;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'LMB13 Brkt';
    n=4;
    SN = 'ABS_E_CP';
    CnntThk = PartThk;
    target = 125;

    data1 = sort_zval (StrData,Z_Keel+EL_LMBbtm, Z_Keel+EL_LMBbtm+0.8*R_LMB);
    CnntData = data1;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    data1 = [];
    close all
%% K-Joint - LMB23 mid
    PartName = 'LMB23 mid';
    PartThk = Thk.KJnt.LMB23;
    StrFile = [path2 PartName '.mat'];
    if exist(StrFile,'file')
        rst = load(StrFile);
        fname = fieldnames(rst);
        StrData = rst.(fname{1});
    else
        StrFile = [path2 PartName '.csv'];
        StrData = importdata(StrFile);
    end

    CnntName = 'LMB23 KJoint';
    n=5;
    SN = 'API_WJ_CP';
    CnntThk = PartThk;
    target = 125;

    data1 = sort_zval (StrData,Z_Keel+EL_LMBbtm+1.2*R_LMB, Z_Keel+EL_LMBbtm+2*R_LMB);
    CnntData = data1;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'LMB23 Brkt';
    n=6;
    SN = 'ABS_E_CP';
    CnntThk = PartThk;
    target = 125;

    data1 = sort_zval (StrData,Z_Keel+EL_LMBbtm, Z_Keel+EL_LMBbtm+0.8*R_LMB);
    CnntData = data1;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    data1 = [];
    close all
end
%% LMB at COL - LMB_Col1
PartName = 'LMB Col1';
PartThk = Thk.Col1.LMB;
StrFile = [path2 PartName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path2 PartName '.csv'];
    StrData = importdata(StrFile);
end


CnntName = 'LMB IS Col1';
n=7;
SN = 'API_WJ_CP';
CnntThk = PartThk;
target = 125;

data1 = sort_xydist (StrData, R_IS_C1, R_IS_C1+0.5*(R_OS_C1-R_IS_C1), Ctr_Col1(1), Ctr_Col1(2));
CnntData = data1;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'LMB OS Col1';
n=8;
SN = 'API_WJ_CP';
CnntThk = PartThk;
target = 125;

data1 = sort_xydist (StrData, R_IS_C1+0.5*(R_OS_C1-R_IS_C1), L_LMBcolcan, Ctr_Col1(1), Ctr_Col1(2));
CnntData = data1;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

data1 = [];
close all
%% LMB at COL - LMB_Col2
PartName = 'LMB Col2';
StrFile = [path2 PartName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path2 PartName '.csv'];
    StrData = importdata(StrFile);
end


CnntName = 'LMB21 IS Col2';
CnntThk = Thk.Col2.LMB21;
n=9;
SN = 'API_WJ_CP';
target = 125;

data1 = sort_xydist (StrData, R_IS_C2, R_IS_C2+0.5*(R_OS_C2-R_IS_C2), Ctr_Col2(1), Ctr_Col2(2));
data1(:,7) = cart2pol(data1(:,2)-Ctr_Col2(1), data1(:,3)-Ctr_Col2(2), data1(:,4)); %Add angle in Col2 cylindrical coord sys
data2 = sort_angle (data1, -60, 30);

CnntData = data2;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'LMB23 IS Col2';
CnntThk = Thk.Col2.LMB23;
n=10;
SN = 'API_WJ_CP';
target = 125;

data2 = sort_angle (data1, -150, -60);
CnntData = data2;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);


CnntName = 'LMB21 OS Col2';
CnntThk = Thk.Col2.LMB21;
n=11;
SN = 'API_WJ_CP';
target = 125;

data1 = sort_xydist (StrData, R_IS_C2+0.5*(R_OS_C2-R_IS_C2), L_LMBcolcan, Ctr_Col2(1), Ctr_Col2(2));
data1(:,7) = cart2pol(data1(:,2)-Ctr_Col2(1), data1(:,3)-Ctr_Col2(2), data1(:,4)); %Add angle in Col2 cylindrical coord sys
data2 = sort_angle (data1, -60, 30);

CnntData = data2;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);


CnntName = 'LMB23 OS Col2';
CnntThk = Thk.Col2.LMB23;
n=12;
SN = 'API_WJ_CP';
target = 125;

data2 = sort_angle (data1, -150, -60);
CnntData = data2;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

data1 = [];
data2 = [];
close all
%% LMB at COL - LMB_Col3
PartName = 'LMB Col3';
StrFile = [path2 PartName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path2 PartName '.csv'];
    StrData = importdata(StrFile);
end

CnntName = 'LMB31 IS Col3';
CnntThk = Thk.Col2.LMB21;
n=13;
SN = 'API_WJ_CP';
target = 125;

data1 = sort_xydist (StrData, R_IS_C2, R_IS_C2+0.5*(R_OS_C2-R_IS_C2), Ctr_Col3(1), Ctr_Col3(2));
data1(:,7) = cart2pol(data1(:,2)-Ctr_Col3(1), data1(:,3)-Ctr_Col3(2), data1(:,4));
data2 = sort_angle (data1, -30, 60);

CnntData = data2;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'LMB32 IS Col3';
CnntThk = Thk.Col2.LMB23;
n=14;
SN = 'API_WJ_CP';
target = 125;

data2 = sort_angle (data1, 60, 150);
CnntData = data2;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'LMB31 OS Col3';
CnntThk = Thk.Col2.LMB21;
n=15;
SN = 'API_WJ_CP';
target = 125;

data1 = sort_xydist (StrData, R_IS_C2+0.5*(R_OS_C2-R_IS_C2), L_LMBcolcan, Ctr_Col3(1), Ctr_Col3(2));
data1(:,7) = cart2pol(data1(:,2)-Ctr_Col3(1), data1(:,3)-Ctr_Col3(2), data1(:,4));
data2 = sort_angle (data1, -30, 60);
CnntData = data2;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'LMB32 OS Col3';
CnntThk = Thk.Col2.LMB23;
n=16;
SN = 'API_WJ_CP';
target = 125;

data2 = sort_angle (data1, 60, 150);
CnntData = data2;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

close all
%% UMB/VB - Col1_IS
if strcmp(GroupName,'Truss_CG1')
    PartName = 'UMBVB Col1';
    StrFile = [path2 PartName '.mat'];
    if exist(StrFile,'file')
        rst = load(StrFile);
        fname = fieldnames(rst);
        StrData = rst.(fname{1});
    else
        StrFile = [path2 PartName '.csv'];
        StrData = importdata(StrFile);
    end

    data1 = sort_xydist (StrData, R_IS_C1-tolerance, R_IS_C1+0.5*(R_OS_C1-R_IS_C1), Ctr_Col1(1), Ctr_Col1(2)); %IS connection

    CnntName = 'UMB IS Col1';
    CnntThk = Thk.Col1.UMB;
    n = 17;
    SN = 'API_WJ_Air';
    target = 75;

    data2 = sort_zval (data1, Z_Keel+EL_UMBtop-2*R_UMB-tolerance, Z_Keel+EL_UMBtop+tolerance);
    CnntData = data2;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'VB IS Col1';
    CnntThk = Thk.Col1.VB;
    n = 18;
    SN = 'API_WJ_Air';
    target = 75;

    data2 = sort_zval (data1, Z_Keel, Z_Keel+EL_UMBtop-2*R_UMB-tolerance);
    CnntData = data2;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    data1 = [];
    close all
%% UMB/VB - Col1_OS
    data1 = sort_xydist (StrData, R_IS_C1+0.5*(R_OS_C1-R_IS_C1), L_UMBcolcan, Ctr_Col1(1), Ctr_Col1(2)); %OS connection

    CnntName = 'UMB OS Col1';
    CnntThk = Thk.Col1.UMB;
    n = 19;
    SN = 'API_WJ_Air';
    target = 75;

    data2 = sort_zval (data1, Z_Keel+EL_UMBtop-2*R_UMB-tolerance, Z_Keel+EL_UMBtop+tolerance);
    CnntData = data2;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'VB OS Col1';
    CnntThk = Thk.Col1.VB;
    n = 20;
    SN = 'API_WJ_CP';
    target = 75;

    data2 = sort_zval (data1, Z_Keel, Z_Keel+EL_UMBtop-2*R_UMB-tolerance);
    CnntData = data2;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    data1 = [];
    close all
%% UMB/VB - Col2_IS
    PartName = 'UMBVB Col2';
    StrFile = [path2 PartName '.mat'];
    if exist(StrFile,'file')
        rst = load(StrFile);
        fname = fieldnames(rst);
        StrData = rst.(fname{1});
    else
        StrFile = [path2 PartName '.csv'];
        StrData = importdata(StrFile);
    end

    data1 = sort_xydist (StrData, R_IS_C2-tolerance, R_IS_C2+0.5*(R_OS_C2-R_IS_C2), Ctr_Col2(1), Ctr_Col2(2)); %IS connection
    data1(:,7) = cart2pol(data1(:,2)-Ctr_Col2(1), data1(:,3)-Ctr_Col2(2), data1(:,4)); %Add angle in Col2 cylindrical coord sys
    data2 = sort_zval (data1, Z_Keel+EL_UMBtop-2*R_UMB-tolerance, Z_Keel+EL_UMBtop+tolerance); %UMB

    CnntName = 'UMB21 IS Col2';
    CnntThk = Thk.Col2.UMB21;
    n = 21;
    SN = 'API_WJ_Air';
    target = 75;

    data3 = sort_angle (data2, -60, 0);
    CnntData = data3;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'UMB23 IS Col2';
    CnntThk = Thk.Col2.UMB23;
    n = 22;
    SN = 'API_WJ_Air';
    target = 75;

    data3 = sort_angle (data2, -120, -60);
    CnntData = data3;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    data3 = [];
    data2 = [];

    CnntName = 'VB21 IS Col2';
    CnntThk = Thk.Col2.VB21;
    n = 23;
    SN = 'API_WJ_Air';
    target = 75;

    data2 = sort_zval (data1, Z_Keel, Z_Keel+EL_UMBtop-2*R_UMB-tolerance);
    CnntData = data2;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    data1 = [];
    close all
%% UMB/VB - Col2_OS
    data1 = sort_xydist (StrData, R_IS_C1+0.5*(R_OS_C2-R_IS_C2), L_UMBcolcan, Ctr_Col2(1), Ctr_Col2(2)); %OS connection
    data1(:,7) = cart2pol(data1(:,2)-Ctr_Col2(1), data1(:,3)-Ctr_Col2(2), data1(:,4)); %Add angle in Col2 cylindrical coord sys

    data2 = sort_zval (data1, Z_Keel+EL_UMBtop-2*R_UMB-tolerance, Z_Keel+EL_UMBtop+tolerance); %UMB

    CnntName = 'UMB21 OS Col2';
    CnntThk = Thk.Col2.UMB21;
    n = 24;
    SN = 'API_WJ_Air';
    target = 75;

    data3 = sort_angle (data2, -60, 0);
    CnntData = data3;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'UMB23 OS Col2';
    CnntThk = Thk.Col2.UMB23;
    n = 25;
    SN = 'API_WJ_Air';
    target = 75;

    data3 = sort_angle (data2, -120, -60);
    CnntData = data3;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    data3 = [];
    data2 = [];

    CnntName = 'VB21 OS Col2';
    CnntThk = Thk.Col2.VB21;
    n = 26;
    SN = 'API_WJ_CP';
    target = 75;

    data2 = sort_zval (data1, Z_Keel, Z_Keel+EL_UMBtop-2*R_UMB-tolerance);
    CnntData = data2;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    data1 = [];
    close all
%% UMB/VB - Col3_IS
    PartName = 'UMBVB Col3';
    StrFile = [path2 PartName '.mat'];
    if exist(StrFile,'file')
        rst = load(StrFile);
        fname = fieldnames(rst);
        StrData = rst.(fname{1});
    else
        StrFile = [path2 PartName '.csv'];
        StrData = importdata(StrFile);
    end

    data1 = sort_xydist (StrData, R_IS_C2-tolerance, R_IS_C2+0.5*(R_OS_C2-R_IS_C2), Ctr_Col3(1), Ctr_Col3(2)); %IS connection
    data1(:,7) = cart2pol(data1(:,2)-Ctr_Col3(1), data1(:,3)-Ctr_Col3(2), data1(:,4)); %Add angle in Col2 cylindrical coord sys
    data2 = sort_zval (data1, Z_Keel+EL_UMBtop-2*R_UMB-tolerance, Z_Keel+EL_UMBtop+tolerance); %UMB

    CnntName = 'UMB31 IS Col3';
    CnntThk = Thk.Col2.UMB21;
    n = 27;
    SN = 'API_WJ_Air';
    target = 75;

    data3 = sort_angle (data2, 0, 60);
    CnntData = data3;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'UMB32 IS Col3';
    CnntThk = Thk.Col2.UMB23;
    n = 28;
    SN = 'API_WJ_Air';
    target = 75;

    data3 = sort_angle (data2, 60, 120);
    CnntData = data3;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    data3 = [];
    data2 = [];

    CnntName = 'VB31 IS Col3';
    CnntThk = Thk.Col2.VB21;
    n = 29;
    SN = 'API_WJ_Air';
    target = 75;

    data2 = sort_zval (data1, Z_Keel, Z_Keel+EL_UMBtop-2*R_UMB-tolerance);
    CnntData = data2;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    data1 = [];
    close all
%% UMB/VB - Col3_OS
    data1 = sort_xydist (StrData, R_IS_C1+0.5*(R_OS_C2-R_IS_C2), L_UMBcolcan, Ctr_Col3(1), Ctr_Col3(2)); %OS connection
    data1(:,7) = cart2pol(data1(:,2)-Ctr_Col3(1), data1(:,3)-Ctr_Col3(2), data1(:,4)); %Add angle in Col2 cylindrical coord sys
    data2 = sort_zval (data1, Z_Keel+EL_UMBtop-2*R_UMB-tolerance, Z_Keel+EL_UMBtop+tolerance); %UMB

    CnntName = 'UMB31 OS Col3';
    CnntThk = Thk.Col2.UMB21;
    n = 30;
    SN = 'API_WJ_Air';
    target = 75;

    data3 = sort_angle (data2, 0, 60);
    CnntData = data3;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'UMB32 OS Col3';
    CnntThk = Thk.Col2.UMB23;
    n = 31;
    SN = 'API_WJ_Air';
    target = 75;

    data3 = sort_angle (data2, 60, 120);
    CnntData = data3;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    data3 = [];
    data2 = [];

    CnntName = 'VB31 OS Col3';
    CnntThk = Thk.Col2.VB21;
    n = 32;
    SN = 'API_WJ_CP';
    target = 75;

    data2 = sort_zval (data1, Z_Keel, Z_Keel+EL_UMBtop-2*R_UMB-tolerance);
    CnntData = data2;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    data1 = [];
    close all
end
%% Save results
ResultFile = [path1 'Fatigue_Life_' GroupName '.mat'];
save(ResultFile,'Result')
ElemFile = [path1 GroupName '_ELem2Run.mat'];
save(ElemFile,'Elem2run')