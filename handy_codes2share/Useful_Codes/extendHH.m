function extendHH(hhfile)
ndata=8;
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
fmtd=repmat('%f',[1 ndata]);
linedata1=fscanf(fid,fmtd,[1 ndata]);
linedata2=fscanf(fid,fmtd,[1 ndata]);
dt=linedata2(1)-linedata1(1);
%go back to the beginning of the data
fseek(fid,cpos1,'bof');
tdata=[0:dt:10000-dt];
oldatac=textscan(fid,fmtd,length(tdata));%nan(length(tdata),ndata);
oldata=cell2mat(oldatac);
% for ii=1:length(tdata)
%     oldata(ii,:)=fscanf(fid,fmtd,[1 ndata]);
% end
starpos=ftell(fid);
fmt2=['%*s' repmat('%f',[1 ndata-1])]; %skip the stars
newdatac=textscan(fid,fmt2);%nan(length(tdata),ndata);
%turn it into a matrix
newdata=cell2mat(newdatac);
nnew=size(newdata,1);
extenddt=[oldata(end,1)+dt;dt*ones(nnew-1,1)];
extendt=cumsum(extenddt);

fmtstar=['%s' repmat('%f',[1 ndata-1])]; %seek the stars
fseek(fid,starpos,'bof');
stardata=textscan(fid,fmtstar);
stars=stardata{:,1};
fclose(fid);

istar=strfind(stars,'********');
arestars=sum([istar{:}]);
if arestars>0
    idot=strfind(hhfile,'.');
    oldhhfile=[hhfile(1:idot-1) 'raw' hhfile(idot:end)];
    isucc=movefile(hhfile,oldhhfile);
    if isucc
        disp(['Creating ' oldhhfile ' and replacing old one'])
    end

    data2write=[oldata;extendt newdata ];
    %% write to file
    fid2=fopen(hhfile,'w+'); %rewrite oldfile
    for jj=1:length(preamble)
        fprintf(fid2,'%s\n',preamble{jj});
    end
    fmt2write1=['%8.3f  %6.2f  %6.2f  %6.2f  %6.3f  %6.3f  %6.3f  %6.2f\n'];
    fmt2write2=['%7.2f  %6.2f  %6.2f  %6.2f  %6.3f  %6.3f  %6.3f  %6.2f\n'];

    [nlines,ndata]=size(data2write);
    for jj=1:nlines
        if jj<=length(tdata)
            fprintf(fid2,fmt2write1,data2write(jj,:));
        else
            fprintf(fid2,fmt2write2,data2write(jj,:));
        end
    end
    fclose(fid2);
else
    disp(['Cannot find **s in ' hhfile ' No modifications made'])
end

end