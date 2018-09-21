function[Life_method_ABS] = SpectralFatigue_Mthd3(path_itr, path_str, Metocean_Filename, theta0, wave_theta, Part, AllSNcurve, MaxP, unit,scale, IsHotspot)
%Analysis Method 3:
%spectral analysis based on combined wave Hs/Tp/Wave Dir fatigue bins, 
%closed form fatigue damage calculation
%Life_method_DNV = fatigue life (years) calc using eq. DNV-RP-C203 and
%recorded environmental Hs/Tp/Wave Direction statistics 
%Life_method_ABS = fatigue life (years) calc using ABS Fatigue Assesment
%and recorded environmental Hs/Tp/Wave Direction statistics 

%% Input parameters
Year_Length = 60*60*24*365.25; %seconds

if strcmp(IsHotspot,'n')
    
    PartName = Part.Name;
    PartThk = Part.Thk;
    TorB = Part.Surf;
    SNcurve = AllSNcurve.(Part.SNname);
    
    %SN curve information
    SQ = SNcurve.S0;
    A = SNcurve.A;
    m = SNcurve.m;
    r = SNcurve.r;
    C = SNcurve.C;
    a = 0.926-0.033*m;
    b = 1.587*m - 2.323;
    Tref = SNcurve.t_ref; %reference thickness (mm)
    Texp = SNcurve.kcorr; % reference thickness exponent
    
elseif strcmp(IsHotspot,'y')
    
    PartName = Part.Name;
    PartThk = Part.Thk;
    TorB = Part.Surf;
    SNnames = Part.SNname;
    RowHsp = Part.ElemRow;
    NoHsp = length(RowHsp);
    for nn=1:NoHsp
        SNcurve = AllSNcurve.(SNnames{nn});
        SQ(nn,1) = SNcurve.S0;
        A(nn,1) = SNcurve.A;
        m(nn,1) = SNcurve.m;
        r(nn,1) = SNcurve.r;
        C(nn,1) = SNcurve.C;
        a(nn,1) = 0.926-0.033*m(nn);
        b(nn,1) = 1.587*m(nn) - 2.323;
        Tref(nn,1) = SNcurve.t_ref; 
        Texp(nn,1) = SNcurve.kcorr; 
    end    
end

periods = MaxP:-1:3; %sec
fr = 1./periods;  %1/sec

%% Fatigue bin information
metocean = importdata(Metocean_Filename);
Hs = metocean.data(:,4);
Tp = metocean.data(:,5);
Dir = metocean.data(:,6);
Prob = metocean.data(:,3)/10000;
NoBin = length(Hs); %Total number of bins

wave_theta_total = wave_theta.total;
Head2Cal = wave_theta.simulated;

%Convert wave direction from 'FROM' to 'TOWARDS'
Wave_theta_int = wave_theta_total(2)-wave_theta_total(1);
Dir_Twd = Dir+180;
aa = find(Dir_Twd>= max(wave_theta_total)+ Wave_theta_int/2);
Dir_Twd(aa)=Dir_Twd(aa)-360;

[bb xout] = hist(Dir_Twd,wave_theta_total);
mm=find(bb>0);
wave_theta = xout(mm); %Wave headings with non-zero probability

%Find the intersection of simulated wave headings and wave headings
%with non-zero probability
simulated_wave_theta = intersect(wave_theta, Head2Cal);

%Find bins whose wave heading is simulated
dir_index1 = round( (Dir_Twd-wave_theta_total(1))/Wave_theta_int ) + 1;
wave_theta_bin = wave_theta_total(dir_index1);
[tf1,loc1] = ismember(wave_theta_bin,simulated_wave_theta);
Bins = 1:NoBin;
Simulated_Bin = Bins(tf1);

%% Compute transfer function
%pre-calculate the transfer in one of a few pre-considered wave headings
TransferFile = [path_itr PartName '_' TorB '_Shs0.mat'];
if exist(TransferFile,'file')
    disp('Using exisitng Shs0 file for stress RAO. Check for validatity of the results')
    load(TransferFile);
    if size(Shs0,3) ~= length(simulated_wave_theta)
        disp('Warning: RAO results stored not covering all required wave headings')
        pause
    end
else
    for j = 1:length(simulated_wave_theta)
        %frequencies considered
        disp(['..... Reading stress RAO of ' PartName ' for wave heading ' num2str(simulated_wave_theta(j)) ' degree.'])
        for k = 1:length(fr)
            Shs0(:,k,j) = StrWvTransfer3(theta0,simulated_wave_theta(j),(1./fr(k)),path_str,PartName,TorB, unit,scale);  % Transfer Function, with thickness correction on stress.
        end        
    end
    save(TransferFile,'Shs0')
end
if strcmp(IsHotspot,'n')
    Shs = Shs0.*(PartThk/Tref)^Texp;
elseif strcmp(IsHotspot,'y')
    Shs0_hsp = Shs0(RowHsp,:,:);
    Shs = 0*Shs0_hsp;
    for nn=1:NoHsp
        Shs(nn,:,:) = Shs0_hsp(nn,:,:).*(PartThk(nn)/Tref(nn))^Texp(nn);
    end
end
clear Shs0 Shs0_hsp
NoElem = size(Shs, 1);  
mu = zeros(NoElem,1,'double');
seastate3 = zeros(NoElem,NoBin,'double');
if strcmp(IsHotspot,'y')
    Sp_str_test = zeros(NoElem, length(fr),NoBin);
end
%% Loop through Hs and Tp values

for i = Simulated_Bin

    disp(['........ Calculating fatigue damage of Bin No.' num2str(i)])

    Dir_index = loc1(i);
    %Calculate wave spectral density - from CalcspecHS.m
    %target spectrum
    siga=0.07;
    sigb=0.09;
    Gamma = 2.5;

    Cp = (5*Hs(i)^2)/(16*(1/Tp(i))*(1.15+0.168*Gamma-0.925/(1.909+Gamma)));

    for k=1:length(fr)
        fhat=fr(k)*Tp(i);
        if (fhat<1)
            alpha=exp(-1. * ((fhat-1.)^2) / (2*siga^2));
        else
            alpha=exp(-1. * ((fhat-1.)^2) / (2*sigb^2));
        end
        sp1(k) =Cp*Gamma^alpha*exp(-1.25/fhat^4)/fhat^5;
    end
    %fr frequency (Hz)
    %sp1 spectral density (m^2/Hz)

    %Convert to stress spectra, and determine 0th, 2nd, and 4th
    %spectral moment of stress response process
    area = zeros (NoElem, 1);
    area2 = zeros (NoElem, 1);
    area4 = zeros (NoElem, 1);
    Sp_str = zeros(NoElem, length(fr)); 
    for k = 1:(length(fr)-1)
        %multiply wave spectral density by transfer function to arrive
        %at stress spectrum (MPa^2/Hz).  Integrate over this
        %spectrum
        area  = Shs(:,k,Dir_index).^2*sp1(k)*(fr(k+1)-fr(k)) + area; %% UNITS MPa^2
        area2 = Shs(:,k,Dir_index).^2*sp1(k)*(fr(k+1)-fr(k))*fr(k)^2 + area2; % MPa^2.*Hz^2
        area4 = Shs(:,k,Dir_index).^2*sp1(k)*(fr(k+1)-fr(k))*fr(k)^4 + area4; % MPa^2.*Hz^2
        if strcmp(IsHotspot,'y') 
            Sp_str(:,k)= Shs(:,k,Dir_index).^2.*sp1(k); %Recording stress spectrum
        end
    end
    if strcmp(IsHotspot,'y')
        Sp_str_test(:,:,i) = Sp_str;
    end
    %0th, 2nd, and 4th spectral moment at i condition
    SpectralMoment0 = area; % MPa^2
    SpectralMoment2 = area2; % MPa^2.*Hz^2
    SpectralMoment4 = area4; % MPa^2.*Hz^4

%         %% DNV-RP-C203 Equation 13-6:
%         seastate(i) = Environ_Data_Timestep.*gamma(1+m0/2).*(1.4/Tp(i))*(2*(2*SpectralMoment0(i))^.5)^m0; %damage at particular sea state
%         
%         %% DNV-RP-C203 Equation 13-7:
%         seastate2(i) = Environ_Data_Timestep.*(1.4./Tp(i)).*(((2.*(2.*SpectralMoment0(i)).^.5).^m1./a1).*(gamma(1+m1/2)-gammainc((1+m1/2),(S0./(2*(2.*SpectralMoment0(i)).^0.5)).^2)) + (((2.*(2.*SpectralMoment0(i)).^0.5).^m2)/a2).*gammainc((1+m2/2),(S0/(2*(2.*SpectralMoment0(i)).^.5)).^2)); %damage at particular sea state
%         %complementary incomplete gamma function in eq 13-7: gammainc_comp(a,z) = gamma(a) - gammainc(a,z)
%         
    %% ABS Spectral-Based Fatigue Assesment Method - Section 6
    f0 = (SpectralMoment2./SpectralMoment0).^0.5; %ABS 6.5
    epsilon = (1-SpectralMoment2.^2./(SpectralMoment0.*SpectralMoment4)).^0.5; %ABS 6.6
    lambda = a + (1-a).*(1-epsilon).^b; % ABS 6.13
    nu = (SQ./(2.*(2)^0.5.*(SpectralMoment0).^0.5)).^2; %ABS 6.16
    mu = 1-(gammainc(m/2+1,nu)-((1./nu).^((r-m)/2).*gammainc(r/2+1,nu)))./gamma(m/2+1); %ABS 6.16
    seastate3(:,i) = Prob(i)*Year_Length./A.*(2.*(2)^0.5).^m.*gamma(m/2+1).*lambda.*mu.*f0.*((SpectralMoment0).^0.5).^m; % ABS 6.14
end
%     Damage_method_DNV_linear = 1/(365.25*sum(seastate)/(length(Hs)*Environ_Data_Timestep/(60*60*24))); % DNV linear S-N curve, Note: not correct with current inputs.  need linear s-n curve parameters for this to be correct
%     Damage_method_DNV = 1/(sum(seastate2)/(length(seastate2)*Environ_Data_Timestep/(60*60*24*365.25)))  % DNV bilinear S-N curve

Life_method_ABS = 1./(sum(seastate3,2)); % ABS bilinear curve

%% Output results
if strcmp(IsHotspot,'y')
    for p = 1:NoElem
        ElemRst{p}.CnntName = char(Part.CnntName(p,1));
        ElemRst{p}.Method = 3;
        ElemRst{p}.TotalLife = Life_method_ABS(p);
        ElemRst{p}.DmgPerBin = seastate3(p,:);
        ElemRst{p}.Heading = simulated_wave_theta;
        ElemRst{p}.Period = periods;
        ElemRst{p}.Metocean = metocean.data;
        ElemRst{p}.StrRAO = Shs(p,:,:);
        ElemRst{p}.StrSpc = Sp_str_test(p,:,:);
    end
    PartResultFile = [path_itr '\Results_Mthd3\' PartName '\ElemResult_' TorB '_Method6_Bin' num2str(NoBin) '.mat' ]; 
    save (PartResultFile, 'ElemRst')
end
end