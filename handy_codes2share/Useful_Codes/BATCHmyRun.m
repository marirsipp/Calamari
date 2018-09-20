function BATCHmyRun(mainfcn,iptfile,stru,str1,dat1,varargin)
%% INITIALIZE
nipts=5;
nvars=1;
strs{nvars}=str1;
dats{nvars}=dat1;
if nargin>nipts+1
    nxtra=length(varargin);
else
    nxtra=0;
end
for pp=1:2:nxtra
    nvars=nvars+1;
    
    strs{nvars}=varargin{pp};
    dats{nvars}=varargin{pp+1};
end
%% CHECK
if ~strcmp(iptfile(end-1:end),'.m')
    iptfile=[iptfile '.m'];
end

%% RECURSE!
LOOPmyRun(mainfcn,iptfile,stru,strs,dats)

end

function LOOPmyRun(mainfcn,iptfile,stru,strs,dats)
% dats = list of cells, each with a list of variables
% Dimensions of dats
nds=cellfun(@(c) length(c),dats);
% Find first non-singleton dimension (could be str arrays or vectors)
dd=find(nds==1,1,'last');
uhoh=find(nds==0);
if ~isempty(uhoh)
    error('one of your dimensions is empty')
end
%what if there is a singleton dimension after
if isempty(dd)
    dd=1;
elseif dd==length(nds)
    %you're on the last dimension
else
    dd=dd+1; % first non singleton dat
end
if nds(dd)>1
    prevdats=dats(1:dd-1);
    if dd==length(dats)
        postdats={};
    else
        postdats=dats(dd+1:end);
    end
    ddat=dats{dd}; % actual list of variables to loop through
    for jj=1:nds(dd)
        if isnumeric(ddat)
            jdat=ddat(jj);
        elseif iscell(ddat)
            jdat=ddat(jj);
        end
        dats={prevdats{:},jdat,postdats{:}}; % concatenate all lists, making sure sure current list only has 1 element
        LOOPmyRun(mainfcn,iptfile,stru,strs,dats);
    end
else
       newiptfile=rewriteIPT(iptfile,stru,strs,dats);
       rehash
       eval([mainfcn '(''' newiptfile ''')'])
       %disp(['Ran ' mainfcn 'for ' datu ])
       pause(2)
end
end

function newiptfile=rewriteIPT(iptfile,stru,strs,dats,varargin)
newiptfile=[iptfile(1:end-2) '_BATCH.m'];
Ipt = regexp( fileread(iptfile), '\n', 'split');
nipts=4;
if length(strs)~=length(dats)
    error('huh')
else
    nvars=length(dats);
end

xtrastr=[];
dispstr=[];
for pp=1:nvars
    if isnumeric(dats{pp})
        nmax = 10^round(log(abs(dats{pp}))./log(10)); % ouch, if there is a large variety in the parameters then the naming will be weird
        if nmax>0
            num2print=round(dats{pp}*100/nmax) ;
        else
            num2print=nmax;
        end
        xtrastr=[xtrastr sprintf('%s%03d',strs{pp},num2print)];
        dispstr=[dispstr sprintf('%s = %2.3f, ',strs{pp},dats{pp})];
    elseif iscell(dats{pp})
        tmp = dats{pp};
        str2print = tmp{:};
        xtrastr=[xtrastr strs{pp} str2print];
        dispstr=[dispstr sprintf('%s = %s, ',strs{pp},str2print)];
    end
end
    
if isempty(stru)
    disp('Naming variable is empty. Multiple calls to main function could result in overwriting output files')
    istru='';
else
    istru=find(~cellfun('isempty',strfind(Ipt,stru)));
    if isempty(istru)
        error('Cannot find variable of unique string to overwite for naming purposes') 
    else
        iptu=Ipt{istru};
    end

    % replace unique filename
    oldu=regexp(iptu,'''(.[^'']*?)''','match'); % look for quotes
    oldustr=oldu{1};
    % come up with a new filename
    [udir,uname,uext]=fileparts(oldustr); % assume it is a filename

    datu = [udir filesep uname '_' xtrastr uext];
    Ipt{istru}=strrep(iptu,oldustr,datu);
end
% replace other vars

for nn=1:nvars
    istr1=find(~cellfun('isempty',strfind(Ipt,strs{nn})));
    if isempty(istru)
        iustr1 = istr1;
    else
        iustr1=istr1(~ismember(istr1,istru)); % make sure you're not modifying that filename
    end
    if length(iustr1)>1
        % then it is referenced in the input file in multiple places. Only
        % change when it is first called (ie., when it is
        % set)
        for ii=1:length(iustr1)
            iptline = Ipt{iustr1(ii)};
            if strcmp(iptline(1),'%')
                % move along, it is just a comment
            else
                % grab the first one
                iustr1 = iustr1(ii);
                break
            end
        end
    end
    ipt1=Ipt{iustr1};
    if isnumeric(dats{nn})
        Ipt{iustr1}=regexprep(ipt1,'[-+]?\d*\.?\d*',sprintf('%5.2f',dats{nn}));
    elseif iscell(dats{nn})
        dcell=dats{nn};
        Ipt{iustr1}=regexprep(ipt1,'(?<='')[^'']+(?='')', dcell{:});
    else
        Ipt{iustr1}=regexprep(ipt1,'''(.[^'']*?)''',dats{nn});
    end 
end
fid = fopen(newiptfile, 'w');
fprintf(fid, '%s\n', Ipt{:});
fclose(fid);
disp(['Wrote to ' newiptfile ' with ' dispstr])
rehash
end

% nv=1;
% for ii=1:length(dat1)
%    idat=dats{nv}; 
%    idat1=idat(ii);
%    if nvars>1
%        nv=nv+1;
%        jdat=dats{nv};
%        for jj=1:length(dat2)
%            jdat2=jdat(jj);
%            if nvars>2
%                nv=nv+1;
%                kdat=dats{nv};
%                
%            else
%                 newiptfile=rewriteIPT(iptfile,stru,datu,str1,idat1,str2,jdat2);
%                 rehash
%                 eval([mainfcn '(' newiptfile ')'])
%                 disp(['Running ' mainfcn 'for ' datu ]) 
%            end
%        end
%    else
%        
%        newiptfile=rewriteIPT(iptfile,stru,datu,str1,idat1);
%        rehash
%        eval([mainfcn '(' newiptfile ')'])
%        disp(['Running ' mainfcn 'for ' datu ])
%    end
% end