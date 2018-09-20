function [RunInfo,RunList]= readRunList(xlsfile,uSheets)
[~,sheets] = xlsfinfo(xlsfile); % MUST SAVE AS XLS FOR MAC (NOT XLSX)
varname='MATLAB Name';
varname2='MATLAB Variable';
exname='Example';
unitname='Units';
runname='Runname';
introname='Introduction'; 
%% check if you have introduction tab
if ~strncmpi(sheets{1},introname,length(introname))
    RunInfo=[];
    warning(['Introduction sheet is not the first sheet in the Excel file: ' xlsfile '. See excel file on GitHub for example of Introduction sheet.'])
end
if isinf(uSheets)
    nSheets=numel(sheets);
    iSheets=1:nSheets;
else
    iSheets=[1 uSheets]; % append INTRODUCTION tab
    nSheets=length(iSheets);
end

% loop through all of the sheets or use the user-specified sheet
nvars=0;
irun=nan(length(iSheets),1);
for ii=iSheets
    irun(ii)=1;
    if ispc
        [num,txt,raw]=xlsread(xlsfile,ii);
    else
        [num,txt,raw]=xlread(xlsfile,ii);
    end
    [inr,inc] = find(cellfun(@(s) strcmp(varname, s), raw));
    if length(inc)>1
        irun(ii)=2;
        warning(['Multiple "MATLAB Name" defined on ' xlsfile '-' sheets{ii} '. Skipping import of that sheet.'])
    elseif isempty(inc)
        [inr,inc] = find(cellfun(@(s) strcmp(varname2, s), raw));
        if isempty(inc)
            warning('Cannot find MATLAB header in sheet')
             irun(ii)=0;
        end
    end
    if irun(ii)==1 %then you have a sheet that should be read
        if ii>1           
            [nraw,ncol]=size(raw);

            %how to find which row to start?
            % First blank entry after the "MATLAB Name"
            irow=inr+1;
            while ~isnan(raw{irow,inc})
                irow=irow+1;
            end
            %how to find which row to end?
            [foo,icol] = find(cellfun(@(s) strcmp(runname, s), raw));%should look for the column labeled 'Runname'
            %icol=inc+4; 
            %frow=irow;
            crow=irow;
            % if you find two blank rows in a row or you get to the end of the
            % table
            endtable=false; 
            brow_last=0;
            while ~endtable
                while ~isnan(raw{crow,icol})
                    crow=crow+1;
                    if crow>nraw
                        endtable=true;
                        break
                    end
                end
                %you're at a blank row
                brow=crow;
                if brow-brow_last==1
                    crow=crow-1;
                    endtable=true;
                else
                    %check the next line
                    if ~endtable
                        crow=crow+1;
                    end
                end
                brow_last=brow;
            end
            frow=crow-1; %row index of last filled in entry
            if frow>nraw
                frow=nraw;
                warning(['Something is weird about the xls file, setting end of table to row ' num2str(frow)])
            end
            nrows=frow-irow;
            % how to find the type of data to use?
            [irex,~] = find(cellfun(@(s) strcmp(exname, s), raw));
            if isempty(irex)
                warning(['Cannot find an "Example" row in the ' xlsfile '. Using the first row of values to obtain data type'])
                rowcheck=irow;
            else
                rowcheck=irex;
            end

            % loop through the columns of the spreadsheet
            for jj=inc+1:ncol
                fname=raw{inr,jj};
                if ~isnan(fname) 
                    %% Get the variable name
                    if ischar(fname) % make sure its characters
                        %remove weird characters
                        icom=strfind(fname,',');
                        fname=fname(~ismember(1:length(fname),icom));
                        idot=strfind(fname,'.');
                        fname=fname(~ismember(1:length(fname),idot)); 
                        isp=strfind(fname,' ');
                        fname=fname(~ismember(1:length(fname),isp)); 
                    end
                    %% Get the variable value
                    % Check what kind of variable is in the first entry of each row 

                    if isnumeric([raw{rowcheck,jj}]) % just check to see if it is a scalar
                        isastr=0;
                        isnum=1;
                        
                        valraw=[raw{irow:frow,jj}]';
                        rs=irow:frow;
                        for rr=1:length(rs)
                            if isempty(raw{rs(rr),jj})
                                valraw(rr,1)=nan;
                            end
                        end
                        vnum=1;
                    else

                        checkstr=raw{rowcheck,jj}; % use the 'Example' to see what kind of variable it is
                        valraw={raw{irow:frow,jj}}';
                        
                        icom=strfind(checkstr,',');
                        icol=strfind(checkstr,':');
                        if isempty(icol)
                            vnum=length(icom)+1; % number of elements in vector
                        else
                            vnum=nan; %if there is a colon in the example, then you don't know how many elements it will be
                        end
                        %strip the string markings (') 
                        if ~isempty(strcmp(checkstr,''''))
                            isastr=1;
                           for kk=1:nrows+1
                               if ~isnan(valraw{kk})
                                   istr=strfind(valraw{kk},'''');
                                   oldstr=valraw{kk};
                                   newstr=oldstr( ~ismember(1:length(valraw{kk,:}),istr) ); % only use the characters
                                   valraw{kk,:}=newstr;
                               end
                           end
                        end
                        % if there are square brackets (or parentheses) convert it to a numerical
                        % vector

                        if strcmp(checkstr(1),'[') && strcmp(checkstr(end),']') 
                            if ~isnan(vnum)
                                isastr=0;
                                valraw=nan(nrows,vnum);
                                for kk=0:nrows
                                    rstr=raw{irow+kk,jj};
                                    if ~isempty(rstr)
                                        if isnan(rstr)
                                            valraw(kk+1,:)= nan(1,vnum);       
                                        elseif isempty(str2num(rstr))
                                            error('Do not include strings in vectors surrounded by square brackets')
                                        else
                                            valraw(kk+1,:)=str2num(rstr);
                                        end
                                    else
                                        valraw(kk+1,:)=nan;
                                    end
                                end
                            else
                                isastr=1; % it really isn't a string, but its a good hack
                                % You are in a row with some scalars and some
                                % vectors                            
                                for kk=0:nrows
                                    rstr=raw{irow+kk,jj};
                                    if ~isnumeric(rstr)
                                        valraw{kk+1,:}=str2num(rstr);
                                    else
                                        valraw{kk+1,:}=rstr;
                                    end
                                end
                            end
                        elseif  strcmp(checkstr(1),'(') && strcmp(checkstr(end),')')
                            %what do parentheses mean?
                            error('What do parentheses mean? Use square [] brackets for a numerical vector or curly {} brackets for an array of strings (or strings and numbers)')
                        elseif strcmp(checkstr(1),'{') && strcmp(checkstr(end),'}')
                            isastr=0;
                            valraw=cell(nrows,vnum);
                            for kk=0:nrows
                                rstr=raw{irow+kk,jj};
                                if ~isempty(rstr)
                                    %strip the string markings (') 
                                    istr=strfind(rstr,'''');
                                    rstr=rstr( ~ismember(1:length(rstr),istr) );

                                    icomm=strfind(rstr,',');
                                    isc = strfind(rstr,';');

                                    idelim=[strfind(rstr,'{') icomm strfind(rstr,'}')];


                                    if isempty(strfind(rstr,'{') )
                                        idelim=[strfind(rstr,'[') icomm strfind(rstr,']')]; % square brackets underneath curly brackets?
                                    end
                                    if isempty(idelim)
                                        for pp=1:vnum
                                            valraw{kk+1,pp}=nan;
                                        end
                                    else
                                        if ~isempty(isc) || isempty(icomm)
                                            % you are trying to import a matrix
                                            valraw{kk+1,1}= str2num(rstr);
                                        else
                                            % you are trying to import a vector
                                           %nvec=max([vnum length(idelim)-1]);
                                            for pp=1:vnum
                                                estr=rstr(idelim(pp)+1:idelim(pp+1)-1);
                                                if isnan(str2double(estr)) || isempty(str2double(estr)) % is this a MATLAB version thing?
                                                     valraw{kk+1,pp}=estr;
                                                else
                                                    valraw{kk+1,pp}=str2double(estr);
                                                end
                                            end
                                        end
                                    end
                                else
                                   valraw{kk+1,1} = nan;
                                end
                            end 

                        end
                    end
                    %

                    for kk=1:nrows+1
                        if ~isastr
                            RunList(nvars+kk).(fname)=valraw(kk,:);
                        else
                            RunList(nvars+kk).(fname)=valraw{kk,:};
                        end
                    end
                    % or
                    %RunList.(fname)=valraw;
                end
            end
            nvars=nvars+nrows+1;
        else
            RunInfo=readExcel(xlsfile,1,'MATLAB Variable','MATLAB Value','');
        end
    end
end

for ii=1:nSheets
    if sum(irun)<1
        display(['Cannot find "MATLAB Name" in ' xlsfile '-' sheets{ii} '. Please write "MATLAB Name" on the first column of the headers']) 
    end
end
if sum(irun)<1
    error('No point in continuing since RunList is empty')
end
end