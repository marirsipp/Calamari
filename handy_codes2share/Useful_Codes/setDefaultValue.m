function output=setDefaultValue(varname,default_val,varargin)
%this is a very dangerous sub-function. DO NOT call more than once with the
%same variable name
if nargin>2
    xtrastr= varargin{1};
else
    xtrastr='';
end
basevars=evalin('caller','who'); %or 'base'
doesitexist = ismember(varname,basevars);
if doesitexist
    wrkspc_val=evalin('caller',varname); %or 'base'
    isvaracell=iscell(wrkspc_val);
    if isvaracell
        if sum(cellfun(@(c) ischar(c),wrkspc_val))>0
            wrkspc_nan=zeros(1,length(wrkspc_val)); %if one of the cell entries is a string, then set all entries to non-nan
        else
            try
                wrkspc_nan=cellfun(@(c) isnan(c),wrkspc_val);
            catch
                wrkspc_val= wrkspc_val{1};
                wrkspc_nan=0;
            end
        end
    else
        wrkspc_nan=isnan(wrkspc_val);
    end
    if length(wrkspc_nan)>1
        isitanan=wrkspc_nan(1);
    else
        isitanan=wrkspc_nan;
    end
    if isitanan
        output=default_val;
        if ~iscell(default_val)
            disp([varname ' variable not set. Setting to ' num2str(default_val) '.' xtrastr])
        else
            disp([varname ' variable not set. Setting to ' num2str([default_val{:}]) '.' xtrastr])
        end
    else
        if isempty(wrkspc_val)
            if ~iscell(default_val)
                disp([' Setting '  varname ' to ' num2str(default_val) '.' xtrastr])
            else
               disp([' Setting ' varname ' to ' num2str([default_val{:}]) '.' xtrastr])
            end
            output=default_val;
        else
            output=wrkspc_val;
        end
    end
else
    output=default_val;
    isoutputacell=iscell(output);
    if ~isoutputacell
        disp([' Setting '  varname ' to ' num2str(default_val) '.' xtrastr])
    else
        disp([' Setting ' varname ' to ' num2str([default_val{:}]) '.' xtrastr])
    end
end
end