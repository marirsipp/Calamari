function[Damage_method_ABS] = SpectralFatigue_Cal_WFA_xHead_byMthd(path0, path_str, path_scatter, theta0, unit, scale, PartName, TorB, PartThk, Head2Cal, MaxP, Analysis_Procedure)
%% Spectral Fatigue Calculation

%Labed BYu where edited by Bingbin Yu, 11/05/2015
%Calculate frequency domain fatigue damage from stress outputs from ANSYS
%Edited by Peter Fobel, 5/27/2014
%contact peter.fobel@gmail.com for information about this file

%% Input
% theta0, defines platform orientation, 0 - column 1 in north, 90 - column
% 1 in east, 180 - column 1 in south, 270 - column 1 in west --BY, Nov 2015
% Analysis type (1-4)
% S-N curve parameters
% Filename of preadsheet containing tower properties
% Wave Scatter Diagram ...or... Hs/Tp/WaveDirection historical data

%% Output
%__Analysis Method 1:
%Damage_method_DNV_linear = fatigue life (years) calc using DNV-RP-C203,
%linear S-N curve and wave scatter diagram
%Damage_method_DNV = fatigue life (years) calc using DNV-RP-C203, bi-linear
%S-N curve and wave scatter diagram
%Damage_method_ABS = fatigue life (years) calc using ABS Fatigue Assesment
%of Offshore Structures 2003 and wave scatter diagram

%__Analysis Method 2:
%Damage = fatigue life (years) calc using Rainflow-Counting of simulated
%seastate time series determined from parameters listed in wave scatter diagram

%__Analysis Method 3:
%Damage_method_DNV = fatigue life (years) calc using eq. DNV-RP-C203 and
%recorded environmental Hs/Tp/Wave Direction statistics 
%Damage_method_ABS = fatigue life (years) calc using ABS Fatigue Assesment
%and recorded environmental Hs/Tp/Wave Direction statistics 

%__Analysis Method 4:
%Damage = fatigue life (years) calc using Rainflow-Counting and recorded
%environmental Hs/Tp/Wave Direction statistics (slow analysis method)

%% How to Run this Function
% Include Wave Scatter Spreadsheet or environmental Hs/Tp/Wave Direction record, 
% WindFloat RAO file, rainflow.exe, transfer.m (stress transfer function),
% and spreadsheet containing tower properties in the same directory as this 
% file.  Run the analysis from this file.

%% Input Parameters

%Input theta here (0 is along x axis). theta0, defines platform orientation 
%0 - column 1 in north, 90 - column 1 in east, 180 - column 1 in south, 
%270 - column 1 in west --BYu, Nov 2015
% theta0 = 340;  %--BYu, Nov 2015

%Analysis Procedure -
% 1 for spectral analyses using wave scatter diagram, 
% 2 for rainflow analysis using wave scatter diagram, 
% 3 rainflow analysis from recorded Hs/Tp/Wave Dir statistics,
% 4 spectral analysis from recorded Hs/Tp/Wave Dir statistics
% Analysis_Procedure = 1;

%Windfloat Design Name
% Design_Name = 'SquarishAlexia_tower'; %Name of windfloat design subject to analysis

%Path for Wave scatter diagram and stress results. --BY Nov2015
% path0 = 'C:\Users\Ansys\Documents\MATLAB\FreqDomain\';

%Iteration name --BY Dec2015
% Itr = 'Itr7_4';

%Name of member to be calculated fatigue damage. --BY Nov2015
% PartName = 'IS_C1';
% TorB = 'Top'; %Top or bottom surface of the member, 'Top' or 'Btm'
% PartThk = 85; %mm, member thickness

%Spreadsheet Filename Containing Wave Scatter Information 
%(Used for analysis methods 1 and 2 only.
Wave_Scatter_Spreadsheet_Filename = [path_scatter '\' 'WaveScatter_WFA.xlsx'];
%Wave scatter diagram orginization
% WFA:
Row_start = 8; %First row number in the wave scatter diagram 
Row_end = 34; 
Row_per_sec =30;
Wave_theta_int = 30;
Wave_theta_start = -20; %The first wave heading in the wave scatter diagram
% WFP:
% Row_start = 46;
% Row_end = 72;
% Row_per_sec =74;
% Wave_theta_int = 30;

%File containing wave Hs,Tp,Wave Direction data (Used for analysis
%methods 3, 4 and 5 only)
Environmental_Data_Filename = [path_scatter '\' 'WFA_ComboFatigueBins_N50.csv'];
Environ_Data_Timestep = 60*10; % Time step of environmental data (seconds)
Length_Timeseries = 900; % Length of generated time series in method 4, second
wave_theta_total = [-20 10 40 70 100 130 160 190 220 250 280 310]; %Total wave headings, toward

%Spreadsheet Containing Windfloat Design Properties
%Design_Properties_Spreadsheet = 'WindFloatProperties.xlsx';

%DNV linear S-N curve parameters (NOT CURRENTLY USED OR CORRECT)
m0 = 3;
a0 = 10^12.48;
%DNV bi-linear S-N curve parameters
m1 = 3;
a1 = 10^12.48;
m2 = 5;
a2 = 10^16.13;
%ABS bi-linear S-N curve parameters
%Actually, this is API RP-2A, SN curve for tubular welded joints in air,
%BYu, Nov 2015
SQ = 67;
A = 10^12.48;
m = 3;
r = 5;
C = 10^16.13;
a = 0.926-0.033*m;
b = 1.587*m - 2.323;
%Shared S-N curve parameters
Tref = 16; %reference thickness (mm)
Texp = 0.25; % reference thickness exponent
%Hot Spot SCF
S0 = 1; %taken as 1 for now

%Hs/Tp combinations considered (size of wave scatter diagram)
Hs = 0.5:1:12.5;
Tp = 0.5:1:24.5;
HsNum = 13;
TpNum = 25;

%% Calculate fatigue Damage - Initialize Constants

% [Tower_Properties_nums, Tower_Properties_text] = xlsread(Design_Properties_Spreadsheet,'Sheet1','B2:I10');
% [row,column] = find(strcmp(Tower_Properties_text,Design_Name));

%File containing RAO information
% RAO_Filename = char(Tower_Properties_text(9,column));

% Tower Properties
% Mt = Tower_Properties_nums(2,column)*1000; %Tower Mass (kg)
% Mn = Tower_Properties_nums(3,column)*1000; %Nacelle Mass (kg)
% Ht = Tower_Properties_nums(4,column); %Tower Height (m)
% Hb = Tower_Properties_nums(5,column); %Height of base of tower above waterline(m)
% Do = Tower_Properties_nums(6,column); %Tower Outside Diameter (m)
% Tt = Tower_Properties_nums(7,column); % (mm) Tower Thickness
Gr = 9.81; %m/s^2 gravitational acceleration

%Length of Year Defined
Year_Length = 60*60*24*365.25; %seconds

%keep track of what percent of total wave scatter combinations considered so far
%initialize as 0:
waveScatterPercentSum = 0;

%initialize frequency values used for step integrations of response spectra
% periods = [50,45,40,35:-1:3]; %sec
periods = MaxP:-1:3; %sec
fr = 1./periods;  %1/sec

%% Fatigue Calculation through Spectral Method -
%% DNV form (linear andS bi-linear) and ABS Form (bi-linear)
if Analysis_Procedure == 1
    
    %Loop through possible wave headings here (0 is along x axis)
    for wave_theta = Head2Cal
%     for wave_theta = [-20 10 40 70 100 130 160 190 220 250 280 310]
%     for wave_theta = [0 30 60 90 120 150 180 210 240 270 300 330]
%     for wave_theta = [0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345]
        
        disp(['..... Running ' PartName '_' TorB ' wave heading ' num2str(wave_theta) ' degree.'])
        wave_sec = (wave_theta - Wave_theta_start)/Wave_theta_int;
        
        %Given theta, load wave scatter diagram
%         WaveScatterRead = xlsread(Wave_Scatter_Spreadsheet_Filename,'Hs-Tp',sprintf('B%d:O%d',Row_start+(wave_theta/Wave_theta_int*Row_per_sec),Row_end+(wave_theta/Wave_theta_int*Row_per_sec)));
        WaveScatterRead = xlsread(Wave_Scatter_Spreadsheet_Filename,'Hs-Tp',sprintf('B%d:P%d',Row_start+(wave_sec*Row_per_sec),Row_end+(wave_sec*Row_per_sec)));
        WaveScatter = WaveScatterRead(1:25,1:13);
        waveScatterPercentSum = waveScatterPercentSum + .01.*WaveScatterRead(27,15);
        
        %% Compute transfer function
        %frequencies considered 
        for i = 1:length(fr)
            Shs(:,i) = StrWvTransfer3(theta0,wave_theta,(1./fr(i)),path_str,PartName,TorB, unit,scale)*(PartThk/Tref)^Texp;  % Transfer Function, with thickness correction on stress. --BYu Nov2015
        end
        NoElem = size(Shs, 1); %Total number of elements included in the results, --BYu Nov2015
        
        %% Loop through Hs and Tp values
        
        for i = 1:HsNum
            for j = 2:TpNum
                
                SeaNo = (i-1)*TpNum + j;
                disp(['..... Running ' PartName '_' TorB ' wave heading ' num2str(wave_theta) ' degree. No.' num2str(SeaNo) ' sea state.'])
                
                %Calculate wave spectral density - from CalcspecHS.m
                %target spectrum
                siga=0.07;
                sigb=0.09;
                Gamma = 1;
                
                Cp = (5*Hs(i)^2)/(16*(1/Tp(j))*(1.15+0.168*Gamma-0.925/(1.909+Gamma)));
%                 Cp = 0.0013 * Hs(i)^(4/3) * Gr^(2/3) * Tp(j)^(7/3);
                
                %Wave spectrum
                for k=1:length(fr)
                    fhat=fr(k)*Tp(j);
                    if (fhat<1)
                        alpha=exp(-1. * ((fhat-1.)^2) / (2*siga^2));
                    else
                        alpha=exp(-1. * ((fhat-1.)^2) / (2*sigb^2));
                    end
                    sp1(k) =Cp*Gamma^alpha*exp(-1.25/fhat^4)/fhat^5;
                end
                %fr frequency (Hz)
                %sp1 spectral density (m^2/Hz)
                
                %Stress energy spectrum
                for k = 1:length(fr)
                    Sp_str(:,k)= Shs(:,k).^2.*sp1(k);
                end
                
                %Convert to stress spectra, and determine 0th, 2nd, and 4th
                %spectral moment of stress response process 
                area = zeros (NoElem, 1);
                area2 = zeros (NoElem, 1);
                area4 = zeros (NoElem, 1);
                for k = 1:(length(fr)-1)
                    %multiply wave spectral density by transfer function to arrive
                    %at stress spectrum (MPa^2/Hz).  Integrate over this
                    %spectrum
                    area  = Shs(:,k).^2.*sp1(k).*(fr(k+1)-fr(k)) + area; %% UNITS MPa^2
                    area2 = Shs(:,k).^2.*sp1(k).*(fr(k+1)-fr(k)).*fr(k)^2 + area2; % MPa^2.*Hz^2
                    area4 = Shs(:,k).^2.*sp1(k).*(fr(k+1)-fr(k)).*fr(k)^4 + area4; % MPa^2.*Hz^2
                end
                %0th, 2nd, and 4th spectral moment at ij condition
                %SpectralMoment0(j,i) = area; % MPa^2, 
                %SpectralMoment2(j,i) = area2; % MPa^2.*Hz^2
                %SpectralMoment4(j,i) = area4; % MPa^2.*Hz^4

                SpectralMoment0 = area; % MPa^2, size(NoElem,1) --BYu Nov2015
                SpectralMoment2 = area2; % MPa^2.*Hz^2
                SpectralMoment4 = area4; % MPa^2.*Hz^4
                
                %% DNV-RP-C203 Equation 13-6:
                %seastate(j,i) = Year_Length./a0.*gamma(1+m0/2).*WaveScatter(j,i)*.01*(1.4/Tp(j))*(2*(2*SpectralMoment0(j,i))^.5)^m0; %damage at particular sea state
                
                %% DNV-RP-C203 Equation 13-7:
                %seastate2(j,i) = Year_Length.*(1.4./Tp(j)).*WaveScatter(j,i).*.01.*(((2.*(2.*SpectralMoment0(j,i)).^.5).^m1./a1).*(gamma(1+m1/2)-gammainc((1+m1/2),(S0./(2*(2.*SpectralMoment0(j,i)).^0.5)).^2)) + (((2.*(2.*SpectralMoment0(j,i)).^0.5).^m2)/a2).*gammainc((1+m2/2),(S0/(2*(2.*SpectralMoment0(j,i)).^.5)).^2)); %damage at particular sea state
                %complementary incomplete gamma function in eq 13-7: gammainc_comp(a,z) = gamma(a) - gammainc(a,z)
                
                %% ABS Spectral-Based Fatigue Assesment Method - Section 6
                %f0(j,i) = (SpectralMoment2(j,i)/SpectralMoment0(j,i))^0.5; %ABS 6.5
                %epsilon(j,i) = (1-SpectralMoment2(j,i).^2./(SpectralMoment0(j,i).*SpectralMoment4(j,i))).^0.5; %ABS 6.6
                %lambda(j,i) = a + (1-a).*(1-epsilon(j,i)).^b; % ABS 6.13
                %nu(j,i) = (SQ./(2.*(2)^0.5.*(SpectralMoment0(j,i)).^0.5)).^2; %ABS 6.16
                %mu(j,i) = 1-(gammainc(m/2+1,nu(j,i))-((1./nu(j,i)).^((r-m)/2).*gammainc(r/2+1,nu(j,i))))./gamma(m/2+1); %ABS 6.16
                %seastate3(j,i) = Year_Length./A.*(2.*(2)^0.5).^m.*gamma(m/2+1).*lambda(j,i).*mu(j,i).*f0(j,i).*WaveScatter(j,i).*0.01.*((SpectralMoment0(j,i)).^0.5).^m; % ABS 6.14
                
                %ABS Spectral-Based Fatigue Assesment Method - Section 6
                %Calculate fatigue damage for the current sea state, wave heading for each element --BYu Nov2015
                f0 = (SpectralMoment2./SpectralMoment0).^0.5; %ABS 6.5
                
                % f0 = 1/2/pi * (SpectralMoment2./SpectralMoment0).^0.5; -ABS 6.5 
                %%There shouldn't be a 1/2pi in this equation,
                %%since the wave spectrum is based on frequency(Hz). BYu, Jan2016
                
                epsilon = (1-SpectralMoment2.^2./(SpectralMoment0.*SpectralMoment4)).^0.5; %ABS 6.6
                lambda = a + (1-a).*(1-epsilon).^b; % ABS 6.13
                nu = (SQ./(2.*(2)^0.5.*(SpectralMoment0).^0.5)).^2; %ABS 6.16
                for n = 1:NoElem
                    mu(n,1) = 1-(gammainc(m/2+1,nu(n,1))-((1./nu(n,1)).^((r-m)/2).*gammainc(r/2+1,nu(n,1))))./gamma(m/2+1); %ABS 6.16
                    %Damage for seastate ij, element n
                    seastate3(n,j,i) = Year_Length./A.*(2.*(2)^0.5).^m.*gamma(m/2+1).*lambda(n,1).*mu(n,1).*f0(n,1).*WaveScatter(j,i).*0.01.*((SpectralMoment0(n,1)).^0.5).^m; % ABS 6.14
                end
            end
        end
        
        %D1(wave_theta/30+1) = sum(sum(seastate),2); %Note: not correct with current inputs.  need linear s-n curve parameters for this to be correct
        %D2(wave_theta/30+1) = sum(sum(seastate2),2);
        D3(:,wave_sec+1) = sum(sum(seastate3,3),2);
      
    end
    
    %Damage_method_DNV_linear = 1/(sum(D1)./waveScatterPercentSum); % DNV linear S-N curve
    %Damage_method_DNV = 1/(sum(D2)./waveScatterPercentSum)  % DNV bilinear S-N curve
    %Damage_method_ABS = 1./(sum(D3,2)./waveScatterPercentSum);  % ABS bilinear curve - This should be fatigue life
    Damage_method_ABS = 1./(sum(D3,2));  % ABS bilinear curve - This should be fatigue life
    
    
%%     
    %% Calculate Using Time Series Generated from Full JONSWAP
elseif Analysis_Procedure == 2
    
%     %Initialize damage
%     Damage = 0;
%     
%     %Loop through possible wave headings here (0 is along x axis)
%     for wave_theta = [0 30 60 90 120 150 180 210 240 270 300 330]
%         
%         %Given theta, load wave scatter diagram
%         WaveScatterRead = xlsread(Wave_Scatter_Spreadsheet_Filename,'Hs-Tp',sprintf('B%d:O%d',46+(wave_theta/30*74),72+(wave_theta/30*74)));
%         WaveScatter = WaveScatterRead(1:25,1:13);
%         waveScatterPercentSum = waveScatterPercentSum + .01.*WaveScatterRead(27,14);
%         
%         %% Compute transfer function
%         %frequencies considered
%         for i = 1:length(fr)
%             Shs(i) = transfer(theta,wave_theta,(1./fr(i)),RAO_Filename,Mt, Mn, Ht, Hb, Do, Do-Tt*.001, Gr)*(Tref/Tt)^Texp;  % Transfer Function
%         end
%         
%         %% Loop through Hs and Tp values
%         for i = 1:HsNum
%             for j = 1:TpNum
%                 %Calculate wave spectral density - from CalcspecHS.m
%                 %target spectrum
%                 siga=0.07;
%                 sigb=0.09;
%                 Gamma = 2.5;
%                 
%                 Cp = (5*Hs(i)^2)/(16*(1/Tp(j))*(1.15+0.168*Gamma-0.925/(1.909+Gamma)));
%                 
%                 for k=1:length(fr)
%                     fhat=fr(k)*Tp(j);
%                     if (fhat<1)
%                         alpha=exp(-1. * ((fhat-1.)^2) / (2*siga^2));
%                     else
%                         alpha=exp(-1. * ((fhat-1.)^2) / (2*sigb^2));
%                     end
%                     sp1(k) =Cp*Gamma^alpha*exp(-1.25/fhat^4)/fhat^5;
%                 end
%                 %fr frequency (Hz)
%                 %sp1 spectral density (m^2/Hz)
%                 
%                 %Determine spectra of stress amplitude
%                 for k=1:length(fr)
%                     if k==1
%                         f1=0;
%                         f2=(fr(1)+fr(2))/2;
%                     elseif k==length(fr)
%                         f1=(fr(k-1)+fr(k))/2;
%                         f2=2*fr(length(fr));
%                     else
%                         f1=(fr(k-1)+fr(k))/2;
%                         f2=(fr(k)+fr(k+1))/2;
%                     end
%                     stress_amplitude(k)=2*sqrt(Shs(k)^2*sp1(k)*(f2-f1));
%                     random_wave_phase(k)=rand*360;
%                 end
%                 
%                 %construct a time history response of stress over the specified time
%                 time = 0:0.2:900; % in seconds
%                 random_phase = repmat(random_wave_phase',1,length(time));
%                 phase = 2.*pi.*(fr'*time) + random_phase.*pi./180;
%                 amplitudes = repmat(stress_amplitude',1,length(time));
%                 response = sum(amplitudes.*sin(phase));
%                 %save ocean wave time series to rainflow.inp file
%                 response2(2:length(response)+1,1) = response';
%                 response2(1,1) = length(response);
%                 save('rainflow.inp','response2','-ASCII');
%                 
%                 % Run rainflow.exe
%                 ! rainflow.exe
%                 
%                 % Read output file rainflow.out
%                 [Type] = textread('rainflow.out','%s');
%                 L = (length(Type) - 56)/4;
%                 [Type,Equals, EQ, Amp] = textread('rainflow.out','%s %s %s %f',L);
%                 
%                 %% Sum Damage from moment amplitudes derived from rainflow algorithm
%                 %Define indices of full and half amplitudes in output Amp array
%                 Fullstr = cellstr('FULL');
%                 Fullarray(1:length(Type),1) = Fullstr;
%                 Halfstr = cellstr('HALF');
%                 Halfarray(1:length(Type),1) = Halfstr;
%                 II = strcmp(Type,Fullarray);
%                 III = strcmp(Type,Halfarray);
%                 Fulls = find(II);
%                 Halfs = find(III);
%                 
%                 %Find the indices of points in each branch of the S-N curve
%                 G = find(Amp >  SQ);
%                 L = find(Amp <= SQ);
%                 
%                 %Calculate N from S, using S-N curve parameters.
%                 Ng = 10.^(log10(a1) - m1.*log10(Amp.*(Tref/Tt).^Texp));
%                 Nl = 10.^(log10(a2) - m2.*log10(Amp.*(Tref/Tt).^Texp));
%                 
%                 %Assemble vector of N's.
%                 N(G,1) = Ng(G,1);
%                 N(L,1) = Nl(L,1);
%                 
%                 %Invert each index of N, to get damage at each stress peak
%                 D(Halfs,1) = 0.5./N(Halfs,1);
%                 D(Fulls,1) = 1./N(Fulls,1);
%                 
%                 % Define the aggregate damage of each seastate:
%                 %sum the damage at each of the
%                 % stress peaks, and add to previous damage
%                 Damage= sum(D)*.01*WaveScatter(j,i)*31557600/time(length(time)) + Damage;
%                 clear D Halfs Fulls N Ng Nl G L Halfs Fulls III II Halfarray Halfstr...
%                     Fullarray Fullstr Stress Type Equals EQ Amp response amplitude ...
%                     phase random_phase time stress_amplitude sp1 random_wave_phase
%             end
%         end
%         
%     end
%     
%     % Report Damage
%     Damage = 1/(Damage/waveScatterPercentSum)
%%     
    %% Calculate Using 10-Minute Hs/Tp/Wave Direction Environmental Data
    %% - ABS/DNV
elseif Analysis_Procedure == 3
    
%     clear seastate seastate2 seastate3
    %Given theta, load wave scatter diagram
    metocean = importdata(Environmental_Data_Filename);
    Hs = metocean.data(:,4);
    Tp = metocean.data(:,5);
    Dir = metocean.data(:,6);
    Prob = metocean.data(:,3)/10000;
    NoBin = length(Hs); %Total number of bins
    
    %Convert wave direction from 'FROM' to 'TOWARDS'
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
    
    % Compute transfer function
    %pre-calculate the transfer in one of a few pre-considered wave
    %headings
    for j = 1:length(simulated_wave_theta)
        %frequencies considered
        disp(['..... Reading stress RAO of ' PartName ' for wave heading ' num2str(simulated_wave_theta(j)) ' degree.'])
        for k = 1:length(fr)
            Shs(:,k,j) = StrWvTransfer3(theta0,simulated_wave_theta(j),(1./fr(k)),path_str,PartName,TorB, unit,scale)*(PartThk/Tref)^Texp;  % Transfer Function, with thickness correction on stress.
        end
    end
    Shs0 = Shs/(PartThk/Tref)^Texp;
    TransferFile = [path0 PartName '_' TorB '_Shs0.mat'];
    save(TransferFile,'Shs0')
    Shs0 = [];
    NoElem = size(Shs, 1);  
    
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
        for k = 1:(length(fr)-1)
            %multiply wave spectral density by transfer function to arrive
            %at stress spectrum (MPa^2/Hz).  Integrate over this
            %spectrum
            area  = Shs(:,k,Dir_index).^2*sp1(k)*(fr(k+1)-fr(k)) + area; %% UNITS MPa^2
            area2 = Shs(:,k,Dir_index).^2*sp1(k)*(fr(k+1)-fr(k))*fr(k)^2 + area2; % MPa^2.*Hz^2
            area4 = Shs(:,k,Dir_index).^2*sp1(k)*(fr(k+1)-fr(k))*fr(k)^4 + area4; % MPa^2.*Hz^2
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
        for n = 1:NoElem
            mu(n,i) = 1-(gammainc(m/2+1,nu(n,1))-((1./nu(n,1)).^((r-m)/2).*gammainc(r/2+1,nu(n,1))))./gamma(m/2+1); %ABS 6.16
            seastate3(n,i) = Prob(i)*Year_Length./A.*(2.*(2)^0.5).^m.*gamma(m/2+1).*lambda(n,1).*mu(n,1).*f0(n,1).*((SpectralMoment0(n,1)).^0.5).^m; % ABS 6.14
        end
    end
%     Damage_method_DNV_linear = 1/(365.25*sum(seastate)/(length(Hs)*Environ_Data_Timestep/(60*60*24))); % DNV linear S-N curve, Note: not correct with current inputs.  need linear s-n curve parameters for this to be correct
%     Damage_method_DNV = 1/(sum(seastate2)/(length(seastate2)*Environ_Data_Timestep/(60*60*24*365.25)))  % DNV bilinear S-N curve

    Damage_method_ABS = 1./(sum(seastate3,2)); % ABS bilinear curve
%%     
    %% Calculate Using 10-Minute Hs/Tp/Wave Direction Environmental Data
    %%  - Rainflow
elseif Analysis_Procedure == 4
    
%     %Initialize damage
%     Damage = 0;
%     
%     %Given theta, load wave data
%     [Hs,Tp, Dir] = textread(Environmental_Data_Filename,'%f %f %f','headerlines',1);
%     wave_theta = [0 30 60 90 120 150 180 210 240 270 300 330,0];
%     % Compute transfer function
%     %pre-calculate the transfer in one of a few pre-considered wave
%     %headings
%     for j = 1:13
%         j
%         %frequencies considered
%         for k = 1:length(fr)
%             Shs(k,j) = transfer(theta,wave_theta(j),(1./fr(k)),RAO_Filename,Mt, Mn, Ht, Hb, Do, Do-Tt*.001, Gr)*(Tref/Tt)^Texp;  % Transfer Function
%         end
%     end
%     
%     
%     for j = (length(Hs)-365*8*2):length(Hs)
%         if mod(j,500) == 0
%             j
%         end
%         
%         %Transform input file coordinates
%         Dir(j) = 360 - Dir(j);
%         Dir_index = round(Dir(j)/30) + 1;
%         
%         %round the current direction, to one of a few pre-determined
%         %wave headings already calculated using transfer function
%         
%         %Calculate wave spectral density - from CalcspecHS.m
%         %target spectrum
%         siga=0.07;
%         sigb=0.09;
%         Gamma = 2.5;
%         
%         Cp = (5*Hs(j)^2)/(16*(1/Tp(j))*(1.15+0.168*Gamma-0.925/(1.909+Gamma)));
%         
%         for k=1:length(fr)
%             fhat=fr(k)*Tp(j);
%             if (fhat<1)
%                 alpha=exp(-1. * ((fhat-1.)^2) / (2*siga^2));
%             else
%                 alpha=exp(-1. * ((fhat-1.)^2) / (2*sigb^2));
%             end
%             sp1(k) =Cp*Gamma^alpha*exp(-1.25/fhat^4)/fhat^5;
%             %fr frequency (Hz)
%             %sp1 spectral density (m^2/Hz)
%             
%             %Determine spectra of stress amplitude
%             if k==1
%                 f1=0;
%                 f2=(fr(1)+fr(2))/2;
%             elseif k==length(fr)
%                 f1=(fr(k-1)+fr(k))/2;
%                 f2=2*fr(length(fr));
%             else
%                 f1=(fr(k-1)+fr(k))/2;
%                 f2=(fr(k)+fr(k+1))/2;
%             end
%             stress_amplitude(k)=2*sqrt(Shs(k,Dir_index)^2*sp1(k)*(f2-f1));
%             random_wave_phase(k)=rand*360;
%         end
%         
%         %construct a time history response of stress over the specified time
%         time = 0:0.2:900; % in seconds
%         random_phase = repmat(random_wave_phase',1,length(time));
%         phase = 2.*pi.*(fr'*time) + random_phase.*pi./180;
%         amplitudes = repmat(stress_amplitude',1,length(time));
%         response = sum(amplitudes.*sin(phase));
%         %save ocean wave time series to rainflow.inp file
%         response2(2:length(response)+1,1) = response';
%         response2(1,1) = length(response);
%         save('rainflow.inp','response2','-ASCII');
%         
%         % Run rainflow.exe
%         ! rainflow.exe
%         
%         % Read output file rainflow.out
%         [Type] = textread('rainflow.out','%s');
%         L = (length(Type) - 56)/4;
%         [Type,Equals, EQ, Amp] = textread('rainflow.out','%s %s %s %f',L);
%         
%         %% Sum Damage from moment amplitudes derived from rainflow algorithm
%         %Define indices of full and half amplitudes in output Amp array
%         Fullstr = cellstr('FULL');
%         Fullarray(1:length(Type),1) = Fullstr;
%         Halfstr = cellstr('HALF');
%         Halfarray(1:length(Type),1) = Halfstr;
%         II = strcmp(Type,Fullarray);
%         III = strcmp(Type,Halfarray);
%         Fulls = find(II);
%         Halfs = find(III);
%         
%         %Find the indices of points in each branch of the S-N curve
%         G = find(Amp >  SQ);
%         L = find(Amp <= SQ);
%         
%         %Calculate N from S, using S-N curve parameters.
%         Ng = 10.^(log10(a1) - m1.*log10(Amp.*(Tref/Tt).^Texp));
%         Nl = 10.^(log10(a2) - m2.*log10(Amp.*(Tref/Tt).^Texp));
%         
%         %Assemble vector of N's.
%         N(G,1) = Ng(G,1);
%         N(L,1) = Nl(L,1);
%         
%         %Invert each index of N, to get damage at each stress peak
%         D(Halfs,1) = 0.5./N(Halfs,1);
%         D(Fulls,1) = 1./N(Fulls,1);
%         
%         % Define the aggregate damage of each seastate:
%         %sum the damage at each of the
%         % stress peaks, and add to previous damage
%         Damage= sum(D)*Environ_Data_Timestep/time(length(time)) + Damage;
%         clear D Halfs Fulls N Ng Nl G L Halfs Fulls III II Halfarray Halfstr...
%             Fullarray Fullstr Stress Type Equals EQ Amp response amplitude ...
%             phase random_phase time stress_amplitude sp1 random_wave_phase  Dir_index
%         
%     end
%     Damage = 1/(365.25*Damage/(length(Hs)*Environ_Data_Timestep/(60*60*24)))
%     
end
end