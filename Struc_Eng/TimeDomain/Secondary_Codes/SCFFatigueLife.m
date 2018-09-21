function [] = SCFFatigueLife(path0, LineNo, PartName, TorB, EqvLd, BatchNo, TB_t,TB_r)
%Calculation of design fatigue life based on fatigue-damage-equivalent
%loadings

% path0 = 'C:\Users\Engineer\Documents\MATLAB\TimeDomain\Itr14_1\';
% LineNo = 'L1'; %Connection number
% PartName = 'TB'; 
% TorB = 'Top'; %Top or bottom surface
% EqvLd = [1030,831,65506,82210]; %Fx_eq, Fy_eq, Mx_eq, My_eq
% BatchNo = 'Batch01'; %Load batch number
% TB_t = 50; %Tower base wall thickness, mm
% TB_r = 3250; %Tower base radius, mm

%--------------------------- READ INPUT FILE ------------------------------
path = [path0 'SCFMtrx\'];
FileName = [path,'SCFMtx_',LineNo,'_',PartName,'_',TorB,'.csv'];

data=importdata(FileName);
thk = data(:,5); %mm, member thickness
SCF_fx = data(:,6); 
SCF_fy = data(:,7); 
SCF_mx = data(:,9);
SCF_my = data(:,10);
SN = data(:,13); %S-N curve choices, 1-ABS_E, 2-API
Mthd = data(:,12); %Hot spot is dominated by loads in 1-Mx, 2-My, 3-Both Mx and My
Nhsp = length(thk); %Total number of hot spots

Output = zeros(Nhsp,6);
Output(:,1:4) = data(:,1:4); %Node number, x-coord, y-coord, z-coord

%----------------------- SET UP INPUT & CONSTANTS -------------------------
%Input DELs (damage-equivalent loads)
MXeq = EqvLd(3); %kNm
MYeq = EqvLd(4); %kNm
FXeq = EqvLd(1); %kN
FYeq = EqvLd(2); %kN 

%S-N curves
%ABS-E
t_ref = 22; %mm, reference thickness
kcorr = 0.25; %For thickness correction
A     = 1.04e12; %For S in MPa
C     = 2.30e15; %For S in MPa
m     = 3;
r     = 5;
N0    = 10^7;
S0    = 47; %MPa

%API
t_ref_p   = 16; %mm
kcorr_p   = 0.25;
log10k1_a = 12.48; %For S in MPa
log10k1_b = 16.13; %For S in MPa
m_a       = 3;
m_b       = 5;
N0_p      = 10^7;
S0_p      = 10^ ((log10k1_a-log10(N0_p))/m_a); %MPa

%ABS-E, CP
A_3   = 4.16e11; %For S in MPa
C_3   = 2.30e15; %For S in MPa
m_3   = 3;
r_3   = 5;
N0_3    = 1.01e6;
S0_3    = 74.4; %MPa

%API, CP
A_4   = 1.51e12; %For S in MPa
C_4   = 1.35e16; %For S in MPa
m_4   = 3;
r_4   = 5;
N0_4    = 1.8e6;
S0_4    = 94; %MPa

%--------------------- CALCULATE HOT SPOT STRESS -------------------------
Meq_nd = (MXeq^3 + MYeq^3) ^(1/3); %kNm, Non-directional equivalent moment
Feq_nd = (FXeq^3 + FYeq^3) ^(1/3); %kN, Non-directional equivalent shear force

TB_A = pi * TB_r*2 * TB_t; %mm^2, Tower base cross section area
TB_I = pi * TB_r^3 * TB_t; %mm^4, Tower base cross section area moment of inertia

Sn_mx = MXeq * 10^6 * TB_r / TB_I; %MPa, norminal stress at tower base due to Mx_eq
Sn_my = MYeq * 10^6 * TB_r / TB_I; %MPa, norminal stress at tower base due to My_eq
Sn_fx = 2 * FXeq * 10^3 / TB_A; % MPa, norminal stress at tower base due to Fx_eq
Sn_fy = 2 * FYeq * 10^3 / TB_A; % MPa, norminal stress at tower base due to Fy_eq

S_mx = SCF_mx * Sn_mx; %MPa, hot spot stresses due to Mx_eq
S_my = SCF_my * Sn_my; %MPa, hot spot stresses due to My_eq
S_fx = SCF_fx * Sn_fx; %MPa, hot spot stresses due to Fx_eq
S_fy = SCF_fy * Sn_fy; %MPa, hot spot stresses due to Fy_eq

Sn_m = Meq_nd * 10^6 * TB_r / TB_I; %MPa, norminal stress at tower base due to non-directional M_eq
Sn_f = 2 * Feq_nd * 10^3 / TB_A; % MPa, norminal stress at tower base due to non-directional F_eq

S_mx2 = SCF_mx * Sn_m; %MPa, hot spot stresses due to M_eq in x direction
S_my2 = SCF_my * Sn_m; %MPa, hot spot stresses due to M_eq in y direction
S_fx2 = SCF_fx * Sn_f; %MPa, hot spot stresses due to F_eq in x direction
S_fy2 = SCF_fy * Sn_f; %MPa, hot spot stresses due to F_eq in y direction

S = [S_mx,S_my,S_fx,S_fy,S_mx2,S_my2,S_fx2,S_fy2];

% thickness correction
for i = 1:Nhsp
    if (SN(i) == 1)||(SN(i) == 3) %ABS-E curves
        
        if thk(i) > t_ref
            S_corr(i,:) = S(i,:)* (thk(i)/t_ref).^kcorr;
        else
            S_corr(i,:) = S(i,:);
        end
        
    elseif (SN(i) == 2)||(SN(i) == 4) %API RP-2A curve
            
        if thk(i) > t_ref_p
            S_corr(i,:) = S(i,:)* (thk(i)/t_ref_p).^kcorr_p;
        else
            S_corr(i,:) = S(i,:);
        end  
    end
end

%------------ CALCULATE FATIGUE LIFE DUE TO SINGLE LOAD -------------------

for i = 1:Nhsp
    
    if SN(i) == 1 %ABS-E curve
        
        for j = 1: size(S,2)            
            if S_corr(i,j) >= S0
                N(i,j) = A / S_corr(i,j)^m; %No of cycles to failure due to S(j) for ith hot spot
            else
                N(i,j) = C / S_corr(i,j)^r;
            end
        end
            
    elseif SN(i) == 2 %API RP-2A curve
            
        for j = 1: size(S,2)            
            if S_corr(i,j) >= S0_p
                N(i,j) = 10^ (log10k1_a - m_a*log10(S_corr(i,j))); 
            else
                N(i,j) = 10^ (log10k1_b - m_b*log10(S_corr(i,j))); 
            end
        end
            
    elseif SN(i) == 3 %ABS-E CP
        
        for j = 1: size(S,2)            
            if S_corr(i,j) >= S0_3
                N(i,j) = A_3 / S_corr(i,j)^m_3; %No of cycles to failure due to S(j) for ith hot spot
            else
                N(i,j) = C_3 / S_corr(i,j)^r_3;
            end
        end
        
    elseif SN(i) == 4 %API CP
        
        for j = 1: size(S,2)            
            if S_corr(i,j) >= S0_4
                N(i,j) = A_4 / S_corr(i,j)^m_4; %No of cycles to failure due to S(j) for ith hot spot
            else
                N(i,j) = C_4 / S_corr(i,j)^r_4;
            end
        end
        
    end
        
end

Life = N / 1e7 * 25; %years

%----------- CALCULATE FATIGUE DAMAGE DUE TO COMBINED TWO LOADS------------
%Mx+Fy
alpha1 = S_corr(:,4)./S_corr(:,1); %Sfy_corr./Smx_corr;
Dmx = 1./ Life(:,1);
Dmxfy(:,1) = Dmx .* (1+alpha1).^m;
Dmxfy(:,2) = Dmx .* (1+alpha1).^r;

%My+Fx
alpha2 = S_corr(:,3)./S_corr(:,2); %Sfx_corr./Smy_corr;
Dmy = 1./ Life(:,2);
Dmyfx(:,1) = Dmy .* (1+alpha2).^m;
Dmyfx(:,2) = Dmy .* (1+alpha2).^r;

%Meq in X
Dmeqx = 1./Life(:,5);

%Meq in Y
Dmeqy = 1./Life(:,6);

%Mx+Feq in y
alpha3 = S_corr(:,8)./S_corr(:,1); %Sfy2_corr./Smx_corr;
%Dmx = 1./ Life(:,1);
Dmxfeqy(:,1) = Dmx .* (1+alpha3).^m;
Dmxfeqy(:,2) = Dmx .* (1+alpha3).^r;

%My+Feq in x
alpha4 = S_corr(:,7)./S_corr(:,2); %Sfy2_corr./Smx_corr;
%Dmy = 1./ Life(:,1);
Dmyfeqx(:,1) = Dmy .* (1+alpha4).^m;
Dmyfeqx(:,2) = Dmy .* (1+alpha4).^r;

%Meq in x+Feq in y
alpha5 = S_corr(:,8)./S_corr(:,5); %Sfy2_corr./Smx2_corr;
%Dmx = 1./ Life(:,1);
Dmeqxfeqy(:,1) = Dmeqx .* (1+alpha5).^m;
Dmeqxfeqy(:,2) = Dmeqx .* (1+alpha5).^r;

%Meq in y+Feq in x
alpha6 = S_corr(:,7)./S_corr(:,6); %Sfx2_corr./Smy2_corr;
%Dmx = 1./ Life(:,1);
Dmeqyfeqx(:,1) = Dmeqy .* (1+alpha6).^m;
Dmeqyfeqx(:,2) = Dmeqy .* (1+alpha6).^r;

%Summary of results
D = [Dmx,Dmy,Dmxfy(:,1),Dmyfx(:,1),Dmeqx,Dmeqy,Dmxfeqy(:,1),Dmyfeqx(:,1),Dmeqxfeqy(:,1),Dmeqyfeqx(:,1)];
FatigueLife = 1./D;

for i = 1:Nhsp
    if Mthd(i) == 1 
        EstLife(i,1) = FatigueLife(i,1);
        EstLife2(i,1) = FatigueLife(i,3);
    else if Mthd(i) == 2
        EstLife(i,1) = FatigueLife(i,2);
        EstLife2(i,1) = FatigueLife(i,4);
        else 
        EstLife(i,1) = min(FatigueLife(i,5),FatigueLife(i,6));
%         EstLife2(i,1) = min(FatigueLife(i,5),FatigueLife(i,6));
        EstLife2(i,1) = min(FatigueLife(i,9),FatigueLife(i,10));
        end
    end
end

Output(:,5) = EstLife;
Output(:,6) = EstLife2;

OutputName = [path0,BatchNo,'\',LineNo,'_',PartName,'_',TorB,'.csv'];
csvwrite(OutputName,Output)

end