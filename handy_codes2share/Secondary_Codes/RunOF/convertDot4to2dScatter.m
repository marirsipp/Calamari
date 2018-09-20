function ScatterFile=convertDot4to2dScatter(dot4file,wP,varargin)
strh{1}='N.B: Wdir (wave heading towards)= N=0deg W=90 deg S= 180 deg E=270deg';
strh{2}='All outputs (motions, forces, moments, etc) are in SI (kg,m,sec,N,N-m) per wave amplitude (m)';

%wP=0; %deg WindFloat heading, all RAOs should be done at 0 deg heading for ease of calculation
%wBin=30;% deg
if nargin<1
    filetypes={'*.4;*.rao'};
   dot4file=uigetfile(filetypes,'Select .4 file');  
end
if nargin<2
    wP = 0;
end

%Tpedge=[0:1:15,inf];%./maxs(2);
%nTp=length(Tpedge)-1;

[maindir,filename,dot4]=fileparts(dot4file);
iHs= regexp(filename,'_\d+m','match');
 if ~isempty(iHs)
     iHs=iHs{1};
     %HsStr=filename(iHs+1:iHs+1);
%     runname=filename(1:iHs-1);
     Hs = str2double(iHs(2));
 else
%     runname=filename;
     Hs = 2; % ?????
 end  
if wP
    tname=[maindir filesep filename '_Orient' num2str(wP) '.csv'];
    matname=[maindir filesep filename '_Orient' num2str(wP) '.mat'];
else
    tname=[maindir filesep filename '.csv'];
    matname=[maindir filesep filename '.mat'];
end

fiddat = fopen(dot4file);
%read header line and discard it
dataline = fgetl(fiddat);
mydata = readDot4file(fiddat);
[nWP,nH]=size(mydata);
nH=nH-2;
RAOwDir = sort(unique(mydata(:,1)));
nW=length(unique(mydata(:,1)));
wBin=mean(diff(unique(mydata(:,1))));
nP=length(unique(mydata(:,2)));

wDir = RAOwDir - wP*ones(nW,1); % wave heading relative to platform heading
%wPn=(wP-wBin/2);
Wdedge= [wDir-wBin/2*ones(nW,1) ;wDir(end)+wBin/2];%[wPn:wBin:360+wPn];%30/maxs(1) 1+wPn

fid=fopen(tname,'w+');
for jj=1:length(strh)
    fprintf(fid,'%s \n',strh{jj});
end
strd='%2.6f,';
fmt=[repmat(strd,[1,nH+1]) ' \n'];

%rowstr=getrcstrs(Tpedge(1:end-1));
if strfind(dot4file,'RNA')
    colstr={'Period (s),','|RAO_1|,','|RAO_2|,','|RAO_3|,','|RAO_4|,','|RAO_5|,','|RAO_6|,',...
    'Phase_1,','Phase_2,','Phase_3,','Phase_4,','Phase_5,','Phase_6'};
elseif strfind(dot4file,'TWR')
        colstr={'Period (s),','|TwrBs_Fx|,','|TwrBs_Fy|,','|TwrBs_Fz|,','|TwrBs_Mx|,','|TwrBs_My|,','|TwrBs_Mz|,',...
    'Phase_1,','Phase_2,','Phase_3,','Phase_4,','Phase_5,','Phase_6'};
else
    %what the heck are you plotting?
        colstr={'Period (s),','|RAO_1|,','|RAO_2|,','|RAO_3|,','|RAO_4|,','|RAO_5|,','|RAO_6|,',...
    'Phase_1,','Phase_2,','Phase_3,','Phase_4,','Phase_5,','Phase_6'};
end
nI=1; 
nDOF=6;
RAO(nW).Amp = nan(nP,nDOF);
RAO(nW).Phase = nan(nP,nDOF);
for ii=1:nW
   rowj=nI:nI+nP-1;
   mymat=mydata(rowj,3:end);
   myper=mydata(rowj,2);
   nI=nI+nP;
   % csv file
   fprintf(fid,'\n');
   fprintf(fid,'%s %d to %d %s','Wave Heading: ',[round(Wdedge(ii) ) round(Wdedge(ii+1))],'deg');
   fprintf(fid,'\n');
   fprintf(fid,'%s',colstr{:});
   fprintf(fid,'\n');
   % mat file
   RAO(ii).Wdir1= Wdedge(ii);
   RAO(ii).Wdir2= Wdedge(ii+1);
   RAO(ii).Wdir = mean([  Wdedge(ii) Wdedge(ii+1) ]);
   RAO(ii).Hs = Hs;
   RAO(ii).Tp = myper;
   for kk=1:nP
      tdata=[sprintf('%1.1f,',myper(kk)) sprintf(fmt,mymat(kk,:))];
      fprintf(fid,'%s\n',tdata);
      RAO(ii).Amp(kk,:) = mymat(kk,1:nDOF) ;
      RAO(ii).Phase(kk,:) = mymat(kk,nDOF+1:2*nDOF) ;
   end

end
fclose(fid);
ScatterFile=matname;
%
save(matname,'RAO');
end


function mydata = readDot4file(fiddat)
[c,count]=fscanf(fiddat,'%f %f %i %f %f %f %f',[7 inf]);
Xs = sortrows(c',[3 2 1]);
Data.Xs=Xs;
Data.Per=Xs(:,1);
Data.Heading=Xs(:,2);
Data.DOFi=Xs(:,3);
Data.ModRAO=Xs(:,4);
Data.PhRAO=Xs(:,5);
Data.ReRAO=Xs(:,6);
Data.ImRAO=Xs(:,7);
[uHead,iHead,foo]=unique(Data.Heading);
[uPer,iPer,foo]=unique(Data.Per);
nHead=length(uHead);
nPer=length(uPer);
mydata=zeros(nHead*nPer,2+12);
for hh=1:nHead
    ih=Data.Heading==uHead(hh);
    for pp=1:nPer
        ip=Data.Per==uPer(pp);
        iph = ip & ih;
        iDOFs=Data.DOFi(iph);
        nDOFs=length(iDOFs);
        mydata((hh-1)*nPer+pp,1)=uHead(hh);
        mydata((hh-1)*nPer+pp,2)=uPer(pp);
        mydata((hh-1)*nPer+pp,2+iDOFs)=Data.ModRAO(iph);
        mydata((hh-1)*nPer+pp,2+nDOFs+iDOFs)=Data.PhRAO(iph);
    end
end
        %should be 6 DOFs
        
    
% Data.NoElePerDOF = max(find(Xs(:,3)==1));
% temp =find(Xs(:,1)==Xs(1,1));
% Data.NoPer = temp(2)-1;
% Data.NoHeading = Data.NoElePerDOF/Data.NoPer;
% Data.NoBody = max(Xs(:,3))/6;
% Data.NoFig=6*Data.NoBody; %6*Data.NoHeadSelec*Data.NoBody;
end

function [rowstr]=getrcstrs(eT)
nT=length(eT);
% nH=length(eH);
% for jj=1:nH+2
%     if jj<=nH && jj>1
%         colstr{jj}=sprintf('%1.1f-%1.1f (m),',eH(jj-1),eH(jj));
%     elseif jj==1
%         colstr{jj}=sprintf('%s','foo,');
%     elseif jj==nH+1
%         colstr{jj}=sprintf('%d +,', eH(jj-1));
%     elseif jj==nH+2
%         colstr{jj}=sprintf('%s,', 'Sum');
%     end
% end
for jj=1:nT
    if jj<nT
        rowstr{jj}=sprintf('%d-%d (s),',eT(jj),eT(jj+1));
    else
        rowstr{jj}=sprintf('%d +,', eT(jj));
    end
end
end



