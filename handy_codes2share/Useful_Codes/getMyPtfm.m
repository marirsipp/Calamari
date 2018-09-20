function Ptfm=getMyPtfm(PtfmName,varargin)
%look for columns that say 'MATLAB Name' and read in all columns that say
%'MATLAB Value'
irun=0; % -> default is to read Excel file
if nargin>1
    irun=varargin{1};
end
xlsfile=[PtfmName '_Ptfm.xlsx'];
fullpath=which(xlsfile);
if isempty(fullpath)
    fullpath=xlsfile;
    islashes=strfind(fullpath,filesep);
    PtfmName=PtfmName(islashes(end)+1:end);
end
[xlsdir,foo,bar]=fileparts(fullpath); 
% if ispc
%     xlsfile=[PtfmName '_Ptfm.xml'];
% else
%     xlsfile=[PtfmName '_Ptfm.xlsx'];
% end
varname='MATLAB Name';
varval='MATLAB Value';
unitname='Units'; % NOT Untis!!
if ~exist([PtfmName '_Ptfm.mat'],'file') || irun
    try
        Ptfm=readExcel(fullpath,inf,varname,varval,unitname);
    catch 
        disp('Excel file open by another processor. Waiting a few seconds.')
        pause(3)
        try
            Ptfm=readExcel(fullpath,inf,varname,varval,unitname);
        catch ME
            error(['Cannot read in ' fullpath  '.' ME.message])
        end
    end
    save([xlsdir filesep PtfmName '_Ptfm.mat'],'Ptfm')
else
    load([xlsdir filesep PtfmName '_Ptfm.mat'])
end
end