function [Frequency,Energy]=SpecDen(Sensor_Time,Sensor,varargin)
if nargin<3
    navg=1;
else
    navg=varargin{1};
end
% from the most trusted source on earth: https://www.mathworks.com/help/signal/ug/power-spectral-density-estimates-using-fft.html
if length(Sensor_Time)~=size(Sensor,1)
    error('SD time series inputs do not have the same length')
end
if mod(length(Sensor_Time),2)
    %if the time series has odd length, just cut out the last time step for
    %simplicity.
    Sensor_Time=Sensor_Time(1:end-1);
    Sensor=Sensor(1:end-1,:);
end
N=length(Sensor_Time);
%nterms=2;
%fs=(N-1)/(Sensor_Time(end)-Sensor_Time(1)); % number of samples/seconds
fs=1/mean(diff(Sensor_Time));
%data1f(1,:) = Sensor_Time;
%data1f(2,:)= Sensor-mean(Sensor);
      
%m = length(data1f);  % Window length
%n = pow2(nextpow2(m));  % Transform length
% Frequency = (0:n-1)*(fs/n)';     % Frequency range
%Frequency = (0:m-1)*(fs/m)';
Frequency = 0:fs/N:fs/2; % Frequency range
%x = fft(data1f(2,:));         % DFT
sdft = fft(Sensor);
sdft=sdft(1:N/2+1,:);
psds = (1/(fs*N)) * abs(sdft).^2;
psds(1,:)=psds(1,:); % scaling zero frequency by 1e-6 just so the power is easy to plot
psds(2:end-1,:) = 2*psds(2:end-1,:); % don't double the zero freq or the Nyquist freq
% y = fft(data1f(2,:),n);
% Energy = 2/fs*y.*conj(y)/n;
%Energy = 1/(pi*fs)*y.*conj(y)/m;

%endi = find(Frequency < 5 , 1, 'last'); % Cut off more than 5 Hz
%Frequency = Frequency(1:endi);
%Energy = Energy(1:endi);

%nf=fix(length(Energy)/nterms);
%S1=reshape(Energy(1:nterms*nf),nterms,nf);
%f1=reshape(Frequency(1:nterms*nf),nterms,nf);
%Energy=mean(S1);
Energy=moving(psds,navg);
%Frequency=mean(f1);

end
