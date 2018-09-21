function[Meq, Sum_D_year]=CalDEL(M, Time, InputTimeStep, m, N0, LifeAsum, Mu, TranTime)
%Calculate fatigue damage equivalent loads (DELs) based on input time
%series of loads
% By Bingbin Yu, Principle Power Inc. 

%INPUTs:
%  M - input table of load time series, force unit kN, moment unit kNm,
%      size: total time steps * total degrees of freedom
%  Time - input time records, unit: second, size: total time steps * 1
%  InputTimeStep - input time step of the simulation if full time records 
%                  is not included, sec
%  m - order of M-N curve
%  N0 - Assumed total number of cycles happened in assumed design life
%  LifeAsum - Assumed design life, unit year; usually 25 years with N0 =
%             1e7
%  Mu - constant in the M-N curve, does not affect the final results
%  TranTime - total transient time to take out in the beginning of
%             simulation, sec
%OUTPUTs:
% Meq - DEL of the input loads, size: 1 * total degrees of freedom
% Sum_D_year - Annual damage from the input loads based on the assumed M-N
%              curve. Does not have physical meaning, only for calculating
%              total DEL of a full set of fatigue bins.

%Simulation time and time step
if isempty(Time)
    tstep = InputTimeStep;
    trun = size(M,1)*tstep; %sec    
else
    trun = max(Time(:,1)); %total simulation time, sec
    tstep = Time(2,1)-Time(1,1);
end

LdNo = size(M,2);

% INPUT DATA of M-N curve
% Mu = 3e6; %kNm, does not affect the final results
MNcurve.A = Mu^m;
MNcurve.m = m;

oneyear=24*365.25; %hours in a year
TStart = floor(TranTime/tstep); %no. of time step before the start of a section
dt = (trun-TranTime)/3600; % length of run - convert in hours
Mshort = M((1+TStart):end,:);
Sum_D_year = nan(LdNo,1);
for jj=1:LdNo
%     figure(j)
%     %clf
%     hold on
%     %plot(Mshort(:,j))
%      plot(Mshort(:,j),'r')
    Sum_DML = runRainflowExe(Mshort(:,jj), MNcurve,[]) ;
    Sum_D_year(jj,1)= Sum_DML*oneyear/dt;
end
Meq = (Sum_D_year * LifeAsum * Mu^m / N0) .^ (1/m);
end