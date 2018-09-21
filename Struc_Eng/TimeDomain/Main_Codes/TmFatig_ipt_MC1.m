%clc
clear all
% requires 2 files:
% 1. basebend forces/moment (specified by imat) for each bin with a matrix consisting of [time x 6 dof]
% 2. prob.mat contains a structure prob.(binname) = scalar, which is the probability of ocurrurence of bin
%------------------------- Input - General --------------------------------
path0 ='C:\Users\Nortada\Desktop\Document de Charlotte\WFA\MooringConnector\TimeDomain\'; 
ItrNo = 'Itr1_01';
strBatch = 'Orcaflex_loads_for_MC\MC_Col1'; %in path0 this is a directory where the loads exist
% file_pwr = 'Combine_BB_POWandPAR.mat'; % for imat = 2, name of file of basebend loads
% file_tran = 'Combine_BB_transients.mat'; % for imat = 2, name of file of transient basebend loads
tstep = 0.2; % [sec] time step of the time series of the loads
imat = 3; % load format: 0 - binary input file (.dat from Alan), 
		  % 1 - .mat input file, with variables run001 run002 etc.  
          % 2 - vestas load format (.mat) consits of 1 variable = vals.(runname1), vals.(runname2) = basebend timeseries [time x 6 dof]
          % 3 - vestas load format (.mat) consits of multiple files into
          % one folder. In each file the forces are stored by variable name, ie Fx, Fy or Mx, My or Fx1,Fx2,...
prob_adjust = 'y'; %Use adjusted probability in DEL and dmg calculation (Vestas had 113%!!)
include_tran = 'n'; %Include transient cases or not, 'y' - yes, 'n' - no ()
Loads = {'Fx1';'Fx2';'Fy1';'Fy2';'Fz1';'Fz2'}; %{'Fx';'Fy';'Fz';'Mx';'My';'Mz'} %we can have {Fx1, Fy1,Fz1,Fx2, Fy2,Fz2} or {Fx, Fy,Fz} instead of {Fx, Fy,Fz,Mx,My,Mz}
%---------------------- Input - For DEL calculation -----------------------
% INPUT DATA of M-N curve
Mu = 3e6; % [kNm], M0 of the M-N curve, does not affect the final results
m  = 3; % [-], exponent of M-N curve
N0 = 1e7; %[cycles], number of total cycles throughout lifespan. With Life_DEL, determines frequency of DEL (sinusoidal) timeseries
Life_DEL = 25; % [year], Lifespan of model. Final "DEL frequency" has large effect on final DEL magnitude.

TranTime = 0; %[sec] total transient time to take out in the beginning of simulation
Rot = 'y'; %[logical], only used for imat = 1, 'y' - loads are rotated into the platform coordinates; 'n' - nonrotated. (different filenames)

CalRotMmt = 'y';% [logical] calculate DEL at a certain angle in local coordinates (project the bending moments onto an arbitrary axis)
RotAngle = [30 60 120 150]; % [deg] (the angles of the arbitrary axes from +x going CCW)
CalFilter = 'n'; % [logical] whether or not to filter the time series before running rainflow counting
% Tfilt=[1, 3, 20]; % [sec], [lower end of the high pass filter (ignored), set to 0, lower end of the bandpass filter, lower end of the low-pass filter]
% Tfilt2=[3, 20, 40]; %[sec], [higher end of the high pass filter, higher end of the bandpass filter, upper end of the low-pass filter (ignored, set to inf)] 

%---------------------- Input - For Simplified method ---------------------
Meq_Angle = [0 30 60 90 120 150]; %In WF global coordinate
Meq = [58826 55848 55206 56033 58981 60811];

%---------------------- Input - For StrPostProc ---------------------------
%Nominal stress, MPa
StrNml = [0.2,0.2,0.1,0.6,0.6,0.3]; %MPa
StrNml = [0.2,0.2,0.1,0.6,0.6,0.3]*1e6; %Pa
CutRto = 2;

%Whether pick the worst node from previous results
PickWorst = 'n';
PickWstHsp = 'n';
% PrvItr = 'ItrR5_15_4';
% PrvBatch = 'BatchA_Vestas2';
% PrvStrOpt = 'S1or2';
% tol_length=15;
% tol_angle=0.5;

%---------------------- Input - For TimeFatigue ---------------------------
%Strfiles selection: method 1 - around connection; method2 - hot spot;
%Method 3 - Worst node around connections; %Method 4 - Worst node from hot
%spot
method = 1;
% filenum = 1; % Uncomment if you want only first path to be post-processed

%Stress choice - whose time history to be used for rainflow counting
%Options:
%S1or2 - Maximum or minimum principal stress
%Smax  - Choice of S1or2 with larger absolute value at each time instance
%Srot  - Normal stress at rotated surface wrt local coordinate system
%SY/SZ/SYZ - Normal stresses in local coordinate system
%TaoMax - Maximum shear stress
StrChoice.name = 'Srot';
StrChoice.theta = 0:30:150;
