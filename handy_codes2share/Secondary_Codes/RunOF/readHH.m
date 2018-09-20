function [t,U,Th,W]=readHH(hhfile)
if ~exist(hhfile,'file')
    error('.hh file does not exist')
end
fid=fopen(hhfile,'r+');
comments='!';
jj=0;
while strcmp(comments(1),'!')
    jj=jj+1;
    cpos1=ftell(fid);
    comments=fgetl(fid);
    preamble{jj}=comments;
end
preamble=preamble(1:end-1);
%go back to the beginning of the data
fseek(fid,cpos1,'bof');
ndata=8;
fmtd=repmat('%f',[1 ndata]);
ll=0;
while ~feof(fid)
    ll=ll+1;
    newline=fscanf(fid,fmtd,[1 ndata]);
    if ~isempty(newline)
        linedata(ll,:)=newline;
    end
end
t=linedata(:,1);
U=linedata(:,2);
Th=linedata(:,3);
W=linedata(:,4);
end