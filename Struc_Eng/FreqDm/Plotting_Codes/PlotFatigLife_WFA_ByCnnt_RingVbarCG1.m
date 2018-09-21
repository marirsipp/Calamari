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
EL_KeelGdr = 1250;

R_IS_C1 = 3250;
R_IS_C2 = 2250;
R_OS_C1 = 6000;
R_OS_C2 = 5750;
R_LMB = 1100;
R_UMB = 900;
R_Ring_C2 = R_IS_C2 - 500;

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

%% Group Info
% GroupName = 'RingVbar_CG1';
GroupName = 'LMB_Rings';
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
%% LMB12 rings and stiffeners
PartName = 'LMB12 rings';
StrFile = [path2 PartName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path2 PartName '.csv'];
    StrData = importdata(StrFile);
end
%% LMB12 Gusset at KJoint
if strcmp(GroupName,'RingVbar_CG1')
    CnntName = 'LMB12 Gusset';
    CnntThk = Thk.KJnt.Gusset; %Part thickness
    n = 1;
    SN = 'ABS_E_CP';
    target = 125;

    data1 = sort_zval (StrData, Z_Keel+ EL_LMBbtm + 2*R_LMB, Z_Keel+EL_PlfmBtm);
    % data2 = sort_xval (data1, Ctr_Col1(1) - R_OS_C1+tolerance, Ctr_Col1(1)- 0.7*R_OS_C1);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
end
%% LMB12 stiff and rings inside LMB
data1 = sort_zval (StrData, Z_Keel+ EL_LMBbtm, Z_Keel+EL_LMBbtm + 2*R_LMB);
%% LMB12 stiff/ring at KJoint
if strcmp(GroupName,'RingVbar_CG1')
    CnntName = 'LMB12 Grid';
    CnntThk = Thk.KJnt.Ring; %Part thickness
    n = 2;
    SN = 'ABS_E_Air';
    target = 125;

    data2 = sort_xydist (data1, 0, L_LMBring+tolerance, KJnt12_Ctr(1), KJnt12_Ctr(2));
    CnntData = data2;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    % CnntName = 'LMB12 FB';
    % CnntThk = Thk.KJnt.LwrFB; %Part thickness
    % n = 3;
    % SN = 'ABS_E_Air';
    % target = 125;
    % 
    % data2 = sort_xydist (data1, L_LMBtoering, L_LMBmidcan/2, KJnt12_Ctr(1), KJnt12_Ctr(2));
    % CnntData = data2;
    % plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    % Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    % CnntName1 = regexprep(CnntName,' ','_');
    % Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'LMB12 ToeRing';
    CnntThk = Thk.KJnt.ToeRing; %Part thickness
    n = 4;
    SN = 'ABS_E_Air';
    target = 125;

    data2 = sort_xydist (data1, L_LMBring, L_LMBtoering, KJnt12_Ctr(1), KJnt12_Ctr(2));
    CnntData = data2;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
end
%% LMB12 ring inside LMB nominal portion
CnntName = 'LMB12 GdrRing';
CnntThk = Thk.Nominal.LMBring; %Part thickness
n = 5;
SN = 'ABS_C_Air';
target = 75;

data2 = sort_xydist (data1, L_LMBmidcan/2, ColSpace, KJnt12_Ctr(1), KJnt12_Ctr(2));
CnntData = data2;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
%% LMB12 stiff/ring at KJoint
if strcmp(GroupName,'RingVbar_CG1')
    CnntName = 'LMB12 Brkt Upper';
    CnntThk = Thk.KJnt.Brkt; %Part thickness
    n = 6;
    SN = 'ABS_E_CP';
    target = 125;

    data1 = sort_zval (StrData, Z_Keel+0.8*EL_LMBbtm, Z_Keel+EL_LMBbtm);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'LMB12 Brkt Lwr';
    CnntThk = Thk.KJnt.Brkt; %Part thickness
    n = 7;
    SN = 'ABS_C_CP';
    target = 75;

    data1 = sort_zval (StrData, Z_Keel, Z_Keel+0.8*EL_LMBbtm);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);    
end
data1 = [];
data2 = [];
close all
%% LMB13 rings and stiffeners
PartName = 'LMB13 rings';
StrFile = [path2 PartName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path2 PartName '.csv'];
    StrData = importdata(StrFile);
end
%% LMB13 Gusset at KJoint
if strcmp(GroupName,'RingVbar_CG1')
    CnntName = 'LMB13 Gusset';
    CnntThk = Thk.KJnt.Gusset; %Part thickness
    n = 8;
    SN = 'ABS_E_CP';
    target = 125;

    data1 = sort_zval (StrData, Z_Keel+ EL_LMBbtm + 2*R_LMB, Z_Keel+EL_PlfmBtm);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
end
%% LMB13 rings and stiffeners insdie LMB
data1 = sort_zval (StrData, Z_Keel+ EL_LMBbtm, Z_Keel+EL_LMBbtm + 2*R_LMB);
%% LMB13 rings and stiffeners at KJoint
if strcmp(GroupName,'RingVbar_CG1')
    CnntName = 'LMB13 Grid';
    CnntThk = Thk.KJnt.Ring; %Part thickness
    n = 9;
    SN = 'ABS_E_Air';
    target = 125;

    data2 = sort_xydist (data1, 0, L_LMBring+tolerance, KJnt13_Ctr(1), KJnt13_Ctr(2));
    CnntData = data2;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    % CnntName = 'LMB13 FB';
    % CnntThk = Thk.KJnt.LwrFB; %Part thickness
    % n = 10;
    % SN = 'ABS_E_Air';
    % target = 125;
    % 
    % data2 = sort_xydist (data1, L_LMBtoering, L_LMBmidcan/2, KJnt13_Ctr(1), KJnt13_Ctr(2));
    % CnntData = data2;
    % plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    % Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    % CnntName1 = regexprep(CnntName,' ','_');
    % Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'LMB13 ToeRing';
    CnntThk = Thk.KJnt.ToeRing; %Part thickness
    n = 11;
    SN = 'ABS_E_Air';
    target = 125;

    data2 = sort_xydist (data1, L_LMBring, L_LMBtoering, KJnt13_Ctr(1), KJnt13_Ctr(2));
    CnntData = data2;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
end
%% LMB13 rings inside nominal portion
CnntName = 'LMB13 GdrRing';
CnntThk = Thk.Nominal.LMBring; %Part thickness
n = 12;
SN = 'ABS_C_Air';
target = 75;

data2 = sort_xydist (data1, L_LMBmidcan/2, ColSpace, KJnt13_Ctr(1), KJnt13_Ctr(2));
CnntData = data2;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
%% LMB12 stiff at KJoint
if strcmp(GroupName,'RingVbar_CG1')
    CnntName = 'LMB13 Brkt Upper';
    CnntThk = Thk.KJnt.Brkt; %Part thickness
    n = 13;
    SN = 'ABS_E_CP';
    target = 125;

    data1 = sort_zval (StrData, Z_Keel+0.8*EL_LMBbtm, Z_Keel+EL_LMBbtm);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'LMB13 Brkt Lwr';
    CnntThk = Thk.KJnt.Brkt; %Part thickness
    n = 14;
    SN = 'ABS_C_CP';
    target = 75;

    data1 = sort_zval (StrData, Z_Keel, Z_Keel+0.8*EL_LMBbtm);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);    
end
data1 = [];
data2 = [];
close all
%% LMB23 rings and stiffeners
PartName = 'LMB23 rings';
StrFile = [path2 PartName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path2 PartName '.csv'];
    StrData = importdata(StrFile);
end
%% LMB23 Gusset at KJoint
if strcmp(GroupName,'RingVbar_CG1')
    CnntName = 'LMB23 Gusset';
    CnntThk = Thk.KJnt.Gusset; %Part thickness
    n = 15;
    SN = 'ABS_E_CP';
    target = 125;

    data1 = sort_zval (StrData, Z_Keel+ EL_LMBbtm + 2*R_LMB, Z_Keel+EL_PlfmBtm);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
end
%% LMB23 rings and stiffeners inside LMB
data1 = sort_zval (StrData, Z_Keel+ EL_LMBbtm, Z_Keel+EL_LMBbtm + 2*R_LMB);
%% LMB23 rings and stiffeners at KJoint
if strcmp(GroupName,'RingVbar_CG1')
    CnntName = 'LMB23 Grid';
    CnntThk = Thk.KJnt.Ring; %Part thickness
    n = 16;
    SN = 'ABS_E_Air';
    target = 125;

    data2 = sort_xydist (data1, 0, L_LMBring+tolerance, KJnt23_Ctr(1), KJnt23_Ctr(2));
    CnntData = data2;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    % CnntName = 'LMB23 FB';
    % CnntThk = Thk.KJnt.LwrFB; %Part thickness
    % n = 17;
    % SN = 'ABS_E_Air';
    % target = 125;
    % 
    % data2 = sort_xydist (data1, L_LMBtoering, L_LMBmidcan/2, KJnt23_Ctr(1), KJnt23_Ctr(2));
    % CnntData = data2;
    % plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    % Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    % CnntName1 = regexprep(CnntName,' ','_');
    % Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'LMB23 ToeRing';
    CnntThk = Thk.KJnt.ToeRing; %Part thickness
    n = 18;
    SN = 'ABS_E_Air';
    target = 125;

    data2 = sort_xydist (data1, L_LMBring, L_LMBtoering, KJnt23_Ctr(1), KJnt23_Ctr(2));
    CnntData = data2;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
end
%% LMB23 rings inside nominal portion
CnntName = 'LMB23 GdrRing';
CnntThk = Thk.Nominal.LMBring; %Part thickness
n = 19;
SN = 'ABS_C_Air';
target = 75;

data2 = sort_xydist (data1, L_LMBmidcan/2, ColSpace, KJnt23_Ctr(1), KJnt23_Ctr(2));
CnntData = data2;
plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
CnntName1 = regexprep(CnntName,' ','_');
Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
%% LMB12 stiffeners at KJoint
if strcmp(GroupName,'RingVbar_CG1')
    CnntName = 'LMB23 Brkt Upper';
    CnntThk = Thk.KJnt.Brkt; %Part thickness
    n = 20;
    SN = 'ABS_E_CP';
    target = 125;

    data1 = sort_zval (StrData, Z_Keel+0.8*EL_LMBbtm, Z_Keel+EL_LMBbtm);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'LMB23 Brkt Lwr';
    CnntThk = Thk.KJnt.Brkt; %Part thickness
    n = 21;
    SN = 'ABS_E_CP';
    target = 125;

    data1 = sort_zval (StrData, Z_Keel, Z_Keel+0.8*EL_LMBbtm);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
end
data1 = [];
data2 = [];
close all
%% ISring Col1
if strcmp(GroupName,'RingVbar_CG1')
    PartName = 'ISring Col1';
    StrFile = [path2 PartName '.mat'];
    if exist(StrFile,'file')
        rst = load(StrFile);
        fname = fieldnames(rst);
        StrData = rst.(fname{1});
    else
        StrFile = [path2 PartName '.csv'];
        StrData = importdata(StrFile);
    end
%% IS TopRings Col1
    CnntName = 'IS TopRings Col1';
    CnntThk = Thk.Col1.RingatVB; %Part thickness
    n = 22;
    SN = 'ABS_E_Air';
    target = 75;

    data1 = sort_zval (StrData, Z_Keel+ EL_PlfmBtm, Z_Keel+EL_Top);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
%% IS BtmRings Col1
    CnntName = 'IS BtmRings Col1';
    CnntThk = Thk.Col1.RingatLMB; %Part thickness
    n = 23;
    SN = 'ABS_E_Air';
    target = 75;

    data1 = sort_zval (StrData, Z_Keel, Z_Keel+EL_PlfmBtm);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
%% ISring Vbar Col2
    PartName = 'ISring Vbar Col2';
    StrFile = [path2 PartName '.mat'];
    if exist(StrFile,'file')
        rst = load(StrFile);
        fname = fieldnames(rst);
        StrData = rst.(fname{1});
    else
        StrFile = [path2 PartName '.csv'];
        StrData = importdata(StrFile);
    end
%% IS Top RingVbar Col2
    CnntName = 'IS RingVbar Col2to1';
    CnntThk = Thk.Col2.RingTop; %Part thickness
    n = 24;
    SN = 'ABS_E_Air';
    target = 75;

    data1 = sort_zval (StrData, Z_Keel+ EL_PlfmBtm, Z_Keel+EL_Top);
    data1(:,7) = cart2pol(data1(:,2)-Ctr_Col2(1), data1(:,3)-Ctr_Col2(2), data1(:,4)); 
    data2 = sort_angle (data1, -60, 0);
    % data3 = sort_xydist(data2,R_Ring_C2, R_Ring_C2+0.5*(R_IS_C2-R_Ring_C2), Ctr_Col2(1), Ctr_Col2(2));
    CnntData = data2;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'IS RingVbar Col2to3';
    CnntThk = Thk.Col2.RingTop; %Part thickness
    n = 25;
    SN = 'ABS_E_Air';
    target = 75;

    data2 = sort_angle (data1, -120, -60);
    % data3 = sort_xydist(data2,R_Ring_C2, R_Ring_C2+0.5*(R_IS_C2-R_Ring_C2), Ctr_Col2(1), Ctr_Col2(2));
    CnntData = data2;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
%% IS BtmRings Col2
    CnntName = 'IS BtmRings Col2';
    CnntThk = Thk.Col2.RingatLMB; %Part thickness
    n = 26;
    SN = 'ABS_E_Air';
    target = 75;

    data1 = sort_zval (StrData, Z_Keel, Z_Keel+EL_PlfmBtm);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
%% ISring Vbar Col3
    PartName = 'ISring Vbar Col3';
    StrFile = [path2 PartName '.mat'];
    if exist(StrFile,'file')
        rst = load(StrFile);
        fname = fieldnames(rst);
        StrData = rst.(fname{1});
    else
        StrFile = [path2 PartName '.csv'];
        StrData = importdata(StrFile);
    end
%% IS TopRings Col3
    CnntName = 'IS TopRings Col3to1';
    CnntThk = Thk.Col2.RingTop; %Part thickness
    n = 27;
    SN = 'ABS_E_Air';
    target = 75;

    data1 = sort_zval (StrData, Z_Keel+ EL_PlfmBtm, Z_Keel+EL_Top);
    data1(:,7) = cart2pol(data1(:,2)-Ctr_Col3(1), data1(:,3)-Ctr_Col3(2), data1(:,4)); 
    data2 = sort_angle (data1, 0, 60);
    % data3 = sort_xydist(data2,R_Ring_C2, R_Ring_C2+0.5*(R_IS_C2-R_Ring_C2), Ctr_Col3(1), Ctr_Col3(2));
    CnntData = data2;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'IS TopRings Col3to2';
    CnntThk = Thk.Col2.RingTop; %Part thickness
    n = 28;
    SN = 'ABS_E_Air';
    target = 75;

    data2 = sort_angle (data1, 60, 120);
    % data3 = sort_xydist(data2,R_Ring_C2, R_Ring_C2+0.5*(R_IS_C2-R_Ring_C2), Ctr_Col3(1), Ctr_Col3(2));
    CnntData = data2;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
%% IS BtmRings Col3
    CnntName = 'IS BtmRings Col3';
    CnntThk = Thk.Col2.RingatLMB; %Part thickness
    n = 29;
    SN = 'ABS_E_Air';
    target = 75;

    data1 = sort_zval (StrData, Z_Keel, Z_Keel+EL_PlfmBtm);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
end
%% Save Results
ResultFile = [path1 'Fatigue_Life_' GroupName '.mat'];
save(ResultFile,'Result')
ElemFile = [path1 GroupName '_ELem2Run.mat'];
save(ElemFile,'Elem2run')