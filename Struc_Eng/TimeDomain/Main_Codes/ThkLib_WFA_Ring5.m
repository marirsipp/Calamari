

%% Itr16_7_2 (platform bottom)
% path0 ='D:\WFA\Analysis\Mz\5400_to_5000\Time_dom\'; 
n = 1; %Thickness set number
ItrNo = 'ItrR16_7_2_LMB_DblToeAdded_13Jul2018_impr';

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
Thk(n).KJnt.LMB12ins = 25; % In case of 50mm thick LMB up to 5000mm
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
Thk(n).Nominal.LMB = 25; % This will be used 25mm nominal portion
Thk(n).Nominal.LMBinst = 50;
Thk(n).Nominal.LMBSpRing4 = 40;
Thk(n).Nominal.LMBSpRing5 = 40; % Ring5 added
Thk(n).Nominal.LMBring = 25;
Thk(n).Nominal.FB = 30;
Thk(n).Nominal.FBsplice = 40;

Thk(n).WEP.Nominal = 13;
Thk(n).Col1WEP.EndPlt_DblToeBrkt_Outer = 40;
Thk(n).Col1WEP.EndPlt_Outer = 9;
Thk(n).Col1WEP.EndPlt_Inner = 9;
Thk(n).Col1WEP.EndPlt_DblToeBrkt_Inner = 40;
Thk(n).Col1WEP.LMBFB_KJt_Brkt = 20;
Thk(n).Col1WEP.Ring4Brkt = 40;
Thk(n).Col1WEP.WEPGirder = 25;
Thk(n).Col1WEP.WEPStiffener = 11.5;
Thk(n).Col1WEP.WEPStiffenerBrkt = 12;
Thk(n).Col1WEP.WEPGirderFlg = 40;
Thk(n).Col1.Ring4 = 40;
Thk(n).Col1.Ring5 = 40;

ThkFile = [path0 ItrNo '\' 'thickness.mat'];
save (ThkFile, 'Thk')