function [data2plot, bindataraw,binN,q]=Metocean_binning_mda(rawdata,maxs,offsets,W,nbinsdes,dtol,plt,matdir,xeno)
% tdir is the directory of where the text file goes
% rawdata is the normalized data (number of observations x number of
% dimensions) 
% maxs is the un-normalized slopes of the data
% offsets is the un-normalized intercepts
% W is the weights to be used in the binning algorithm (number of
% observations x 1)
%define number of parameters
[Nt,Np]=size(rawdata);
Lk=2;
irerebin=1;
% Set tolerance on normalized distance to rebin or not
%dtol=.1/Nr; %ie only rebin if it is X% distance away from the bin

% define tolerance level for bins to keep
%[sbins,sbinsN]=throwoutbins(allbinsN,ntol,Nt); % array of bin numbers (from allbinsN) that have passed the tolerance test, count of number of observations in each bin

%rebin the non-included data and get the max 1D distance of each of these
%rebinned observations to the centroid of the nearest bin 
niter=0;
%[newbinsN,dPs]=rebin(sbins,allbinsN,rawdata,bindata,dtol,W,niter,dF,plt);
% get mda bin data
dPs=ones(Nt,1); newbinsN=nan(Nt,1); 
idir = maxs>358 & maxs<360.1;
beenbin=mda2(rawdata,ceil(nbinsdes*xeno),[],idir,Lk,matdir);
% assign bin numbers
ibeenbin=ismember(rawdata,beenbin,'rows');
Nbins=sum(ibeenbin);
sbins=1:Nbins; % come up with arbitrary bin numbers
newbinsN(logical(ibeenbin)) = sbins; % assign bin numbers to each of the initial chosen observations
dPs(ibeenbin)=0;
%use original bins with a lower tolerance to try to rebin the distant data
dmax=0;
while sum(dPs)>0
   niter=niter+1;
   %% STEP 1: cluster observations
   % get bin data=[means,stdevs] to calculate distance
   [bindata,binN]=getbindata(sbins,newbinsN,rawdata); %binN=sbinsN
   [newbinsN,dPs,dmax]=rebin(sbins,newbinsN,rawdata,bindata,dtol,W,niter,[],plt,[],irerebin);
   irebin=dPs~=0;
   nobsleft=sum(irebin);
   disp(sprintf('Iteration %d: Observations Remaining: %d. Largest distance = %1.3f',niter,sum(irebin),dmax))
   if sum(dPs)==0
       break
   elseif sum(irebin) == 1
       % only 1 observation remains
       minbin=1;
   else
       minbin=1;% or 2?
   end
   %% STEP 2: run mda again
   unbindata=rawdata(logical(irebin),:);
   n2start=floor(max([(nbinsdes-Nbins)*xeno minbin]));
   if nobsleft+Nbins > floor(nbinsdes*.95) && nobsleft+Nbins < ceil(nbinsdes*1.05)
       n2start=nobsleft;
   end
   beenbin=mda2(unbindata,n2start,bindata(:,1:Np) ,idir,Lk,matdir); % re-run MDA to get new bins

   Ntotbins = size(beenbin,1);
   Nnewbins = Ntotbins - Nbins;
   snewbins=Nbins+1:Ntotbins; % come up with arbitrary bin numbers
   [tf,loc] =ismember(rawdata,beenbin(snewbins,:),'rows');
   [foo,pp] = sort(loc(tf));
   ibeenbin  = find(tf);
   ibeenbin  = ibeenbin(pp);
   %Nnewbins=sum(ibeenbin)-Nbins;
   newbinsN(ibeenbin) = snewbins; 
   
   Nbins=Nbins+Nnewbins;
   
   sbins=1:Nbins;%[sbins snewbins];
   dPs(ibeenbin)=0;
   irebin=dPs~=0;
   nobsleft=sum(irebin);
   disp(sprintf('Iteration %d.5 has %d bins: Observations Remaining: %d',niter,Nbins,nobsleft))
   nbins2go =nbinsdes-Nbins;
%% STEP 3 End-Game 
    if nbins2go > 0 
       if nbins2go > floor(nobsleft*.95) && nbins2go < ceil(nobsleft*1.05)
       
           % cluster them all!
           ibeenbin = find(irebin);
           snewbins=Nbins+1:Nbins+nobsleft; % come up with arbitrary bin numbers
           newbinsN(ibeenbin) = snewbins; 
           dPs(ibeenbin)=0;
           disp(sprintf('All remaining %d bins have each been given single cluster in Iteration %d.',nobsleft,niter))
              
            Nbins=Nbins+nobsleft;
            sbins=1:Nbins;
       end
    elseif nbins2go < floor(nobsleft*.95)
        %keep moving along
    elseif nbins2go > floor(nobsleft*1.05)
        % something is wrong...
        irerebin=0;
    end
end

% output table
[bindataraw,binN,q]=getbintable(sbins,newbinsN,rawdata,maxs,offsets);
disp(sprintf('Quality q: %1.4f',q))
data2plot=rawdata.*repmat(maxs,[Nt 1])+repmat(offsets,[Nt 1]);

end