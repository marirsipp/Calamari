%%% Matlab post-processing tool for Ansys results
%%% Keep same order to run the post-processing
%%% As inputs have to be changed for each post processing it is safer to
%%% use those scripts as they were built and not use a function calling all
%%% those scripts below
%%% CHECK INPUT OF EACH FILE BEFORE EACH RUN
%% General input file

TmFatig_ipt_WFA_MC
% information like directory path, iteration number,... are set here

%% Library of the elements thicknesses
% output thickness.mat

ThkLib_WFA_MC
% run only related section

%% Library of the connections set in Ansys
% output CnntInfo.mat

CnntInfo_WFA_MC
% run only related section

%% Library of the SN curves
% output SNcurve.mat

SNcurveLib

%% Create Stress Matrix and SCF Matrix from Ansys outputs

% StrPostProc
StrPostProc_anyLoad
% --> update BuildStrMtrx_Gen and BuildSCFMtrx_Gen if load input in ansys
% were not (Fx,Fy,Fz,Mx,My,Mz)
        % BuildStrMtrx_Gen_anyLoad, BuildSCFMtrx_Gen_anyLoad and
        % StrPostProc_anyLoad have been created for that purpose
% from the csv files from ansys (one file per connection per load case), build
% another csv file (one file per connection with 3 columns per load case)
% to keep only the directional stresses
% will use CnntInfo library

%% Compute stress matrix * time series for each connection, to get fatigue

TimeFatigue_AllCnnt_Gen

%% Post-processing

[Life] = FatigueLifeSummary(path0, ItrNo, strBatch, StrChoice.name)