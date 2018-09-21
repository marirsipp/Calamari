clc
close all
clear Result
clear Elem2run

%Plot fatigue life results for connections

%Input
path1 = path_rst;
PlotRingCenter = 'n';

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
L_VB = 23367-500;
L_VBcolcan1 = 9544.7; %Exact number
L_VBmidcan1 = L_VBtotal-L_VB-L_VBcolcan1; %Exact number

Dist_LMBRings = [9020 12724 16419 20114]; %Distance of LMB rings from Column center
Dist_LMBSplices = [8820 9220 19914 20314]; %Distance of LMB insert plate splices from Column center

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
% ------------------ First group - trusses cans -------------------------
% GroupName = 'Truss_CG2';
GroupName = 'LMB_Nominal';
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
%% LMBnm Col1
PartName = 'LMBnm Col1';
PartThk = Thk.Nominal.LMB; %Part thickness
if isfield(Thk.Nominal,'LMBSplice')
    PartThk1 = Thk.Nominal.LMBSplice; %Part thickness
else
    PartThk1 = PartThk;
end
if isfield(Thk.Nominal,'LMBSpRing4')
    PartThk2 = Thk.Nominal.LMBSpRing4; %Part thickness
else
    PartThk2 = PartThk;
end
StrFile = [path2 PartName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path2 PartName '.csv'];
    StrData = importdata(StrFile);
end
%% LMBnm Col1
data1 = sort_zval (StrData,Z_Keel+EL_LMBbtm, Z_Keel+EL_LMBbtm+0.5*R_LMB);

if strcmp(PlotRingCenter,'y')
    CnntName = 'LMBnm FB Ring1 Col1';
    n=1;
    CnntThk = PartThk;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, 0, (Dist_LMBRings(1)+Dist_LMBRings(2))/2, Ctr_Col1(1),Ctr_Col1(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
    
    CnntName = 'LMBnm FB Ring2 Col1';    
    n=2;
    CnntThk = PartThk;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, (Dist_LMBRings(1)+Dist_LMBRings(2))/2, (Dist_LMBRings(2)+Dist_LMBRings(3))/2, Ctr_Col1(1),Ctr_Col1(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'LMBnm FB Ring3 Col1';
    n=3;
    CnntThk = PartThk;    
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, (Dist_LMBRings(2)+Dist_LMBRings(3))/2, (Dist_LMBRings(3)+Dist_LMBRings(4))/2, Ctr_Col1(1),Ctr_Col1(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'LMBnm FB Ring4 Col1';
    n=4;
    CnntThk = PartThk2;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, (Dist_LMBRings(3)+Dist_LMBRings(4))/2, ColSpace, Ctr_Col1(1),Ctr_Col1(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
    
else
    CnntName = 'LMBnm FB Splice1 Col1';
    n=1;
    CnntThk = PartThk;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, 0, Dist_LMBSplices(1), Ctr_Col1(1),Ctr_Col1(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
    
    CnntName = 'LMBnm FB Splice2 Col1';
    n=2;
    CnntThk = PartThk1;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, Dist_LMBSplices(1), Dist_LMBSplices(2), Ctr_Col1(1),Ctr_Col1(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
    
    CnntName = 'LMBnm FB Splice3 Col1';
    n=3;
    CnntThk = PartThk;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, Dist_LMBSplices(2), Dist_LMBSplices(3), Ctr_Col1(1),Ctr_Col1(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'LMBnm FB Splice4 Col1';
    n=4;
    CnntThk = PartThk2;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, Dist_LMBSplices(3), Dist_LMBSplices(4), Ctr_Col1(1),Ctr_Col1(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
    
    CnntName = 'LMBnm FB Splice5 Col1';
    n=26;
    CnntThk = PartThk1;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, Dist_LMBSplices(4), ColSpace/2, Ctr_Col1(1),Ctr_Col1(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
end

%% LMBnm Col2
PartName = 'LMBnm Col2';
PartThk = Thk.Nominal.LMB; %Part thickness
if isfield(Thk.Nominal,'LMBSplice')
    PartThk1 = Thk.Nominal.LMBSplice; %LMB insert plate thickness
else
    PartThk1 = PartThk;
end
if isfield(Thk.Nominal,'LMBSpRing4')
    PartThk2 = Thk.Nominal.LMBSpRing4; %Part thickness
else
    PartThk2 = PartThk;
end
StrFile = [path2 PartName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path2 PartName '.csv'];
    StrData = importdata(StrFile);
end
%% LMBnm Col1
data1 = sort_zval (StrData,Z_Keel+EL_LMBbtm, Z_Keel+EL_LMBbtm+0.5*R_LMB);

if strcmp(PlotRingCenter,'y')
    CnntName = 'LMBnm FB Ring1 Col2';
    n=5;
    CnntThk = PartThk;
    SN = 'ABS_E_CP';
    data2 = sort_xydist (data1, 0, (Dist_LMBRings(1)+Dist_LMBRings(2))/2, Ctr_Col2(1),Ctr_Col2(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
    
    CnntName = 'LMBnm FB Ring2 Col2';    
    n=6;
    CnntThk = PartThk;
    SN = 'ABS_E_CP';
    data2 = sort_xydist (data1, (Dist_LMBRings(1)+Dist_LMBRings(2))/2, (Dist_LMBRings(2)+Dist_LMBRings(3))/2, Ctr_Col2(1),Ctr_Col2(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'LMBnm FB Ring3 Col2';
    n=7;
    CnntThk = PartThk;    
    SN = 'ABS_E_CP';
    data2 = sort_xydist (data1, (Dist_LMBRings(2)+Dist_LMBRings(3))/2, (Dist_LMBRings(3)+Dist_LMBRings(4))/2, Ctr_Col2(1),Ctr_Col2(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'LMBnm FB Ring4 Col2';
    n=8;
    CnntThk = PartThk2;
    SN = 'ABS_E_CP';
    data2 = sort_xydist (data1, (Dist_LMBRings(3)+Dist_LMBRings(4))/2, ColSpace, Ctr_Col2(1),Ctr_Col2(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
else
    CnntName = 'LMBnm FB Splice1 Col2';
    n=5;
    CnntThk = PartThk;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, 0, Dist_LMBSplices(1), Ctr_Col2(1),Ctr_Col2(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
    
    CnntName = 'LMBnm FB Splice2 Col2';
    n=6;
    CnntThk = PartThk;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, Dist_LMBSplices(1), Dist_LMBSplices(2), Ctr_Col2(1),Ctr_Col2(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
    
    CnntName = 'LMBnm FB Splice3 Col2';
    n=7;
    CnntThk = PartThk;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, Dist_LMBSplices(2), Dist_LMBSplices(3), Ctr_Col2(1),Ctr_Col2(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
    
    CnntName = 'LMBnm FB Splice4 Col2';
    n=8;
    CnntThk = PartThk2;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, Dist_LMBSplices(3), Dist_LMBSplices(4), Ctr_Col2(1),Ctr_Col2(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
    
    CnntName = 'LMBnm FB Splice5 Col2';
    n=27;
    CnntThk = PartThk1;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, Dist_LMBSplices(4), ColSpace/2, Ctr_Col2(1),Ctr_Col2(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
end

%% LMBnm Col3
PartName = 'LMBnm Col3';
PartThk = Thk.Nominal.LMB; %Part thickness
if isfield(Thk.Nominal,'LMBSplice')
    PartThk1 = Thk.Nominal.LMBSplice; %LMB insert plate thickness
else
    PartThk1 = PartThk;
end
if isfield(Thk.Nominal,'LMBSpRing4')
    PartThk2 = Thk.Nominal.LMBSpRing4; %Part thickness
else
    PartThk2 = PartThk;
end
StrFile = [path2 PartName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path2 PartName '.csv'];
    StrData = importdata(StrFile);
end

data1 = sort_zval (StrData,Z_Keel+EL_LMBbtm, Z_Keel+EL_LMBbtm+0.5*R_LMB);

if strcmp(PlotRingCenter,'y')
    CnntName = 'LMBnm FB Ring1 Col3';
    n=9;
    CnntThk = PartThk;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, 0, (Dist_LMBRings(1)+Dist_LMBRings(2))/2, Ctr_Col3(1),Ctr_Col3(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
    
    CnntName = 'LMBnm FB Ring2 Col3';    
    n=10;
    CnntThk = PartThk;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, (Dist_LMBRings(1)+Dist_LMBRings(2))/2, (Dist_LMBRings(2)+Dist_LMBRings(3))/2, Ctr_Col3(1),Ctr_Col3(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'LMBnm FB Ring3 Col3';
    n=11;
    CnntThk = PartThk;    
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, (Dist_LMBRings(2)+Dist_LMBRings(3))/2, (Dist_LMBRings(3)+Dist_LMBRings(4))/2, Ctr_Col3(1),Ctr_Col3(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'LMBnm FB Ring4 Col3';
    n=12;
    CnntThk = PartThk2;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, (Dist_LMBRings(3)+Dist_LMBRings(4))/2, ColSpace, Ctr_Col3(1),Ctr_Col3(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
else
    CnntName = 'LMBnm FB Splice1 Col3';
    n=9;
    CnntThk = PartThk;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, 0, Dist_LMBSplices(1), Ctr_Col3(1),Ctr_Col3(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
    
    CnntName = 'LMBnm FB Splice2 Col3';
    n=10;
    CnntThk = PartThk;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, Dist_LMBSplices(1), Dist_LMBSplices(2), Ctr_Col3(1),Ctr_Col3(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
    
    CnntName = 'LMBnm FB Splice3 Col3';
    n=11;
    CnntThk = PartThk;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, Dist_LMBSplices(2), Dist_LMBSplices(3), Ctr_Col3(1),Ctr_Col3(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'LMBnm FB Splice4 Col3';
    n=12;
    CnntThk = PartThk2;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, Dist_LMBSplices(3), Dist_LMBSplices(4), Ctr_Col3(1),Ctr_Col3(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
    
    CnntName = 'LMBnm FB Splice5 Col3';
    n=28;
    CnntThk = PartThk1;
    SN = 'ABS_E_CP';
    target = 125;
    
    data2 = sort_xydist (data1, Dist_LMBSplices(4), ColSpace/2, Ctr_Col3(1),Ctr_Col3(2));
    CnntData = data2;
    plot2d_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
end

%% VBlwr 12
if strcmp(GroupName,'Truss_CG2')
    PartName = 'VBlwr 12';
    PartThk = Thk.KJnt.VB12; %Part thickness
    StrFile = [path2 PartName '.mat'];
    if exist(StrFile,'file')
        rst = load(StrFile);
        fname = fieldnames(rst);
        StrData = rst.(fname{1});
    else
        StrFile = [path2 PartName '.csv'];
        StrData = importdata(StrFile);
    end

    CnntName = 'VB12 KJoint';
    n=13;
    SN = 'API_WJ_CP';
    CnntThk = PartThk;
    target = 125;

    data1 = sort_xyzdist (StrData,0, 0.7*L_VBmidcan1, KJnt12_Ctr);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'VB12 Gusset';
    n=14;
    SN = 'ABS_E_CP';
    CnntThk = PartThk;
    target = 125;

    data1 = sort_xyzdist (StrData, 0.7*L_VBmidcan1, 1.2*L_VBmidcan1, KJnt12_Ctr);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

%% VBlwr 13
    PartName = 'VBlwr 13';
    PartThk = Thk.KJnt.VB12; %Part thickness
    StrFile = [path2 PartName '.mat'];
    if exist(StrFile,'file')
        rst = load(StrFile);
        fname = fieldnames(rst);
        StrData = rst.(fname{1});
    else
        StrFile = [path2 PartName '.csv'];
        StrData = importdata(StrFile);
    end

    CnntName = 'VB13 KJoint';
    n=15;
    SN = 'API_WJ_CP';
    CnntThk = PartThk;
    target = 125;

    data1 = sort_xyzdist (StrData,0, 0.7*L_VBmidcan1, KJnt13_Ctr);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'VB13 Gusset';
    n=16;
    SN = 'ABS_E_CP';
    CnntThk = PartThk;
    target = 125;

    data1 = sort_xyzdist (StrData, 0.7*L_VBmidcan1, 1.2*L_VBmidcan1, KJnt13_Ctr);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
%% VBlwr 23
    PartName = 'VBlwr 23';
    PartThk = Thk.KJnt.VB23; %Part thickness
    StrFile = [path2 PartName '.mat'];
    if exist(StrFile,'file')
        rst = load(StrFile);
        fname = fieldnames(rst);
        StrData = rst.(fname{1});
    else
        StrFile = [path2 PartName '.csv'];
        StrData = importdata(StrFile);
    end

    CnntName = 'VB23 KJoint';
    n=17;
    SN = 'API_WJ_CP';
    CnntThk = PartThk;
    target = 125;

    data1 = sort_xyzdist (StrData,0, 0.7*L_VBmidcan1, KJnt23_Ctr);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'VB23 Gusset';
    n=18;
    SN = 'ABS_E_CP';
    CnntThk = PartThk;
    target = 125;

    data1 = sort_xyzdist (StrData, 0.7*L_VBmidcan1, 1.2*L_VBmidcan1, KJnt23_Ctr);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
%% VBnm Col1
    PartName = 'VBnm Col1';
    PartThk = Thk.Nominal.VB1; %Part thickness
    StrFile = [path2 PartName '.mat'];
    if exist(StrFile,'file')
        rst = load(StrFile);
        fname = fieldnames(rst);
        StrData = rst.(fname{1});
    else
        StrFile = [path2 PartName '.csv'];
        StrData = importdata(StrFile);
    end

    CnntName = 'VBnm KJnt12';
    n = 19;
    SN = 'API_WJ_CP';
    CnntThk = PartThk;
    target = 125;

    data1 = sort_xyzdist (StrData,L_VBmidcan1, L_VBmidcan1+2000, KJnt12_Ctr);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'VBnm KJnt13';
    n = 20;
    SN = 'API_WJ_CP';
    CnntThk = PartThk;
    target = 125;

    data1 = sort_xyzdist (StrData,L_VBmidcan1, L_VBmidcan1+2000, KJnt13_Ctr);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
%% VBnm Col2
    PartName = 'VBnm Col2';
    PartThk = Thk.Nominal.VB2; %Part thickness
    StrFile = [path2 PartName '.mat'];
    if exist(StrFile,'file')
        rst = load(StrFile);
        fname = fieldnames(rst);
        StrData = rst.(fname{1});
    else
        StrFile = [path2 PartName '.csv'];
        StrData = importdata(StrFile);
    end

    CnntName = 'VBnm KJnt21';
    n = 21;
    SN = 'API_WJ_CP';
    CnntThk = PartThk;
    target = 125;

    data1 = sort_xyzdist (StrData,L_VBmidcan1, L_VBmidcan1+2000, KJnt12_Ctr);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'VBnm KJnt23';
    n = 22;
    SN = 'API_WJ_CP';
    CnntThk = PartThk;
    target = 125;

    data1 = sort_xyzdist (StrData,L_VBmidcan1, L_VBmidcan1+2000, KJnt23_Ctr);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
%% VBnm Col3
    PartName = 'VBnm Col3';
    PartThk = Thk.Nominal.VB2; %Part thickness
    StrFile = [path2 PartName '.mat'];
    if exist(StrFile,'file')
        rst = load(StrFile);
        fname = fieldnames(rst);
        StrData = rst.(fname{1});
    else
        StrFile = [path2 PartName '.csv'];
        StrData = importdata(StrFile);
    end

    CnntName = 'VBnm KJnt31';
    n = 23;
    SN = 'API_WJ_CP';
    CnntThk = PartThk;
    target = 125;

    data1 = sort_xyzdist (StrData,L_VBmidcan1, L_VBmidcan1+2000, KJnt13_Ctr);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'VBnm KJnt32';
    n = 24;
    SN = 'API_WJ_CP';
    CnntThk = PartThk;
    target = 125;

    data1 = sort_xyzdist (StrData,L_VBmidcan1, L_VBmidcan1+2000, KJnt23_Ctr);
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    close all
%% VBcan Col2
    PartName = 'VBcan Col2';
    StrFile = [path2 PartName '.mat'];
    if exist(StrFile,'file')
        rst = load(StrFile);
        fname = fieldnames(rst);
        StrData = rst.(fname{1});
    else
        StrFile = [path2 PartName '.csv'];
        StrData = importdata(StrFile);
    end

    CnntName = 'VB23 IS Col2';
    n = 25;
    SN = 'API_WJ_Air';
    CnntThk = Thk.Col2.VB23;
    target = 75;

    data1 = sort_xydist (StrData, R_IS_C2-tolerance, R_IS_C2+0.5*(R_OS_C2-R_IS_C2), Ctr_Col2(1), Ctr_Col2(2)); %IS connection
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'VB23 OS Col2';
    n = 26;
    SN = 'API_WJ_Air';
    CnntThk = Thk.Col2.VB23;
    target = 75;

    data1 = sort_xydist (StrData, R_IS_C1+0.5*(R_OS_C2-R_IS_C2), L_VBcolcan, Ctr_Col2(1), Ctr_Col2(2)); %OS connection
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

%% VBcan Col3
    PartName = 'VBcan Col3';
    StrFile = [path2 PartName '.mat'];
    if exist(StrFile,'file')
        rst = load(StrFile);
        fname = fieldnames(rst);
        StrData = rst.(fname{1});
    else
        StrFile = [path2 PartName '.csv'];
        StrData = importdata(StrFile);
    end

    CnntName = 'VB32 IS Col3';
    n = 27;
    SN = 'API_WJ_Air';
    CnntThk = Thk.Col2.VB23;
    target = 75;

    data1 = sort_xydist (StrData, R_IS_C2-tolerance, R_IS_C2+0.5*(R_OS_C2-R_IS_C2), Ctr_Col3(1), Ctr_Col3(2)); %IS connection
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);

    CnntName = 'VB32 OS Col3';
    n = 28;
    SN = 'API_WJ_Air';
    CnntThk = Thk.Col2.VB23;
    target = 75;

    data1 = sort_xydist (StrData, R_IS_C1+0.5*(R_OS_C2-R_IS_C2), L_VBcolcan, Ctr_Col3(1), Ctr_Col3(2)); %OS connection
    CnntData = data1;
    plot_TopBtm_FatigLife(CnntData,path3,CnntName,DotSize)
    Result{n} = FatigueResult(path1, GroupName, CnntData, CnntName, SN, CnntThk);
    CnntName1 = regexprep(CnntName,' ','_');
    Elem2run.(GroupName).(CnntName1) = ResultScreen(path1, GroupData, CnntData, CnntName, SN, CnntThk,target);
end
%% Save results
ResultFile = [path1 'Fatigue_Life_' GroupName '.mat'];
save(ResultFile,'Result')
ElemFile = [path1 GroupName '_ELem2Run.mat'];
save(ElemFile,'Elem2run')