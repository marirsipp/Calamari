close all

% Create transient bins based on Vestas transient cases 
% By rotating tower base force and moment into different wind direction in
% postprocessing

% By Bingbin Yu, Principle Power Inc. 
% Reference:  
% \\Shark\Bingbin\Documents\Fatigue assessment\@WFP WFA\WFA\Time Domain\New
% model\Bin\Vestas\WFA_Bins4Vestas_IHCv2Reduced.xlsx

%Input - Information regarding wind direction distribution
DirInfo.phi0 = 300; %Vestas transient cases wind/wave direction
DirInfo.phi = 35:30:365;
DirInfo.dir_prob = [0.182	0.075	0.029	0.029	0.060	0.094	0.120	0.082	0.058	0.052	0.066	0.153]; %Based on Bin 10311

OutBatch = [strBatch '_Tran'];
path_out = [path0 OutBatch];
if ~exist(path_out,'dir')
    mkdir(path_out)
end

Ndir = length(DirInfo.phi);

file_pwr = 'Combine_BB_POWandPAR.mat'; 
file_tran = 'Combine_BB_transients.mat'; 
if strcmp(prob_adjust,'y')
    file_prob = 'prob_adj.mat';
else
    file_prob = 'prob.mat';
end

path1 = [ path0 '\' strBatch '\'];
TBtran = load([path1 file_tran]);
load([path1 file_prob]);

RunNames_tran = fieldnames(TBtran.vals);
nrun_tran = size(RunNames_tran,1);
        
for n= 1:nrun_tran
    M = TBtran.vals.(RunNames_tran{n});
    disp(['Running transient bin No. ' num2str(n)])
    p = prob.(RunNames_tran{n});
    for ii = 1:Ndir
        angle = (DirInfo.phi0 - DirInfo.phi(ii))/180*pi;
        Fx_rot = M(:,1)*cos(angle) - M(:,2)*sin(angle);
        Fy_rot = M(:,1)*sin(angle) + M(:,2)*cos(angle);
        Mx_rot = M(:,4)*cos(angle) - M(:,5)*sin(angle);
        My_rot = M(:,4)*sin(angle) + M(:,5)*cos(angle);
        
        run_name = [RunNames_tran{n} '_V' num2str(DirInfo.phi(ii))];
        vals.(run_name)= [Fx_rot,Fy_rot,M(:,3),Mx_rot,My_rot,M(:,6)];
        prob.(run_name) = p*DirInfo.dir_prob(ii);
        p_test(ii+(n-1)*Ndir) = p*DirInfo.dir_prob(ii);
    end    
end

file_tran_out = [path_out '\' file_tran];
file_prob_out = [path_out '\' file_prob];
save(file_tran_out,'vals')
save(file_prob_out,'prob')
            