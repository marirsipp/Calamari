function Turbine=getMyTurbine(TurbName,varargin)
%look for columns that say 'MATLAB Name' and read in all columns that say
%'MATLAB Value'
xlsfile=[TurbName '_Turb.xlsx'];
irun=0; % -> default is to read Excel file
if nargin>1
    irun=varargin{1};
end
fullpath=which(xlsfile);
if isempty(fullpath)
    fullpath=xlsfile;
    islashes=strfind(fullpath,filesep);
    TurbName=TurbName(islashes(end)+1:end);
end
[xlsdir,foo,bar]=fileparts(fullpath); 

varname='MATLAB Name';
varval='MATLAB Value';
unitname='Units'; % NOT Untis!!
if ~exist([TurbName '_Turb.mat'],'file') || irun
    try
        Turbine=readExcel(xlsfile,inf,varname,varval,unitname);
    catch 
        disp('Excel file open by another processor. Waiting a few seconds.')
        pause(3)
        try
            Turbine=readExcel(xlsfile,inf,varname,varval,unitname);
        catch ME
            error(['Cannot read in ' xlsfile  '.' ME.message])
        end
    end
    Turbine.ThrustTable=[Turbine.ThrustWS  Turbine.ThrustF];
    save([xlsdir filesep TurbName '_Turb.mat'],'Turbine')
else
    load([xlsdir filesep TurbName '_Turb.mat'])
end
if ~isfield(Turbine,'CutIn')
    error(['Must specify cut-in speed and cut-out speed in ' xlsfile 'for RunOF simulations to work properly'])
end
end