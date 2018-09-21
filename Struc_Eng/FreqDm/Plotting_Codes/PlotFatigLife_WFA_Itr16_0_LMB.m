clc 
%clear all

%Plat fatigue life results

%Input
path1 = path_rst;

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

R_OS_C1 = 6000;
R_OS_C2 = 5750;
R_LMB = 1100;
R_UMB = 900;

L_LMBmidcan = 9700;
L_LMBcolcan = 8000; %Approximate number
L_UMBcolcan = 10000; %Approximate number
L_VBcolcan = 9500; %Approximate number
L_VBmidcan = 3900; %Approximate number

L_VBtotal = sqrt((EL_UMBtop-R_UMB-EL_LMBbtm-R_LMB)^2 + (ColSpace/2)^2);
L_VB = 23367-500;
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

tolerance1 = 30;

%% Truss_CG1/LMB_Can
% ------------------ First group - trusses cans -------------------------
GroupName = 'LMB_Can';
path2 = [path1 GroupName '\'];
if ~exist(path2,'dir')
    mkdir(path2)
end
StrFile = [path1 GroupName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path1 GroupName '.csv'];
    StrData = importdata(StrFile);
end

%% Truss_CG1 - All LMBs
data1 = sort_zval(StrData, Z_Keel, Z_Keel + EL_PlfmBtm); %All LMBs
%% Truss_CG1 - LMB mid (LMB can at KJoint)
% Part1 = 'LMB12 mid';
% 
% data2 = sort_yval(data1, YBound(2), YBound(1));
% Str_part1 = sort_xydist(data2, ColSpace/2-L_LMBmidcan/2, ColSpace/2+L_LMBmidcan/2, Ctr_Col1(1), Ctr_Col1(2));
% 
% FatigLife(1,:) = min(Str_part1(:,5:6));
% plot_TopBtm_FatigLife (Str_part1,path2,Part1,40)
% 
% OutputName = [path2,Part1,'.csv'];
% csvwrite(OutputName,Str_part1)
% OutputName1 = [path2,Part1,'.mat'];
% save(OutputName1,'Str_part1')
% 
% data2 = [];
% close all

% Part2 = 'LMB13 mid';
% 
% data2 = sort_yval(data1,YBound(3),YBound(2));
% Str_part2 = sort_xydist(data2, ColSpace/2-L_LMBmidcan/2, ColSpace/2+L_LMBmidcan/2, Ctr_Col1(1), Ctr_Col1(2));
% 
% FatigLife(2,:) = min(Str_part2(:,5:6));
% plot_TopBtm_FatigLife (Str_part2,path2,Part2,40)
% 
% OutputName = [path2,Part2,'.csv'];
% csvwrite(OutputName,Str_part2)
% OutputName1 = [path2,Part2,'.mat'];
% save(OutputName1,'Str_part2')
% 
% data2 = [];
% close all

% Part3 = 'LMB23 mid';
% 
% data2 = sort_xval(data1,XBound(3),XBound(2));
% Str_part3 = sort_yval(data2, -L_LMBmidcan/2,L_LMBmidcan/2);
% 
% FatigLife(3,:) = min(Str_part3(:,5:6));
% plot_TopBtm_FatigLife (Str_part3,path2,Part3,40)
% 
% OutputName = [path2,Part3,'.csv'];
% csvwrite(OutputName,Str_part3)
% OutputName1 = [path2,Part3,'.mat'];
% save(OutputName1,'Str_part3')
% 
% data2 = [];
% close all
%% Truss_CG1 - LMB can at columns
Part4 = 'LMB Col1';

Str_part4 = sort_xydist(data1, 0, L_LMBcolcan, Ctr_Col1(1), Ctr_Col1(2));
FatigLife(4,:) = min(Str_part4(:,5:6));
plot_TopBtm_FatigLife (Str_part4,path2,Part4,40)

OutputName = [path2,Part4,'.csv'];
csvwrite(OutputName,Str_part4)
OutputName1 = [path2,Part4,'.mat'];
save(OutputName1,'Str_part4')

data2 = [];
close all

Part5 = 'LMB Col2';

Str_part5 = sort_xydist(data1, 0,L_LMBcolcan, Ctr_Col2(1), Ctr_Col2(2));
FatigLife(5,:) = min(Str_part5(:,5:6));
plot_TopBtm_FatigLife (Str_part5,path2,Part5,40)

OutputName = [path2,Part5,'.csv'];
csvwrite(OutputName,Str_part5)
OutputName1 = [path2,Part5,'.mat'];
save(OutputName1,'Str_part5')

data2 = [];
close all

Part6 = 'LMB Col3';

Str_part6 = sort_xydist(data1, 0,L_LMBcolcan, Ctr_Col3(1), Ctr_Col3(2));
FatigLife(6,:) = min(Str_part6(:,5:6));
plot_TopBtm_FatigLife (Str_part6,path2,Part6,40)

OutputName = [path2,Part6,'.csv'];
csvwrite(OutputName,Str_part6)
OutputName1 = [path2,Part6,'.mat'];
save(OutputName1,'Str_part6')

data2 = [];
close all
data1 = [];

%% Truss_CG1 - All UMB/VBs
% data1 = sort_zval(StrData,ZBound(2),ZBound(1)); %All UMB/VBs

% Part7 = 'UMBVB Col1';
% 
% Str_part7 = sort_xydist(data1, 0, L_UMBcolcan, Ctr_Col1(1), Ctr_Col1(2));
% FatigLife(7,:) = min(Str_part7(:,5:6));
% plot_TopBtm_FatigLife (Str_part7,path2,Part7,40)
% 
% OutputName = [path2,Part7,'.csv'];
% csvwrite(OutputName,Str_part7)
% OutputName1 = [path2,Part7,'.mat'];
% save(OutputName1,'Str_part7')
% 
% close all

% Part8 = 'UMBVB Col2';
% 
% Str_part8 = sort_xydist(data1, 0,L_UMBcolcan, Ctr_Col2(1), Ctr_Col2(2));
% FatigLife(8,:) = min(Str_part8(:,5:6));
% plot_TopBtm_FatigLife (Str_part8,path2,Part8,40)
% 
% OutputName = [path2,Part8,'.csv'];
% csvwrite(OutputName,Str_part8)
% OutputName1 = [path2,Part8,'.mat'];
% save(OutputName1,'Str_part8')
% 
% close all

% Part9 = 'UMBVB Col3';
% 
% Str_part9 = sort_xydist(data1, 0,L_UMBcolcan, Ctr_Col3(1), Ctr_Col3(2));
% FatigLife(9,:) = min(Str_part9(:,5:6));
% plot_TopBtm_FatigLife (Str_part9,path2,Part9,40)
% 
% OutputName = [path2,Part9,'.csv'];
% csvwrite(OutputName,Str_part9)
% OutputName1 = [path2,Part9,'.mat'];
% save(OutputName1,'Str_part9')
% 
% close all
% data1=[];
% StrData = [];
%% Truss_CG2/LMB_Nominal
%--------------------------------------------------------------------------
GroupName = 'LMB_Nominal';
path2 = [path1 GroupName '\'];
if ~exist(path2,'dir')
    mkdir(path2)
end
StrFile = [path1 GroupName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path1 GroupName '.csv'];
    StrData = importdata(StrFile);
end
%% Truss_CG2 - All LMBs
data1 = sort_zval(StrData,Z_Keel, Z_Keel + EL_LMBbtm + R_LMB*2); %All LMBs

Part10 = 'LMBnm Col1';

Str_part10 = sort_xydist(data1, 0, ColSpace/2, Ctr_Col1(1), Ctr_Col1(2));
FatigLife(10,:) = min(Str_part10(:,5:6));
plot_TopBtm_FatigLife (Str_part10,path2,Part10,40)

OutputName = [path2,Part10,'.csv'];
csvwrite(OutputName,Str_part10)
OutputName1 = [path2,Part10,'.mat'];
save(OutputName1,'Str_part10')

close all

Part11 = 'LMBnm Col2';

Str_part11 = sort_xydist(data1, 0, ColSpace/2, Ctr_Col2(1), Ctr_Col2(2));
FatigLife(11,:) = min(Str_part11(:,5:6));
plot_TopBtm_FatigLife (Str_part11,path2,Part11,40)

OutputName = [path2,Part11,'.csv'];
csvwrite(OutputName,Str_part11)
OutputName1 = [path2,Part11,'.mat'];
save(OutputName1,'Str_part11')


close all

Part12 = 'LMBnm Col3';

Str_part12 = sort_xydist(data1, 0, ColSpace/2, Ctr_Col3(1), Ctr_Col3(2));
FatigLife(12,:) = min(Str_part12(:,5:6));
plot_TopBtm_FatigLife (Str_part12,path2,Part12,40)

OutputName = [path2,Part12,'.csv'];
csvwrite(OutputName,Str_part12)
OutputName1 = [path2,Part12,'.mat'];
save(OutputName1,'Str_part12')

close all
data1=[];

%% Truss_CG2 - All UMBs
% data1 = sort_zval(StrData, Z_Keel + EL_UMBtop - R_UMB*2, ZBound(1) ); %All UMBs
% 
% Part13 = 'UMBnm Col1';
% 
% Str_part13 = sort_xydist(data1, 0, ColSpace/2, Ctr_Col1(1), Ctr_Col1(2));
% FatigLife(13,:) = min(Str_part13(:,5:6));
% plot_TopBtm_FatigLife (Str_part13,path1,Part13,40)
% 
% OutputName = [path1,Part13,'.csv'];
% csvwrite(OutputName,Str_part13)
% 
% close all

% Part14 = 'UMBnm Col2';
% 
% Str_part14 = sort_xydist(data1,  0, ColSpace/2, Ctr_Col2(1), Ctr_Col2(2));
% FatigLife(14,:) = min(Str_part14(:,5:6));
% plot_TopBtm_FatigLife (Str_part14,path1,Part14,40)
% 
% OutputName = [path1,Part14,'.csv'];
% csvwrite(OutputName,Str_part14)
% 
% close all

% Part15 = 'UMBnm Col3';
% 
% Str_part15 = sort_xydist(data1,  0, ColSpace/2, Ctr_Col3(1), Ctr_Col3(2));
% FatigLife(15,:) = min(Str_part15(:,5:6));
% plot_TopBtm_FatigLife (Str_part15,path1,Part15,40)
% 
% OutputName = [path1,Part15,'.csv'];
% csvwrite(OutputName,Str_part15)
% 
% close all
% data1=[];
%% Truss_CG2 - All upper VBs
% data1 = sort_zval(StrData, Z_Keel+EL_LMBbtm+R_LMB*2 , Z_Keel+EL_UMBtop-R_UMB*2); %All upper VBs
% 
% Part16 = 'VBnm Col1';
% 
% Str_part16 = sort_xyzdist(data1, L_VBcolcan1, L_VB+L_VBcolcan1+tolerance1, TrussCtr_Col1);
% FatigLife(16,:) = min(Str_part16(:,5:6));
% plot_TopBtm_FatigLife (Str_part16,path2,Part16,40)
% 
% OutputName = [path2,Part16,'.csv'];
% csvwrite(OutputName,Str_part16)
% OutputName1 = [path2,Part16,'.mat'];
% save(OutputName1,'Str_part16')
% 
% close all
% 
% Part17 = 'VBnm Col2';
% 
% Str_part17 = sort_xyzdist(data1,L_VBcolcan, L_VB+L_VBcolcan+tolerance1, TrussCtr_Col2);
% FatigLife(17,:) = min(Str_part17(:,5:6));
% plot_TopBtm_FatigLife (Str_part17,path2,Part17,40)
% 
% OutputName = [path2,Part17,'.csv'];
% csvwrite(OutputName,Str_part17)
% OutputName1 = [path2,Part17,'.mat'];
% save(OutputName1,'Str_part17')
% 
% close all
% 
% Part18 = 'VBnm Col3';
% 
% Str_part18 = sort_xyzdist(data1, L_VBcolcan, L_VB+L_VBcolcan+tolerance1, TrussCtr_Col3);
% FatigLife(18,:) = min(Str_part18(:,5:6));
% plot_TopBtm_FatigLife (Str_part18,path2,Part18,40)
% 
% OutputName = [path2,Part18,'.csv'];
% csvwrite(OutputName,Str_part18)
% OutputName1 = [path2,Part18,'.mat'];
% save(OutputName1,'Str_part18')
% 
% close all
% data1=[];
%% Truss_CG2 - All lwr VBs
% data1 = sort_zval(StrData, Z_Keel+EL_LMBbtm+R_LMB, Z_Keel+EL_LMBbtm+R_LMB+L_VBmidcan); %All lwr VBs and part LMBs
% 
% Part19 = 'VBlwr 12';
% 
% data2 = sort_yval(data1,YBound(2),YBound(1));
% Str_part19 = sort_xyzdist(data2,0, L_VBmidcan1+tolerance1, KJnt12_Ctr);
% FatigLife(19,:) = min(Str_part19(:,5:6));
% plot_TopBtm_FatigLife (Str_part19,path2,Part19,40)
% 
% OutputName = [path2,Part19,'.csv'];
% csvwrite(OutputName,Str_part19)
% OutputName1 = [path2,Part19,'.mat'];
% save(OutputName1,'Str_part19')
% 
% close all
% data2=[];
% 
% Part20 = 'VBlwr 13';
% 
% data2 = sort_yval(data1,YBound(3),YBound(2));
% Str_part20 = sort_xyzdist(data2,0, L_VBmidcan1+tolerance1, KJnt13_Ctr);
% FatigLife(20,:) = min(Str_part20(:,5:6));
% plot_TopBtm_FatigLife (Str_part20,path2,Part20,40)
% 
% OutputName = [path2,Part20,'.csv'];
% csvwrite(OutputName,Str_part20)
% OutputName1 = [path2,Part20,'.mat'];
% save(OutputName1,'Str_part20')
% 
% close all
% data2=[];
% 
% Part21 = 'VBlwr 23';
% 
% data2 = sort_xval(data1,XBound(3),XBound(2));
% Str_part21 = sort_xyzdist(data2,0, L_VBmidcan1+tolerance1, KJnt23_Ctr);
% FatigLife(21,:) = min(Str_part21(:,5:6));
% plot_TopBtm_FatigLife (Str_part21,path2,Part21,40)
% 
% OutputName = [path2,Part21,'.csv'];
% csvwrite(OutputName,Str_part21)
% OutputName1 = [path2,Part21,'.mat'];
% save(OutputName1,'Str_part21')
% 
% close all
% data2=[];
% ------------------ End of first group ---------------------------
% ------------------ Second group:  IS ----------------------------

%% IS_CG1
% GroupName = 'IS_CG1';
% path2 = [path1 GroupName '\'];
% if ~exist(path2,'dir')
%     mkdir(path2)
% end
% StrFile = [path1 GroupName '.mat'];
% if exist(StrFile,'file')
%     rst = load(StrFile);
%     fname = fieldnames(rst);
%     StrData = rst.(fname{1});
% else
%     StrFile = [path1 GroupName '.csv'];
%     StrData = importdata(StrFile);
% end

% data1 = sort_xval(StrData, Ctr_Col1(1)-R_OS_C1, Ctr_Col1(1)+R_OS_C1); %Col1
% 
% Part201 = 'IStop Col1';
% Str_part201 = data1;
% FatigLife2(1,:) = min(Str_part201(:,5:6));
% plot_TopBtm_FatigLife (Str_part201,path2,Part201,40)
% 
% OutputName = [path2,Part201,'.csv'];
% csvwrite(OutputName,Str_part201)
% OutputName1 = [path2,Part201,'.mat'];
% save(OutputName1,'Str_part201')
% 
% close all
% data1 =[];
% StrData = [];

%% IS_CG2 - IS_Bot Col1
GroupName = 'IS_Bot';
path2 = [path1 GroupName '\'];
if ~exist(path2,'dir')
    mkdir(path2)
end
StrFile = [path1 GroupName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path1 GroupName '.csv'];
    StrData = importdata(StrFile);
end

data1 = sort_xval(StrData,XBound(2),XBound(1)); %Col1

Part204 = 'ISbtm Col1';
Str_part204 = sort_zval(data1,Z_Keel,Z_Keel+EL_PlfmBtm);
FatigLife2(4,:) = min(Str_part204(:,5:6));
plot_TopBtm_FatigLife (Str_part204,path2,Part204,40)

OutputName = [path2,Part204,'.csv'];
csvwrite(OutputName,Str_part204)
OutputName1 = [path2,Part204,'.mat'];
save(OutputName1,'Str_part204')

close all
%% IS_CG2 - IS_mid Col1
% Part205 = 'ISmid Col1';
% Str_part205 = sort_zval(data1,Z_Keel+EL_PlfmBtm,ZBound(1));
% FatigLife2(5,:) = min(Str_part205(:,5:6));
% plot_TopBtm_FatigLife (Str_part205,path2,Part205,40)
% 
% OutputName = [path2,Part205,'.csv'];
% csvwrite(OutputName,Str_part205)
% OutputName1 = [path2,Part205,'.mat'];
% save(OutputName1,'Str_part205')
% 
% close all
% data1=[];

%% IS_CG2 - IS Col2/3
data1 = sort_xval(StrData,XBound(3),XBound(2)); %Col2&3
data2 = sort_yval(data1,YBound(2),YBound(1)); %Col2
%% IS_CG2 - IS top Col2
% Part202 = 'IStop Col2';
% Str_part202 = sort_zval(data2, ZBound(2), ZBound(1));
% FatigLife2(2,:) = min(Str_part202(:,5:6));
% plot_TopBtm_FatigLife (Str_part202,path2,Part202,40)
% 
% OutputName = [path2,Part202,'.csv'];
% csvwrite(OutputName,Str_part202)
% OutputName1 = [path2,Part202,'.mat'];
% save(OutputName1,'Str_part202')
% 
% close all
%% IS_CG2 - IS bot Col2
Part206 = 'ISbtm Col2';
Str_part206 = sort_zval(data2, Z_Keel, ZBound(2));
FatigLife2(6,:) = min(Str_part206(:,5:6));
plot_TopBtm_FatigLife (Str_part206,path2,Part206,40)

OutputName = [path2,Part206,'.csv'];
csvwrite(OutputName,Str_part206)
OutputName1 = [path2,Part206,'.mat'];
save(OutputName1,'Str_part206')

close all
data2 = [];
%% IS_CG2 - IS Col3
data2 = sort_yval(data1,YBound(3),YBound(2)); %Col3
%% IS_CG2 - IS top Col3
% Part203 = 'IStop Col3';
% Str_part203 = sort_zval(data2,ZBound(2), ZBound(1));
% FatigLife2(3,:) = min(Str_part203(:,5:6));
% plot_TopBtm_FatigLife (Str_part203,path2,Part203,40)
% 
% OutputName = [path2,Part203,'.csv'];
% csvwrite(OutputName,Str_part203)
% OutputName1 = [path2,Part203,'.mat'];
% save(OutputName1,'Str_part203')
% 
% close all

%% IS_CG2 - IS bot Col3
Part207 = 'ISbtm Col3';
Str_part207 = sort_zval(data2, Z_Keel, ZBound(2));
FatigLife2(7,:) = min(Str_part207(:,5:6));
plot_TopBtm_FatigLife (Str_part207,path2,Part207,40)

OutputName = [path2,Part207,'.csv'];
csvwrite(OutputName,Str_part207)
OutputName1 = [path2,Part207,'.mat'];
save(OutputName1,'Str_part207')

close all
data1=[];
StrData=[];

% ------------------ End of second group ---------------------------
% ------------------ Third group:  OS ----------------------------
%% OS_CG1
% GroupName = 'OS_CG1';
% path2 = [path1 GroupName '\'];
% if ~exist(path2,'dir')
%     mkdir(path2)
% end
% StrFile = [path1 GroupName '.mat'];
% if exist(StrFile,'file')
%     rst = load(StrFile);
%     fname = fieldnames(rst);
%     StrData = rst.(fname{1});
% else
%     StrFile = [path1 GroupName '.csv'];
%     StrData = importdata(StrFile);
% end

% Part301 = 'OStop Col1';
% 
% FatigLife3(1,:) = min(StrData(:,5:6));
% plot_TopBtm_FatigLife (StrData,path2,Part301,40)
% 
% OutputName = [path2,Part301,'.csv'];
% csvwrite(OutputName,StrData)
% OutputName1 = [path2,Part301,'.mat'];
% save(OutputName1,'StrData')
% 
% close all
% StrData =[];

%% OS_CG2
GroupName = 'OS_Bot';
path2 = [path1 GroupName '\'];
if ~exist(path2,'dir')
    mkdir(path2)
end
StrFile = [path1 GroupName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path1 GroupName '.csv'];
    StrData = importdata(StrFile);
end

data1 = sort_xval(StrData,XBound(2),XBound(1)); %Col1
%% OS_CG2 - OSbtm Col1
Part302 = 'OSbtm Col1';
Str_part302 = sort_zval(data1,Z_Keel,Z_Keel+EL_PlfmBtm);
FatigLife3(2,:) = min(Str_part302(:,5:6));
plot_TopBtm_FatigLife (Str_part302,path2,Part302,40)

OutputName = [path2,Part302,'.csv'];
csvwrite(OutputName,Str_part302)
OutputName1 = [path2,Part302,'.mat'];
save(OutputName1,'Str_part302')

close all
%% OS_CG2 - OSmid Col1
% Part303 = 'OSmid Col1';
% Str_part303 = sort_zval(data1,Z_Keel+EL_PlfmBtm,ZBound(1));
% FatigLife3(3,:) = min(Str_part303(:,5:6));
% plot_TopBtm_FatigLife (Str_part303,path2,Part303,40)
% 
% OutputName = [path2,Part303,'.csv'];
% csvwrite(OutputName,Str_part303)
% OutputName1 = [path2,Part303,'.mat'];
% save(OutputName1,'Str_part303')
% 
% close all
% data1=[];
%% OS_CG2 - OSbtm Col2
data1 = sort_xval(StrData,XBound(3),XBound(2)); %Col2&3
data2 = sort_yval(data1,YBound(2),YBound(1));%Col2

Part304 = 'OSbtm Col2';
Str_part304 = sort_zval(data2,Z_Keel,Z_Keel+EL_PlfmBtm);
FatigLife3(4,:) = min(Str_part304(:,5:6));
plot_TopBtm_FatigLife (Str_part304,path2,Part304,40)

OutputName = [path2,Part304,'.csv'];
csvwrite(OutputName,Str_part304)
OutputName1 = [path2,Part304,'.mat'];
save(OutputName1,'Str_part304')

close all
%% OS_CG2 - OStop Col2
% Part305 = 'OStop Col2';
% Str_part305 = sort_zval(data2,ZBound(2),ZBound(1));
% FatigLife3(5,:) = min(Str_part305(:,5:6));
% plot_TopBtm_FatigLife (Str_part305,path2,Part305,40)
% 
% OutputName = [path2,Part305,'.csv'];
% csvwrite(OutputName,Str_part305)
% OutputName1 = [path2,Part305,'.mat'];
% save(OutputName1,'Str_part305')
% 
% close all
%% OS_CG2 - OSmid Col2
% Part306 = 'OSmid Col2';
% Str_part306 = sort_zval(data2,Z_Keel+EL_PlfmBtm,ZBound(2));
% FatigLife3(6,:) = min(Str_part306(:,5:6));
% plot_TopBtm_FatigLife (Str_part306,path2,Part306,40)
% 
% OutputName = [path2,Part306,'.csv'];
% csvwrite(OutputName,Str_part306)
% OutputName1 = [path2,Part306,'.mat'];
% save(OutputName1,'Str_part306')
% 
% close all
% data2 = [];
%% OS_CG2 - OSbtm Col3
data2 = sort_yval(data1,YBound(3),YBound(2));%Col3

Part307 = 'OSbtm Col3';
Str_part307 = sort_zval(data2,Z_Keel,Z_Keel+EL_PlfmBtm);
FatigLife3(7,:) = min(Str_part307(:,5:6));
plot_TopBtm_FatigLife (Str_part307,path2,Part307,40)

OutputName = [path2,Part307,'.csv'];
csvwrite(OutputName,Str_part307)
OutputName1 = [path2,Part307,'.mat'];
save(OutputName1,'Str_part307')

close all
%% OS_CG2 - OStop Col3
% Part308 = 'OStop Col3';
% Str_part308 = sort_zval(data2,ZBound(2),ZBound(1));
% FatigLife3(8,:) = min(Str_part308(:,5:6));
% plot_TopBtm_FatigLife (Str_part308,path2,Part308,40)
% 
% OutputName = [path2,Part308,'.csv'];
% csvwrite(OutputName,Str_part308)
% OutputName1 = [path2,Part308,'.mat'];
% save(OutputName1,'Str_part308')
% 
% close all
%% OS_CG2 - OSmid Col3
% Part309 = 'OSmid Col3';
% Str_part309 = sort_zval(data2,Z_Keel+EL_PlfmBtm,ZBound(2));
% FatigLife3(9,:) = min(Str_part309(:,5:6));
% plot_TopBtm_FatigLife (Str_part309,path2,Part309,40)
% 
% OutputName = [path2,Part309,'.csv'];
% csvwrite(OutputName,Str_part309)
% OutputName1 = [path2,Part309,'.mat'];
% save(OutputName1,'Str_part309')
% 
% close all
% data2 = [];
% data1 = [];

% ------------------ End of third group ---------------------------
% ------------------ Fourth group:  WEP ----------------------------
%% WEP_CG1
% GroupName = 'WEP_CG1';
% StrFile = [path1 GroupName '.csv'];
% StrData = importdata(StrFile);
% 
% 
% Part401 = 'WEP Col1';
% 
% Str_part401 = sort_xval(StrData,-25000,10000); %Col1
% FatigLife4(1,:) = min(Str_part401(:,5:6));
% plot2d_TopBtm_FatigLife (Str_part401,path1,Part401,40)
% 
% OutputName = [path1,Part401,'.csv'];
% csvwrite(OutputName,Str_part401)
% 
% close all
% 
% data1 = sort_xval(StrData,-70000,-25000); %Col2&3
% 
% Part402 = 'WEP Col2';
% 
% Str_part402 = sort_yval(data1,0,70000); %Col2
% FatigLife4(2,:) = min(Str_part402(:,5:6));
% plot2d_TopBtm_FatigLife (Str_part402,path1,Part402,40)
% 
% OutputName = [path1,Part402,'.csv'];
% csvwrite(OutputName,Str_part402)
% 
% close all
% 
% Part403 = 'WEP Col3';
% 
% Str_part403 = sort_yval(data1,-70000,0); %Col3
% FatigLife4(3,:) = min(Str_part403(:,5:6));
% plot2d_TopBtm_FatigLife (Str_part403,path1,Part403,40)
% 
% OutputName = [path1,Part403,'.csv'];
% csvwrite(OutputName,Str_part403)
% 
% close all
% data1 = [];
% StrData = [];

% ------------------ End of fourth group ---------------------------
% ------------------ Fifth group:  Flats ----------------------------
%% Flat_CG1
% GroupName = 'Flat_CG1';
% StrFile = [path1 GroupName '.csv'];
% StrData = importdata(StrFile);
% 
% Part501 = 'Flat Top Col1';
% 
% Str_part501 = StrData; %Col3
% FatigLife5(1,:) = min(Str_part501(:,5:6));
% plot2d_TopBtm_FatigLife (Str_part501,path1,Part501,40)
% 
% OutputName = [path1,Part501,'.csv'];
% csvwrite(OutputName,Str_part501)
% 
% close all
% StrData = [];
%% OS1_KL
% GroupName = 'OS1_KL';
% StrFile = [path1 GroupName '.csv'];
% StrData = importdata(StrFile);
% 
% Part504 = 'Flat keel Col1';
% Str_part504 = sort_zval(StrData,Z_Keel,Z_Keel+tolerance1);
% FatigLife5(4,:) = min(Str_part504(:,5:6));
% plot2d_TopBtm_FatigLife (Str_part504,path1,Part504,40)
% 
% OutputName = [path1,Part504,'.csv'];
% csvwrite(OutputName,Str_part504)
% 
% GroupName = 'OS2_KL';
% StrFile = [path1 GroupName '.csv'];
% StrData = importdata(StrFile);
% 
% Part506 = 'Flat keel Col2';
% Str_part506 = sort_zval(StrData,Z_Keel,Z_Keel+tolerance1);
% FatigLife5(6,:) = min(Str_part506(:,5:6));
% plot2d_TopBtm_FatigLife (Str_part506,path1,Part506,40)
% 
% OutputName = [path1,Part506,'.csv'];
% csvwrite(OutputName,Str_part506)
% 
% GroupName = 'OS3_KL';
% StrFile = [path1 GroupName '.csv'];
% StrData = importdata(StrFile);
% 
% Part508 = 'Flat keel Col3';
% Str_part508 = sort_zval(StrData,Z_Keel,Z_Keel+tolerance1);
% FatigLife5(8,:) = min(Str_part508(:,5:6));
% plot2d_TopBtm_FatigLife (Str_part508,path1,Part508,40)
% 
% OutputName = [path1,Part508,'.csv'];
% csvwrite(OutputName,Str_part508)
% 
% close all
% StrData = [];

% ------------------ End of fifth group ---------------------------
% ------------------ Fifth group:  Rings & Vbars ----------------------------
%% RingVbar_CG1 / LMB_Rings
GroupName = 'LMB_Rings';
path2 = [path1 GroupName '\'];
if ~exist(path2,'dir')
    mkdir(path2)
end
StrFile = [path1 GroupName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path1 GroupName '.csv'];
    StrData = importdata(StrFile);
end
%% RingVbar_CG1 - IS rings
% data1 =  sort_xydist(StrData,0,R_OS_C1, Ctr_Col1(1),Ctr_Col1(2) ); %Col1
% 
% Part601 = 'ISring Col1';
% Str_part601 = data1;
% FatigLife6(1,:) = min(Str_part601(:,5:6));
% plot_TopBtm_FatigLife (Str_part601,path2,Part601,40)
% 
% OutputName = [path2,Part601,'.csv'];
% csvwrite(OutputName,Str_part601)
% OutputName1 = [path2,Part601,'.mat'];
% save(OutputName1,'Str_part601')
% 
% data1 = [];
% close all
% 
% data1 =  sort_xydist(StrData,0,R_OS_C2, Ctr_Col2(1),Ctr_Col2(2) ); %Col2
%data2 = sort_yval(data1,0,50000);%Col2

% Part602 = 'ISring Vbar Col2';
% Str_part602 = data1;
% FatigLife6(2,:) = min(Str_part602(:,5:6));
% plot_TopBtm_FatigLife (Str_part602,path2,Part602,40)
% 
% OutputName = [path2,Part602,'.csv'];
% csvwrite(OutputName,Str_part602)
% OutputName1 = [path2,Part602,'.mat'];
% save(OutputName1,'Str_part602')
% 
% data1 = [];
% close all
% 
% data1 =  sort_xydist(StrData,0,R_OS_C2, Ctr_Col3(1),Ctr_Col3(2) ); %Col3
% 
% Part603 = 'ISring Vbar Col3';
% Str_part603 = data1;
% FatigLife6(3,:) = min(Str_part603(:,5:6));
% plot_TopBtm_FatigLife (Str_part603,path2,Part603,40)
% 
% OutputName = [path2,Part603,'.csv'];
% csvwrite(OutputName,Str_part603)
% OutputName1 = [path2,Part603,'.mat'];
% save(OutputName1,'Str_part603')
% 
% data2 = [];
% data1 = [];
% close all
%% RingVbar_CG1 - LMB rings
data1 = sort_zval(StrData,Z_Keel, Z_Keel+EL_PlfmBtm); %LMB rings

data2 = sort_yval(data1,YBound(2),YBound(1)); %Col1to2 side
data3 = sort_xval(data2,KJnt23_Ctr(1)+R_LMB,XBound(1));

Part604 = 'LMB12 rings';
Str_part604 = sort_xydist(data3,L_LMBcolcan, ColSpace-L_LMBcolcan, Ctr_Col1(1), Ctr_Col1(2));
FatigLife6(4,:) = min(Str_part604(:,5:6));
plot_TopBtm_FatigLife (Str_part604,path2,Part604,40)

OutputName = [path2,Part604,'.csv'];
csvwrite(OutputName,Str_part604)
OutputName1 = [path2,Part604,'.mat'];
save(OutputName1,'Str_part604')

data2 = [];
data3 = [];
close all

data2 = sort_yval(data1,YBound(3),YBound(2)); %Col1to3 side
data3 = sort_xval(data2,KJnt23_Ctr(1)+R_LMB,XBound(1));

Part605 = 'LMB13 rings';
Str_part605 = sort_xydist(data3,L_LMBcolcan, ColSpace-L_LMBcolcan, Ctr_Col1(1), Ctr_Col1(2));
FatigLife6(5,:) = min(Str_part605(:,5:6));
plot_TopBtm_FatigLife (Str_part605,path2,Part605,40)

OutputName = [path2,Part605,'.csv'];
csvwrite(OutputName,Str_part605)
OutputName1 = [path2,Part605,'.mat'];
save(OutputName1,'Str_part605')

data2 = [];
close all

data2 = sort_xval(data1,KJnt23_Ctr(1)-R_LMB,KJnt23_Ctr(1)+R_LMB); %Col2to3 side

Part606 = 'LMB23 rings';
Str_part606 = sort_yval(data2,-(ColSpace/2-L_LMBcolcan), ColSpace/2-L_LMBcolcan);
FatigLife6(6,:) = min(Str_part606(:,5:6));
plot_TopBtm_FatigLife (Str_part606,path2,Part606,40)

OutputName = [path2,Part606,'.csv'];
csvwrite(OutputName,Str_part606)
OutputName1 = [path2,Part606,'.mat'];
save(OutputName1,'Str_part606')

data2 = [];
close all
StrData = [];

% ------------------ End of sixth group ---------------------------
%% RingVbar_CG2 / LMB_FB
% ------------------ Seven group - RingVbar 2 -------------------------
GroupName = 'LMB_FB';
path2 = [path1 GroupName '\'];
if ~exist(path2,'dir')
    mkdir(path2)
end
StrFile = [path1 GroupName '.mat'];
if exist(StrFile,'file')
    rst = load(StrFile);
    fname = fieldnames(rst);
    StrData = rst.(fname{1});
else
    StrFile = [path1 GroupName '.csv'];
    StrData = importdata(StrFile);
end

Part701 = 'FB Col1';

Str_part701 = sort_xydist(StrData, 0, ColSpace/2, Ctr_Col1(1), Ctr_Col1(2));
FatigLife7(1,:) = min(Str_part701(:,5:6));
plot_TopBtm_FatigLife (Str_part701,path2,Part701,40)

OutputName = [path2,Part701,'.csv'];
csvwrite(OutputName,Str_part701)
OutputName1 = [path2,Part701,'.mat'];
save(OutputName1,'Str_part701')

close all

Part702 = 'FB Col2';

Str_part702 = sort_xydist(StrData, 0, ColSpace/2, Ctr_Col2(1), Ctr_Col2(2));
FatigLife7(2,:) = min(Str_part702(:,5:6));
plot_TopBtm_FatigLife (Str_part702,path2,Part702,40)

OutputName = [path2,Part702,'.csv'];
csvwrite(OutputName,Str_part702)
OutputName1 = [path2,Part702,'.mat'];
save(OutputName1,'Str_part702')

close all

Part703 = 'FB Col3';

Str_part703 = sort_xydist(StrData, 0, ColSpace/2, Ctr_Col3(1), Ctr_Col3(2));
FatigLife7(3,:) = min(Str_part703(:,5:6));
plot_TopBtm_FatigLife (Str_part703,path2,Part703,40)

OutputName = [path2,Part703,'.csv'];
csvwrite(OutputName,Str_part703)
OutputName1 = [path2,Part703,'.mat'];
save(OutputName1,'Str_part703')

close all
%% Bkh_CG1
%------------------ Eighth group - Bulkheads -------------------------
% GroupName = 'Bkh_CG1';
% StrFile = [path1 GroupName '.csv'];
% StrData = importdata(StrFile);
% 
% Part801 = 'Bkh Col1';
% Str_part801 = sort_xval(StrData,XBound(2),XBound(1));
% FatigLife8(1,:) = min(Str_part801(:,5:6));
% plot_TopBtm_FatigLife (Str_part801,path1,Part801,40)
% 
% OutputName = [path1,Part801,'.csv'];
% csvwrite(OutputName,Str_part801)

% data1 = sort_xval(StrData,XBound(3),XBound(2)); %Col 2&3
% 
% Part802 = 'Bkh Col2';
% Str_part802 = sort_yval(data1,YBound(2),YBound(1));
% FatigLife8(2,:) = min(Str_part802(:,5:6));
% plot_TopBtm_FatigLife (Str_part802,path1,Part802,40)
% 
% OutputName = [path1,Part802,'.csv'];
% csvwrite(OutputName,Str_part802)

% Part803 = 'Bkh Col3';
% Str_part803 = sort_yval(data1,YBound(3),YBound(2));
% FatigLife8(3,:) = min(Str_part803(:,5:6));
% plot_TopBtm_FatigLife (Str_part803,path1,Part803,40)
% 
% OutputName = [path1,Part803,'.csv'];
% csvwrite(OutputName,Str_part803)

%% OSRG_CG1
%------------------ Eighth group - OS ring girders -------------------------
% GroupName = 'OSRG_CG1';
% StrFile = [path1 GroupName '.csv'];
% StrData = importdata(StrFile);
% 
% Part901 = 'OSRG Col1';
% Str_part901 = sort_xval(StrData,XBound(2),XBound(1));
% FatigLife9(1,:) = min(Str_part901(:,5:6));
% plot_TopBtm_FatigLife (Str_part901,path1,Part901,40)
% 
% OutputName = [path1,Part901,'.csv'];
% csvwrite(OutputName,Str_part901)

% data1 = sort_xval(StrData,XBound(3),XBound(2)); %Col 2&3
% 
% Part902 = 'OSRG Col2';
% Str_part902 = sort_yval(data1,YBound(2),YBound(1));
% FatigLife9(2,:) = min(Str_part902(:,5:6));
% plot_TopBtm_FatigLife (Str_part902,path1,Part902,40)
% 
% OutputName = [path1,Part902,'.csv'];
% csvwrite(OutputName,Str_part902)

% Part903 = 'OSRG Col3';
% Str_part903 = sort_yval(data1,YBound(3),YBound(2));
% FatigLife9(3,:) = min(Str_part903(:,5:6));
% plot_TopBtm_FatigLife (Str_part903,path1,Part903,40)
% 
% OutputName = [path1,Part903,'.csv'];
% csvwrite(OutputName,Str_part903)
%% KFGdr_CG1
%------------------ Eighth group - Keel flat girders -------------------------
% GroupName = 'KFGdr_CG1';
% StrFile = [path1 GroupName '.csv'];
% StrData = importdata(StrFile);
% 
% Part1001 = 'KFGdr Col1';
% Str_part1001 = sort_xval(StrData,XBound(2),XBound(1));
% FatigLife10(1,:) = min(Str_part1001(:,5:6));
% plot_TopBtm_FatigLife (Str_part1001,path1,Part1001,40)
% 
% OutputName = [path1,Part1001,'.csv'];
% csvwrite(OutputName,Str_part1001)

% data1 = sort_xval(StrData,XBound(3),XBound(2)); %Col 2&3
% 
% Part1002 = 'KFGdr Col2';
% Str_part1002 = sort_yval(data1,YBound(2),YBound(1));
% FatigLife10(2,:) = min(Str_part1002(:,5:6));
% plot_TopBtm_FatigLife (Str_part1002,path1,Part1002,40)
% 
% OutputName = [path1,Part1002,'.csv'];
% csvwrite(OutputName,Str_part1002)

% Part1003 = 'KFGdr Col3';
% Str_part1003 = sort_yval(data1,YBound(3),YBound(2));
% FatigLife10(3,:) = min(Str_part1003(:,5:6));
% plot_TopBtm_FatigLife (Str_part1003,path1,Part1003,40)
% 
% OutputName = [path1,Part1003,'.csv'];
% csvwrite(OutputName,Str_part1003)

