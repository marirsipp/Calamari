function[] = SNcurveLib(path0)

%All intellectual property rights to and in this software (in which this 
%log is embedded) are owned exclusively by Principle Power, Inc. (“PPI”).
%This software may not be used by you, nor disclosed by you to any third 
%party, without the express written consent of PPI that grants you an 
%express license for use on the terms stated in such license.
%No implied licenses are given and any third party who receives this 
%software by error or otherwise without PPI’s consent is prohibited from 
%using or copying it and shall immediately inform PPI that this software 
%has come into its possession and promptly delete and destroy all copies 
%thereof.
%Removal of this embedded log from this software (or any copy or iteration 
%thereof) is strictly prohibited by law.

%Build S-N curve library
%Format of Two-segment S-N curve:
%For S>SQ, N<NQ: NS^m=A
%For S<SQ, N>NQ: NS^r=C

%S0: Stress range at the number of cycles at the slope change 
%N0: Number of cycles at the slope change
%m: Inverse of the slope at the first segment of the slope change
%r: Inverse of the slope at the second segment of the slope change
%A: Constant at the first segment of the slope chagne
%C: Constant at the second segment of the slope chagne
%t_ref: Reference thickness for the thickness correction formulation
%kcorr: Exponent for the thickness correction (NOTE 1)

%NOTE1: In the case of the BV formulation, this parameter is variable and
%depends on the type of detail. For this case, the exponent is set to 0.25
%which is the most conservative value.

%Path to store S-N curve library
%path0 = 'C:\Users\snarayanan.PPI\Documents\MATLAB\Structural-Eng\FreqDm\Main_Codes';
%path0 = 'C:\Users\Ansys.000\Documents\MATLAB\FreqDomain\';

%HISTORY OF CHANGES
%7/25/2018 - Alvaro Urruchi
%Included the fatigue curves for air, free corrosion and cathodic protection 
%according to the BV standards (NI 611). The exponent for the thickness 
%correction factor has been set at 0.25, which is the most conservative
%value. It can be changed through the connection info for optimization.

%ABS FAOS S-N Curves

SNcurve.ABS_E_Air.S0 = 47;
SNcurve.ABS_E_Air.N0 = 1e7;
SNcurve.ABS_E_Air.m = 3.0;
SNcurve.ABS_E_Air.r = 5.0;
SNcurve.ABS_E_Air.A = 1.04e12;
SNcurve.ABS_E_Air.C = 2.30e15;
SNcurve.ABS_E_Air.t_ref = 22; 
SNcurve.ABS_E_Air.kcorr = 0.25;

SNcurve.ABS_E_CP.S0 = 74.4; 
SNcurve.ABS_E_CP.N0 = 1.01e6;
SNcurve.ABS_E_CP.m = 3.0;
SNcurve.ABS_E_CP.r = 5.0;
SNcurve.ABS_E_CP.A = 4.16e11;
SNcurve.ABS_E_CP.C = 2.30e15;
SNcurve.ABS_E_CP.t_ref = 22; 
SNcurve.ABS_E_CP.kcorr = 0.25; 

SNcurve.API_WJ_Air.S0 = 67;
SNcurve.API_WJ_Air.N0 = 1e7;
SNcurve.API_WJ_Air.m = 3.0;
SNcurve.API_WJ_Air.r = 5.0;
SNcurve.API_WJ_Air.A = 3.02e12;
SNcurve.API_WJ_Air.C = 1.35e16;
SNcurve.API_WJ_Air.t_ref = 16; 
SNcurve.API_WJ_Air.kcorr = 0.25; 

SNcurve.API_WJ_CP.S0 = 94;
SNcurve.API_WJ_CP.N0 = 1.8e6;
SNcurve.API_WJ_CP.m = 3.0;
SNcurve.API_WJ_CP.r = 5.0;
SNcurve.API_WJ_CP.A = 1.51e12;
SNcurve.API_WJ_CP.C = 1.35e16;
SNcurve.API_WJ_CP.t_ref = 16; 
SNcurve.API_WJ_CP.kcorr = 0.25; 

SNcurve.ABS_B_Air.S0 = 100.2;
SNcurve.ABS_B_Air.N0 = 1e7;
SNcurve.ABS_B_Air.m = 4.0;
SNcurve.ABS_B_Air.r = 6.0;
SNcurve.ABS_B_Air.A = 1.01e15;
SNcurve.ABS_B_Air.C = 1.02e19;
SNcurve.ABS_B_Air.t_ref = 22; 
SNcurve.ABS_B_Air.kcorr = 0.25; 

SNcurve.ABS_B_CP.S0 = 158.5;
SNcurve.ABS_B_CP.N0 = 6.4e5;
SNcurve.ABS_B_CP.m = 4.0;
SNcurve.ABS_B_CP.r = 6.0;
SNcurve.ABS_B_CP.A = 4.04e14;
SNcurve.ABS_B_CP.C = 1.02e19;
SNcurve.ABS_B_CP.t_ref = 22; 
SNcurve.ABS_B_CP.kcorr = 0.25; 

SNcurve.ABS_C_Air.S0 = 78.2;
SNcurve.ABS_C_Air.N0 = 1e7;
SNcurve.ABS_C_Air.m = 3.5;
SNcurve.ABS_C_Air.r = 5.5;
SNcurve.ABS_C_Air.A = 4.23e13;
SNcurve.ABS_C_Air.C = 2.59e17;
SNcurve.ABS_C_Air.t_ref = 22; 
SNcurve.ABS_C_Air.kcorr = 0.25; 

SNcurve.ABS_C_CP.S0 = 123.7; 
SNcurve.ABS_C_CP.N0 = 8.1e5;
SNcurve.ABS_C_CP.m = 3.5;
SNcurve.ABS_C_CP.r = 5.5;
SNcurve.ABS_C_CP.A = 1.69e13;
SNcurve.ABS_C_CP.C = 2.59e17;
SNcurve.ABS_C_CP.t_ref = 22; 
SNcurve.ABS_C_CP.kcorr = 0.25; 

%One segment S-N curve for testing
SNcurve.ABS_E_Test.m = 3.0;
SNcurve.ABS_E_Test.A = 1.04e12;
SNcurve.ABS_E_Test.t_ref = 22; 
SNcurve.ABS_E_Test.kcorr = 0.25; 

%Bureau Veritas NI 611 S-N Curves

SNcurve.BV_C_Air.S0 = 78.19; 
SNcurve.BV_C_Air.N0 = 1e7;
SNcurve.BV_C_Air.m = 3.5;
SNcurve.BV_C_Air.r = 6;
SNcurve.BV_C_Air.A = 4.23e13;
SNcurve.BV_C_Air.C = 2.28e18;
SNcurve.BV_C_Air.t_ref = 25; 
SNcurve.BV_C_Air.kcorr = 0.25; 

SNcurve.BV_D_Air.S0 = 53.36; 
SNcurve.BV_D_Air.N0 = 1e7;
SNcurve.BV_D_Air.m = 3;
SNcurve.BV_D_Air.r = 5;
SNcurve.BV_D_Air.A = 1.52e12;
SNcurve.BV_D_Air.C = 4.33e15;
SNcurve.BV_D_Air.t_ref = 25; 
SNcurve.BV_D_Air.kcorr = 0.25; 

SNcurve.BV_E_Air.S0 = 46.96;
SNcurve.BV_E_Air.N0 = 1e7;
SNcurve.BV_E_Air.m = 3;
SNcurve.BV_E_Air.r = 5;
SNcurve.BV_E_Air.A = 1.04e12;
SNcurve.BV_E_Air.C = 2.28e15;
SNcurve.BV_E_Air.t_ref = 25; 
SNcurve.BV_E_Air.kcorr = 0.25; 

SNcurve.BV_F_Air.S0 = 39.82;
SNcurve.BV_F_Air.N0 = 1e7;
SNcurve.BV_F_Air.m = 3;
SNcurve.BV_F_Air.r = 5;
SNcurve.BV_F_Air.A = 6.31e11;
SNcurve.BV_F_Air.C = 1.00e15;
SNcurve.BV_F_Air.t_ref = 25; 
SNcurve.BV_F_Air.kcorr = 0.25; 

SNcurve.BV_F2_Air.S0 = 35.06;
SNcurve.BV_F2_Air.N0 = 1e7;
SNcurve.BV_F2_Air.m = 3;
SNcurve.BV_F2_Air.r = 5;
SNcurve.BV_F2_Air.A = 4.31e11;
SNcurve.BV_F2_Air.C = 5.30e14;
SNcurve.BV_F2_Air.t_ref = 25; 
SNcurve.BV_F2_Air.kcorr = 0.25;

SNcurve.BV_PNORM_Air.S0 = 53.36;
SNcurve.BV_PNORM_Air.N0 = 1e7;
SNcurve.BV_PNORM_Air.m = 3;
SNcurve.BV_PNORM_Air.r = 5;
SNcurve.BV_PNORM_Air.A = 1.52e12;
SNcurve.BV_PNORM_Air.C = 4.32e15;
SNcurve.BV_PNORM_Air.t_ref = 25; 
SNcurve.BV_PNORM_Air.kcorr = 0.25;

SNcurve.BV_PPARA_Air.S0 = 58.48;
SNcurve.BV_PPARA_Air.N0 = 1e7;
SNcurve.BV_PPARA_Air.m = 3;
SNcurve.BV_PPARA_Air.r = 5;
SNcurve.BV_PPARA_Air.A = 2.00e12;
SNcurve.BV_PPARA_Air.C = 6.84e15;
SNcurve.BV_PPARA_Air.t_ref = 25; 
SNcurve.BV_PPARA_Air.kcorr = 0.25;

SNcurve.BV_C_CP.S0 = 112.80; 
SNcurve.BV_C_CP.N0 = 1e7;
SNcurve.BV_C_CP.m = 3.5;
SNcurve.BV_C_CP.r = 6;
SNcurve.BV_C_CP.A = 1.69e13;
SNcurve.BV_C_CP.C = 2.29e18;
SNcurve.BV_C_CP.t_ref = 25; 
SNcurve.BV_C_CP.kcorr = 0.25; 

SNcurve.BV_D_CP.S0 = 84.38; 
SNcurve.BV_D_CP.N0 = 1e7;
SNcurve.BV_D_CP.m = 3;
SNcurve.BV_D_CP.r = 5;
SNcurve.BV_D_CP.A = 6.08e11;
SNcurve.BV_D_CP.C = 4.33e15;
SNcurve.BV_D_CP.t_ref = 25; 
SNcurve.BV_D_CP.kcorr = 0.25; 

SNCurve.BV_E_CP.S0 = 74.25;
SNcurve.BV_E_CP.N0 = 1e7;
SNcurve.BV_E_CP.m = 3;
SNcurve.BV_E_CP.r = 5;
SNcurve.BV_E_CP.A = 4.14e11;
SNcurve.BV_E_CP.C = 2.28e15;
SNcurve.BV_E_CP.t_ref = 25; 
SNcurve.BV_E_CP.kcorr = 0.25; 

SNcurve.BV_F_CP.S0 = 62.97;
SNcurve.BV_F_CP.N0 = 1e7;
SNcurve.BV_F_CP.m = 3;
SNcurve.BV_F_CP.r = 5;
SNcurve.BV_F_CP.A = 2.53e11;
SNcurve.BV_F_CP.C = 1.00e15;
SNcurve.BV_F_CP.t_ref = 25; 
SNcurve.BV_F_CP.kcorr = 0.25; 

SNcurve.BV_F2_CP.S0 = 55.44;
SNcurve.BV_F2_CP.N0 = 1e7;
SNcurve.BV_F2_CP.m = 3;
SNcurve.BV_F2_CP.r = 5;
SNcurve.BV_F2_CP.A = 1.72e11;
SNcurve.BV_F2_CP.C = 5.30e14;
SNcurve.BV_F2_CP.t_ref = 25; 
SNcurve.BV_F2_CP.kcorr = 0.25;

SNcurve.BV_PNORM_CP.S0 = 84.38;
SNcurve.BV_PNORM_CP.N0 = 1e7;
SNcurve.BV_PNORM_CP.m = 3;
SNcurve.BV_PNORM_CP.r = 5;
SNcurve.BV_PNORM_CP.A = 6.08e11;
SNcurve.BV_PNORM_CP.C = 4.33e15;
SNcurve.BV_PNORM_CP.t_ref = 25; 
SNcurve.BV_PNORM_CP.kcorr = 0.25;

SNcurve.BV_PPARA_CP.S0 = 94.47;
SNcurve.BV_PPARA_CP.N0 = 1e7;
SNcurve.BV_PPARA_CP.m = 3;
SNcurve.BV_PPARA_CP.r = 5;
SNcurve.BV_PPARA_CP.A = 8.00e11;
SNcurve.BV_PPARA_CP.C = 6.84e15;
SNcurve.BV_PPARA_CP.t_ref = 25; 
SNcurve.BV_PPARA_CP.kcorr = 0.25;

SNcurve.BV_C_FC.S0 = 50.21;
SNcurve.BV_C_FC.N0 = 1e7;
SNcurve.BV_C_FC.m = 3;
SNcurve.BV_C_FC.r = 3;
SNcurve.BV_C_FC.A = 1.27e12;
SNcurve.BV_C_FC.C = 1.27e12;
SNcurve.BV_C_FC.t_ref = 25; 
SNcurve.BV_C_FC.kcorr = 0.25; 

SNcurve.BV_D_FC.S0 = 37.00; 
SNcurve.BV_D_FC.N0 = 1e7;
SNcurve.BV_D_FC.m = 3;
SNcurve.BV_D_FC.r = 3;
SNcurve.BV_D_FC.A = 5.07e11;
SNcurve.BV_D_FC.C = 5.07e11;
SNcurve.BV_D_FC.t_ref = 25; 
SNcurve.BV_D_FC.kcorr = 0.25; 

SNcurve.BV_E_FC.S0 = 32.56; 
SNcurve.BV_E_FC.N0 = 1e7;
SNcurve.BV_E_FC.m = 3;
SNcurve.BV_E_FC.r = 3;
SNcurve.BV_E_FC.A = 3.45e11;
SNcurve.BV_E_FC.C = 3.45e11;
SNcurve.BV_E_FC.t_ref = 25; 
SNcurve.BV_E_FC.kcorr = 0.25; 

SNcurve.BV_F_FC.S0 = 27.61; 
SNcurve.BV_F_FC.N0 = 1e7;
SNcurve.BV_F_FC.m = 3;
SNcurve.BV_F_FC.r = 3;
SNcurve.BV_F_FC.A = 2.11e11;
SNcurve.BV_F_FC.C = 2.11e11;
SNcurve.BV_F_FC.t_ref = 25; 
SNcurve.BV_F_FC.kcorr = 0.25; 

SNcurve.BV_F2_FC.S0 = 24.31; 
SNcurve.BV_F2_FC.N0 = 1e7;
SNcurve.BV_F2_FC.m = 3;
SNcurve.BV_F2_FC.r = 3;
SNcurve.BV_F2_FC.A = 1.44e11;
SNcurve.BV_F2_FC.C = 1.44e11;
SNcurve.BV_F2_FC.t_ref = 25; 
SNcurve.BV_F2_FC.kcorr = 0.25;

SNcurve.BV_PNORM_FC.S0 = 37.00; 
SNcurve.BV_PNORM_FC.N0 = 1e7;
SNcurve.BV_PNORM_FC.m = 3;
SNcurve.BV_PNORM_FC.r = 3;
SNcurve.BV_PNORM_FC.A = 5.07e11;
SNcurve.BV_PNORM_FC.C = 5.07e11;
SNcurve.BV_PNORM_FC.t_ref = 25; 
SNcurve.BV_PNORM_FC.kcorr = 0.25;

SNcurve.BV_PPARA_FC.S0 = 40.55;
SNcurve.BV_PPARA_FC.N0 = 1e7;
SNcurve.BV_PPARA_FC.m = 3;
SNcurve.BV_PPARA_FC.r = 3;
SNcurve.BV_PPARA_FC.A = 6.67e11;
SNcurve.BV_PPARA_FC.C = 6.67e11;
SNcurve.BV_PPARA_FC.t_ref = 25; 
SNcurve.BV_PPARA_FC.kcorr = 0.25;

SNFile = [path0 'SNcurve.mat'];
save (SNFile, 'SNcurve')
end
