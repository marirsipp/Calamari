 function SurfaceElevationData(IPTfile) % get input values from "SufaceElevationIPT"
 
close all
Fullfile = which(IPTfile);
run(Fullfile);

disp(['Calculating surface elevation for ' WaveType ' spectrum wave '])
%% Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Wp = 2*pi/Tp; %[1/s] pulsation
%[Amp,freq,ph,K,freqint] = getOrcaWaveData(IPTfile);
%[Amp,w,ph,lam,freqint,Model]=getWaveData(Hs,Tp,WaveType,WaveSeed,WaveGamma,WaterDepth);

Model=ofxModel();
Gen=Model('General');
Env=Model('Environment');
Env.SelectedWaveTrain = Env.WaveName(1);
if ~strcmp(WaveType,'Regular')
   Env.WaveType=WaveType;
   Env.UserSpecifiedRandomWaveSeeds='Yes';
   Env.WaveSeed = WaveSeed;
   if  strcmp(WaveType,'JONSWAP')
        Env.WaveGamma = WaveGamma;
   end
   Env.WaveNumberOfComponents=100; %these are default different for different versions of Orca
    if strcmp(WaveType,'JONSWAP') || strcmp(WaveType,'ISSC')
        Env.WaveSpectrumMinRelFrequency=.5;
        Env.WaveSpectrumMaxRelFrequency=10.0;
    end
    Env.WaveHs = Hs; %+ .00001; % add negligible current for rayleigh damping
    Env.WaveTp = max([Tp 1]); 
else
    Env.WaveType = 'Single Airy';
    Env.WaveHeight = Hs;
    Env.WavePeriod = max([Tp 1]);
end
Env.WaterDepth = WaterDepth; 
Env.WaveDirection = WaveDirection; %[deg], this doesn't matter if we just extract wave train information
Env.WavePreviewPositionX=X(1); %[m], X position of the preview
Env.WavePreviewPositionY=X(2); %[m], Y position of the preview
%% Run simulation %%
Gen.NumberOfStages=2;
Gen.StageDuration{2}=Runtime; % sets the simulation runtime 
Model.RunSimulation;
%% Get input data for Matlab wave elevation reconstruction %%
waveCs=Model.waveComponents;
freq=[waveCs.Frequency]'; % [rad/s]
Amp=[waveCs.Amplitude]'; %[m]
ph=[waveCs.PhaseLagWrtSimulationTime]'; %[deg]
K=[waveCs.WaveNumber]'; % [m]
freqU = [waveCs.FrequencyUpperBound]'; % [rad/s]
freqL = [waveCs.FrequencyLowerBound]'; % [rad/s]
deltafreq=freqU - freqL; % [rad/s]
% WaveElv = Env.TimeHistory('Elevation')
%% Get surface elevation built by Orcaflex %%
% wavePreview=Model.Profile;
Model.SaveData('IncidentWave.dat');
Model.SaveSimulation('IncidentWave.sim')


%%
k = Wp^2/g; %[1/m] wave number in infinite depth 

%% Get graph from Orcaflex %%
[Res]=extractSIMwaveElevation('IncidentWave',X(1),X(2));
t = [Res.time]';
OrcaElev = [Res.waveel]';

%% Airy Wave and energy density spectrum %%
Surfelev = Hs/2*cos(k*(cos(WaveDirection*pi/180)*X(1)+sin(WaveDirection*pi/180)*X(2))-2*pi/Tp*t); %calculate the wave surface elevation for a regular Airy wave in infinite depth

Spectre = [Amp.^2./(2.*deltafreq)];

figure
grid on
ax1 = subplot(2,1,1);
plot(ax1,freq,Spectre)
title(ax1,'Density Spectrum')
xlabel(ax1,'frequence [Hz]')
ylabel(ax1,'Spectral Density [m^2/Hz]')

ax2 = subplot(2,1,2);
plot(ax2,t,Surfelev);
title(ax2,'Wave Surface Elevation - Airy Wave')
xlabel(ax2,'time [s]')
ylabel(ax2,'Wave Surface Elevation [m]')

%% Others spectra %%

if strcmp(WaveType,'JONSWAP')
      
    SurfElevJ = @(t) sum(Amp.*cos(K.*(cos(WaveDirection*pi/180)*X(1)+sin(WaveDirection*pi/180)*X(2))+ph.*(pi/180)-2*pi.*freq.*t)); %Wave surface elevation
    SurfelevationJ = @(X) arrayfun(SurfElevJ,X);
    
    figure
    grid on
    bx1 = subplot(2,2,1);
    plot(bx1,t,OrcaElev,'b');
    title(bx1,'Jonswap - Orcaflex Wave Surface Elevation')
    xlabel(bx1,'time [s]')
    ylabel(bx1,'Wave Surface Elevation [m]')

    bx2 = subplot(2,2,2);
    plot(t,SurfelevationJ(t),'g');
    title(bx2,'Jonswap - Hand-built Wave Surface Elevation')
    xlabel(bx2,'time [s]')
    ylabel(bx2,'Wave Surface Elevation [m]')
    
    bx3 = subplot(2,2,[3,4]);
    plot(t,OrcaElev,'b',t,SurfelevationJ(t),'g');
    title('Jonsawp - Subplot Orcaflex and Hand-built results')
    xlabel(bx3,'time [s]')
    ylabel(bx3,'Wave Surface Elevation [m]')


elseif strcmp(WaveType,'ISSC')
    
     
    %Wm = (5*pi/4)^(1/4)*Wp;
    SurfElevPM = @(t) sum(Amp.*cos(K.*(cos(WaveDirection*pi/180)*X(1)+sin(WaveDirection*pi/180)*X(2))+ph.*(pi/180)-2*pi.*freq.*t)); %Total wave surface elevation
    SurfelevationPM = @(X) arrayfun(SurfElevPM,X);
    
    figure
    grid on
    bx1 = subplot(2,2,1);
    plot(bx1,t,OrcaElev,'b');
    title(bx1,'ISSC - Orcaflex Wave Surface Elevation')
    xlabel(bx1,'time [s]')
    ylabel(bx1,'Wave Surface Elevation [m]')

    bx2 = subplot(2,2,2);
    plot(t,SurfelevationPM(t),'g');
    title(bx2,'ISSC - Hand-built Wave Surface Elevation')
    xlabel(bx2,'time [s]')
    ylabel(bx2,'Wave Surface Elevation [m]')
    
    bx3 = subplot(2,2,[3,4]);
    plot(t,OrcaElev,'b',t,SurfelevationPM(t),'g');
    title('ISSC - Subplot Orcaflex and Hand-built results')
    xlabel(bx3,'time [s]')
    ylabel(bx3,'Wave Surface Elevation [m]')
    
else
     disp('Wrong wave type name')

     
end

delete('IncidentWave.dat')
delete('IncidentWave.sim')
 end
