function [Res]=extractSIMwaveElevation(SIMname,positionX,positionY,varargin)
disp(['Extracting results from ' SIMname ['.sim']])

t_start=0;
resh_mod = ofxModel([SIMname '.sim']);
timedata = resh_mod.simulationTimeStatus;
timeend = floor(timedata.CurrentTime -1);

resh_obj = resh_mod.objects;

for jj=1:length(resh_obj)
    igenC=strfind(resh_obj{jj}.Name,'General');
    if ~isempty(igenC)
        igen=jj;
    end
    ienvC=strfind(resh_obj{jj}.Name,'Environment');
    if ~isempty(ienvC)
        ienv=jj;
    end
    
end

resh_gen = resh_obj{igen}; %General
resh_env = resh_obj{ienv}; %Environment

try
    Res.time = resh_gen.TimeHistory('Time',ofx.Period(t_start,timeend))';
    Units.time={'sec'};
catch
    error( [SIMname '.sim file cannot be opened: try opening it in OrcaFlex to see what is wrong.'])
end
% dt = Res.time(2) - Res.time(1); % FIXED time step!!

%% Wave elevation at Model origin (Column 1)
Res.waveel =resh_env.TimeHistory('Elevation', ofx.Period(t_start,timeend), ofx.oeEnvironment(positionX,positionY,0))';
Units.waveel={'m'};

% figure
% plot(Res.time,Res.waveel)
% grid on
% title('Wave Surface Elevation from Orcaflex')
% xlabel('time [s]')
% ylabel('Wave elevation [m]')

end