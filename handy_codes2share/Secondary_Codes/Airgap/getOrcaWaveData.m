function [a,f,ph,K,deltw]=getOrcaWaveData(IPTfile) %get input values from "SurfaceElevationIPT"
Fullfile = which(IPTfile);
run(Fullfile);

% if nargin>6
%     WaveSeed=varargin{1};
%     WaveGamma=varargin{2};
%     if nargin>8
%         WaterDepth=varargin{3};
%     end
% end

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
f=[waveCs.Frequency]'; % [rad/s]
a=[waveCs.Amplitude]'; %[m]
ph=[waveCs.PhaseLagWrtSimulationTime]'; %[deg]
K=[waveCs.WaveNumber]'; % [m]
freqU = [waveCs.FrequencyUpperBound]'; % [rad/s]
freqL = [waveCs.FrequencyLowerBound]'; % [rad/s]
deltw=freqU - freqL; % [rad/s]
% WaveElv = Env.TimeHistory('Elevation')
%% Get surface elevation built by Orcaflex %%
% wavePreview=Model.Profile;
Model.SaveData('IncidentWave.dat');
Model.SaveSimulation('IncidentWave.sim')
end
