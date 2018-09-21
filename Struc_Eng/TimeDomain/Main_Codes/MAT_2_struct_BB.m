
close all
clear all
clc

path='08082016_Bimodal_Fatigue';%folder name you want it to look for mat
cd(path)
fnames = dir('*.mat');
numfids = length(fnames);
vals = cell(1,numfids);
Basebend={'Fxt12','Fyt12', 'Fzt12','Mxt12','Myt12', 'Mzt12'};% variables you want to pull
for K = 1:numfids
    temp = load(fnames(K).name);%(Basebend{i}
    for i = 1:length(Basebend)
       vals{K}(:,i) = temp.(Basebend{i});
    end
    clear temp
end

%%%vals is the structure for you!!!!