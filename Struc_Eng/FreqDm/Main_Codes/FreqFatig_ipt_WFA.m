clc
clear all

%% Input - General
path0 = 'D:\Newfolder\MATLAB\FreqDomain\';
SNfile = 'SNcurve.mat';

%Iteration name 
Itr = 'ItrR16_7_3_v0_Offset';
path_itr = [path0 Itr '\']; %General path for each iteration

%Input theta0, defines platform orientation 
%0 - column 1 in north, 90 - column 1 in east, 180 - column 1 in south, 
%270 - column 1 in west 
theta0 = 340;

%Path for Wave scatter diagram and stress results. 
LoadDate = 'Aug32018';
path_str = ['D:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\MzStudy\Results\Loads_' LoadDate '\Results\'];
path_scatter = 'D:\Newfolder\Fatigue assessment\@WFP WFA\WFA\FreqDomain\WaveScatter';

%Units
unit = 'Pa'; %Stress output unit, 'Pa' - stress in Pa, length in meter; 'MPa' - stress in MPa, length in mm
scale = 100; %Loads from Match Maker usually are scaled down by scale to avoid larege rigid body motion in ANSYS

%Max./Min. wave period simulated
MaxPeriod = 30;
MinPeriod = 3;

%Wave headings to check
%Convention TOWARD: 0 - toward north, 90 - toward east, 180 - toward south, 
%270 - toward west
wave_theta.simulated = [-20 40 70 100 130 160 190 220 250 310];  %Simulated wave headings, toward
wave_theta.total = [-20 10 40 70 100 130 160 190 220 250 280 310]; %Total wave headings, toward

%% Input - DispPressure

path_load = ['\\SHARK\Bingbin\Models\@Round5_WFA\Itr16_FreqDm_Detail\Loads_' LoadDate '\'];
Head = 0; %deg, wave heading to plot
Period = 15; %s, wave period to plot
RorI = 'imag'; %real or imag to plot
units.stress = unit; %unit of the pressure 
units.length = 'm'; %unit of length in the element location file

%% Input - FreqFatig_AllParts 

% Analysis Procedure -
% 1 for spectral analyses using wave scatter diagram, closed form damage calculation
% 2 for spectral analysis using wave scatter diagram, rainflow counting
% 3 spectral analysis from Hs/Tp/Wave Dir fatigue bins, closed form damage calculation
% 4 spectral analysis from Hs/Tp/Wave Dir fatigue bins, rainflow counting
% 5 spectral analysis from Hs/Tp/Wave Dir fatigue bins, rainflow counting, S1 from Snormal
% 6 spectral analysis from bi-model wave Hs/Tp/Dir fatigue bins
% 7 spectral analysis from bi-model wave Hs/Tp/Dir fatigue bins, rainflow counting
Method_Analysis = 6;
Bin = 198;
% MetData_File = [path_scatter '\' 'WFA_ComboFatigueBins_N' num2str(Bin) '.csv'];
MetData_File = [path_scatter '\' 'WFA_BiModWaveFatigueBins_N' num2str(Bin) '.csv'];

% Control groups information
CGinfo.IS_CG1.thk = 85;
CGinfo.IS_CG1.SN = 'API_WJ_Air';
CGinfo.IS_CG2.thk = 60;
CGinfo.IS_CG2.SN = 'API_WJ_CP';
CGinfo.IS_CG3.thk = 19;
CGinfo.IS_CG3.SN = 'ABS_E_Air';

CGinfo.OS_CG1.thk = 40;
CGinfo.OS_CG1.SN = 'API_WJ_Air';
CGinfo.OS_CG2.thk = 30;
CGinfo.OS_CG2.SN = 'API_WJ_CP';

CGinfo.Truss_CG1.thk = 32;
CGinfo.Truss_CG1.SN = 'API_WJ_Air';
CGinfo.Truss_CG2.thk = 25;
CGinfo.Truss_CG2.SN = 'API_WJ_CP';

CGinfo.RingVbar_CG1.thk = 40;
CGinfo.RingVbar_CG1.SN = 'ABS_E_Air';
CGinfo.RingVbar_CG2.thk = 40;
CGinfo.RingVbar_CG2.SN = 'ABS_E_CP';

CGinfo.LMB12.thk = 25;
CGinfo.LMB12.SN = 'ABS_E_CP';

CGinfo.FB12ECC.thk = 30;
CGinfo.FB12ECC.SN = 'ABS_E_CP';

CGinfo.FB13ECC.thk = 30;
CGinfo.FB13ECC.SN = 'ABS_E_CP';

CGinfo.FB21ECC.thk = 30;
CGinfo.FB21ECC.SN = 'ABS_E_CP';

CGinfo.DblToeBrktC12.thk = 28;
CGinfo.DblToeBrktC12.SN = 'ABS_E_CP';

CGinfo.DblToeBrktC13.thk = 28;
CGinfo.DblToeBrktC13.SN = 'ABS_E_CP';

CGinfo.FB12CEN.thk = 40;
CGinfo.FB12CEN.SN = 'ABS_E_CP';

CGinfo.FB13CEN.thk = 40;
CGinfo.FB13CEN.SN = 'ABS_E_CP';

CGinfo.FB21CEN.thk = 40;
CGinfo.FB21CEN.SN = 'ABS_E_CP';

CGinfo.GirderFlangeCol1.thk = 28;
CGinfo.GirderFlangeCol1.SN = 'ABS_E_CP';

CGinfo.GirderFlangeCol2.thk = 28;
CGinfo.GirderFlangeCol2.SN = 'ABS_E_CP';

CGinfo.GirderWebCol1.thk = 20;
CGinfo.GirderWebCol1.SN = 'ABS_E_CP';


CGinfo.GirderWebCol2.thk = 20;
CGinfo.GirderWebCol2.SN = 'ABS_E_CP';

CGinfo.GirderWebRing4Col1.thk = 25;
CGinfo.GirderWebRing4Col1.SN = 'ABS_E_CP';

CGinfo.KJointCanBrktC12.thk = 20;
CGinfo.KJointCanBrktC12.SN = 'ABS_E_CP';

CGinfo.KJointCanBrktC13.thk = 20;
CGinfo.KJointCanBrktC13.SN = 'ABS_E_CP';

CGinfo.KJointCanC12.thk = 50;
CGinfo.KJointCanC12.SN = 'ABS_E_CP';

CGinfo.KJointCanC13.thk = 50;
CGinfo.KJointCanC13.SN = 'ABS_E_CP';

CGinfo.KJtDblToeBrktC12.thk = 40;
CGinfo.KJtDblToeBrktC12.SN = 'ABS_E_CP';

CGinfo.KJtDblToeBrktC13.thk = 40;
CGinfo.KJtDblToeBrktC13.SN = 'ABS_E_CP';

CGinfo.LMB13.thk = 25;
CGinfo.LMB13.SN = 'ABS_E_CP';

CGinfo.Ring4C21.thk = 25;
CGinfo.Ring4C21.SN = 'ABS_E_CP';

CGinfo.Ring45C12.thk = 25;
CGinfo.Ring45C12.SN = 'ABS_E_CP';

CGinfo.Ring45C13.thk = 25;
CGinfo.Ring45C13.SN = 'ABS_E_CP';

CGinfo.StiffenerFlangeCol1.thk = 18;
CGinfo.StiffenerFlangeCol1.SN = 'ABS_E_CP';

CGinfo.StiffenerFlangeCol2.thk = 18;
CGinfo.StiffenerFlangeCol2.SN = 'ABS_E_CP';

CGinfo.StiffenerWebCol1.thk = 11.5;
CGinfo.StiffenerWebCol1.SN = 'ABS_E_CP';

CGinfo.StiffenerWebCol2.thk = 11.5;
CGinfo.StiffenerWebCol2.SN = 'ABS_E_CP';
%Parts to Run
Parts = {'KJtDblToeBrktC12','KJtDblToeBrktC13','LMB12','Ring4C21','Ring45C12','Ring45C13','StiffenerFlangeCol1','StiffenerFlangeCol2','StiffenerWebCol1','StiffenerWebCol2','FB12ECC','FB13ECC','DblToeBrktC12','DblToeBrktC13','FB12CEN','FB13CEN','FB21CEN','FB21ECC','GirderFlangeCol1','GirderFlangeCol2','GirderWebCol1','GirderWebCol2','GirderWebRing4Col1','KJointCanBrktC12','KJointCanBrktC13','KJointCanC12','KJointCanC13'};

%Input for method6 
InputMthd6.gamma1 = 1; %Gamma for wind sea spectrum, site specific
InputMthd6.gamma2 = 2.2; %Gamma for swell spectrum, site specific
InputMthd6.periods = MaxPeriod:-1:MinPeriod;

%Input for method7 
InputMthd7.dt = 0.1; %s, time step for generated stress time series
InputMthd7.totaltime = 3600; %s, total time for generated stress time series
InputMthd7.gamma1 = 1; %Gamma for wind sea spectrum, site specific
InputMthd7.gamma2 = 2.2; %Gamma for swell spectrum, site specific
InputMthd7.periods = MaxPeriod:-1:MinPeriod;
InputMthd7.RefSpec = 'n'; %Whether to refine stress spectrum
InputMthd7.Nfreq = 100; % number of frequencies in refinement (goes from 1/periods(1) to 1/periods(end))

%% Input - For PlotFatigueLife
method_plot = 6;
path_rst = [path0 Itr '\Results_Mthd' num2str(method_plot) '\'];

%% Input - SpecFatig_HotSpot 

%Analysis Procedure -
% 1 for spectral analyses using wave scatter diagram, 
% 2 for rainflow analysis using wave scatter diagram, 
% 3 spectral analysis from Hs/Tp/Wave Dir statistics,
% 4 rainflow analysis from Hs/Tp/Wave Dir statistics,
% 5 rainflow analysis from Hs/Tp/Wave Dir statistics, S1 from Snormal
% 6 spectral analysis from bi-model wave Hs/Tp/Dir fatigue bins
% 7 spectral analysis from bi-model wave Hs/Tp/Dir fatigue bins, rainflow counting
Method_hotspot = 7;
Bin_hsp = 198;
% MetFile_hsp = [path_scatter '\' 'WFA_ComboFatigueBins_N' num2str(Bin_hsp) '.csv'];
MetFile_hsp = [path_scatter '\' 'WFA_BiModWaveFatigueBins_N' num2str(Bin_hsp) '.csv'];

%Name of member to be calculated fatigue damage. 
Group_all ={'DblToeBrktC12','DblToeBrktC13'};
% Group_all = {'KJtDblToeBrktC12','KJtDblToeBrktC13','LMB12','Ring4C21','Ring45C12','Ring45C13','StiffenerFlangeCol1','StiffenerFlangeCol2','StiffenerWebCol1','StiffenerWebCol2','FB12ECC','FB13ECC','DblToeBrktC12','DblToeBrktC13','FB12CEN','FB13CEN','FB21CEN','FB21ECC','GirderFlangeCol1','GirderFlangeCol2','GirderWebCol1','GirderWebCol2','GirderWebRing4Col1','KJointCanBrktC12','KJointCanBrktC13','KJointCanC12','KJointCanC13'};

% Group_all = {'Truss_CG1','Truss_CG2','IS_CG1','IS_CG2','OS_CG1','OS_CG2','RingVbar_CG1','RingVbar_CG2','Bkh_CG1','OSRG_CG1','KFGdr_CG1'};

HotspotGroups = Group_all();

HspIptMthd6.gamma1 = 1; %Gamma for wind sea spectrum, site specific
HspIptMthd6.gamma2 = 2.2; %Gamma for swell spectrum, site specific
HspIptMthd6.periods = MaxPeriod:-1:MinPeriod; %Periods simulated

HspIptMthd7.dt = 0.1; %s, time step for generated stress time series
HspIptMthd7.totaltime = 3600; %s, time step for generated stress time series
HspIptMthd7.gamma1 = 1; %Gamma for wind sea spectrum, site specific
HspIptMthd7.gamma2 = 2.2; %Gamma for swell spectrum, site specific
HspIptMthd7.periods = MaxPeriod:-1:MinPeriod; %Periods simulated
HspIptMthd7.RefSpec = 'n'; %Whether to refine stress spectrum
HspIptMthd7.Nfreq = 100; % number of frequencies in refinement (goes from 1/periods(1) to 1/periods(end))

%% Input - SpecFatig_SelectElem 
%Analysis Procedure -
% 1 for spectral analyses using wave scatter diagram, 
% 2 for rainflow analysis using wave scatter diagram, 
% 3 spectral analysis from Hs/Tp/Wave Dir statistics,
% 4 rainflow analysis from Hs/Tp/Wave Dir statistics,
% 5 rainflow analysis from Hs/Tp/Wave Dir statistics, S1 from Snormal
% 6 spectral analysis from bi-model wave Hs/Tp/Dir fatigue bins
% 7 spectral analysis from bi-model wave Hs/Tp/Dir fatigue bins, rainflow counting

Method_PreScreen = 6; %Method that the prescreen was based on
Method_FinalCal = 6; %Method that the final calculation is based on

Bin_Select = 198;
MetFile_Select = [path_scatter '\' 'WFA_BiModWaveFatigueBins_N' num2str(Bin_Select) '.csv'];

%Name of member to be calculated fatigue damage. 
% Group_all = {'Truss_CG1','Truss_CG2','IS_CG1','IS_CG2','OS_CG1','OS_CG2','RingVbar_CG1','RingVbar_CG2','Bkh_CG1','OSRG_CG1','KFGdr_CG1'};
Group_all = {'LMB_Nominal','LMB_FB','IS_Bot','OS_Bot','LMB_Can','IS_Rings','LMB_Rings'};
SelectGroups = {Group_all{1}};

SelectIptMthd6.gamma1 = 1; %Gamma for wind sea spectrum, site specific
SelectIptMthd6.gamma2 = 2.2; %Gamma for swell spectrum, site specific
SelectIptMthd6.periods = MaxPeriod:-1:MinPeriod; %Periods simulated

SelIptMthd7.dt = 0.1; %s, time step for generated stress time series
SelIptMthd7.totaltime = 600; %s, time step for generated stress time series
SelIptMthd7.gamma1 = 1; %Gamma for wind sea spectrum, site specific
SelIptMthd7.gamma2 = 2.2; %Gamma for swell spectrum, site specific
SelIptMthd7.periods = MaxPeriod:-1:MinPeriod; %Periods simulated
SelIptMthd7.RefSpec = 'n'; %Whether to refine stress spectrum
SelIptMthd7.Nfreq = 100; % number of frequencies in refinement (goes from 1/periods(1) to 1/periods(end))
%% Input - For Plot Cnnt Elem Result 
iteration.name = Itr;
iteration.theta0 = theta0;

Method.No = 6;
Method.Bin = 500;
Method.Perc = 0.02;

result.group = 'Truss_CG2';
result.surf = 'Top';