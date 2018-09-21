close all

% Calculation of Fatigue damage equivalent force/moment
% Based on output from RainFlow algorithm
% By Bingbin Yu, based on fatig_towerbase.m
% Reference:  
% [1] Freebury, Gregg and Musial, Walter. Determining equivalent damage 
%     loading for full-scale wind turbine blade fatigue tests. s.l. : 
%     National Renewable Energy Laboratory, 2000

%-----------------------Input----------------------------------------------
% Run TmFatig_ipt_[yourname].m first to load your workspace with the appropriate variables
%-----------------------Input----------------------------------------------

%

%If vestas load format 
if strcmp(prob_adjust,'y')
    file_prob = 'prob_adj.mat';
else
    file_prob = 'prob.mat';
end
% include_tran = 'y'; %Include transient cases or not, 'y' - yes, 'n' - no
% TranTime = 0; %total transient time to take out in the beginning of simulation, sec
% Rot = 'y';

path1 = [ path0 '\' strBatch '\'];
% cd(path_rainflow)

if (imat == 0) || (imat == 1)
    a0 = [path1 strBatch '.txt'] ;
    fid0 = fopen(a0,'r');
    percent = fscanf(fid0,'%f',[1 Inf]);
    fclose(fid0);
    proba=percent/100;
    nrun = length(proba);
elseif imat == 2
    load([path1 file_prob])
else
    disp('Input value of imat is invalid')
end

if imat == 1
    if strcmp (Rot,'y')
        filedat = strcat([path1,strBatch,'.mat']);
    else
        filedat = strcat([path1,strBatch,'_NoR','.mat']); %Loads following turbine orientation
    end
elseif imat == 2    
    TBloads = load([path1 file_pwr]);
    RunNames = fieldnames(TBloads.vals);
    nrun = size(RunNames,1);
end

Tot_D_year=zeros(6,1);

if strcmp(CalRotMmt,'y')
    N_angle = length(RotAngle);
    Tot_Dyr_Rot = zeros(N_angle,1);
    Tot_Dyr_FRot = zeros(N_angle,1);
end

if strcmp(CalFilter,'y')
    N_freq1 = length(Tfilt);
    N_freq2 = length(Tfilt);
    if N_freq1 ~= N_freq2
        disp('Input filter lower limits number does not match with upper limit number')
    else
        Tot_Dyr_filt = zeros(6,N_freq1);
    end
end

%% Power production and idling cases
for i= 1:nrun

    % Read time series in binary format
    M=[];
    
    if i<10
        strnum=['00',num2str(i)];
    elseif i<100
        strnum=['0',num2str(i)];
    else
        strnum=num2str(i);
    end
    
    if imat == 0
        
        a1=strcat([path1,strnum,'.dat']);
        fid=fopen(a1);
        M = fread(fid,'double');
        fclose(fid);
        M = reshape(M,6,length(M)/6);
        M1 = M'/1000; % kN or kNm
        
        disp(['Running bin No. ' num2str(i)])
        [Meq, Dmg]=CalDEL(M1, [], tstep, m, N0, Life_DEL, Mu, TranTime);
        DEL_bin(i,:) = Meq;
        Tot_D_year = Tot_D_year + proba(i)*Dmg;
        
        if strcmp(CalRotMmt,'y')
            for k = 1:N_angle
                theta = RotAngle(k)/180*pi;
                Mrot = M1(:,4)*cos(theta) + M1(:,5)*sin(theta);
                [Meq_rot,Dmg_rot] = CalDEL(Mrot, [], tstep, m, N0, Life_DEL, Mu, TranTime);
                DEL_bin_rot(i,k) = Meq_rot;
                Tot_Dyr_Rot(k,1) = Tot_Dyr_Rot(k,1) + proba(i)*Dmg_rot;
            end
        end
        
    elseif imat == 1 
        
        expr = ['run',strnum];
        expr1 = ['^', expr];
        Maddress = load(filedat,'-regexp',expr1); 
        M=(Maddress.(expr))';
        M1 = M'/1000; % kN or kNm
        
        disp(['Running bin No. ' num2str(i)])
        [Meq, Dmg]=CalDEL(M1, [], tstep, m, N0, Life_DEL, Mu, TranTime);
        DEL_bin(i,:) = Meq;
        Tot_D_year = Tot_D_year + proba(i)*Dmg;
        
        if strcmp(CalRotMmt,'y')
            for k = 1:N_angle
                theta = RotAngle(k)/180*pi;
                Mrot = M1(:,4)*cos(theta) + M1(:,5)*sin(theta);
                [Meq_rot,Dmg_rot] = CalDEL(Mrot, [], tstep, m, N0, Life_DEL, Mu, TranTime);
                DEL_bin_rot(i,k) = Meq_rot;
                Tot_Dyr_Rot(k,1) = Tot_Dyr_Rot(k,1) + proba(i)*Dmg_rot;
            end
        end
        
    elseif imat ==2
        
        M = TBloads.vals.(RunNames{i});
        disp(['Running bin No. ' num2str(i)])
        [Meq, Dmg]=CalDEL(M, [], tstep, m, N0, Life_DEL, Mu, TranTime);
        DEL_bin.((RunNames{i})) = Meq; % output, DEL by bin (unfiltered)
        Dmg_bin.((RunNames{i}))  = prob.(RunNames{i})*Dmg;
        Tot_D_year = Tot_D_year + Dmg_bin.((RunNames{i}));
        
        if strcmp(CalRotMmt,'y')
            for k = 1:N_angle
                theta = RotAngle(k)/180*pi;
                Mrot = M(:,4)*cos(theta) + M(:,5)*sin(theta);                
                [Meq_rot,Dmg_rot] = CalDEL(Mrot, [], tstep, m, N0, Life_DEL, Mu, TranTime);                
                DEL_bin_rot.((RunNames{i}))(1,k) = Meq_rot; % optional output, DEL by bin (rotated by arbitrary axes), second dimension is by angle
                Dmg_bin_rot.((RunNames{i}))(1,k) = prob.(RunNames{i})*Dmg_rot;
                Tot_Dyr_Rot(k,1) = Tot_Dyr_Rot(k,1) + Dmg_bin_rot.((RunNames{i}))(1,k);
                
                Frot = M(:,1)*cos(theta) + M(:,2)*sin(theta);
                [Feq_rot,Dmg_Frot] = CalDEL(Frot, [], tstep, m, N0, Life_DEL, Mu, TranTime);
                DEL_bin_Frot.((RunNames{i}))(1,k) = Feq_rot; % optional output, DEL by bin (rotated by arbitrary axes), second dimension is by angle
                Dmg_bin_Frot.((RunNames{i}))(1,k) = prob.(RunNames{i})*Dmg_Frot;
                Tot_Dyr_FRot(k,1) = Tot_Dyr_FRot(k,1) + Dmg_bin_Frot.((RunNames{i}))(1,k);
            end
        end
        
         if strcmp(CalFilter,'y')
            for k = 1:N_freq1
                if k == 1
                    n_order = 5;
                else
                    n_order = 4;
                end
                M_filt = LoadFilt (M,Tfilt,Tfilt2,k,tstep,n_order);
                [Meq_filt,Dmg_filt] = CalDEL(M_filt, [], tstep, m, N0, Life_DEL, Mu, TranTime);
                DEL_bin_filt.((RunNames{i}))(:,k) = Meq_filt; % optional output, DEL by bin (filtered using Tfilt), second dimension is freq range of filter
                Dmg_bin_filt.((RunNames{i}))(:,k) = prob.(RunNames{i})*Dmg_filt;
                Tot_Dyr_filt(:,k) = Tot_Dyr_filt(:,k) + Dmg_bin_filt.((RunNames{i}))(:,k);
            end
         end
        
    end    
end

M_eq = (Tot_D_year * Life_DEL * Mu^m / N0) .^ (1/m); % Using user-defined M-N curve, calculate equivalent moment based on total damage (scalar)
if strcmp(CalRotMmt,'y')
    M_eq_rot = (Tot_Dyr_Rot * Life_DEL * Mu^m / N0) .^ (1/m); % Using user-defined M-N curve, calculate equivalent moment based on rotated total damage (1 x angle )
    F_eq_rot = (Tot_Dyr_FRot * Life_DEL * Mu^m / N0) .^ (1/m);
end

if strcmp(CalFilter,'y')
    M_eq_filt = (Tot_Dyr_filt * Life_DEL * Mu^m / N0) .^ (1/m); % Using user-defined M-N curve, calculate equivalent moment based on rotated total damage (1 x filt )
end

%% Transient cases

if imat == 2    
    if strcmp(include_tran,'y')
        TBtran = load([path1 file_tran]);
        Tot_D_year1 = zeros(6,1); %Transient cases alone
        Tot_D_year2 = Tot_D_year; %Total 
        
        if strcmp(CalRotMmt,'y')
            Tot_Dyr_Rot1 = zeros(N_angle,1); %Transient cases alone
            Tot_Dyr_Rot2 = Tot_Dyr_Rot; %Total 
        end
        
        RunNames_tran = fieldnames(TBtran.vals);
        nrun_tran = size(RunNames_tran,1);
        
        for i= 1:nrun_tran
            M = TBtran.vals.(RunNames_tran{i});
            disp(['Running transient bin No. ' num2str(i)])
            [Meq, Dmg]=CalDEL(M, [], tstep, m, N0, Life_DEL, Mu, TranTime);
            DEL_bin_tran.((RunNames_tran{i})) = Meq;
            Tot_D_year1 = Tot_D_year1 + prob.(RunNames_tran{i})*Dmg;
            Tot_D_year2 = Tot_D_year2 + prob.(RunNames_tran{i})*Dmg;
            
            if strcmp(CalRotMmt,'y')
                for k = 1:N_angle
                    theta = RotAngle(k)/180*pi;
                    Mrot = M(:,4)*cos(theta) + M(:,5)*sin(theta);
                    [Meq_rot,Dmg_rot] = CalDEL(Mrot, [], tstep, m, N0, Life_DEL, Mu, TranTime);
                    DEL_bin_TranRot.((RunNames_tran{i}))(1,k) = Meq_rot;
                    Tot_Dyr_Rot1(k,1) = Tot_Dyr_Rot1(k,1) + prob.(RunNames_tran{i})*Dmg_rot;
                    Tot_Dyr_Rot2(k,1) = Tot_Dyr_Rot2(k,1) + prob.(RunNames_tran{i})*Dmg_rot;
                end
            end
        end
        
        M_eq1 = (Tot_D_year1 * Life_DEL * Mu^m / N0) .^ (1/m); %Transient cases alone
        M_eq2 = (Tot_D_year2 * Life_DEL * Mu^m / N0) .^ (1/m); %Total pp, idl and tran
        
        if strcmp(CalRotMmt,'y')
            M_eq_rot1 = (Tot_Dyr_Rot1 * Life_DEL * Mu^m / N0) .^ (1/m); %Transient cases alone
            M_eq_rot2 = (Tot_Dyr_Rot2 * Life_DEL * Mu^m / N0) .^ (1/m); %Total pp, idl and tran
        end
    
    end
end

%% Output bin results
out_name = [path1 'DEL_bin.mat'];
save(out_name, '-regexp','^DEL_bin','^M_eq','^Dmg_bin')
