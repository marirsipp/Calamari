clc 
close all
clear Result
clear Elem2run

%Plat fatigue life results for connections

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

%% Group Info
% GroupName = 'IS_CG2';
GroupName = 'IS_Bot';
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
%% ISbtm Col1
PartName = 'ISbtm Col1';
PartThk = Thk.Col1.ISbtm; %Part thickness
StrFile = [path2 PartName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path2 PartName '.csv'];
    StrData = importdata(StrFile);
end

%% ISbtm Col1
CnntName = 'ISbtm LMB Col1';
n = 1;
SN = 'API_WJ_CP';
CnntThk = PartThk;
target = 125;

data1 = sort_zval (StrData, Z_Keel+ 0.8*EL_LMBbtm, Z_Keel+EL_LMBbtm+2.5*R_LMB);
data2 = sort_xval (data1, Ctr_Col1(1) - R_IS_C1, Ctr_Col1(1));
CnntData = data2;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'ISbtm Gdr Col1';
n = 2;
SN = 'ABS_E_CP';
CnntThk = PartThk;
target = 125;

data1 = sort_zval (StrData, Z_Keel, Z_Keel + 1.3*EL_LMBbtm );
CnntData = data1;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

StrData = [];
data1 = [];
data2 = [];
%% ISbtm Col2
PartName = 'ISbtm Col2';
PartThk = Thk.Col2.ISbtm; %Part thickness
StrFile = [path2 PartName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path2 PartName '.csv'];
    StrData = importdata(StrFile);
end

CnntName = 'ISbtm LMB21 Col2';
n = 3;
SN = 'API_WJ_CP';
CnntThk = PartThk;
target = 125;

data1 = sort_zval (StrData, Z_Keel+ 0.9*EL_LMBbtm, Z_Keel+EL_LMBbtm+2.5*R_LMB);
data1(:,7) = cart2pol(data1(:,2)-Ctr_Col2(1), data1(:,3)-Ctr_Col2(2), data1(:,4)); %Add angle in Col2 cylindrical coord sys
data2 = sort_angle (data1, -60, 30);
CnntData = data2;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'ISbtm LMB23 Col2';
n = 4;
SN = 'API_WJ_CP';
CnntThk = PartThk;
target = 125;

data1 = sort_zval (StrData, Z_Keel+ 0.9*EL_LMBbtm, Z_Keel+EL_LMBbtm+2.5*R_LMB);
data1(:,7) = cart2pol(data1(:,2)-Ctr_Col2(1), data1(:,3)-Ctr_Col2(2), data1(:,4)); %Add angle in Col2 cylindrical coord sys
data2 = sort_angle (data1, -150, -60);
CnntData = data2;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'ISbtm Gdr Col2';
n = 5;
SN = 'ABS_E_CP';
CnntThk = PartThk;
target = 125;

data1 = sort_zval (StrData, Z_Keel, Z_Keel + 1.3*EL_LMBbtm );
CnntData = data1;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

StrData = [];
data1 = [];
data2 = [];
%% ISbtm Col3
PartName = 'ISbtm Col3';
PartThk = Thk.Col2.ISbtm; %Part thickness
StrFile = [path2 PartName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path2 PartName '.csv'];
    StrData = importdata(StrFile);
end
%% ISbtm Col3
CnntName = 'ISbtm LMB31 Col3';
n = 6;
SN = 'API_WJ_CP';
CnntThk = PartThk;
target = 125;

data1 = sort_zval (StrData, Z_Keel+ 0.9*EL_LMBbtm, Z_Keel+EL_LMBbtm+2.5*R_LMB);
data1(:,7) = cart2pol(data1(:,2)-Ctr_Col3(1), data1(:,3)-Ctr_Col3(2), data1(:,4)); %Add angle in Col3 cylindrical coord sys
data2 = sort_angle (data1, -30, 60);
CnntData = data2;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'ISbtm LMB32 Col3';
n = 7;
SN = 'API_WJ_CP';
CnntThk = PartThk;
target = 125;

data1 = sort_zval (StrData, Z_Keel+ 0.9*EL_LMBbtm, Z_Keel+EL_LMBbtm+2.5*R_LMB);
data1(:,7) = cart2pol(data1(:,2)-Ctr_Col3(1), data1(:,3)-Ctr_Col3(2), data1(:,4)); %Add angle in Col3 cylindrical coord sys
data2 = sort_angle (data1, 60, 150);
CnntData = data2;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

CnntName = 'ISbtm Gdr Col3';
n = 8;
SN = 'ABS_E_CP';
CnntThk = PartThk;
target = 125;

data1 = sort_zval (StrData, Z_Keel, Z_Keel + 1.3*EL_LMBbtm );
CnntData = data1;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

StrData = [];
data1 = [];
data2 = [];
%% IStop Col2
if strcmp(GroupName,'IS_CG2')
    PartName = 'IStop Col2';
    PartThk1 = Thk.Col2.IStopfrnt; %Part thickness
    PartThk2 = Thk.Col2.IStopbk; %Part thickness
    StrFile = [path2 PartName '.mat'];
    if exist(StrFile,'file')
        rst = load(StrFile);
        fname = fieldnames(rst);
        StrData = rst.(fname{1});
    else
        StrFile = [path2 PartName '.csv'];
        StrData = importdata(StrFile);
    end

    CnntName = 'IStop UMBVB21 Col2';
    n = 9;
    SN = 'API_WJ_Air';
    StrData(:,7) = cart2pol(StrData(:,2)-Ctr_Col2(1), StrData(:,3)-Ctr_Col2(2), StrData(:,4)); %Add angle in Col2 cylindrical coord sys
    data1 = sort_angle (StrData, -60, 10);
    plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk1);

    CnntName = 'IStop UMBVB23 Col2';
    n = 10;
    SN = 'API_WJ_Air';
    data1 = sort_angle (StrData, -130, -60);
    plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk2);

    StrData = [];
    data1 = [];
%% IStop Col3
    PartName = 'IStop Col3';
    PartThk1 = Thk.Col2.IStopfrnt; %Part thickness
    PartThk2 = Thk.Col2.IStopbk; %Part thickness
    StrFile = [path2 PartName '.mat'];
    if exist(StrFile,'file')
        rst = load(StrFile);
        fname = fieldnames(rst);
        StrData = rst.(fname{1});
    else
        StrFile = [path2 PartName '.csv'];
        StrData = importdata(StrFile);
    end

    CnntName = 'IStop UMBVB31 Col3';
    n = 11;
    SN = 'API_WJ_Air';
    StrData(:,7) = cart2pol(StrData(:,2)-Ctr_Col3(1), StrData(:,3)-Ctr_Col3(2), StrData(:,4)); %Add angle in Col2 cylindrical coord sys
    data1 = sort_angle (StrData, -10, 60);
    plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk1);

    CnntName = 'IStop UMBVB32 Col3';
    n = 12;
    SN = 'API_WJ_Air';
    data1 = sort_angle (StrData, 60, 130);
    plot_TopBtm_FatigLife(data1,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, data1, CnntName, SN, PartThk2);

    StrData = [];
    data1 = [];
end
%% Save Results
ResultFile = [path1 'Fatigue_Life_' GroupName '.mat'];
save(ResultFile,'Result')
ElemFile = [path1 GroupName '_ELem2Run.mat'];
save(ElemFile,'Elem2run')