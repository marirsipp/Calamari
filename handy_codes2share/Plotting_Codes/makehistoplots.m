function makehistoplots(figdir,basename,data,nr,isemi)


% obs.labels={'Hs-Combo','Tp-Combo','Wave Dir-Combo','Wind Dir','Wind Speed'};
% obs.units={'(m)', '(s)', '(deg)', '(deg)', '(m/s)'};

%% SO HARDCODED!!! AHHH!
% Hsedge=[0:1:6 inf];
% Tpedge=[0:4:24 inf];
% Wdedge=[0:60:360 inf];
% Vdedge=[0:60:360 inf];
% Vspedge=[0:2:22 inf];
% 
% nHs=length(Hsedge)-1;
% nTp=length(Tpedge)-1;
% nWd=length(Wdedge)-1;
% nVd=length(Vdedge)-1;
% nVsp=length(Vspedge)-1;
% 
% 
% padN=max([nHs nTp nWd nVd nVsp])*ones(1,nP)-[nHs nTp nWd nVd nVsp];
% e1=[Hsedge' ; nan(padN(1),1)];
% e2=[Tpedge' ; nan(padN(2),1)];
% e3=[Wdedge' ; nan(padN(3),1)];
% e4=[Vdedge' ; nan(padN(4),1)];
% e5=[Vspedge' ; nan(padN(5),1)];
% myedges=[e1,e2,e3,e4,e5];
[ntr,nP]=size(nr);

nplot=length(data(1).labels);
nrun=length(data);
if ntr==1
    nr=repmat(nr,[nrun 1]);
end
nbin=nan(nrun,1);
pltstr={'rs','bo','cx','m^','kv','r<'};
for ii=1:nplot
    hf=figure('Name',data(1).labels{ii});
    set(hf,'Units','inches','Position',[-16.7708    0.0000+.5*ii   16.6771    4.3750])
    for kk=1:nrun
        bincount=data(kk).binN;
        nbin(kk)=length(bincount);
        bindata=data(kk).bindata;
        obsdata=data(kk).obsdata;
        rawedges=data(kk).edges;
        %bindata and obsdata are unnormalized
        [Nobs,nP]=size(obsdata);
        myedges=makenewedges(rawedges,nr(kk,:));
        %get the non-nan edges
        iedges=myedges(~isnan(myedges(:,ii)),ii) ;
        %redges=rawedges(~isnan(rawedges(:,ii)),ii) ;
        if ~isinf(iedges(end))
           iedges(end+1)=inf; % add in an infinity just to make sure all observations are accounted for (histc will return 0 at the end)
        end
%         if ~isinf(redges(end))
%            redges(end+1)=inf; % add in an infinity just to make sure all observations are accounted for (histc will return 0 at the end)
%         end
        % count up the observed data 
        obsN=histc(obsdata(:,ii),iedges);% last value includes edges that match end of myedges
        obsN=obsN(1:end-1); %remove the 0 due to the inf
        medges=[nanmean([iedges(1:end-2) iedges(2:end-1)],2); iedges(end-1)+mean(diff(iedges(1:end-1)))];
        
        if ~isinf(iedges(end))
            medges(end+1)  = iedges(end);
        end
        
%         if kk==nrun
% 
%         end
        % count up the bin data 
        [~,ibin]=histc(bindata(:,ii),iedges); % ibin will never equal length(iedges)+1, due to inclusion of infinity 
        ubin=unique(ibin);
        binN=zeros(length(iedges)-1,1);
        for jj=1:length(ubin)
            ibinj=ubin(jj);
            binN(ibinj)=sum(bincount(ibin==ibinj)); %terrible memory allocation!!
        end
       % bincount(ibin)


        if isemi
            semilogy(medges,binN./Nobs,pltstr{kk})
        else
            plot(medges,binN./Nobs,pltstr{kk})
        end
        hold on
        if sum(binN)~=Nobs
            disp(sprintf('not all binned data is accounted for. Sum of binned observations is: %d, while total observations is %d',sum(binN),Nobs) )
        end
        %bar(iedges,
        legstr{kk}=sprintf('Binned Data, N = %d',nbin(kk));
        %nbins=sum(bincount(ibin));
    end
    if isemi
        semilogy(medges,obsN./Nobs,'k-')
    else
        plot(medges,obsN./Nobs,'k-')
    end
    xlabel([data(1).labels{ii} data(1).units{ii}])
    ylabel('Probability of Occurrence')

    legstr{nrun+1}='Raw data';%, 'Binned data')
    colstr=getxstrs(iedges);
    set(gca,'xtick',medges,'xticklabel',colstr);
    grid on
    set(gca,'position',[ 0.0700    0.1100    0.9    0.8150])
    legend(legstr);
    set(hf,'paperunits','inches','paperposition',[0 0 16 4])
    if isemi
        sstr='log';
    else
        sstr='';
    end
    lstr=data(1).labels{ii};
    nosp=1:length(lstr);
    isp=strfind(lstr,' ');
    lstr=lstr(~ismember(nosp,isp));
    print(hf,[figdir basename, sprintf('Histogram%s_%s_N%d',sstr,lstr,nbin(1)) '.png'],'-dpng','-r300')

end
hold off
end
function ned=makenewedges(ed,nr)
[nB,nP]=size(ed);
if length(nr)==1
    nr=nr*ones(1,nP);
end
if length(nr)~=nP
    error('set refine vector to be same length as number of dimensions')
end
nE=sum(~isnan(ed),1);
nD=nE.*nr;
if max(nr)>1
    nBn=max(nD)-1;
else
    nBn=max(nD);
end
ned=nan(nBn,nP);
for ii=1:nP
   olde=ed(1:nE(ii),ii);
   newm=ndlinspace(olde(1:end-1),olde(2:end),nr(ii)+1); %newedges is a matrix nE(ii) x  nR+1
   newmp=newm';
   row1=newmp(:,1);
   rest=newmp(2:end,2:end);
   newe= [row1(:) ;rest(:)];
   ned(1:length(newe),ii)=newe;
end

%    je(
%    for jj=1:length(olde)-1
%        je=linspace( olde(jj),olde(jj+1),nr(ii));
%     newnD=nan(nD(ii),1);
%    
%    newnD(1:nr(ii):end)=
%    ned(1 
% end
end
function colstr=getxstrs(xe)
nH=length(xe)-1; %don't count inf
for jj=1:nH
    if jj<nH
        if rem(xe(jj),1)>0 || rem(xe(jj+1),1)>0 
            colstr{jj}=sprintf('%1.1f-%1.1f',xe(jj),xe(jj+1));
        else
            colstr{jj}=sprintf('%d-%d',xe(jj),xe(jj+1));
        end
    elseif jj==nH
        if rem(xe(jj),1)>0 
            colstr{jj}=sprintf('%1.1f +,', xe(jj));
        else
            colstr{jj}=sprintf('%d +,', xe(jj));
        end
    end
end
% for jj=1:nT
%     if jj<nT
%         rowstr{jj}=sprintf('%d-%d (s),',jj-1,jj);
%     else
%         rowstr{jj}=sprintf('%d +,', jj-1);
%     end
% end
end