clear all

%Stores member thickness information for iterations

%--------------------Frequency Domain Models-------------------------------
n = 1; %Thickness set number
%path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr13_5';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 85;
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 45;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 40;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk       = 20;

Thk(n).Col1.Bkh        = 21;
Thk(n).Col1.FB         = 15;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 32;
Thk(n).KJnt.VB = 25;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB        = 30;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%%
n = 1; %Thickness set number
%path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr13_6';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 85;
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 45;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 40;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;

Thk(n).Col1.Bkh        = 21;
Thk(n).Col1.FB         = 15;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 32;
Thk(n).KJnt.VB = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 25;
Thk(n).KJnt.LwrFB = 20;
Thk(n).KJnt.Brkt = 20;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB        = 30;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')

%%
n = 1; %Thickness set number
%path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr13_7';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 85;
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 45;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 40;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;

Thk(n).Col1.Bkh        = 21;
Thk(n).Col1.FB         = 15;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB = 25;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 25;
Thk(n).KJnt.LwrFB = 25;
Thk(n).KJnt.Brkt = 20;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB        = 30;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%%
n = 1; %Thickness set number
%path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr13_6dp1';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 85;
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 45;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 40;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 21;
Thk(n).Col1.FB         = 15;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 32;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 25;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 25;
Thk(n).KJnt.LwrFB = 20;
Thk(n).KJnt.Brkt = 20;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB        = 30;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%%
n = 1; %Thickness set number
%path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr13_9';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 85;
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 40;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 21;
Thk(n).Col1.FB         = 15;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 25;
Thk(n).KJnt.VB23 = 25;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 25;
Thk(n).KJnt.LwrFB = 30;
Thk(n).KJnt.Brkt = 30;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.FB = 30;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr13_10
n = 1; %Thickness set number
%path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr13_10';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 85;
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 40;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 21;
Thk(n).Col1.FB         = 15;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 12;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 25;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBring = 45;
Thk(n).Nominal.FB = 40;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr13_10_noTwr
n = 1; %Thickness set number
%path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr13_10_noTwr';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt  = 85;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 21;
Thk(n).Col1.FB         = 15;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 25;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 25;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBring = 45;
Thk(n).Nominal.FB = 40;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr13_10_NewLoad
n = 1; %Thickness set number
%path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr13_10_NewLoad';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 85;
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 40;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 21;
Thk(n).Col1.FB         = 15;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 12;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 25;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBring = 45;
Thk(n).Nominal.FB = 40;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr16_0_LMB
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr16_0_LMB';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 25;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr16_1
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr16_1';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 13;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')

%% Itr16_0_KJnt
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr16_0_5_KJnt';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 25;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 25;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBinst = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 13;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr16_2
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr16_2';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 13;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr16_3
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr16_3';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 13;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr16_4
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr16_4';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 30;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')

%% Itr13_11
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr13_11';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 13;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')

%% Itr16_4_1_LMB
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr16_4_1_LMB';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;
Thk(n).Nominal.FBins = 50;

Thk(n).WEP.Nominal = 30;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')

%% Itr16_4_2_LMB
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr16_4_2_LMB';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 25;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;
Thk(n).Nominal.FBins = 40;

Thk(n).WEP.Nominal = 30;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')

%% Itr16_1_Keel
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr16_1_Keel';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;
Thk(n).Col1.KFin      = 25; %Keel flat inside IS
Thk(n).Col1.KFout      = 28; %Keel flat betwee IS OS

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.KF      = 23;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 13;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')

%% Itr16_6
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr16_6';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 30;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr16_6_5
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr16_6_5';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 30;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr16_6_6
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr16_6_6';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 30;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr16_6_2H
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr16_6_2H';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 30;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr16_5
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr16_5';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 30;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')

%% Itr17_0_LMB
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr17_0_LMB';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 13;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')

%% Itr17_0_5_LMB
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr17_0_5_LMB';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 25;
Thk(n).KJnt.LwrFB = 50;
Thk(n).KJnt.Brkt = 50;
Thk(n).KJnt.ToeRing = 25;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 50;

Thk(n).WEP.Nominal = 13;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr17_0_6_LMB
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr17_0_6_LMB';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 25;
Thk(n).KJnt.LwrFB = 50;
Thk(n).KJnt.Brkt = 50;
Thk(n).KJnt.ToeRing = 25;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 50;

Thk(n).WEP.Nominal = 13;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr17_0_7_LMB
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr17_0_7_LMB';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 25;
Thk(n).KJnt.LwrFB = 50;
Thk(n).KJnt.Brkt = 50;
Thk(n).KJnt.ToeRing = 25;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 50;

Thk(n).WEP.Nominal = 13;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr17_0_8_LMB
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr17_0_8_LMB';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 25;
Thk(n).KJnt.LwrFB = 50;
Thk(n).KJnt.Brkt = 50;
Thk(n).KJnt.ToeRing = 25;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 50;

Thk(n).WEP.Nominal = 13;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr17_0_9_LMB
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr17_0_9_LMB';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 25;
Thk(n).KJnt.LwrFB = 50;
Thk(n).KJnt.Brkt = 50;
Thk(n).KJnt.ToeRing = 25;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 60;

Thk(n).WEP.Nominal = 13;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr17_0_10_Keel
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr17_0_10_Keel_2H';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 60;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 40;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 13;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr17_0_11_Keel
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr17_0_11_Keel';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 70;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 65;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 40;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 13;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')

%% Itr17_0_9FB65_LMB
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr17_0_9FB65_LMB';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 25;
Thk(n).KJnt.LwrFB = 50;
Thk(n).KJnt.Brkt = 50;
Thk(n).KJnt.ToeRing = 25;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 65;

Thk(n).WEP.Nominal = 13;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')

%% Itr16_1_1_Keel
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = '16_1_1_KEEL';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 13;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr16_20
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr16_20';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 30;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr17_1
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr17_1';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 30;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr16_21
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr16_21';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 30;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr16_7_LMB
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr16_7_LMB';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 25;
Thk(n).KJnt.LwrFB = 50;
Thk(n).KJnt.Brkt = 50;
Thk(n).KJnt.ToeRing = 25;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 30;
Thk(n).Nominal.FBsplice = 40;

Thk(n).WEP.Nominal = 13;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')

%% Itr16_7_1_LMB
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr16_7_1_LMB';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 25;
Thk(n).KJnt.LwrFB = 50;
Thk(n).KJnt.Brkt = 50;
Thk(n).KJnt.ToeRing = 25;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;
Thk(n).Nominal.FBsplice = 40;

Thk(n).WEP.Nominal = 13;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr16_0_6_KJnt
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr16_0_6_KJnt';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 25;
%Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 25;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBinst = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 13;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')

%% Itr16_7_2_LMB
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr16_7_2_LMB';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 25;
Thk(n).KJnt.LwrFB = 50;
Thk(n).KJnt.Brkt = 50;
Thk(n).KJnt.ToeRing = 25;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBSpRing4 = 40;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 30;
Thk(n).Nominal.FBsplice = 40;

Thk(n).WEP.Nominal = 13;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr_17_1_Keel
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr_17_1_Keel';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 30;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')

%% Itr_17_3_Keel
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr17_3_Keel';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtwLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtwLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 30;
Thk(n).WEP.Cen_Rad_Gir_Col2=25;
Thk(n).WEP.Cen_Rad_Gir_Col3=25;
ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr_17_5_WEP
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr17_5_WEP';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtwLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtwLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

Thk(n).Nominal.UMB = 23;
Thk(n).Nominal.VB1 = 23;
Thk(n).Nominal.VB2 = 19;
Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 30;
Thk(n).WEP.Cen_Rad_Gir_Col2=25;
Thk(n).WEP.Cen_Rad_Gir_Col3=25;
ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% ItrR16_7_3_v0_Offset
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'ItrR16_7_3_v0_Offset';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtwLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtwLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

% Thk(n).Nominal.UMB = 23;
% Thk(n).Nominal.VB1 = 23;
% Thk(n).Nominal.VB2 = 19;
% Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
% Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 30;
Thk(n).WEP.Cen_Rad_Gir_Col2=25;
Thk(n).WEP.Cen_Rad_Gir_Col3=25;

Thk(n).Nominal.LMB12 = 25;
Thk(n).Nominal.FB12ECC = 30;
Thk(n).Nominal.FB13ECC = 30;
Thk(n).Nominal.FB21ECC = 30;
Thk(n).WEP.DblToeBrktC12 = 28;
Thk(n).WEP.DblToeBrktC13 = 28;
Thk(n).Nominal.FB12CEN = 40;
Thk(n).Nominal.FB13CEN = 40;
Thk(n).Nominal.FB21CEN = 40;
Thk(n).WEP.GirderFlangeCol1 = 28;
Thk(n).WEP.GirderFlangeCol2 = 28;
Thk(n).WEP.GirderWebCol1 = 20;
Thk(n).WEP.GirderWebCol2 = 20;
Thk(n).WEP.GirderWebRing4Col1 = 25;
Thk(n).KJnt.KJointCanBrktC12 = 20;
Thk(n).KJnt.KJointCanBrktC13 = 20;
Thk(n).KJnt.KJointCanC12 = 50;
Thk(n).KJnt.KJointCanC13 = 50;
Thk(n).KJnt.KJtDblToeBrktC12 = 40;
Thk(n).KJtDblToeBrktC13 = 40;
Thk(n).Nominal.LMB13 = 25;
Thk(n).Nominal.Ring4C21 = 25;
Thk(n).Nominal.Ring45C12 = 25;
Thk(n).Nominal.Ring45C13 = 25;
Thk(n).WEP.StiffenerFlangeCol1 = 18;
Thk(n).WEP.StiffenerFlangeCol2 = 18;
Thk(n).WEP.StiffenerWebCol1 = 11.5;
Thk(n).WEP.StiffenerWebCol2 = 11.5;


ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr1_0_KJoint
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr1_0_KJoint';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtwLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtwLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

% Thk(n).Nominal.UMB = 23;
% Thk(n).Nominal.VB1 = 23;
% Thk(n).Nominal.VB2 = 19;
% Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
% Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 30;
Thk(n).WEP.Cen_Rad_Gir_Col2=25;
Thk(n).WEP.Cen_Rad_Gir_Col3=25;

Thk(n).Nominal.LMB12 = 25;
Thk(n).Nominal.FB12ECC = 30;
Thk(n).Nominal.FB13ECC = 30;
Thk(n).Nominal.FB21ECC = 30;
Thk(n).WEP.DblToeBrktC12 = 28;
Thk(n).WEP.DblToeBrktC13 = 28;
Thk(n).Nominal.FB12CEN = 40;
Thk(n).Nominal.FB13CEN = 40;
Thk(n).Nominal.FB21CEN = 40;
Thk(n).WEP.GirderFlangeCol1 = 28;
Thk(n).WEP.GirderFlangeCol2 = 28;
Thk(n).WEP.GirderWebCol1 = 20;
Thk(n).WEP.GirderWebCol2 = 20;
Thk(n).WEP.GirderWebRing4Col1 = 25;
Thk(n).KJnt.KJointCanBrktC12 = 20;
Thk(n).KJnt.KJointCanBrktC13 = 20;
Thk(n).KJnt.KJointCanC12 = 50;
Thk(n).KJnt.KJointCanC13 = 50;
Thk(n).KJnt.KJtDblToeBrktC12 = 40;
Thk(n).KJtDblToeBrktC13 = 40;
Thk(n).Nominal.LMB13 = 25;
Thk(n).Nominal.Ring4C21 = 25;
Thk(n).Nominal.Ring45C12 = 25;
Thk(n).Nominal.Ring45C13 = 25;
Thk(n).WEP.StiffenerFlangeCol1 = 18;
Thk(n).WEP.StiffenerFlangeCol2 = 18;
Thk(n).WEP.StiffenerWebCol1 = 11.5;
Thk(n).WEP.StiffenerWebCol2 = 11.5;


ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr1_0_KJoint
n = 1; %Thickness set number
% path0 ='E:\Data\ANSYS\WFA_Models\FrequencyDomainMarch2017\FreqDomain_Results\'; 
ItrNo = 'Itr1_1_KJoint';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 95;
Thk(n).Col1.IStopfrnt = 95; %
Thk(n).Col1.IStopbk = 60;
Thk(n).Col1.ISbtm = 60;

Thk(n).Col1.TFin       = 20;
Thk(n).Col1.TFout      = 20;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 22;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtwLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 26;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col1.RGbtm      = 12;
Thk(n).Col1.KFGdr      = 18;
Thk(n).Col1.KFGdrFl    = 28;
Thk(n).Col1.KFSfr      = 12;
Thk(n).Col1.KFSfrFl    = 18;
Thk(n).Col1.KFCirc     = 16;

Thk(n).Col2.IStopfrnt = 60;
Thk(n).Col2.IStopbk = 38;
Thk(n).Col2.ISbtm = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtwLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop  = 30;
Thk(n).Col2.VbarTop   = 30;
Thk(n).Col2.RingatLMB   = 30;

Thk(n).Col2.RGbtm      = 12;
Thk(n).Col2.KFGdr      = 12;
Thk(n).Col2.KFCirc     = 19;

Thk(n).KJnt.LMB12 = 50;
Thk(n).KJnt.LMB23 = 50;
Thk(n).KJnt.VB12 = 35;
Thk(n).KJnt.VB23 = 35;
Thk(n).KJnt.Ring = 25;
Thk(n).KJnt.Gusset = 25;
Thk(n).KJnt.UpperFB = 40;
Thk(n).KJnt.LwrFB = 40;
Thk(n).KJnt.Brkt = 40;
Thk(n).KJnt.ToeRing = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21        = 35;
Thk(n).Col2.VB21         = 32;
Thk(n).Col2.UMB23        = 29;
Thk(n).Col2.VB23         = 25;
Thk(n).Col2.LMB21        = 30;
Thk(n).Col2.LMB23        = 40;

% Thk(n).Nominal.UMB = 23;
% Thk(n).Nominal.VB1 = 23;
% Thk(n).Nominal.VB2 = 19;
% Thk(n).Nominal.LMB = 25;
Thk(n).Nominal.LMBSplice = 50;
Thk(n).Nominal.LMBring = 25;
% Thk(n).Nominal.FB = 40;

Thk(n).WEP.Nominal = 30;
Thk(n).WEP.Cen_Rad_Gir_Col2=25;
Thk(n).WEP.Cen_Rad_Gir_Col3=25;

Thk(n).Nominal.LMB12 = 25;
Thk(n).Nominal.FB12ECC = 30;
Thk(n).Nominal.FB13ECC = 30;
Thk(n).Nominal.FB21ECC = 30;
Thk(n).WEP.DblToeBrktC12 = 28;
Thk(n).WEP.DblToeBrktC13 = 28;
Thk(n).Nominal.FB12CEN = 40;
Thk(n).Nominal.FB13CEN = 40;
Thk(n).Nominal.FB21CEN = 40;
Thk(n).WEP.GirderFlangeCol1 = 28;
Thk(n).WEP.GirderFlangeCol2 = 28;
Thk(n).WEP.GirderWebCol1 = 20;
Thk(n).WEP.GirderWebCol2 = 20;
Thk(n).WEP.GirderWebRing4Col1 = 25;
Thk(n).KJnt.KJointCanBrktC12 = 20;
Thk(n).KJnt.KJointCanBrktC13 = 20;
Thk(n).KJnt.KJointCanC12 = 100;
Thk(n).KJnt.KJointCanC13 = 100;
Thk(n).KJnt.KJtDblToeBrktC12 = 40;
Thk(n).KJtDblToeBrktC13 = 40;
Thk(n).Nominal.LMB13 = 25;
Thk(n).Nominal.Ring4C21 = 25;
Thk(n).Nominal.Ring45C12 = 25;
Thk(n).Nominal.Ring45C13 = 25;
Thk(n).WEP.StiffenerFlangeCol1 = 18;
Thk(n).WEP.StiffenerFlangeCol2 = 18;
Thk(n).WEP.StiffenerWebCol1 = 11.5;
Thk(n).WEP.StiffenerWebCol2 = 11.5;


ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')