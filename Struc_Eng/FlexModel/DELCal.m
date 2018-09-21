function[DEL] = DELCal(M,t,m)
%Calculate DEL with a single time series
%Assume 10e7 cycles in 25 years

%INPUT
%M - Single column/row time series of force or moment
%t - time, same size as M, has a unit of second
%m - slope of M-N curve

%Constants
Mu = 3e6; %kNm, does not affect the final results
oneyear=24*365.25; %hours in a year

tstep = t(2) - t(1); %Assume constant time step
dt = max(t)/3600; % length of run - convert in hours

fidrf=fopen('rainflow.inp','w');
fprintf(fidrf,'%i\n',max(size(M)));
fprintf(fidrf,'%f\n',M);
fclose(fidrf);

%Use rainflow counting algorithm 
!rainflow.exe 

% READ OUTPUT
ML=[]; %Moment range
NML=[]; %Number to failure
DML=[]; %Fatigue damage

% open output from RainFlow counting
filename=['rainflow.out'];
a1=[ filename ];
fiddat=fopen(a1);

% read number of lines with Force/Moment range
count = 0;
while ~feof(fiddat)
    line = fgetl(fiddat);
    if isempty(line) || ((~ strncmp(line,' HALF',5)) && (~ strncmp(line,' FULL',5)))
        continue
    end
    count = count + 1;
    HorF = line(2:5);
    if strcmp(HorF,'HALF')
        HorF_No(count) = 0.5;
    elseif strcmp(HorF,'FULL')
        HorF_No(count) = 1;
    end
end
% disp(sprintf('%d lines',count));
% move cursor to beginning of file
status=fseek(fiddat,0,'bof');

% read stress range
[ML,countl]=fscanf(fiddat,'%*s %*s %*s %f ',[1 count]);
inull=find(ML(1,:)==0);
ML(:,inull)=[];
HorF_No(:,inull)=[];
fclose(fiddat);

% number of cycles to failure
NML= (Mu./ML).^m;

% damage
DML=1./NML;
DML2=HorF_No.*DML;
Sum_DML=sum(DML2);
% Sum_DML=sum(DML);
Sum_D_year = Sum_DML*oneyear/dt;

DEL = (Sum_D_year * 25 * Mu^m / 10^7) .^ (1/m);

end