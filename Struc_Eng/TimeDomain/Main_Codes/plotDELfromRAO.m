function [ output_args ] = plotDELfromRAO(raodir , DELmatname)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

allf = dir(raodir);
idir = [allf(:).isdir];
subdirnames = {allf(idir).name};
ndirs=length(subdirnames);
nRun=0;
for nn=1:ndirs
    allnums = regexp(subdirnames{nn},'\d*','match');
    if ~isempty(allnums)
        nRun=nRun+1;
        Orient(nRun) = str2double(allnums{1})*pi/180;
        dT(nRun) = str2double(allnums{2});
        Lt(nRun) = str2double(allnums{3});
        dTp(nRun) = str2double(allnums{4});
        load([raodir subdirnames{nn} filesep DELmatname])
        Mx(nRun) = TotDEL(4);
        My(nRun) = TotDEL(5);
    end
end
figure('name',['Mx for' DELmatname(1:end-4)])
polar(Orient,Mx,'ro')
view(-90,90)
figure('name',['My for' DELmatname(1:end-4)])
polar(Orient,My,'ro')
view(-90,90)
end

