function [a,w,ph,lam,deltaw,varargout]=getWaveData(Hs,Tp,WaveType,varargin)
% OUTPUTS = 
% wave sig wave height [m]
% wave period [s] 
% wave type= 'Regular' or 'JONSWAP' or 'ISSC' 
% Wave Seed (optional) = 0, 1, ... (set to 1 default)
% Wave Gamma (optional) = 1, 2.2 (set to 1 default)
% Water depth [m] (optional) = 100 (set to 100 default)
% OUTPUTS
% a = wave amplitude component [m]
% w = wave frequency component [rad/s]
% ph = wave phase [deg]
% lam = wavelength of component [m]

%TODO: finite depth dispersion relation
g=9.8; %[m/s^2], everything here in SI
WaterDepth=100;
WaveSeed=0;
WaveGamma=1;
WaveDirection=0;
iOrca=NaN;
if nargin>3
    WaveSeed=varargin{1};
    WaveGamma=varargin{2};
    if nargin>5
        WaterDepth=varargin{3};
    end
    if nargin>6
        iOrca=varargin{4};
    end
end
if iOrca~=0
    try
      Model=ofxModel();
      iOrca=1;
    catch
      iOrca=0;
    end
end
if ~iOrca
      nW=100; % number of desired frequencies
      Etol=1e-7; %allowed differences between energy strips
    wrelmin=0.5; wrelmax=10; %[-] defined like OrcaFlex
end
if iOrca
  Env=Model('Environment');
  Env.SelectedWaveTrain = Env.WaveName(1);
  if ~strcmp(WaveType,'Regular')
     Env.WaveType=WaveType;
     Env.UserSpecifiedRandomWaveSeeds='Yes';
     Env.WaveSeed = WaveSeed;
     Env.WaveGamma = WaveGamma;
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
  Model.RunSimulation;
  waveCs=Model.waveComponents;
  f=[waveCs.Frequency]'; % [Hz]
  w=2*pi*f;
  a=[waveCs.Amplitude]'; %[m]
  S=a(2:end).^2/2./diff(w);
  ph=[waveCs.PhaseLagWrtSimulationTime]'; %[deg]
  lam=2*pi./[waveCs.WaveNumber]'; % [m]
  freqU = [waveCs.FrequencyUpperBound]'; % [rad/s]
  freqL = [waveCs.FrequencyLowerBound]'; % [rad/s]
  deltaw=freqU - freqL; % [rad/s] TODO: is this not just max(w)-min(w)?
  varargout{1}=Model;
  varargout{2}=S;
  %Model.SaveData('tmp.dat');
else
  Wave1.Hs=Hs; Wave1.Tp=Tp; Wave1.Gam=WaveGamma;
  wbar= getEvenSpecEnergy(wrelmin,wrelmax,nW,Wave1,WaveType,Etol);
  Sbar = waveLibrary(wbar,Wave1,WaveType) ;
  Energy = mean([Sbar(1:end-1) Sbar(2:end)],2).*diff(wbar); 
  w = mean([wbar(1:end-1) wbar(2:end)],2); % get midpoint of w bars
  dw=diff(wbar); %get width of w bars
  k = w.^2./g; %[1/m], infinite depth water assumption % TODO: use dispersion relation for finite depth
  S = waveLibrary(w,Wave1,WaveType) ;
  figure(1)
  plot(wbar,Sbar,'b-o',w,S,'k-x')
  deltaw=max(w)-min(w);
  a=sqrt(2.*S.*dw);
  rng(WaveSeed); %initialize random number generator
  ph= -360 + 720.*rand(1); 
  lam=2*pi./k;
  varargout{1}=1;
  varargout{2}=S;
end

end


%           S = waveLibrary(w,Hs,Tp,WaveType) ; % N+2 function evaluations
%           plot(2*pi./w,S,'k-x');
%           pause
%           Sbar = mean([S(1:end-1) S(2:end)],2); % N+1 mid points
%           Energy = Sbar.*diff(w); % there are N areas
%           f = diff(Energy); % there are N areas 
%           df = diff(Sbar);
%           wold=w;
%           dw=[0; f./df; 0]
%           w= wold - dw;
%           err= abs(w-wold);
%     f = inline(f);
%     df = inline(df);
%     x(1) = x0 - (f(x0)/df(x0));
%     ex(1) = abs(x(1)-x0);
%     k = 2;
%     while (ex(k-1) >= tol) && (k <= nmax)
%         x(k) = x(k-1) - (f(x(k-1))/df(x(k-1)));
%         ex(k) = abs(x(k)-x(k-1));
%         k = k+1;
%     end

