% Jun 23 2017
% By Victor Sanchez
% Based on ViscForce_FatCalc.m by Sriram Narayanan

clear all;
close all;
clc;

tstart=tic; 
%% Input data

%General settings
iunit='si'; %SI or EU
imat = 1;
tstep = 1; %Time step, sec
thour = 24; %Number of hours
tday = 365; %Number of days
path0 = [cd, '\Sample_run']; %Working folder, must include .mat with loads and .txt with probabilities 
strBatch = 'Batch1'; %Name of .txt file with probabilities
loadFile = 'WEPFatigue_6_23_16'; %Name of the .mat loads file
numseed = 6; %Number of seed per bin
ncolumns = 3; %Number of columns

%Add rainflow counting function path
mydir=userpath;
addpath(genpath([mydir(1:end-1) filesep]));


% Define SN curve
% S0 = stress ant N0
% A = linear coeff in SN curve equation
% m = exponent in SN curve equation
% N0 = above this cycle limit a new equation is used (optional)
% C = linear coeff in modified SN curve equation
% r = exponent in modified SN curve equation
% t_ref = reference thickness for thickness correction
% kcorr = correciton factor for thickness correction
S0_SN = 123.7;
A_SN = 1.69E+13;
m_SN = 3.5;
N0_SN = 8.10E+05;
C_SN = 2.59E+17;
r_SN = 5.5;
t_ref_SN = 22;
kcorr_SN = 0.25;
SNcurve = struct('S0', S0_SN, 'A', A_SN, 'm', m_SN, 'N0', N0_SN, 'C', C_SN, 'r', r_SN, 't_ref', t_ref_SN, 'kcorr', kcorr_SN);
Thk = 28; %Thickness of the body rainflow counting is made on

%Introduce names of points to calculate
pnames = char('P_04LINE_R', 'P_04LINE_L', 'P_03LINE_L', 'P_SC_L', 'P_I4_L', 'P_I3_L', 'P_I3_R', 'P_I4_R', 'P_SC_R', 'P_03LINE_R');

%Reference force and stress matrix
force_stress_ref.Column1 = [
    0 0;
    776.010637 0.602;
    717.340765 1.025;
    712.975203 1.106;
    581.734920 1.043;
    520.695440 1.266;
    0 0;
    0 0;
    0 0;
    0 0;    
    ];

force_stress_ref.Column2 = [
    636.999340 0.6699;
    0 0;
    0 0;
    0 0;
    0 0;
    0 0;
    556.938771 1.0798;
    536.588074 0.9539;
    582.264156 0.9153;
    639.618299 1.1938;    
    ];

force_stress_ref.Column3 = [
    0 0;
    594.556490 0.6181;
    495.718231 0.9678;
    474.301713 0.8020;
    385.094625 1.7143;
    401.941618 2.7739;
    0 0;
    0 0;
    0 0;
    0 0;    
    ];


%% Read loads bin probability

a0 = [path0 '\' strBatch '.txt'] ; %.txt file containing percentage of probabilities of all bins
fid0 = fopen(a0,'r');
percent = fscanf(fid0,'%f',[1 Inf]);
fclose(fid0);
probinit = percent/10000; %Change probability to percentage
nruninit = length(probinit); %Number of bins
nrun = numseed*length(probinit); %Number of runs
proba = zeros(nrun,1); %Vector containing the probability of each bin
for i=1:nruninit
    proba(i*numseed-(numseed-1):i*numseed) = probinit(i); %Create a vector repeating the probabilities for the same bin, different seeds
end
if imat == 1
    filedat = strcat([path0, '\', loadFile,'.mat']); %Load in .mat file
end

pretyp = {'Force'}; %Name of load class goes here
ForceRFResult = []; %Initialize Rainflow Output Vector


%% Calculate fatigue damage

Maddress = load(filedat,'-regexp'); %Load the file containing force data
Ms1 = [];

for i= 1:nrun %Going thorugh runs
    for j = 1:length(pretyp)
        for k = 1:1:ncolumns %Going though columns (structure)
            for m = 1:length(pnames) %Going through points of the WEP
                %Read time series in binary format, generates names of the runs
                if i<10
                    strnum = ['10000',num2str(i)];
                elseif i<100 
                    strnum = ['1000',num2str(i)];
                else
                    strnum = ['100',num2str(i)];
                end
                if imat == 0
                    a1 = strcat([path1,strnum,'.dat']);
                    fid = fopen(a1);
                    M = fread(fid,'double');
                    fclose(fid);
                    M = reshape(M,7,length(M)/7);
                else
                    expr = ['Run',strnum];   
                    expr2 = pretyp{j};
                    M = Maddress.VisForce.(expr).(expr2){1,k}(:,m); %Copies Data from structure into M
                end
                M1 = M(:,1); %Unit TBW
                M1(isnan(M1(:,1)),:) = [];
                clear M;

                [NCH,NC] = rainflowdotexe( M1 ); %Perform rainflow counting on the force string
                FL = [NC;NCH]; %Create a vector contining half and full cycles
                SL = FL.*force_stress_ref.(['Column' num2str(k)])(m,2)./force_stress_ref.(['Column' num2str(k)])(m,1); %Translate force to stress
                %Create a vector with the multipliers for half cycles.
                %NOTE!!!! 0.5 for half cycles
                %In order to test the code against the previous procedure, remember to change to 1 the multiplier for half cycles
                %since in the previous version all cycles were considered as full
                HorF_No = [ones(length(NC),1);0.5*ones(length(NCH),1)]; 
                SL_corr = SL;
                
                % Thickness correction
                if isfield(SNcurve,'t_ref') && exist('Thk','var')
                  if Thk > SNcurve.t_ref
                      SL_corr = SL*(Thk/SNcurve.t_ref)^SNcurve.kcorr;    
                  end
                elseif isfield(SNcurve,'MBS')
                  SL_corr = SL/SNcurve.MBS;
                end
                
                %Number of cycles to failure
                NSL = SNcurve.A./(SL_corr).^SNcurve.m;  %Number to failure 
                if isfield(SNcurve,'S0') %Recalculation of the cycles for the other section of the SN curve
                index_above = find(SL_corr < SNcurve.S0);
                NSL(index_above)= SNcurve.C./(SL_corr(index_above)).^SNcurve.r; 
                end
                %Total damage by the input time series
                DSL = 1./NSL;
                DSL = sum(HorF_No.*DSL);
          
                clc
                fprintf('Step 1\n');
                fprintf('Run %i\n',i);
                fprintf('Column %i\n',k)
                fprintf('Point %i\n',m)
                
                %Struct containing the damage per seed
                ForceRFResult.(expr).Damage.([('Column'),num2str(k)]).(strtrim(pnames(m,:))) = DSL;
            end
        end
    end
end
%Save the .mat file containing the damage per seed
%save('D:\vsanchez\WEP_Fatigue\Fatigue_Rainflow\Sample_run\ForceRFResult.mat', 'ForceRFResult')

%% Calculate fatigue life

for k = 1:1:ncolumns %Going though columns (structure)
    for m = 1:length(pnames) %Going through points of the WEP
        damage_string = zeros(nrun, 1);
        %Read time series in binary format, generates names of the runs
        for i = 1:nrun
            if i<10
                strnum = ['10000',num2str(i)];
            elseif i<100 
                strnum = ['1000',num2str(i)];
            else
                strnum = ['100',num2str(i)];
            end
            expr = ['Run',strnum];     
            %Create a struct with the damage per bin
            damage_string(i) = ForceRFResult.(expr).Damage.([('Column'),num2str(k)]).(strtrim(pnames(m,:)));
            
            clc
            fprintf('Step 2\n');
            fprintf('Run %i\n',i);
            fprintf('Column %i\n',k)
            fprintf('Point %i\n',m)
        end 
        %Calculate the toal damage produce by all bins
        damage_x_prob = damage_string.*proba;
        DamageString.([('Column'),num2str(k)]).(strtrim(pnames(m,:))) = sum(damage_string);
        Total_dmg.([('Column'),num2str(k)]).(strtrim(pnames(m,:))) = sum(damage_x_prob);
        %Struct containing the fatigue life of the elements
        Fatigue_life.([('Column'),num2str(k)]).(strtrim(pnames(m,:))) = 1./(Total_dmg.([('Column'),num2str(k)]).(strtrim(pnames(m,:))).*thour.*tday);
    end
end

% for k = 1:1:ncolumns
%     c = [{['Point (Column' num2str(k) ')']} {'Fatigue life (years)'}; fieldnames(Fatigue_life.Column1) struct2cell(Fatigue_life.([('Column'),num2str(k)]))];
%     s = xlswrite(['Column' num2str(k) '.xls'], c);
% end

fprintf('Done!\n');

telapsed = toc(tstart);
fprintf('Running time: %f seconds\n', telapsed);