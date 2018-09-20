function [data2plot, bindataraw,binN,rawedges,q]=Metocean_binning_algorithm(rawdata,maxs,offsets,W,Ne,ntol,dtol,plt)
% tdir is the directory of where the text file goes
% rawdata is the normalized data (number of observations x number of
% dimensions) 
% maxs is the un-normalized slopes of the data
% offsets is the un-normalized intercepts
% W is the weights to be used in the binning algorithm (number of
% observations x 1)
% Ne: Ne(nDims).count, Ne(nDims).xs, Ne(nDims).ys, see
% getNptsfromPDF(xs,ys,count)
% Nr is the type of refinements
% strl = 
% iwrite = logical to write table 
%define number of parameters
[Nt,Np]=size(rawdata);

%Np=5;
% define number of 'refinements'
%Nr=4;
% Set tolerance on percentage of observations in a bin to keep
%ntol=1e-1;%4e-3
% Set tolerance on normalized distance to rebin or not
%dtol=.1/Nr; %ie only rebin if it is X% distance away from the bin
dF=Ne(1).dFreeze;
myedges=getfirstedges(Np,Ne); %  Nb x Np size matrix of the edges of the initial bins
[Nb,~]=size(myedges);
rawedges=myedges.*repmat(maxs,[Nb 1])+repmat(offsets,[Nb 1]);
allbinsN=findmybin(rawdata,myedges); % [Nt x 1] array where each row is a scalar with the index of the corresponding bin for each parameter (in columns)

% define tolerance level for bins to keep
[sbins,sbinsN]=throwoutbins(allbinsN,ntol,Nt); % array of bin numbers (from allbinsN) that have passed the tolerance test, count of number of observations in each bin
% get bin data=[means,stdevs] to calculate distance
[bindata,binN]=getbindata(sbins,allbinsN,rawdata); %binN=sbinsN
%rebin the non-included data and get the max 1D distance of each of these
%rebinned observations to the centroid of the nearest bin 
niter=0;
[newbinsN,dPs]=rebin(sbins,allbinsN,rawdata,bindata,dtol,W,niter,dF,plt,myedges);
% get new bin data
%[bindata,binN]=getbindata(sbins,newbinsN,rawdata); %binN=sbinsN
%use original bins with a lower tolerance to try to rebin the distant data
while sum(dPs)>0
   niter=niter+1;
   irebin=dPs~=0;
   ntol=ntol/2; %decrease the tolerance (accept more bins) every iteration step
   %W=W*1; % does not increase the total number of bins produced, just gradually increases the range of each bin 
   %only update the new bins
   %allbinsN=newbinsN;
   newbinsN(isnan(newbinsN))=allbinsN(isnan(newbinsN)); %reset the bin numbers, back to the original values
   %get the new bin numbers that meet the updated criteria
   [farbins,sbinsN]=throwoutbins(newbinsN(irebin),ntol,Nt);
   sbins=[sbins;farbins];
   %sbins=sort([sbins;farbins]); %why do i need to sort them?
   % get bin data=[means,stdevs] to calculate distance
    [bindata,binN]=getbindata(sbins,newbinsN,rawdata); %binN=sbinsN
    [newbinsN,dPs]=rebin(sbins,newbinsN,rawdata,bindata,dtol,W,niter,dF,plt,myedges);
    disp(sprintf('Number of Observations Remaining: %d',sum(irebin)))
end

% output table
[bindataraw,binN,q]=getbintable(sbins,newbinsN,rawdata,maxs,offsets);
disp(sprintf('Quality q: %1.4f',q))
data2plot=rawdata.*repmat(maxs,[Nt 1])+repmat(offsets,[Nt 1]);

end