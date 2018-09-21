function met = readBinData4Structures(xlsxfile,BinNum,varargin)
if nargin>2
    iRun = varargin{1};
end
[xlsdir,xlsname,xlsx]=fileparts(xlsxfile);
matfile = [xlsdir filesep xlsname '_Bin' num2str(BinNum) '.mat'];
if ~exist(matfile,'file')
   iRun = 1; 
end
if iRun
    [foo,sheets] = xlsfinfo(xlsxfile); % MUST SAVE AS XLS FOR MAC (NOT XLSX)
    iSheet = cellfun(@(s) ~isempty(strfind(s,num2str(BinNum))),sheets);
    if isempty(iSheet)
        error(['Cannot find sheet with Bin Number ' num2str(BinNum) ' in xlsfile: ' xlsxfile]);
    end
    if sum(iSheet)>1
        error(['Multiple sheets with Bin Number ' num2str(BinNum) ' found in xlsfile: ' xlsxfile '. Remove duplicates'])
    end
    if ispc
        [num,txt,raw]=xlsread(xlsxfile,find(iSheet));
    else
        [num,txt,raw]=xlread(xlsxfile,find(iSheet));
    end
    [nraw,nData]=size(raw);
    % hard-coded
    ConventionStr = raw{1,1};
    iComma = strfind(ConventionStr,','); 
    met.DirConv = ConventionStr(1:iComma-1);
    CutOutStr = raw{2,1};
    CutOutCell = regexp(CutOutStr,'\d*','match');
    met.CutOut = str2num(CutOutCell{1});
    
    % 
    [iHead,colone] = find(cellfun(@(s) strcmp('BinName', s), raw)); % hard-coded name
    headers = raw(iHead,:);
    data = raw(iHead + 2:end,:); %skip Units line
    for pp = 1:nData
        if isnumeric(data{1,pp})
            pData = cell2mat(data(:,pp));
        else
            pData = data(:,pp);
        end
        headerName = strrep(headers{pp},' ','');
        met.(headerName) = pData;
    end
    save(matfile,'-struct','met');
else
    met = load(matfile);
end

end