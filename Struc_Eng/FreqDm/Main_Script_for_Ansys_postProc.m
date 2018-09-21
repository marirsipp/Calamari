%%% Matlab post-processing tool for Ansys results
%%% Keep same order to run the post-processing
%%% As inputs have to be changed for each post processing it is safer to
%%% use those scripts as they were built and not use a function calling all
%%% those scripts below
%%% CHECK INPUT OF EACH FILE BEFORE EACH RUN
%% General input file 
% Make a copy of the FreqFatig_ipt.sample in the \Structural-Eng\FreqDm\Main_Codes folder
% Make it a .m file and put it in the folder \Structural-Eng\FreqDm\Input_files

FreqFatig_XX_ipt
% information like directory path, iteration number,... are set here

%% Library of the elements thicknesses
% In folder \Structural-Eng\FreqDm\Main_Codes
% output thickness.mat

ThkLib_WFA
% make an entry and run only related section

%% Library of the SN curves
% input path0
% output SNcurve.mat

SNcurveLib

%% Compute stressRAO and fatigue life for all elements for each Named Selection group
% Usually with a coarser method, for the purpose of prescreening
% All inputs defined in the ipt file
% Output: 
% - (GroupName)_Top(Btm)_Shs0.mat in (path0)\(ItrNo) folder, stress RAO files
% - (GroupName).csv and .mat files in the (path0)\(ItrNo)\Result_Mthd()
%   folder, fatigue life results files 

FreqFatig_AllParts

%% Plotting fatigue life results - by part
% Dividing fatigue results of the group into smaller groups (part) and plot them 
% Will need to be rewritten for more general application
% All inputs defined in the ipt file
% Output: 
% -(PartName).csv and .mat in (path0)\(ItrNo)\Result_Mthd()\(GroupName)
%  folder, fatigue results files 
% -(PartName)_Top(Btm).fig in the (path0)\(ItrNo)\Result_Mthd()\(GroupName)
%  folder, fatigue life plots 

PlotFatigLife_WFA_Itr16_0_LMB

%% Plotting and screening fatigue life results - by connection
% Dividing fatigue results of each part into even smaller smaller groups (connection) and plot them 
% Will need to be rewritten for more general application
% All inputs defined in the ipt file
% Pre-requisite
% 
% Output: 
% -(CnntName)_Top(Btm).fig in the
%  (path0)\(ItrNo)\Result_Mthd()\(GroupName)\Connection folder, fatigue 
%  life plots  
% -(GroupName)_Elem2Run.mat in (path0)\(ItrNo)\Result_Mthd(), selected
%  elements that have lower fatigue life value than specified target 

PlotFatigLife_WFA_ByCnnt_TrussCG2 %for LMB_nominal
PlotFatigLife_WFA_ByCnnt_TrussCG1 %for LMB_Can
PlotFatigLife_WFA_ByCnnt_RingVbarCG1 %for LMB_Rings
PlotFatigLife_WFA_ByCnnt_RingVbarCG2 %for LMB_FB
PlotFatigLife_WFA_ByCnnt_ISCG2 %for IS_Bot
PlotFatigLife_WFA_ByCnnt_OSCG2 %for OS_Bot
etc

%% Summary of worst element of each connection

FatigueResultSummary
%% Computing fatigue results of worst element of each connection
% Output:
% - Life.mat in the (path0)\(ItrNo)\Result_Mthd() folder

FreqFatig_HotSpot

%% Computing fatigue results of pre-selected elements of each connection

FreqFatig_SelectELem
%% Summary of select element results
% Output:
% - SelElem_Summary.xls in the (path0)\(ItrNo)\(Result_Mthd)\SelElem folder
SelElemSummary