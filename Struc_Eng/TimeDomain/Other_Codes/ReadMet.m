clc
clear all
close all

%--------------------------------Input-------------------------------------
% path0 = 'C:\Users\Ansys.000\Documents\MATLAB\TimeDomain';
% BatchNo = 'Batch_Vestas2';
% life = 25; %year

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BEGIN USER-DEFINED CODE %%%%%%%%%%%%%%%%%%
path0 = 'C:\Users\Ansys.000\Documents\MATLAB\TimeDomain';
BatchNo = 'BatchA_Vestas2';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BEGIN USER-DEFINED CODE %%%%%%%%%%%%%%%%%%

output = 'metocean';

path1 = [path0 '\' BatchNo '\Metocean\'];
cd(path1)
fnames = dir('*.xlsx');
numfids = length(fnames);

for n = 1:numfids
    
    [num1, txt1]=xlsread(fnames(n).name,'wind');
    RunNo = size(num1,1);
    for m = 1:RunNo
        RunName = ['Run' txt1{m+2,1} '_PPI'];
        metocean.(RunName).(txt1{1,2})=num1(m,1);
        metocean.(RunName).(txt1{1,3})=num1(m,2);
    end
    
    [num2, txt2]=xlsread(fnames(n).name,'wave');
    RunNo = size(num2,1);
    for m = 1:RunNo
        RunName = ['Run' txt2{m+2,1} '_PPI'];
        for n = 1:size(num2,2)
            metocean.(RunName).(txt2{1,n+1})=num2(m,n);
        end
    end
    
    clear num1 txt1 num2 txt2
end

save(output,'metocean');