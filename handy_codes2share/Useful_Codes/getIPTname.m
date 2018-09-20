function iptname=getIPTname(funcname)
absname=which(funcname);
islash=strfind(absname,filesep);
funcdir=absname(1:islash(end));
files=dir(funcdir);

nf=0;
for ii=1:length(files)
    ip=strcmpi(files(ii).name,[funcname 'ipt.m']);
    if ip
        iptname=files(ii).name;
        nf=nf+1;
    end
end
if nf==0
    error(['Cannot locate ' funcname 'ipt.m in ' funcdir '. Try COPYING (not renaming) ' funcname 'IPT.sample to ' funcname 'ipt.m to run ' funcname '.m using default values.'])
elseif nf==1
    disp(['Using input parameters defined in ' iptname ])
else
    error(['Multiple inputs files found (case-insensitive). Please remove one of the files named: ' iptname ])
end
[foo,iptname,mext]=fileparts(iptname);
end