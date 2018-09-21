clc
clear all

%% Input - General
path0 = 'D:\Newfolder\MATLAB\FreqDomain\';
SNfile = 'SNcurve.mat';

%Iteration name 
Itr = 'Itr2_0_UMBVB_Cast';
path_itr = [path0 Itr '\']; %General path for each iteration

%Input theta0, defines platform orientation 
%0 - column 1 in north, 90 - column 1 in east, 180 - column 1 in south, 
%270 - column 1 in west 
theta0 = 225;

%Path for Wave scatter diagram and stress results. 
LoadDate = 'Sep142018';
path_str = ['G:\Data\EFG\FreqDom\FDRe\Loads_' LoadDate '\Results\'];
path_scatter = 'D:\Newfolder\Fatigue assessment\@WFM\EFG\FreqDomain\WaveScatter';

%Units
unit = 'Pa'; %Stress output unit, 'Pa' - stress in Pa, length in meter; 'MPa' - stress in MPa, length in mm
scale = 1; %Loads from Match Maker usually are scaled down by scale to avoid larege rigid body motion in ANSYS

%Max./Min. wave period simulated
MaxPeriod = 30;
MinPeriod = 3;

%Wave headings to check
%Convention TOWARD: 0 - toward north, 90 - toward east, 180 - toward south, 
%270 - toward west
wave_theta.simulated = [210 240 270 300];  %Simulated wave headings
wave_theta.total = 0:30:330; %Total wave headings, toward
wave_theta.conv = 'TOWARDS+CCW, rel to platform';

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
Method_Analysis = 8;
Bin = 210;
% MetData_File = [path_scatter '\' 'WFA_ComboFatigueBins_N' num2str(Bin)
% '.csv'];

MetData_File = [path_scatter '\' 'WFM_Bins7D_4Structures_Bin' num2str(Bin) '.mat'];


% Control groups information
CGinfo.KJoint_LMB12.thk = 100;
CGinfo.KJoint_LMB12.SN = 'API_WJ_CP';

CGinfo.KJoint_VB12.thk = 100;
CGinfo.KJoint_VB12.SN = 'API_WJ_CP';

CGinfo.KJoint_LMB21.thk = 100;
CGinfo.KJoint_LMB21.SN = 'API_WJ_CP';

CGinfo.KJoint_VB21.thk = 100;
CGinfo.KJoint_VB21.SN = 'API_WJ_CP';

CGinfo.KJoint_LMB13.thk = 100;
CGinfo.KJoint_LMB13.SN = 'API_WJ_CP';

CGinfo.KJoint_VB13.thk = 100;
CGinfo.KJoint_VB13.SN = 'API_WJ_CP';

CGinfo.KJoint_LMB31.thk = 100;
CGinfo.KJoint_LMB31.SN = 'API_WJ_CP';

CGinfo.KJoint_VB31.thk = 100;
CGinfo.KJoint_VB31.SN = 'API_WJ_CP';

CGinfo.KJoint_LMB23.thk = 100;
CGinfo.KJoint_LMB23.SN = 'API_WJ_CP';

CGinfo.KJoint_VB23.thk = 100;
CGinfo.KJoint_VB23.SN = 'API_WJ_CP';

CGinfo.KJoint_LMB32.thk = 100;
CGinfo.KJoint_LMB32.SN = 'API_WJ_CP';

CGinfo.KJoint_VB32.thk = 100;
CGinfo.KJoint_VB32.SN = 'API_WJ_CP';

CGinfo.UMB12_Can.thk = 50;
CGinfo.UMB12_Can.SN = 'API_WJ_Air';

CGinfo.UMB13_Can.thk = 50;
CGinfo.UMB13_Can.SN = 'API_WJ_Air';

CGinfo.UMB21_Can.thk = 35;
CGinfo.UMB21_Can.SN = 'API_WJ_Air';

CGinfo.UMB31_Can.thk = 35;
CGinfo.UMB31_Can.SN = 'API_WJ_Air';

CGinfo.UMB23_Can.thk = 37;
CGinfo.UMB23_Can.SN = 'API_WJ_Air';

CGinfo.UMB32_Can.thk = 37;
CGinfo.UMB32_Can.SN = 'API_WJ_Air';

CGinfo.VB12_Can.thk = 50;
CGinfo.VB12_Can.SN = 'API_WJ_Air';

CGinfo.VB13_Can.thk = 50;
CGinfo.VB13_Can.SN = 'API_WJ_Air';

CGinfo.VB21_Can.thk = 35;
CGinfo.VB21_Can.SN = 'API_WJ_Air';

CGinfo.VB31_Can.thk = 35;
CGinfo.VB31_Can.SN = 'API_WJ_Air';

CGinfo.VB23_Can.thk = 37;
CGinfo.VB23_Can.SN = 'API_WJ_Air';

CGinfo.VB32_Can.thk = 37;
CGinfo.VB32_Can.SN = 'API_WJ_Air';
%Parts to Run
% Parts = {'KJoint_LMB12','KJoint_VB12','KJoint_LMB21','KJoint_VB21','KJoint_LMB13','KJoint_VB13','KJoint_LMB31','KJoint_VB31','KJoint_LMB23','KJoint_VB23','KJoint_LMB32','KJoint_VB32'};
Parts = {'UMB12_Can','UMB21_Can','UMB13_Can','UMB31_Can','UMB23_Can','UMB32_Can','VB12_Can','VB13_Can','VB21_Can','VB31_Can','VB23_Can','VB32_Can'};
%Input for method3

InputMthd3.gamma1 = 2; %Gamma for wind sea spectrum, site specific
%Input for method8 
InputMthd8.gamma1 = 1; %Gamma for wind sea spectrum, site specific
InputMthd8.gamma2 = 2.2; %Gamma for swell spectrum, site specific
InputMthd8.periods = MaxPeriod:-1:MinPeriod;
% InputMthd3.gamma2 = 2.2; %Gamma for swell spectrum, site specific
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
method_plot = 8;
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
Group_all = {'Truss_CG1','Truss_CG2','IS_CG1','IS_CG2','OS_CG1','OS_CG2','RingVbar_CG1','RingVbar_CG2','Bkh_CG1','OSRG_CG1','KFGdr_CG1'};
HotspotGroups = Group_all(1);

HspIptMthd6.gamma1 = 1; %Gamma for wind sea spectrum, site specific
HspIptMthd6.gamma2 = 2.2; %Gamma for swell spectrum, site specific
HspIptMthd6.periods = MaxPeriod:-1:MinPeriod; %Periods simulated

HspIptMthd7.dt = 0.1; %s, time step for generated stress time series
HspIptMthd7.totaltime = 600; %s, time step for generated stress time series
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