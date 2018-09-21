clear all

%Stores member thickness information for iterations
%% Itr2_01
n = 1; %Thickness set number
% path0 ='C:\Users\Nortada\Desktop\Document de Charlotte\WFA\MooringConnector\TimeDomain\'; 
% ItrNo = 'Itr2_01';

Thk(n).Name       = ItrNo;

Thk(n).Col23.OS        = 20;
Thk(n).Col23.MC        = 30;
Thk(n).Col23.MCrf      = 20;
Thk(n).Col23.Pin       = 200;
Thk(n).Col23.LMB_Can   = 30;

Thk(n).Col23.StN       = 35;
Thk(n).Col23.FlN       = 28;
Thk(n).Col23.Bracket   = 12;

Thk(n).Col23.Rg850     = 11;
Thk(n).Col23.Keel      = 23;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% Itr1_01
n = 1; %Thickness set number
% path0 ='C:\Users\Nortada\Desktop\Document de Charlotte\WFA\MooringConnector\TimeDomain\Ansys_output\'; 
% ItrNo = 'Itr1_01';

Thk(n).Name       = ItrNo;

Thk(n).Col1.OS        = 22;
Thk(n).Col1.MC        = 30;
Thk(n).Col1.MCrf      = 20;
Thk(n).Col1.Pin       = 200;
Thk(n).Col1.LMB_Can   = 30;

Thk(n).Col1.StN       = 35;
Thk(n).Col1.FlN       = 20;
Thk(n).Col1.Bracket   = 12;

Thk(n).Col1.Rg850     = 12;
Thk(n).Col1.Keel      = 28;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% ItrR5_13_10
n = 1; %Thickness set number
% path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
% ItrNo = 'ItrR5_13_10';

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

%% ItrR5_12_6dp8
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_12_6dp8';

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
Thk(n).Col2.Bkh   = 18;

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

%% ItrR5_15_2dp3
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_15_2dp3';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 105;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 50;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 21;
Thk(n).Col1.FB         = 25;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;
Thk(n).Col1.Brkt_TBatBkh = 18;
Thk(n).Col1.Brkt_TBatFB  = 15;


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

%% ItrR5_15_4
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_15_4';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 105;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 50;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 50;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 21;
Thk(n).Col1.FB         = 25;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
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
Thk(n).Col1.VB         = 40;
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
%% ItrR5_15_4dp5
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_15_4dp5';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 105;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 50;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 50;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 21;
Thk(n).Col1.FB         = 25;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 45;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
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
%% ItrR5_15_5
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_15_5';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 115;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 50;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 21;
Thk(n).Col1.FB         = 25;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;
Thk(n).Col1.Brkt_TBatBkh = 18;
Thk(n).Col1.Brkt_TBatFB  = 15;


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

%% ItrR5_15_5dp5
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_15_5dp5';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 110;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 50;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 21;
Thk(n).Col1.FB         = 25;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;
Thk(n).Col1.Brkt_TBatBkh = 18;
Thk(n).Col1.Brkt_TBatFB  = 15;


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

%% ItrR5_15_6
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_15_6';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 110;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 35;

Thk(n).Col1.OSatUMB    = 35;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 21;
Thk(n).Col1.FB         = 18;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;
Thk(n).Col1.Brkt_TBatBkh = 18;
Thk(n).Col1.Brkt_TBatFB  = 15;


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

%% ItrR5_15_5dp3
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_15_5dp3';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 115;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 50;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 21;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;
Thk(n).Col1.Brkt_TBatBkh = 18;
Thk(n).Col1.Brkt_TBatFB  = 15;


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

%% ItrR5_15_5dp3dp4
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_15_5dp3dp4';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 115;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 50;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 50;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 21;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;
Thk(n).Col1.Brkt_TBatBkh = 21;
Thk(n).Col1.Brkt_TBatFB  = 15;


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

%% ItrR5_15_12
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_15_12';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 115;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 50;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 50;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 21;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;
Thk(n).Col1.Brkt_TBatBkh = 20;
Thk(n).Col1.Brkt_TBatFB  = 20;


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

%% ItrR5_15_12dp6

n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_15_12dp6';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 115;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 50;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 50;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 21;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
Thk(n).Col1.VBaratBkh  = 55;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;
Thk(n).Col1.Brkt_TBatBkh = 25;
Thk(n).Col1.Brkt_TBatFB  = 20;


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

%% ItrR5_15_15dp5
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_15_15dp5';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 115;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 50;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 30;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;
Thk(n).Col1.Brkt_TBatBkh = 30;
Thk(n).Col1.Brkt_TBatFB  = 20;


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

%% ItrR5_15_16
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_15_16';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 115;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 50;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 21;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;
Thk(n).Col1.Brkt_TBatBkh = 20;
Thk(n).Col1.Brkt_TBatFB  = 20;


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
%% ItrR5_15_16dp4
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_15_16dp4';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 115;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 50;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 25;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;
Thk(n).Col1.Brkt_TBatBkh = 20;
Thk(n).Col1.Brkt_TBatFB  = 20;


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
%% ItrR5_15_16dp5
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_15_16dp5';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 115;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 50;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 25;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;
Thk(n).Col1.Brkt_TBatBkh = 22;
Thk(n).Col1.Brkt_TBatFB  = 20;


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
%% ItrR5_15_17
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_15_17';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 115;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 50;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 25;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;
Thk(n).Col1.Brkt_TBatBkh = 23;
Thk(n).Col1.Brkt_TBatFB  = 18;


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
%% ItrR5_15_18
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_15_18';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 115;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 50;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 25;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;
Thk(n).Col1.Brkt_TBatBkh = 23;
Thk(n).Col1.Brkt_TBatFB  = 18;


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

%% ItrR5_12_9 (Col3 Top)
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_12_9';

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
Thk(n).Col1.RingatLMB  = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col2.IStopfrnt  = 60;
Thk(n).Col2.IStopbk    = 38;
Thk(n).Col2.ISbtm      = 38;

Thk(n).Col2.OSatTruss21= 30;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop    = 30;
Thk(n).Col2.VbarTop    = 30;
Thk(n).Col2.RingatLMB  = 30;
Thk(n).Col2.Bkh        = 18;

Thk(n).KJnt.LMB12      = 50;
Thk(n).KJnt.LMB23      = 50;
Thk(n).KJnt.VB12       = 35;
Thk(n).KJnt.VB23       = 25;
Thk(n).KJnt.Ring       = 25;
Thk(n).KJnt.Gusset     = 25;
Thk(n).KJnt.UpperFB    = 25;
Thk(n).KJnt.LwrFB      = 40;
Thk(n).KJnt.Brkt       = 40;
Thk(n).KJnt.ToeRing    = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21      = 35;
Thk(n).Col2.VB21       = 32;
Thk(n).Col2.UMB23      = 29;
Thk(n).Col2.VB23       = 25;
Thk(n).Col2.LMB21      = 30;
Thk(n).Col2.LMB23      = 40;

Thk(n).Nominal.UMB     = 23;
Thk(n).Nominal.VB1     = 23;
Thk(n).Nominal.VB2     = 19;
Thk(n).Nominal.LMB     = 25;
Thk(n).Nominal.LMBring = 45;
Thk(n).Nominal.FB      = 40;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% ItrR5_12_11 (Col3 Top)
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_12_11';

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
Thk(n).Col1.RingatLMB  = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col2.IStopfrnt  = 70;
Thk(n).Col2.IStopbk    = 38;
Thk(n).Col2.ISbtm      = 38;

Thk(n).Col2.OSatTruss21= 35;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop    = 30;
Thk(n).Col2.VbarTop    = 30;
Thk(n).Col2.RingatLMB  = 30;
Thk(n).Col2.Bkh        = 18;

Thk(n).KJnt.LMB12      = 50;
Thk(n).KJnt.LMB23      = 50;
Thk(n).KJnt.VB12       = 35;
Thk(n).KJnt.VB23       = 25;
Thk(n).KJnt.Ring       = 25;
Thk(n).KJnt.Gusset     = 25;
Thk(n).KJnt.UpperFB    = 25;
Thk(n).KJnt.LwrFB      = 40;
Thk(n).KJnt.Brkt       = 40;
Thk(n).KJnt.ToeRing    = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21      = 35;
Thk(n).Col2.VB21       = 32;
Thk(n).Col2.UMB23      = 29;
Thk(n).Col2.VB23       = 25;
Thk(n).Col2.LMB21      = 30;
Thk(n).Col2.LMB23      = 40;

Thk(n).Nominal.UMB     = 23;
Thk(n).Nominal.VB1     = 23;
Thk(n).Nominal.VB2     = 19;
Thk(n).Nominal.LMB     = 25;
Thk(n).Nominal.LMBring = 45;
Thk(n).Nominal.FB      = 40;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% ItrR5_12_10 (Col2 Top)
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_12_10';

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
Thk(n).Col1.RingatLMB  = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;

Thk(n).Col2.IStopfrnt  = 70;
Thk(n).Col2.IStopbk    = 38;
Thk(n).Col2.ISbtm      = 38;

Thk(n).Col2.OSatTruss21= 35;
Thk(n).Col2.OSatTruss23= 20;
Thk(n).Col2.OSTopbk    = 18;
Thk(n).Col2.OSatLMB    = 40;
Thk(n).Col2.OSbtm      = 20;

Thk(n).Col2.RingTop    = 30;
Thk(n).Col2.VbarTop    = 30;
Thk(n).Col2.RingatLMB  = 30;
Thk(n).Col2.Bkh        = 18;

Thk(n).KJnt.LMB12      = 50;
Thk(n).KJnt.LMB23      = 50;
Thk(n).KJnt.VB12       = 35;
Thk(n).KJnt.VB23       = 25;
Thk(n).KJnt.Ring       = 25;
Thk(n).KJnt.Gusset     = 25;
Thk(n).KJnt.UpperFB    = 25;
Thk(n).KJnt.LwrFB      = 40;
Thk(n).KJnt.Brkt       = 40;
Thk(n).KJnt.ToeRing    = 45;

Thk(n).Col1.UMB        = 32;
Thk(n).Col1.VB         = 32;
Thk(n).Col1.LMB        = 30;
Thk(n).Col2.UMB21      = 35;
Thk(n).Col2.VB21       = 32;
Thk(n).Col2.UMB23      = 29;
Thk(n).Col2.VB23       = 25;
Thk(n).Col2.LMB21      = 30;
Thk(n).Col2.LMB23      = 40;

Thk(n).Nominal.UMB     = 23;
Thk(n).Nominal.VB1     = 23;
Thk(n).Nominal.VB2     = 19;
Thk(n).Nominal.LMB     = 25;
Thk(n).Nominal.LMBring = 45;
Thk(n).Nominal.FB      = 40;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')
%% ItrR5_15_19
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_15_19';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 115;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 50;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 25;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;
Thk(n).Col1.Brkt_TBatBkh = 23;
Thk(n).Col1.Brkt_TBatFB  = 18;


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

%% ItrR5_15_19dp6
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_15_19dp6';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 115;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 50;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 25;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;
Thk(n).Col1.Brkt_TBatBkh = 23;
Thk(n).Col1.Brkt_TBatFB  = 18;


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

%% ItrR5_15_20
n = 1; %Thickness set number
path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
ItrNo = 'ItrR5_15_20';

Thk(n).Name       = ItrNo;

Thk(n).Col1.TB         = 115;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 50;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 25;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;
Thk(n).Col1.Brkt_TBatBkh = 23;
Thk(n).Col1.Brkt_TBatFB  = 18;


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
%% Itr01_NewDesign for Col2,3
n = 1; %Thickness set number
path0 ='D:\Newfolder\MATLAB\TimeDomain\'; 
ItrNo = 'Itr01_NewDesign';

Thk(n).Col2.OS = 20;
Thk(n).Col2.IS = 38;
Thk(n).Col2.C3 = 35;
Thk(n).Col2.C3b = 20;
Thk(n).Col2.C3bFl =28; 
Thk(n).Col2.C3Fl = 35;
Thk(n).Col2.Rg850 = 11;
Thk(n).Col2.Rg850Fl =16; 
Thk(n).Col2.Keel = 23;
Thk(n).Col2.Rg1700 =11; 
Thk(n).Col2.C3Br = 12;


Thk(n).Name       = ItrNo;
Thk(n).Col1.TB         = 115;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 50;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 25;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;
Thk(n).Col1.Brkt_TBatBkh = 23;
Thk(n).Col1.Brkt_TBatFB  = 18;


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
%% Itr01_NewDesign for Col2,3
n = 1; %Thickness set number
path0 ='D:\Newfolder\MATLAB\TimeDomain\'; 
ItrNo = 'Itr03_NewDesign';

Thk(n).Col2.OS = 20;
Thk(n).Col2.IS = 38;
Thk(n).Col2.C3 = 35;
Thk(n).Col2.C3b = 20;
Thk(n).Col2.C3bFl =28; 
Thk(n).Col2.C3Fl = 35;
Thk(n).Col2.Rg850 = 11;
Thk(n).Col2.Rg850Fl =16; 
Thk(n).Col2.Keel = 23;
Thk(n).Col2.Rg1700 =11; 
Thk(n).Col2.C3Br = 12;


Thk(n).Name       = ItrNo;
Thk(n).Col1.TB         = 115;
Thk(n).Col1.IStopfrnt  = 95;
Thk(n).Col1.IStopbk    = 60;
Thk(n).Col1.ISbtm      = 60;

Thk(n).Col1.TFin       = 30;
Thk(n).Col1.TFout      = 20;
Thk(n).Col1.TFatUMB    = 50;

Thk(n).Col1.OSatUMB    = 50;
Thk(n).Col1.OSatVB     = 30;
Thk(n).Col1.OSTopbk    = 20;
Thk(n).Col1.OSatLMB    = 40;
Thk(n).Col1.OSbtm      = 22;

Thk(n).Col1.Bkh        = 25;
Thk(n).Col1.FB         = 20;
Thk(n).Col1.RingatUMB  = 30;
Thk(n).Col1.RingatVB   = 35;
Thk(n).Col1.RingatLMB   = 30;
Thk(n).Col1.TOCring     = 30;
Thk(n).Col1.VBaratBkh  = 45;
Thk(n).Col1.VBaratTruss= 30;
Thk(n).Col1.CFlat      = 25;
Thk(n).Col1.Brkt_TBatBkh = 23;
Thk(n).Col1.Brkt_TBatFB  = 18;


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