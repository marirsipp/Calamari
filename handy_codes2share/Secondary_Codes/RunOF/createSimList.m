function simlist = createSimList(xlsfile,varargin)
if nargin<2
    nSheets=inf;
else
    nSheets=varargin{1};
end
[RunInfo,RunList]= readRunList(xlsfile,nSheets);
notnan=cellfun(@(V) any(~isnan(V(:))), {RunList.Runname});
RunList=RunList(notnan);
if isfield(RunList,'Runname')
    % need to expand RunList like in RunOF_BATCH

    % seek a file called RunOFipt.m to get datfile_default
    if ~isempty(RunInfo)
        varnames=fieldnames(RunInfo);
        for jj=1:length(varnames)
             eval([varnames{jj} '=' 'RunInfo.(varnames{jj})' ';'])
        end
    else
         iptname=getIPTname('RunOF');
        run(iptname);
    end
    if exist('Datfile','var')
        if ~isnan(Datfile)
            datfile_default=Datfile;
        end
    end
    filetypes={[TurbineName '.sim'],[TurbineName '.outb'],'outputs.mat','stats.mat'};
    typenum = bttnChoiseDialog(filetypes,'What files would you like to plot?',3,'Plot Type');
    typestr=filetypes{typenum};
    nRuns=length(RunList);
    simlist=cell(nRuns,1);
    for jj=1:nRuns
        datset=0;
        runstr=RunList(jj).Runname;
        %get datfile
        if isfield(RunList,'Datfile')
            Datfile=RunList(jj).Datfile;
            if ~isnan(Datfile)
                datset=1;
            end
            if exist('datfile_default','var') && ~datset
                datset=1;
                Datfile=datfile_default;
            end  
            if ~datset
                error('Datfile is unspecified. Please specify datfile in DLC spreadsheet or RunOFipt.m file')
            end
        end
        [datfilepath, datfilename] = fileparts(Datfile); %datfilepath does not include filesep
        slashes=strfind(datfilepath,filesep);
        MainFolder = datfilepath(1:slashes(end));
        simlist{jj,1}=[MainFolder RunFolder filesep RunPrefix runstr filesep typestr];
        
    end
else
    error('Runname column cannot be found')
end

end