clc
% clear all

%Connection information of WFA model
%General path for data
%path0='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 

%%% SN: SN curve reference
%%% int: sampling one of every interval number of nodes
%%% path: coordinates of each point on the path
% - Column no. of the data the sampling based on



%% ItrR5_15_4 (Col1_Top)
ItrNo = 'ItrR5_15_4';
path1 = [path0 ItrNo '\'];
load([path1 'thickness.mat']);

Cnnt.Itr = ItrNo;

%Line1 - TB*IS*TF
Cnnt.L1.SN = 'ABS_E_Air';
Cnnt.L1.group = 'circ';
Cnnt.L1.axis = 'y';

Cnnt.L1.TB.thk = Thk.Col1.TB;
Cnnt.L1.TB.int = 3;
Cnnt.L1.TB.axisTT = 'x'; %through-thickness axis

Cnnt.L1.TF.thk = Thk.Col1.TFin;
Cnnt.L1.TF.int = 10;
Cnnt.L1.TF.axisTT = 'z'; %through-thickness axis

Cnnt.L1.TOCring.thk = Thk.Col1.TFin;
Cnnt.L1.TOCring.int = 10;
Cnnt.L1.TOCring.axisTT = 'z';

%Line2 - IS*UMB12
Cnnt.L2.SN = 'API_WJ_Air';
Cnnt.L2.group = 'circ';
Cnnt.L2.axis = 'y';

Cnnt.L2.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L2.IS.int = 2;
Cnnt.L2.IS.axisTT = 'x';
Cnnt.L2.IS.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L2.IS.HspTol = 0.5; %Tolerance in hot spot sampling

Cnnt.L2.UMB12.thk = Thk.Col1.UMB;
Cnnt.L2.UMB12.int = 3;
Cnnt.L2.UMB12.axisTT = 'x';
Cnnt.L2.UMB12.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L2.UMB12.HspTol = 0.5; 

%Line3 - IS*VB12
Cnnt.L3.SN = 'API_WJ_Air';
Cnnt.L3.group = 'circ';
Cnnt.L3.axis = 'y';

Cnnt.L3.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L3.IS.axisTT = 'x';
Cnnt.L3.IS.int = 2;
Cnnt.L3.IS.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L3.IS.HspTol = 0.5;

Cnnt.L3.VB12.thk = Thk.Col1.VB;
Cnnt.L3.VB12.axisTT = 'x';
Cnnt.L3.VB12.int = 3;
Cnnt.L3.VB12.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L3.VB12.HspTol = 0.5;

%Line4 - IS*BKHs
Cnnt.L4.SN = 'ABS_E_Air';
Cnnt.L4.group = 'rad';
Cnnt.L4.axis_c = 'y';
Cnnt.L4.axis_r = 'z';

Cnnt.L4.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L4.IS.axisTT = 'x';
Cnnt.L4.IS.int = 5;
Cnnt.L4.IS.HspAxis = 'z';
Cnnt.L4.IS.Hsp = [5585, 6900,7550.3,8300,9311,9700,10700,10844,11800,12356];
Cnnt.L4.IS.HspTol = 10;

%Line5 - OS*TF
Cnnt.L5.SN = 'ABS_E_Air';
Cnnt.L5.group = 'circ';
Cnnt.L5.axis = 'y';

Cnnt.L5.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L5.OS.axisTT = 'x';
Cnnt.L5.OS.int = 20;
Cnnt.L5.OS.HspThk = Thk.Col1.OSatUMB ;
Cnnt.L5.OS.Hsp = [-150,150];
Cnnt.L5.OS.HspTol = 7.5;

Cnnt.L5.TF.thk = Thk.Col1.TFout;
Cnnt.L5.TF.axisTT = 'z';
Cnnt.L5.TF.int = 20;
Cnnt.L5.TF.HspThk = Thk.Col1.TFatUMB ;
Cnnt.L5.TF.Hsp = [-150,150];
Cnnt.L5.TF.HspTol = 7.5;

%Line6 - OS*UMB12
Cnnt.L6.SN = 'API_WJ_Air';
Cnnt.L6.group = 'circ';
Cnnt.L6.axis = 'y';

Cnnt.L6.OS.thk = Thk.Col1.OSatUMB;
Cnnt.L6.OS.axisTT = 'x';
Cnnt.L6.OS.int = 3;

Cnnt.L6.UMB12.thk = Thk.Col1.UMB;
Cnnt.L6.UMB12.axisTT = 'x';
Cnnt.L6.UMB12.int = 3;

%Line7 - OS*VB12
Cnnt.L7.SN = 'API_WJ_Air';
Cnnt.L7.group = 'circ';
Cnnt.L7.axis = 'y';

Cnnt.L7.OS.thk = Thk.Col1.OSatVB;
Cnnt.L7.OS.axisTT = 'x';
Cnnt.L7.OS.int = 3;

Cnnt.L7.VB12.thk = Thk.Col1.VB;
Cnnt.L7.VB12.axisTT = 'x';
Cnnt.L7.VB12.int = 3;

%Line8 - OS*Bkh1
Cnnt.L8.SN = 'ABS_E_Air';
Cnnt.L8.group = 'rad';
Cnnt.L8.axis_c = 'y';
Cnnt.L8.axis_r = 'z';

Cnnt.L8.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L8.OS.axisTT = 'x';
Cnnt.L8.OS.int = 10;
Cnnt.L8.OS.HspAxis = 'z';
Cnnt.L8.OS.Hsp = [0,1100,2000,2200,3300,4400,5000,5500,6900,8300,9700,10700,11800,13000];
Cnnt.L8.OS.HspTol = 10;

%Line9 - OS*TFgd
Cnnt.L9.SN = 'ABS_E_Air';
Cnnt.L9.group = 'rad';
Cnnt.L9.axis_c = 'y';
Cnnt.L9.axis_r = 'z';

Cnnt.L9.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L9.OS.axisTT = 'x';
Cnnt.L9.OS.int = 3;
Cnnt.L9.OS.HspAxis = 'y';
Cnnt.L9.OS.HspThk = Thk.Col1.OSatUMB ;
Cnnt.L9.OS.Hsp = [-150,150];
Cnnt.L9.OS.HspTol = 0.5;

%Line10 - Bkh1 four edges
Cnnt.L10.SN = 'ABS_E_Air';
Cnnt.L10.group = 'flat';
Cnnt.L10.axis1 = 'y';
Cnnt.L10.axis2 = 'z';

Cnnt.L10.Bkh1.thk = Thk.Col1.Bkh;
Cnnt.L10.Bkh1.axisTT = 'x';
Cnnt.L10.Bkh1.int = 10;

Cnnt.L10.Bkh1.path = [0,0;2750,0;2750,-13000;0,-13000];
Cnnt.L10.Bkh1.HspAxis = 'z';
Cnnt.L10.Bkh1.Hsp = 0;
Cnnt.L10.Bkh1.HspTol = 0.5;
Cnnt.L10.Bkh1.HspInt = 5;

%Line11 - TFin * TFgd
Cnnt.L11.SN = 'ABS_E_Air';
Cnnt.L11.group = 'other';
Cnnt.L11.axis1 = 'y';
Cnnt.L11.axis2 = 'x';

Cnnt.L11.TF.thk = Thk.Col1.TFin;
Cnnt.L11.TF.axisTT = 'z';
Cnnt.L11.TF.int = 1;
Cnnt.L11.TF.HspAxis = 'y';
Cnnt.L11.TF.Hsp = -165:15:180;
Cnnt.L11.TF.HspTol = 0.1;
Cnnt.L11.TF.HspInt = 2;

%Line12 - TFout * TFgd
%Line13 - FB1 * UMB12
Cnnt.L13.SN = 'ABS_E_Air';
Cnnt.L13.group = 'flat';
Cnnt.L13.axis1 = 'y';
Cnnt.L13.axis2 = 'z';

Cnnt.L13.FB1.thk = Thk.Col1.FB;
Cnnt.L13.FB1.axisTT = 'x';
Cnnt.L13.FB1.int = 6;
Cnnt.L13.FB1.path = [0,0;2750,0;2750,-500;0,-500];

Cnnt.L13.FB1.HspAxis = 'z';
Cnnt.L13.FB1.Hsp = 0;
Cnnt.L13.FB1.HspTol = 0.5;
Cnnt.L13.FB1.HspInt = 3;

%Line14 - TB * TBbrkt
Cnnt.L14.SN = 'ABS_E_Air';
Cnnt.L14.group = 'rad';
Cnnt.L14.axis_c = 'y';
Cnnt.L14.axis_r = 'z';

Cnnt.L14.TB.thk = Thk.Col1.TB;
Cnnt.L14.TB.axisTT = 'x';
Cnnt.L14.TB.int = 2;
Cnnt.L14.TB.HspAxis = 'y';
Cnnt.L14.TB.Hsp = [-120,120];
Cnnt.L14.TB.HspTol = 0.5;

%Line15 - IS * Ring1
Cnnt.L15.SN = 'ABS_E_Air';
Cnnt.L15.group = 'circ';
Cnnt.L15.axis = 'y';

Cnnt.L15.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L15.IS.axisTT = 'x';
Cnnt.L15.IS.int = 3;
Cnnt.L15.IS.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L15.IS.HspTol = 0.5;

Cnnt.L15.Ring1.thk = Thk.Col1.RingatUMB;
Cnnt.L15.Ring1.axisTT = 'z';
Cnnt.L15.Ring1.int = 10;
Cnnt.L15.Ring1.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L15.Ring1.HspTol = 0.5;

%Line16 - IS * Ring2
Cnnt.L16.SN = 'ABS_E_Air';
Cnnt.L16.group = 'circ';
Cnnt.L16.axis = 'y';

Cnnt.L16.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L16.IS.axisTT = 'x';
Cnnt.L16.IS.int = 3;
Cnnt.L16.IS.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L16.IS.HspTol = 0.5;

Cnnt.L16.Ring2.thk = Thk.Col1.RingatUMB;
Cnnt.L16.Ring2.axisTT = 'z';
Cnnt.L16.Ring2.int = 10;
Cnnt.L16.Ring2.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L16.Ring2.HspTol = 0.5;

%Line17 - IS * Ring3
Cnnt.L17.SN = 'ABS_E_Air';
Cnnt.L17.group = 'circ';
Cnnt.L17.axis = 'y';

Cnnt.L17.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L17.IS.axisTT = 'x';
Cnnt.L17.IS.int = 3;
Cnnt.L17.IS.Hsp = [-157.71, -156, -144, -142.29, -120, 120, 142.29, 144, 156, 157.71];
Cnnt.L17.IS.HspTol = 0.5;

Cnnt.L17.Ring3.thk = Thk.Col1.RingatVB;
Cnnt.L17.Ring3.axisTT = 'z';
Cnnt.L17.Ring3.int = 10;
Cnnt.L17.Ring3.Hsp = [-157.71, -156, -144, -142.29, -120, 120, 142.29, 144, 156, 157.71];
Cnnt.L17.Ring3.HspTol = 0.5;

%Line18 - IS * Ring4
Cnnt.L18.SN = 'ABS_E_Air';
Cnnt.L18.group = 'circ';
Cnnt.L18.axis = 'y';

Cnnt.L18.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L18.IS.axisTT = 'x';
Cnnt.L18.IS.int = 3;
Cnnt.L18.IS.Hsp = [-156.75, -156, -144, -143.25,-120, 120,  143.25, 144, 156, 156.75];
Cnnt.L18.IS.HspTol = 0.5;

Cnnt.L18.Ring4.thk = Thk.Col1.RingatVB;
Cnnt.L18.Ring4.axisTT = 'z';
Cnnt.L18.Ring4.int = 10;
Cnnt.L18.Ring4.Hsp = [-156.75, -156, -144, -143.25,-120, 120,  143.25, 144, 156, 156.75];
Cnnt.L18.Ring4.HspTol = 0.5;

%Line19 - TF * TBring
%Line20 - IS * UMB13
Cnnt.L20.SN = 'API_WJ_Air';
Cnnt.L20.group = 'circ';
Cnnt.L20.axis = 'y';

Cnnt.L20.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L20.IS.axisTT = 'x';
Cnnt.L20.IS.int = 2;
Cnnt.L20.IS.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L20.IS.HspTol = 0.5; %Tolerance in hot spot sampling

Cnnt.L20.UMB13.thk = Thk.Col1.UMB;
Cnnt.L20.UMB13.axisTT = 'x';
Cnnt.L20.UMB13.int = 3;
Cnnt.L20.UMB13.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L20.UMB13.HspTol = 0.5; 

%Line21 - IS * VB13
Cnnt.L21.SN = 'API_WJ_Air';
Cnnt.L21.group = 'circ';
Cnnt.L21.axis = 'y';

Cnnt.L21.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L21.IS.axisTT = 'x';
Cnnt.L21.IS.int = 2;
Cnnt.L21.IS.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L21.IS.HspTol = 0.5;

Cnnt.L21.VB13.thk = Thk.Col1.VB;
Cnnt.L21.VB13.axisTT = 'x';
Cnnt.L21.VB13.int = 3;
Cnnt.L21.VB13.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L21.VB13.HspTol = 0.5;

%Line22 - OS * UMB13
Cnnt.L22.SN = 'API_WJ_Air';
Cnnt.L22.group = 'circ';
Cnnt.L22.axis = 'y';

Cnnt.L22.OS.thk = Thk.Col1.OSatUMB;
Cnnt.L22.OS.axisTT = 'x';
Cnnt.L22.OS.int = 3;

Cnnt.L22.UMB13.thk = Thk.Col1.UMB;
Cnnt.L22.UMB13.axisTT = 'x';
Cnnt.L22.UMB13.int = 3;

%Line23 - OS * VB13
Cnnt.L23.SN = 'API_WJ_Air';
Cnnt.L23.group = 'circ';
Cnnt.L23.axis = 'y';

Cnnt.L23.OS.thk = Thk.Col1.OSatVB;
Cnnt.L23.OS.axisTT = 'x';
Cnnt.L23.OS.int = 3;

Cnnt.L23.VB13.thk = Thk.Col1.VB;
Cnnt.L23.VB13.axisTT = 'x';
Cnnt.L23.VB13.int = 3;

%Line24 - Bkh2 two edges
Cnnt.L24.SN = 'ABS_E_Air';
Cnnt.L24.group = 'flat';
Cnnt.L24.axis1 = 'y';
Cnnt.L24.axis2 = 'z';

Cnnt.L24.Bkh2.thk = Thk.Col1.Bkh;
Cnnt.L24.Bkh2.axisTT = 'x';
Cnnt.L24.Bkh2.int = 10;
Cnnt.L24.Bkh2.path = [0,0;-2750,0;-2750,-13000;0,-13000];
Cnnt.L24.Bkh2.HspAxis = 'z';
Cnnt.L24.Bkh2.Hsp = 0;
Cnnt.L24.Bkh2.HspTol = 0.5;
Cnnt.L24.Bkh2.HspInt = 2;

%Line25 - FB2 four edges
Cnnt.L25.SN = 'ABS_E_Air';
Cnnt.L25.group = 'flat';
Cnnt.L25.axis1 = 'y';
Cnnt.L25.axis2 = 'z';

Cnnt.L25.FB2.thk = Thk.Col1.FB;
Cnnt.L25.FB2.axisTT = 'x';
Cnnt.L25.FB2.int = 6;
Cnnt.L25.FB2.path = [0,0;-2750,0;-2750,-500;0,-500];
Cnnt.L25.FB2.HspAxis = 'z';
Cnnt.L25.FB2.Hsp = 0;
Cnnt.L25.FB2.HspTol = 0.5;
Cnnt.L25.FB2.HspInt = 3;

%Line26 - IS opening
Cnnt.L26.SN = 'ABS_C_Air';
Cnnt.L26.group = 'flat';
Cnnt.L26.axis1 = 'y';
Cnnt.L26.axis2 = 'z';

Cnnt.L26.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L26.IS.axisTT = 'x';
Cnnt.L26.IS.int = 2;

%Line27 - VB12lwr * LMB12mid
%Line28 - VB21lwr * LMB12mid
%Line29 - VB13lwr * LMB13mid
%Line30 - VB31lwr * LMB13mid
%Line31 - IS * C-Plate

%Line32 - Vbar1 (at Bkh1) four edge
Cnnt.L32.SN = 'ABS_E_Air';
Cnnt.L32.group = 'other';
Cnnt.L32.axis1 = 'x';
Cnnt.L32.axis2 = 'z';

Cnnt.L32.Vbar1.thk = Thk.Col1.VBaratBkh;
Cnnt.L32.Vbar1.axisTT = 'y';
Cnnt.L32.Vbar1.int = 1;

Cnnt.L32.Vbar1.HspAxis = 'x';
Cnnt.L32.Vbar1.Hsp = [2550, 3250];
Cnnt.L32.Vbar1.HspTol = 0.5;
Cnnt.L32.Vbar1.HspInt = 4;

%Line33 - Vbar2 (at Bkh2) four edge
Cnnt.L33.SN = 'ABS_E_Air';
Cnnt.L33.group = 'other';
Cnnt.L33.axis1 = 'x';
Cnnt.L33.axis2 = 'z';

Cnnt.L33.Vbar2.thk = Thk.Col1.VBaratBkh;
Cnnt.L33.Vbar2.axisTT = 'y';
Cnnt.L33.Vbar2.int = 1;

Cnnt.L33.Vbar2.HspAxis = 'x';
Cnnt.L33.Vbar2.Hsp = [2550, 3250];
Cnnt.L33.Vbar2.HspTol = 0.5;
Cnnt.L33.Vbar2.HspInt = 4;

%Line34 - Vbar3 (at UMBVB12) four edge
Cnnt.L34.SN = 'ABS_E_Air';
Cnnt.L34.group = 'other';
Cnnt.L34.axis1 = 'x';
Cnnt.L34.axis2 = 'z';

Cnnt.L34.Vbar3.thk = Thk.Col1.VBaratTruss;
Cnnt.L34.Vbar3.axisTT = 'y';
Cnnt.L34.Vbar3.int = 1;

Cnnt.L34.Vbar3.HspAxis = 'z';
Cnnt.L34.Vbar3.Hsp =  [7550 9311 10844 12356];
Cnnt.L34.Vbar3.HspTol = 0.5;
Cnnt.L34.Vbar3.HspInt = 1;

%Line35 - Vbar4 (at UMBVB12) four edge
Cnnt.L35.SN = 'ABS_E_Air';
Cnnt.L35.group = 'other';
Cnnt.L35.axis1 = 'x';
Cnnt.L35.axis2 = 'z';

Cnnt.L35.Vbar4.thk = Thk.Col1.VBaratTruss;
Cnnt.L35.Vbar4.axisTT = 'y';
Cnnt.L35.Vbar4.int = 1;
Cnnt.L35.Vbar4.path = [];
Cnnt.L35.Vbar4.HspAxis = 'z';
Cnnt.L35.Vbar4.Hsp =  [7550 9311 10844 12356];
Cnnt.L35.Vbar4.HspTol = 0.5;
Cnnt.L35.Vbar4.HspInt = 1;

%Line36 - Vbar5 (at UMBVB13) four edge
Cnnt.L36.SN = 'ABS_E_Air';
Cnnt.L36.group = 'other';
Cnnt.L36.axis1 = 'x';
Cnnt.L36.axis2 = 'z';

Cnnt.L36.Vbar5.thk = Thk.Col1.VBaratTruss;
Cnnt.L36.Vbar5.axisTT = 'y';
Cnnt.L36.Vbar5.int = 1;

Cnnt.L36.Vbar5.HspAxis = 'z';
Cnnt.L36.Vbar5.Hsp = [7550 9311 10844 12356];
Cnnt.L36.Vbar5.HspTol = 0.5;
Cnnt.L36.Vbar5.HspInt = 1;

%Line37 - Vbar6 (at UMBVB13) four edge
Cnnt.L37.SN = 'ABS_E_Air';
Cnnt.L37.group = 'other';
Cnnt.L37.axis1 = 'x';
Cnnt.L37.axis2 = 'z';

Cnnt.L37.Vbar6.thk = Thk.Col1.VBaratTruss;
Cnnt.L37.Vbar6.axisTT = 'y';
Cnnt.L37.Vbar6.int = 1;

Cnnt.L37.Vbar6.HspAxis = 'z';
Cnnt.L37.Vbar6.Hsp = [7550 9311 10844 12356];
Cnnt.L37.Vbar6.HspTol = 0.5;
Cnnt.L37.Vbar6.HspInt = 1;

OutName = [path1 'CnntInfo.mat'];
save(OutName, 'Cnnt')

%% ItrR5_15_4dp5 (Col1_Top)
ItrNo = 'ItrR5_15_4dp5';
path1 = [path0 ItrNo '\'];
load([path1 'thickness.mat']);

Cnnt.Itr = ItrNo;

%Line1 - TB*IS*TF
Cnnt.L1.SN = 'ABS_E_Air';
Cnnt.L1.group = 'circ';
Cnnt.L1.axis = 'y';

Cnnt.L1.TB.thk = Thk.Col1.TB;
Cnnt.L1.TB.int = 3;
Cnnt.L1.TB.axisTT = 'x'; %through-thickness axis

Cnnt.L1.TF.thk = Thk.Col1.TFin;
Cnnt.L1.TF.int = 10;
Cnnt.L1.TF.axisTT = 'z'; %through-thickness axis

Cnnt.L1.TOCring.thk = Thk.Col1.TFin;
Cnnt.L1.TOCring.int = 10;
Cnnt.L1.TOCring.axisTT = 'z';

%Line2 - IS*UMB12
Cnnt.L2.SN = 'API_WJ_Air';
Cnnt.L2.group = 'circ';
Cnnt.L2.axis = 'y';

Cnnt.L2.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L2.IS.int = 2;
Cnnt.L2.IS.axisTT = 'x';
Cnnt.L2.IS.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L2.IS.HspTol = 0.5; %Tolerance in hot spot sampling

Cnnt.L2.UMB12.thk = Thk.Col1.UMB;
Cnnt.L2.UMB12.int = 3;
Cnnt.L2.UMB12.axisTT = 'x';
Cnnt.L2.UMB12.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L2.UMB12.HspTol = 0.5; 

%Line3 - IS*VB12
Cnnt.L3.SN = 'API_WJ_Air';
Cnnt.L3.group = 'circ';
Cnnt.L3.axis = 'y';

Cnnt.L3.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L3.IS.axisTT = 'x';
Cnnt.L3.IS.int = 2;
Cnnt.L3.IS.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L3.IS.HspTol = 0.5;

Cnnt.L3.VB12.thk = Thk.Col1.VB;
Cnnt.L3.VB12.axisTT = 'x';
Cnnt.L3.VB12.int = 3;
Cnnt.L3.VB12.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L3.VB12.HspTol = 0.5;

%Line4 - IS*BKHs
Cnnt.L4.SN = 'ABS_E_Air';
Cnnt.L4.group = 'rad';
Cnnt.L4.axis_c = 'y';
Cnnt.L4.axis_r = 'z';

Cnnt.L4.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L4.IS.axisTT = 'x';
Cnnt.L4.IS.int = 5;
Cnnt.L4.IS.HspAxis = 'z';
Cnnt.L4.IS.Hsp = [5585, 6900,7550.3,8300,9311,9700,10700,10844,11800,12356];
Cnnt.L4.IS.HspTol = 10;

%Line5 - OS*TF
Cnnt.L5.SN = 'ABS_E_Air';
Cnnt.L5.group = 'circ';
Cnnt.L5.axis = 'y';

Cnnt.L5.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L5.OS.axisTT = 'x';
Cnnt.L5.OS.int = 20;
Cnnt.L5.OS.HspThk = Thk.Col1.OSatUMB ;
Cnnt.L5.OS.Hsp = [-150,150];
Cnnt.L5.OS.HspTol = 7.5;

Cnnt.L5.TF.thk = Thk.Col1.TFout;
Cnnt.L5.TF.axisTT = 'z';
Cnnt.L5.TF.int = 20;
Cnnt.L5.TF.HspThk = Thk.Col1.TFatUMB ;
Cnnt.L5.TF.Hsp = [-150,150];
Cnnt.L5.TF.HspTol = 7.5;

%Line6 - OS*UMB12
Cnnt.L6.SN = 'API_WJ_Air';
Cnnt.L6.group = 'circ';
Cnnt.L6.axis = 'y';

Cnnt.L6.OS.thk = Thk.Col1.OSatUMB;
Cnnt.L6.OS.axisTT = 'x';
Cnnt.L6.OS.int = 3;

Cnnt.L6.UMB12.thk = Thk.Col1.UMB;
Cnnt.L6.UMB12.axisTT = 'x';
Cnnt.L6.UMB12.int = 3;

%Line7 - OS*VB12
Cnnt.L7.SN = 'API_WJ_Air';
Cnnt.L7.group = 'circ';
Cnnt.L7.axis = 'y';

Cnnt.L7.OS.thk = Thk.Col1.OSatVB;
Cnnt.L7.OS.axisTT = 'x';
Cnnt.L7.OS.int = 3;

Cnnt.L7.VB12.thk = Thk.Col1.VB;
Cnnt.L7.VB12.axisTT = 'x';
Cnnt.L7.VB12.int = 3;

%Line8 - OS*Bkh1
Cnnt.L8.SN = 'ABS_E_Air';
Cnnt.L8.group = 'rad';
Cnnt.L8.axis_c = 'y';
Cnnt.L8.axis_r = 'z';

Cnnt.L8.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L8.OS.axisTT = 'x';
Cnnt.L8.OS.int = 10;
Cnnt.L8.OS.HspAxis = 'z';
Cnnt.L8.OS.Hsp = [0,1100,2000,2200,3300,4400,5000,5500,6900,8300,9700,10700,11800,13000];
Cnnt.L8.OS.HspTol = 10;

%Line9 - OS*TFgd
Cnnt.L9.SN = 'ABS_E_Air';
Cnnt.L9.group = 'rad';
Cnnt.L9.axis_c = 'y';
Cnnt.L9.axis_r = 'z';

Cnnt.L9.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L9.OS.axisTT = 'x';
Cnnt.L9.OS.int = 3;
Cnnt.L9.OS.HspAxis = 'y';
Cnnt.L9.OS.HspThk = Thk.Col1.OSatUMB ;
Cnnt.L9.OS.Hsp = [-150,150];
Cnnt.L9.OS.HspTol = 0.5;

%Line10 - Bkh1 four edges
Cnnt.L10.SN = 'ABS_E_Air';
Cnnt.L10.group = 'flat';
Cnnt.L10.axis1 = 'y';
Cnnt.L10.axis2 = 'z';

Cnnt.L10.Bkh1.thk = Thk.Col1.Bkh;
Cnnt.L10.Bkh1.axisTT = 'x';
Cnnt.L10.Bkh1.int = 10;

Cnnt.L10.Bkh1.path = [0,0;2750,0;2750,-13000;0,-13000];
Cnnt.L10.Bkh1.HspAxis = 'z';
Cnnt.L10.Bkh1.Hsp = 0;
Cnnt.L10.Bkh1.HspTol = 0.5;
Cnnt.L10.Bkh1.HspInt = 5;

%Line11 - TFin * TFgd
Cnnt.L11.SN = 'ABS_E_Air';
Cnnt.L11.group = 'other';
Cnnt.L11.axis1 = 'y';
Cnnt.L11.axis2 = 'x';

Cnnt.L11.TF.thk = Thk.Col1.TFin;
Cnnt.L11.TF.axisTT = 'z';
Cnnt.L11.TF.int = 1;
Cnnt.L11.TF.HspAxis = 'y';
Cnnt.L11.TF.Hsp = -165:15:180;
Cnnt.L11.TF.HspTol = 0.1;
Cnnt.L11.TF.HspInt = 2;

%Line12 - TFout * TFgd
%Line13 - FB1 * UMB12
Cnnt.L13.SN = 'ABS_E_Air';
Cnnt.L13.group = 'flat';
Cnnt.L13.axis1 = 'y';
Cnnt.L13.axis2 = 'z';

Cnnt.L13.FB1.thk = Thk.Col1.FB;
Cnnt.L13.FB1.axisTT = 'x';
Cnnt.L13.FB1.int = 6;
Cnnt.L13.FB1.path = [0,0;2750,0;2750,-500;0,-500];

Cnnt.L13.FB1.HspAxis = 'z';
Cnnt.L13.FB1.Hsp = 0;
Cnnt.L13.FB1.HspTol = 0.5;
Cnnt.L13.FB1.HspInt = 3;

%Line14 - TB * TBbrkt
Cnnt.L14.SN = 'ABS_E_Air';
Cnnt.L14.group = 'rad';
Cnnt.L14.axis_c = 'y';
Cnnt.L14.axis_r = 'z';

Cnnt.L14.TB.thk = Thk.Col1.TB;
Cnnt.L14.TB.axisTT = 'x';
Cnnt.L14.TB.int = 2;
Cnnt.L14.TB.HspAxis = 'y';
Cnnt.L14.TB.Hsp = [-120,120];
Cnnt.L14.TB.HspTol = 0.5;

%Line15 - IS * Ring1
Cnnt.L15.SN = 'ABS_E_Air';
Cnnt.L15.group = 'circ';
Cnnt.L15.axis = 'y';

Cnnt.L15.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L15.IS.axisTT = 'x';
Cnnt.L15.IS.int = 3;
Cnnt.L15.IS.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L15.IS.HspTol = 0.5;

Cnnt.L15.Ring1.thk = Thk.Col1.RingatUMB;
Cnnt.L15.Ring1.axisTT = 'z';
Cnnt.L15.Ring1.int = 10;
Cnnt.L15.Ring1.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L15.Ring1.HspTol = 0.5;

%Line16 - IS * Ring2
Cnnt.L16.SN = 'ABS_E_Air';
Cnnt.L16.group = 'circ';
Cnnt.L16.axis = 'y';

Cnnt.L16.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L16.IS.axisTT = 'x';
Cnnt.L16.IS.int = 3;
Cnnt.L16.IS.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L16.IS.HspTol = 0.5;

Cnnt.L16.Ring2.thk = Thk.Col1.RingatUMB;
Cnnt.L16.Ring2.axisTT = 'z';
Cnnt.L16.Ring2.int = 10;
Cnnt.L16.Ring2.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L16.Ring2.HspTol = 0.5;

%Line17 - IS * Ring3
Cnnt.L17.SN = 'ABS_E_Air';
Cnnt.L17.group = 'circ';
Cnnt.L17.axis = 'y';

Cnnt.L17.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L17.IS.axisTT = 'x';
Cnnt.L17.IS.int = 3;
Cnnt.L17.IS.Hsp = [-157.71, -156, -144, -142.29, -120, 120, 142.29, 144, 156, 157.71];
Cnnt.L17.IS.HspTol = 0.5;

Cnnt.L17.Ring3.thk = Thk.Col1.RingatVB;
Cnnt.L17.Ring3.axisTT = 'z';
Cnnt.L17.Ring3.int = 10;
Cnnt.L17.Ring3.Hsp = [-157.71, -156, -144, -142.29, -120, 120, 142.29, 144, 156, 157.71];
Cnnt.L17.Ring3.HspTol = 0.5;

%Line18 - IS * Ring4
Cnnt.L18.SN = 'ABS_E_Air';
Cnnt.L18.group = 'circ';
Cnnt.L18.axis = 'y';

Cnnt.L18.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L18.IS.axisTT = 'x';
Cnnt.L18.IS.int = 3;
Cnnt.L18.IS.Hsp = [-156.75, -156, -144, -143.25,-120, 120,  143.25, 144, 156, 156.75];
Cnnt.L18.IS.HspTol = 0.5;

Cnnt.L18.Ring4.thk = Thk.Col1.RingatVB;
Cnnt.L18.Ring4.axisTT = 'z';
Cnnt.L18.Ring4.int = 10;
Cnnt.L18.Ring4.Hsp = [-156.75, -156, -144, -143.25,-120, 120,  143.25, 144, 156, 156.75];
Cnnt.L18.Ring4.HspTol = 0.5;

%Line19 - TF * TBring
%Line20 - IS * UMB13
Cnnt.L20.SN = 'API_WJ_Air';
Cnnt.L20.group = 'circ';
Cnnt.L20.axis = 'y';

Cnnt.L20.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L20.IS.axisTT = 'x';
Cnnt.L20.IS.int = 2;
Cnnt.L20.IS.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L20.IS.HspTol = 0.5; %Tolerance in hot spot sampling

Cnnt.L20.UMB13.thk = Thk.Col1.UMB;
Cnnt.L20.UMB13.axisTT = 'x';
Cnnt.L20.UMB13.int = 3;
Cnnt.L20.UMB13.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L20.UMB13.HspTol = 0.5; 

%Line21 - IS * VB13
Cnnt.L21.SN = 'API_WJ_Air';
Cnnt.L21.group = 'circ';
Cnnt.L21.axis = 'y';

Cnnt.L21.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L21.IS.axisTT = 'x';
Cnnt.L21.IS.int = 2;
Cnnt.L21.IS.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L21.IS.HspTol = 0.5;

Cnnt.L21.VB13.thk = Thk.Col1.VB;
Cnnt.L21.VB13.axisTT = 'x';
Cnnt.L21.VB13.int = 3;
Cnnt.L21.VB13.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L21.VB13.HspTol = 0.5;

%Line22 - OS * UMB13
Cnnt.L22.SN = 'API_WJ_Air';
Cnnt.L22.group = 'circ';
Cnnt.L22.axis = 'y';

Cnnt.L22.OS.thk = Thk.Col1.OSatUMB;
Cnnt.L22.OS.axisTT = 'x';
Cnnt.L22.OS.int = 3;

Cnnt.L22.UMB13.thk = Thk.Col1.UMB;
Cnnt.L22.UMB13.axisTT = 'x';
Cnnt.L22.UMB13.int = 3;

%Line23 - OS * VB13
Cnnt.L23.SN = 'API_WJ_Air';
Cnnt.L23.group = 'circ';
Cnnt.L23.axis = 'y';

Cnnt.L23.OS.thk = Thk.Col1.OSatVB;
Cnnt.L23.OS.axisTT = 'x';
Cnnt.L23.OS.int = 3;

Cnnt.L23.VB13.thk = Thk.Col1.VB;
Cnnt.L23.VB13.axisTT = 'x';
Cnnt.L23.VB13.int = 3;

%Line24 - Bkh2 two edges
Cnnt.L24.SN = 'ABS_E_Air';
Cnnt.L24.group = 'flat';
Cnnt.L24.axis1 = 'y';
Cnnt.L24.axis2 = 'z';

Cnnt.L24.Bkh2.thk = Thk.Col1.Bkh;
Cnnt.L24.Bkh2.axisTT = 'x';
Cnnt.L24.Bkh2.int = 10;
Cnnt.L24.Bkh2.path = [0,0;-2750,0;-2750,-13000;0,-13000];
Cnnt.L24.Bkh2.HspAxis = 'z';
Cnnt.L24.Bkh2.Hsp = 0;
Cnnt.L24.Bkh2.HspTol = 0.5;
Cnnt.L24.Bkh2.HspInt = 5;

%Line25 - FB2 four edges
Cnnt.L25.SN = 'ABS_E_Air';
Cnnt.L25.group = 'flat';
Cnnt.L25.axis1 = 'y';
Cnnt.L25.axis2 = 'z';

Cnnt.L25.FB2.thk = Thk.Col1.FB;
Cnnt.L25.FB2.axisTT = 'x';
Cnnt.L25.FB2.int = 6;
Cnnt.L25.FB2.path = [0,0;-2750,0;-2750,-500;0,-500];
Cnnt.L25.FB2.HspAxis = 'z';
Cnnt.L25.FB2.Hsp = 0;
Cnnt.L25.FB2.HspTol = 0.5;
Cnnt.L25.FB2.HspInt = 3;

%Line26 - IS opening
Cnnt.L26.SN = 'ABS_C_Air';
Cnnt.L26.group = 'flat';
Cnnt.L26.axis1 = 'y';
Cnnt.L26.axis2 = 'z';

Cnnt.L26.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L26.IS.axisTT = 'x';
Cnnt.L26.IS.int = 2;

%Line27 - VB12lwr * LMB12mid
%Line28 - VB21lwr * LMB12mid
%Line29 - VB13lwr * LMB13mid
%Line30 - VB31lwr * LMB13mid
%Line31 - IS * C-Plate

%Line32 - Vbar1 (at Bkh1) four edge
Cnnt.L32.SN = 'ABS_E_Air';
Cnnt.L32.group = 'other';
Cnnt.L32.axis1 = 'x';
Cnnt.L32.axis2 = 'z';

Cnnt.L32.Vbar1.thk = Thk.Col1.VBaratBkh;
Cnnt.L32.Vbar1.axisTT = 'y';
Cnnt.L32.Vbar1.int = 1;

Cnnt.L32.Vbar1.HspAxis = 'x';
Cnnt.L32.Vbar1.Hsp = [2550, 3250];
Cnnt.L32.Vbar1.HspTol = 0.5;
Cnnt.L32.Vbar1.HspInt = 4;

%Line33 - Vbar2 (at Bkh2) four edge
Cnnt.L33.SN = 'ABS_E_Air';
Cnnt.L33.group = 'other';
Cnnt.L33.axis1 = 'x';
Cnnt.L33.axis2 = 'z';

Cnnt.L33.Vbar2.thk = Thk.Col1.VBaratBkh;
Cnnt.L33.Vbar2.axisTT = 'y';
Cnnt.L33.Vbar2.int = 1;

Cnnt.L33.Vbar2.HspAxis = 'x';
Cnnt.L33.Vbar2.Hsp = [2550, 3250];
Cnnt.L33.Vbar2.HspTol = 0.5;
Cnnt.L33.Vbar2.HspInt = 4;

%Line34 - Vbar3 (at UMBVB12) four edge
Cnnt.L34.SN = 'ABS_E_Air';
Cnnt.L34.group = 'other';
Cnnt.L34.axis1 = 'x';
Cnnt.L34.axis2 = 'z';

Cnnt.L34.Vbar3.thk = Thk.Col1.VBaratTruss;
Cnnt.L34.Vbar3.axisTT = 'y';
Cnnt.L34.Vbar3.int = 1;

Cnnt.L34.Vbar3.HspAxis = 'x';
Cnnt.L34.Vbar3.Hsp = [2550, 3250];
Cnnt.L34.Vbar3.HspTol = 0.5;
Cnnt.L34.Vbar3.HspInt = 4;

%Line35 - Vbar4 (at UMBVB12) four edge
Cnnt.L35.SN = 'ABS_E_Air';
Cnnt.L35.group = 'other';
Cnnt.L35.axis1 = 'x';
Cnnt.L35.axis2 = 'z';

Cnnt.L35.Vbar4.thk = Thk.Col1.VBaratTruss;
Cnnt.L35.Vbar4.axisTT = 'y';
Cnnt.L35.Vbar4.int = 1;
Cnnt.L35.Vbar4.path = [];
Cnnt.L35.Vbar4.HspAxis = 'x';
Cnnt.L35.Vbar4.Hsp = [2550, 3250];
Cnnt.L35.Vbar4.HspTol = 0.5;
Cnnt.L35.Vbar4.HspInt = 4;

%Line36 - Vbar5 (at UMBVB13) four edge
Cnnt.L36.SN = 'ABS_E_Air';
Cnnt.L36.group = 'other';
Cnnt.L36.axis1 = 'x';
Cnnt.L36.axis2 = 'z';

Cnnt.L36.Vbar5.thk = Thk.Col1.VBaratTruss;
Cnnt.L36.Vbar5.axisTT = 'y';
Cnnt.L36.Vbar5.int = 1;

Cnnt.L36.Vbar5.HspAxis = 'x';
Cnnt.L36.Vbar5.Hsp = [2550, 3250];
Cnnt.L36.Vbar5.HspTol = 0.5;
Cnnt.L36.Vbar5.HspInt = 4;

%Line37 - Vbar6 (at UMBVB13) four edge
Cnnt.L37.SN = 'ABS_E_Air';
Cnnt.L37.group = 'other';
Cnnt.L37.axis1 = 'x';
Cnnt.L37.axis2 = 'z';

Cnnt.L37.Vbar6.thk = Thk.Col1.VBaratTruss;
Cnnt.L37.Vbar6.axisTT = 'y';
Cnnt.L37.Vbar6.int = 1;

Cnnt.L37.Vbar6.HspAxis = 'x';
Cnnt.L37.Vbar6.Hsp = [2550, 3250];
Cnnt.L37.Vbar6.HspTol = 0.5;
Cnnt.L37.Vbar6.HspInt = 4;

OutName = [path1 'CnntInfo.mat'];
save(OutName, 'Cnnt')

%% Itr12_6dp8 (Col2_Top)
ItrNo = 'ItrR5_12_6dp8';
path1 = [path0 ItrNo '\'];
load([path1 'thickness.mat']);

Cnnt.Itr = ItrNo;

%Line201 - IS*UMB21
Cnnt.L201.SN = 'API_WJ_Air';
Cnnt.L201.group = 'circ';
Cnnt.L201.axis = 'y';

Cnnt.L201.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L201.IS.int = 3;
Cnnt.L201.IS.axisTT = 'x';
Cnnt.L201.IS.Hsp = [-154.27, -138.59 ,-49.458, -25.729, 25.729, 49.458, 138.59, 154.27]; %deg
Cnnt.L201.IS.HspTol = 0.5; %Tolerance in hot spot sampling

Cnnt.L201.UMB21.thk = Thk.Col2.UMB21;
Cnnt.L201.UMB21.int = 3;
Cnnt.L201.UMB21.axisTT = 'x';
Cnnt.L201.UMB21.Hsp = [-154.27, -138.59 ,-49.458, -25.729, 25.729, 49.458, 138.59, 154.27]; %deg
Cnnt.L201.UMB21.HspTol = 0.5; 

%Line202 - IS*VB21
Cnnt.L202.SN = 'API_WJ_Air';
Cnnt.L202.group = 'circ';
Cnnt.L202.axis = 'y';

Cnnt.L202.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L202.IS.int = 3;
Cnnt.L202.IS.axisTT = 'x';
Cnnt.L202.IS.Hsp = [-148.6, -128.91 ,-41.286, -31.396, 31.396, 41.286, 128.91, 148.6]; %deg
Cnnt.L202.IS.HspTol = 0.5; %Tolerance in hot spot sampling

Cnnt.L202.VB21.thk = Thk.Col2.VB21;
Cnnt.L202.VB21.int = 3;
Cnnt.L202.VB21.axisTT = 'x';
Cnnt.L202.VB21.Hsp = [-148.6, -128.91 ,-41.286, -31.396, 31.396, 41.286, 128.91, 148.6]; %deg
Cnnt.L202.VB21.HspTol = 0.5; 

%Line203 - OS*UMB21
Cnnt.L203.SN = 'API_WJ_Air';
Cnnt.L203.group = 'circ';
Cnnt.L203.axis = 'y';

Cnnt.L203.OS.thk = Thk.Col2.OSatTruss21;
Cnnt.L203.OS.axisTT = 'x';
Cnnt.L203.OS.int = 3;

Cnnt.L203.UMB21.thk = Thk.Col2.UMB21;
Cnnt.L203.UMB21.axisTT = 'x';
Cnnt.L203.UMB21.int = 3;

%Line204 - OS*VB21
Cnnt.L204.SN = 'API_WJ_Air';
Cnnt.L204.group = 'circ';
Cnnt.L204.axis = 'y';

Cnnt.L204.OS.thk = Thk.Col2.OSatTruss21;
Cnnt.L204.OS.axisTT = 'x';
Cnnt.L204.OS.int = 3;

Cnnt.L204.VB21.thk = Thk.Col2.VB21;
Cnnt.L204.VB21.axisTT = 'x';
Cnnt.L204.VB21.int = 3;

%Line205 - IS * Ring1
Cnnt.L205.SN = 'ABS_E_Air';
Cnnt.L205.group = 'circ';
Cnnt.L205.axis = 'y';

Cnnt.L205.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L205.IS.axisTT = 'x';
Cnnt.L205.IS.int = 5;
Cnnt.L205.IS.Hsp = [ -45.342, -40, -20, -14.658, 0]; %deg
Cnnt.L205.IS.HspTol = 0.5;

Cnnt.L205.Ring1.thk = Thk.Col2.RingTop;
Cnnt.L205.Ring1.axisTT = 'z';
Cnnt.L205.Ring1.int = 5;
Cnnt.L205.Ring1.Hsp = [ -45.342, -40, -20, -14.658, 0]; %deg
Cnnt.L205.Ring1.HspTol = 0.5; 

%Line206 - IS * Ring2
Cnnt.L206.SN = 'ABS_E_Air';
Cnnt.L206.group = 'circ';
Cnnt.L206.axis = 'y';

Cnnt.L206.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L206.IS.axisTT = 'x';
Cnnt.L206.IS.int = 5;
Cnnt.L206.IS.Hsp = [ -47.696, -40, -20, -12.304, 0]; %deg
Cnnt.L206.IS.HspTol = 0.5;

Cnnt.L206.Ring2.thk = Thk.Col2.RingTop;
Cnnt.L206.Ring2.axisTT = 'z';
Cnnt.L206.Ring2.int = 5;
Cnnt.L206.Ring2.Hsp = [ -47.696, -40, -20, -12.304, 0]; %deg
Cnnt.L206.Ring2.HspTol = 0.5;

%Line207 - IS * Ring3
Cnnt.L207.SN = 'ABS_E_Air';
Cnnt.L207.group = 'circ';
Cnnt.L207.axis = 'y';

Cnnt.L207.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L207.IS.axisTT = 'x';
Cnnt.L207.IS.int = 5;
Cnnt.L207.IS.Hsp = [ -45.032, -40, -20, -14.968, 0]; %deg
Cnnt.L207.IS.HspTol = 0.5;

Cnnt.L207.Ring3.thk = Thk.Col2.RingTop;
Cnnt.L207.Ring3.axisTT = 'z';
Cnnt.L207.Ring3.int = 5;
Cnnt.L207.Ring3.Hsp = [ -45.032, -40, -20, -14.968, 0]; %deg
Cnnt.L207.Ring3.HspTol = 0.5;

%Line208 - IS * Ring4
Cnnt.L208.SN = 'ABS_E_Air';
Cnnt.L208.group = 'circ';
Cnnt.L208.axis = 'y';

Cnnt.L208.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L208.IS.axisTT = 'x';
Cnnt.L208.IS.int = 5;
Cnnt.L208.IS.Hsp = [ -42.705, -40, -20, -17.295, 0]; %deg
Cnnt.L208.IS.HspTol = 0.5;

Cnnt.L208.Ring4.thk = Thk.Col2.RingTop;
Cnnt.L208.Ring4.axisTT = 'z';
Cnnt.L208.Ring4.int = 5;
Cnnt.L208.Ring4.Hsp = [ -42.705, -40, -20, -17.295, 0]; %deg
Cnnt.L208.Ring4.HspTol = 0.5;

%Line209 - IS * Vbar1
Cnnt.L209.SN = 'ABS_E_Air';
Cnnt.L209.group = 'circ';
Cnnt.L209.axis = 'z';

Cnnt.L209.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L209.IS.axisTT = 'x';
Cnnt.L209.IS.int = 5;
Cnnt.L209.IS.Hsp = [589.23, 724.99, 1985, 2210.8, 2666.9, 2861.3, 4328, 4455.4]; %mm
Cnnt.L209.IS.HspTol = 30;

Cnnt.L209.Vbar1.thk = Thk.Col2.VbarTop;
Cnnt.L209.Vbar1.axisTT = 'x';
Cnnt.L209.Vbar1.int = 5;
Cnnt.L209.Vbar1.Hsp = [589.23, 724.99, 1985, 2210.8, 2666.9, 2861.3, 4328, 4455.4]; %mm
Cnnt.L209.Vbar1.HspTol = 30;

%Line210 - IS * Vbar2
Cnnt.L210.SN = 'ABS_E_Air';
Cnnt.L210.group = 'circ';
Cnnt.L210.axis = 'z';

Cnnt.L210.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L210.IS.axisTT = 'x';
Cnnt.L210.IS.int = 5;
Cnnt.L210.IS.Hsp = [589.23, 725, 1985, 2210.8, 2666.9, 2861.3, 4328, 4455.4]; %mm
Cnnt.L210.IS.HspTol = 30;

Cnnt.L210.Vbar2.thk = Thk.Col2.VbarTop;
Cnnt.L210.Vbar2.axisTT = 'x';
Cnnt.L210.Vbar2.int = 5;
Cnnt.L210.Vbar2.Hsp = [589.23, 725, 1985, 2210.8, 2666.9, 2861.3, 4328, 4455.4]; %mm
Cnnt.L210.Vbar2.HspTol = 30;

%Line211 - Ring1 edges
Cnnt.L211.SN = 'ABS_E_Air';
Cnnt.L211.group = 'other';
Cnnt.L211.axis1 = 'x';
Cnnt.L211.axis2 = 'y';

Cnnt.L211.Ring1.thk = Thk.Col2.RingTop;
Cnnt.L211.Ring1.axisTT = 'z';
Cnnt.L211.Ring1.int = 1;

Cnnt.L211.Ring1.HspAxis = 'x';
Cnnt.L211.Ring1.HspSN = 'ABS_C_Air';
Cnnt.L211.Ring1.Hsp = 1750;
Cnnt.L211.Ring1.HspTol = 30;
Cnnt.L211.Ring1.HspInt = 4;

%Line212 - Ring2 edges
Cnnt.L212.SN = 'ABS_E_Air';
Cnnt.L212.group = 'other';
Cnnt.L212.axis1 = 'x';
Cnnt.L212.axis2 = 'y';

Cnnt.L212.Ring2.thk = Thk.Col2.RingTop;
Cnnt.L212.Ring2.axisTT = 'z';
Cnnt.L212.Ring2.int = 1;

Cnnt.L212.Ring2.HspSN = 'ABS_C_Air';
Cnnt.L212.Ring2.HspAxis = 'x';
Cnnt.L212.Ring2.Hsp = 1750;
Cnnt.L212.Ring2.HspTol = 30;
Cnnt.L212.Ring2.HspInt = 4;

%Line213 - Ring3 edges
Cnnt.L213.SN = 'ABS_E_Air';
Cnnt.L213.group = 'other';
Cnnt.L213.axis1 = 'x';
Cnnt.L213.axis2 = 'y';

Cnnt.L213.Ring3.thk = Thk.Col2.RingTop;
Cnnt.L213.Ring3.axisTT = 'z';
Cnnt.L213.Ring3.int = 1;

Cnnt.L213.Ring3.HspSN = 'ABS_C_Air';
Cnnt.L213.Ring3.HspAxis = 'x';
Cnnt.L213.Ring3.Hsp = 1750;
Cnnt.L213.Ring3.HspTol = 30;
Cnnt.L213.Ring3.HspInt = 4;

%Line214 - Ring4 edges
Cnnt.L214.SN = 'ABS_E_Air';
Cnnt.L214.group = 'other';
Cnnt.L214.axis1 = 'x';
Cnnt.L214.axis2 = 'y';

Cnnt.L214.Ring4.thk = Thk.Col2.RingTop;
Cnnt.L214.Ring4.axisTT = 'z';
Cnnt.L214.Ring4.int = 1;

Cnnt.L214.Ring4.HspAxis = 'x';
Cnnt.L214.Ring4.HspSN = 'ABS_C_Air';
Cnnt.L214.Ring4.Hsp = 1750;
Cnnt.L214.Ring4.HspTol = 30;
Cnnt.L214.Ring4.HspInt = 4;

%Line215 - Vbar1 edges
Cnnt.L215.SN = 'ABS_E_Air';
Cnnt.L215.group = 'other';
Cnnt.L215.axis1 = 'y';
Cnnt.L215.axis2 = 'z';

Cnnt.L215.Vbar1.thk = Thk.Col2.VbarTop;
Cnnt.L215.Vbar1.axisTT = 'x';
Cnnt.L215.Vbar1.int = 1;

Cnnt.L215.Vbar1.HspAxis = 'z';
Cnnt.L215.Vbar1.Hsp = [1985, 2861.3];
Cnnt.L215.Vbar1.HspTol = 30;
Cnnt.L215.Vbar1.HspInt = 1;

%Line216 - Vbar2 edges
Cnnt.L216.SN = 'ABS_E_Air';
Cnnt.L216.group = 'other';
Cnnt.L216.axis1 = 'y';
Cnnt.L216.axis2 = 'z';

Cnnt.L216.Vbar2.thk = Thk.Col2.VbarTop;
Cnnt.L216.Vbar2.axisTT = 'x';
Cnnt.L216.Vbar2.int = 1;

Cnnt.L216.Vbar2.HspAxis = 'z';
Cnnt.L216.Vbar2.Hsp = [1985, 2861.3];
Cnnt.L216.Vbar2.HspTol = 30;
Cnnt.L216.Vbar2.HspInt = 1;

%Line217 - Bkh1 edges
Cnnt.L217.SN = 'ABS_E_Air';
Cnnt.L217.group = 'circ';
Cnnt.L217.axis = 'z';

Cnnt.L217.Bkh1.thk = Thk.Col2.Bkh;
Cnnt.L217.Bkh1.axisTT = 'x';
Cnnt.L217.Bkh1.int = 3;
Cnnt.L217.Bkh1.Hsp = [0, -725, -1500, -2861.3, -2900, -4200, -4328, -5200]; %mm
Cnnt.L217.Bkh1.HspTol = 30;

OutName = [path1 'CnntInfo.mat'];
save(OutName, 'Cnnt')
%% ItrR5_15_5 (Col1_Top)
ItrNo = 'ItrR5_15_5';
path1 = [path0 ItrNo '\'];
load([path1 'thickness.mat']);

Cnnt.Itr = ItrNo;

%Line1 - TB*IS*TF
Cnnt.L1.SN = 'ABS_E_Air';
Cnnt.L1.group = 'circ';
Cnnt.L1.axis = 'y';

Cnnt.L1.TB.thk = Thk.Col1.TB;
Cnnt.L1.TB.int = 2;
Cnnt.L1.TB.axisTT = 'x'; %through-thickness axis
Cnnt.L1.TB.SDir = 90; %degree

Cnnt.L1.TF.thk = Thk.Col1.TFin;
Cnnt.L1.TF.int = 10;
Cnnt.L1.TF.axisTT = 'z'; %through-thickness axis
Cnnt.L1.TF.HspAxis = 'y';
Cnnt.L1.TF.Hsp = -165:15:180;
Cnnt.L1.TF.HspTol = 0.5;

Cnnt.L1.TOCring.thk = Thk.Col1.TFin;
Cnnt.L1.TOCring.int = 10;
Cnnt.L1.TOCring.axisTT = 'z';

%Line2 - IS*UMB12
Cnnt.L2.SN = 'API_WJ_Air';
Cnnt.L2.group = 'circ';
Cnnt.L2.axis = 'y';

Cnnt.L2.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L2.IS.int = 2;
Cnnt.L2.IS.axisTT = 'x';
Cnnt.L2.IS.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L2.IS.HspTol = 0.5; %Tolerance in hot spot sampling
Cnnt.L2.IS.SDir = 90;

Cnnt.L2.UMB12.thk = Thk.Col1.UMB;
Cnnt.L2.UMB12.int = 3;
Cnnt.L2.UMB12.axisTT = 'x';
Cnnt.L2.UMB12.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L2.UMB12.HspTol = 0.5; 
Cnnt.L2.UMB12.SDir = 120;

%Line3 - IS*VB12
Cnnt.L3.SN = 'API_WJ_Air';
Cnnt.L3.group = 'circ';
Cnnt.L3.axis = 'y';

Cnnt.L3.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L3.IS.axisTT = 'x';
Cnnt.L3.IS.int = 2;
Cnnt.L3.IS.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L3.IS.HspTol = 0.5;
Cnnt.L3.IS.SDir = 120;

Cnnt.L3.VB12.thk = Thk.Col1.VB;
Cnnt.L3.VB12.axisTT = 'x';
Cnnt.L3.VB12.int = 3;
Cnnt.L3.VB12.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L3.VB12.HspTol = 0.5;
Cnnt.L3.VB12.SDir = 90;

%Line4 - IS*BKHs
Cnnt.L4.SN = 'ABS_E_Air';
Cnnt.L4.group = 'rad';
Cnnt.L4.axis_c = 'y';
Cnnt.L4.axis_r = 'z';

Cnnt.L4.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L4.IS.axisTT = 'x';
Cnnt.L4.IS.int = 5;
Cnnt.L4.IS.HspAxis = 'z';
Cnnt.L4.IS.Hsp = [5585, 6900,7550.3,8300,9311,9700,10700,10844,11800,12356];
Cnnt.L4.IS.HspTol = 10;
Cnnt.L4.IS.SDir = 90;

%Line5 - OS*TF
Cnnt.L5.SN = 'ABS_E_Air';
Cnnt.L5.group = 'circ';
Cnnt.L5.axis = 'y';

Cnnt.L5.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L5.OS.axisTT = 'x';
Cnnt.L5.OS.int = 20;
Cnnt.L5.OS.HspThk = Thk.Col1.OSatUMB ;
Cnnt.L5.OS.Hsp = -172.5 : 15 : 172.5;
Cnnt.L5.OS.HspTol = 0.2;
Cnnt.L5.OS.SDir = 0;

Cnnt.L5.TF.thk = Thk.Col1.TFout;
Cnnt.L5.TF.axisTT = 'z';
Cnnt.L5.TF.int = 20;
Cnnt.L5.TF.HspThk = Thk.Col1.TFatUMB ;
Cnnt.L5.TF.Hsp = -180 : 7.5 : 180;
Cnnt.L5.TF.HspTol = 0.2;
Cnnt.L5.TF.SDir = 90;

%Line6 - OS*UMB12
Cnnt.L6.SN = 'API_WJ_Air';
Cnnt.L6.group = 'circ';
Cnnt.L6.axis = 'y';

Cnnt.L6.OS.thk = Thk.Col1.OSatUMB;
Cnnt.L6.OS.axisTT = 'x';
Cnnt.L6.OS.int = 3;

Cnnt.L6.UMB12.thk = Thk.Col1.UMB;
Cnnt.L6.UMB12.axisTT = 'x';
Cnnt.L6.UMB12.int = 3;

%Line7 - OS*VB12
Cnnt.L7.SN = 'API_WJ_Air';
Cnnt.L7.group = 'circ';
Cnnt.L7.axis = 'y';

Cnnt.L7.OS.thk = Thk.Col1.OSatVB;
Cnnt.L7.OS.axisTT = 'x';
Cnnt.L7.OS.int = 3;

Cnnt.L7.VB12.thk = Thk.Col1.VB;
Cnnt.L7.VB12.axisTT = 'x';
Cnnt.L7.VB12.int = 3;

%Line8 - OS*Bkh1
Cnnt.L8.SN = 'ABS_E_Air';
Cnnt.L8.group = 'rad';
Cnnt.L8.axis_c = 'y';
Cnnt.L8.axis_r = 'z';

Cnnt.L8.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L8.OS.axisTT = 'x';
Cnnt.L8.OS.int = 10;
Cnnt.L8.OS.HspAxis = 'z';
Cnnt.L8.OS.Hsp = [0,1100,2000,2200,3300,4400,5000,5500,6900,8300,9700,10700,11800,13000];
Cnnt.L8.OS.HspTol = 10;
Cnnt.L8.OS.SDir = 0;

%Line9 - OS*TFgd
Cnnt.L9.SN = 'ABS_E_Air';
Cnnt.L9.group = 'rad';
Cnnt.L9.axis_c = 'y';
Cnnt.L9.axis_r = 'z';

Cnnt.L9.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L9.OS.axisTT = 'x';
Cnnt.L9.OS.int = 3;
Cnnt.L9.OS.HspAxis = 'y';
Cnnt.L9.OS.HspThk = Thk.Col1.OSatUMB ;
Cnnt.L9.OS.Hsp = [-150,150];
Cnnt.L9.OS.HspTol = 0.1;
Cnnt.L8.OS.SDir = 0;

%Line10 - Bkh1 four edges
Cnnt.L10.SN = 'ABS_E_Air';
Cnnt.L10.group = 'flat';
Cnnt.L10.axis1 = 'y';
Cnnt.L10.axis2 = 'z';

Cnnt.L10.Bkh1.thk = Thk.Col1.Bkh;
Cnnt.L10.Bkh1.axisTT = 'x';
Cnnt.L10.Bkh1.int = 10;

Cnnt.L10.Bkh1.path = [0,0;2750,0;2750,-13000;0,-13000];
Cnnt.L10.Bkh1.HspAxis = 'z';
Cnnt.L10.Bkh1.Hsp = 0;
Cnnt.L10.Bkh1.HspTol = 0.5;
Cnnt.L10.Bkh1.HspInt = 2;
Cnnt.L10.Bkh1.SDir = 120;

%Line11 - TFin * TFgd
Cnnt.L11.SN = 'ABS_E_Air';
Cnnt.L11.group = 'other';
Cnnt.L11.axis1 = 'y';
Cnnt.L11.axis2 = 'x';

Cnnt.L11.TF.thk = Thk.Col1.TFin;
Cnnt.L11.TF.axisTT = 'z';
Cnnt.L11.TF.int = 1;
Cnnt.L11.TF.HspAxis = 'y';
Cnnt.L11.TF.Hsp = -165:15:180;
Cnnt.L11.TF.HspTol = 0.1;
Cnnt.L11.TF.HspInt = 5;

%Line12 - TFout * TFgd
%Line13 - FB1 * UMB12
Cnnt.L13.SN = 'ABS_E_Air';
Cnnt.L13.group = 'flat';
Cnnt.L13.axis1 = 'y';
Cnnt.L13.axis2 = 'z';

Cnnt.L13.FB1.thk = Thk.Col1.FB;
Cnnt.L13.FB1.axisTT = 'x';
Cnnt.L13.FB1.int = 6;
Cnnt.L13.FB1.path = [0,0;2750,0;2750,-500;0,-500];

Cnnt.L13.FB1.HspAxis = 'z';
Cnnt.L13.FB1.Hsp = 0;
Cnnt.L13.FB1.HspTol = 0.5;
Cnnt.L13.FB1.HspInt = 3;
Cnnt.L13.FB1.SDir = 150;

%Line14 - TB * TBbrkt
Cnnt.L14.SN = 'ABS_E_Air';
Cnnt.L14.group = 'rad';
Cnnt.L14.axis_c = 'y';
Cnnt.L14.axis_r = 'z';

Cnnt.L14.TB.thk = Thk.Col1.TB;
Cnnt.L14.TB.axisTT = 'x';
Cnnt.L14.TB.int = 1;
Cnnt.L14.TB.HspAxis = 'y';
Cnnt.L14.TB.Hsp = [-120,120];
Cnnt.L14.TB.HspTol = 0.5;
Cnnt.L14.TB.SDir = 90;

%Line15 - IS * Ring1
Cnnt.L15.SN = 'ABS_E_Air';
Cnnt.L15.group = 'circ';
Cnnt.L15.axis = 'y';

Cnnt.L15.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L15.IS.axisTT = 'x';
Cnnt.L15.IS.int = 3;
Cnnt.L15.IS.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L15.IS.HspTol = 0.5;
Cnnt.L15.IS.SDir = 90;

Cnnt.L15.Ring1.thk = Thk.Col1.RingatUMB;
Cnnt.L15.Ring1.axisTT = 'z';
Cnnt.L15.Ring1.int = 10;
Cnnt.L15.Ring1.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L15.Ring1.HspTol = 0.5;
Cnnt.L15.Ring1.SDir = 0;

%Line16 - IS * Ring2
Cnnt.L16.SN = 'ABS_E_Air';
Cnnt.L16.group = 'circ';
Cnnt.L16.axis = 'y';

Cnnt.L16.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L16.IS.axisTT = 'x';
Cnnt.L16.IS.int = 3;
Cnnt.L16.IS.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L16.IS.HspTol = 0.5;
Cnnt.L16.IS.SDir = 90;

Cnnt.L16.Ring2.thk = Thk.Col1.RingatUMB;
Cnnt.L16.Ring2.axisTT = 'z';
Cnnt.L16.Ring2.int = 10;
Cnnt.L16.Ring2.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L16.Ring2.HspTol = 0.5;
Cnnt.L16.Ring2.SDir = 0;

%Line17 - IS * Ring3
Cnnt.L17.SN = 'ABS_E_Air';
Cnnt.L17.group = 'circ';
Cnnt.L17.axis = 'y';

Cnnt.L17.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L17.IS.axisTT = 'x';
Cnnt.L17.IS.int = 3;
Cnnt.L17.IS.Hsp = [-157.71, -156, -144, -142.29, -120, 120, 142.29, 144, 156, 157.71];
Cnnt.L17.IS.HspTol = 0.5;
Cnnt.L17.IS.SDir = 120;

Cnnt.L17.Ring3.thk = Thk.Col1.RingatVB;
Cnnt.L17.Ring3.axisTT = 'z';
Cnnt.L17.Ring3.int = 10;
Cnnt.L17.Ring3.Hsp = [-157.71, -156, -144, -142.29, -120, 120, 142.29, 144, 156, 157.71];
Cnnt.L17.Ring3.HspTol = 0.5;
Cnnt.L17.Ring3.SDir = 0;

%Line18 - IS * Ring4
Cnnt.L18.SN = 'ABS_E_Air';
Cnnt.L18.group = 'circ';
Cnnt.L18.axis = 'y';

Cnnt.L18.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L18.IS.axisTT = 'x';
Cnnt.L18.IS.int = 3;
Cnnt.L18.IS.Hsp = [-156.75, -156, -144, -143.25,-120, 120,  143.25, 144, 156, 156.75];
Cnnt.L18.IS.HspTol = 0.5;
Cnnt.L18.IS.SDir = 90;

Cnnt.L18.Ring4.thk = Thk.Col1.RingatVB;
Cnnt.L18.Ring4.axisTT = 'z';
Cnnt.L18.Ring4.int = 10;
Cnnt.L18.Ring4.Hsp = [-156.75, -156, -144, -143.25,-120, 120,  143.25, 144, 156, 156.75];
Cnnt.L18.Ring4.HspTol = 0.5;
Cnnt.L18.Ring4.SDir = [30 150];

%Line19 - TF * TBring
%Line20 - IS * UMB13
Cnnt.L20.SN = 'API_WJ_Air';
Cnnt.L20.group = 'circ';
Cnnt.L20.axis = 'y';

Cnnt.L20.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L20.IS.axisTT = 'x';
Cnnt.L20.IS.int = 2;
Cnnt.L20.IS.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L20.IS.HspTol = 0.5; %Tolerance in hot spot sampling
Cnnt.L20.IS.SDir = 90;

Cnnt.L20.UMB13.thk = Thk.Col1.UMB;
Cnnt.L20.UMB13.axisTT = 'x';
Cnnt.L20.UMB13.int = 3;
Cnnt.L20.UMB13.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L20.UMB13.HspTol = 0.5; 
Cnnt.L20.UMB13.SDir = 60;

%Line21 - IS * VB13
Cnnt.L21.SN = 'API_WJ_Air';
Cnnt.L21.group = 'circ';
Cnnt.L21.axis = 'y';

Cnnt.L21.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L21.IS.axisTT = 'x';
Cnnt.L21.IS.int = 2;
Cnnt.L21.IS.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L21.IS.HspTol = 0.5;
Cnnt.L21.IS.SDir = 60;

Cnnt.L21.VB13.thk = Thk.Col1.VB;
Cnnt.L21.VB13.axisTT = 'x';
Cnnt.L21.VB13.int = 3;
Cnnt.L21.VB13.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L21.VB13.HspTol = 0.5;
Cnnt.L21.VB13.SDir = 90;

%Line22 - OS * UMB13
Cnnt.L22.SN = 'API_WJ_Air';
Cnnt.L22.group = 'circ';
Cnnt.L22.axis = 'y';

Cnnt.L22.OS.thk = Thk.Col1.OSatUMB;
Cnnt.L22.OS.axisTT = 'x';
Cnnt.L22.OS.int = 3;

Cnnt.L22.UMB13.thk = Thk.Col1.UMB;
Cnnt.L22.UMB13.axisTT = 'x';
Cnnt.L22.UMB13.int = 3;

%Line23 - OS * VB13
Cnnt.L23.SN = 'API_WJ_Air';
Cnnt.L23.group = 'circ';
Cnnt.L23.axis = 'y';

Cnnt.L23.OS.thk = Thk.Col1.OSatVB;
Cnnt.L23.OS.axisTT = 'x';
Cnnt.L23.OS.int = 3;

Cnnt.L23.VB13.thk = Thk.Col1.VB;
Cnnt.L23.VB13.axisTT = 'x';
Cnnt.L23.VB13.int = 3;

%Line24 - Bkh2 two edges
Cnnt.L24.SN = 'ABS_E_Air';
Cnnt.L24.group = 'flat';
Cnnt.L24.axis1 = 'y';
Cnnt.L24.axis2 = 'z';

Cnnt.L24.Bkh2.thk = Thk.Col1.Bkh;
Cnnt.L24.Bkh2.axisTT = 'x';
Cnnt.L24.Bkh2.int = 10;
Cnnt.L24.Bkh2.path = [0,0;-2750,0;-2750,-13000;0,-13000];
Cnnt.L24.Bkh2.HspAxis = 'z';
Cnnt.L24.Bkh2.Hsp = 0;
Cnnt.L24.Bkh2.HspTol = 0.5;
Cnnt.L24.Bkh2.HspInt = 2;
Cnnt.L24.Bkh2.SDir = 60;

%Line25 - FB2 four edges
Cnnt.L25.SN = 'ABS_E_Air';
Cnnt.L25.group = 'flat';
Cnnt.L25.axis1 = 'y';
Cnnt.L25.axis2 = 'z';

Cnnt.L25.FB2.thk = Thk.Col1.FB;
Cnnt.L25.FB2.axisTT = 'x';
Cnnt.L25.FB2.int = 6;
Cnnt.L25.FB2.path = [0,0;-2750,0;-2750,-500;0,-500];
Cnnt.L25.FB2.HspAxis = 'z';
Cnnt.L25.FB2.Hsp = 0;
Cnnt.L25.FB2.HspTol = 0.5;
Cnnt.L25.FB2.HspInt = 3;
Cnnt.L25.FB2.SDir = 30;

%Line26 - IS opening
Cnnt.L26.SN = 'ABS_C_Air';
Cnnt.L26.group = 'flat';
Cnnt.L26.axis1 = 'y';
Cnnt.L26.axis2 = 'z';

Cnnt.L26.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L26.IS.axisTT = 'x';
Cnnt.L26.IS.int = 2;

%Line27 - VB12lwr * LMB12mid
%Line28 - VB21lwr * LMB12mid
%Line29 - VB13lwr * LMB13mid
%Line30 - VB31lwr * LMB13mid
%Line31 - IS * C-Plate

%Line32 - Vbar1 (at Bkh1) four edge
Cnnt.L32.SN = 'ABS_E_Air';
Cnnt.L32.group = 'other';
Cnnt.L32.axis1 = 'x';
Cnnt.L32.axis2 = 'z';

Cnnt.L32.Vbar1.thk = Thk.Col1.VBaratBkh;
Cnnt.L32.Vbar1.axisTT = 'y';
Cnnt.L32.Vbar1.int = 1;

Cnnt.L32.Vbar1.HspAxis = 'x';
Cnnt.L32.Vbar1.Hsp = [2550, 3250];
Cnnt.L32.Vbar1.HspTol = 0.5;
Cnnt.L32.Vbar1.HspInt = 4;
Cnnt.L32.Vbar1.SDir = 60;

%Line33 - Vbar2 (at Bkh2) four edge
Cnnt.L33.SN = 'ABS_E_Air';
Cnnt.L33.group = 'other';
Cnnt.L33.axis1 = 'x';
Cnnt.L33.axis2 = 'z';

Cnnt.L33.Vbar2.thk = Thk.Col1.VBaratBkh;
Cnnt.L33.Vbar2.axisTT = 'y';
Cnnt.L33.Vbar2.int = 1;

Cnnt.L33.Vbar2.HspAxis = 'x';
Cnnt.L33.Vbar2.Hsp = [2550, 3250];
Cnnt.L33.Vbar2.HspTol = 0.5;
Cnnt.L33.Vbar2.HspInt = 4;
Cnnt.L33.Vbar2.SDir = 60;

%Line34 - Vbar3 (at UMBVB12) four edge
Cnnt.L34.SN = 'ABS_E_Air';
Cnnt.L34.group = 'other';
Cnnt.L34.axis1 = 'x';
Cnnt.L34.axis2 = 'z';

Cnnt.L34.Vbar3.thk = Thk.Col1.VBaratTruss;
Cnnt.L34.Vbar3.axisTT = 'y';
Cnnt.L34.Vbar3.int = 1;

Cnnt.L34.Vbar3.HspAxis = 'x';
Cnnt.L34.Vbar3.Hsp = [2550, 3250];
Cnnt.L34.Vbar3.HspTol = 0.5;
Cnnt.L34.Vbar3.HspInt = 4;
Cnnt.L34.Vbar3.SDir = 90;

%Line35 - Vbar4 (at UMBVB12) four edge
Cnnt.L35.SN = 'ABS_E_Air';
Cnnt.L35.group = 'other';
Cnnt.L35.axis1 = 'x';
Cnnt.L35.axis2 = 'z';

Cnnt.L35.Vbar4.thk = Thk.Col1.VBaratTruss;
Cnnt.L35.Vbar4.axisTT = 'y';
Cnnt.L35.Vbar4.int = 1;
Cnnt.L35.Vbar4.path = [];
Cnnt.L35.Vbar4.HspAxis = 'x';
Cnnt.L35.Vbar4.Hsp = [2550, 3250];
Cnnt.L35.Vbar4.HspTol = 0.5;
Cnnt.L35.Vbar4.HspInt = 4;
Cnnt.L35.Vbar4.SDir = 90;

%Line36 - Vbar5 (at UMBVB13) four edge
Cnnt.L36.SN = 'ABS_E_Air';
Cnnt.L36.group = 'other';
Cnnt.L36.axis1 = 'x';
Cnnt.L36.axis2 = 'z';

Cnnt.L36.Vbar5.thk = Thk.Col1.VBaratTruss;
Cnnt.L36.Vbar5.axisTT = 'y';
Cnnt.L36.Vbar5.int = 1;

Cnnt.L36.Vbar5.HspAxis = 'x';
Cnnt.L36.Vbar5.Hsp = [2550, 3250];
Cnnt.L36.Vbar5.HspTol = 0.5;
Cnnt.L36.Vbar5.HspInt = 4;
Cnnt.L36.Vbar5.SDir = 90;

%Line37 - Vbar6 (at UMBVB13) four edge
Cnnt.L37.SN = 'ABS_E_Air';
Cnnt.L37.group = 'other';
Cnnt.L37.axis1 = 'x';
Cnnt.L37.axis2 = 'z';

Cnnt.L37.Vbar6.thk = Thk.Col1.VBaratTruss;
Cnnt.L37.Vbar6.axisTT = 'y';
Cnnt.L37.Vbar6.int = 1;

Cnnt.L37.Vbar6.HspAxis = 'x';
Cnnt.L37.Vbar6.Hsp = [2550, 3250];
Cnnt.L37.Vbar6.HspTol = 0.5;
Cnnt.L37.Vbar6.HspInt = 4;
Cnnt.L37.Vbar6.SDir = 90;

%Line38 - Ring1 inner edges and connection with Vbars
Cnnt.L38.SN = 'ABS_C_Air';
Cnnt.L38.group = 'other';
Cnnt.L38.axis1 = 'x';
Cnnt.L38.axis2 = 'y';

Cnnt.L38.Ring1.thk = Thk.Col1.RingatUMB;
Cnnt.L38.Ring1.axisTT = 'z';
Cnnt.L38.Ring1.int = 4;

Cnnt.L38.Ring1.HspAxis = 'y';
Cnnt.L38.Ring1.Hsp = [-156, -144, -120, 120, 144, 156];
Cnnt.L38.Ring1.HspSN = 'ABS_E_Air';
Cnnt.L38.Ring1.HspTol = 0.5;
Cnnt.L38.Ring1.HspInt = 1;
Cnnt.L38.Ring1.SDir = 90;

%Line39 - Ring2 inner edges and connection with Vbars
Cnnt.L39.SN = 'ABS_C_Air';
Cnnt.L39.group = 'other';
Cnnt.L39.axis1 = 'x';
Cnnt.L39.axis2 = 'y';

Cnnt.L39.Ring2.thk = Thk.Col1.RingatUMB;
Cnnt.L39.Ring2.axisTT = 'z';
Cnnt.L39.Ring2.int = 4;

Cnnt.L39.Ring2.HspAxis = 'y';
Cnnt.L39.Ring2.Hsp = [-156, -144, -120, 120, 144, 156];
Cnnt.L39.Ring2.HspSN = 'ABS_E_Air';
Cnnt.L39.Ring2.HspTol = 0.5;
Cnnt.L39.Ring2.HspInt = 1;
Cnnt.L39.Ring2.SDir = 90;

%Line40 - Ring3 inner edges and connection with Vbars
Cnnt.L40.SN = 'ABS_C_Air';
Cnnt.L40.group = 'other';
Cnnt.L40.axis1 = 'x';
Cnnt.L40.axis2 = 'y';

Cnnt.L40.Ring3.thk = Thk.Col1.RingatVB;
Cnnt.L40.Ring3.axisTT = 'z';
Cnnt.L40.Ring3.int = 4;

Cnnt.L40.Ring3.HspAxis = 'y';
Cnnt.L40.Ring3.Hsp = [-156, -144, -120, 120, 144, 156];
Cnnt.L40.Ring3.HspSN = 'ABS_E_Air';
Cnnt.L40.Ring3.HspTol = 0.5;
Cnnt.L40.Ring3.HspInt = 1;
Cnnt.L40.Ring3.SDir = 90;

%Line41 - Ring4 inner edges and connection with Vbars
Cnnt.L41.SN = 'ABS_C_Air';
Cnnt.L41.group = 'other';
Cnnt.L41.axis1 = 'x';
Cnnt.L41.axis2 = 'y';

Cnnt.L41.Ring4.thk = Thk.Col1.RingatVB;
Cnnt.L41.Ring4.axisTT = 'z';
Cnnt.L41.Ring4.int = 4;

Cnnt.L41.Ring4.HspAxis = 'y';
Cnnt.L41.Ring4.Hsp = [-156, -144, -120, 120, 144, 156];
Cnnt.L41.Ring4.HspSN = 'ABS_E_Air';
Cnnt.L41.Ring4.HspTol = 0.5;
Cnnt.L41.Ring4.HspInt = 1;
Cnnt.L41.Ring4.SDir = 90;

%Line42 - TBBrkt1 (at Bkh1)
Cnnt.L42.SN = 'ABS_C_Air';
Cnnt.L42.group = 'other';
Cnnt.L42.axis1 = 'x';
Cnnt.L42.axis2 = 'z';

Cnnt.L42.TBBrkt1.thk = Thk.Col1.Brkt_TBatBkh;
Cnnt.L42.TBBrkt1.axisTT = 'y';
Cnnt.L42.TBBrkt1.int = 1;

Cnnt.L42.TBBrkt1.HspAxis = 'x';
Cnnt.L42.TBBrkt1.Hsp = 3250;
Cnnt.L42.TBBrkt1.HspAxis2 = 'z';
Cnnt.L42.TBBrkt1.Hsp2 = 13000;

Cnnt.L42.TBBrkt1.HspSN = 'ABS_E_Air';
Cnnt.L42.TBBrkt1.HspTol = 15;
Cnnt.L42.TBBrkt1.HspInt = 2;
Cnnt.L42.TBBrkt1.SDir = 120;

%Line43 - TBBrkt1 (at FB1)
Cnnt.L43.SN = 'ABS_C_Air';
Cnnt.L43.group = 'other';
Cnnt.L43.axis1 = 'x';
Cnnt.L43.axis2 = 'z';

Cnnt.L43.TBBrkt2.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L43.TBBrkt2.axisTT = 'y';
Cnnt.L43.TBBrkt2.int = 1;

Cnnt.L43.TBBrkt2.HspAxis = 'x';
Cnnt.L43.TBBrkt2.Hsp = 3250;
Cnnt.L43.TBBrkt2.HspAxis2 = 'z';
Cnnt.L43.TBBrkt2.Hsp2 = 13000;

Cnnt.L43.TBBrkt2.HspSN = 'ABS_E_Air';
Cnnt.L43.TBBrkt2.HspTol = 15;
Cnnt.L43.TBBrkt2.HspInt = 2;
Cnnt.L43.TBBrkt2.SDir = 120;

%Line42 - TBBrkt1 (at OS*FB1)
Cnnt.L44.SN = 'ABS_C_Air';
Cnnt.L44.group = 'other';
Cnnt.L44.axis1 = 'x';
Cnnt.L44.axis2 = 'z';

Cnnt.L44.TBBrkt3.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L44.TBBrkt3.axisTT = 'y';
Cnnt.L44.TBBrkt3.int = 1;

Cnnt.L44.TBBrkt3.HspAxis = 'x';
Cnnt.L44.TBBrkt3.Hsp = 6000;
Cnnt.L44.TBBrkt3.HspAxis2 = 'z';
Cnnt.L44.TBBrkt3.Hsp2 = 12500;

Cnnt.L44.TBBrkt3.HspSN = 'ABS_E_Air';
Cnnt.L44.TBBrkt3.HspTol = 15;
Cnnt.L44.TBBrkt3.HspInt = 2;
Cnnt.L44.TBBrkt3.SDir = 150;

%Line45 - TBBrkt4 (at Bkh2)
Cnnt.L45.SN = 'ABS_C_Air';
Cnnt.L45.group = 'other';
Cnnt.L45.axis1 = 'x';
Cnnt.L45.axis2 = 'z';

Cnnt.L45.TBBrkt4.thk = Thk.Col1.Brkt_TBatBkh;
Cnnt.L45.TBBrkt4.axisTT = 'y';
Cnnt.L45.TBBrkt4.int = 1;

Cnnt.L45.TBBrkt4.HspAxis = 'x';
Cnnt.L45.TBBrkt4.Hsp = 3250;
Cnnt.L45.TBBrkt4.HspAxis2 = 'z';
Cnnt.L45.TBBrkt4.Hsp2 = 13000;

Cnnt.L45.TBBrkt4.HspSN = 'ABS_E_Air';
Cnnt.L45.TBBrkt4.HspTol = 15;
Cnnt.L45.TBBrkt4.HspInt = 2;
Cnnt.L45.TBBrkt4.SDir = 120;

%Line46 - TBBrkt5 (at FB2)
Cnnt.L46.SN = 'ABS_C_Air';
Cnnt.L46.group = 'other';
Cnnt.L46.axis1 = 'x';
Cnnt.L46.axis2 = 'z';

Cnnt.L46.TBBrkt5.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L46.TBBrkt5.axisTT = 'y';
Cnnt.L46.TBBrkt5.int = 1;

Cnnt.L46.TBBrkt5.HspAxis = 'x';
Cnnt.L46.TBBrkt5.Hsp = 3250;
Cnnt.L46.TBBrkt5.HspAxis2 = 'z';
Cnnt.L46.TBBrkt5.Hsp2 = 13000;

Cnnt.L46.TBBrkt5.HspSN = 'ABS_E_Air';
Cnnt.L46.TBBrkt5.HspTol = 15;
Cnnt.L46.TBBrkt5.HspInt = 2;
Cnnt.L46.TBBrkt5.SDir = 120;

%Line47 - TBBrkt6 (at OS*FB2)
Cnnt.L47.SN = 'ABS_C_Air';
Cnnt.L47.group = 'other';
Cnnt.L47.axis1 = 'x';
Cnnt.L47.axis2 = 'z';

Cnnt.L47.TBBrkt6.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L47.TBBrkt6.axisTT = 'y';
Cnnt.L47.TBBrkt6.int = 1;

Cnnt.L47.TBBrkt6.HspAxis = 'x';
Cnnt.L47.TBBrkt6.Hsp = 6000;
Cnnt.L47.TBBrkt6.HspAxis2 = 'z';
Cnnt.L47.TBBrkt6.Hsp2 = 12500;

Cnnt.L47.TBBrkt6.HspSN = 'ABS_E_Air';
Cnnt.L47.TBBrkt6.HspTol = 15;
Cnnt.L47.TBBrkt6.HspInt = 2;
Cnnt.L47.TBBrkt6.SDir = 150;

OutName = [path1 'CnntInfo.mat'];
save(OutName, 'Cnnt')
%% ItrR5_15_6 (Col1_Top)
ItrNo = 'ItrR5_15_6';
path1 = [path0 ItrNo '\'];
load([path1 'thickness.mat']);

Cnnt.Itr = ItrNo;

%Line1 - TB*IS*TF
Cnnt.L1.SN = 'ABS_E_Air';
Cnnt.L1.group = 'circ';
Cnnt.L1.axis = 'y';

Cnnt.L1.TB.thk = Thk.Col1.TB;
Cnnt.L1.TB.int = 2;
Cnnt.L1.TB.axisTT = 'x'; %through-thickness axis
Cnnt.L1.TB.SDir = 90; %degree

Cnnt.L1.TF.thk = Thk.Col1.TFin;
Cnnt.L1.TF.int = 10;
Cnnt.L1.TF.axisTT = 'z'; %through-thickness axis

Cnnt.L1.TOCring.thk = Thk.Col1.TFin;
Cnnt.L1.TOCring.int = 10;
Cnnt.L1.TOCring.axisTT = 'z';

%Line2 - IS*UMB12
Cnnt.L2.SN = 'API_WJ_Air';
Cnnt.L2.group = 'circ';
Cnnt.L2.axis = 'y';

Cnnt.L2.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L2.IS.int = 2;
Cnnt.L2.IS.axisTT = 'x';
Cnnt.L2.IS.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L2.IS.HspTol = 0.5; %Tolerance in hot spot sampling
Cnnt.L2.IS.SDir = 90;

Cnnt.L2.UMB12.thk = Thk.Col1.UMB;
Cnnt.L2.UMB12.int = 3;
Cnnt.L2.UMB12.axisTT = 'x';
Cnnt.L2.UMB12.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L2.UMB12.HspTol = 0.5; 
Cnnt.L2.UMB12.SDir = 120;

%Line3 - IS*VB12
Cnnt.L3.SN = 'API_WJ_Air';
Cnnt.L3.group = 'circ';
Cnnt.L3.axis = 'y';

Cnnt.L3.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L3.IS.axisTT = 'x';
Cnnt.L3.IS.int = 2;
Cnnt.L3.IS.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L3.IS.HspTol = 0.5;
Cnnt.L3.IS.SDir = 120;

Cnnt.L3.VB12.thk = Thk.Col1.VB;
Cnnt.L3.VB12.axisTT = 'x';
Cnnt.L3.VB12.int = 3;
Cnnt.L3.VB12.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L3.VB12.HspTol = 0.5;
Cnnt.L3.VB12.SDir = 90;

%Line4 - IS*BKHs
Cnnt.L4.SN = 'ABS_E_Air';
Cnnt.L4.group = 'rad';
Cnnt.L4.axis_c = 'y';
Cnnt.L4.axis_r = 'z';

Cnnt.L4.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L4.IS.axisTT = 'x';
Cnnt.L4.IS.int = 5;
Cnnt.L4.IS.HspAxis = 'z';
Cnnt.L4.IS.Hsp = [5585, 6900,7550.3,8300,9311,9700,10700,10844,11800,12356];
Cnnt.L4.IS.HspTol = 10;
Cnnt.L4.IS.SDir = 90;

%Line5 - OS*TF
Cnnt.L5.SN = 'ABS_E_Air';
Cnnt.L5.group = 'circ';
Cnnt.L5.axis = 'y';

Cnnt.L5.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L5.OS.axisTT = 'x';
Cnnt.L5.OS.int = 20;
Cnnt.L5.OS.HspThk = Thk.Col1.OSatUMB ;
Cnnt.L5.OS.Hsp = -172.5 : 15 : 172.5;
Cnnt.L5.OS.HspTol = 0.2;
Cnnt.L5.OS.SDir = 0;

Cnnt.L5.TF.thk = Thk.Col1.TFout;
Cnnt.L5.TF.axisTT = 'z';
Cnnt.L5.TF.int = 20;
Cnnt.L5.TF.HspThk = Thk.Col1.TFatUMB ;
Cnnt.L5.TF.Hsp = -180 : 7.5 : 180;
Cnnt.L5.TF.HspTol = 0.2;
Cnnt.L5.TF.SDir = 90;

%Line6 - OS*UMB12
Cnnt.L6.SN = 'API_WJ_Air';
Cnnt.L6.group = 'circ';
Cnnt.L6.axis = 'y';

Cnnt.L6.OS.thk = Thk.Col1.OSatUMB;
Cnnt.L6.OS.axisTT = 'x';
Cnnt.L6.OS.int = 3;

Cnnt.L6.UMB12.thk = Thk.Col1.UMB;
Cnnt.L6.UMB12.axisTT = 'x';
Cnnt.L6.UMB12.int = 3;

%Line7 - OS*VB12
Cnnt.L7.SN = 'API_WJ_Air';
Cnnt.L7.group = 'circ';
Cnnt.L7.axis = 'y';

Cnnt.L7.OS.thk = Thk.Col1.OSatVB;
Cnnt.L7.OS.axisTT = 'x';
Cnnt.L7.OS.int = 3;

Cnnt.L7.VB12.thk = Thk.Col1.VB;
Cnnt.L7.VB12.axisTT = 'x';
Cnnt.L7.VB12.int = 3;

%Line8 - OS*Bkh1
Cnnt.L8.SN = 'ABS_E_Air';
Cnnt.L8.group = 'rad';
Cnnt.L8.axis_c = 'y';
Cnnt.L8.axis_r = 'z';

Cnnt.L8.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L8.OS.axisTT = 'x';
Cnnt.L8.OS.int = 10;
Cnnt.L8.OS.HspAxis = 'z';
Cnnt.L8.OS.Hsp = [0,1100,2000,2200,3300,4400,5000,5500,6900,8300,9700,10700,11800,13000];
Cnnt.L8.OS.HspTol = 10;
Cnnt.L8.OS.SDir = 0;

%Line9 - OS*TFgd
Cnnt.L9.SN = 'ABS_E_Air';
Cnnt.L9.group = 'rad';
Cnnt.L9.axis_c = 'y';
Cnnt.L9.axis_r = 'z';

Cnnt.L9.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L9.OS.axisTT = 'x';
Cnnt.L9.OS.int = 3;
Cnnt.L9.OS.HspAxis = 'y';
Cnnt.L9.OS.HspThk = Thk.Col1.OSatUMB ;
Cnnt.L9.OS.Hsp = [-150,150];
Cnnt.L9.OS.HspTol = 0.1;
Cnnt.L8.OS.SDir = 0;

%Line10 - Bkh1 four edges
Cnnt.L10.SN = 'ABS_E_Air';
Cnnt.L10.group = 'flat';
Cnnt.L10.axis1 = 'y';
Cnnt.L10.axis2 = 'z';

Cnnt.L10.Bkh1.thk = Thk.Col1.Bkh;
Cnnt.L10.Bkh1.axisTT = 'x';
Cnnt.L10.Bkh1.int = 10;

Cnnt.L10.Bkh1.path = [0,0;2750,0;2750,-13000;0,-13000];
Cnnt.L10.Bkh1.HspAxis = 'z';
Cnnt.L10.Bkh1.Hsp = 0;
Cnnt.L10.Bkh1.HspTol = 0.5;
Cnnt.L10.Bkh1.HspInt = 2;
Cnnt.L10.Bkh1.SDir = 120;

%Line11 - TFin * TFgd
Cnnt.L11.SN = 'ABS_E_Air';
Cnnt.L11.group = 'other';
Cnnt.L11.axis1 = 'y';
Cnnt.L11.axis2 = 'x';

Cnnt.L11.TF.thk = Thk.Col1.TFin;
Cnnt.L11.TF.axisTT = 'z';
Cnnt.L11.TF.int = 1;
Cnnt.L11.TF.HspAxis = 'y';
Cnnt.L11.TF.Hsp = -165:15:180;
Cnnt.L11.TF.HspTol = 0.1;
Cnnt.L11.TF.HspInt = 2;

%Line12 - TFout * TFgd
%Line13 - FB1 * UMB12
Cnnt.L13.SN = 'ABS_E_Air';
Cnnt.L13.group = 'flat';
Cnnt.L13.axis1 = 'y';
Cnnt.L13.axis2 = 'z';

Cnnt.L13.FB1.thk = Thk.Col1.FB;
Cnnt.L13.FB1.axisTT = 'x';
Cnnt.L13.FB1.int = 6;
Cnnt.L13.FB1.path = [0,0;2750,0;2750,-500;0,-500];

Cnnt.L13.FB1.HspAxis = 'z';
Cnnt.L13.FB1.Hsp = 0;
Cnnt.L13.FB1.HspTol = 0.5;
Cnnt.L13.FB1.HspInt = 3;
Cnnt.L13.FB1.SDir = 150;

%Line14 - TB * TBbrkt
Cnnt.L14.SN = 'ABS_E_Air';
Cnnt.L14.group = 'rad';
Cnnt.L14.axis_c = 'y';
Cnnt.L14.axis_r = 'z';

Cnnt.L14.TB.thk = Thk.Col1.TB;
Cnnt.L14.TB.axisTT = 'x';
Cnnt.L14.TB.int = 1;
Cnnt.L14.TB.HspAxis = 'y';
Cnnt.L14.TB.Hsp = [-120,120];
Cnnt.L14.TB.HspTol = 0.5;
Cnnt.L14.TB.SDir = 90;

%Line15 - IS * Ring1
Cnnt.L15.SN = 'ABS_E_Air';
Cnnt.L15.group = 'circ';
Cnnt.L15.axis = 'y';

Cnnt.L15.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L15.IS.axisTT = 'x';
Cnnt.L15.IS.int = 3;
Cnnt.L15.IS.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L15.IS.HspTol = 0.5;
Cnnt.L15.IS.SDir = 90;

Cnnt.L15.Ring1.thk = Thk.Col1.RingatUMB;
Cnnt.L15.Ring1.axisTT = 'z';
Cnnt.L15.Ring1.int = 10;
Cnnt.L15.Ring1.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L15.Ring1.HspTol = 0.5;
Cnnt.L15.Ring1.SDir = 0;

%Line16 - IS * Ring2
Cnnt.L16.SN = 'ABS_E_Air';
Cnnt.L16.group = 'circ';
Cnnt.L16.axis = 'y';

Cnnt.L16.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L16.IS.axisTT = 'x';
Cnnt.L16.IS.int = 3;
Cnnt.L16.IS.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L16.IS.HspTol = 0.5;
Cnnt.L16.IS.SDir = 90;

Cnnt.L16.Ring2.thk = Thk.Col1.RingatUMB;
Cnnt.L16.Ring2.axisTT = 'z';
Cnnt.L16.Ring2.int = 10;
Cnnt.L16.Ring2.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L16.Ring2.HspTol = 0.5;
Cnnt.L16.Ring2.SDir = 0;

%Line17 - IS * Ring3
Cnnt.L17.SN = 'ABS_E_Air';
Cnnt.L17.group = 'circ';
Cnnt.L17.axis = 'y';

Cnnt.L17.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L17.IS.axisTT = 'x';
Cnnt.L17.IS.int = 3;
Cnnt.L17.IS.Hsp = [-157.71, -156, -144, -142.29, -120, 120, 142.29, 144, 156, 157.71];
Cnnt.L17.IS.HspTol = 0.5;
Cnnt.L17.IS.SDir = 120;

Cnnt.L17.Ring3.thk = Thk.Col1.RingatVB;
Cnnt.L17.Ring3.axisTT = 'z';
Cnnt.L17.Ring3.int = 10;
Cnnt.L17.Ring3.Hsp = [-157.71, -156, -144, -142.29, -120, 120, 142.29, 144, 156, 157.71];
Cnnt.L17.Ring3.HspTol = 0.5;
Cnnt.L17.Ring3.SDir = 0;

%Line18 - IS * Ring4
Cnnt.L18.SN = 'ABS_E_Air';
Cnnt.L18.group = 'circ';
Cnnt.L18.axis = 'y';

Cnnt.L18.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L18.IS.axisTT = 'x';
Cnnt.L18.IS.int = 3;
Cnnt.L18.IS.Hsp = [-156.75, -156, -144, -143.25,-120, 120,  143.25, 144, 156, 156.75];
Cnnt.L18.IS.HspTol = 0.5;
Cnnt.L18.IS.SDir = 90;

Cnnt.L18.Ring4.thk = Thk.Col1.RingatVB;
Cnnt.L18.Ring4.axisTT = 'z';
Cnnt.L18.Ring4.int = 10;
Cnnt.L18.Ring4.Hsp = [-156.75, -156, -144, -143.25,-120, 120,  143.25, 144, 156, 156.75];
Cnnt.L18.Ring4.HspTol = 0.5;
Cnnt.L18.Ring4.SDir = [30 150];

%Line19 - TF * TBring
%Line20 - IS * UMB13
Cnnt.L20.SN = 'API_WJ_Air';
Cnnt.L20.group = 'circ';
Cnnt.L20.axis = 'y';

Cnnt.L20.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L20.IS.axisTT = 'x';
Cnnt.L20.IS.int = 2;
Cnnt.L20.IS.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L20.IS.HspTol = 0.5; %Tolerance in hot spot sampling
Cnnt.L20.IS.SDir = 90;

Cnnt.L20.UMB13.thk = Thk.Col1.UMB;
Cnnt.L20.UMB13.axisTT = 'x';
Cnnt.L20.UMB13.int = 3;
Cnnt.L20.UMB13.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L20.UMB13.HspTol = 0.5; 
Cnnt.L20.UMB13.SDir = 60;

%Line21 - IS * VB13
Cnnt.L21.SN = 'API_WJ_Air';
Cnnt.L21.group = 'circ';
Cnnt.L21.axis = 'y';

Cnnt.L21.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L21.IS.axisTT = 'x';
Cnnt.L21.IS.int = 2;
Cnnt.L21.IS.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L21.IS.HspTol = 0.5;
Cnnt.L21.IS.SDir = 60;

Cnnt.L21.VB13.thk = Thk.Col1.VB;
Cnnt.L21.VB13.axisTT = 'x';
Cnnt.L21.VB13.int = 3;
Cnnt.L21.VB13.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L21.VB13.HspTol = 0.5;
Cnnt.L21.VB13.SDir = 90;

%Line22 - OS * UMB13
Cnnt.L22.SN = 'API_WJ_Air';
Cnnt.L22.group = 'circ';
Cnnt.L22.axis = 'y';

Cnnt.L22.OS.thk = Thk.Col1.OSatUMB;
Cnnt.L22.OS.axisTT = 'x';
Cnnt.L22.OS.int = 3;

Cnnt.L22.UMB13.thk = Thk.Col1.UMB;
Cnnt.L22.UMB13.axisTT = 'x';
Cnnt.L22.UMB13.int = 3;

%Line23 - OS * VB13
Cnnt.L23.SN = 'API_WJ_Air';
Cnnt.L23.group = 'circ';
Cnnt.L23.axis = 'y';

Cnnt.L23.OS.thk = Thk.Col1.OSatVB;
Cnnt.L23.OS.axisTT = 'x';
Cnnt.L23.OS.int = 3;

Cnnt.L23.VB13.thk = Thk.Col1.VB;
Cnnt.L23.VB13.axisTT = 'x';
Cnnt.L23.VB13.int = 3;

%Line24 - Bkh2 two edges
Cnnt.L24.SN = 'ABS_E_Air';
Cnnt.L24.group = 'flat';
Cnnt.L24.axis1 = 'y';
Cnnt.L24.axis2 = 'z';

Cnnt.L24.Bkh2.thk = Thk.Col1.Bkh;
Cnnt.L24.Bkh2.axisTT = 'x';
Cnnt.L24.Bkh2.int = 10;
Cnnt.L24.Bkh2.path = [0,0;-2750,0;-2750,-13000;0,-13000];
Cnnt.L24.Bkh2.HspAxis = 'z';
Cnnt.L24.Bkh2.Hsp = 0;
Cnnt.L24.Bkh2.HspTol = 0.5;
Cnnt.L24.Bkh2.HspInt = 2;
Cnnt.L24.Bkh2.SDir = 60;

%Line25 - FB2 four edges
Cnnt.L25.SN = 'ABS_E_Air';
Cnnt.L25.group = 'flat';
Cnnt.L25.axis1 = 'y';
Cnnt.L25.axis2 = 'z';

Cnnt.L25.FB2.thk = Thk.Col1.FB;
Cnnt.L25.FB2.axisTT = 'x';
Cnnt.L25.FB2.int = 6;
Cnnt.L25.FB2.path = [0,0;-2750,0;-2750,-500;0,-500];
Cnnt.L25.FB2.HspAxis = 'z';
Cnnt.L25.FB2.Hsp = -500;
Cnnt.L25.FB2.HspTol = 0.5;
Cnnt.L25.FB2.HspInt = 3;
Cnnt.L25.FB2.SDir = 30;

%Line26 - IS opening
Cnnt.L26.SN = 'ABS_C_Air';
Cnnt.L26.group = 'flat';
Cnnt.L26.axis1 = 'y';
Cnnt.L26.axis2 = 'z';

Cnnt.L26.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L26.IS.axisTT = 'x';
Cnnt.L26.IS.int = 2;

%Line27 - VB12lwr * LMB12mid
%Line28 - VB21lwr * LMB12mid
%Line29 - VB13lwr * LMB13mid
%Line30 - VB31lwr * LMB13mid
%Line31 - IS * C-Plate

%Line32 - Vbar1 (at Bkh1) four edge
Cnnt.L32.SN = 'ABS_E_Air';
Cnnt.L32.group = 'other';
Cnnt.L32.axis1 = 'x';
Cnnt.L32.axis2 = 'z';

Cnnt.L32.Vbar1.thk = Thk.Col1.VBaratBkh;
Cnnt.L32.Vbar1.axisTT = 'y';
Cnnt.L32.Vbar1.int = 1;

Cnnt.L32.Vbar1.HspAxis = 'x';
Cnnt.L32.Vbar1.Hsp = [2550, 3250];
Cnnt.L32.Vbar1.HspTol = 0.5;
Cnnt.L32.Vbar1.HspInt = 4;
Cnnt.L32.Vbar1.SDir = 60;

%Line33 - Vbar2 (at Bkh2) four edge
Cnnt.L33.SN = 'ABS_E_Air';
Cnnt.L33.group = 'other';
Cnnt.L33.axis1 = 'x';
Cnnt.L33.axis2 = 'z';

Cnnt.L33.Vbar2.thk = Thk.Col1.VBaratBkh;
Cnnt.L33.Vbar2.axisTT = 'y';
Cnnt.L33.Vbar2.int = 1;

Cnnt.L33.Vbar2.HspAxis = 'x';
Cnnt.L33.Vbar2.Hsp = [2550, 3250];
Cnnt.L33.Vbar2.HspTol = 0.5;
Cnnt.L33.Vbar2.HspInt = 4;
Cnnt.L33.Vbar2.SDir = 60;

%Line34 - Vbar3 (at UMBVB12) four edge
Cnnt.L34.SN = 'ABS_E_Air';
Cnnt.L34.group = 'other';
Cnnt.L34.axis1 = 'x';
Cnnt.L34.axis2 = 'z';

Cnnt.L34.Vbar3.thk = Thk.Col1.VBaratTruss;
Cnnt.L34.Vbar3.axisTT = 'y';
Cnnt.L34.Vbar3.int = 1;

Cnnt.L34.Vbar3.HspAxis = 'x';
Cnnt.L34.Vbar3.Hsp = [2550, 3250];
Cnnt.L34.Vbar3.HspTol = 0.5;
Cnnt.L34.Vbar3.HspInt = 4;
Cnnt.L34.Vbar3.SDir = 90;

%Line35 - Vbar4 (at UMBVB12) four edge
Cnnt.L35.SN = 'ABS_E_Air';
Cnnt.L35.group = 'other';
Cnnt.L35.axis1 = 'x';
Cnnt.L35.axis2 = 'z';

Cnnt.L35.Vbar4.thk = Thk.Col1.VBaratTruss;
Cnnt.L35.Vbar4.axisTT = 'y';
Cnnt.L35.Vbar4.int = 1;
Cnnt.L35.Vbar4.path = [];
Cnnt.L35.Vbar4.HspAxis = 'x';
Cnnt.L35.Vbar4.Hsp = [2550, 3250];
Cnnt.L35.Vbar4.HspTol = 0.5;
Cnnt.L35.Vbar4.HspInt = 4;
Cnnt.L35.Vbar4.SDir = 90;

%Line36 - Vbar5 (at UMBVB13) four edge
Cnnt.L36.SN = 'ABS_E_Air';
Cnnt.L36.group = 'other';
Cnnt.L36.axis1 = 'x';
Cnnt.L36.axis2 = 'z';

Cnnt.L36.Vbar5.thk = Thk.Col1.VBaratTruss;
Cnnt.L36.Vbar5.axisTT = 'y';
Cnnt.L36.Vbar5.int = 1;

Cnnt.L36.Vbar5.HspAxis = 'x';
Cnnt.L36.Vbar5.Hsp = [2550, 3250];
Cnnt.L36.Vbar5.HspTol = 0.5;
Cnnt.L36.Vbar5.HspInt = 4;
Cnnt.L36.Vbar5.SDir = 90;

%Line37 - Vbar6 (at UMBVB13) four edge
Cnnt.L37.SN = 'ABS_E_Air';
Cnnt.L37.group = 'other';
Cnnt.L37.axis1 = 'x';
Cnnt.L37.axis2 = 'z';

Cnnt.L37.Vbar6.thk = Thk.Col1.VBaratTruss;
Cnnt.L37.Vbar6.axisTT = 'y';
Cnnt.L37.Vbar6.int = 1;

Cnnt.L37.Vbar6.HspAxis = 'x';
Cnnt.L37.Vbar6.Hsp = [2550, 3250];
Cnnt.L37.Vbar6.HspTol = 0.5;
Cnnt.L37.Vbar6.HspInt = 4;
Cnnt.L37.Vbar6.SDir = 90;

%Line38 - Ring1 inner edges and connection with Vbars
Cnnt.L38.SN = 'ABS_C_Air';
Cnnt.L38.group = 'other';
Cnnt.L38.axis1 = 'x';
Cnnt.L38.axis2 = 'y';

Cnnt.L38.Ring1.thk = Thk.Col1.RingatUMB;
Cnnt.L38.Ring1.axisTT = 'z';
Cnnt.L38.Ring1.int = 4;

Cnnt.L38.Ring1.HspAxis = 'y';
Cnnt.L38.Ring1.Hsp = [-156, -144, -120, 120, 144, 156];
Cnnt.L38.Ring1.HspSN = 'ABS_E_Air';
Cnnt.L38.Ring1.HspTol = 0.5;
Cnnt.L38.Ring1.HspInt = 1;
Cnnt.L38.Ring1.SDir = 90;

%Line39 - Ring2 inner edges and connection with Vbars
Cnnt.L39.SN = 'ABS_C_Air';
Cnnt.L39.group = 'other';
Cnnt.L39.axis1 = 'x';
Cnnt.L39.axis2 = 'y';

Cnnt.L39.Ring2.thk = Thk.Col1.RingatUMB;
Cnnt.L39.Ring2.axisTT = 'z';
Cnnt.L39.Ring2.int = 4;

Cnnt.L39.Ring2.HspAxis = 'y';
Cnnt.L39.Ring2.Hsp = [-156, -144, -120, 120, 144, 156];
Cnnt.L39.Ring2.HspSN = 'ABS_E_Air';
Cnnt.L39.Ring2.HspTol = 0.5;
Cnnt.L39.Ring2.HspInt = 1;
Cnnt.L39.Ring2.SDir = 90;

%Line40 - Ring3 inner edges and connection with Vbars
Cnnt.L40.SN = 'ABS_C_Air';
Cnnt.L40.group = 'other';
Cnnt.L40.axis1 = 'x';
Cnnt.L40.axis2 = 'y';

Cnnt.L40.Ring3.thk = Thk.Col1.RingatVB;
Cnnt.L40.Ring3.axisTT = 'z';
Cnnt.L40.Ring3.int = 4;

Cnnt.L40.Ring3.HspAxis = 'y';
Cnnt.L40.Ring3.Hsp = [-156, -144, -120, 120, 144, 156];
Cnnt.L40.Ring3.HspSN = 'ABS_E_Air';
Cnnt.L40.Ring3.HspTol = 0.5;
Cnnt.L40.Ring3.HspInt = 1;
Cnnt.L40.Ring3.SDir = 90;

%Line41 - Ring4 inner edges and connection with Vbars
Cnnt.L41.SN = 'ABS_C_Air';
Cnnt.L41.group = 'other';
Cnnt.L41.axis1 = 'x';
Cnnt.L41.axis2 = 'y';

Cnnt.L41.Ring4.thk = Thk.Col1.RingatVB;
Cnnt.L41.Ring4.axisTT = 'z';
Cnnt.L41.Ring4.int = 4;

Cnnt.L41.Ring4.HspAxis = 'y';
Cnnt.L41.Ring4.Hsp = [-156, -144, -120, 120, 144, 156];
Cnnt.L41.Ring4.HspSN = 'ABS_E_Air';
Cnnt.L41.Ring4.HspTol = 0.5;
Cnnt.L41.Ring4.HspInt = 1;
Cnnt.L41.Ring4.SDir = 90;

%Line42 - TBBrkt1 (at Bkh1)
Cnnt.L42.SN = 'ABS_C_Air';
Cnnt.L42.group = 'other';
Cnnt.L42.axis1 = 'x';
Cnnt.L42.axis2 = 'z';

Cnnt.L42.TBBrkt1.thk = Thk.Col1.Brkt_TBatBkh;
Cnnt.L42.TBBrkt1.axisTT = 'y';
Cnnt.L42.TBBrkt1.int = 1;

Cnnt.L42.TBBrkt1.HspAxis = 'x';
Cnnt.L42.TBBrkt1.Hsp = 3250;
Cnnt.L42.TBBrkt1.HspSN = 'ABS_E_Air';
Cnnt.L42.TBBrkt1.HspTol = 15;
Cnnt.L42.TBBrkt1.HspInt = 2;
Cnnt.L42.TBBrkt1.SDir = 120;

%Line43 - TBBrkt1 (at FB1)
Cnnt.L43.SN = 'ABS_C_Air';
Cnnt.L43.group = 'other';
Cnnt.L43.axis1 = 'x';
Cnnt.L43.axis2 = 'z';

Cnnt.L43.TBBrkt2.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L43.TBBrkt2.axisTT = 'y';
Cnnt.L43.TBBrkt2.int = 1;

Cnnt.L43.TBBrkt2.HspAxis = 'x';
Cnnt.L43.TBBrkt2.Hsp = 3250;
Cnnt.L43.TBBrkt2.HspSN = 'ABS_E_Air';
Cnnt.L43.TBBrkt2.HspTol = 15;
Cnnt.L43.TBBrkt2.HspInt = 2;
Cnnt.L43.TBBrkt2.SDir = 120;

%Line42 - TBBrkt1 (at OS*FB1)
Cnnt.L44.SN = 'ABS_C_Air';
Cnnt.L44.group = 'other';
Cnnt.L44.axis1 = 'x';
Cnnt.L44.axis2 = 'z';

Cnnt.L44.TBBrkt3.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L44.TBBrkt3.axisTT = 'y';
Cnnt.L44.TBBrkt3.int = 1;

Cnnt.L44.TBBrkt3.HspAxis = 'x';
Cnnt.L44.TBBrkt3.Hsp = 6500;
Cnnt.L44.TBBrkt3.HspSN = 'ABS_E_Air';
Cnnt.L44.TBBrkt3.HspTol = 15;
Cnnt.L44.TBBrkt3.HspInt = 2;
Cnnt.L44.TBBrkt3.SDir = 150;

%Line45 - TBBrkt4 (at Bkh2)
Cnnt.L45.SN = 'ABS_C_Air';
Cnnt.L45.group = 'other';
Cnnt.L45.axis1 = 'x';
Cnnt.L45.axis2 = 'z';

Cnnt.L45.TBBrkt4.thk = Thk.Col1.Brkt_TBatBkh;
Cnnt.L45.TBBrkt4.axisTT = 'y';
Cnnt.L45.TBBrkt4.int = 1;

Cnnt.L45.TBBrkt4.HspAxis = 'x';
Cnnt.L45.TBBrkt4.Hsp = 3250;
Cnnt.L45.TBBrkt4.HspSN = 'ABS_E_Air';
Cnnt.L45.TBBrkt4.HspTol = 15;
Cnnt.L45.TBBrkt4.HspInt = 2;
Cnnt.L45.TBBrkt4.SDir = 120;

%Line46 - TBBrkt5 (at FB2)
Cnnt.L46.SN = 'ABS_C_Air';
Cnnt.L46.group = 'other';
Cnnt.L46.axis1 = 'x';
Cnnt.L46.axis2 = 'z';

Cnnt.L46.TBBrkt5.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L46.TBBrkt5.axisTT = 'y';
Cnnt.L46.TBBrkt5.int = 1;

Cnnt.L46.TBBrkt5.HspAxis = 'x';
Cnnt.L46.TBBrkt5.Hsp = 3250;
Cnnt.L46.TBBrkt5.HspSN = 'ABS_E_Air';
Cnnt.L46.TBBrkt5.HspTol = 15;
Cnnt.L46.TBBrkt5.HspInt = 2;
Cnnt.L46.TBBrkt5.SDir = 120;

%Line47 - TBBrkt6 (at OS*FB2)
Cnnt.L47.SN = 'ABS_C_Air';
Cnnt.L47.group = 'other';
Cnnt.L47.axis1 = 'x';
Cnnt.L47.axis2 = 'z';

Cnnt.L47.TBBrkt6.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L47.TBBrkt6.axisTT = 'y';
Cnnt.L47.TBBrkt6.int = 1;

Cnnt.L47.TBBrkt6.HspAxis = 'x';
Cnnt.L47.TBBrkt6.Hsp = 6500;
Cnnt.L47.TBBrkt6.HspSN = 'ABS_E_Air';
Cnnt.L47.TBBrkt6.HspTol = 15;
Cnnt.L47.TBBrkt6.HspInt = 2;
Cnnt.L47.TBBrkt6.SDir = 150;

OutName = [path1 'CnntInfo.mat'];
save(OutName, 'Cnnt')

%% ItrR5_15_12 (Col1_Top)
ItrNo = 'ItrR5_15_12';
path1 = [path0 ItrNo '\'];
load([path1 'thickness.mat']);

Cnnt.Itr = ItrNo;

%Line1 - TB*IS*TF
Cnnt.L1.SN = 'ABS_E_Air';
Cnnt.L1.group = 'circ';
Cnnt.L1.axis = 'y';

Cnnt.L1.TB.thk = Thk.Col1.TB;
Cnnt.L1.TB.int = 2;
Cnnt.L1.TB.axisTT = 'x'; %through-thickness axis
Cnnt.L1.TB.SDir = 90; %degree

Cnnt.L1.TF.thk = Thk.Col1.TFin;
Cnnt.L1.TF.int = 10;
Cnnt.L1.TF.axisTT = 'z'; %through-thickness axis
Cnnt.L1.TF.HspAxis = 'y';
Cnnt.L1.TF.Hsp = -165:15:180;
Cnnt.L1.TF.HspTol = 0.5;

Cnnt.L1.TOCring.thk = Thk.Col1.TFin;
Cnnt.L1.TOCring.int = 10;
Cnnt.L1.TOCring.axisTT = 'z';

%Line2 - IS*UMB12
Cnnt.L2.SN = 'API_WJ_Air';
Cnnt.L2.group = 'circ';
Cnnt.L2.axis = 'y';

Cnnt.L2.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L2.IS.int = 2;
Cnnt.L2.IS.axisTT = 'x';
Cnnt.L2.IS.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L2.IS.HspTol = 0.5; %Tolerance in hot spot sampling
Cnnt.L2.IS.SDir = 90;

Cnnt.L2.UMB12.thk = Thk.Col1.UMB;
Cnnt.L2.UMB12.int = 3;
Cnnt.L2.UMB12.axisTT = 'x';
Cnnt.L2.UMB12.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L2.UMB12.HspTol = 0.5; 
Cnnt.L2.UMB12.SDir = 120;

%Line3 - IS*VB12
Cnnt.L3.SN = 'API_WJ_Air';
Cnnt.L3.group = 'circ';
Cnnt.L3.axis = 'y';

Cnnt.L3.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L3.IS.axisTT = 'x';
Cnnt.L3.IS.int = 2;
Cnnt.L3.IS.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L3.IS.HspTol = 0.5;
Cnnt.L3.IS.SDir = 120;

Cnnt.L3.VB12.thk = Thk.Col1.VB;
Cnnt.L3.VB12.axisTT = 'x';
Cnnt.L3.VB12.int = 3;
Cnnt.L3.VB12.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L3.VB12.HspTol = 0.5;
Cnnt.L3.VB12.SDir = 90;

%Line4 - IS*BKHs
Cnnt.L4.SN = 'ABS_E_Air';
Cnnt.L4.group = 'rad';
Cnnt.L4.axis_c = 'y';
Cnnt.L4.axis_r = 'z';

Cnnt.L4.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L4.IS.axisTT = 'x';
Cnnt.L4.IS.int = 5;
Cnnt.L4.IS.HspAxis = 'z';
Cnnt.L4.IS.Hsp = [5585, 6900,7550.3,8300,9311,9700,10700,10844,11800,12356];
Cnnt.L4.IS.HspTol = 10;
Cnnt.L4.IS.SDir = 90;

%Line5 - OS*TF
Cnnt.L5.SN = 'ABS_E_Air';
Cnnt.L5.group = 'circ';
Cnnt.L5.axis = 'y';

Cnnt.L5.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L5.OS.axisTT = 'x';
Cnnt.L5.OS.int = 20;
Cnnt.L5.OS.HspThk = Thk.Col1.OSatUMB ;
Cnnt.L5.OS.Hsp = -172.5 : 15 : 172.5;
Cnnt.L5.OS.HspTol = 0.2;
Cnnt.L5.OS.SDir = 0;

Cnnt.L5.TF.thk = Thk.Col1.TFout;
Cnnt.L5.TF.axisTT = 'z';
Cnnt.L5.TF.int = 20;
Cnnt.L5.TF.HspThk = Thk.Col1.TFatUMB ;
Cnnt.L5.TF.Hsp = -180 : 7.5 : 180;
Cnnt.L5.TF.HspTol = 0.2;
Cnnt.L5.TF.SDir = 90;

%Line6 - OS*UMB12
Cnnt.L6.SN = 'API_WJ_Air';
Cnnt.L6.group = 'circ';
Cnnt.L6.axis = 'y';

Cnnt.L6.OS.thk = Thk.Col1.OSatUMB;
Cnnt.L6.OS.axisTT = 'x';
Cnnt.L6.OS.int = 3;

Cnnt.L6.UMB12.thk = Thk.Col1.UMB;
Cnnt.L6.UMB12.axisTT = 'x';
Cnnt.L6.UMB12.int = 3;

%Line7 - OS*VB12
Cnnt.L7.SN = 'API_WJ_Air';
Cnnt.L7.group = 'circ';
Cnnt.L7.axis = 'y';

Cnnt.L7.OS.thk = Thk.Col1.OSatVB;
Cnnt.L7.OS.axisTT = 'x';
Cnnt.L7.OS.int = 3;

Cnnt.L7.VB12.thk = Thk.Col1.VB;
Cnnt.L7.VB12.axisTT = 'x';
Cnnt.L7.VB12.int = 3;

%Line8 - OS*Bkh1
Cnnt.L8.SN = 'ABS_E_Air';
Cnnt.L8.group = 'rad';
Cnnt.L8.axis_c = 'y';
Cnnt.L8.axis_r = 'z';

Cnnt.L8.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L8.OS.axisTT = 'x';
Cnnt.L8.OS.int = 10;
Cnnt.L8.OS.HspAxis = 'z';
Cnnt.L8.OS.Hsp = [0,1100,2000,2200,3300,4400,5000,5500,6900,8300,9700,10700,11800,13000];
Cnnt.L8.OS.HspTol = 10;
Cnnt.L8.OS.SDir = 0;

%Line9 - OS*TFgd
Cnnt.L9.SN = 'ABS_E_Air';
Cnnt.L9.group = 'rad';
Cnnt.L9.axis_c = 'y';
Cnnt.L9.axis_r = 'z';

Cnnt.L9.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L9.OS.axisTT = 'x';
Cnnt.L9.OS.int = 3;
Cnnt.L9.OS.HspAxis = 'y';
Cnnt.L9.OS.HspThk = Thk.Col1.OSatUMB ;
Cnnt.L9.OS.Hsp = [-150,150];
Cnnt.L9.OS.HspTol = 0.1;
Cnnt.L8.OS.SDir = 0;

%Line10 - Bkh1 four edges
Cnnt.L10.SN = 'ABS_E_Air';
Cnnt.L10.group = 'flat';
Cnnt.L10.axis1 = 'y';
Cnnt.L10.axis2 = 'z';

Cnnt.L10.Bkh1.thk = Thk.Col1.Bkh;
Cnnt.L10.Bkh1.axisTT = 'x';
Cnnt.L10.Bkh1.int = 10;

Cnnt.L10.Bkh1.path = [0,0;2750,0;2750,-13000;0,-13000];
Cnnt.L10.Bkh1.HspAxis = 'z';
Cnnt.L10.Bkh1.Hsp = 0;
Cnnt.L10.Bkh1.HspTol = 0.5;
Cnnt.L10.Bkh1.HspInt = 2;
Cnnt.L10.Bkh1.SDir = 120;

%Line11 - TFin * TFgd
Cnnt.L11.SN = 'ABS_E_Air';
Cnnt.L11.group = 'other';
Cnnt.L11.axis1 = 'y';
Cnnt.L11.axis2 = 'x';

Cnnt.L11.TF.thk = Thk.Col1.TFin;
Cnnt.L11.TF.axisTT = 'z';
Cnnt.L11.TF.int = 1;
Cnnt.L11.TF.HspAxis = 'y';
Cnnt.L11.TF.Hsp = -165:15:180;
Cnnt.L11.TF.HspTol = 0.1;
Cnnt.L11.TF.HspInt = 5;

%Line12 - TFout * TFgd
%Line13 - FB1 * UMB12
Cnnt.L13.SN = 'ABS_E_Air';
Cnnt.L13.group = 'flat';
Cnnt.L13.axis1 = 'y';
Cnnt.L13.axis2 = 'z';

Cnnt.L13.FB1.thk = Thk.Col1.FB;
Cnnt.L13.FB1.axisTT = 'x';
Cnnt.L13.FB1.int = 6;
Cnnt.L13.FB1.path = [0,0;2750,0;2750,-500;0,-500];

Cnnt.L13.FB1.HspAxis = 'z';
Cnnt.L13.FB1.Hsp = 0;
Cnnt.L13.FB1.HspTol = 0.5;
Cnnt.L13.FB1.HspInt = 3;
Cnnt.L13.FB1.SDir = 150;

%Line14 - TB * TBbrkt
Cnnt.L14.SN = 'ABS_E_Air';
Cnnt.L14.group = 'rad';
Cnnt.L14.axis_c = 'y';
Cnnt.L14.axis_r = 'z';

Cnnt.L14.TB.thk = Thk.Col1.TB;
Cnnt.L14.TB.axisTT = 'x';
Cnnt.L14.TB.int = 1;
Cnnt.L14.TB.HspAxis = 'y';
Cnnt.L14.TB.Hsp = [-120,120];
Cnnt.L14.TB.HspTol = 0.5;
Cnnt.L14.TB.SDir = 90;

%Line15 - IS * Ring1
Cnnt.L15.SN = 'ABS_E_Air';
Cnnt.L15.group = 'circ';
Cnnt.L15.axis = 'y';

Cnnt.L15.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L15.IS.axisTT = 'x';
Cnnt.L15.IS.int = 3;
Cnnt.L15.IS.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L15.IS.HspTol = 0.5;
Cnnt.L15.IS.SDir = 90;

Cnnt.L15.Ring1.thk = Thk.Col1.RingatUMB;
Cnnt.L15.Ring1.axisTT = 'z';
Cnnt.L15.Ring1.int = 10;
Cnnt.L15.Ring1.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L15.Ring1.HspTol = 0.5;
Cnnt.L15.Ring1.SDir = 0;

%Line16 - IS * Ring2
Cnnt.L16.SN = 'ABS_E_Air';
Cnnt.L16.group = 'circ';
Cnnt.L16.axis = 'y';

Cnnt.L16.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L16.IS.axisTT = 'x';
Cnnt.L16.IS.int = 3;
Cnnt.L16.IS.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L16.IS.HspTol = 0.5;
Cnnt.L16.IS.SDir = 90;

Cnnt.L16.Ring2.thk = Thk.Col1.RingatUMB;
Cnnt.L16.Ring2.axisTT = 'z';
Cnnt.L16.Ring2.int = 10;
Cnnt.L16.Ring2.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L16.Ring2.HspTol = 0.5;
Cnnt.L16.Ring2.SDir = 0;

%Line17 - IS * Ring3
Cnnt.L17.SN = 'ABS_E_Air';
Cnnt.L17.group = 'circ';
Cnnt.L17.axis = 'y';

Cnnt.L17.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L17.IS.axisTT = 'x';
Cnnt.L17.IS.int = 3;
Cnnt.L17.IS.Hsp = [-157.71, -156, -144, -142.29, -120, 120, 142.29, 144, 156, 157.71];
Cnnt.L17.IS.HspTol = 0.5;
Cnnt.L17.IS.SDir = 120;

Cnnt.L17.Ring3.thk = Thk.Col1.RingatVB;
Cnnt.L17.Ring3.axisTT = 'z';
Cnnt.L17.Ring3.int = 10;
Cnnt.L17.Ring3.Hsp = [-157.71, -156, -144, -142.29, -120, 120, 142.29, 144, 156, 157.71];
Cnnt.L17.Ring3.HspTol = 0.5;
Cnnt.L17.Ring3.SDir = 0;

%Line18 - IS * Ring4
Cnnt.L18.SN = 'ABS_E_Air';
Cnnt.L18.group = 'circ';
Cnnt.L18.axis = 'y';

Cnnt.L18.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L18.IS.axisTT = 'x';
Cnnt.L18.IS.int = 3;
Cnnt.L18.IS.Hsp = [-156.75, -156, -144, -143.25,-120, 120,  143.25, 144, 156, 156.75];
Cnnt.L18.IS.HspTol = 0.5;
Cnnt.L18.IS.SDir = 90;

Cnnt.L18.Ring4.thk = Thk.Col1.RingatVB;
Cnnt.L18.Ring4.axisTT = 'z';
Cnnt.L18.Ring4.int = 10;
Cnnt.L18.Ring4.Hsp = [-156.75, -156, -144, -143.25,-120, 120,  143.25, 144, 156, 156.75];
Cnnt.L18.Ring4.HspTol = 0.5;
Cnnt.L18.Ring4.SDir = [30 150];

%Line19 - TF * TBring
%Line20 - IS * UMB13
Cnnt.L20.SN = 'API_WJ_Air';
Cnnt.L20.group = 'circ';
Cnnt.L20.axis = 'y';

Cnnt.L20.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L20.IS.axisTT = 'x';
Cnnt.L20.IS.int = 2;
Cnnt.L20.IS.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L20.IS.HspTol = 0.5; %Tolerance in hot spot sampling
Cnnt.L20.IS.SDir = 90;

Cnnt.L20.UMB13.thk = Thk.Col1.UMB;
Cnnt.L20.UMB13.axisTT = 'x';
Cnnt.L20.UMB13.int = 3;
Cnnt.L20.UMB13.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L20.UMB13.HspTol = 0.5; 
Cnnt.L20.UMB13.SDir = 60;

%Line21 - IS * VB13
Cnnt.L21.SN = 'API_WJ_Air';
Cnnt.L21.group = 'circ';
Cnnt.L21.axis = 'y';

Cnnt.L21.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L21.IS.axisTT = 'x';
Cnnt.L21.IS.int = 2;
Cnnt.L21.IS.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L21.IS.HspTol = 0.5;
Cnnt.L21.IS.SDir = 60;

Cnnt.L21.VB13.thk = Thk.Col1.VB;
Cnnt.L21.VB13.axisTT = 'x';
Cnnt.L21.VB13.int = 3;
Cnnt.L21.VB13.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L21.VB13.HspTol = 0.5;
Cnnt.L21.VB13.SDir = 90;

%Line22 - OS * UMB13
Cnnt.L22.SN = 'API_WJ_Air';
Cnnt.L22.group = 'circ';
Cnnt.L22.axis = 'y';

Cnnt.L22.OS.thk = Thk.Col1.OSatUMB;
Cnnt.L22.OS.axisTT = 'x';
Cnnt.L22.OS.int = 3;

Cnnt.L22.UMB13.thk = Thk.Col1.UMB;
Cnnt.L22.UMB13.axisTT = 'x';
Cnnt.L22.UMB13.int = 3;

%Line23 - OS * VB13
Cnnt.L23.SN = 'API_WJ_Air';
Cnnt.L23.group = 'circ';
Cnnt.L23.axis = 'y';

Cnnt.L23.OS.thk = Thk.Col1.OSatVB;
Cnnt.L23.OS.axisTT = 'x';
Cnnt.L23.OS.int = 3;

Cnnt.L23.VB13.thk = Thk.Col1.VB;
Cnnt.L23.VB13.axisTT = 'x';
Cnnt.L23.VB13.int = 3;

%Line24 - Bkh2 two edges
Cnnt.L24.SN = 'ABS_E_Air';
Cnnt.L24.group = 'flat';
Cnnt.L24.axis1 = 'y';
Cnnt.L24.axis2 = 'z';

Cnnt.L24.Bkh2.thk = Thk.Col1.Bkh;
Cnnt.L24.Bkh2.axisTT = 'x';
Cnnt.L24.Bkh2.int = 10;
Cnnt.L24.Bkh2.path = [0,0;-2750,0;-2750,-13000;0,-13000];
Cnnt.L24.Bkh2.HspAxis = 'z';
Cnnt.L24.Bkh2.Hsp = 0;
Cnnt.L24.Bkh2.HspTol = 0.5;
Cnnt.L24.Bkh2.HspInt = 2;
Cnnt.L24.Bkh2.SDir = 60;

%Line25 - FB2 four edges
Cnnt.L25.SN = 'ABS_E_Air';
Cnnt.L25.group = 'flat';
Cnnt.L25.axis1 = 'y';
Cnnt.L25.axis2 = 'z';

Cnnt.L25.FB2.thk = Thk.Col1.FB;
Cnnt.L25.FB2.axisTT = 'x';
Cnnt.L25.FB2.int = 3;
Cnnt.L25.FB2.path = [0,0;-2750,0;-2750,-500;0,-500];
Cnnt.L25.FB2.HspAxis1 = 'z';
Cnnt.L25.FB2.Hsp = 0;
Cnnt.L25.FB2.HspAxis2 = 'y';
Cnnt.L25.FB2.Hsp2 = -2750;
Cnnt.L25.FB2.HspTol = 0.5;
Cnnt.L25.FB2.HspInt = 1;
Cnnt.L25.FB2.SDir = 30;

%Line26 - IS opening
Cnnt.L26.SN = 'ABS_C_Air';
Cnnt.L26.group = 'flat';
Cnnt.L26.axis1 = 'y';
Cnnt.L26.axis2 = 'z';

Cnnt.L26.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L26.IS.axisTT = 'x';
Cnnt.L26.IS.int = 2;

%Line27 - VB12lwr * LMB12mid
%Line28 - VB21lwr * LMB12mid
%Line29 - VB13lwr * LMB13mid
%Line30 - VB31lwr * LMB13mid
%Line31 - IS * C-Plate

%Line32 - Vbar1 (at Bkh1) four edge
Cnnt.L32.SN = 'ABS_E_Air';
Cnnt.L32.group = 'other';
Cnnt.L32.axis1 = 'x';
Cnnt.L32.axis2 = 'z';

Cnnt.L32.Vbar1.thk = Thk.Col1.VBaratBkh;
Cnnt.L32.Vbar1.axisTT = 'y';
Cnnt.L32.Vbar1.int = 1;

Cnnt.L32.Vbar1.HspAxis = 'x';
Cnnt.L32.Vbar1.Hsp = [2550, 3250];
Cnnt.L32.Vbar1.HspTol = 0.5;
Cnnt.L32.Vbar1.HspInt = 4;
Cnnt.L32.Vbar1.SDir = 60;

%Line33 - Vbar2 (at Bkh2) four edge
Cnnt.L33.SN = 'ABS_E_Air';
Cnnt.L33.group = 'other';
Cnnt.L33.axis1 = 'x';
Cnnt.L33.axis2 = 'z';

Cnnt.L33.Vbar2.thk = Thk.Col1.VBaratBkh;
Cnnt.L33.Vbar2.axisTT = 'y';
Cnnt.L33.Vbar2.int = 1;

Cnnt.L33.Vbar2.HspAxis = 'x';
Cnnt.L33.Vbar2.Hsp = [2550, 3250];
Cnnt.L33.Vbar2.HspTol = 0.5;
Cnnt.L33.Vbar2.HspInt = 4;
Cnnt.L33.Vbar2.SDir = 60;

%Line34 - Vbar3 (at UMBVB12) four edge
Cnnt.L34.SN = 'ABS_E_Air';
Cnnt.L34.group = 'other';
Cnnt.L34.axis1 = 'x';
Cnnt.L34.axis2 = 'z';

Cnnt.L34.Vbar3.thk = Thk.Col1.VBaratTruss;
Cnnt.L34.Vbar3.axisTT = 'y';
Cnnt.L34.Vbar3.int = 1;

Cnnt.L34.Vbar3.HspAxis = 'x';
Cnnt.L34.Vbar3.Hsp = [2550, 3250];
Cnnt.L34.Vbar3.HspTol = 0.5;
Cnnt.L34.Vbar3.HspInt = 4;
Cnnt.L34.Vbar3.SDir = 90;

%Line35 - Vbar4 (at UMBVB12) four edge
Cnnt.L35.SN = 'ABS_E_Air';
Cnnt.L35.group = 'other';
Cnnt.L35.axis1 = 'x';
Cnnt.L35.axis2 = 'z';

Cnnt.L35.Vbar4.thk = Thk.Col1.VBaratTruss;
Cnnt.L35.Vbar4.axisTT = 'y';
Cnnt.L35.Vbar4.int = 1;
Cnnt.L35.Vbar4.path = [];
Cnnt.L35.Vbar4.HspAxis = 'x';
Cnnt.L35.Vbar4.Hsp = [2550, 3250];
Cnnt.L35.Vbar4.HspTol = 0.5;
Cnnt.L35.Vbar4.HspInt = 4;
Cnnt.L35.Vbar4.SDir = 90;

%Line36 - Vbar5 (at UMBVB13) four edge
Cnnt.L36.SN = 'ABS_E_Air';
Cnnt.L36.group = 'other';
Cnnt.L36.axis1 = 'x';
Cnnt.L36.axis2 = 'z';

Cnnt.L36.Vbar5.thk = Thk.Col1.VBaratTruss;
Cnnt.L36.Vbar5.axisTT = 'y';
Cnnt.L36.Vbar5.int = 1;

Cnnt.L36.Vbar5.HspAxis = 'x';
Cnnt.L36.Vbar5.Hsp = [2550, 3250];
Cnnt.L36.Vbar5.HspTol = 0.5;
Cnnt.L36.Vbar5.HspInt = 4;
Cnnt.L36.Vbar5.SDir = 90;

%Line37 - Vbar6 (at UMBVB13) four edge
Cnnt.L37.SN = 'ABS_E_Air';
Cnnt.L37.group = 'other';
Cnnt.L37.axis1 = 'x';
Cnnt.L37.axis2 = 'z';

Cnnt.L37.Vbar6.thk = Thk.Col1.VBaratTruss;
Cnnt.L37.Vbar6.axisTT = 'y';
Cnnt.L37.Vbar6.int = 1;

Cnnt.L37.Vbar6.HspAxis = 'x';
Cnnt.L37.Vbar6.Hsp = [2550, 3250];
Cnnt.L37.Vbar6.HspTol = 0.5;
Cnnt.L37.Vbar6.HspInt = 4;
Cnnt.L37.Vbar6.SDir = 90;

%Line38 - Ring1 inner edges and connection with Vbars
Cnnt.L38.SN = 'ABS_C_Air';
Cnnt.L38.group = 'other';
Cnnt.L38.axis1 = 'x';
Cnnt.L38.axis2 = 'y';

Cnnt.L38.Ring1.thk = Thk.Col1.RingatUMB;
Cnnt.L38.Ring1.axisTT = 'z';
Cnnt.L38.Ring1.int = 4;

Cnnt.L38.Ring1.HspAxis = 'y';
Cnnt.L38.Ring1.Hsp = [-156, -144, -120, 120, 144, 156];
Cnnt.L38.Ring1.HspSN = 'ABS_E_Air';
Cnnt.L38.Ring1.HspTol = 0.5;
Cnnt.L38.Ring1.HspInt = 1;
Cnnt.L38.Ring1.SDir = 90;

%Line39 - Ring2 inner edges and connection with Vbars
Cnnt.L39.SN = 'ABS_C_Air';
Cnnt.L39.group = 'other';
Cnnt.L39.axis1 = 'x';
Cnnt.L39.axis2 = 'y';

Cnnt.L39.Ring2.thk = Thk.Col1.RingatUMB;
Cnnt.L39.Ring2.axisTT = 'z';
Cnnt.L39.Ring2.int = 4;

Cnnt.L39.Ring2.HspAxis = 'y';
Cnnt.L39.Ring2.Hsp = [-156, -144, -120, 120, 144, 156];
Cnnt.L39.Ring2.HspSN = 'ABS_E_Air';
Cnnt.L39.Ring2.HspTol = 0.5;
Cnnt.L39.Ring2.HspInt = 1;
Cnnt.L39.Ring2.SDir = 90;

%Line40 - Ring3 inner edges and connection with Vbars
Cnnt.L40.SN = 'ABS_C_Air';
Cnnt.L40.group = 'other';
Cnnt.L40.axis1 = 'x';
Cnnt.L40.axis2 = 'y';

Cnnt.L40.Ring3.thk = Thk.Col1.RingatVB;
Cnnt.L40.Ring3.axisTT = 'z';
Cnnt.L40.Ring3.int = 4;

Cnnt.L40.Ring3.HspAxis = 'y';
Cnnt.L40.Ring3.Hsp = [-156, -144, -120, 120, 144, 156];
Cnnt.L40.Ring3.HspSN = 'ABS_E_Air';
Cnnt.L40.Ring3.HspTol = 0.5;
Cnnt.L40.Ring3.HspInt = 1;
Cnnt.L40.Ring3.SDir = 90;

%Line41 - Ring4 inner edges and connection with Vbars
Cnnt.L41.SN = 'ABS_C_Air';
Cnnt.L41.group = 'other';
Cnnt.L41.axis1 = 'x';
Cnnt.L41.axis2 = 'y';

Cnnt.L41.Ring4.thk = Thk.Col1.RingatVB;
Cnnt.L41.Ring4.axisTT = 'z';
Cnnt.L41.Ring4.int = 4;

Cnnt.L41.Ring4.HspAxis = 'y';
Cnnt.L41.Ring4.Hsp = [-156, -144, -120, 120, 144, 156];
Cnnt.L41.Ring4.HspSN = 'ABS_E_Air';
Cnnt.L41.Ring4.HspTol = 0.5;
Cnnt.L41.Ring4.HspInt = 1;
Cnnt.L41.Ring4.SDir = 90;

%Line42 - TBBrkt1 (at Bkh1)
Cnnt.L42.SN = 'ABS_C_Air';
Cnnt.L42.group = 'other';
Cnnt.L42.axis1 = 'x';
Cnnt.L42.axis2 = 'z';

Cnnt.L42.TBBrkt1.thk = Thk.Col1.Brkt_TBatBkh;
Cnnt.L42.TBBrkt1.axisTT = 'y';
Cnnt.L42.TBBrkt1.int = 1;

Cnnt.L42.TBBrkt1.HspAxis = 'x';
Cnnt.L42.TBBrkt1.Hsp = 3250;
Cnnt.L42.TBBrkt1.HspAxis2 = 'z';
Cnnt.L42.TBBrkt1.Hsp2 = 13000;

Cnnt.L42.TBBrkt1.HspSN = 'ABS_E_Air';
Cnnt.L42.TBBrkt1.HspTol = 15;
Cnnt.L42.TBBrkt1.HspInt = 2;
Cnnt.L42.TBBrkt1.SDir = 120;

%Line43 - TBBrkt1 (at FB1)
Cnnt.L43.SN = 'ABS_C_Air';
Cnnt.L43.group = 'other';
Cnnt.L43.axis1 = 'x';
Cnnt.L43.axis2 = 'z';

Cnnt.L43.TBBrkt2.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L43.TBBrkt2.axisTT = 'y';
Cnnt.L43.TBBrkt2.int = 1;

Cnnt.L43.TBBrkt2.HspAxis = 'x';
Cnnt.L43.TBBrkt2.Hsp = 3250;
Cnnt.L43.TBBrkt2.HspAxis2 = 'z';
Cnnt.L43.TBBrkt2.Hsp2 = 13000;

Cnnt.L43.TBBrkt2.HspSN = 'ABS_E_Air';
Cnnt.L43.TBBrkt2.HspTol = 15;
Cnnt.L43.TBBrkt2.HspInt = 2;
Cnnt.L43.TBBrkt2.SDir = 120;

%Line42 - TBBrkt1 (at OS*FB1)
Cnnt.L44.SN = 'ABS_C_Air';
Cnnt.L44.group = 'other';
Cnnt.L44.axis1 = 'x';
Cnnt.L44.axis2 = 'z';

Cnnt.L44.TBBrkt3.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L44.TBBrkt3.axisTT = 'y';
Cnnt.L44.TBBrkt3.int = 1;

Cnnt.L44.TBBrkt3.HspAxis = 'x';
Cnnt.L44.TBBrkt3.Hsp = 6000;
Cnnt.L44.TBBrkt3.HspAxis2 = 'z';
Cnnt.L44.TBBrkt3.Hsp2 = 12500;

Cnnt.L44.TBBrkt3.HspSN = 'ABS_E_Air';
Cnnt.L44.TBBrkt3.HspTol = 15;
Cnnt.L44.TBBrkt3.HspInt = 2;
Cnnt.L44.TBBrkt3.SDir = 150;

%Line45 - TBBrkt4 (at Bkh2)
Cnnt.L45.SN = 'ABS_C_Air';
Cnnt.L45.group = 'other';
Cnnt.L45.axis1 = 'x';
Cnnt.L45.axis2 = 'z';

Cnnt.L45.TBBrkt4.thk = Thk.Col1.Brkt_TBatBkh;
Cnnt.L45.TBBrkt4.axisTT = 'y';
Cnnt.L45.TBBrkt4.int = 1;

Cnnt.L45.TBBrkt4.HspAxis = 'x';
Cnnt.L45.TBBrkt4.Hsp = 3250;
Cnnt.L45.TBBrkt4.HspAxis2 = 'z';
Cnnt.L45.TBBrkt4.Hsp2 = 13000;

Cnnt.L45.TBBrkt4.HspSN = 'ABS_E_Air';
Cnnt.L45.TBBrkt4.HspTol = 15;
Cnnt.L45.TBBrkt4.HspInt = 2;
Cnnt.L45.TBBrkt4.SDir = 120;

%Line46 - TBBrkt5 (at FB2)
Cnnt.L46.SN = 'ABS_C_Air';
Cnnt.L46.group = 'other';
Cnnt.L46.axis1 = 'x';
Cnnt.L46.axis2 = 'z';

Cnnt.L46.TBBrkt5.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L46.TBBrkt5.axisTT = 'y';
Cnnt.L46.TBBrkt5.int = 1;

Cnnt.L46.TBBrkt5.HspAxis = 'x';
Cnnt.L46.TBBrkt5.Hsp = 3250;
Cnnt.L46.TBBrkt5.HspAxis2 = 'z';
Cnnt.L46.TBBrkt5.Hsp2 = 13000;

Cnnt.L46.TBBrkt5.HspSN = 'ABS_E_Air';
Cnnt.L46.TBBrkt5.HspTol = 15;
Cnnt.L46.TBBrkt5.HspInt = 2;
Cnnt.L46.TBBrkt5.SDir = 120;

%Line47 - TBBrkt6 (at OS*FB2)
Cnnt.L47.SN = 'ABS_C_Air';
Cnnt.L47.group = 'other';
Cnnt.L47.axis1 = 'x';
Cnnt.L47.axis2 = 'z';

Cnnt.L47.TBBrkt6.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L47.TBBrkt6.axisTT = 'y';
Cnnt.L47.TBBrkt6.int = 1;

Cnnt.L47.TBBrkt6.HspAxis = 'x';
Cnnt.L47.TBBrkt6.Hsp = 6000;
Cnnt.L47.TBBrkt6.HspAxis2 = 'z';
Cnnt.L47.TBBrkt6.Hsp2 = 12500;

Cnnt.L47.TBBrkt6.HspSN = 'ABS_E_Air';
Cnnt.L47.TBBrkt6.HspTol = 15;
Cnnt.L47.TBBrkt6.HspInt = 2;
Cnnt.L47.TBBrkt6.SDir = 150;

%L48 - TOC ring * Vbars
Cnnt.L48.SN = 'ABS_E_Air';
Cnnt.L48.group = 'rad';
Cnnt.L48.axis_c = 'y';
Cnnt.L48.axis_r = 'x';

Cnnt.L48.TOCring.thk = Thk.Col1.TOCring;
Cnnt.L48.TOCring.axisTT = 'z';
Cnnt.L48.TOCring.int = 1;
Cnnt.L48.TOCring.HspAxis = 'x';
Cnnt.L48.TOCring.Hsp = 2550;
Cnnt.L48.TOCring.HspTol = 0.5;
Cnnt.L48.TOCring.SDir = 90;

OutName = [path1 'CnntInfo.mat'];
save(OutName, 'Cnnt')

%% ItrR5_15_17 (Col1_Top)
ItrNo = 'ItrR5_15_17';
path1 = [path0 ItrNo '\'];
load([path1 'thickness.mat']);

Cnnt.Itr = ItrNo;

%Line1 - TB*IS*TF
Cnnt.L1.SN = 'ABS_E_Air';
Cnnt.L1.group = 'circ';
Cnnt.L1.axis = 'y';

Cnnt.L1.TB.thk = Thk.Col1.TB;
Cnnt.L1.TB.int = 2;
Cnnt.L1.TB.axisTT = 'x'; %through-thickness axis
Cnnt.L1.TB.SDir = 90; %degree

Cnnt.L1.TF.thk = Thk.Col1.TFin;
Cnnt.L1.TF.int = 10;
Cnnt.L1.TF.axisTT = 'z'; %through-thickness axis
Cnnt.L1.TF.HspAxis = 'y';
Cnnt.L1.TF.Hsp = -165:15:180;
Cnnt.L1.TF.HspTol = 0.5;

Cnnt.L1.TOCring.thk = Thk.Col1.TFin;
Cnnt.L1.TOCring.int = 10;
Cnnt.L1.TOCring.axisTT = 'z';

%Line2 - IS*UMB12
Cnnt.L2.SN = 'API_WJ_Air';
Cnnt.L2.group = 'circ';
Cnnt.L2.axis = 'y';

Cnnt.L2.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L2.IS.int = 2;
Cnnt.L2.IS.axisTT = 'x';
Cnnt.L2.IS.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L2.IS.HspTol = 0.5; %Tolerance in hot spot sampling
Cnnt.L2.IS.SDir = 90;

Cnnt.L2.UMB12.thk = Thk.Col1.UMB;
Cnnt.L2.UMB12.int = 3;
Cnnt.L2.UMB12.axisTT = 'x';
Cnnt.L2.UMB12.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L2.UMB12.HspTol = 0.5; 
Cnnt.L2.UMB12.SDir = 120;

%Line3 - IS*VB12
Cnnt.L3.SN = 'API_WJ_Air';
Cnnt.L3.group = 'circ';
Cnnt.L3.axis = 'y';

Cnnt.L3.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L3.IS.axisTT = 'x';
Cnnt.L3.IS.int = 2;
Cnnt.L3.IS.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L3.IS.HspTol = 0.5;
Cnnt.L3.IS.SDir = 120;

Cnnt.L3.VB12.thk = Thk.Col1.VB;
Cnnt.L3.VB12.axisTT = 'x';
Cnnt.L3.VB12.int = 3;
Cnnt.L3.VB12.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L3.VB12.HspTol = 0.5;
Cnnt.L3.VB12.SDir = 90;

%Line4 - IS*BKHs
Cnnt.L4.SN = 'ABS_E_Air';
Cnnt.L4.group = 'rad';
Cnnt.L4.axis_c = 'y';
Cnnt.L4.axis_r = 'z';

Cnnt.L4.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L4.IS.axisTT = 'x';
Cnnt.L4.IS.int = 5;
Cnnt.L4.IS.HspAxis = 'z';
Cnnt.L4.IS.Hsp = [5585, 6900,7550.3,8300,9311,9700,10700,10844,11800,12356];
Cnnt.L4.IS.HspTol = 10;
Cnnt.L4.IS.SDir = 90;

%Line5 - OS*TF
Cnnt.L5.SN = 'ABS_E_Air';
Cnnt.L5.group = 'circ';
Cnnt.L5.axis = 'y';

Cnnt.L5.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L5.OS.axisTT = 'x';
Cnnt.L5.OS.int = 20;
Cnnt.L5.OS.HspThk = Thk.Col1.OSatUMB ;
Cnnt.L5.OS.Hsp = -172.5 : 15 : 172.5;
Cnnt.L5.OS.HspTol = 0.2;
Cnnt.L5.OS.SDir = 0;

Cnnt.L5.TF.thk = Thk.Col1.TFout;
Cnnt.L5.TF.axisTT = 'z';
Cnnt.L5.TF.int = 20;
Cnnt.L5.TF.HspThk = Thk.Col1.TFatUMB ;
Cnnt.L5.TF.Hsp = -180 : 7.5 : 180;
Cnnt.L5.TF.HspTol = 0.2;
Cnnt.L5.TF.SDir = 90;

%Line6 - OS*UMB12
Cnnt.L6.SN = 'API_WJ_Air';
Cnnt.L6.group = 'circ';
Cnnt.L6.axis = 'y';

Cnnt.L6.OS.thk = Thk.Col1.OSatUMB;
Cnnt.L6.OS.axisTT = 'x';
Cnnt.L6.OS.int = 3;

Cnnt.L6.UMB12.thk = Thk.Col1.UMB;
Cnnt.L6.UMB12.axisTT = 'x';
Cnnt.L6.UMB12.int = 3;

%Line7 - OS*VB12
Cnnt.L7.SN = 'API_WJ_Air';
Cnnt.L7.group = 'circ';
Cnnt.L7.axis = 'y';

Cnnt.L7.OS.thk = Thk.Col1.OSatVB;
Cnnt.L7.OS.axisTT = 'x';
Cnnt.L7.OS.int = 3;

Cnnt.L7.VB12.thk = Thk.Col1.VB;
Cnnt.L7.VB12.axisTT = 'x';
Cnnt.L7.VB12.int = 3;

%Line8 - OS*Bkh1
Cnnt.L8.SN = 'ABS_E_Air';
Cnnt.L8.group = 'rad';
Cnnt.L8.axis_c = 'y';
Cnnt.L8.axis_r = 'z';

Cnnt.L8.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L8.OS.axisTT = 'x';
Cnnt.L8.OS.int = 5;
Cnnt.L8.OS.HspAxis = 'z';
Cnnt.L8.OS.Hsp = [0,1100,2000,2200,3300,4400,5000,5500,6900,8300,9700,10700,11800,13000];
Cnnt.L8.OS.HspTol = 10;
Cnnt.L8.OS.SDir = 0;

%Line9 - OS*TFgd
Cnnt.L9.SN = 'ABS_E_Air';
Cnnt.L9.group = 'rad';
Cnnt.L9.axis_c = 'y';
Cnnt.L9.axis_r = 'z';

Cnnt.L9.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L9.OS.axisTT = 'x';
Cnnt.L9.OS.int = 3;
Cnnt.L9.OS.HspAxis = 'y';
Cnnt.L9.OS.HspThk = Thk.Col1.OSatUMB ;
Cnnt.L9.OS.Hsp = [-150,150];
Cnnt.L9.OS.HspTol = 0.1;
Cnnt.L8.OS.SDir = 0;

%Line10 - Bkh1 four edges
Cnnt.L10.SN = 'ABS_E_Air';
Cnnt.L10.group = 'flat';
Cnnt.L10.axis1 = 'y';
Cnnt.L10.axis2 = 'z';

Cnnt.L10.Bkh1.thk = Thk.Col1.Bkh;
Cnnt.L10.Bkh1.axisTT = 'x';
Cnnt.L10.Bkh1.int = 5;

Cnnt.L10.Bkh1.path = [0,0;2750,0;2750,-13000;0,-13000];
Cnnt.L10.Bkh1.HspAxis = 'z';
Cnnt.L10.Bkh1.Hsp = 0;
Cnnt.L10.Bkh1.HspTol = 0.5;
Cnnt.L10.Bkh1.HspInt = 2;
Cnnt.L10.Bkh1.SDir = 120;

%Line11 - TFin * TFgd
Cnnt.L11.SN = 'ABS_E_Air';
Cnnt.L11.group = 'other';
Cnnt.L11.axis1 = 'y';
Cnnt.L11.axis2 = 'x';

Cnnt.L11.TF.thk = Thk.Col1.TFin;
Cnnt.L11.TF.axisTT = 'z';
Cnnt.L11.TF.int = 1;
Cnnt.L11.TF.HspAxis = 'y';
Cnnt.L11.TF.Hsp = -165:15:180;
Cnnt.L11.TF.HspTol = 0.1;
Cnnt.L11.TF.HspInt = 5;

%Line12 - TFout * TFgd
%Line13 - FB1 * UMB12
Cnnt.L13.SN = 'ABS_E_Air';
Cnnt.L13.group = 'flat';
Cnnt.L13.axis1 = 'y';
Cnnt.L13.axis2 = 'z';

Cnnt.L13.FB1.thk = Thk.Col1.FB;
Cnnt.L13.FB1.axisTT = 'x';
Cnnt.L13.FB1.int = 6;
Cnnt.L13.FB1.path = [0,0;2750,0;2750,-500;0,-500];

Cnnt.L13.FB1.HspAxis = 'z';
Cnnt.L13.FB1.Hsp = 0;
Cnnt.L13.FB1.HspTol = 0.5;
Cnnt.L13.FB1.HspInt = 3;
Cnnt.L13.FB1.SDir = 150;

%Line14 - TB * TBbrkt
Cnnt.L14.SN = 'ABS_E_Air';
Cnnt.L14.group = 'rad';
Cnnt.L14.axis_c = 'y';
Cnnt.L14.axis_r = 'z';

Cnnt.L14.TB.thk = Thk.Col1.TB;
Cnnt.L14.TB.axisTT = 'x';
Cnnt.L14.TB.int = 1;
Cnnt.L14.TB.HspAxis = 'y';
Cnnt.L14.TB.Hsp = -120;
Cnnt.L14.TB.HspTol = 0.5;
Cnnt.L14.TB.SDir = 90;

%Line15 - IS * Ring1
Cnnt.L15.SN = 'ABS_E_Air';
Cnnt.L15.group = 'circ';
Cnnt.L15.axis = 'y';

Cnnt.L15.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L15.IS.axisTT = 'x';
Cnnt.L15.IS.int = 3;
Cnnt.L15.IS.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L15.IS.HspTol = 0.5;
Cnnt.L15.IS.SDir = 90;

Cnnt.L15.Ring1.thk = Thk.Col1.RingatUMB;
Cnnt.L15.Ring1.axisTT = 'z';
Cnnt.L15.Ring1.int = 10;
Cnnt.L15.Ring1.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L15.Ring1.HspTol = 0.5;
Cnnt.L15.Ring1.SDir = 0;

%Line16 - IS * Ring2
Cnnt.L16.SN = 'ABS_E_Air';
Cnnt.L16.group = 'circ';
Cnnt.L16.axis = 'y';

Cnnt.L16.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L16.IS.axisTT = 'x';
Cnnt.L16.IS.int = 3;
Cnnt.L16.IS.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L16.IS.HspTol = 0.5;
Cnnt.L16.IS.SDir = 90;

Cnnt.L16.Ring2.thk = Thk.Col1.RingatUMB;
Cnnt.L16.Ring2.axisTT = 'z';
Cnnt.L16.Ring2.int = 10;
Cnnt.L16.Ring2.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L16.Ring2.HspTol = 0.5;
Cnnt.L16.Ring2.SDir = 0;

%Line17 - IS * Ring3
Cnnt.L17.SN = 'ABS_E_Air';
Cnnt.L17.group = 'circ';
Cnnt.L17.axis = 'y';

Cnnt.L17.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L17.IS.axisTT = 'x';
Cnnt.L17.IS.int = 3;
Cnnt.L17.IS.Hsp = [-157.71, -156, -144, -142.29, -120, 120, 142.29, 144, 156, 157.71];
Cnnt.L17.IS.HspTol = 0.5;
Cnnt.L17.IS.SDir = 120;

Cnnt.L17.Ring3.thk = Thk.Col1.RingatVB;
Cnnt.L17.Ring3.axisTT = 'z';
Cnnt.L17.Ring3.int = 10;
Cnnt.L17.Ring3.Hsp = [-157.71, -156, -144, -142.29, -120, 120, 142.29, 144, 156, 157.71];
Cnnt.L17.Ring3.HspTol = 0.5;
Cnnt.L17.Ring3.SDir = 0;

%Line18 - IS * Ring4
Cnnt.L18.SN = 'ABS_E_Air';
Cnnt.L18.group = 'circ';
Cnnt.L18.axis = 'y';

Cnnt.L18.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L18.IS.axisTT = 'x';
Cnnt.L18.IS.int = 3;
Cnnt.L18.IS.Hsp = [-156.75, -156, -144, -143.25,-120, 120,  143.25, 144, 156, 156.75];
Cnnt.L18.IS.HspTol = 0.5;
Cnnt.L18.IS.SDir = 90;

Cnnt.L18.Ring4.thk = Thk.Col1.RingatVB;
Cnnt.L18.Ring4.axisTT = 'z';
Cnnt.L18.Ring4.int = 10;
Cnnt.L18.Ring4.Hsp = [-156.75, -156, -144, -143.25,-120, 120,  143.25, 144, 156, 156.75];
Cnnt.L18.Ring4.HspTol = 0.5;
Cnnt.L18.Ring4.SDir = [30 150];

%Line19 - TF * TBring
%Line20 - IS * UMB13
Cnnt.L20.SN = 'API_WJ_Air';
Cnnt.L20.group = 'circ';
Cnnt.L20.axis = 'y';

Cnnt.L20.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L20.IS.axisTT = 'x';
Cnnt.L20.IS.int = 2;
Cnnt.L20.IS.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L20.IS.HspTol = 0.5; %Tolerance in hot spot sampling
Cnnt.L20.IS.SDir = 90;

Cnnt.L20.UMB13.thk = Thk.Col1.UMB;
Cnnt.L20.UMB13.axisTT = 'x';
Cnnt.L20.UMB13.int = 3;
Cnnt.L20.UMB13.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L20.UMB13.HspTol = 0.5; 
Cnnt.L20.UMB13.SDir = 60;

%Line21 - IS * VB13
Cnnt.L21.SN = 'API_WJ_Air';
Cnnt.L21.group = 'circ';
Cnnt.L21.axis = 'y';

Cnnt.L21.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L21.IS.axisTT = 'x';
Cnnt.L21.IS.int = 2;
Cnnt.L21.IS.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L21.IS.HspTol = 0.5;
Cnnt.L21.IS.SDir = 60;

Cnnt.L21.VB13.thk = Thk.Col1.VB;
Cnnt.L21.VB13.axisTT = 'x';
Cnnt.L21.VB13.int = 3;
Cnnt.L21.VB13.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L21.VB13.HspTol = 0.5;
Cnnt.L21.VB13.SDir = 90;

%Line22 - OS * UMB13
Cnnt.L22.SN = 'API_WJ_Air';
Cnnt.L22.group = 'circ';
Cnnt.L22.axis = 'y';

Cnnt.L22.OS.thk = Thk.Col1.OSatUMB;
Cnnt.L22.OS.axisTT = 'x';
Cnnt.L22.OS.int = 3;

Cnnt.L22.UMB13.thk = Thk.Col1.UMB;
Cnnt.L22.UMB13.axisTT = 'x';
Cnnt.L22.UMB13.int = 3;

%Line23 - OS * VB13
Cnnt.L23.SN = 'API_WJ_Air';
Cnnt.L23.group = 'circ';
Cnnt.L23.axis = 'y';

Cnnt.L23.OS.thk = Thk.Col1.OSatVB;
Cnnt.L23.OS.axisTT = 'x';
Cnnt.L23.OS.int = 3;

Cnnt.L23.VB13.thk = Thk.Col1.VB;
Cnnt.L23.VB13.axisTT = 'x';
Cnnt.L23.VB13.int = 3;

%Line24 - Bkh2 two edges
Cnnt.L24.SN = 'ABS_E_Air';
Cnnt.L24.group = 'flat';
Cnnt.L24.axis1 = 'y';
Cnnt.L24.axis2 = 'z';

Cnnt.L24.Bkh2.thk = Thk.Col1.Bkh;
Cnnt.L24.Bkh2.axisTT = 'x';
Cnnt.L24.Bkh2.int = 5;
Cnnt.L24.Bkh2.path = [0,0;-2750,0;-2750,-13000;0,-13000];
Cnnt.L24.Bkh2.HspAxis = 'z';
Cnnt.L24.Bkh2.Hsp = 0;
Cnnt.L24.Bkh2.HspTol = 0.5;
Cnnt.L24.Bkh2.HspInt = 2;
Cnnt.L24.Bkh2.SDir = 50;

%Line25 - FB2 four edges
Cnnt.L25.SN = 'ABS_E_Air';
Cnnt.L25.group = 'flat';
Cnnt.L25.axis1 = 'y';
Cnnt.L25.axis2 = 'z';

Cnnt.L25.FB2.thk = Thk.Col1.FB;
Cnnt.L25.FB2.axisTT = 'x';
Cnnt.L25.FB2.int = 3;
Cnnt.L25.FB2.path = [0,0;-2750,0;-2750,-500;0,-500];
Cnnt.L25.FB2.HspAxis1 = 'z';
Cnnt.L25.FB2.Hsp = 0;
Cnnt.L25.FB2.HspAxis2 = 'y';
Cnnt.L25.FB2.Hsp2 = -2750;
Cnnt.L25.FB2.HspTol = 0.5;
Cnnt.L25.FB2.HspInt = 1;
Cnnt.L25.FB2.SDir = 30;

%Line26 - IS opening
Cnnt.L26.SN = 'ABS_C_Air';
Cnnt.L26.group = 'flat';
Cnnt.L26.axis1 = 'y';
Cnnt.L26.axis2 = 'z';

Cnnt.L26.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L26.IS.axisTT = 'x';
Cnnt.L26.IS.int = 2;

%Line27 - VB12lwr * LMB12mid
%Line28 - VB21lwr * LMB12mid
%Line29 - VB13lwr * LMB13mid
%Line30 - VB31lwr * LMB13mid
%Line31 - IS * C-Plate

%Line32 - Vbar1 (at Bkh1) four edge
Cnnt.L32.SN = 'ABS_E_Air';
Cnnt.L32.group = 'other';
Cnnt.L32.axis1 = 'x';
Cnnt.L32.axis2 = 'z';

Cnnt.L32.Vbar1.thk = Thk.Col1.VBaratBkh;
Cnnt.L32.Vbar1.axisTT = 'y';
Cnnt.L32.Vbar1.int = 1;

Cnnt.L32.Vbar1.HspAxis = 'x';
Cnnt.L32.Vbar1.Hsp = [2550, 3250];
Cnnt.L32.Vbar1.HspTol = 0.5;
Cnnt.L32.Vbar1.HspInt = 3;
Cnnt.L32.Vbar1.SDir = 60;

%Line33 - Vbar2 (at Bkh2) four edge
Cnnt.L33.SN = 'ABS_E_Air';
Cnnt.L33.group = 'other';
Cnnt.L33.axis1 = 'x';
Cnnt.L33.axis2 = 'z';

Cnnt.L33.Vbar2.thk = Thk.Col1.VBaratBkh;
Cnnt.L33.Vbar2.axisTT = 'y';
Cnnt.L33.Vbar2.int = 1;

Cnnt.L33.Vbar2.HspAxis = 'x';
Cnnt.L33.Vbar2.Hsp = [2550, 3250];
Cnnt.L33.Vbar2.HspTol = 0.5;
Cnnt.L33.Vbar2.HspInt = 3;
Cnnt.L33.Vbar2.SDir = 60;

%Line34 - Vbar3 (at UMBVB12) four edge
Cnnt.L34.SN = 'ABS_E_Air';
Cnnt.L34.group = 'other';
Cnnt.L34.axis1 = 'x';
Cnnt.L34.axis2 = 'z';

Cnnt.L34.Vbar3.thk = Thk.Col1.VBaratTruss;
Cnnt.L34.Vbar3.axisTT = 'y';
Cnnt.L34.Vbar3.int = 1;

Cnnt.L34.Vbar3.HspAxis = 'x';
Cnnt.L34.Vbar3.Hsp = [2550, 3250];
Cnnt.L34.Vbar3.HspTol = 0.5;
Cnnt.L34.Vbar3.HspInt = 4;
Cnnt.L34.Vbar3.SDir = 90;

%Line35 - Vbar4 (at UMBVB12) four edge
Cnnt.L35.SN = 'ABS_E_Air';
Cnnt.L35.group = 'other';
Cnnt.L35.axis1 = 'x';
Cnnt.L35.axis2 = 'z';

Cnnt.L35.Vbar4.thk = Thk.Col1.VBaratTruss;
Cnnt.L35.Vbar4.axisTT = 'y';
Cnnt.L35.Vbar4.int = 1;
Cnnt.L35.Vbar4.path = [];
Cnnt.L35.Vbar4.HspAxis = 'x';
Cnnt.L35.Vbar4.Hsp = [2550, 3250];
Cnnt.L35.Vbar4.HspTol = 0.5;
Cnnt.L35.Vbar4.HspInt = 4;
Cnnt.L35.Vbar4.SDir = 90;

%Line36 - Vbar5 (at UMBVB13) four edge
Cnnt.L36.SN = 'ABS_E_Air';
Cnnt.L36.group = 'other';
Cnnt.L36.axis1 = 'x';
Cnnt.L36.axis2 = 'z';

Cnnt.L36.Vbar5.thk = Thk.Col1.VBaratTruss;
Cnnt.L36.Vbar5.axisTT = 'y';
Cnnt.L36.Vbar5.int = 1;

Cnnt.L36.Vbar5.HspAxis = 'x';
Cnnt.L36.Vbar5.Hsp = [2550, 3250];
Cnnt.L36.Vbar5.HspTol = 0.5;
Cnnt.L36.Vbar5.HspInt = 4;
Cnnt.L36.Vbar5.SDir = 90;

%Line37 - Vbar6 (at UMBVB13) four edge
Cnnt.L37.SN = 'ABS_E_Air';
Cnnt.L37.group = 'other';
Cnnt.L37.axis1 = 'x';
Cnnt.L37.axis2 = 'z';

Cnnt.L37.Vbar6.thk = Thk.Col1.VBaratTruss;
Cnnt.L37.Vbar6.axisTT = 'y';
Cnnt.L37.Vbar6.int = 1;

Cnnt.L37.Vbar6.HspAxis = 'x';
Cnnt.L37.Vbar6.Hsp = [2550, 3250];
Cnnt.L37.Vbar6.HspTol = 0.5;
Cnnt.L37.Vbar6.HspInt = 4;
Cnnt.L37.Vbar6.SDir = 90;

%Line38 - Ring1 inner edges and connection with Vbars
Cnnt.L38.SN = 'ABS_C_Air';
Cnnt.L38.group = 'other';
Cnnt.L38.axis1 = 'x';
Cnnt.L38.axis2 = 'y';

Cnnt.L38.Ring1.thk = Thk.Col1.RingatUMB;
Cnnt.L38.Ring1.axisTT = 'z';
Cnnt.L38.Ring1.int = 4;

Cnnt.L38.Ring1.HspAxis = 'y';
Cnnt.L38.Ring1.Hsp = [-156, -144, -120, 120, 144, 156];
Cnnt.L38.Ring1.HspSN = 'ABS_E_Air';
Cnnt.L38.Ring1.HspTol = 0.5;
Cnnt.L38.Ring1.HspInt = 1;
Cnnt.L38.Ring1.SDir = 90;

%Line39 - Ring2 inner edges and connection with Vbars
Cnnt.L39.SN = 'ABS_C_Air';
Cnnt.L39.group = 'other';
Cnnt.L39.axis1 = 'x';
Cnnt.L39.axis2 = 'y';

Cnnt.L39.Ring2.thk = Thk.Col1.RingatUMB;
Cnnt.L39.Ring2.axisTT = 'z';
Cnnt.L39.Ring2.int = 4;

Cnnt.L39.Ring2.HspAxis = 'y';
Cnnt.L39.Ring2.Hsp = [-156, -144, -120, 120, 144, 156];
Cnnt.L39.Ring2.HspSN = 'ABS_E_Air';
Cnnt.L39.Ring2.HspTol = 0.5;
Cnnt.L39.Ring2.HspInt = 1;
Cnnt.L39.Ring2.SDir = 90;

%Line40 - Ring3 inner edges and connection with Vbars
Cnnt.L40.SN = 'ABS_C_Air';
Cnnt.L40.group = 'other';
Cnnt.L40.axis1 = 'x';
Cnnt.L40.axis2 = 'y';

Cnnt.L40.Ring3.thk = Thk.Col1.RingatVB;
Cnnt.L40.Ring3.axisTT = 'z';
Cnnt.L40.Ring3.int = 4;

Cnnt.L40.Ring3.HspAxis = 'y';
Cnnt.L40.Ring3.Hsp = [-156, -144, -120, 120, 144, 156];
Cnnt.L40.Ring3.HspSN = 'ABS_E_Air';
Cnnt.L40.Ring3.HspTol = 0.5;
Cnnt.L40.Ring3.HspInt = 1;
Cnnt.L40.Ring3.SDir = 90;

%Line41 - Ring4 inner edges and connection with Vbars
Cnnt.L41.SN = 'ABS_C_Air';
Cnnt.L41.group = 'other';
Cnnt.L41.axis1 = 'x';
Cnnt.L41.axis2 = 'y';

Cnnt.L41.Ring4.thk = Thk.Col1.RingatVB;
Cnnt.L41.Ring4.axisTT = 'z';
Cnnt.L41.Ring4.int = 4;

Cnnt.L41.Ring4.HspAxis = 'y';
Cnnt.L41.Ring4.Hsp = [-156, -144, -120, 120, 144, 156];
Cnnt.L41.Ring4.HspSN = 'ABS_E_Air';
Cnnt.L41.Ring4.HspTol = 0.5;
Cnnt.L41.Ring4.HspInt = 1;
Cnnt.L41.Ring4.SDir = 90;

%Line42 - TBBrkt1 (at Bkh1)
Cnnt.L42.SN = 'ABS_C_Air';
Cnnt.L42.group = 'other';
Cnnt.L42.axis1 = 'x';
Cnnt.L42.axis2 = 'z';

Cnnt.L42.TBBrkt1.thk = Thk.Col1.Brkt_TBatBkh;
Cnnt.L42.TBBrkt1.axisTT = 'y';
Cnnt.L42.TBBrkt1.int = 1;

Cnnt.L42.TBBrkt1.HspAxis = 'x';
Cnnt.L42.TBBrkt1.Hsp = 3250;
Cnnt.L42.TBBrkt1.HspAxis2 = 'z';
Cnnt.L42.TBBrkt1.Hsp2 = 13000;

Cnnt.L42.TBBrkt1.HspSN = 'ABS_E_Air';
Cnnt.L42.TBBrkt1.HspTol = 15;
Cnnt.L42.TBBrkt1.HspInt = 1;
Cnnt.L42.TBBrkt1.SDir = 130;

%Line43 - TBBrkt1 (at FB1)
Cnnt.L43.SN = 'ABS_C_Air';
Cnnt.L43.group = 'other';
Cnnt.L43.axis1 = 'x';
Cnnt.L43.axis2 = 'z';

Cnnt.L43.TBBrkt2.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L43.TBBrkt2.axisTT = 'y';
Cnnt.L43.TBBrkt2.int = 1;

Cnnt.L43.TBBrkt2.HspAxis = 'x';
Cnnt.L43.TBBrkt2.Hsp = 3250;
Cnnt.L43.TBBrkt2.HspAxis2 = 'z';
Cnnt.L43.TBBrkt2.Hsp2 = 13000;

Cnnt.L43.TBBrkt2.HspSN = 'ABS_E_Air';
Cnnt.L43.TBBrkt2.HspTol = 15;
Cnnt.L43.TBBrkt2.HspInt = 3;
Cnnt.L43.TBBrkt2.SDir = 130;

%Line42 - TBBrkt1 (at OS*FB1)
Cnnt.L44.SN = 'ABS_C_Air';
Cnnt.L44.group = 'other';
Cnnt.L44.axis1 = 'x';
Cnnt.L44.axis2 = 'z';

Cnnt.L44.TBBrkt3.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L44.TBBrkt3.axisTT = 'y';
Cnnt.L44.TBBrkt3.int = 1;

Cnnt.L44.TBBrkt3.HspAxis = 'x';
Cnnt.L44.TBBrkt3.Hsp = 6000;
Cnnt.L44.TBBrkt3.HspAxis2 = 'z';
Cnnt.L44.TBBrkt3.Hsp2 = 12500;

Cnnt.L44.TBBrkt3.HspSN = 'ABS_E_Air';
Cnnt.L44.TBBrkt3.HspTol = 15;
Cnnt.L44.TBBrkt3.HspInt = 1;
Cnnt.L44.TBBrkt3.SDir = 150;

%Line45 - TBBrkt4 (at Bkh2)
Cnnt.L45.SN = 'ABS_C_Air';
Cnnt.L45.group = 'other';
Cnnt.L45.axis1 = 'x';
Cnnt.L45.axis2 = 'z';

Cnnt.L45.TBBrkt4.thk = Thk.Col1.Brkt_TBatBkh;
Cnnt.L45.TBBrkt4.axisTT = 'y';
Cnnt.L45.TBBrkt4.int = 1;

Cnnt.L45.TBBrkt4.HspAxis = 'x';
Cnnt.L45.TBBrkt4.Hsp = 3250;
Cnnt.L45.TBBrkt4.HspAxis2 = 'z';
Cnnt.L45.TBBrkt4.Hsp2 = 13000;

Cnnt.L45.TBBrkt4.HspSN = 'ABS_E_Air';
Cnnt.L45.TBBrkt4.HspTol = 15;
Cnnt.L45.TBBrkt4.HspInt = 1;
Cnnt.L45.TBBrkt4.SDir = 130;

%Line46 - TBBrkt5 (at FB2)
Cnnt.L46.SN = 'ABS_C_Air';
Cnnt.L46.group = 'other';
Cnnt.L46.axis1 = 'x';
Cnnt.L46.axis2 = 'z';

Cnnt.L46.TBBrkt5.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L46.TBBrkt5.axisTT = 'y';
Cnnt.L46.TBBrkt5.int = 1;

Cnnt.L46.TBBrkt5.HspAxis = 'x';
Cnnt.L46.TBBrkt5.Hsp = 3250;
Cnnt.L46.TBBrkt5.HspAxis2 = 'z';
Cnnt.L46.TBBrkt5.Hsp2 = 13000;

Cnnt.L46.TBBrkt5.HspSN = 'ABS_E_Air';
Cnnt.L46.TBBrkt5.HspTol = 15;
Cnnt.L46.TBBrkt5.HspInt = 1;
Cnnt.L46.TBBrkt5.SDir = 130;

%Line47 - TBBrkt6 (at OS*FB2)
Cnnt.L47.SN = 'ABS_C_Air';
Cnnt.L47.group = 'other';
Cnnt.L47.axis1 = 'x';
Cnnt.L47.axis2 = 'z';

Cnnt.L47.TBBrkt6.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L47.TBBrkt6.axisTT = 'y';
Cnnt.L47.TBBrkt6.int = 1;

Cnnt.L47.TBBrkt6.HspAxis = 'x';
Cnnt.L47.TBBrkt6.Hsp = 6000;
Cnnt.L47.TBBrkt6.HspAxis2 = 'z';
Cnnt.L47.TBBrkt6.Hsp2 = 12500;

Cnnt.L47.TBBrkt6.HspSN = 'ABS_E_Air';
Cnnt.L47.TBBrkt6.HspTol = 15;
Cnnt.L47.TBBrkt6.HspInt = 1;
Cnnt.L47.TBBrkt6.SDir = 150;

%L48 - TOC ring * Vbars
Cnnt.L48.SN = 'ABS_E_Air';
Cnnt.L48.group = 'rad';
Cnnt.L48.axis_c = 'y';
Cnnt.L48.axis_r = 'x';

Cnnt.L48.TOCring.thk = Thk.Col1.TOCring;
Cnnt.L48.TOCring.axisTT = 'z';
Cnnt.L48.TOCring.int = 1;
Cnnt.L48.TOCring.HspAxis = 'x';
Cnnt.L48.TOCring.Hsp = 2550;
Cnnt.L48.TOCring.HspTol = 0.5;
Cnnt.L48.TOCring.SDir = 90;

OutName = [path1 'CnntInfo.mat'];
save(OutName, 'Cnnt')

%% ItrR5_15_18 (Col1_Top)
ItrNo = 'ItrR5_15_18';
path1 = [path0 ItrNo '\'];
load([path1 'thickness.mat']);

Cnnt.Itr = ItrNo;

%Line1 - TB*IS*TF
Cnnt.L1.SN = 'ABS_E_Air';
Cnnt.L1.group = 'circ';
Cnnt.L1.axis = 'y';

Cnnt.L1.TB.thk = Thk.Col1.TB;
Cnnt.L1.TB.int = 2;
Cnnt.L1.TB.axisTT = 'x'; %through-thickness axis
Cnnt.L1.TB.SDir = 90; %degree

Cnnt.L1.TF.thk = Thk.Col1.TFin;
Cnnt.L1.TF.int = 10;
Cnnt.L1.TF.axisTT = 'z'; %through-thickness axis
Cnnt.L1.TF.HspAxis = 'y';
Cnnt.L1.TF.Hsp = -165:15:180;
Cnnt.L1.TF.HspTol = 0.5;

Cnnt.L1.TOCring.thk = Thk.Col1.TFin;
Cnnt.L1.TOCring.int = 10;
Cnnt.L1.TOCring.axisTT = 'z';

%Line2 - IS*UMB12
Cnnt.L2.SN = 'API_WJ_Air';
Cnnt.L2.group = 'circ';
Cnnt.L2.axis = 'y';

Cnnt.L2.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L2.IS.int = 2;
Cnnt.L2.IS.axisTT = 'x';
Cnnt.L2.IS.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L2.IS.HspTol = 0.5; %Tolerance in hot spot sampling
Cnnt.L2.IS.SDir = 90;

Cnnt.L2.UMB12.thk = Thk.Col1.UMB;
Cnnt.L2.UMB12.int = 3;
Cnnt.L2.UMB12.axisTT = 'x';
Cnnt.L2.UMB12.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L2.UMB12.HspTol = 0.5; 
Cnnt.L2.UMB12.SDir = 120;

%Line3 - IS*VB12
Cnnt.L3.SN = 'API_WJ_Air';
Cnnt.L3.group = 'circ';
Cnnt.L3.axis = 'y';

Cnnt.L3.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L3.IS.axisTT = 'x';
Cnnt.L3.IS.int = 2;
Cnnt.L3.IS.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L3.IS.HspTol = 0.5;
Cnnt.L3.IS.SDir = 120;

Cnnt.L3.VB12.thk = Thk.Col1.VB;
Cnnt.L3.VB12.axisTT = 'x';
Cnnt.L3.VB12.int = 3;
Cnnt.L3.VB12.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L3.VB12.HspTol = 0.5;
Cnnt.L3.VB12.SDir = 90;

%Line4 - IS*BKHs
Cnnt.L4.SN = 'ABS_E_Air';
Cnnt.L4.group = 'rad';
Cnnt.L4.axis_c = 'y';
Cnnt.L4.axis_r = 'z';

Cnnt.L4.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L4.IS.axisTT = 'x';
Cnnt.L4.IS.int = 5;
Cnnt.L4.IS.HspAxis = 'z';
Cnnt.L4.IS.Hsp = [5585, 6900,7550.3,8300,9311,9700,10700,10844,11800,12356];
Cnnt.L4.IS.HspTol = 10;
Cnnt.L4.IS.SDir = 90;

%Line5 - OS*TF
Cnnt.L5.SN = 'ABS_E_Air';
Cnnt.L5.group = 'circ';
Cnnt.L5.axis = 'y';

Cnnt.L5.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L5.OS.axisTT = 'x';
Cnnt.L5.OS.int = 20;
Cnnt.L5.OS.HspThk = Thk.Col1.OSatUMB ;
Cnnt.L5.OS.Hsp = -172.5 : 15 : 172.5;
Cnnt.L5.OS.HspTol = 0.2;
Cnnt.L5.OS.SDir = 0;

Cnnt.L5.TF.thk = Thk.Col1.TFout;
Cnnt.L5.TF.axisTT = 'z';
Cnnt.L5.TF.int = 20;
Cnnt.L5.TF.HspThk = Thk.Col1.TFatUMB ;
Cnnt.L5.TF.Hsp = -180 : 7.5 : 180;
Cnnt.L5.TF.HspTol = 0.2;
Cnnt.L5.TF.SDir = 90;

%Line6 - OS*UMB12
Cnnt.L6.SN = 'API_WJ_Air';
Cnnt.L6.group = 'circ';
Cnnt.L6.axis = 'y';

Cnnt.L6.OS.thk = Thk.Col1.OSatUMB;
Cnnt.L6.OS.axisTT = 'x';
Cnnt.L6.OS.int = 3;

Cnnt.L6.UMB12.thk = Thk.Col1.UMB;
Cnnt.L6.UMB12.axisTT = 'x';
Cnnt.L6.UMB12.int = 3;

%Line7 - OS*VB12
Cnnt.L7.SN = 'API_WJ_Air';
Cnnt.L7.group = 'circ';
Cnnt.L7.axis = 'y';

Cnnt.L7.OS.thk = Thk.Col1.OSatVB;
Cnnt.L7.OS.axisTT = 'x';
Cnnt.L7.OS.int = 3;

Cnnt.L7.VB12.thk = Thk.Col1.VB;
Cnnt.L7.VB12.axisTT = 'x';
Cnnt.L7.VB12.int = 3;

%Line8 - OS*Bkh1
Cnnt.L8.SN = 'ABS_E_Air';
Cnnt.L8.group = 'rad';
Cnnt.L8.axis_c = 'y';
Cnnt.L8.axis_r = 'z';

Cnnt.L8.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L8.OS.axisTT = 'x';
Cnnt.L8.OS.int = 10;
Cnnt.L8.OS.HspAxis = 'z';
Cnnt.L8.OS.Hsp = [0,1100,2000,2200,3300,4400,5000,5500,6900,8300,9700,10700,11800,13000];
Cnnt.L8.OS.HspTol = 10;
Cnnt.L8.OS.SDir = 0;

%Line9 - OS*TFgd
Cnnt.L9.SN = 'ABS_E_Air';
Cnnt.L9.group = 'rad';
Cnnt.L9.axis_c = 'y';
Cnnt.L9.axis_r = 'z';

Cnnt.L9.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L9.OS.axisTT = 'x';
Cnnt.L9.OS.int = 3;
Cnnt.L9.OS.HspAxis = 'y';
Cnnt.L9.OS.HspThk = Thk.Col1.OSatUMB ;
Cnnt.L9.OS.Hsp = [-150,150];
Cnnt.L9.OS.HspTol = 0.1;
Cnnt.L8.OS.SDir = 0;

%Line10 - Bkh1 four edges
Cnnt.L10.SN = 'ABS_E_Air';
Cnnt.L10.group = 'flat';
Cnnt.L10.axis1 = 'y';
Cnnt.L10.axis2 = 'z';

Cnnt.L10.Bkh1.thk = Thk.Col1.Bkh;
Cnnt.L10.Bkh1.axisTT = 'x';
Cnnt.L10.Bkh1.int = 5;

Cnnt.L10.Bkh1.path = [0,0;2750,0;2750,-13000;0,-13000];
Cnnt.L10.Bkh1.HspAxis = 'z';
Cnnt.L10.Bkh1.Hsp = 0;
Cnnt.L10.Bkh1.HspTol = 0.5;
Cnnt.L10.Bkh1.HspInt = 1;
Cnnt.L10.Bkh1.SDir = 120;

%Line11 - TFin * TFgd
Cnnt.L11.SN = 'ABS_E_Air';
Cnnt.L11.group = 'other';
Cnnt.L11.axis1 = 'y';
Cnnt.L11.axis2 = 'x';

Cnnt.L11.TF.thk = Thk.Col1.TFin;
Cnnt.L11.TF.axisTT = 'z';
Cnnt.L11.TF.int = 1;
Cnnt.L11.TF.HspAxis = 'y';
Cnnt.L11.TF.Hsp = -165:15:180;
Cnnt.L11.TF.HspTol = 0.1;
Cnnt.L11.TF.HspInt = 5;

%Line12 - TFout * TFgd
%Line13 - FB1 * UMB12
Cnnt.L13.SN = 'ABS_E_Air';
Cnnt.L13.group = 'flat';
Cnnt.L13.axis1 = 'y';
Cnnt.L13.axis2 = 'z';

Cnnt.L13.FB1.thk = Thk.Col1.FB;
Cnnt.L13.FB1.axisTT = 'x';
Cnnt.L13.FB1.int = 6;
Cnnt.L13.FB1.path = [0,0;2750,0;2750,-500;0,-500];

Cnnt.L13.FB1.HspAxis = 'z';
Cnnt.L13.FB1.Hsp = 0;
Cnnt.L13.FB1.HspTol = 0.5;
Cnnt.L13.FB1.HspInt = 3;
Cnnt.L13.FB1.SDir = 150;

%Line14 - TB * TBbrkt
Cnnt.L14.SN = 'ABS_E_Air';
Cnnt.L14.group = 'rad';
Cnnt.L14.axis_c = 'y';
Cnnt.L14.axis_r = 'z';

Cnnt.L14.TB.thk = Thk.Col1.TB;
Cnnt.L14.TB.axisTT = 'x';
Cnnt.L14.TB.int = 1;
Cnnt.L14.TB.HspAxis = 'y';
Cnnt.L14.TB.Hsp = -120;
Cnnt.L14.TB.HspTol = 0.5;
Cnnt.L14.TB.SDir = 90;

%Line15 - IS * Ring1
Cnnt.L15.SN = 'ABS_E_Air';
Cnnt.L15.group = 'circ';
Cnnt.L15.axis = 'y';

Cnnt.L15.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L15.IS.axisTT = 'x';
Cnnt.L15.IS.int = 3;
Cnnt.L15.IS.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L15.IS.HspTol = 0.5;
Cnnt.L15.IS.SDir = 90;

Cnnt.L15.Ring1.thk = Thk.Col1.RingatUMB;
Cnnt.L15.Ring1.axisTT = 'z';
Cnnt.L15.Ring1.int = 10;
Cnnt.L15.Ring1.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L15.Ring1.HspTol = 0.5;
Cnnt.L15.Ring1.SDir = 0;

%Line16 - IS * Ring2
Cnnt.L16.SN = 'ABS_E_Air';
Cnnt.L16.group = 'circ';
Cnnt.L16.axis = 'y';

Cnnt.L16.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L16.IS.axisTT = 'x';
Cnnt.L16.IS.int = 3;
Cnnt.L16.IS.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L16.IS.HspTol = 0.5;
Cnnt.L16.IS.SDir = 90;

Cnnt.L16.Ring2.thk = Thk.Col1.RingatUMB;
Cnnt.L16.Ring2.axisTT = 'z';
Cnnt.L16.Ring2.int = 10;
Cnnt.L16.Ring2.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L16.Ring2.HspTol = 0.5;
Cnnt.L16.Ring2.SDir = 0;

%Line17 - IS * Ring3
Cnnt.L17.SN = 'ABS_E_Air';
Cnnt.L17.group = 'circ';
Cnnt.L17.axis = 'y';

Cnnt.L17.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L17.IS.axisTT = 'x';
Cnnt.L17.IS.int = 3;
Cnnt.L17.IS.Hsp = [-157.71, -156, -144, -142.29, -120, 120, 142.29, 144, 156, 157.71];
Cnnt.L17.IS.HspTol = 0.5;
Cnnt.L17.IS.SDir = 120;

Cnnt.L17.Ring3.thk = Thk.Col1.RingatVB;
Cnnt.L17.Ring3.axisTT = 'z';
Cnnt.L17.Ring3.int = 10;
Cnnt.L17.Ring3.Hsp = [-157.71, -156, -144, -142.29, -120, 120, 142.29, 144, 156, 157.71];
Cnnt.L17.Ring3.HspTol = 0.5;
Cnnt.L17.Ring3.SDir = 0;

%Line18 - IS * Ring4
Cnnt.L18.SN = 'ABS_E_Air';
Cnnt.L18.group = 'circ';
Cnnt.L18.axis = 'y';

Cnnt.L18.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L18.IS.axisTT = 'x';
Cnnt.L18.IS.int = 3;
Cnnt.L18.IS.Hsp = [-156.75, -156, -144, -143.25,-120, 120,  143.25, 144, 156, 156.75];
Cnnt.L18.IS.HspTol = 0.5;
Cnnt.L18.IS.SDir = 90;

Cnnt.L18.Ring4.thk = Thk.Col1.RingatVB;
Cnnt.L18.Ring4.axisTT = 'z';
Cnnt.L18.Ring4.int = 10;
Cnnt.L18.Ring4.Hsp = [-156.75, -156, -144, -143.25,-120, 120,  143.25, 144, 156, 156.75];
Cnnt.L18.Ring4.HspTol = 0.5;
Cnnt.L18.Ring4.SDir = [30 150];

%Line19 - TF * TBring
%Line20 - IS * UMB13
Cnnt.L20.SN = 'API_WJ_Air';
Cnnt.L20.group = 'circ';
Cnnt.L20.axis = 'y';

Cnnt.L20.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L20.IS.axisTT = 'x';
Cnnt.L20.IS.int = 2;
Cnnt.L20.IS.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L20.IS.HspTol = 0.5; %Tolerance in hot spot sampling
Cnnt.L20.IS.SDir = 90;

Cnnt.L20.UMB13.thk = Thk.Col1.UMB;
Cnnt.L20.UMB13.axisTT = 'x';
Cnnt.L20.UMB13.int = 3;
Cnnt.L20.UMB13.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L20.UMB13.HspTol = 0.5; 
Cnnt.L20.UMB13.SDir = 60;

%Line21 - IS * VB13
Cnnt.L21.SN = 'API_WJ_Air';
Cnnt.L21.group = 'circ';
Cnnt.L21.axis = 'y';

Cnnt.L21.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L21.IS.axisTT = 'x';
Cnnt.L21.IS.int = 2;
Cnnt.L21.IS.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L21.IS.HspTol = 0.5;
Cnnt.L21.IS.SDir = 60;

Cnnt.L21.VB13.thk = Thk.Col1.VB;
Cnnt.L21.VB13.axisTT = 'x';
Cnnt.L21.VB13.int = 3;
Cnnt.L21.VB13.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L21.VB13.HspTol = 0.5;
Cnnt.L21.VB13.SDir = 90;

%Line22 - OS * UMB13
Cnnt.L22.SN = 'API_WJ_Air';
Cnnt.L22.group = 'circ';
Cnnt.L22.axis = 'y';

Cnnt.L22.OS.thk = Thk.Col1.OSatUMB;
Cnnt.L22.OS.axisTT = 'x';
Cnnt.L22.OS.int = 3;

Cnnt.L22.UMB13.thk = Thk.Col1.UMB;
Cnnt.L22.UMB13.axisTT = 'x';
Cnnt.L22.UMB13.int = 3;

%Line23 - OS * VB13
Cnnt.L23.SN = 'API_WJ_Air';
Cnnt.L23.group = 'circ';
Cnnt.L23.axis = 'y';

Cnnt.L23.OS.thk = Thk.Col1.OSatVB;
Cnnt.L23.OS.axisTT = 'x';
Cnnt.L23.OS.int = 3;

Cnnt.L23.VB13.thk = Thk.Col1.VB;
Cnnt.L23.VB13.axisTT = 'x';
Cnnt.L23.VB13.int = 3;

%Line24 - Bkh2 two edges
Cnnt.L24.SN = 'ABS_E_Air';
Cnnt.L24.group = 'flat';
Cnnt.L24.axis1 = 'y';
Cnnt.L24.axis2 = 'z';

Cnnt.L24.Bkh2.thk = Thk.Col1.Bkh;
Cnnt.L24.Bkh2.axisTT = 'x';
Cnnt.L24.Bkh2.int = 5;
Cnnt.L24.Bkh2.path = [0,0;-2750,0;-2750,-13000;0,-13000];
Cnnt.L24.Bkh2.HspAxis = 'z';
Cnnt.L24.Bkh2.Hsp = 0;
Cnnt.L24.Bkh2.HspTol = 0.5;
Cnnt.L24.Bkh2.HspInt = 1;
Cnnt.L24.Bkh2.SDir = 50;

%Line25 - FB2 four edges
Cnnt.L25.SN = 'ABS_E_Air';
Cnnt.L25.group = 'flat';
Cnnt.L25.axis1 = 'y';
Cnnt.L25.axis2 = 'z';

Cnnt.L25.FB2.thk = Thk.Col1.FB;
Cnnt.L25.FB2.axisTT = 'x';
Cnnt.L25.FB2.int = 3;
Cnnt.L25.FB2.path = [0,0;-2750,0;-2750,-500;0,-500];
Cnnt.L25.FB2.HspAxis1 = 'z';
Cnnt.L25.FB2.Hsp = 0;
Cnnt.L25.FB2.HspAxis2 = 'y';
Cnnt.L25.FB2.Hsp2 = -2750;
Cnnt.L25.FB2.HspTol = 0.5;
Cnnt.L25.FB2.HspInt = 1;
Cnnt.L25.FB2.SDir = 30;

%Line26 - IS opening
Cnnt.L26.SN = 'ABS_C_Air';
Cnnt.L26.group = 'flat';
Cnnt.L26.axis1 = 'y';
Cnnt.L26.axis2 = 'z';

Cnnt.L26.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L26.IS.axisTT = 'x';
Cnnt.L26.IS.int = 2;

%Line27 - VB12lwr * LMB12mid
%Line28 - VB21lwr * LMB12mid
%Line29 - VB13lwr * LMB13mid
%Line30 - VB31lwr * LMB13mid
%Line31 - IS * C-Plate

%Line32 - Vbar1 (at Bkh1) four edge
Cnnt.L32.SN = 'ABS_E_Air';
Cnnt.L32.group = 'other';
Cnnt.L32.axis1 = 'x';
Cnnt.L32.axis2 = 'z';

Cnnt.L32.Vbar1.thk = Thk.Col1.VBaratBkh;
Cnnt.L32.Vbar1.axisTT = 'y';
Cnnt.L32.Vbar1.int = 1;

Cnnt.L32.Vbar1.HspAxis = 'x';
Cnnt.L32.Vbar1.Hsp = [2550, 3250];
Cnnt.L32.Vbar1.HspTol = 0.5;
Cnnt.L32.Vbar1.HspInt = 4;
Cnnt.L32.Vbar1.SDir = 60;

%Line33 - Vbar2 (at Bkh2) four edge
Cnnt.L33.SN = 'ABS_E_Air';
Cnnt.L33.group = 'other';
Cnnt.L33.axis1 = 'x';
Cnnt.L33.axis2 = 'z';

Cnnt.L33.Vbar2.thk = Thk.Col1.VBaratBkh;
Cnnt.L33.Vbar2.axisTT = 'y';
Cnnt.L33.Vbar2.int = 1;

Cnnt.L33.Vbar2.HspAxis = 'x';
Cnnt.L33.Vbar2.Hsp = [2550, 3250];
Cnnt.L33.Vbar2.HspTol = 0.5;
Cnnt.L33.Vbar2.HspInt = 4;
Cnnt.L33.Vbar2.SDir = 60;

%Line34 - Vbar3 (at UMBVB12) four edge
Cnnt.L34.SN = 'ABS_E_Air';
Cnnt.L34.group = 'other';
Cnnt.L34.axis1 = 'x';
Cnnt.L34.axis2 = 'z';

Cnnt.L34.Vbar3.thk = Thk.Col1.VBaratTruss;
Cnnt.L34.Vbar3.axisTT = 'y';
Cnnt.L34.Vbar3.int = 1;

Cnnt.L34.Vbar3.HspAxis = 'x';
Cnnt.L34.Vbar3.Hsp = [2550, 3250];
Cnnt.L34.Vbar3.HspTol = 0.5;
Cnnt.L34.Vbar3.HspInt = 4;
Cnnt.L34.Vbar3.SDir = 90;

%Line35 - Vbar4 (at UMBVB12) four edge
Cnnt.L35.SN = 'ABS_E_Air';
Cnnt.L35.group = 'other';
Cnnt.L35.axis1 = 'x';
Cnnt.L35.axis2 = 'z';

Cnnt.L35.Vbar4.thk = Thk.Col1.VBaratTruss;
Cnnt.L35.Vbar4.axisTT = 'y';
Cnnt.L35.Vbar4.int = 1;
Cnnt.L35.Vbar4.path = [];
Cnnt.L35.Vbar4.HspAxis = 'x';
Cnnt.L35.Vbar4.Hsp = [2550, 3250];
Cnnt.L35.Vbar4.HspTol = 0.5;
Cnnt.L35.Vbar4.HspInt = 4;
Cnnt.L35.Vbar4.SDir = 90;

%Line36 - Vbar5 (at UMBVB13) four edge
Cnnt.L36.SN = 'ABS_E_Air';
Cnnt.L36.group = 'other';
Cnnt.L36.axis1 = 'x';
Cnnt.L36.axis2 = 'z';

Cnnt.L36.Vbar5.thk = Thk.Col1.VBaratTruss;
Cnnt.L36.Vbar5.axisTT = 'y';
Cnnt.L36.Vbar5.int = 1;

Cnnt.L36.Vbar5.HspAxis = 'x';
Cnnt.L36.Vbar5.Hsp = [2550, 3250];
Cnnt.L36.Vbar5.HspTol = 0.5;
Cnnt.L36.Vbar5.HspInt = 4;
Cnnt.L36.Vbar5.SDir = 90;

%Line37 - Vbar6 (at UMBVB13) four edge
Cnnt.L37.SN = 'ABS_E_Air';
Cnnt.L37.group = 'other';
Cnnt.L37.axis1 = 'x';
Cnnt.L37.axis2 = 'z';

Cnnt.L37.Vbar6.thk = Thk.Col1.VBaratTruss;
Cnnt.L37.Vbar6.axisTT = 'y';
Cnnt.L37.Vbar6.int = 1;

Cnnt.L37.Vbar6.HspAxis = 'x';
Cnnt.L37.Vbar6.Hsp = [2550, 3250];
Cnnt.L37.Vbar6.HspTol = 0.5;
Cnnt.L37.Vbar6.HspInt = 4;
Cnnt.L37.Vbar6.SDir = 90;

%Line38 - Ring1 inner edges and connection with Vbars
Cnnt.L38.SN = 'ABS_E_Air';
Cnnt.L38.group = 'other';
Cnnt.L38.axis1 = 'x';
Cnnt.L38.axis2 = 'y';

Cnnt.L38.Ring1.thk = Thk.Col1.RingatUMB;
Cnnt.L38.Ring1.axisTT = 'z';
Cnnt.L38.Ring1.int = 2;

Cnnt.L38.Ring1.HspAxis = 'y';
Cnnt.L38.Ring1.Hsp = [-156, -144, -120, 120, 144, 156];
% Cnnt.L38.Ring1.HspSN = 'ABS_E_Air';
Cnnt.L38.Ring1.HspTol = 0.5;
Cnnt.L38.Ring1.HspInt = 1;
Cnnt.L38.Ring1.SDir = 90;

%Line39 - Ring2 inner edges and connection with Vbars
Cnnt.L39.SN = 'ABS_E_Air';
Cnnt.L39.group = 'other';
Cnnt.L39.axis1 = 'x';
Cnnt.L39.axis2 = 'y';

Cnnt.L39.Ring2.thk = Thk.Col1.RingatUMB;
Cnnt.L39.Ring2.axisTT = 'z';
Cnnt.L39.Ring2.int = 2;

Cnnt.L39.Ring2.HspAxis = 'y';
Cnnt.L39.Ring2.Hsp = [-156, -144, -120, 120, 144, 156];
% Cnnt.L39.Ring2.HspSN = 'ABS_E_Air';
Cnnt.L39.Ring2.HspTol = 0.5;
Cnnt.L39.Ring2.HspInt = 1;
Cnnt.L39.Ring2.SDir = 90;

%Line40 - Ring3 inner edges and connection with Vbars
Cnnt.L40.SN = 'ABS_E_Air';
Cnnt.L40.group = 'other';
Cnnt.L40.axis1 = 'x';
Cnnt.L40.axis2 = 'y';

Cnnt.L40.Ring3.thk = Thk.Col1.RingatVB;
Cnnt.L40.Ring3.axisTT = 'z';
Cnnt.L40.Ring3.int = 2;

Cnnt.L40.Ring3.HspAxis = 'y';
Cnnt.L40.Ring3.Hsp = [-156, -144, -120, 120, 144, 156];
% Cnnt.L40.Ring3.HspSN = 'ABS_E_Air';
Cnnt.L40.Ring3.HspTol = 0.5;
Cnnt.L40.Ring3.HspInt = 1;
Cnnt.L40.Ring3.SDir = 90;

%Line41 - Ring4 inner edges and connection with Vbars
Cnnt.L41.SN = 'ABS_E_Air';
Cnnt.L41.group = 'other';
Cnnt.L41.axis1 = 'x';
Cnnt.L41.axis2 = 'y';

Cnnt.L41.Ring4.thk = Thk.Col1.RingatVB;
Cnnt.L41.Ring4.axisTT = 'z';
Cnnt.L41.Ring4.int = 2;

Cnnt.L41.Ring4.HspAxis = 'y';
Cnnt.L41.Ring4.Hsp = [-156, -144, -120, 120, 144, 156];
% Cnnt.L41.Ring4.HspSN = 'ABS_E_Air';
Cnnt.L41.Ring4.HspTol = 0.5;
Cnnt.L41.Ring4.HspInt = 1;
Cnnt.L41.Ring4.SDir = 90;

%Line42 - TBBrkt1 (at Bkh1)
Cnnt.L42.SN = 'ABS_C_Air';
Cnnt.L42.group = 'other';
Cnnt.L42.axis1 = 'x';
Cnnt.L42.axis2 = 'z';

Cnnt.L42.TBBrkt1.thk = Thk.Col1.Brkt_TBatBkh;
Cnnt.L42.TBBrkt1.axisTT = 'y';
Cnnt.L42.TBBrkt1.int = 1;

Cnnt.L42.TBBrkt1.HspAxis = 'x';
Cnnt.L42.TBBrkt1.Hsp = 3250;
Cnnt.L42.TBBrkt1.HspAxis2 = 'z';
Cnnt.L42.TBBrkt1.Hsp2 = 13000;

Cnnt.L42.TBBrkt1.HspSN = 'ABS_E_Air';
Cnnt.L42.TBBrkt1.HspTol = 15;
Cnnt.L42.TBBrkt1.HspInt = 1;
Cnnt.L42.TBBrkt1.SDir = 130;

%Line43 - TBBrkt1 (at FB1)
Cnnt.L43.SN = 'ABS_C_Air';
Cnnt.L43.group = 'other';
Cnnt.L43.axis1 = 'x';
Cnnt.L43.axis2 = 'z';

Cnnt.L43.TBBrkt2.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L43.TBBrkt2.axisTT = 'y';
Cnnt.L43.TBBrkt2.int = 1;

Cnnt.L43.TBBrkt2.HspAxis = 'x';
Cnnt.L43.TBBrkt2.Hsp = 3250;
Cnnt.L43.TBBrkt2.HspAxis2 = 'z';
Cnnt.L43.TBBrkt2.Hsp2 = 13000;

Cnnt.L43.TBBrkt2.HspSN = 'ABS_E_Air';
Cnnt.L43.TBBrkt2.HspTol = 15;
Cnnt.L43.TBBrkt2.HspInt = 3;
Cnnt.L43.TBBrkt2.SDir = 130;

%Line42 - TBBrkt1 (at OS*FB1)
Cnnt.L44.SN = 'ABS_C_Air';
Cnnt.L44.group = 'other';
Cnnt.L44.axis1 = 'x';
Cnnt.L44.axis2 = 'z';

Cnnt.L44.TBBrkt3.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L44.TBBrkt3.axisTT = 'y';
Cnnt.L44.TBBrkt3.int = 1;

Cnnt.L44.TBBrkt3.HspAxis = 'x';
Cnnt.L44.TBBrkt3.Hsp = 6000;
Cnnt.L44.TBBrkt3.HspAxis2 = 'z';
Cnnt.L44.TBBrkt3.Hsp2 = 12500;

Cnnt.L44.TBBrkt3.HspSN = 'ABS_E_Air';
Cnnt.L44.TBBrkt3.HspTol = 15;
Cnnt.L44.TBBrkt3.HspInt = 1;
Cnnt.L44.TBBrkt3.SDir = 150;

%Line45 - TBBrkt4 (at Bkh2)
Cnnt.L45.SN = 'ABS_C_Air';
Cnnt.L45.group = 'other';
Cnnt.L45.axis1 = 'x';
Cnnt.L45.axis2 = 'z';

Cnnt.L45.TBBrkt4.thk = Thk.Col1.Brkt_TBatBkh;
Cnnt.L45.TBBrkt4.axisTT = 'y';
Cnnt.L45.TBBrkt4.int = 1;

Cnnt.L45.TBBrkt4.HspAxis = 'x';
Cnnt.L45.TBBrkt4.Hsp = 3250;
Cnnt.L45.TBBrkt4.HspAxis2 = 'z';
Cnnt.L45.TBBrkt4.Hsp2 = 13000;

Cnnt.L45.TBBrkt4.HspSN = 'ABS_E_Air';
Cnnt.L45.TBBrkt4.HspTol = 15;
Cnnt.L45.TBBrkt4.HspInt = 1;
Cnnt.L45.TBBrkt4.SDir = 130;

%Line46 - TBBrkt5 (at FB2)
Cnnt.L46.SN = 'ABS_C_Air';
Cnnt.L46.group = 'other';
Cnnt.L46.axis1 = 'x';
Cnnt.L46.axis2 = 'z';

Cnnt.L46.TBBrkt5.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L46.TBBrkt5.axisTT = 'y';
Cnnt.L46.TBBrkt5.int = 1;

Cnnt.L46.TBBrkt5.HspAxis = 'x';
Cnnt.L46.TBBrkt5.Hsp = 3250;
Cnnt.L46.TBBrkt5.HspAxis2 = 'z';
Cnnt.L46.TBBrkt5.Hsp2 = 13000;

Cnnt.L46.TBBrkt5.HspSN = 'ABS_E_Air';
Cnnt.L46.TBBrkt5.HspTol = 15;
Cnnt.L46.TBBrkt5.HspInt = 1;
Cnnt.L46.TBBrkt5.SDir = 130;

%Line47 - TBBrkt6 (at OS*FB2)
Cnnt.L47.SN = 'ABS_C_Air';
Cnnt.L47.group = 'other';
Cnnt.L47.axis1 = 'x';
Cnnt.L47.axis2 = 'z';

Cnnt.L47.TBBrkt6.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L47.TBBrkt6.axisTT = 'y';
Cnnt.L47.TBBrkt6.int = 1;

Cnnt.L47.TBBrkt6.HspAxis = 'x';
Cnnt.L47.TBBrkt6.Hsp = 6000;
Cnnt.L47.TBBrkt6.HspAxis2 = 'z';
Cnnt.L47.TBBrkt6.Hsp2 = 12500;

Cnnt.L47.TBBrkt6.HspSN = 'ABS_E_Air';
Cnnt.L47.TBBrkt6.HspTol = 15;
Cnnt.L47.TBBrkt6.HspInt = 1;
Cnnt.L47.TBBrkt6.SDir = 150;

%L48 - TOC ring * Vbars
Cnnt.L48.SN = 'ABS_E_Air';
Cnnt.L48.group = 'rad';
Cnnt.L48.axis_c = 'y';
Cnnt.L48.axis_r = 'x';

Cnnt.L48.TOCring.thk = Thk.Col1.TOCring;
Cnnt.L48.TOCring.axisTT = 'z';
Cnnt.L48.TOCring.int = 1;
Cnnt.L48.TOCring.HspAxis = 'x';
Cnnt.L48.TOCring.Hsp = 2550;
Cnnt.L48.TOCring.HspTol = 0.5;
Cnnt.L48.TOCring.SDir = 90;

OutName = [path1 'CnntInfo.mat'];
save(OutName, 'Cnnt')

%% Itr12_9 (Col3_Top)
ItrNo = 'ItrR5_12_9';
path1 = [path0 ItrNo '\'];
load([path1 'thickness.mat']);

Cnnt.Itr = ItrNo;

%Line301 - IS*UMB31
Cnnt.L301.SN = 'API_WJ_Air';
Cnnt.L301.group = 'circ';
Cnnt.L301.axis = 'y';

Cnnt.L301.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L301.IS.int = 3;
Cnnt.L301.IS.axisTT = 'x';
Cnnt.L301.IS.Hsp = [-154.27, -134.4 ,-45.546, -25.729, 0, 25.729, 45.546, 134.4, 154.27]; %deg
Cnnt.L301.IS.HspTol = 0.5; %Tolerance in hot spot sampling
Cnnt.L301.IS.SDir = 90;

Cnnt.L301.UMB31.thk = Thk.Col2.UMB21;
Cnnt.L301.UMB31.int = 3;
Cnnt.L301.UMB31.axisTT = 'x';
Cnnt.L301.UMB31.Hsp = [-154.27, -134.4 ,-45.546, -25.729, 25.729, 45.546, 134.4, 154.27]; %deg
Cnnt.L301.UMB31.HspTol = 0.5; 
Cnnt.L301.UMB31.SDir = 90;

%Line302 - IS*VB31
Cnnt.L302.SN = 'API_WJ_Air';
Cnnt.L302.group = 'circ';
Cnnt.L302.axis = 'y';

Cnnt.L302.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L302.IS.int = 3;
Cnnt.L302.IS.axisTT = 'x';
Cnnt.L302.IS.Hsp = [-167.56, -79.931, -70.041, -7.2496, 2.6408, 90.27, 109.96, 172.75]; %deg
Cnnt.L302.IS.HspTol = 0.5; %Tolerance in hot spot sampling
Cnnt.L302.IS.SDir = 90;

Cnnt.L302.VB31.thk = Thk.Col2.VB21;
Cnnt.L302.VB31.int = 3;
Cnnt.L302.VB31.axisTT = 'x';
Cnnt.L302.VB31.Hsp = [-167.56, -79.931, -70.041, -7.2496, 2.6408, 90.27, 109.96, 172.75]; %deg
Cnnt.L302.VB31.HspTol = 0.5; 
Cnnt.L302.VB31.SDir = 90;

%Line303 - OS*UMB31
Cnnt.L303.SN = 'API_WJ_Air';
Cnnt.L303.group = 'circ';
Cnnt.L303.axis = 'y';

Cnnt.L303.OS.thk = Thk.Col2.OSatTruss21;
Cnnt.L303.OS.axisTT = 'x';
Cnnt.L303.OS.int = 3;
Cnnt.L303.OS.SDir = 0;

Cnnt.L303.UMB31.thk = Thk.Col2.UMB21;
Cnnt.L303.UMB31.axisTT = 'x';
Cnnt.L303.UMB31.int = 3;
Cnnt.L303.UMB31.SDir = 90;

%Line304 - OS*VB31
Cnnt.L304.SN = 'API_WJ_Air';
Cnnt.L304.group = 'circ';
Cnnt.L304.axis = 'y';

Cnnt.L304.OS.thk = Thk.Col2.OSatTruss21;
Cnnt.L304.OS.axisTT = 'x';
Cnnt.L304.OS.int = 3;
Cnnt.L304.OS.Hsp = -40; %deg
Cnnt.L304.OS.HspTol = 10; %Tolerance in hot spot sampling
Cnnt.L304.OS.SDir = 90;

Cnnt.L304.VB31.thk = Thk.Col2.VB21;
Cnnt.L304.VB31.axisTT = 'x';
Cnnt.L304.VB31.int = 3;
Cnnt.L304.VB31.SDir = 90;

%Line305 - IS * Ring1
Cnnt.L305.SN = 'ABS_E_Air';
Cnnt.L305.group = 'circ';
Cnnt.L305.axis = 'y';

Cnnt.L305.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L305.IS.axisTT = 'x';
Cnnt.L305.IS.int = 3;
Cnnt.L305.IS.Hsp = [ 46.606, 40, 20, 13.394, 0]; %deg
Cnnt.L305.IS.HspTol = 0.5;

Cnnt.L305.Ring1.thk = Thk.Col2.RingTop;
Cnnt.L305.Ring1.axisTT = 'z';
Cnnt.L305.Ring1.int = 3;
Cnnt.L305.Ring1.Hsp = [ 46.606, 40, 20, 13.394, 0]; %deg
Cnnt.L305.Ring1.HspTol = 0.5; 

%Line306 - IS * Ring2
Cnnt.L306.SN = 'ABS_E_Air';
Cnnt.L306.group = 'circ';
Cnnt.L306.axis = 'y';

Cnnt.L306.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L306.IS.axisTT = 'x';
Cnnt.L306.IS.int = 3;
Cnnt.L306.IS.Hsp = [ 46.59, 40, 20, 13.41, 0]; %deg
Cnnt.L306.IS.HspTol = 0.5;

Cnnt.L306.Ring2.thk = Thk.Col2.RingTop;
Cnnt.L306.Ring2.axisTT = 'z';
Cnnt.L306.Ring2.int = 3;
Cnnt.L306.Ring2.Hsp = [ 46.59, 40, 20, 13.41, 0]; %deg
Cnnt.L306.Ring2.HspTol = 0.5;

%Line307 - IS * Ring3
Cnnt.L307.SN = 'ABS_E_Air';
Cnnt.L307.group = 'circ';
Cnnt.L307.axis = 'y';

Cnnt.L307.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L307.IS.axisTT = 'x';
Cnnt.L307.IS.int = 3;
Cnnt.L307.IS.Hsp = [ 45.032, 40, 20, 14.968, 0]; %deg
Cnnt.L307.IS.HspTol = 0.5;

Cnnt.L307.Ring3.thk = Thk.Col2.RingTop;
Cnnt.L307.Ring3.axisTT = 'z';
Cnnt.L307.Ring3.int = 3;
Cnnt.L307.Ring3.Hsp = [ 45.032, 40, 20, 14.968, 0]; %deg
Cnnt.L307.Ring3.HspTol = 0.5;

%Line308 - IS * Ring4
Cnnt.L308.SN = 'ABS_E_Air';
Cnnt.L308.group = 'circ';
Cnnt.L308.axis = 'y';

Cnnt.L308.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L308.IS.axisTT = 'x';
Cnnt.L308.IS.int = 3;
Cnnt.L308.IS.Hsp = [ 42.705, 40, 20, 17.295, 0]; %deg
Cnnt.L308.IS.HspTol = 0.5;
Cnnt.L308.IS.SDir = [30 150];

Cnnt.L308.Ring4.thk = Thk.Col2.RingTop;
Cnnt.L308.Ring4.axisTT = 'z';
Cnnt.L308.Ring4.int = 3;
Cnnt.L308.Ring4.Hsp = [ 42.705, 40, 20, 17.295, 0]; %deg
Cnnt.L308.Ring4.HspTol = 0.5;
Cnnt.L308.Ring4.SDir = [30 150];

%Line309 - IS * Vbar1
Cnnt.L309.SN = 'ABS_E_Air';
Cnnt.L309.group = 'circ';
Cnnt.L309.axis = 'z';

Cnnt.L309.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L309.IS.axisTT = 'x';
Cnnt.L309.IS.int = 3;
Cnnt.L309.IS.Hsp = [589.23, 770.3, 2030.3, 2210.8, 2666.9, 2861.3, 4328, 4455.4]; %mm
Cnnt.L309.IS.HspTol = 30;

Cnnt.L309.Vbar1.thk = Thk.Col2.VbarTop;
Cnnt.L309.Vbar1.axisTT = 'x';
Cnnt.L309.Vbar1.int = 3;
Cnnt.L309.Vbar1.Hsp = [589.23, 770.3, 2030.3, 2210.8, 2666.9, 2861.3, 4328, 4455.4]; %mm
Cnnt.L309.Vbar1.HspTol = 30;
Cnnt.L309.Vbar1.SDir = 0;

%Line310 - IS * Vbar2
Cnnt.L310.SN = 'ABS_E_Air';
Cnnt.L310.group = 'circ';
Cnnt.L310.axis = 'z';

Cnnt.L310.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L310.IS.axisTT = 'x';
Cnnt.L310.IS.int = 3;
Cnnt.L310.IS.Hsp = [589.23, 770.3, 2030.3, 2210.8, 2666.9, 2861.3, 4328, 4455.4]; %mm
Cnnt.L310.IS.HspTol = 30;

Cnnt.L310.Vbar2.thk = Thk.Col2.VbarTop;
Cnnt.L310.Vbar2.axisTT = 'x';
Cnnt.L310.Vbar2.int = 3;
Cnnt.L310.Vbar2.Hsp = [589.23, 770.3, 2030.3, 2210.8, 2666.9, 2861.3, 4328, 4455.4]; %mm
Cnnt.L310.Vbar2.HspTol = 30;
Cnnt.L310.Vbar2.SDir = 0;

%Line311 - Ring1 edges
Cnnt.L311.SN = 'ABS_E_Air';
Cnnt.L311.group = 'other';
Cnnt.L311.axis1 = 'x';
Cnnt.L311.axis2 = 'y';

Cnnt.L311.Ring1.thk = Thk.Col2.RingTop;
Cnnt.L311.Ring1.axisTT = 'z';
Cnnt.L311.Ring1.int = 1;

Cnnt.L311.Ring1.HspAxis = 'x';
Cnnt.L311.Ring1.HspSN = 'ABS_C_Air';
Cnnt.L311.Ring1.Hsp = 1750;
Cnnt.L311.Ring1.HspTol = 30;
Cnnt.L311.Ring1.HspInt = 3;
Cnnt.L311.Ring1.SDir = 90;

%Line312 - Ring2 edges
Cnnt.L312.SN = 'ABS_E_Air';
Cnnt.L312.group = 'other';
Cnnt.L312.axis1 = 'x';
Cnnt.L312.axis2 = 'y';

Cnnt.L312.Ring2.thk = Thk.Col2.RingTop;
Cnnt.L312.Ring2.axisTT = 'z';
Cnnt.L312.Ring2.int = 1;

Cnnt.L312.Ring2.HspSN = 'ABS_C_Air';
Cnnt.L312.Ring2.HspAxis = 'x';
Cnnt.L312.Ring2.Hsp = 1750;
Cnnt.L312.Ring2.HspTol = 30;
Cnnt.L312.Ring2.HspInt = 3;
Cnnt.L312.Ring2.SDir = 90;

%Line313 - Ring3 edges
Cnnt.L313.SN = 'ABS_E_Air';
Cnnt.L313.group = 'other';
Cnnt.L313.axis1 = 'x';
Cnnt.L313.axis2 = 'y';

Cnnt.L313.Ring3.thk = Thk.Col2.RingTop;
Cnnt.L313.Ring3.axisTT = 'z';
Cnnt.L313.Ring3.int = 1;

Cnnt.L313.Ring3.HspSN = 'ABS_C_Air';
Cnnt.L313.Ring3.HspAxis = 'x';
Cnnt.L313.Ring3.Hsp = 1750;
Cnnt.L313.Ring3.HspTol = 30;
Cnnt.L313.Ring3.HspInt = 3;
Cnnt.L313.Ring3.SDir = 90;

%Line314 - Ring4 edges
Cnnt.L314.SN = 'ABS_E_Air';
Cnnt.L314.group = 'other';
Cnnt.L314.axis1 = 'x';
Cnnt.L314.axis2 = 'y';

Cnnt.L314.Ring4.thk = Thk.Col2.RingTop;
Cnnt.L314.Ring4.axisTT = 'z';
Cnnt.L314.Ring4.int = 1;

Cnnt.L314.Ring4.HspAxis = 'x';
Cnnt.L314.Ring4.HspSN = 'ABS_C_Air';
Cnnt.L314.Ring4.Hsp = 1750;
Cnnt.L314.Ring4.HspTol = 30;
Cnnt.L314.Ring4.HspInt = 3;
Cnnt.L314.Ring4.SDir = 90;

%Line315 - Vbar1 edges
Cnnt.L315.SN = 'ABS_E_Air';
Cnnt.L315.group = 'other';
Cnnt.L315.axis1 = 'y';
Cnnt.L315.axis2 = 'z';

Cnnt.L315.Vbar1.thk = Thk.Col2.VbarTop;
Cnnt.L315.Vbar1.axisTT = 'x';
Cnnt.L315.Vbar1.int = 1;

Cnnt.L315.Vbar1.HspAxis = 'z';
Cnnt.L315.Vbar1.Hsp = [770.3, 2030.3, 2861.3, 4328];
Cnnt.L315.Vbar1.HspTol = 30;
Cnnt.L315.Vbar1.HspInt = 1;
Cnnt.L315.Vbar1.SDir = 90;

%Line316 - Vbar2 edges
Cnnt.L316.SN = 'ABS_E_Air';
Cnnt.L316.group = 'other';
Cnnt.L316.axis1 = 'y';
Cnnt.L316.axis2 = 'z';

Cnnt.L316.Vbar2.thk = Thk.Col2.VbarTop;
Cnnt.L316.Vbar2.axisTT = 'x';
Cnnt.L316.Vbar2.int = 1;

Cnnt.L316.Vbar2.HspAxis = 'z';
Cnnt.L316.Vbar2.Hsp = [770.3, 2030.3, 2861.3, 4328];
Cnnt.L316.Vbar2.HspTol = 30;
Cnnt.L316.Vbar2.HspInt = 1;
Cnnt.L316.Vbar2.SDir = 90;

%Line317 - Bkh1 edges
Cnnt.L317.SN = 'ABS_E_Air';
Cnnt.L317.group = 'circ';
Cnnt.L317.axis = 'z';

Cnnt.L317.Bkh1.thk = Thk.Col2.Bkh;
Cnnt.L317.Bkh1.axisTT = 'x';
Cnnt.L317.Bkh1.int = 3;
Cnnt.L317.Bkh1.Hsp = [0, -770.3, -1500, -2030.3, -2861.3, -2900, -4200, -4328, -5200]; %mm
Cnnt.L317.Bkh1.HspTol = 30;
Cnnt.L317.Bkh1.SDir = 0;

OutName = [path1 'CnntInfo.mat'];
save(OutName, 'Cnnt')
%% Itr12_11 (Col3_Top)
ItrNo = 'ItrR5_12_11';
path1 = [path0 ItrNo '\'];
load([path1 'thickness.mat']);

Cnnt.Itr = ItrNo;

%Line301 - IS*UMB31
Cnnt.L301.SN = 'API_WJ_Air';
Cnnt.L301.group = 'circ';
Cnnt.L301.axis = 'y';

Cnnt.L301.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L301.IS.int = 3;
Cnnt.L301.IS.axisTT = 'x';
Cnnt.L301.IS.Hsp = [-154.27, -134.4 ,-45.546, -25.729, 0, 25.729, 45.546, 134.4, 154.27]; %deg
Cnnt.L301.IS.HspTol = 0.5; %Tolerance in hot spot sampling
Cnnt.L301.IS.SDir = 90;

Cnnt.L301.UMB31.thk = Thk.Col2.UMB21;
Cnnt.L301.UMB31.int = 3;
Cnnt.L301.UMB31.axisTT = 'x';
Cnnt.L301.UMB31.Hsp = [-154.27, -134.4 ,-45.546, -25.729, 25.729, 45.546, 134.4, 154.27]; %deg
Cnnt.L301.UMB31.HspTol = 0.5; 
Cnnt.L301.UMB31.SDir = 90;

%Line302 - IS*VB31
Cnnt.L302.SN = 'API_WJ_Air';
Cnnt.L302.group = 'circ';
Cnnt.L302.axis = 'y';

Cnnt.L302.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L302.IS.int = 3;
Cnnt.L302.IS.axisTT = 'x';
Cnnt.L302.IS.Hsp = [-167.56, -79.931, -70.041, -7.2496, 2.6408, 90.27, 109.96, 172.75]; %deg
Cnnt.L302.IS.HspTol = 0.5; %Tolerance in hot spot sampling
Cnnt.L302.IS.SDir = 90;

Cnnt.L302.VB31.thk = Thk.Col2.VB21;
Cnnt.L302.VB31.int = 3;
Cnnt.L302.VB31.axisTT = 'x';
Cnnt.L302.VB31.Hsp = [-167.56, -79.931, -70.041, -7.2496, 2.6408, 90.27, 109.96, 172.75]; %deg
Cnnt.L302.VB31.HspTol = 0.5; 
Cnnt.L302.VB31.SDir = 90;

%Line303 - OS*UMB31
Cnnt.L303.SN = 'API_WJ_Air';
Cnnt.L303.group = 'circ';
Cnnt.L303.axis = 'y';

Cnnt.L303.OS.thk = Thk.Col2.OSatTruss21;
Cnnt.L303.OS.axisTT = 'x';
Cnnt.L303.OS.int = 3;
Cnnt.L303.OS.SDir = 0;

Cnnt.L303.UMB31.thk = Thk.Col2.UMB21;
Cnnt.L303.UMB31.axisTT = 'x';
Cnnt.L303.UMB31.int = 3;
Cnnt.L303.UMB31.SDir = 90;

%Line304 - OS*VB31
Cnnt.L304.SN = 'API_WJ_Air';
Cnnt.L304.group = 'circ';
Cnnt.L304.axis = 'y';

Cnnt.L304.OS.thk = Thk.Col2.OSatTruss21;
Cnnt.L304.OS.axisTT = 'x';
Cnnt.L304.OS.int = 3;
Cnnt.L304.OS.Hsp = -40; %deg
Cnnt.L304.OS.HspTol = 10; %Tolerance in hot spot sampling
Cnnt.L304.OS.SDir = 90;

Cnnt.L304.VB31.thk = Thk.Col2.VB21;
Cnnt.L304.VB31.axisTT = 'x';
Cnnt.L304.VB31.int = 3;
Cnnt.L304.VB31.SDir = 90;

%Line305 - IS * Ring1
Cnnt.L305.SN = 'ABS_E_Air';
Cnnt.L305.group = 'circ';
Cnnt.L305.axis = 'y';

Cnnt.L305.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L305.IS.axisTT = 'x';
Cnnt.L305.IS.int = 3;
Cnnt.L305.IS.Hsp = [ 46.606, 40, 20, 13.394, 0]; %deg
Cnnt.L305.IS.HspTol = 0.5;

Cnnt.L305.Ring1.thk = Thk.Col2.RingTop;
Cnnt.L305.Ring1.axisTT = 'z';
Cnnt.L305.Ring1.int = 3;
Cnnt.L305.Ring1.Hsp = [ 46.606, 40, 20, 13.394, 0]; %deg
Cnnt.L305.Ring1.HspTol = 0.5; 

%Line306 - IS * Ring2
Cnnt.L306.SN = 'ABS_E_Air';
Cnnt.L306.group = 'circ';
Cnnt.L306.axis = 'y';

Cnnt.L306.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L306.IS.axisTT = 'x';
Cnnt.L306.IS.int = 3;
Cnnt.L306.IS.Hsp = [ 46.59, 40, 20, 13.41, 0]; %deg
Cnnt.L306.IS.HspTol = 0.5;

Cnnt.L306.Ring2.thk = Thk.Col2.RingTop;
Cnnt.L306.Ring2.axisTT = 'z';
Cnnt.L306.Ring2.int = 3;
Cnnt.L306.Ring2.Hsp = [ 46.59, 40, 20, 13.41, 0]; %deg
Cnnt.L306.Ring2.HspTol = 0.5;

%Line307 - IS * Ring3
Cnnt.L307.SN = 'ABS_E_Air';
Cnnt.L307.group = 'circ';
Cnnt.L307.axis = 'y';

Cnnt.L307.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L307.IS.axisTT = 'x';
Cnnt.L307.IS.int = 3;
Cnnt.L307.IS.Hsp = [ 45.032, 40, 20, 14.968, 0]; %deg
Cnnt.L307.IS.HspTol = 0.5;

Cnnt.L307.Ring3.thk = Thk.Col2.RingTop;
Cnnt.L307.Ring3.axisTT = 'z';
Cnnt.L307.Ring3.int = 3;
Cnnt.L307.Ring3.Hsp = [ 45.032, 40, 20, 14.968, 0]; %deg
Cnnt.L307.Ring3.HspTol = 0.5;

%Line308 - IS * Ring4
Cnnt.L308.SN = 'ABS_E_Air';
Cnnt.L308.group = 'circ';
Cnnt.L308.axis = 'y';

Cnnt.L308.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L308.IS.axisTT = 'x';
Cnnt.L308.IS.int = 3;
Cnnt.L308.IS.Hsp = [ 42.705, 40, 20, 17.295, 0]; %deg
Cnnt.L308.IS.HspTol = 0.5;
Cnnt.L308.IS.SDir = [30 150];

Cnnt.L308.Ring4.thk = Thk.Col2.RingTop;
Cnnt.L308.Ring4.axisTT = 'z';
Cnnt.L308.Ring4.int = 3;
Cnnt.L308.Ring4.Hsp = [ 42.705, 40, 20, 17.295, 0]; %deg
Cnnt.L308.Ring4.HspTol = 0.5;
Cnnt.L308.Ring4.SDir = [30 150];

%Line309 - IS * Vbar1
Cnnt.L309.SN = 'ABS_E_Air';
Cnnt.L309.group = 'circ';
Cnnt.L309.axis = 'z';

Cnnt.L309.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L309.IS.axisTT = 'x';
Cnnt.L309.IS.int = 3;
Cnnt.L309.IS.Hsp = [589.23, 770.3, 2030.3, 2210.8, 2666.9, 2861.3, 4328, 4455.4]; %mm
Cnnt.L309.IS.HspTol = 30;

Cnnt.L309.Vbar1.thk = Thk.Col2.VbarTop;
Cnnt.L309.Vbar1.axisTT = 'x';
Cnnt.L309.Vbar1.int = 3;
Cnnt.L309.Vbar1.Hsp = [589.23, 770.3, 2030.3, 2210.8, 2666.9, 2861.3, 4328, 4455.4]; %mm
Cnnt.L309.Vbar1.HspTol = 30;
Cnnt.L309.Vbar1.SDir = 170;

%Line310 - IS * Vbar2
Cnnt.L310.SN = 'ABS_E_Air';
Cnnt.L310.group = 'circ';
Cnnt.L310.axis = 'z';

Cnnt.L310.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L310.IS.axisTT = 'x';
Cnnt.L310.IS.int = 3;
Cnnt.L310.IS.Hsp = [589.23, 770.3, 2030.3, 2210.8, 2666.9, 2861.3, 4328, 4455.4]; %mm
Cnnt.L310.IS.HspTol = 30;

Cnnt.L310.Vbar2.thk = Thk.Col2.VbarTop;
Cnnt.L310.Vbar2.axisTT = 'x';
Cnnt.L310.Vbar2.int = 3;
Cnnt.L310.Vbar2.Hsp = [589.23, 770.3, 2030.3, 2210.8, 2666.9, 2861.3, 4328, 4455.4]; %mm
Cnnt.L310.Vbar2.HspTol = 30;
Cnnt.L310.Vbar2.SDir = 170;

%Line311 - Ring1 edges
Cnnt.L311.SN = 'ABS_E_Air';
Cnnt.L311.group = 'other';
Cnnt.L311.axis1 = 'x';
Cnnt.L311.axis2 = 'y';

Cnnt.L311.Ring1.thk = Thk.Col2.RingTop;
Cnnt.L311.Ring1.axisTT = 'z';
Cnnt.L311.Ring1.int = 1;

Cnnt.L311.Ring1.HspAxis = 'x';
Cnnt.L311.Ring1.HspSN = 'ABS_C_Air';
Cnnt.L311.Ring1.Hsp = 1750;
Cnnt.L311.Ring1.HspTol = 30;
Cnnt.L311.Ring1.HspInt = 3;
Cnnt.L311.Ring1.SDir = 90;

%Line312 - Ring2 edges
Cnnt.L312.SN = 'ABS_E_Air';
Cnnt.L312.group = 'other';
Cnnt.L312.axis1 = 'x';
Cnnt.L312.axis2 = 'y';

Cnnt.L312.Ring2.thk = Thk.Col2.RingTop;
Cnnt.L312.Ring2.axisTT = 'z';
Cnnt.L312.Ring2.int = 1;

Cnnt.L312.Ring2.HspSN = 'ABS_C_Air';
Cnnt.L312.Ring2.HspAxis = 'x';
Cnnt.L312.Ring2.Hsp = 1750;
Cnnt.L312.Ring2.HspTol = 30;
Cnnt.L312.Ring2.HspInt = 3;
Cnnt.L312.Ring2.SDir = 90;

%Line313 - Ring3 edges
Cnnt.L313.SN = 'ABS_E_Air';
Cnnt.L313.group = 'other';
Cnnt.L313.axis1 = 'x';
Cnnt.L313.axis2 = 'y';

Cnnt.L313.Ring3.thk = Thk.Col2.RingTop;
Cnnt.L313.Ring3.axisTT = 'z';
Cnnt.L313.Ring3.int = 1;

Cnnt.L313.Ring3.HspSN = 'ABS_C_Air';
Cnnt.L313.Ring3.HspAxis = 'x';
Cnnt.L313.Ring3.Hsp = 1750;
Cnnt.L313.Ring3.HspTol = 30;
Cnnt.L313.Ring3.HspInt = 3;
Cnnt.L313.Ring3.SDir = 90;

%Line314 - Ring4 edges
Cnnt.L314.SN = 'ABS_E_Air';
Cnnt.L314.group = 'other';
Cnnt.L314.axis1 = 'x';
Cnnt.L314.axis2 = 'y';

Cnnt.L314.Ring4.thk = Thk.Col2.RingTop;
Cnnt.L314.Ring4.axisTT = 'z';
Cnnt.L314.Ring4.int = 1;

Cnnt.L314.Ring4.HspAxis = 'x';
Cnnt.L314.Ring4.HspSN = 'ABS_C_Air';
Cnnt.L314.Ring4.Hsp = 1750;
Cnnt.L314.Ring4.HspTol = 30;
Cnnt.L314.Ring4.HspInt = 3;
Cnnt.L314.Ring4.SDir = 90;

%Line315 - Vbar1 edges
Cnnt.L315.SN = 'ABS_E_Air';
Cnnt.L315.group = 'other';
Cnnt.L315.axis1 = 'y';
Cnnt.L315.axis2 = 'z';

Cnnt.L315.Vbar1.thk = Thk.Col2.VbarTop;
Cnnt.L315.Vbar1.axisTT = 'x';
Cnnt.L315.Vbar1.int = 1;

Cnnt.L315.Vbar1.HspAxis = 'z';
Cnnt.L315.Vbar1.Hsp = [770.3, 2030.3, 2861.3, 4328];
Cnnt.L315.Vbar1.HspTol = 30;
Cnnt.L315.Vbar1.HspInt = 1;
Cnnt.L315.Vbar1.SDir = 90;

%Line316 - Vbar2 edges
Cnnt.L316.SN = 'ABS_E_Air';
Cnnt.L316.group = 'other';
Cnnt.L316.axis1 = 'y';
Cnnt.L316.axis2 = 'z';

Cnnt.L316.Vbar2.thk = Thk.Col2.VbarTop;
Cnnt.L316.Vbar2.axisTT = 'x';
Cnnt.L316.Vbar2.int = 1;

Cnnt.L316.Vbar2.HspAxis = 'z';
Cnnt.L316.Vbar2.Hsp = [770.3, 2030.3, 2861.3, 4328];
Cnnt.L316.Vbar2.HspTol = 30;
Cnnt.L316.Vbar2.HspInt = 1;
Cnnt.L316.Vbar2.SDir = 90;

%Line317 - Bkh1 edges
Cnnt.L317.SN = 'ABS_E_Air';
Cnnt.L317.group = 'circ';
Cnnt.L317.axis = 'z';

Cnnt.L317.Bkh1.thk = Thk.Col2.Bkh;
Cnnt.L317.Bkh1.axisTT = 'x';
Cnnt.L317.Bkh1.int = 3;
Cnnt.L317.Bkh1.Hsp = [0, -770.3, -1500, -2030.3, -2861.3, -2900, -4200, -4328, -5200]; %mm
Cnnt.L317.Bkh1.HspTol = 30;
Cnnt.L317.Bkh1.SDir = 170;

OutName = [path1 'CnntInfo.mat'];
save(OutName, 'Cnnt')

%% Itr12_10 (Col2_Top)
ItrNo = 'ItrR5_12_10';
path1 = [path0 ItrNo '\'];
load([path1 'thickness.mat']);

Cnnt.Itr = ItrNo;

%Line201 - IS*UMB21
Cnnt.L201.SN = 'API_WJ_Air';
Cnnt.L201.group = 'circ';
Cnnt.L201.axis = 'y';

Cnnt.L201.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L201.IS.int = 3;
Cnnt.L201.IS.axisTT = 'x';
Cnnt.L201.IS.Hsp = [-154.27, -134.4 ,-45.546, -25.729, 0, 25.729, 45.546, 134.4, 154.27]; %deg
Cnnt.L201.IS.HspTol = 1; %Tolerance in hot spot sampling

Cnnt.L201.UMB21.thk = Thk.Col2.UMB21;
Cnnt.L201.UMB21.int = 3;
Cnnt.L201.UMB21.axisTT = 'x';
Cnnt.L201.UMB21.Hsp = [-154.27, -134.4 ,-45.546, -25.729, 0, 25.729, 45.546, 134.4, 154.27]; %deg
Cnnt.L201.UMB21.HspTol = 1; 

%Line202 - IS*VB21
Cnnt.L202.SN = 'API_WJ_Air';
Cnnt.L202.group = 'circ';
Cnnt.L202.axis = 'y';

Cnnt.L202.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L202.IS.int = 3;
Cnnt.L202.IS.axisTT = 'x';
Cnnt.L202.IS.Hsp = [-180, -148.6, -128.91 ,-41.286, -31.396, 31.396, 41.286, 128.91, 148.6, 180]; %deg
Cnnt.L202.IS.HspTol = 1; %Tolerance in hot spot sampling

Cnnt.L202.VB21.thk = Thk.Col2.VB21;
Cnnt.L202.VB21.int = 3;
Cnnt.L202.VB21.axisTT = 'x';
Cnnt.L202.VB21.Hsp = [-180, -148.6, -128.91 ,-41.286, -31.396, 31.396, 41.286, 128.91, 148.6, 180]; %deg
Cnnt.L202.VB21.HspTol = 1; 

%Line203 - OS*UMB21
Cnnt.L203.SN = 'API_WJ_Air';
Cnnt.L203.group = 'circ';
Cnnt.L203.axis = 'y';

Cnnt.L203.OS.thk = Thk.Col2.OSatTruss21;
Cnnt.L203.OS.axisTT = 'x';
Cnnt.L203.OS.int = 3;

Cnnt.L203.UMB21.thk = Thk.Col2.UMB21;
Cnnt.L203.UMB21.axisTT = 'x';
Cnnt.L203.UMB21.int = 3;

%Line204 - OS*VB21
Cnnt.L204.SN = 'API_WJ_Air';
Cnnt.L204.group = 'circ';
Cnnt.L204.axis = 'y';

Cnnt.L204.OS.thk = Thk.Col2.OSatTruss21;
Cnnt.L204.OS.axisTT = 'x';
Cnnt.L204.OS.int = 3;

Cnnt.L204.VB21.thk = Thk.Col2.VB21;
Cnnt.L204.VB21.axisTT = 'x';
Cnnt.L204.VB21.int = 3;

%Line205 - IS * Ring1
Cnnt.L205.SN = 'ABS_E_Air';
Cnnt.L205.group = 'circ';
Cnnt.L205.axis = 'y';

Cnnt.L205.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L205.IS.axisTT = 'x';
Cnnt.L205.IS.int = 5;
Cnnt.L205.IS.Hsp = [ -46.606, -40, -20, -13.394, 0]; %deg
Cnnt.L205.IS.HspTol = 1;

Cnnt.L205.Ring1.thk = Thk.Col2.RingTop;
Cnnt.L205.Ring1.axisTT = 'z';
Cnnt.L205.Ring1.int = 5;
Cnnt.L205.Ring1.Hsp = [ -46.606, -40, -20, -13.394, 0]; %deg
Cnnt.L205.Ring1.HspTol = 1; 

%Line206 - IS * Ring2
Cnnt.L206.SN = 'ABS_E_Air';
Cnnt.L206.group = 'circ';
Cnnt.L206.axis = 'y';

Cnnt.L206.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L206.IS.axisTT = 'x';
Cnnt.L206.IS.int = 5;
Cnnt.L206.IS.Hsp = [ -46.59, -40, -20, -13.41, 0]; %deg
Cnnt.L206.IS.HspTol = 1;

Cnnt.L206.Ring2.thk = Thk.Col2.RingTop;
Cnnt.L206.Ring2.axisTT = 'z';
Cnnt.L206.Ring2.int = 5;
Cnnt.L206.Ring2.Hsp = [ -46.59, -40, -20, -13.41, 0]; %deg
Cnnt.L206.Ring2.HspTol = 1;

%Line207 - IS * Ring3
Cnnt.L207.SN = 'ABS_E_Air';
Cnnt.L207.group = 'circ';
Cnnt.L207.axis = 'y';

Cnnt.L207.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L207.IS.axisTT = 'x';
Cnnt.L207.IS.int = 5;
Cnnt.L207.IS.Hsp = [ -45.032, -40, -20, -14.968, 0]; %deg
Cnnt.L207.IS.HspTol = 1;

Cnnt.L207.Ring3.thk = Thk.Col2.RingTop;
Cnnt.L207.Ring3.axisTT = 'z';
Cnnt.L207.Ring3.int = 5;
Cnnt.L207.Ring3.Hsp = [ -45.032, -40, -20, -14.968, 0]; %deg
Cnnt.L207.Ring3.HspTol = 1;

%Line208 - IS * Ring4
Cnnt.L208.SN = 'ABS_E_Air';
Cnnt.L208.group = 'circ';
Cnnt.L208.axis = 'y';

Cnnt.L208.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L208.IS.axisTT = 'x';
Cnnt.L208.IS.int = 5;
Cnnt.L208.IS.Hsp = [ -42.705, -40, -20, -17.295, 0]; %deg
Cnnt.L208.IS.HspTol = 1;

Cnnt.L208.Ring4.thk = Thk.Col2.RingTop;
Cnnt.L208.Ring4.axisTT = 'z';
Cnnt.L208.Ring4.int = 5;
Cnnt.L208.Ring4.Hsp = [ -42.705, -40, -20, -17.295, 0]; %deg
Cnnt.L208.Ring4.HspTol = 1;

%Line209 - IS * Vbar1
Cnnt.L209.SN = 'ABS_E_Air';
Cnnt.L209.group = 'circ';
Cnnt.L209.axis = 'z';

Cnnt.L209.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L209.IS.axisTT = 'x';
Cnnt.L209.IS.int = 5;
Cnnt.L209.IS.Hsp = [589.23, 770.29, 2030.3, 2210.8, 2666.9, 2861.3, 4328, 4455.4]; %mm
Cnnt.L209.IS.HspTol = 30;

Cnnt.L209.Vbar1.thk = Thk.Col2.VbarTop;
Cnnt.L209.Vbar1.axisTT = 'x';
Cnnt.L209.Vbar1.int = 5;
Cnnt.L209.Vbar1.Hsp = [589.23, 770.29, 2030.3, 2210.8, 2666.9, 2861.3, 4328, 4455.4]; %mm
Cnnt.L209.Vbar1.HspTol = 30;

%Line210 - IS * Vbar2
Cnnt.L210.SN = 'ABS_E_Air';
Cnnt.L210.group = 'circ';
Cnnt.L210.axis = 'z';

Cnnt.L210.IS.thk = Thk.Col2.IStopfrnt;
Cnnt.L210.IS.axisTT = 'x';
Cnnt.L210.IS.int = 5;
Cnnt.L210.IS.Hsp = [589.23, 770.3, 2030.3, 2210.8, 2666.9, 2861.3, 4328, 4455.4]; %mm
Cnnt.L210.IS.HspTol = 30;

Cnnt.L210.Vbar2.thk = Thk.Col2.VbarTop;
Cnnt.L210.Vbar2.axisTT = 'x';
Cnnt.L210.Vbar2.int = 5;
Cnnt.L210.Vbar2.Hsp = [589.23, 770.3, 2030.3, 2210.8, 2666.9, 2861.3, 4328, 4455.4]; %mm
Cnnt.L210.Vbar2.HspTol = 30;

%Line211 - Ring1 edges
Cnnt.L211.SN = 'ABS_E_Air';
Cnnt.L211.group = 'other';
Cnnt.L211.axis1 = 'x';
Cnnt.L211.axis2 = 'y';

Cnnt.L211.Ring1.thk = Thk.Col2.RingTop;
Cnnt.L211.Ring1.axisTT = 'z';
Cnnt.L211.Ring1.int = 1;

Cnnt.L211.Ring1.HspAxis = 'x';
Cnnt.L211.Ring1.HspSN = 'ABS_C_Air';
Cnnt.L211.Ring1.Hsp = 1750;
Cnnt.L211.Ring1.HspTol = 30;
Cnnt.L211.Ring1.HspInt = 4;

%Line212 - Ring2 edges
Cnnt.L212.SN = 'ABS_E_Air';
Cnnt.L212.group = 'other';
Cnnt.L212.axis1 = 'x';
Cnnt.L212.axis2 = 'y';

Cnnt.L212.Ring2.thk = Thk.Col2.RingTop;
Cnnt.L212.Ring2.axisTT = 'z';
Cnnt.L212.Ring2.int = 1;

Cnnt.L212.Ring2.HspSN = 'ABS_C_Air';
Cnnt.L212.Ring2.HspAxis = 'x';
Cnnt.L212.Ring2.Hsp = 1750;
Cnnt.L212.Ring2.HspTol = 30;
Cnnt.L212.Ring2.HspInt = 4;

%Line213 - Ring3 edges
Cnnt.L213.SN = 'ABS_E_Air';
Cnnt.L213.group = 'other';
Cnnt.L213.axis1 = 'x';
Cnnt.L213.axis2 = 'y';

Cnnt.L213.Ring3.thk = Thk.Col2.RingTop;
Cnnt.L213.Ring3.axisTT = 'z';
Cnnt.L213.Ring3.int = 1;

Cnnt.L213.Ring3.HspSN = 'ABS_C_Air';
Cnnt.L213.Ring3.HspAxis = 'x';
Cnnt.L213.Ring3.Hsp = 1750;
Cnnt.L213.Ring3.HspTol = 30;
Cnnt.L213.Ring3.HspInt = 4;

%Line214 - Ring4 edges
Cnnt.L214.SN = 'ABS_E_Air';
Cnnt.L214.group = 'other';
Cnnt.L214.axis1 = 'x';
Cnnt.L214.axis2 = 'y';

Cnnt.L214.Ring4.thk = Thk.Col2.RingTop;
Cnnt.L214.Ring4.axisTT = 'z';
Cnnt.L214.Ring4.int = 1;

Cnnt.L214.Ring4.HspAxis = 'x';
Cnnt.L214.Ring4.HspSN = 'ABS_C_Air';
Cnnt.L214.Ring4.Hsp = 1750;
Cnnt.L214.Ring4.HspTol = 30;
Cnnt.L214.Ring4.HspInt = 4;

%Line215 - Vbar1 edges
Cnnt.L215.SN = 'ABS_C_Air';
Cnnt.L215.group = 'other';
Cnnt.L215.axis1 = 'y';
Cnnt.L215.axis2 = 'z';

Cnnt.L215.Vbar1.thk = Thk.Col2.VbarTop;
Cnnt.L215.Vbar1.axisTT = 'x';
Cnnt.L215.Vbar1.int = 1;

Cnnt.L215.Vbar1.HspSN = 'ABS_E_Air';
Cnnt.L215.Vbar1.HspAxis = 'z';
Cnnt.L215.Vbar1.Hsp = [0, 770.29, 2030.3, 2861.3, 4328];
Cnnt.L215.Vbar1.HspTol = 30;
Cnnt.L215.Vbar1.HspInt = 1;

%Line216 - Vbar2 edges
Cnnt.L216.SN = 'ABS_C_Air';
Cnnt.L216.group = 'other';
Cnnt.L216.axis1 = 'y';
Cnnt.L216.axis2 = 'z';

Cnnt.L216.Vbar2.thk = Thk.Col2.VbarTop;
Cnnt.L216.Vbar2.axisTT = 'x';
Cnnt.L216.Vbar2.int = 1;

Cnnt.L216.Vbar2.HspSN = 'ABS_E_Air';
Cnnt.L216.Vbar2.HspAxis = 'z';
Cnnt.L216.Vbar2.Hsp = [0, 770.3, 2030.3, 2861.3, 4328];
Cnnt.L216.Vbar2.HspTol = 30;
Cnnt.L216.Vbar2.HspInt = 1;

%Line217 - Bkh1 edges
Cnnt.L217.SN = 'ABS_E_Air';
Cnnt.L217.group = 'circ';
Cnnt.L217.axis = 'z';

Cnnt.L217.Bkh1.thk = Thk.Col2.Bkh;
Cnnt.L217.Bkh1.axisTT = 'x';
Cnnt.L217.Bkh1.int = 3;
Cnnt.L217.Bkh1.Hsp = [0, -770.3, -1500, -2030.3, -2861.3, -2900, -4200, -4328, -5200, -5800]; %mm
Cnnt.L217.Bkh1.HspTol = 30;

OutName = [path1 'CnntInfo.mat'];
save(OutName, 'Cnnt')
%% ItrR5_15_19 (Col1_Top)
ItrNo = 'ItrR5_15_19';
path1 = [path0 ItrNo '\'];
load([path1 'thickness.mat']);

Cnnt.Itr = ItrNo;

%Line1 - TB*IS*TF
Cnnt.L1.SN = 'ABS_E_Air';
Cnnt.L1.group = 'circ';
Cnnt.L1.axis = 'y';

Cnnt.L1.TB.thk = Thk.Col1.TB;
Cnnt.L1.TB.int = 2;
Cnnt.L1.TB.axisTT = 'x'; %through-thickness axis
Cnnt.L1.TB.SDir = 90; %degree

Cnnt.L1.TF.thk = Thk.Col1.TFin;
Cnnt.L1.TF.int = 10;
Cnnt.L1.TF.axisTT = 'z'; %through-thickness axis
Cnnt.L1.TF.HspAxis = 'y';
Cnnt.L1.TF.Hsp = -165:15:180;
Cnnt.L1.TF.HspTol = 0.5;

Cnnt.L1.TOCring.thk = Thk.Col1.TFin;
Cnnt.L1.TOCring.int = 10;
Cnnt.L1.TOCring.axisTT = 'z';

%Line2 - IS*UMB12
Cnnt.L2.SN = 'API_WJ_Air';
Cnnt.L2.group = 'circ';
Cnnt.L2.axis = 'y';

Cnnt.L2.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L2.IS.int = 2;
Cnnt.L2.IS.axisTT = 'x';
Cnnt.L2.IS.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L2.IS.HspTol = 0.5; %Tolerance in hot spot sampling
Cnnt.L2.IS.SDir = 90;

Cnnt.L2.UMB12.thk = Thk.Col1.UMB;
Cnnt.L2.UMB12.int = 3;
Cnnt.L2.UMB12.axisTT = 'x';
Cnnt.L2.UMB12.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L2.UMB12.HspTol = 0.5; 
Cnnt.L2.UMB12.SDir = 120;

%Line3 - IS*VB12
Cnnt.L3.SN = 'API_WJ_Air';
Cnnt.L3.group = 'circ';
Cnnt.L3.axis = 'y';

Cnnt.L3.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L3.IS.axisTT = 'x';
Cnnt.L3.IS.int = 2;
Cnnt.L3.IS.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L3.IS.HspTol = 0.5;
Cnnt.L3.IS.SDir = 120;

Cnnt.L3.VB12.thk = Thk.Col1.VB;
Cnnt.L3.VB12.axisTT = 'x';
Cnnt.L3.VB12.int = 3;
Cnnt.L3.VB12.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L3.VB12.HspTol = 0.5;
Cnnt.L3.VB12.SDir = 90;

%Line4 - IS*BKHs
Cnnt.L4.SN = 'ABS_E_Air';
Cnnt.L4.group = 'rad';
Cnnt.L4.axis_c = 'y';
Cnnt.L4.axis_r = 'z';

Cnnt.L4.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L4.IS.axisTT = 'x';
Cnnt.L4.IS.int = 5;
Cnnt.L4.IS.HspAxis = 'z';
Cnnt.L4.IS.Hsp = [5585, 6900,7550.3,8300,9311,9700,10700,10844,11800,12356];
Cnnt.L4.IS.HspTol = 10;
Cnnt.L4.IS.SDir = 90;

%Line5 - OS*TF
Cnnt.L5.SN = 'ABS_E_Air';
Cnnt.L5.group = 'circ';
Cnnt.L5.axis = 'y';

Cnnt.L5.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L5.OS.axisTT = 'x';
Cnnt.L5.OS.int = 20;
Cnnt.L5.OS.HspThk = Thk.Col1.OSatUMB ;
Cnnt.L5.OS.Hsp = -172.5 : 15 : 172.5;
Cnnt.L5.OS.HspTol = 0.2;
Cnnt.L5.OS.SDir = 0;

Cnnt.L5.TF.thk = Thk.Col1.TFout;
Cnnt.L5.TF.axisTT = 'z';
Cnnt.L5.TF.int = 20;
Cnnt.L5.TF.HspThk = Thk.Col1.TFatUMB ;
Cnnt.L5.TF.Hsp = -180 : 7.5 : 180;
Cnnt.L5.TF.HspTol = 0.2;
Cnnt.L5.TF.SDir = 90;

%Line6 - OS*UMB12
Cnnt.L6.SN = 'API_WJ_Air';
Cnnt.L6.group = 'circ';
Cnnt.L6.axis = 'y';

Cnnt.L6.OS.thk = Thk.Col1.OSatUMB;
Cnnt.L6.OS.axisTT = 'x';
Cnnt.L6.OS.int = 3;

Cnnt.L6.UMB12.thk = Thk.Col1.UMB;
Cnnt.L6.UMB12.axisTT = 'x';
Cnnt.L6.UMB12.int = 3;

%Line7 - OS*VB12
Cnnt.L7.SN = 'API_WJ_Air';
Cnnt.L7.group = 'circ';
Cnnt.L7.axis = 'y';

Cnnt.L7.OS.thk = Thk.Col1.OSatVB;
Cnnt.L7.OS.axisTT = 'x';
Cnnt.L7.OS.int = 3;

Cnnt.L7.VB12.thk = Thk.Col1.VB;
Cnnt.L7.VB12.axisTT = 'x';
Cnnt.L7.VB12.int = 3;

%Line8 - OS*Bkh1
Cnnt.L8.SN = 'ABS_E_Air';
Cnnt.L8.group = 'rad';
Cnnt.L8.axis_c = 'y';
Cnnt.L8.axis_r = 'z';

Cnnt.L8.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L8.OS.axisTT = 'x';
Cnnt.L8.OS.int = 10;
Cnnt.L8.OS.HspAxis = 'z';
Cnnt.L8.OS.Hsp = [0,1100,2000,2200,3300,4400,5000,5500,6900,8300,9700,10700,11800,13000];
Cnnt.L8.OS.HspTol = 10;
Cnnt.L8.OS.SDir = 0;

%Line9 - OS*TFgd
Cnnt.L9.SN = 'ABS_E_Air';
Cnnt.L9.group = 'rad';
Cnnt.L9.axis_c = 'y';
Cnnt.L9.axis_r = 'z';

Cnnt.L9.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L9.OS.axisTT = 'x';
Cnnt.L9.OS.int = 3;
Cnnt.L9.OS.HspAxis = 'y';
Cnnt.L9.OS.HspThk = Thk.Col1.OSatUMB ;
Cnnt.L9.OS.Hsp = [-150,150];
Cnnt.L9.OS.HspTol = 0.1;
Cnnt.L8.OS.SDir = 0;

%Line10 - Bkh1 four edges
Cnnt.L10.SN = 'ABS_E_Air';
Cnnt.L10.group = 'flat';
Cnnt.L10.axis1 = 'y';
Cnnt.L10.axis2 = 'z';

Cnnt.L10.Bkh1.thk = Thk.Col1.Bkh;
Cnnt.L10.Bkh1.axisTT = 'x';
Cnnt.L10.Bkh1.int = 5;

Cnnt.L10.Bkh1.path = [0,0;2750,0;2750,-13000;0,-13000];
Cnnt.L10.Bkh1.HspAxis = 'z';
Cnnt.L10.Bkh1.Hsp = 0;
Cnnt.L10.Bkh1.HspTol = 0.5;
Cnnt.L10.Bkh1.HspInt = 1;
Cnnt.L10.Bkh1.SDir = 120;

%Line11 - TFin * TFgd
Cnnt.L11.SN = 'ABS_E_Air';
Cnnt.L11.group = 'other';
Cnnt.L11.axis1 = 'y';
Cnnt.L11.axis2 = 'x';

Cnnt.L11.TF.thk = Thk.Col1.TFin;
Cnnt.L11.TF.axisTT = 'z';
Cnnt.L11.TF.int = 1;
Cnnt.L11.TF.HspAxis = 'y';
Cnnt.L11.TF.Hsp = -165:15:180;
Cnnt.L11.TF.HspTol = 0.1;
Cnnt.L11.TF.HspInt = 5;

%Line12 - TFout * TFgd
%Line13 - FB1 * UMB12
Cnnt.L13.SN = 'ABS_E_Air';
Cnnt.L13.group = 'flat';
Cnnt.L13.axis1 = 'y';
Cnnt.L13.axis2 = 'z';

Cnnt.L13.FB1.thk = Thk.Col1.FB;
Cnnt.L13.FB1.axisTT = 'x';
Cnnt.L13.FB1.int = 6;
Cnnt.L13.FB1.path = [0,0;2750,0;2750,-500;0,-500];

Cnnt.L13.FB1.HspAxis = 'z';
Cnnt.L13.FB1.Hsp = 0;
Cnnt.L13.FB1.HspTol = 0.5;
Cnnt.L13.FB1.HspInt = 3;
Cnnt.L13.FB1.SDir = 150;

%Line14 - TB * TBbrkt
Cnnt.L14.SN = 'ABS_E_Air';
Cnnt.L14.group = 'rad';
Cnnt.L14.axis_c = 'y';
Cnnt.L14.axis_r = 'z';

Cnnt.L14.TB.thk = Thk.Col1.TB;
Cnnt.L14.TB.axisTT = 'x';
Cnnt.L14.TB.int = 1;
Cnnt.L14.TB.HspAxis = 'y';
Cnnt.L14.TB.Hsp = -120;
Cnnt.L14.TB.HspTol = 0.5;
Cnnt.L14.TB.SDir = 90;

%Line15 - IS * Ring1
Cnnt.L15.SN = 'ABS_E_Air';
Cnnt.L15.group = 'circ';
Cnnt.L15.axis = 'y';

Cnnt.L15.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L15.IS.axisTT = 'x';
Cnnt.L15.IS.int = 3;
Cnnt.L15.IS.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L15.IS.HspTol = 0.5;
Cnnt.L15.IS.SDir = 90;

Cnnt.L15.Ring1.thk = Thk.Col1.RingatUMB;
Cnnt.L15.Ring1.axisTT = 'z';
Cnnt.L15.Ring1.int = 10;
Cnnt.L15.Ring1.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L15.Ring1.HspTol = 0.5;
Cnnt.L15.Ring1.SDir = 0;

%Line16 - IS * Ring2
Cnnt.L16.SN = 'ABS_E_Air';
Cnnt.L16.group = 'circ';
Cnnt.L16.axis = 'y';

Cnnt.L16.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L16.IS.axisTT = 'x';
Cnnt.L16.IS.int = 3;
Cnnt.L16.IS.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L16.IS.HspTol = 0.5;
Cnnt.L16.IS.SDir = 90;

Cnnt.L16.Ring2.thk = Thk.Col1.RingatUMB;
Cnnt.L16.Ring2.axisTT = 'z';
Cnnt.L16.Ring2.int = 10;
Cnnt.L16.Ring2.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L16.Ring2.HspTol = 0.5;
Cnnt.L16.Ring2.SDir = 0;

%Line17 - IS * Ring3
Cnnt.L17.SN = 'ABS_E_Air';
Cnnt.L17.group = 'circ';
Cnnt.L17.axis = 'y';

Cnnt.L17.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L17.IS.axisTT = 'x';
Cnnt.L17.IS.int = 3;
Cnnt.L17.IS.Hsp = [-157.71, -156, -144, -142.29, -120, 120, 142.29, 144, 156, 157.71];
Cnnt.L17.IS.HspTol = 0.5;
Cnnt.L17.IS.SDir = 120;

Cnnt.L17.Ring3.thk = Thk.Col1.RingatVB;
Cnnt.L17.Ring3.axisTT = 'z';
Cnnt.L17.Ring3.int = 10;
Cnnt.L17.Ring3.Hsp = [-157.71, -156, -144, -142.29, -120, 120, 142.29, 144, 156, 157.71];
Cnnt.L17.Ring3.HspTol = 0.5;
Cnnt.L17.Ring3.SDir = 0;

%Line18 - IS * Ring4
Cnnt.L18.SN = 'ABS_E_Air';
Cnnt.L18.group = 'circ';
Cnnt.L18.axis = 'y';

Cnnt.L18.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L18.IS.axisTT = 'x';
Cnnt.L18.IS.int = 3;
Cnnt.L18.IS.Hsp = [-156.75, -156, -144, -143.25,-120, 120,  143.25, 144, 156, 156.75];
Cnnt.L18.IS.HspTol = 0.5;
Cnnt.L18.IS.SDir = 90;

Cnnt.L18.Ring4.thk = Thk.Col1.RingatVB;
Cnnt.L18.Ring4.axisTT = 'z';
Cnnt.L18.Ring4.int = 10;
Cnnt.L18.Ring4.Hsp = [-156.75, -156, -144, -143.25,-120, 120,  143.25, 144, 156, 156.75];
Cnnt.L18.Ring4.HspTol = 0.5;
Cnnt.L18.Ring4.SDir = [30 150];

%Line19 - TF * TBring
%Line20 - IS * UMB13
Cnnt.L20.SN = 'API_WJ_Air';
Cnnt.L20.group = 'circ';
Cnnt.L20.axis = 'y';

Cnnt.L20.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L20.IS.axisTT = 'x';
Cnnt.L20.IS.int = 2;
Cnnt.L20.IS.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L20.IS.HspTol = 0.5; %Tolerance in hot spot sampling
Cnnt.L20.IS.SDir = 90;

Cnnt.L20.UMB13.thk = Thk.Col1.UMB;
Cnnt.L20.UMB13.axisTT = 'x';
Cnnt.L20.UMB13.int = 3;
Cnnt.L20.UMB13.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L20.UMB13.HspTol = 0.5; 
Cnnt.L20.UMB13.SDir = 60;

%Line21 - IS * VB13
Cnnt.L21.SN = 'API_WJ_Air';
Cnnt.L21.group = 'circ';
Cnnt.L21.axis = 'y';

Cnnt.L21.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L21.IS.axisTT = 'x';
Cnnt.L21.IS.int = 2;
Cnnt.L21.IS.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L21.IS.HspTol = 0.5;
Cnnt.L21.IS.SDir = 60;

Cnnt.L21.VB13.thk = Thk.Col1.VB;
Cnnt.L21.VB13.axisTT = 'x';
Cnnt.L21.VB13.int = 3;
Cnnt.L21.VB13.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L21.VB13.HspTol = 0.5;
Cnnt.L21.VB13.SDir = 90;

%Line22 - OS * UMB13
Cnnt.L22.SN = 'API_WJ_Air';
Cnnt.L22.group = 'circ';
Cnnt.L22.axis = 'y';

Cnnt.L22.OS.thk = Thk.Col1.OSatUMB;
Cnnt.L22.OS.axisTT = 'x';
Cnnt.L22.OS.int = 3;

Cnnt.L22.UMB13.thk = Thk.Col1.UMB;
Cnnt.L22.UMB13.axisTT = 'x';
Cnnt.L22.UMB13.int = 3;

%Line23 - OS * VB13
Cnnt.L23.SN = 'API_WJ_Air';
Cnnt.L23.group = 'circ';
Cnnt.L23.axis = 'y';

Cnnt.L23.OS.thk = Thk.Col1.OSatVB;
Cnnt.L23.OS.axisTT = 'x';
Cnnt.L23.OS.int = 3;

Cnnt.L23.VB13.thk = Thk.Col1.VB;
Cnnt.L23.VB13.axisTT = 'x';
Cnnt.L23.VB13.int = 3;

%Line24 - Bkh2 two edges
Cnnt.L24.SN = 'ABS_E_Air';
Cnnt.L24.group = 'flat';
Cnnt.L24.axis1 = 'y';
Cnnt.L24.axis2 = 'z';

Cnnt.L24.Bkh2.thk = Thk.Col1.Bkh;
Cnnt.L24.Bkh2.axisTT = 'x';
Cnnt.L24.Bkh2.int = 5;
Cnnt.L24.Bkh2.path = [0,0;-2750,0;-2750,-13000;0,-13000];
Cnnt.L24.Bkh2.HspAxis = 'z';
Cnnt.L24.Bkh2.Hsp = 0;
Cnnt.L24.Bkh2.HspTol = 0.5;
Cnnt.L24.Bkh2.HspInt = 1;
Cnnt.L24.Bkh2.SDir = 50;

%Line25 - FB2 four edges
Cnnt.L25.SN = 'ABS_E_Air';
Cnnt.L25.group = 'flat';
Cnnt.L25.axis1 = 'y';
Cnnt.L25.axis2 = 'z';

Cnnt.L25.FB2.thk = Thk.Col1.FB;
Cnnt.L25.FB2.axisTT = 'x';
Cnnt.L25.FB2.int = 3;
Cnnt.L25.FB2.path = [0,0;-2750,0;-2750,-500;0,-500];
Cnnt.L25.FB2.HspAxis1 = 'z';
Cnnt.L25.FB2.Hsp = 0;
Cnnt.L25.FB2.HspAxis2 = 'y';
Cnnt.L25.FB2.Hsp2 = -2750;
Cnnt.L25.FB2.HspTol = 0.5;
Cnnt.L25.FB2.HspInt = 1;
Cnnt.L25.FB2.SDir = 30;

%Line26 - IS opening
Cnnt.L26.SN = 'ABS_C_Air';
Cnnt.L26.group = 'flat';
Cnnt.L26.axis1 = 'y';
Cnnt.L26.axis2 = 'z';

Cnnt.L26.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L26.IS.axisTT = 'x';
Cnnt.L26.IS.int = 2;

%Line27 - VB12lwr * LMB12mid
%Line28 - VB21lwr * LMB12mid
%Line29 - VB13lwr * LMB13mid
%Line30 - VB31lwr * LMB13mid
%Line31 - IS * C-Plate

%Line32 - Vbar1 (at Bkh1) four edge
Cnnt.L32.SN = 'ABS_E_Air';
Cnnt.L32.group = 'other';
Cnnt.L32.axis1 = 'x';
Cnnt.L32.axis2 = 'z';

Cnnt.L32.Vbar1.thk = Thk.Col1.VBaratBkh;
Cnnt.L32.Vbar1.axisTT = 'y';
Cnnt.L32.Vbar1.int = 1;

Cnnt.L32.Vbar1.HspAxis = 'x';
Cnnt.L32.Vbar1.Hsp = [2550, 3250];
Cnnt.L32.Vbar1.HspTol = 0.5;
Cnnt.L32.Vbar1.HspInt = 4;
Cnnt.L32.Vbar1.SDir = 60;

%Line33 - Vbar2 (at Bkh2) four edge
Cnnt.L33.SN = 'ABS_E_Air';
Cnnt.L33.group = 'other';
Cnnt.L33.axis1 = 'x';
Cnnt.L33.axis2 = 'z';

Cnnt.L33.Vbar2.thk = Thk.Col1.VBaratBkh;
Cnnt.L33.Vbar2.axisTT = 'y';
Cnnt.L33.Vbar2.int = 1;

Cnnt.L33.Vbar2.HspAxis = 'x';
Cnnt.L33.Vbar2.Hsp = [2550, 3250];
Cnnt.L33.Vbar2.HspTol = 0.5;
Cnnt.L33.Vbar2.HspInt = 4;
Cnnt.L33.Vbar2.SDir = 60;

%Line34 - Vbar3 (at UMBVB12) four edge
Cnnt.L34.SN = 'ABS_E_Air';
Cnnt.L34.group = 'other';
Cnnt.L34.axis1 = 'x';
Cnnt.L34.axis2 = 'z';

Cnnt.L34.Vbar3.thk = Thk.Col1.VBaratTruss;
Cnnt.L34.Vbar3.axisTT = 'y';
Cnnt.L34.Vbar3.int = 1;

Cnnt.L34.Vbar3.HspAxis = 'x';
Cnnt.L34.Vbar3.Hsp = [2550, 3250];
Cnnt.L34.Vbar3.HspTol = 0.5;
Cnnt.L34.Vbar3.HspInt = 4;
Cnnt.L34.Vbar3.SDir = 90;

%Line35 - Vbar4 (at UMBVB12) four edge
Cnnt.L35.SN = 'ABS_E_Air';
Cnnt.L35.group = 'other';
Cnnt.L35.axis1 = 'x';
Cnnt.L35.axis2 = 'z';

Cnnt.L35.Vbar4.thk = Thk.Col1.VBaratTruss;
Cnnt.L35.Vbar4.axisTT = 'y';
Cnnt.L35.Vbar4.int = 1;
Cnnt.L35.Vbar4.path = [];
Cnnt.L35.Vbar4.HspAxis = 'x';
Cnnt.L35.Vbar4.Hsp = [2550, 3250];
Cnnt.L35.Vbar4.HspTol = 0.5;
Cnnt.L35.Vbar4.HspInt = 4;
Cnnt.L35.Vbar4.SDir = 90;

%Line36 - Vbar5 (at UMBVB13) four edge
Cnnt.L36.SN = 'ABS_E_Air';
Cnnt.L36.group = 'other';
Cnnt.L36.axis1 = 'x';
Cnnt.L36.axis2 = 'z';

Cnnt.L36.Vbar5.thk = Thk.Col1.VBaratTruss;
Cnnt.L36.Vbar5.axisTT = 'y';
Cnnt.L36.Vbar5.int = 1;

Cnnt.L36.Vbar5.HspAxis = 'x';
Cnnt.L36.Vbar5.Hsp = [2550, 3250];
Cnnt.L36.Vbar5.HspTol = 0.5;
Cnnt.L36.Vbar5.HspInt = 4;
Cnnt.L36.Vbar5.SDir = 90;

%Line37 - Vbar6 (at UMBVB13) four edge
Cnnt.L37.SN = 'ABS_E_Air';
Cnnt.L37.group = 'other';
Cnnt.L37.axis1 = 'x';
Cnnt.L37.axis2 = 'z';

Cnnt.L37.Vbar6.thk = Thk.Col1.VBaratTruss;
Cnnt.L37.Vbar6.axisTT = 'y';
Cnnt.L37.Vbar6.int = 1;

Cnnt.L37.Vbar6.HspAxis = 'x';
Cnnt.L37.Vbar6.Hsp = [2550, 3250];
Cnnt.L37.Vbar6.HspTol = 0.5;
Cnnt.L37.Vbar6.HspInt = 4;
Cnnt.L37.Vbar6.SDir = 90;

%Line38 - Ring1 inner edges and connection with Vbars
Cnnt.L38.SN = 'ABS_E_Air';
Cnnt.L38.group = 'other';
Cnnt.L38.axis1 = 'x';
Cnnt.L38.axis2 = 'y';

Cnnt.L38.Ring1.thk = Thk.Col1.RingatUMB;
Cnnt.L38.Ring1.axisTT = 'z';
Cnnt.L38.Ring1.int = 2;

Cnnt.L38.Ring1.HspAxis = 'x';
Cnnt.L38.Ring1.Hsp = 2500;
% Cnnt.L38.Ring1.HspSN = 'ABS_E_Air';
Cnnt.L38.Ring1.HspTol = 0.5;
Cnnt.L38.Ring1.HspInt = 1;
Cnnt.L38.Ring1.SDir = 90;

%Line39 - Ring2 inner edges and connection with Vbars
Cnnt.L39.SN = 'ABS_E_Air';
Cnnt.L39.group = 'other';
Cnnt.L39.axis1 = 'x';
Cnnt.L39.axis2 = 'y';

Cnnt.L39.Ring2.thk = Thk.Col1.RingatUMB;
Cnnt.L39.Ring2.axisTT = 'z';
Cnnt.L39.Ring2.int = 2;

Cnnt.L39.Ring2.HspAxis = 'x';
Cnnt.L39.Ring2.Hsp = 2500;
% Cnnt.L39.Ring2.HspSN = 'ABS_E_Air';
Cnnt.L39.Ring2.HspTol = 0.5;
Cnnt.L39.Ring2.HspInt = 1;
Cnnt.L39.Ring2.SDir = 90;

%Line40 - Ring3 inner edges and connection with Vbars
Cnnt.L40.SN = 'ABS_E_Air';
Cnnt.L40.group = 'other';
Cnnt.L40.axis1 = 'x';
Cnnt.L40.axis2 = 'y';

Cnnt.L40.Ring3.thk = Thk.Col1.RingatVB;
Cnnt.L40.Ring3.axisTT = 'z';
Cnnt.L40.Ring3.int = 2;

Cnnt.L40.Ring3.HspAxis = 'x';
Cnnt.L40.Ring3.Hsp = 2500;
% Cnnt.L40.Ring3.HspSN = 'ABS_E_Air';
Cnnt.L40.Ring3.HspTol = 0.5;
Cnnt.L40.Ring3.HspInt = 1;
Cnnt.L40.Ring3.SDir = 0:10:170;

%Line41 - Ring4 inner edges and connection with Vbars
Cnnt.L41.SN = 'ABS_E_Air';
Cnnt.L41.group = 'other';
Cnnt.L41.axis1 = 'x';
Cnnt.L41.axis2 = 'y';

Cnnt.L41.Ring4.thk = Thk.Col1.RingatVB;
Cnnt.L41.Ring4.axisTT = 'z';
Cnnt.L41.Ring4.int = 2;

Cnnt.L41.Ring4.HspAxis = 'x';
Cnnt.L41.Ring4.Hsp = 2500;
% Cnnt.L41.Ring4.HspSN = 'ABS_E_Air';
Cnnt.L41.Ring4.HspTol = 0.5;
Cnnt.L41.Ring4.HspInt = 1;
Cnnt.L41.Ring4.SDir = 0:10:170;

%Line42 - TBBrkt1 (at Bkh1)
Cnnt.L42.SN = 'ABS_C_Air';
Cnnt.L42.group = 'other';
Cnnt.L42.axis1 = 'x';
Cnnt.L42.axis2 = 'z';

Cnnt.L42.TBBrkt1.thk = Thk.Col1.Brkt_TBatBkh;
Cnnt.L42.TBBrkt1.axisTT = 'y';
Cnnt.L42.TBBrkt1.int = 1;

Cnnt.L42.TBBrkt1.HspAxis = 'x';
Cnnt.L42.TBBrkt1.Hsp = 3250;
Cnnt.L42.TBBrkt1.HspAxis2 = 'z';
Cnnt.L42.TBBrkt1.Hsp2 = 13000;

Cnnt.L42.TBBrkt1.HspSN = 'ABS_E_Air';
Cnnt.L42.TBBrkt1.HspTol = 15;
Cnnt.L42.TBBrkt1.HspInt = 1;
Cnnt.L42.TBBrkt1.SDir = 130;

%Line43 - TBBrkt1 (at FB1)
Cnnt.L43.SN = 'ABS_C_Air';
Cnnt.L43.group = 'other';
Cnnt.L43.axis1 = 'x';
Cnnt.L43.axis2 = 'z';

Cnnt.L43.TBBrkt2.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L43.TBBrkt2.axisTT = 'y';
Cnnt.L43.TBBrkt2.int = 1;

Cnnt.L43.TBBrkt2.HspAxis = 'x';
Cnnt.L43.TBBrkt2.Hsp = 3250;
Cnnt.L43.TBBrkt2.HspAxis2 = 'z';
Cnnt.L43.TBBrkt2.Hsp2 = 13000;

Cnnt.L43.TBBrkt2.HspSN = 'ABS_E_Air';
Cnnt.L43.TBBrkt2.HspTol = 15;
Cnnt.L43.TBBrkt2.HspInt = 3;
Cnnt.L43.TBBrkt2.SDir = 130;

%Line42 - TBBrkt1 (at OS*FB1)
Cnnt.L44.SN = 'ABS_C_Air';
Cnnt.L44.group = 'other';
Cnnt.L44.axis1 = 'x';
Cnnt.L44.axis2 = 'z';

Cnnt.L44.TBBrkt3.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L44.TBBrkt3.axisTT = 'y';
Cnnt.L44.TBBrkt3.int = 1;

Cnnt.L44.TBBrkt3.HspAxis = 'x';
Cnnt.L44.TBBrkt3.Hsp = 6000;
Cnnt.L44.TBBrkt3.HspAxis2 = 'z';
Cnnt.L44.TBBrkt3.Hsp2 = 12500;

Cnnt.L44.TBBrkt3.HspSN = 'ABS_E_Air';
Cnnt.L44.TBBrkt3.HspTol = 15;
Cnnt.L44.TBBrkt3.HspInt = 1;
Cnnt.L44.TBBrkt3.SDir = 150;

%Line45 - TBBrkt4 (at Bkh2)
Cnnt.L45.SN = 'ABS_C_Air';
Cnnt.L45.group = 'other';
Cnnt.L45.axis1 = 'x';
Cnnt.L45.axis2 = 'z';

Cnnt.L45.TBBrkt4.thk = Thk.Col1.Brkt_TBatBkh;
Cnnt.L45.TBBrkt4.axisTT = 'y';
Cnnt.L45.TBBrkt4.int = 1;

Cnnt.L45.TBBrkt4.HspAxis = 'x';
Cnnt.L45.TBBrkt4.Hsp = 3250;
Cnnt.L45.TBBrkt4.HspAxis2 = 'z';
Cnnt.L45.TBBrkt4.Hsp2 = 13000;

Cnnt.L45.TBBrkt4.HspSN = 'ABS_E_Air';
Cnnt.L45.TBBrkt4.HspTol = 15;
Cnnt.L45.TBBrkt4.HspInt = 1;
Cnnt.L45.TBBrkt4.SDir = 130;

%Line46 - TBBrkt5 (at FB2)
Cnnt.L46.SN = 'ABS_C_Air';
Cnnt.L46.group = 'other';
Cnnt.L46.axis1 = 'x';
Cnnt.L46.axis2 = 'z';

Cnnt.L46.TBBrkt5.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L46.TBBrkt5.axisTT = 'y';
Cnnt.L46.TBBrkt5.int = 1;

Cnnt.L46.TBBrkt5.HspAxis = 'x';
Cnnt.L46.TBBrkt5.Hsp = 3250;
Cnnt.L46.TBBrkt5.HspAxis2 = 'z';
Cnnt.L46.TBBrkt5.Hsp2 = 13000;

Cnnt.L46.TBBrkt5.HspSN = 'ABS_E_Air';
Cnnt.L46.TBBrkt5.HspTol = 15;
Cnnt.L46.TBBrkt5.HspInt = 1;
Cnnt.L46.TBBrkt5.SDir = 130;

%Line47 - TBBrkt6 (at OS*FB2)
Cnnt.L47.SN = 'ABS_C_Air';
Cnnt.L47.group = 'other';
Cnnt.L47.axis1 = 'x';
Cnnt.L47.axis2 = 'z';

Cnnt.L47.TBBrkt6.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L47.TBBrkt6.axisTT = 'y';
Cnnt.L47.TBBrkt6.int = 1;

Cnnt.L47.TBBrkt6.HspAxis = 'x';
Cnnt.L47.TBBrkt6.Hsp = 6000;
Cnnt.L47.TBBrkt6.HspAxis2 = 'z';
Cnnt.L47.TBBrkt6.Hsp2 = 12500;

Cnnt.L47.TBBrkt6.HspSN = 'ABS_E_Air';
Cnnt.L47.TBBrkt6.HspTol = 15;
Cnnt.L47.TBBrkt6.HspInt = 1;
Cnnt.L47.TBBrkt6.SDir = 150;

%L48 - TOC ring * Vbars
Cnnt.L48.SN = 'ABS_E_Air';
Cnnt.L48.group = 'rad';
Cnnt.L48.axis_c = 'y';
Cnnt.L48.axis_r = 'x';

Cnnt.L48.TOCring.thk = Thk.Col1.TOCring;
Cnnt.L48.TOCring.axisTT = 'z';
Cnnt.L48.TOCring.int = 1;
Cnnt.L48.TOCring.HspAxis = 'x';
Cnnt.L48.TOCring.Hsp = 2550;
Cnnt.L48.TOCring.HspTol = 0.5;
Cnnt.L48.TOCring.SDir = 90;

%Line49 - Vbar1 (at Bkh1) free edges
Cnnt.L49.SN = 'ABS_C_Air';
Cnnt.L49.group = 'circ';
Cnnt.L49.axis = 'z';

Cnnt.L49.Vbar1.thk = Thk.Col1.VBaratBkh;
Cnnt.L49.Vbar1.axisTT = 'y';
Cnnt.L49.Vbar1.int = 2;

Cnnt.L49.Vbar1.Hsp = [7169.9, 7550.3, 9311, 10844, 12356];
Cnnt.L49.Vbar1.HspTol = 200;
Cnnt.L49.Vbar1.SDir = 90;

%Line50 - Vbar2 (at Bkh1) free edges
Cnnt.L50.SN = 'ABS_C_Air';
Cnnt.L50.group = 'circ';
Cnnt.L50.axis = 'z';

Cnnt.L50.Vbar2.thk = Thk.Col1.VBaratBkh;
Cnnt.L50.Vbar2.axisTT = 'y';
Cnnt.L50.Vbar2.int = 2;

Cnnt.L50.Vbar2.Hsp = [7169.9, 7550.3, 9311, 10844, 12356];
Cnnt.L50.Vbar2.HspTol = 200;
Cnnt.L50.Vbar2.SDir = 90;

%Line51 - Vbar3 (at Truss) free edges
Cnnt.L51.SN = 'ABS_C_Air';
Cnnt.L51.group = 'circ';
Cnnt.L51.axis = 'z';

Cnnt.L51.Vbar3.thk = Thk.Col1.VBaratTruss;
Cnnt.L51.Vbar3.axisTT = 'y';
Cnnt.L51.Vbar3.int = 2;

Cnnt.L51.Vbar3.Hsp = [7169.9, 7550.3, 9311, 10844, 12356];
Cnnt.L51.Vbar3.HspTol = 200;
Cnnt.L51.Vbar3.SDir = 90;

OutName = [path1 'CnntInfo.mat'];
save(OutName, 'Cnnt')

%% ItrR5_15_20 (Col1_Top)
ItrNo = 'ItrR5_15_20';
path1 = [path0 ItrNo '\'];
load([path1 'thickness.mat']);

Cnnt.Itr = ItrNo;

%Line1 - TB*IS*TF
Cnnt.L1.SN = 'ABS_E_Air';
Cnnt.L1.group = 'circ';
Cnnt.L1.axis = 'y';

Cnnt.L1.TB.thk = Thk.Col1.TB;
Cnnt.L1.TB.int = 3;
Cnnt.L1.TB.axisTT = 'x'; %through-thickness axis
Cnnt.L1.TB.SDir = 90; %degree

Cnnt.L1.TF.thk = Thk.Col1.TFin;
Cnnt.L1.TF.int = 10;
Cnnt.L1.TF.axisTT = 'z'; %through-thickness axis
Cnnt.L1.TF.HspAxis = 'y';
Cnnt.L1.TF.Hsp = -165:15:180;
Cnnt.L1.TF.HspTol = 0.5;

Cnnt.L1.TOCring.thk = Thk.Col1.TFin;
Cnnt.L1.TOCring.int = 10;
Cnnt.L1.TOCring.axisTT = 'z';

%Line2 - IS*UMB12
Cnnt.L2.SN = 'API_WJ_Air';
Cnnt.L2.group = 'circ';
Cnnt.L2.axis = 'y';

Cnnt.L2.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L2.IS.int = 1;
Cnnt.L2.IS.axisTT = 'x';
Cnnt.L2.IS.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L2.IS.HspTol = 0.5; %Tolerance in hot spot sampling
Cnnt.L2.IS.SDir = 90;

Cnnt.L2.UMB12.thk = Thk.Col1.UMB;
Cnnt.L2.UMB12.int = 3;
Cnnt.L2.UMB12.axisTT = 'x';
Cnnt.L2.UMB12.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L2.UMB12.HspTol = 0.5; 
Cnnt.L2.UMB12.SDir = 120;

%Line3 - IS*VB12
Cnnt.L3.SN = 'API_WJ_Air';
Cnnt.L3.group = 'circ';
Cnnt.L3.axis = 'y';

Cnnt.L3.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L3.IS.axisTT = 'x';
Cnnt.L3.IS.int = 1;
Cnnt.L3.IS.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L3.IS.HspTol = 0.5;
Cnnt.L3.IS.SDir = 120;

Cnnt.L3.VB12.thk = Thk.Col1.VB;
Cnnt.L3.VB12.axisTT = 'x';
Cnnt.L3.VB12.int = 3;
Cnnt.L3.VB12.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L3.VB12.HspTol = 0.5;
Cnnt.L3.VB12.SDir = 90;

%Line4 - IS*BKHs
Cnnt.L4.SN = 'ABS_E_Air';
Cnnt.L4.group = 'rad';
Cnnt.L4.axis_c = 'y';
Cnnt.L4.axis_r = 'z';

Cnnt.L4.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L4.IS.axisTT = 'x';
Cnnt.L4.IS.int = 3;
Cnnt.L4.IS.HspAxis = 'z';
Cnnt.L4.IS.Hsp = [5585, 6900,7550.3,8300,9311,9700,10700,10844,11800,12356];
Cnnt.L4.IS.HspTol = 10;
Cnnt.L4.IS.SDir = 90;

%Line5 - OS*TF
Cnnt.L5.SN = 'ABS_E_Air';
Cnnt.L5.group = 'circ';
Cnnt.L5.axis = 'y';

Cnnt.L5.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L5.OS.axisTT = 'x';
Cnnt.L5.OS.int = 20;
Cnnt.L5.OS.HspThk = Thk.Col1.OSatUMB ;
Cnnt.L5.OS.Hsp = -172.5 : 15 : 172.5;
Cnnt.L5.OS.HspTol = 0.2;
Cnnt.L5.OS.SDir = 0;

Cnnt.L5.TF.thk = Thk.Col1.TFout;
Cnnt.L5.TF.axisTT = 'z';
Cnnt.L5.TF.int = 20;
Cnnt.L5.TF.HspThk = Thk.Col1.TFatUMB ;
Cnnt.L5.TF.Hsp = -180 : 7.5 : 180;
Cnnt.L5.TF.HspTol = 0.2;
Cnnt.L5.TF.SDir = 90;

%Line6 - OS*UMB12
Cnnt.L6.SN = 'API_WJ_Air';
Cnnt.L6.group = 'circ';
Cnnt.L6.axis = 'y';

Cnnt.L6.OS.thk = Thk.Col1.OSatUMB;
Cnnt.L6.OS.axisTT = 'x';
Cnnt.L6.OS.int = 3;

Cnnt.L6.UMB12.thk = Thk.Col1.UMB;
Cnnt.L6.UMB12.axisTT = 'x';
Cnnt.L6.UMB12.int = 3;

%Line7 - OS*VB12
Cnnt.L7.SN = 'API_WJ_Air';
Cnnt.L7.group = 'circ';
Cnnt.L7.axis = 'y';

Cnnt.L7.OS.thk = Thk.Col1.OSatVB;
Cnnt.L7.OS.axisTT = 'x';
Cnnt.L7.OS.int = 3;

Cnnt.L7.VB12.thk = Thk.Col1.VB;
Cnnt.L7.VB12.axisTT = 'x';
Cnnt.L7.VB12.int = 3;

%Line8 - OS*Bkh1
Cnnt.L8.SN = 'ABS_E_Air';
Cnnt.L8.group = 'rad';
Cnnt.L8.axis_c = 'y';
Cnnt.L8.axis_r = 'z';

Cnnt.L8.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L8.OS.axisTT = 'x';
Cnnt.L8.OS.int = 10;
Cnnt.L8.OS.HspAxis = 'z';
Cnnt.L8.OS.Hsp = [0,1100,2000,2200,3300,4400,5000,5500,6900,8300,9700,10700,11800,13000];
Cnnt.L8.OS.HspTol = 10;
Cnnt.L8.OS.SDir = 0;

%Line9 - OS*TFgd
Cnnt.L9.SN = 'ABS_E_Air';
Cnnt.L9.group = 'rad';
Cnnt.L9.axis_c = 'y';
Cnnt.L9.axis_r = 'z';

Cnnt.L9.OS.thk = Thk.Col1.OSTopbk;
Cnnt.L9.OS.axisTT = 'x';
Cnnt.L9.OS.int = 3;
Cnnt.L9.OS.HspAxis = 'y';
Cnnt.L9.OS.HspThk = Thk.Col1.OSatUMB ;
Cnnt.L9.OS.Hsp = [-150,150];
Cnnt.L9.OS.HspTol = 0.1;
Cnnt.L8.OS.SDir = 0;

%Line10 - Bkh1 four edges
Cnnt.L10.SN = 'ABS_E_Air';
Cnnt.L10.group = 'flat';
Cnnt.L10.axis1 = 'y';
Cnnt.L10.axis2 = 'z';

Cnnt.L10.Bkh1.thk = Thk.Col1.Bkh;
Cnnt.L10.Bkh1.axisTT = 'x';
Cnnt.L10.Bkh1.int = 5;

Cnnt.L10.Bkh1.path = [0,0;2750,0;2750,-13000;0,-13000];
Cnnt.L10.Bkh1.HspAxis = 'z';
Cnnt.L10.Bkh1.Hsp = 0;
Cnnt.L10.Bkh1.HspTol = 0.5;
Cnnt.L10.Bkh1.HspInt = 1;
Cnnt.L10.Bkh1.SDir = 120;

%Line11 - TFin * TFgd
Cnnt.L11.SN = 'ABS_E_Air';
Cnnt.L11.group = 'other';
Cnnt.L11.axis1 = 'y';
Cnnt.L11.axis2 = 'x';

Cnnt.L11.TF.thk = Thk.Col1.TFin;
Cnnt.L11.TF.axisTT = 'z';
Cnnt.L11.TF.int = 1;
Cnnt.L11.TF.HspAxis = 'y';
Cnnt.L11.TF.Hsp = -165:15:180;
Cnnt.L11.TF.HspTol = 0.1;
Cnnt.L11.TF.HspInt = 5;

%Line12 - TFout * TFgd
%Line13 - FB1 * UMB12
Cnnt.L13.SN = 'ABS_E_Air';
Cnnt.L13.group = 'flat';
Cnnt.L13.axis1 = 'y';
Cnnt.L13.axis2 = 'z';

Cnnt.L13.FB1.thk = Thk.Col1.FB;
Cnnt.L13.FB1.axisTT = 'x';
Cnnt.L13.FB1.int = 6;
Cnnt.L13.FB1.path = [0,0;2750,0;2750,-500;0,-500];

Cnnt.L13.FB1.HspAxis = 'z';
Cnnt.L13.FB1.Hsp = 0;
Cnnt.L13.FB1.HspTol = 0.5;
Cnnt.L13.FB1.HspInt = 3;
Cnnt.L13.FB1.SDir = 150;

Cnnt.L13.UMB12.thk = Thk.Col1.UMB;
Cnnt.L13.UMB12.axisTT = 'x';
Cnnt.L13.UMB12.int = 3;
Cnnt.L13.UMB12.path = [-180,-3250;-180,0];

%Line14 - TB * TBbrkt
Cnnt.L14.SN = 'ABS_E_Air';
Cnnt.L14.group = 'rad';
Cnnt.L14.axis_c = 'y';
Cnnt.L14.axis_r = 'z';

Cnnt.L14.TB.thk = Thk.Col1.TB;
Cnnt.L14.TB.axisTT = 'x';
Cnnt.L14.TB.int = 1;
Cnnt.L14.TB.HspAxis = 'y';
Cnnt.L14.TB.Hsp = -120;
Cnnt.L14.TB.HspTol = 0.5;
Cnnt.L14.TB.SDir = 90;

%Line15 - IS * Ring1
Cnnt.L15.SN = 'ABS_E_Air';
Cnnt.L15.group = 'circ';
Cnnt.L15.axis = 'y';

Cnnt.L15.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L15.IS.axisTT = 'x';
Cnnt.L15.IS.int = 4;
Cnnt.L15.IS.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L15.IS.HspTol = 0.5;
Cnnt.L15.IS.SDir = 90;

Cnnt.L15.Ring1.thk = Thk.Col1.RingatUMB;
Cnnt.L15.Ring1.axisTT = 'z';
Cnnt.L15.Ring1.int = 10;
Cnnt.L15.Ring1.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L15.Ring1.HspTol = 0.5;
Cnnt.L15.Ring1.SDir = 0;

%Line16 - IS * Ring2
Cnnt.L16.SN = 'ABS_E_Air';
Cnnt.L16.group = 'circ';
Cnnt.L16.axis = 'y';

Cnnt.L16.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L16.IS.axisTT = 'x';
Cnnt.L16.IS.int = 4;
Cnnt.L16.IS.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L16.IS.HspTol = 0.5;
Cnnt.L16.IS.SDir = 90;

Cnnt.L16.Ring2.thk = Thk.Col1.RingatUMB;
Cnnt.L16.Ring2.axisTT = 'z';
Cnnt.L16.Ring2.int = 10;
Cnnt.L16.Ring2.Hsp = [ -158.64, -156, -144, -141.36, -120, 120, 141.36,144, 156, 158.64];
Cnnt.L16.Ring2.HspTol = 0.5;
Cnnt.L16.Ring2.SDir = 0;

%Line17 - IS * Ring3
Cnnt.L17.SN = 'ABS_E_Air';
Cnnt.L17.group = 'circ';
Cnnt.L17.axis = 'y';

Cnnt.L17.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L17.IS.axisTT = 'x';
Cnnt.L17.IS.int = 4;
Cnnt.L17.IS.Hsp = [-157.71, -156, -144, -142.29, -120, 120, 142.29, 144, 156, 157.71];
Cnnt.L17.IS.HspTol = 0.5;
Cnnt.L17.IS.SDir = 120;

Cnnt.L17.Ring3.thk = Thk.Col1.RingatVB;
Cnnt.L17.Ring3.axisTT = 'z';
Cnnt.L17.Ring3.int = 10;
Cnnt.L17.Ring3.Hsp = [-157.71, -156, -144, -142.29, -120, 120, 142.29, 144, 156, 157.71];
Cnnt.L17.Ring3.HspTol = 0.5;
Cnnt.L17.Ring3.SDir = 0;

%Line18 - IS * Ring4
Cnnt.L18.SN = 'ABS_E_Air';
Cnnt.L18.group = 'circ';
Cnnt.L18.axis = 'y';

Cnnt.L18.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L18.IS.axisTT = 'x';
Cnnt.L18.IS.int = 4;
Cnnt.L18.IS.Hsp = [-156.75, -156, -144, -143.25,-120, 120,  143.25, 144, 156, 156.75];
Cnnt.L18.IS.HspTol = 0.5;
Cnnt.L18.IS.SDir = 90;

Cnnt.L18.Ring4.thk = Thk.Col1.RingatVB;
Cnnt.L18.Ring4.axisTT = 'z';
Cnnt.L18.Ring4.int = 10;
Cnnt.L18.Ring4.Hsp = [-156.75, -156, -144, -143.25,-120, 120,  143.25, 144, 156, 156.75];
Cnnt.L18.Ring4.HspTol = 0.5;
Cnnt.L18.Ring4.SDir = [30 150];

%Line19 - TF * TBring
%Line20 - IS * UMB13
Cnnt.L20.SN = 'API_WJ_Air';
Cnnt.L20.group = 'circ';
Cnnt.L20.axis = 'y';

Cnnt.L20.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L20.IS.axisTT = 'x';
Cnnt.L20.IS.int = 1;
Cnnt.L20.IS.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L20.IS.HspTol = 0.5; %Tolerance in hot spot sampling
Cnnt.L20.IS.SDir = 90;

Cnnt.L20.UMB13.thk = Thk.Col1.UMB;
Cnnt.L20.UMB13.axisTT = 'x';
Cnnt.L20.UMB13.int = 3;
Cnnt.L20.UMB13.Hsp = [-157.82, -147.14 ,-32.86,-22.177, 22.177, 32.86,147.14, 157.82];
Cnnt.L20.UMB13.HspTol = 0.5; 
Cnnt.L20.UMB13.SDir = 60;

%Line21 - IS * VB13
Cnnt.L21.SN = 'API_WJ_Air';
Cnnt.L21.group = 'circ';
Cnnt.L21.axis = 'y';

Cnnt.L21.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L21.IS.axisTT = 'x';
Cnnt.L21.IS.int = 1;
Cnnt.L21.IS.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L21.IS.HspTol = 0.5;
Cnnt.L21.IS.SDir = 60;

Cnnt.L21.VB13.thk = Thk.Col1.VB;
Cnnt.L21.VB13.axisTT = 'x';
Cnnt.L21.VB13.int = 3;
Cnnt.L21.VB13.Hsp = [-153.07, -144.43,-30.595, 30.595,144.43, 153.07];
Cnnt.L21.VB13.HspTol = 0.5;
Cnnt.L21.VB13.SDir = 90;

%Line22 - OS * UMB13
Cnnt.L22.SN = 'API_WJ_Air';
Cnnt.L22.group = 'circ';
Cnnt.L22.axis = 'y';

Cnnt.L22.OS.thk = Thk.Col1.OSatUMB;
Cnnt.L22.OS.axisTT = 'x';
Cnnt.L22.OS.int = 3;

Cnnt.L22.UMB13.thk = Thk.Col1.UMB;
Cnnt.L22.UMB13.axisTT = 'x';
Cnnt.L22.UMB13.int = 3;

%Line23 - OS * VB13
Cnnt.L23.SN = 'API_WJ_Air';
Cnnt.L23.group = 'circ';
Cnnt.L23.axis = 'y';

Cnnt.L23.OS.thk = Thk.Col1.OSatVB;
Cnnt.L23.OS.axisTT = 'x';
Cnnt.L23.OS.int = 3;

Cnnt.L23.VB13.thk = Thk.Col1.VB;
Cnnt.L23.VB13.axisTT = 'x';
Cnnt.L23.VB13.int = 3;

%Line24 - Bkh2 two edges
Cnnt.L24.SN = 'ABS_E_Air';
Cnnt.L24.group = 'flat';
Cnnt.L24.axis1 = 'y';
Cnnt.L24.axis2 = 'z';

Cnnt.L24.Bkh2.thk = Thk.Col1.Bkh;
Cnnt.L24.Bkh2.axisTT = 'x';
Cnnt.L24.Bkh2.int = 5;
Cnnt.L24.Bkh2.path = [0,0;-2750,0;-2750,-13000;0,-13000];
Cnnt.L24.Bkh2.HspAxis = 'z';
Cnnt.L24.Bkh2.Hsp = 0;
Cnnt.L24.Bkh2.HspTol = 0.5;
Cnnt.L24.Bkh2.HspInt = 1;
Cnnt.L24.Bkh2.SDir = 50;

%Line25 - FB2 four edges
Cnnt.L25.SN = 'ABS_E_Air';
Cnnt.L25.group = 'flat';
Cnnt.L25.axis1 = 'y';
Cnnt.L25.axis2 = 'z';

Cnnt.L25.FB2.thk = Thk.Col1.FB;
Cnnt.L25.FB2.axisTT = 'x';
Cnnt.L25.FB2.int = 3;
Cnnt.L25.FB2.path = [0,0;-2750,0;-2750,-500;0,-500];

Cnnt.L25.FB2.HspAxis = 'z';
Cnnt.L25.FB2.Hsp = 0;
Cnnt.L25.FB2.HspAxis2 = 'y';
Cnnt.L25.FB2.Hsp2 = -2750;
Cnnt.L25.FB2.HspTol = 0.5;
Cnnt.L25.FB2.HspInt = 1;
Cnnt.L25.FB2.SDir = 30;

Cnnt.L25.UMB13.thk = Thk.Col1.UMB;
Cnnt.L25.UMB13.axisTT = 'x';
Cnnt.L25.UMB13.int = 3;
Cnnt.L25.UMB13.path = [180,-3250;180,0];

%Line26 - IS opening
Cnnt.L26.SN = 'ABS_C_Air';
Cnnt.L26.group = 'other';
Cnnt.L26.axis1 = 'y';
Cnnt.L26.axis2 = 'z';

Cnnt.L26.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L26.IS.axisTT = 'x';
Cnnt.L26.IS.int = 1;

%Line27 - VB12lwr * LMB12mid
%Line28 - VB21lwr * LMB12mid
%Line29 - VB13lwr * LMB13mid
%Line30 - VB31lwr * LMB13mid

%Line31 - IS * C-Plate
Cnnt.L31.SN = 'ABS_E_Air';
Cnnt.L31.group = 'circ';
Cnnt.L31.axis = 'y';

Cnnt.L31.IS.thk = Thk.Col1.IStopfrnt;
Cnnt.L31.IS.axisTT = 'x';
Cnnt.L31.IS.int = 3;
Cnnt.L31.IS.Hsp = [-128.85, -120:30:120, 128.85];
Cnnt.L31.IS.HspTol = 0.5;
Cnnt.L31.IS.SDir = 90;

Cnnt.L31.CFlat.thk = Thk.Col1.CFlat;
Cnnt.L31.CFlat.axisTT = 'z';
Cnnt.L31.CFlat.int = 5;
Cnnt.L31.CFlat.Hsp = [-128.85, -120:30:120, 128.85];
Cnnt.L31.CFlat.HspTol = 0.5;
% Cnnt.L31.CFlat.SDir = [30 150];

%Line32 - Vbar1 (at Bkh1) four edge
Cnnt.L32.SN = 'ABS_E_Air';
Cnnt.L32.group = 'other';
Cnnt.L32.axis1 = 'x';
Cnnt.L32.axis2 = 'z';

Cnnt.L32.Vbar1.thk = Thk.Col1.VBaratBkh;
Cnnt.L32.Vbar1.axisTT = 'y';
Cnnt.L32.Vbar1.int = 1;

Cnnt.L32.Vbar1.HspAxis = 'x';
Cnnt.L32.Vbar1.Hsp = [2550, 3250];
Cnnt.L32.Vbar1.HspTol = 0.5;
Cnnt.L32.Vbar1.HspInt = 4;
Cnnt.L32.Vbar1.SDir = 60;

%Line33 - Vbar2 (at Bkh2) four edge
Cnnt.L33.SN = 'ABS_E_Air';
Cnnt.L33.group = 'other';
Cnnt.L33.axis1 = 'x';
Cnnt.L33.axis2 = 'z';

Cnnt.L33.Vbar2.thk = Thk.Col1.VBaratBkh;
Cnnt.L33.Vbar2.axisTT = 'y';
Cnnt.L33.Vbar2.int = 1;

Cnnt.L33.Vbar2.HspAxis = 'x';
Cnnt.L33.Vbar2.Hsp = [2550, 3250];
Cnnt.L33.Vbar2.HspTol = 0.5;
Cnnt.L33.Vbar2.HspInt = 4;
Cnnt.L33.Vbar2.SDir = 60;

%Line34 - Vbar3 (at UMBVB12) four edge
Cnnt.L34.SN = 'ABS_E_Air';
Cnnt.L34.group = 'other';
Cnnt.L34.axis1 = 'x';
Cnnt.L34.axis2 = 'z';

Cnnt.L34.Vbar3.thk = Thk.Col1.VBaratTruss;
Cnnt.L34.Vbar3.axisTT = 'y';
Cnnt.L34.Vbar3.int = 1;

Cnnt.L34.Vbar3.HspAxis = 'x';
Cnnt.L34.Vbar3.Hsp = 2550;
Cnnt.L34.Vbar3.HspTol = 100;
Cnnt.L34.Vbar3.HspInt = 1;
Cnnt.L34.Vbar3.SDir = 90;

%Line35 - Vbar4 (at UMBVB12) four edge
Cnnt.L35.SN = 'ABS_E_Air';
Cnnt.L35.group = 'other';
Cnnt.L35.axis1 = 'x';
Cnnt.L35.axis2 = 'z';

Cnnt.L35.Vbar4.thk = Thk.Col1.VBaratTruss;
Cnnt.L35.Vbar4.axisTT = 'y';
Cnnt.L35.Vbar4.int = 1;
Cnnt.L35.Vbar4.HspAxis = 'x';
Cnnt.L35.Vbar4.Hsp = 2550;
Cnnt.L35.Vbar4.HspTol = 100;
Cnnt.L35.Vbar4.HspInt = 1;
Cnnt.L35.Vbar4.SDir = 90;

%Line36 - Vbar5 (at UMBVB13) four edge
Cnnt.L36.SN = 'ABS_E_Air';
Cnnt.L36.group = 'other';
Cnnt.L36.axis1 = 'x';
Cnnt.L36.axis2 = 'z';

Cnnt.L36.Vbar5.thk = Thk.Col1.VBaratTruss;
Cnnt.L36.Vbar5.axisTT = 'y';
Cnnt.L36.Vbar5.int = 1;

Cnnt.L36.Vbar5.HspAxis = 'x';
Cnnt.L36.Vbar5.Hsp = 2550;
Cnnt.L36.Vbar5.HspTol = 100;
Cnnt.L36.Vbar5.HspInt = 1;
Cnnt.L36.Vbar5.SDir = 90;

%Line37 - Vbar6 (at UMBVB13) four edge
Cnnt.L37.SN = 'ABS_E_Air';
Cnnt.L37.group = 'other';
Cnnt.L37.axis1 = 'x';
Cnnt.L37.axis2 = 'z';

Cnnt.L37.Vbar6.thk = Thk.Col1.VBaratTruss;
Cnnt.L37.Vbar6.axisTT = 'y';
Cnnt.L37.Vbar6.int = 1;

Cnnt.L37.Vbar6.HspAxis = 'x';
Cnnt.L37.Vbar6.Hsp = 2550;
Cnnt.L37.Vbar6.HspTol = 100;
Cnnt.L37.Vbar6.HspInt = 1;
Cnnt.L37.Vbar6.SDir = 90;

%Line38 - Ring1 inner edges and connection with Vbars
Cnnt.L38.SN = 'ABS_E_Air';
Cnnt.L38.group = 'other';
Cnnt.L38.axis1 = 'x';
Cnnt.L38.axis2 = 'y';

Cnnt.L38.Ring1.thk = Thk.Col1.RingatUMB;
Cnnt.L38.Ring1.axisTT = 'z';
Cnnt.L38.Ring1.int = 1;

Cnnt.L38.Ring1.HspAxis = 'x';
Cnnt.L38.Ring1.Hsp = 2500;
% Cnnt.L38.Ring1.HspSN = 'ABS_E_Air';
Cnnt.L38.Ring1.HspTol = 0.5;
Cnnt.L38.Ring1.HspInt = 2;
Cnnt.L38.Ring1.SDir = 90;

%Line39 - Ring2 inner edges and connection with Vbars
Cnnt.L39.SN = 'ABS_E_Air';
Cnnt.L39.group = 'other';
Cnnt.L39.axis1 = 'x';
Cnnt.L39.axis2 = 'y';

Cnnt.L39.Ring2.thk = Thk.Col1.RingatUMB;
Cnnt.L39.Ring2.axisTT = 'z';
Cnnt.L39.Ring2.int = 1;

Cnnt.L39.Ring2.HspAxis = 'x';
Cnnt.L39.Ring2.Hsp = 2500;
% Cnnt.L39.Ring2.HspSN = 'ABS_E_Air';
Cnnt.L39.Ring2.HspTol = 0.5;
Cnnt.L39.Ring2.HspInt = 2;
Cnnt.L39.Ring2.SDir = 90;

%Line40 - Ring3 inner edges and connection with Vbars
Cnnt.L40.SN = 'ABS_E_Air';
Cnnt.L40.group = 'other';
Cnnt.L40.axis1 = 'x';
Cnnt.L40.axis2 = 'y';

Cnnt.L40.Ring3.thk = Thk.Col1.RingatVB;
Cnnt.L40.Ring3.axisTT = 'z';
Cnnt.L40.Ring3.int = 1;

Cnnt.L40.Ring3.HspAxis = 'x';
Cnnt.L40.Ring3.Hsp = 2500;
% Cnnt.L40.Ring3.HspSN = 'ABS_E_Air';
Cnnt.L40.Ring3.HspTol = 0.5;
Cnnt.L40.Ring3.HspInt = 2;
Cnnt.L40.Ring3.SDir = 0:10:170;

%Line41 - Ring4 inner edges and connection with Vbars
Cnnt.L41.SN = 'ABS_E_Air';
Cnnt.L41.group = 'other';
Cnnt.L41.axis1 = 'x';
Cnnt.L41.axis2 = 'y';

Cnnt.L41.Ring4.thk = Thk.Col1.RingatVB;
Cnnt.L41.Ring4.axisTT = 'z';
Cnnt.L41.Ring4.int = 1;

Cnnt.L41.Ring4.HspAxis = 'x';
Cnnt.L41.Ring4.Hsp = 2500;
% Cnnt.L41.Ring4.HspSN = 'ABS_E_Air';
Cnnt.L41.Ring4.HspTol = 0.5;
Cnnt.L41.Ring4.HspInt = 2;
Cnnt.L41.Ring4.SDir = 0:10:170;

%Line42 - TBBrkt1 (at Bkh1)
Cnnt.L42.SN = 'ABS_C_Air';
Cnnt.L42.group = 'other';
Cnnt.L42.axis1 = 'x';
Cnnt.L42.axis2 = 'z';

Cnnt.L42.TBBrkt1.thk = Thk.Col1.Brkt_TBatBkh;
Cnnt.L42.TBBrkt1.axisTT = 'y';
Cnnt.L42.TBBrkt1.int = 1;

Cnnt.L42.TBBrkt1.HspAxis = 'x';
Cnnt.L42.TBBrkt1.Hsp = 3250;
Cnnt.L42.TBBrkt1.HspAxis2 = 'z';
Cnnt.L42.TBBrkt1.Hsp2 = 13000;

Cnnt.L42.TBBrkt1.HspSN = 'ABS_E_Air';
Cnnt.L42.TBBrkt1.HspTol = 15;
Cnnt.L42.TBBrkt1.HspInt = 1;
Cnnt.L42.TBBrkt1.SDir = 130;

%Line43 - TBBrkt1 (at FB1)
Cnnt.L43.SN = 'ABS_C_Air';
Cnnt.L43.group = 'other';
Cnnt.L43.axis1 = 'x';
Cnnt.L43.axis2 = 'z';

Cnnt.L43.TBBrkt2.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L43.TBBrkt2.axisTT = 'y';
Cnnt.L43.TBBrkt2.int = 1;

Cnnt.L43.TBBrkt2.HspAxis = 'x';
Cnnt.L43.TBBrkt2.Hsp = 3250;
Cnnt.L43.TBBrkt2.HspAxis2 = 'z';
Cnnt.L43.TBBrkt2.Hsp2 = 13000;

Cnnt.L43.TBBrkt2.HspSN = 'ABS_E_Air';
Cnnt.L43.TBBrkt2.HspTol = 15;
Cnnt.L43.TBBrkt2.HspInt = 1;
Cnnt.L43.TBBrkt2.SDir = 130;

%Line42 - TBBrkt1 (at OS*FB1)
Cnnt.L44.SN = 'ABS_C_Air';
Cnnt.L44.group = 'other';
Cnnt.L44.axis1 = 'x';
Cnnt.L44.axis2 = 'z';

Cnnt.L44.TBBrkt3.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L44.TBBrkt3.axisTT = 'y';
Cnnt.L44.TBBrkt3.int = 1;

Cnnt.L44.TBBrkt3.HspAxis = 'x';
Cnnt.L44.TBBrkt3.Hsp = 6000;
Cnnt.L44.TBBrkt3.HspAxis2 = 'z';
Cnnt.L44.TBBrkt3.Hsp2 = 12500;

Cnnt.L44.TBBrkt3.HspSN = 'ABS_E_Air';
Cnnt.L44.TBBrkt3.HspTol = 15;
Cnnt.L44.TBBrkt3.HspInt = 1;
Cnnt.L44.TBBrkt3.SDir = 150;

%Line45 - TBBrkt4 (at Bkh2)
Cnnt.L45.SN = 'ABS_C_Air';
Cnnt.L45.group = 'other';
Cnnt.L45.axis1 = 'x';
Cnnt.L45.axis2 = 'z';

Cnnt.L45.TBBrkt4.thk = Thk.Col1.Brkt_TBatBkh;
Cnnt.L45.TBBrkt4.axisTT = 'y';
Cnnt.L45.TBBrkt4.int = 1;

Cnnt.L45.TBBrkt4.HspAxis = 'x';
Cnnt.L45.TBBrkt4.Hsp = 3250;
Cnnt.L45.TBBrkt4.HspAxis2 = 'z';
Cnnt.L45.TBBrkt4.Hsp2 = 13000;

Cnnt.L45.TBBrkt4.HspSN = 'ABS_E_Air';
Cnnt.L45.TBBrkt4.HspTol = 15;
Cnnt.L45.TBBrkt4.HspInt = 1;
Cnnt.L45.TBBrkt4.SDir = 130;

%Line46 - TBBrkt5 (at FB2)
Cnnt.L46.SN = 'ABS_C_Air';
Cnnt.L46.group = 'other';
Cnnt.L46.axis1 = 'x';
Cnnt.L46.axis2 = 'z';

Cnnt.L46.TBBrkt5.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L46.TBBrkt5.axisTT = 'y';
Cnnt.L46.TBBrkt5.int = 1;

Cnnt.L46.TBBrkt5.HspAxis = 'x';
Cnnt.L46.TBBrkt5.Hsp = 3250;
Cnnt.L46.TBBrkt5.HspAxis2 = 'z';
Cnnt.L46.TBBrkt5.Hsp2 = 13000;

Cnnt.L46.TBBrkt5.HspSN = 'ABS_E_Air';
Cnnt.L46.TBBrkt5.HspTol = 15;
Cnnt.L46.TBBrkt5.HspInt = 1;
Cnnt.L46.TBBrkt5.SDir = 130;

%Line47 - TBBrkt6 (at OS*FB2)
Cnnt.L47.SN = 'ABS_C_Air';
Cnnt.L47.group = 'other';
Cnnt.L47.axis1 = 'x';
Cnnt.L47.axis2 = 'z';

Cnnt.L47.TBBrkt6.thk = Thk.Col1.Brkt_TBatFB;
Cnnt.L47.TBBrkt6.axisTT = 'y';
Cnnt.L47.TBBrkt6.int = 1;

Cnnt.L47.TBBrkt6.HspAxis = 'x';
Cnnt.L47.TBBrkt6.Hsp = 6000;
Cnnt.L47.TBBrkt6.HspAxis2 = 'z';
Cnnt.L47.TBBrkt6.Hsp2 = 12500;

Cnnt.L47.TBBrkt6.HspSN = 'ABS_E_Air';
Cnnt.L47.TBBrkt6.HspTol = 15;
Cnnt.L47.TBBrkt6.HspInt = 1;
Cnnt.L47.TBBrkt6.SDir = 150;

%L48 - TOC ring * Vbars
Cnnt.L48.SN = 'ABS_E_Air';
Cnnt.L48.group = 'other';
Cnnt.L48.axis1 = 'y';
Cnnt.L48.axis2 = 'x';

Cnnt.L48.TOCring.thk = Thk.Col1.TOCring;
Cnnt.L48.TOCring.axisTT = 'z';
Cnnt.L48.TOCring.int = 1;

Cnnt.L48.TOCring.HspAxis = 'x';
Cnnt.L48.TOCring.Hsp = 2500;
Cnnt.L48.TOCring.HspTol = 0.5;
Cnnt.L48.TOCring.HspInt = 8;
Cnnt.L48.TOCring.HspSN = 'ABS_C_Air';
Cnnt.L48.TOCring.SDir = 90;

%Line49 - Vbar1 (at Bkh1) free edges
Cnnt.L49.SN = 'ABS_C_Air';
Cnnt.L49.group = 'circ';
Cnnt.L49.axis = 'z';

Cnnt.L49.Vbar1.thk = Thk.Col1.VBaratBkh;
Cnnt.L49.Vbar1.axisTT = 'y';
Cnnt.L49.Vbar1.int = 2;

Cnnt.L49.Vbar1.Hsp = [7169.9, 7550.3, 9311, 10844, 12356];
Cnnt.L49.Vbar1.HspTol = 200;
Cnnt.L49.Vbar1.SDir = 90;

%Line50 - Vbar2 (at Bkh1) free edges
Cnnt.L50.SN = 'ABS_C_Air';
Cnnt.L50.group = 'circ';
Cnnt.L50.axis = 'z';

Cnnt.L50.Vbar2.thk = Thk.Col1.VBaratBkh;
Cnnt.L50.Vbar2.axisTT = 'y';
Cnnt.L50.Vbar2.int = 2;

Cnnt.L50.Vbar2.Hsp = [7169.9, 7550.3, 9311, 10844, 12356];
Cnnt.L50.Vbar2.HspTol = 200;
Cnnt.L50.Vbar2.SDir = 90;

%Line51 - Vbar3 (at Truss) free edges
Cnnt.L51.SN = 'ABS_C_Air';
Cnnt.L51.group = 'circ';
Cnnt.L51.axis = 'z';

Cnnt.L51.Vbar3.thk = Thk.Col1.VBaratTruss;
Cnnt.L51.Vbar3.axisTT = 'y';
Cnnt.L51.Vbar3.int = 2;

Cnnt.L51.Vbar3.Hsp = [7169.9, 7550.3, 7725.3, 9223.5, 9398.5, 10406, 11281, 12356, 13000];
Cnnt.L51.Vbar3.HspTol = 60;
Cnnt.L51.Vbar3.SDir = 90;

%Line52 - Vbar4 (at Truss) free edges
Cnnt.L52.SN = 'ABS_C_Air';
Cnnt.L52.group = 'circ';
Cnnt.L52.axis = 'z';

Cnnt.L52.Vbar4.thk = Thk.Col1.VBaratTruss;
Cnnt.L52.Vbar4.axisTT = 'y';
Cnnt.L52.Vbar4.int = 2;

Cnnt.L52.Vbar4.Hsp = [7169.9, 7550.3, 7725.3, 9223.5, 9398.5, 10406, 11281, 12356, 13000];
Cnnt.L52.Vbar4.HspTol = 60;
Cnnt.L52.Vbar4.SDir = 90;

%Line53 - Vbar5 (at Truss) free edges
Cnnt.L53.SN = 'ABS_C_Air';
Cnnt.L53.group = 'circ';
Cnnt.L53.axis = 'z';

Cnnt.L53.Vbar5.thk = Thk.Col1.VBaratTruss;
Cnnt.L53.Vbar5.axisTT = 'y';
Cnnt.L53.Vbar5.int = 2;

Cnnt.L53.Vbar5.Hsp = [7169.9, 7550.3, 7725.3, 9223.5, 9398.5, 10406, 11281, 12356, 13000];
Cnnt.L53.Vbar5.HspTol = 60;
Cnnt.L53.Vbar5.SDir = 90;

%Line54 - Vbar6 (at Truss) free edges
Cnnt.L54.SN = 'ABS_C_Air';
Cnnt.L54.group = 'circ';
Cnnt.L54.axis = 'z';

Cnnt.L54.Vbar6.thk = Thk.Col1.VBaratTruss;
Cnnt.L54.Vbar6.axisTT = 'y';
Cnnt.L54.Vbar6.int = 2;

Cnnt.L54.Vbar6.Hsp = [7169.9, 7550.3, 7725.3, 9223.5, 9398.5, 10406, 11281, 12356, 13000];
Cnnt.L54.Vbar6.HspTol = 60;
Cnnt.L54.Vbar6.SDir = 90;

%Line55 - Ring1 free edges
Cnnt.L55.SN = 'ABS_C_Air';
Cnnt.L55.group = 'circ';
Cnnt.L55.axis = 'y';

Cnnt.L55.Ring1.thk = Thk.Col1.RingatUMB;
Cnnt.L55.Ring1.axisTT = 'z';
Cnnt.L55.Ring1.int = 10;
Cnnt.L55.Ring1.SDir = 90;

%Line56 - Ring2 free edges
Cnnt.L56.SN = 'ABS_C_Air';
Cnnt.L56.group = 'circ';
Cnnt.L56.axis = 'y';

Cnnt.L56.Ring2.thk = Thk.Col1.RingatUMB;
Cnnt.L56.Ring2.axisTT = 'z';
Cnnt.L56.Ring2.int = 10;
Cnnt.L56.Ring2.SDir = 90;

%Line57 - Ring3 free edges
Cnnt.L57.SN = 'ABS_C_Air';
Cnnt.L57.group = 'circ';
Cnnt.L57.axis = 'y';

Cnnt.L57.Ring3.thk = Thk.Col1.RingatVB;
Cnnt.L57.Ring3.axisTT = 'z';
Cnnt.L57.Ring3.int = 10;
Cnnt.L57.Ring3.SDir = 90;

%Line58 - Ring4 free edges
Cnnt.L58.SN = 'ABS_C_Air';
Cnnt.L58.group = 'circ';
Cnnt.L58.axis = 'y';

Cnnt.L58.Ring4.thk = Thk.Col1.RingatVB;
Cnnt.L58.Ring4.axisTT = 'z';
Cnnt.L58.Ring4.int = 10;
Cnnt.L58.Ring4.SDir = 90;

OutName = [path1 'CnntInfo.mat'];
save(OutName, 'Cnnt')

%% ItrR5_16_0_6 (K-Joint)
ItrNo = 'ItrR5_16_0_6';
path1 = [path0 ItrNo '\'];
load([path1 'thickness.mat']);

Cnnt.Itr = ItrNo;

%Line401 - LMB12 * VB12
Cnnt.L401.SN = 'API_WJ_CP';
Cnnt.L401.group = 'circ';
Cnnt.L401.axis = 'y';

Cnnt.L401.LMB12.thk = Thk.KJnt.LMB12;
Cnnt.L401.LMB12.int = 1;
Cnnt.L401.LMB12.axisTT = 'x'; %through-thickness axis
Cnnt.L401.LMB12.SDir = 90; %degree

Cnnt.L401.VB12.thk = Thk.KJnt.VB12;
Cnnt.L401.VB12.int = 1;
Cnnt.L401.VB12.axisTT = 'x'; %through-thickness axis

%Line402 - LMB12 * VB21
Cnnt.L402.SN = 'API_WJ_CP';
Cnnt.L402.group = 'circ';
Cnnt.L402.axis = 'y';

Cnnt.L402.LMB12.thk = Thk.KJnt.LMB12;
Cnnt.L402.LMB12.int = 1;
Cnnt.L402.LMB12.axisTT = 'x'; %through-thickness axis
Cnnt.L402.LMB12.SDir = 90; %degree

Cnnt.L402.VB21.thk = Thk.KJnt.VB12;
Cnnt.L402.VB21.int = 1;
Cnnt.L402.VB21.axisTT = 'x'; %through-thickness axis

%Line403 - LMB13 * VB13
Cnnt.L403.SN = 'API_WJ_CP';
Cnnt.L403.group = 'circ';
Cnnt.L403.axis = 'y';

Cnnt.L403.LMB13.thk = Thk.KJnt.LMB12;
Cnnt.L403.LMB13.int = 1;
Cnnt.L403.LMB13.axisTT = 'x'; %through-thickness axis
Cnnt.L403.LMB13.SDir = 90; %degree

Cnnt.L403.VB13.thk = Thk.KJnt.VB12;
Cnnt.L403.VB13.int = 1;
Cnnt.L403.VB13.axisTT = 'x'; %through-thickness axis

%Line404 - LMB13 * VB31
Cnnt.L404.SN = 'API_WJ_CP';
Cnnt.L404.group = 'circ';
Cnnt.L404.axis = 'y';

Cnnt.L404.LMB13.thk = Thk.KJnt.LMB12;
Cnnt.L404.LMB13.int = 1;
Cnnt.L404.LMB13.axisTT = 'x'; %through-thickness axis
Cnnt.L404.LMB13.SDir = 90; %degree

Cnnt.L404.VB31.thk = Thk.KJnt.VB12;
Cnnt.L404.VB31.int = 1;
Cnnt.L404.VB31.axisTT = 'x'; %through-thickness axis

%Line405 - LMB23 * VB23
Cnnt.L405.SN = 'API_WJ_CP';
Cnnt.L405.group = 'circ';
Cnnt.L405.axis = 'y';

Cnnt.L405.LMB23.thk = Thk.KJnt.LMB23;
Cnnt.L405.LMB23.int = 2;
Cnnt.L405.LMB23.axisTT = 'x'; %through-thickness axis
Cnnt.L405.LMB23.SDir = 90; %degree

Cnnt.L405.VB23.thk = Thk.KJnt.VB23;
Cnnt.L405.VB23.int = 2;
Cnnt.L405.VB23.axisTT = 'x'; %through-thickness axis

%Line406 - LMB23 * VB32
Cnnt.L406.SN = 'API_WJ_CP';
Cnnt.L406.group = 'circ';
Cnnt.L406.axis = 'y';

Cnnt.L406.LMB23.thk = Thk.KJnt.LMB23;
Cnnt.L406.LMB23.int = 2;
Cnnt.L406.LMB23.axisTT = 'x'; %through-thickness axis
Cnnt.L406.LMB23.SDir = 90; %degree

Cnnt.L406.VB32.thk = Thk.KJnt.VB23;
Cnnt.L406.VB32.int = 2;
Cnnt.L406.VB32.axisTT = 'x'; %through-thickness axis

%Line415 - LMB12 * FB12
Cnnt.L415.SN = 'ABS_E_CP';
Cnnt.L415.group = 'circ';
Cnnt.L415.axis = 'z';

Cnnt.L415.LMB12.thk = Thk.Nominal.LMB;
Cnnt.L415.LMB12.int = 1;
Cnnt.L415.LMB12.axisTT = 'x'; %through-thickness axis

Cnnt.L415.LMB12.Hsp = -1386;
Cnnt.L415.LMB12.HspTol = 250;
Cnnt.L415.LMB12.HspThk = Thk.Nominal.LMBinst;

Cnnt.L415.FB12.thk = Thk.Nominal.FB;
Cnnt.L415.FB12.int = 1;
Cnnt.L415.FB12.axisTT = 'y'; %through-thickness axis

%Line416 - LMB13 * FB13
Cnnt.L416.SN = 'ABS_E_CP';
Cnnt.L416.group = 'circ';
Cnnt.L416.axis = 'z';

Cnnt.L416.LMB13.thk = Thk.Nominal.LMB;
Cnnt.L416.LMB13.int = 1;
Cnnt.L416.LMB13.axisTT = 'x'; %through-thickness axis

Cnnt.L416.LMB13.Hsp = -1386;
Cnnt.L416.LMB13.HspTol = 250;
Cnnt.L416.LMB13.HspThk = Thk.Nominal.LMBinst;

Cnnt.L416.FB13.thk = Thk.Nominal.FB;
Cnnt.L416.FB13.int = 1;
Cnnt.L416.FB13.axisTT = 'y'; %through-thickness axis

%Line417 - LMB21 * FB21
Cnnt.L417.SN = 'ABS_E_CP';
Cnnt.L417.group = 'circ';
Cnnt.L417.axis = 'z';

Cnnt.L417.LMB21.thk = Thk.Nominal.LMB;
Cnnt.L417.LMB21.int = 1;
Cnnt.L417.LMB21.axisTT = 'x'; %through-thickness axis

Cnnt.L417.LMB21.Hsp = 11085;
Cnnt.L417.LMB21.HspTol = 250;
Cnnt.L417.LMB21.HspThk = Thk.Nominal.LMBinst;

Cnnt.L417.FB21.thk = Thk.Nominal.FB;
Cnnt.L417.FB21.int = 1;
Cnnt.L417.FB21.axisTT = 'y'; %through-thickness axis

%Line418 - LMB13 * FB31
Cnnt.L418.SN = 'ABS_E_CP';
Cnnt.L418.group = 'circ';
Cnnt.L418.axis = 'z';

Cnnt.L418.LMB31.thk = Thk.Nominal.LMB;
Cnnt.L418.LMB31.int = 1;
Cnnt.L418.LMB31.axisTT = 'x'; %through-thickness axis

Cnnt.L418.LMB31.Hsp = 11085;
Cnnt.L418.LMB31.HspTol = 250;
Cnnt.L418.LMB31.HspThk = Thk.Nominal.LMBinst;

Cnnt.L418.FB31.thk = Thk.Nominal.FB;
Cnnt.L418.FB31.int = 1;
Cnnt.L418.FB31.axisTT = 'y'; %through-thickness axis

%Line421 - LMB12 * Brkt12
Cnnt.L421.SN = 'ABS_E_CP';
Cnnt.L421.group = 'circ';
Cnnt.L421.axis = 'z';

Cnnt.L421.LMB12.thk = Thk.KJnt.LMB12;
Cnnt.L421.LMB12.int = 1;
Cnnt.L421.LMB12.axisTT = 'x'; %through-thickness axis
Cnnt.L421.LMB12.SDir = 90; %degree

Cnnt.L421.Brkt12.thk = Thk.KJnt.Brkt;
Cnnt.L421.Brkt12.int = 1;
Cnnt.L421.Brkt12.axisTT = 'y'; %through-thickness axis

%Line422 - LMB12 * Brkt21
Cnnt.L422.SN = 'ABS_E_CP';
Cnnt.L422.group = 'circ';
Cnnt.L422.axis = 'z';

Cnnt.L422.LMB12.thk = Thk.KJnt.LMB12;
Cnnt.L422.LMB12.int = 1;
Cnnt.L422.LMB12.axisTT = 'x'; %through-thickness axis
Cnnt.L422.LMB12.SDir = 90; %degree

Cnnt.L422.Brkt21.thk = Thk.KJnt.Brkt;
Cnnt.L422.Brkt21.int = 1;
Cnnt.L422.Brkt21.axisTT = 'y'; %through-thickness axis

%Line423 - LMB13 * Brkt13
Cnnt.L423.SN = 'ABS_E_CP';
Cnnt.L423.group = 'circ';
Cnnt.L423.axis = 'z';

Cnnt.L423.LMB13.thk = Thk.KJnt.LMB12;
Cnnt.L423.LMB13.int = 1;
Cnnt.L423.LMB13.axisTT = 'x'; %through-thickness axis
Cnnt.L423.LMB13.SDir = 90; %degree

Cnnt.L423.Brkt13.thk = Thk.KJnt.Brkt;
Cnnt.L423.Brkt13.int = 1;
Cnnt.L423.Brkt13.axisTT = 'y'; %through-thickness axis

%Line424 - LMB13 * Brkt31
Cnnt.L424.SN = 'ABS_E_CP';
Cnnt.L424.group = 'circ';
Cnnt.L424.axis = 'z';

Cnnt.L424.LMB13.thk = Thk.KJnt.LMB12;
Cnnt.L424.LMB13.int = 1;
Cnnt.L424.LMB13.axisTT = 'x'; %through-thickness axis
Cnnt.L424.LMB13.SDir = 90; %degree

Cnnt.L424.Brkt31.thk = Thk.KJnt.Brkt;
Cnnt.L424.Brkt31.int = 1;
Cnnt.L424.Brkt31.axisTT = 'y'; %through-thickness axis

%Line425 - LMB23 * Brkt23
Cnnt.L425.SN = 'ABS_E_CP';
Cnnt.L425.group = 'circ';
Cnnt.L425.axis = 'z';

Cnnt.L425.LMB23.thk = Thk.KJnt.LMB23;
Cnnt.L425.LMB23.int = 1;
Cnnt.L425.LMB23.axisTT = 'x'; %through-thickness axis
Cnnt.L425.LMB23.SDir = 90; %degree

Cnnt.L425.Brkt23.thk = Thk.KJnt.Brkt;
Cnnt.L425.Brkt23.int = 1;
Cnnt.L425.Brkt23.axisTT = 'y'; %through-thickness axis

%Line426 - LMB23 * Brkt32
Cnnt.L426.SN = 'ABS_E_CP';
Cnnt.L426.group = 'circ';
Cnnt.L426.axis = 'z';

Cnnt.L426.LMB23.thk = Thk.KJnt.LMB23;
Cnnt.L426.LMB23.int = 1;
Cnnt.L426.LMB23.axisTT = 'x'; %through-thickness axis
Cnnt.L426.LMB23.SDir = 90; %degree

Cnnt.L426.Brkt32.thk = Thk.KJnt.Brkt;
Cnnt.L426.Brkt32.int = 1;
Cnnt.L426.Brkt32.axisTT = 'y'; %through-thickness axis

OutName = [path1 'CnntInfo.mat'];
save(OutName, 'Cnnt')

%% Itr23_01 WFA Mooring Connector Analysis - Columns 2 & 3 model
% ItrNo = 'Itr3_01';
path1 = [path0 ItrNo '\'];
load([path1 'thickness.mat']);

Cnnt.Itr = ItrNo;

%Line1 - L201_MCatt_Pin
Cnnt.L201.SN = 'ABS_E_CP';
Cnnt.L201.group = 'circ';
Cnnt.L201.axis = 'y';

Cnnt.L201.MCatt.thk = Thk.Col23.MCatt;
Cnnt.L201.MCatt.int = 3;
Cnnt.L201.MCatt.axisTT = 'z'; %through-thickness axis
Cnnt.L201.MCatt.SDir = 90; %degree

%Line2 - L202_MC_Pin
Cnnt.L202.SN = 'ABS_E_CP';
Cnnt.L202.group = 'circ';
Cnnt.L202.axis = 'y';

Cnnt.L202.MCatt.thk = Thk.Col23.MCatt;
Cnnt.L202.MCatt.int = 3;
Cnnt.L202.MCatt.axisTT = 'z'; %through-thickness axis
Cnnt.L202.MCatt.SDir = 90; %degree

%Line3 - L203_MC_Bracket
Cnnt.L203.SN = 'ABS_E_CP';
Cnnt.L203.group = 'circ';
Cnnt.L203.axis = 'x';

Cnnt.L203.MC.thk = Thk.Col23.MC;
Cnnt.L203.MC.axisTT = 'z';
Cnnt.L203.MC.int = 1;
Cnnt.L203.MC.SDir = 90; %degree

Cnnt.L203.Bracket.thk = Thk.Col23.Bracket;
Cnnt.L203.Bracket.axisTT = 'y';
Cnnt.L203.Bracket.int = 1;
Cnnt.L203.Bracket.SDir = 90; %degree

%Line4 - L204_OS_Bracket
Cnnt.L204.SN = 'ABS_E_CP';
Cnnt.L204.group = 'circ';
Cnnt.L204.axis = 'z';

Cnnt.L204.OS.thk = Thk.Col23.OS;
Cnnt.L204.OS.axisTT = 'x';
Cnnt.L204.OS.int = 1;
Cnnt.L204.OS.SDir = 90; %degree

Cnnt.L204.Bracket.thk = Thk.Col23.Bracket;
Cnnt.L204.Bracket.axisTT = 'y';
Cnnt.L204.Bracket.int = 1;
Cnnt.L204.Bracket.SDir = 90; %degree

%Line5.1 - L2051_OS_MC
Cnnt.L2051.SN = 'ABS_E_CP';
Cnnt.L2051.group = 'circ';
Cnnt.L2051.axis = 'y';

Cnnt.L2051.MC.thk = Thk.Col23.MC;
Cnnt.L2051.MC.int = 3;
Cnnt.L2051.MC.axisTT = 'z'; %through-thickness axis
Cnnt.L2051.MC.SDir = 90; %degree

Cnnt.L2051.OS.thk = Thk.Col23.OS;
Cnnt.L2051.OS.int = 3;
Cnnt.L2051.OS.axisTT = 'x'; %through-thickness axis
Cnnt.L2051.OS.SDir = 90; %degree

%Line5.2 - L2052_OS_MC
Cnnt.L2052.SN = 'ABS_E_CP';
Cnnt.L2052.group = 'circ';
Cnnt.L2052.axis = 'z';

Cnnt.L2052.OS.thk = Thk.Col23.OS;
Cnnt.L2052.OS.axisTT = 'x';
Cnnt.L2052.OS.int = 3;
Cnnt.L2052.OS.SDir = 90; %degree

Cnnt.L2052.MC.thk = Thk.Col23.MC;
Cnnt.L2052.MC.axisTT = 'z';
Cnnt.L2052.MC.int = 3;
Cnnt.L2052.MC.SDir = 90; %degree

%Line5.3 - L2053_OS_MC
Cnnt.L2053.SN = 'ABS_E_CP';
Cnnt.L2053.group = 'circ';
Cnnt.L2053.axis = 'z';

Cnnt.L2053.OS.thk = Thk.Col23.OS;
Cnnt.L2053.OS.axisTT = 'x';
Cnnt.L2053.OS.int = 3;
Cnnt.L2053.OS.SDir = 90; %degree

Cnnt.L2053.MC.thk = Thk.Col23.MC;
Cnnt.L2053.MC.axisTT = 'z';
Cnnt.L2053.MC.int = 3;
Cnnt.L2053.MC.SDir = 90; %degree

%Line6 - L206_OS_StN
Cnnt.L206.SN = 'ABS_E_CP';
Cnnt.L206.group = 'circ';
Cnnt.L206.axis = 'z';

Cnnt.L206.OS.thk = Thk.Col23.OS;
Cnnt.L206.OS.axisTT = 'x';
Cnnt.L206.OS.int = 1;
Cnnt.L206.OS.SDir = 90; %degree

Cnnt.L206.StN.thk = Thk.Col23.StN;
Cnnt.L206.StN.axisTT = 'y';
Cnnt.L206.StN.int = 1;
Cnnt.L206.StN.SDir = 90; %degree

%Line7.1 - L2071_StN_FlN
Cnnt.L2071.SN = 'ABS_E_CP';
Cnnt.L2071.group = 'circ';
Cnnt.L2071.axis = 'x';

Cnnt.L2071.FlN.thk = Thk.Col23.FlN;
Cnnt.L2071.FlN.axisTT = 'z';
Cnnt.L2071.FlN.int = 1;
Cnnt.L2071.FlN.SDir = 90; %degree

Cnnt.L2071.StN.thk = Thk.Col23.StN;
Cnnt.L2071.StN.axisTT = 'y';
Cnnt.L2071.StN.int = 1;
Cnnt.L2071.StN.SDir = 90; %degree

%Line7.2 - L2072_StN_FlN
Cnnt.L2072.SN = 'ABS_E_CP';
Cnnt.L2072.group = 'circ';
Cnnt.L2072.axis = 'z';

Cnnt.L2072.StN.thk = Thk.Col23.StN;
Cnnt.L2072.StN.int = 1;
Cnnt.L2072.StN.axisTT = 'y'; %through-thickness axis
Cnnt.L2072.StN.SDir = 90; %degree

Cnnt.L2072.FlN.thk = Thk.Col23.FlN;
Cnnt.L2072.FlN.int = 1;
Cnnt.L2072.FlN.axisTT = 'x'; %through-thickness axis
Cnnt.L2072.FlN.SDir = 90; %degree

%Line7.3 - L2073_StN_FlN
Cnnt.L2073.SN = 'ABS_E_CP';
Cnnt.L2073.group = 'circ';
Cnnt.L2073.axis = 'z';

Cnnt.L2073.FlN.thk = Thk.Col23.FlN;
Cnnt.L2073.FlN.axisTT = 'z';
Cnnt.L2073.FlN.int = 1;
Cnnt.L2073.FlN.SDir = 90; %degree

Cnnt.L2073.StN.thk = Thk.Col23.StN;
Cnnt.L2073.StN.axisTT = 'y';
Cnnt.L2073.StN.int = 1;
Cnnt.L2073.StN.SDir = 90; %degree

%Line8 - L208_Rg850_OS
Cnnt.L208.SN = 'ABS_E_CP';
Cnnt.L208.group = 'circ';
Cnnt.L208.axis = 'y';

Cnnt.L208.Rg850.thk = Thk.Col23.Rg850;
Cnnt.L208.Rg850.int = 3;
Cnnt.L208.Rg850.axisTT = 'z'; %through-thickness axis
Cnnt.L208.Rg850.SDir = 90; %degree

%Line9 - L209_Keel_MC
Cnnt.L209.SN = 'ABS_E_CP';
Cnnt.L209.group = 'circ';
Cnnt.L209.axis = 'y';

Cnnt.L209.MC.thk = Thk.Col23.MC;
Cnnt.L209.MC.int = 3;
Cnnt.L209.MC.axisTT = 'z'; %through-thickness axis
Cnnt.L209.MC.SDir = 90; %degree

Cnnt.L209.Keel.thk = Thk.Col23.Keel;
Cnnt.L209.Keel.int = 3;
Cnnt.L209.Keel.axisTT = 'z'; %through-thickness axis
Cnnt.L209.Keel.SDir = 90; %degree

%Line10.1 - L2101_OS_MCrf
Cnnt.L2101.SN = 'ABS_E_CP';
Cnnt.L2101.group = 'circ';
Cnnt.L2101.axis = 'z';

Cnnt.L2101.MCrf.thk = Thk.Col23.MCrf;
Cnnt.L2101.MCrf.axisTT = 'z';
Cnnt.L2101.MCrf.int = 3;
Cnnt.L2101.MCrf.SDir = 90; %degree

%Line10.2 - L2102_OS_MCrf
Cnnt.L2102.SN = 'ABS_E_CP';
Cnnt.L2102.group = 'circ';
Cnnt.L2102.axis = 'z';

Cnnt.L2102.MCrf.thk = Thk.Col23.MCrf;
Cnnt.L2102.MCrf.axisTT = 'z';
Cnnt.L2102.MCrf.int = 3;
Cnnt.L2102.MCrf.SDir = 90; %degree

%Line11 - L211_OS_MC
Cnnt.L211.SN = 'ABS_E_CP';
Cnnt.L211.group = 'circ';
Cnnt.L211.axis = 'y';

Cnnt.L211.Keel.thk = Thk.Col23.Keel;
Cnnt.L211.Keel.int = 3;
Cnnt.L211.Keel.axisTT = 'z'; %through-thickness axis
Cnnt.L211.Keel.SDir = 90; %degree

Cnnt.L211.OS.thk = Thk.Col23.OS;
Cnnt.L211.OS.int = 3;
Cnnt.L211.OS.axisTT = 'x'; %through-thickness axis
Cnnt.L211.OS.SDir = 90; %degree


OutName = [path1 'CnntInfo.mat'];
save(OutName, 'Cnnt')

%%
%% Itr1_01 WFA Mooring Connector Analysis - Column 1 model
% ItrNo = 'Itr1_01';
path1 = [path0 ItrNo '\'];
load([path1 'thickness.mat']);

Cnnt.Itr = ItrNo;

%Line1 - L101_MCatt_Pin
Cnnt.L101.SN = 'ABS_E_CP';
Cnnt.L101.group = 'circ';
Cnnt.L101.axis = 'y';

Cnnt.L101.MCatt.thk = Thk.Col1.MCatt;
Cnnt.L101.MCatt.int = 3;
Cnnt.L101.MCatt.axisTT = 'z'; %through-thickness axis
Cnnt.L101.MCatt.SDir = 90; %degree

%Line2 - L102_MCatt_Pin
Cnnt.L102.SN = 'ABS_E_CP';
Cnnt.L102.group = 'circ';
Cnnt.L102.axis = 'y';

Cnnt.L102.MCatt.thk = Thk.Col1.MCatt;
Cnnt.L102.MCatt.int = 3;
Cnnt.L102.MCatt.axisTT = 'z'; %through-thickness axis
Cnnt.L102.MCatt.SDir = 90; %degree

%Line3 - L103_MC_Bracket
Cnnt.L103.SN = 'ABS_E_CP';
Cnnt.L103.group = 'circ';
Cnnt.L103.axis = 'x';

Cnnt.L103.MC.thk = Thk.Col1.MC;
Cnnt.L103.MC.axisTT = 'z';
Cnnt.L103.MC.int = 1;
Cnnt.L103.MC.SDir = 90; %degree

Cnnt.L103.Bracket.thk = Thk.Col1.Bracket;
Cnnt.L103.Bracket.axisTT = 'y';
Cnnt.L103.Bracket.int = 1;
Cnnt.L103.Bracket.SDir = 90; %degree

%Line4 - L104_OS_Bracket
Cnnt.L104.SN = 'ABS_E_CP';
Cnnt.L104.group = 'circ';
Cnnt.L104.axis = 'z';

Cnnt.L104.OS.thk = Thk.Col1.OS;
Cnnt.L104.OS.axisTT = 'x';
Cnnt.L104.OS.int = 1;
Cnnt.L104.OS.SDir = 90; %degree

Cnnt.L104.Bracket.thk = Thk.Col1.Bracket;
Cnnt.L104.Bracket.axisTT = 'y';
Cnnt.L104.Bracket.int = 1;
Cnnt.L104.Bracket.SDir = 90; %degree

%Line5.1 - L1051_OS_MC
Cnnt.L1051.SN = 'ABS_E_CP';
Cnnt.L1051.group = 'circ';
Cnnt.L1051.axis = 'y';

Cnnt.L1051.MC.thk = Thk.Col1.MC;
Cnnt.L1051.MC.int = 3;
Cnnt.L1051.MC.axisTT = 'z'; %through-thickness axis
Cnnt.L1051.MC.SDir = 90; %degree

Cnnt.L1051.OS.thk = Thk.Col1.OS;
Cnnt.L1051.OS.int = 3;
Cnnt.L1051.OS.axisTT = 'x'; %through-thickness axis
Cnnt.L1051.OS.SDir = 90; %degree

%Line5.2 - L1052_OS_MC
Cnnt.L1052.SN = 'ABS_E_CP';
Cnnt.L1052.group = 'circ';
Cnnt.L1052.axis = 'z';

Cnnt.L1052.OS.thk = Thk.Col1.OS;
Cnnt.L1052.OS.axisTT = 'x';
Cnnt.L1052.OS.int = 3;
Cnnt.L1052.OS.SDir = 90; %degree

Cnnt.L1052.MC.thk = Thk.Col1.MC;
Cnnt.L1052.MC.axisTT = 'z';
Cnnt.L1052.MC.int = 3;
Cnnt.L1052.MC.SDir = 90; %degree

%Line5.3 - L1053_OS_MC
Cnnt.L1053.SN = 'ABS_E_CP';
Cnnt.L1053.group = 'circ';
Cnnt.L1053.axis = 'z';

Cnnt.L1053.OS.thk = Thk.Col1.OS;
Cnnt.L1053.OS.axisTT = 'x';
Cnnt.L1053.OS.int = 3;
Cnnt.L1053.OS.SDir = 90; %degree

Cnnt.L1053.MC.thk = Thk.Col1.MC;
Cnnt.L1053.MC.axisTT = 'z';
Cnnt.L1053.MC.int = 3;
Cnnt.L1053.MC.SDir = 90; %degree


%Line6 - L106_OS_StN
Cnnt.L106.SN = 'ABS_E_CP';
Cnnt.L106.group = 'circ';
Cnnt.L106.axis = 'z';

Cnnt.L106.OS.thk = Thk.Col1.OS;
Cnnt.L106.OS.axisTT = 'x';
Cnnt.L106.OS.int = 1;
Cnnt.L106.OS.SDir = 90; %degree

Cnnt.L106.StN.thk = Thk.Col1.StN;
Cnnt.L106.StN.axisTT = 'y';
Cnnt.L106.StN.int = 1;
Cnnt.L106.StN.SDir = 90; %degree

%Line7.1 - L1071_StN_FlN
Cnnt.L1071.SN = 'ABS_E_CP';
Cnnt.L1071.group = 'circ';
Cnnt.L1071.axis = 'x';

Cnnt.L1071.FlN.thk = Thk.Col1.FlN;
Cnnt.L1071.FlN.axisTT = 'z';
Cnnt.L1071.FlN.int = 1;
Cnnt.L1071.FlN.SDir = 90; %degree

Cnnt.L1071.StN.thk = Thk.Col1.StN;
Cnnt.L1071.StN.axisTT = 'y';
Cnnt.L1071.StN.int = 1;
Cnnt.L1071.StN.SDir = 90; %degree

%Line7.2 - L1072_StN_FlN
Cnnt.L1072.SN = 'ABS_E_CP';
Cnnt.L1072.group = 'circ';
Cnnt.L1072.axis = 'z';

Cnnt.L1072.StN.thk = Thk.Col1.StN;
Cnnt.L1072.StN.int = 1;
Cnnt.L1072.StN.axisTT = 'y'; %through-thickness axis
Cnnt.L1072.StN.SDir = 90; %degree

Cnnt.L1072.FlN.thk = Thk.Col1.FlN;
Cnnt.L1072.FlN.int = 1;
Cnnt.L1072.FlN.axisTT = 'x'; %through-thickness axis
Cnnt.L1072.FlN.SDir = 90; %degree

%Line7.3 - L1073_StN_FlN
Cnnt.L1073.SN = 'ABS_E_CP';
Cnnt.L1073.group = 'circ';
Cnnt.L1073.axis = 'z';

Cnnt.L1073.FlN.thk = Thk.Col1.FlN;
Cnnt.L1073.FlN.axisTT = 'z';
Cnnt.L1073.FlN.int = 1;
Cnnt.L1073.FlN.SDir = 90; %degree

Cnnt.L1073.StN.thk = Thk.Col1.StN;
Cnnt.L1073.StN.axisTT = 'y';
Cnnt.L1073.StN.int = 1;
Cnnt.L1073.StN.SDir = 90; %degree

%Line8 - L108_Rg850_OS
Cnnt.L108.SN = 'ABS_E_CP';
Cnnt.L108.group = 'circ';
Cnnt.L108.axis = 'y';

Cnnt.L108.Rg850.thk = Thk.Col1.Rg850;
Cnnt.L108.Rg850.int = 3;
Cnnt.L108.Rg850.axisTT = 'z'; %through-thickness axis
Cnnt.L108.Rg850.SDir = 90; %degree

%Line9 - L109_Keel_MC
Cnnt.L109.SN = 'ABS_E_CP';
Cnnt.L109.group = 'circ';
Cnnt.L109.axis = 'y';

Cnnt.L109.MC.thk = Thk.Col1.MC;
Cnnt.L109.MC.int = 3;
Cnnt.L109.MC.axisTT = 'z'; %through-thickness axis
Cnnt.L109.MC.SDir = 90; %degree

Cnnt.L109.Keel.thk = Thk.Col1.Keel;
Cnnt.L109.Keel.int = 3;
Cnnt.L109.Keel.axisTT = 'z'; %through-thickness axis
Cnnt.L109.Keel.SDir = 90; %degree

%Line10.1 - L1101_OS_MCrf
Cnnt.L1101.SN = 'ABS_E_CP';
Cnnt.L1101.group = 'circ';
Cnnt.L1101.axis = 'z';

Cnnt.L1101.MCrf.thk = Thk.Col1.MCrf;
Cnnt.L1101.MCrf.axisTT = 'z';
Cnnt.L1101.MCrf.int = 3;
Cnnt.L1101.MCrf.SDir = 90; %degree

%Line10.2 - L1102_OS_MCrf
Cnnt.L1102.SN = 'ABS_E_CP';
Cnnt.L1102.group = 'circ';
Cnnt.L1102.axis = 'z';

Cnnt.L1102.MCrf.thk = Thk.Col1.MCrf;
Cnnt.L1102.MCrf.axisTT = 'z';
Cnnt.L1102.MCrf.int = 3;
Cnnt.L1102.MCrf.SDir = 90; %degree

%Line11 - L111_OS_MC
Cnnt.L111.SN = 'ABS_E_CP';
Cnnt.L111.group = 'circ';
Cnnt.L111.axis = 'y';

Cnnt.L111.Keel.thk = Thk.Col1.Keel;
Cnnt.L111.Keel.int = 3;
Cnnt.L111.Keel.axisTT = 'z'; %through-thickness axis
Cnnt.L111.Keel.SDir = 90; %degree

Cnnt.L111.OS.thk = Thk.Col1.OS;
Cnnt.L111.OS.int = 3;
Cnnt.L111.OS.axisTT = 'x'; %through-thickness axis
Cnnt.L111.OS.SDir = 90; %degree


OutName = [path1 'CnntInfo.mat'];
save(OutName, 'Cnnt')

%%
%% Itr1_NewDesign WFA Mooring Connector Analysis - Column 2 model
% ItrNo = 'Itr1_01';
path1 = [path0 ItrNo '\'];
load([path1 'thickness.mat']);

Cnnt.Itr = ItrNo;


%Line4 - L1041_OS_MC
Cnnt.L1041.SN = 'ABS_E_CP';
Cnnt.L1041.group = 'circ';
Cnnt.L1041.axis = 'z';

Cnnt.L1041.OS.thk = Thk.Col2.OS;
Cnnt.L1041.OS.axisTT = 'x';
Cnnt.L1041.OS.int = 3;
Cnnt.L1041.OS.SDir = 90; %degree

%Line4 - L1042_OS_MC
Cnnt.L1042.SN = 'ABS_E_CP';
Cnnt.L1042.group = 'circ';
Cnnt.L1042.axis = 'z';

Cnnt.L1042.OS.thk = Thk.Col2.OS;
Cnnt.L1042.OS.axisTT = 'x';
Cnnt.L1042.OS.int = 3;
Cnnt.L1042.OS.SDir = 90; %degree


%Line5.2 - L1052_OS_MC
Cnnt.L1052.SN = 'ABS_E_CP';
Cnnt.L1052.group = 'circ';
Cnnt.L1052.axis = 'y';

Cnnt.L1052.OS.thk = Thk.Col2.OS;
Cnnt.L1052.OS.axisTT = 'x';
Cnnt.L1052.OS.int = 3;
Cnnt.L1052.OS.SDir = 90; %degree

%Line5.3 - L1053_OS_MC
Cnnt.L1053.SN = 'ABS_E_CP';
Cnnt.L1053.group = 'circ';
Cnnt.L1053.axis = 'y';

Cnnt.L1053.OS.thk = Thk.Col2.OS;
Cnnt.L1053.OS.axisTT = 'x';
Cnnt.L1053.OS.int = 3;
Cnnt.L1053.OS.SDir = 90; %degree


%Line6.1 - L1061_OS_C3
Cnnt.L1061.SN = 'ABS_E_CP';
Cnnt.L1061.group = 'circ';
Cnnt.L1061.axis = 'z';

Cnnt.L1061.OS.thk = Thk.Col2.OS;
Cnnt.L1061.OS.axisTT = 'x';
Cnnt.L1061.OS.int = 3;
Cnnt.L1061.OS.SDir = 90; %degree

Cnnt.L1061.C3.thk = Thk.Col2.C3;
Cnnt.L1061.C3.axisTT = 'y';
Cnnt.L1061.C3.int = 3;
Cnnt.L1061.C3.SDir = 90; %degree

%Line6.2 - L1062_OS_C3
Cnnt.L1062.SN = 'ABS_E_CP';
Cnnt.L1062.group = 'circ';
Cnnt.L1062.axis = 'z';

Cnnt.L1062.OS.thk = Thk.Col2.OS;
Cnnt.L1062.OS.axisTT = 'x';
Cnnt.L1062.OS.int = 3;
Cnnt.L1062.OS.SDir = 90; %degree

Cnnt.L1062.C3.thk = Thk.Col2.C3;
Cnnt.L1062.C3.axisTT = 'y';
Cnnt.L1062.C3.int = 3;
Cnnt.L1062.C3.SDir = 90; %degree

%Line7.1 - L1071_C3_C3Fl
%Careful with C3 girder; has diffent thicknesses. Same for the flange
Cnnt.L1071.SN = 'ABS_E_CP';
Cnnt.L1071.group = 'circ';
Cnnt.L1071.axis = 'x';

Cnnt.L1071.C3.thk = Thk.Col2.C3b;
Cnnt.L1071.C3.axisTT = 'y';
Cnnt.L1071.C3.int = 3;
Cnnt.L1071.C3.SDir = 90; %degree

Cnnt.L1071.C3Fl.thk = Thk.Col2.C3bFl;
Cnnt.L1071.C3Fl.axisTT = 'z';
Cnnt.L1071.C3Fl.int = 3;
Cnnt.L1071.C3Fl.SDir = 90; %degree

%Line7.2 - L1072_C3_C3Fl
Cnnt.L1072.SN = 'ABS_E_CP';
Cnnt.L1072.group = 'circ';
Cnnt.L1072.axis = 'z';

Cnnt.L1072.C3.thk = Thk.Col2.C3;
Cnnt.L1072.C3.int = 3;
Cnnt.L1072.C3.axisTT = 'y'; %through-thickness axis
Cnnt.L1072.C3.SDir = 90; %degree

Cnnt.L1072.C3Fl.thk = Thk.Col2.C3Fl;
Cnnt.L1072.C3Fl.int = 3;
Cnnt.L1072.C3Fl.axisTT = 'x'; %through-thickness axis
Cnnt.L1072.C3Fl.SDir = 90; %degree

%Line7.3 - L1073_C3_C3Fl
Cnnt.L1073.SN = 'ABS_E_CP';
Cnnt.L1073.group = 'circ';
Cnnt.L1073.axis = 'z';

Cnnt.L1073.C3.thk = Thk.Col2.C3;
Cnnt.L1073.C3.axisTT = 'y';
Cnnt.L1073.C3.int = 3;
Cnnt.L1073.C3.SDir = 90; %degree

Cnnt.L1073.C3Fl.thk = Thk.Col2.C3Fl;
Cnnt.L1073.C3Fl.axisTT = 'x';
Cnnt.L1073.C3Fl.int = 3;
Cnnt.L1073.C3Fl.SDir = 90; %degree

%Line7.4 - L1074_C3_C3Fl
Cnnt.L1074.SN = 'ABS_E_CP';
Cnnt.L1074.group = 'circ';
Cnnt.L1074.axis = 'x';

Cnnt.L1074.C3.thk = Thk.Col2.C3b;
Cnnt.L1074.C3.axisTT = 'y';
Cnnt.L1074.C3.int = 3;
Cnnt.L1074.C3.SDir = 90; %degree

Cnnt.L1074.C3Fl.thk = Thk.Col2.C3bFl;
Cnnt.L1074.C3Fl.axisTT = 'z';
Cnnt.L1074.C3Fl.int = 3;
Cnnt.L1074.C3Fl.SDir = 90; %degree

%Line7.5 - L1075_C3_C3Fl
Cnnt.L1075.SN = 'ABS_E_CP';
Cnnt.L1075.group = 'circ';
Cnnt.L1075.axis = 'z';

Cnnt.L1075.C3.thk = Thk.Col2.C3;
Cnnt.L1075.C3.int = 3;
Cnnt.L1075.C3.axisTT = 'y'; %through-thickness axis
Cnnt.L1075.C3.SDir = 90; %degree

Cnnt.L1075.C3Fl.thk = Thk.Col2.C3Fl;
Cnnt.L1075.C3Fl.int = 3;
Cnnt.L1075.C3Fl.axisTT = 'x'; %through-thickness axis
Cnnt.L1075.C3Fl.SDir = 90; %degree

%Line7.6 - L1076_C3_C3Fl
Cnnt.L1076.SN = 'ABS_E_CP';
Cnnt.L1076.group = 'circ';
Cnnt.L1076.axis = 'z';

Cnnt.L1076.C3.thk = Thk.Col2.C3;
Cnnt.L1076.C3.axisTT = 'y';
Cnnt.L1076.C3.int = 3;
Cnnt.L1076.C3.SDir = 90; %degree

Cnnt.L1076.C3Fl.thk = Thk.Col2.C3Fl;
Cnnt.L1076.C3Fl.axisTT = 'x';
Cnnt.L1076.C3Fl.int = 3;
Cnnt.L1076.C3Fl.SDir = 90; %degree


%Line8 - L1080_Rg850_OS
Cnnt.L1080.SN = 'ABS_E_CP';
Cnnt.L1080.group = 'circ';
Cnnt.L1080.axis = 'y';

Cnnt.L1080.Rg850.thk = Thk.Col2.Rg850;
Cnnt.L1080.Rg850.int = 3;
Cnnt.L1080.Rg850.axisTT = 'z'; %through-thickness axis
Cnnt.L1080.Rg850.SDir = 90; %degree

%Line11.0 - L1110_OS_Keel
Cnnt.L1110.SN = 'ABS_E_CP';
Cnnt.L1110.group = 'circ';
Cnnt.L1110.axis = 'y';

Cnnt.L1110.OS.thk = Thk.Col2.OS;
Cnnt.L1110.OS.int = 3;
Cnnt.L1110.OS.axisTT = 'x'; %through-thickness axis
Cnnt.L1110.OS.SDir = 90; %degree

Cnnt.L1110.Keel.thk = Thk.Col2.Keel;
Cnnt.L1110.Keel.int = 3;
Cnnt.L1110.Keel.axisTT = 'z'; %through-thickness axis
Cnnt.L1110.Keel.SDir = 90; %degree

%Line12.0 - L1120_Rg850_Rg850Fl
Cnnt.L1120.SN = 'ABS_E_CP';
Cnnt.L1120.group = 'circ';
Cnnt.L1120.axis = 'y';

Cnnt.L1120.Rg850.thk = Thk.Col2.Rg850;
Cnnt.L1120.Rg850.int = 3;
Cnnt.L1120.Rg850.axisTT = 'z'; %through-thickness axis
Cnnt.L1120.Rg850.SDir = 90; %degree

Cnnt.L1120.Rg850Fl.thk = Thk.Col2.Rg850Fl;
Cnnt.L1120.Rg850Fl.int = 3;
Cnnt.L1120.Rg850Fl.axisTT = 'x'; %through-thickness axis
Cnnt.L1120.Rg850Fl.SDir = 90; %degree

%Line13.1 - L1131_Rg850_C3
Cnnt.L1131.SN = 'ABS_E_CP';
Cnnt.L1131.group = 'circ';
Cnnt.L1131.axis = 'x';

Cnnt.L1131.C3.thk = Thk.Col2.C3;
Cnnt.L1131.C3.int = 3;
Cnnt.L1131.C3.axisTT = 'y'; %through-thickness axis
Cnnt.L1131.C3.SDir = 90; %degree

Cnnt.L1131.Rg850.thk = Thk.Col2.Rg850;
Cnnt.L1131.Rg850.int = 3;
Cnnt.L1131.Rg850.axisTT = 'z'; %through-thickness axis
Cnnt.L1131.Rg850.SDir = 90; %degree

%Line13.2 - L1132_Rg850_C3
Cnnt.L1132.SN = 'ABS_E_CP';
Cnnt.L1132.group = 'circ';
Cnnt.L1132.axis = 'x';

Cnnt.L1132.C3.thk = Thk.Col2.C3;
Cnnt.L1132.C3.int = 3;
Cnnt.L1132.C3.axisTT = 'y'; %through-thickness axis
Cnnt.L1132.C3.SDir = 90; %degree

Cnnt.L1132.Rg850.thk = Thk.Col2.Rg850;
Cnnt.L1132.Rg850.int = 3;
Cnnt.L1132.Rg850.axisTT = 'z'; %through-thickness axis
Cnnt.L1132.Rg850.SDir = 90; %degree


%Line14.1 - L1141_Rg850Fl_C3
Cnnt.L1141.SN = 'ABS_E_CP';
Cnnt.L1141.group = 'circ';
Cnnt.L1141.axis = 'z';

Cnnt.L1141.C3.thk = Thk.Col2.C3;
Cnnt.L1141.C3.int = 3;
Cnnt.L1141.C3.axisTT = 'y'; %through-thickness axis
Cnnt.L1141.C3.SDir = 90; %degree

Cnnt.L1141.Rg850Fl.thk = Thk.Col2.Rg850Fl;
Cnnt.L1141.Rg850Fl.int = 3;
Cnnt.L1141.Rg850Fl.axisTT = 'x'; %through-thickness axis
Cnnt.L1141.Rg850Fl.SDir = 90; %degree

%Line14.2 - L1142_Rg850Fl_C3
Cnnt.L1142.SN = 'ABS_E_CP';
Cnnt.L1142.group = 'circ';
Cnnt.L1142.axis = 'z';

Cnnt.L1142.C3.thk = Thk.Col2.C3;
Cnnt.L1142.C3.int = 3;
Cnnt.L1142.C3.axisTT = 'y'; %through-thickness axis
Cnnt.L1142.C3.SDir = 90; %degree

Cnnt.L1142.Rg850Fl.thk = Thk.Col2.Rg850Fl;
Cnnt.L1142.Rg850Fl.int = 3;
Cnnt.L1142.Rg850Fl.axisTT = 'x'; %through-thickness axis
Cnnt.L1142.Rg850Fl.SDir = 90; %degree


%Line15.1 - L1151_Rg1700_C3
Cnnt.L1151.SN = 'ABS_E_CP';
Cnnt.L1151.group = 'circ';
Cnnt.L1151.axis = 'x';

Cnnt.L1151.C3.thk = Thk.Col2.C3;
Cnnt.L1151.C3.int = 3;
Cnnt.L1151.C3.axisTT = 'y'; %through-thickness axis
Cnnt.L1151.C3.SDir = 90; %degree

Cnnt.L1151.Rg1700.thk = Thk.Col2.Rg1700;
Cnnt.L1151.Rg1700.int = 3;
Cnnt.L1151.Rg1700.axisTT = 'z'; %through-thickness axis
Cnnt.L1151.Rg1700.SDir = 90; %degree

%Line15.2 - L1152_Rg1700_C3
Cnnt.L1152.SN = 'ABS_E_CP';
Cnnt.L1152.group = 'circ';
Cnnt.L1152.axis = 'x';

Cnnt.L1152.C3.thk = Thk.Col2.C3;
Cnnt.L1152.C3.int = 3;
Cnnt.L1152.C3.axisTT = 'y'; %through-thickness axis
Cnnt.L1152.C3.SDir = 90; %degree

Cnnt.L1152.Rg1700.thk = Thk.Col2.Rg1700;
Cnnt.L1152.Rg1700.int = 3;
Cnnt.L1152.Rg1700.axisTT = 'z'; %through-thickness axis
Cnnt.L1152.Rg1700.SDir = 90; %degree

%Line16.1 - L1161_Keel_C3
Cnnt.L1161.SN = 'ABS_E_CP';
Cnnt.L1161.group = 'circ';
Cnnt.L1161.axis = 'x';

Cnnt.L1161.C3.thk = Thk.Col2.C3;
Cnnt.L1161.C3.int = 3;
Cnnt.L1161.C3.axisTT = 'y'; %through-thickness axis
Cnnt.L1161.C3.SDir = 90; %degree

Cnnt.L1161.Keel.thk = Thk.Col2.Keel;
Cnnt.L1161.Keel.int = 3;
Cnnt.L1161.Keel.axisTT = 'z'; %through-thickness axis
Cnnt.L1161.Keel.SDir = 90; %degree

%Line16.2 - L1162_Keel_C3
Cnnt.L1162.SN = 'ABS_E_CP';
Cnnt.L1162.group = 'circ';
Cnnt.L1162.axis = 'x';

Cnnt.L1162.C3.thk = Thk.Col2.C3;
Cnnt.L1162.C3.int = 3;
Cnnt.L1162.C3.axisTT = 'y'; %through-thickness axis
Cnnt.L1162.C3.SDir = 90; %degree

Cnnt.L1162.Keel.thk = Thk.Col2.Keel;
Cnnt.L1162.Keel.int = 3;
Cnnt.L1162.Keel.axisTT = 'z'; %through-thickness axis
Cnnt.L1162.Keel.SDir = 90; %degree

%Line16.3 - L1163_Keel_C3
Cnnt.L1163.SN = 'ABS_E_CP';
Cnnt.L1163.group = 'circ';
Cnnt.L1163.axis = 'x';

Cnnt.L1163.C3.thk = Thk.Col2.C3b;
Cnnt.L1163.C3.int = 3;
Cnnt.L1163.C3.axisTT = 'y'; %through-thickness axis
Cnnt.L1163.C3.SDir = 90; %degree

Cnnt.L1163.Keel.thk = Thk.Col2.Keel;
Cnnt.L1163.Keel.int = 3;
Cnnt.L1163.Keel.axisTT = 'z'; %through-thickness axis
Cnnt.L1163.Keel.SDir = 90; %degree

%Line16.4 - L1164_Keel_C3
Cnnt.L1164.SN = 'ABS_E_CP';
Cnnt.L1164.group = 'circ';
Cnnt.L1164.axis = 'x';

Cnnt.L1164.C3.thk = Thk.Col2.C3b;
Cnnt.L1164.C3.int = 3;
Cnnt.L1164.C3.axisTT = 'y'; %through-thickness axis
Cnnt.L1164.C3.SDir = 90; %degree

Cnnt.L1164.Keel.thk = Thk.Col2.Keel;
Cnnt.L1164.Keel.int = 3;
Cnnt.L1164.Keel.axisTT = 'z'; %through-thickness axis
Cnnt.L1164.Keel.SDir = 90; %degree

%Line17.1 - L1171_C3_C3Fb
Cnnt.L1171.SN = 'ABS_E_CP';
Cnnt.L1171.group = 'circ';
Cnnt.L1171.axis = 'z';

Cnnt.L1171.C3.thk = Thk.Col2.C3;
Cnnt.L1171.C3.int = 3;
Cnnt.L1171.C3.axisTT = 'y'; %through-thickness axis
Cnnt.L1171.C3.SDir = 90; %degree


%Line17.2 - L1172_C3_C3Fb
Cnnt.L1172.SN = 'ABS_E_CP';
Cnnt.L1172.group = 'circ';
Cnnt.L1172.axis = 'z';

Cnnt.L1172.C3.thk = Thk.Col2.C3b;
Cnnt.L1172.C3.int = 3;
Cnnt.L1172.C3.axisTT = 'y'; %through-thickness axis
Cnnt.L1172.C3.SDir = 90; %degree

%Line17.3 - L1173_C3_C3Fb
Cnnt.L1173.SN = 'ABS_E_CP';
Cnnt.L1173.group = 'circ';
Cnnt.L1173.axis = 'z';

Cnnt.L1173.C3.thk = Thk.Col2.C3;
Cnnt.L1173.C3.int = 3;
Cnnt.L1173.C3.axisTT = 'y'; %through-thickness axis
Cnnt.L1173.C3.SDir = 90; %degree


%Line17.4 - L1174_C3_C3Fb
Cnnt.L1174.SN = 'ABS_E_CP';
Cnnt.L1174.group = 'circ';
Cnnt.L1174.axis = 'z';

Cnnt.L1174.C3.thk = Thk.Col2.C3b;
Cnnt.L1174.C3.int = 3;
Cnnt.L1174.C3.axisTT = 'y'; %through-thickness axis
Cnnt.L1174.C3.SDir = 90; %degree


%Line18.1 - L1181_C3_IS
Cnnt.L1181.SN = 'ABS_E_CP';
Cnnt.L1181.group = 'circ';
Cnnt.L1181.axis = 'z';

Cnnt.L1181.C3.thk = Thk.Col2.C3b;
Cnnt.L1181.C3.int = 3;
Cnnt.L1181.C3.axisTT = 'y'; %through-thickness axis
Cnnt.L1181.C3.SDir = 90; %degree

Cnnt.L1181.IS.thk = Thk.Col2.IS;
Cnnt.L1181.IS.int = 3;
Cnnt.L1181.IS.axisTT = 'x'; %through-thickness axis
Cnnt.L1181.IS.SDir = 90; %degree

%Line18.2 - L1182_C3_IS
Cnnt.L1182.SN = 'ABS_E_CP';
Cnnt.L1182.group = 'circ';
Cnnt.L1182.axis = 'z';

Cnnt.L1182.C3.thk = Thk.Col2.C3b;
Cnnt.L1182.C3.int = 3;
Cnnt.L1182.C3.axisTT = 'y'; %through-thickness axis
Cnnt.L1182.C3.SDir = 90; %degree

Cnnt.L1182.IS.thk = Thk.Col2.IS;
Cnnt.L1182.IS.int = 3;
Cnnt.L1182.IS.axisTT = 'x'; %through-thickness axis
Cnnt.L1182.IS.SDir = 90; %degree

%Line19.1 - L1191_C3_C3Br
Cnnt.L1191.SN = 'ABS_E_CP';
Cnnt.L1191.group = 'circ';
Cnnt.L1191.axis = 'x';

Cnnt.L1191.C3.thk = Thk.Col2.C3b;
Cnnt.L1191.C3.int = 3;
Cnnt.L1191.C3.axisTT = 'y'; %through-thickness axis
Cnnt.L1191.C3.SDir = 90; %degree

Cnnt.L1191.C3Br.thk = Thk.Col2.C3Br;
Cnnt.L1191.C3Br.int = 3;
Cnnt.L1191.C3Br.axisTT = 'y'; %through-thickness axis
Cnnt.L1191.C3Br.SDir = 90; %degree

%Line19.2 - L1192_C3_C3Br
Cnnt.L1192.SN = 'ABS_E_CP';
Cnnt.L1192.group = 'circ';
Cnnt.L1192.axis = 'x';

Cnnt.L1192.C3.thk = Thk.Col2.C3b;
Cnnt.L1192.C3.int = 3;
Cnnt.L1192.C3.axisTT = 'y'; %through-thickness axis
Cnnt.L1192.C3.SDir = 90; %degree

Cnnt.L1192.C3Br.thk = Thk.Col2.C3Br;
Cnnt.L1192.C3Br.int = 3;
Cnnt.L1192.C3Br.axisTT = 'y'; %through-thickness axis
Cnnt.L1192.C3Br.SDir = 90; %degree


%Line20.1 - L1201_IS_C3Br
Cnnt.L1201.SN = 'ABS_E_CP';
Cnnt.L1201.group = 'circ';
Cnnt.L1201.axis = 'z';

Cnnt.L1201.IS.thk = Thk.Col2.IS;
Cnnt.L1201.IS.int = 3;
Cnnt.L1201.IS.axisTT = 'x'; %through-thickness axis
Cnnt.L1201.IS.SDir = 90; %degree

Cnnt.L1201.C3Br.thk = Thk.Col2.C3Br;
Cnnt.L1201.C3Br.int = 3;
Cnnt.L1201.C3Br.axisTT = 'y'; %through-thickness axis
Cnnt.L1201.C3Br.SDir = 90; %degree

%Line20.2 - L1202_IS_C3Br
Cnnt.L1202.SN = 'ABS_E_CP';
Cnnt.L1202.group = 'circ';
Cnnt.L1202.axis = 'z';

Cnnt.L1202.IS.thk = Thk.Col2.IS;
Cnnt.L1202.IS.int = 3;
Cnnt.L1202.IS.axisTT = 'x'; %through-thickness axis
Cnnt.L1202.IS.SDir = 90; %degree

Cnnt.L1202.C3Br.thk = Thk.Col2.C3Br;
Cnnt.L1202.C3Br.int = 3;
Cnnt.L1202.C3Br.axisTT = 'y'; %through-thickness axis
Cnnt.L1202.C3Br.SDir = 90; %degree


OutName = [path1 'CnntInfo.mat'];
save(OutName, 'Cnnt')