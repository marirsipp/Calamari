%% Post processes stress output from ANSYS into stress matrix and SCF matrix.
% Also samples stress matrix for time domain fatigue analysis
% Run TmFatig_ipt_(ComputerName).m before this code

%------------------------Inputs--------------------------------------------
% %General path for data
% path0='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
% ItrNo = 'ItrR5_15_4';
% Loads = {'Fx';'Fy';'Fz';'Mx';'My';'Mz'}; %name of the force/moment in fatigue load time series
% LoadValue = [100, 100, 100, 1000, 1000, 1000]; %kN for forces and kNm for moments, force/moment value of unit load cases applied in ANSYS

% %Nominal stress, MPa
% StrNml = [0.2,0.2,0.1,0.6,0.6,0.3];
% CutRto = 2;
% 
% %Whether pick the worst node from previous results
% PickWorst = 'n';
% PickWstHsp = 'n';
% PrvItr = 'ItrR5_15_4';
% PrvBatch = 'BatchA_Vestas2';
% PrvStrOpt = 'S1or2';
%------------------------Inputs--------------------------------------------

%Paths for stress raw data and processed stress matrix
path_norm = [path0 ItrNo '\NormStr\']; mkdir(path_norm);
path_str = [path0 ItrNo '\StrMtrx\']; mkdir(path_str);
path_SCF = [path0 ItrNo '\SCFMtrx\']; mkdir(path_SCF);
path_hsp = [path0 ItrNo '\HotSpots\']; mkdir(path_hsp);
path_itr = [path0 ItrNo '\']; mkdir(path_itr);

Load1 = Loads{1};

%Scale factor when creating stress matrix
if strcmp(StrUnit,'MPa');
    unitscale = 1;
elseif strcmp(StrUnit,'Pa')
    unitscale = 1e6;
end

%To scale all stress results to stress in MPa due to 1kN/1kNm load 
for n=1:length(Loads)  
    StrScale.(Loads{n}) = 1/LoadValue(n)/unitscale;
end

%Connection info
load([path_itr 'CnntInfo.mat']);
if ~strcmp(Cnnt.Itr,ItrNo)
    disp('Connection info does not contain the correct iteration no. Check input')
end
%%
%-----------------Write Stress and SCF matrix------------------------------
cd(path_norm)
fnames = dir('*.csv');
if isempty(fnames) == 1
    disp('Please copy the Ansys output csv files into the folder «NormStr»')
end
numfids = length(fnames);
num_cnnts = numfids/6;

if num_cnnts ~= floor(num_cnnts)
    disp('Output stress files missing for one or more load cases')
end

for n = 1:numfids
    
    filename = fnames(n).name;
    ind1 = regexp(filename,'_');
    ind2 = regexp(filename,'.csv');
    LineNo = filename(1:ind1(1)-1);
    PartName = filename(ind1(1)+1:ind1(2)-1);
    TorB = filename(ind1(2)+1:ind1(3)-1);
    Load = filename(ind1(3)+1:ind2-1);
    
    if strcmp(Load,Load1)
        thk = Cnnt.(LineNo).(PartName).thk;
        axisTT = Cnnt.(LineNo).(PartName).axisTT;
        BuildStrMtrx_Gen_anyLoad(path_norm, path_str, LineNo, PartName, TorB, thk, axisTT,Loads, StrScale)
        BuildSCFMtrx_Gen_anyLoad(path_str, path_SCF, LineNo, PartName, TorB, StrNml ,CutRto,Loads)
    end
    
end
%%
%------------------Write Sample Stress matrix------------------------------
WriteSmplStrMtrx(path_itr,path_str,path_hsp,Cnnt)
%%
%------------------Write Worst Hotspot Stress matrix-----------------------
if strcmp(PickWorst,'y')
    path_rst = [path0 PrvItr '\' PrvBatch '\TmFatigue\' PrvStrOpt '\'];
    path_str = [path0 ItrNo '\StrMtrx\' ];
    path_out = [path0 ItrNo '\Worst\' ];
    PickWorstNode(path_rst, path_str, path_out, PrvStrOpt, tol_length, tol_angle)
end

if strcmp(PickWstHsp,'y')
    path_rst = [path0 PrvItr '\' PrvBatch '\TmFatigueHsp\' PrvStrOpt '\'];
    path_str = [path0 ItrNo '\StrMtrx\' ];
    path_out = [path0 ItrNo '\Worst_Hsp\' ];
    PickWorstNode(path_rst, path_str, path_out, PrvStrOpt, tol_length, tol_angle)
end
%%
%From simplified method
path_simprst = [path0 ItrNo '\' strBatch '\Simplified'];
if exist(path_simprst,'dir')
    path_str = [path0 ItrNo '\StrMtrx\' ];
    path_out = [path0 ItrNo '\Worst_Simp\' ];
    if ~exist(path_out,'dir')
        mkdir(path_out)
    end
    PickWorstNode(path_simprst, path_str, path_out, '', tol_length, tol_angle)
end