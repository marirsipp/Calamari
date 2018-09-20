function [Ptfm,Wind,Wave,Cur,General,Turbine,Results]=generateInputListfromOPT(OPTfile,varargin)
% optFile, General,Ptfm,Turbine
if exist(OPTfile,'file')
    fid=fopen(OPTfile,'r');
    if nargin==2
        General=varargin{1}; Turbine=[]; Ptfm=[];
    elseif nargin==3
        General=varargin{1};
        Ptfm=varargin{2}; Turbine=[];
    elseif nargin==4
        General=varargin{1};
        Ptfm=varargin{2}; 
        Turbine=varargin{3};
    else
        General=[]; Turbine=[]; Ptfm=[]; 
    end
    Wind=[]; Wave=[];Cur=[]; Results=[];
else
    error(['OPT file: ' OPTfile ' not found'])
end
while ~feof(fid)
    myLine=fgetl(fid);
    [value,label,isComment,descr,fieldType]=parseIPTline(myLine);
    if strcmp(label, 'yawfix') % because I kept changing the OPT file, can be removed later
        Results.yawfix=value;
    elseif strcmp(label, 'NacYaw_Mean') % because I kept changing the OPT file, can be removed later
        Results.NacYaw_Mean=value;
    end
    if ~isempty(label)
        eval([label '=' 'value' ';'])
    end
end
fclose(fid);
end
function [value,label,isComment,descr,fieldType]=parseIPTline(line)
%% Modified from ParseFASTInputLine
value = '';
label = '';
isComment = true;
descr = '';
fieldType = 'Comment';

firstChar = sscanf(strtrim(line),'%c',1);    
% first check that this isn't a blank line... or a comment
if isempty(firstChar)
    return
elseif ~isempty( strfind( '#!', firstChar ) )
    descr = value;
    value = strtrim(line);
    return
end

trueFalseValues = {'true','false'};
if isempty( strfind( '#!', firstChar ) )
    isComment = false;
    %%get the label : searching for dash followed by tab!!
    TABCHAR = sprintf('-\t');
    idash=strfind(line,TABCHAR);
    if isempty(idash)
        disp(['improperly formatted IPT/OPT file: no dash followed by a tab:' line])
        SPCHAR = sprintf('- ');
        isp=strfind(line,SPCHAR);
        if isempty(isp)
            warning(['improperly formatted IPT/OPT file: no dash followed by a space:' line])
            [~, ~, ~, nextindex] = sscanf(line,'%s', 1);
            testVal=strtrim(line(1:nextindex-1));
            line = line(nextindex:end);
        else
            testVal=strtrim(line(1:isp-1));
            line=line(isp+1:end);
            line=strtrim(line);
        end
    else
        testVal=strtrim(line(1:idash-1));
        line=line(idash+1:end);
        line=strtrim(line);
    end 
 % Get the Value, number or string
    %[testVal, cnt, ~, nextindex] = sscanf(line,'%s', 1);  %First check if line begins with a string
    valueNum=str2num(testVal);
    if ~isnan(valueNum)
        value=valueNum;
        fieldType = 'Numeric';
    else %we didn't find a numeric so...
        value = testVal;
        if any( strcmpi(testVal,trueFalseValues) )
            %this is a logical input
            fieldType = 'Logical'; 
        else
            fieldType = 'Character';  
        end
    end

    isemi=strfind(line,';');
    if isempty(isemi)
        warning(['improperly formatted IPT/OPT file: no semi-colon. skipping line: ' line])
        label='';
        descr=line;
    else
        isComment=false;
        label=line(1:isemi-1);
        descr=line(isemi+1:end);
    end 
end

end