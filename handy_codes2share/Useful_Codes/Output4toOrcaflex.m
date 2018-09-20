function Output4toOrcaflex(varargin)
% Input .4 to OrcaFLEX Load/Displacement RAOs
% Reads .4 file and inputs it to orcaflex, with modes 3, 4, 5
% with values of 0.
% Created by Alan Lum (modified by Yannick Debruyne on 07/06/2013)
% Modified by Sam Kanner, 03/17/2017, Copyright Principle Power Inc 

%%%%%%%%%%%%%%%%%%%%%%%% ORCAFLEX VERSION %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Orcina changed the selectedRAO syntax from 9.7 -> 10.1
myofxv=str2double(regexp(ofx.DLLVersion,['\d+\.\d*'],'match'));
%%%%%%%%%%%%%%%%%%%%%%%% ORCAFLEX VERSION %%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin==0
    [filename, fpath]=uigetfile('*.4', 'Select .4 file');
    dot4file=[fpath filename];
elseif nargin>0
    dot4file=varargin{1};
end
fid_4 = fopen(dot4file);
fgets(fid_4);
rho = 1025;
g = 9.8065;
% rho=1025*0.068521/(3.28^3); %slug/ft^3
% g=32.17405; %ft/s^2
rhog = rho*g;
data_4 = fscanf(fid_4, '%f %f %i %f %f %f %f', [7 inf]);
fclose all;
periods = unique(data_4(1,:));
directions = unique(data_4(2,:));
for jj = 1:length(directions)
    index_1 = find(data_4(2,:) == directions(jj) & data_4(3,:) == 1);
    index_2 = find(data_4(2,:) == directions(jj) & data_4(3,:) == 2);
    index_3 = find(data_4(2,:) == directions(jj) & data_4(3,:) == 3);
    index_4 = find(data_4(2,:) == directions(jj) & data_4(3,:) == 4);
    index_5 = find(data_4(2,:) == directions(jj) & data_4(3,:) == 5);
    index_6 = find(data_4(2,:) == directions(jj) & data_4(3,:) == 6);
    varname = sprintf('DisplacementRAOs_%d', directions(jj));
    eval([varname ' = transpose(periods);']);
    eval([varname '(:,2) = transpose(data_4(4, index_1));']);  %%%% take column 4 for amplitude 
    eval([varname '(:,3) = transpose(data_4(4, index_2));']);
    eval([varname '(:,4) = transpose(data_4(4, index_3));']);
    eval([varname '(:,5) = transpose(data_4(4, index_4));']);
    eval([varname '(:,6) = transpose(data_4(4, index_5));']);
    eval([varname '(:,7) = transpose(data_4(4, index_6));']);
    eval([varname '(:,8) = transpose(data_4(5, index_1));']);  %%%% take column 5 for phase
    eval([varname '(:,9) = transpose(data_4(5, index_2));']);
    eval([varname '(:,10) = transpose(data_4(5, index_3));']);
    eval([varname '(:,11) = transpose(data_4(5, index_4));']);
    eval([varname '(:,12) = transpose(data_4(5, index_5));']);
    eval([varname '(:,13) = transpose(data_4(5, index_6));']);
end
directions=sort(directions);
%% ORCAFLEX Import
if nargin<2
    [fileOrca, fpath]=uigetfile('*.dat', 'Select OrcaFlex file');
    datfile=[fileOrca, fpath];
elseif nargin==2
    datfile=varargin{2};
end
model = ofxModel(datfile);
[WindFloat,WindFloatType]=getWindFloatModel(model);
% VesselName='Platform';
% %VesselName='PlatformWF';
% % VesselType='WindFloat Portugal_CenterTower_ORCAFAST';
% %VesselType='WindFloat_6MW_CenterPlatform_ORCAFAST';
% VesselType='MF_Deepstar_infDepth';
% DraftName='Draught1';
% environment = model('Environment');
% general= model('General');
% WindFloat = model(VesselName);
% WindFloatType = model(VesselType);
%WindFloatType.SelectedDraught = DraftName;
WindFloatType.SelectedRAOs = 'Displacement';
WindFloatType.NumberOfRAODirections = 0;
WindFloatType.NumberOfRAODirections = length(directions);
model.SaveData(datfile);
nn = 0;
%enter directions
for jj = 1:length(directions)
   if myofxv>=10
       try 
           WindFloatType.SelectedRAODirection = num2str(directions(jj));
       catch
           WindFloatType.SelectedRAODirection = num2str(0);
       end
       if directions(jj)>0
            WindFloatType.RAODirection = directions(jj);
       end
   else
%        try 
%            WindFloatType.SelectedRAODirection = jj;
%        catch
%            WindFloatType.SelectedRAODirection = 0;
%        end
        WindFloatType.SelectedRAODirection = jj-1;
       if directions(jj)>0
            WindFloatType.RAODirection = directions(jj);
       end
   end
end
for jj = 1:length(directions)
    varname = sprintf('DisplacementRAOs_%d', directions(jj));
    varname2=eval(varname);
%     if directions(jj) == 0
%         WindFloatType.SelectedRAODirection = num2str(nn);
%     elseif directions(jj) > 0
%         WindFloatType.SelectedRAODirection = num2str(nn+1);
%         WindFloatType.RAODirection = directions(jj);
%     else
%         WindFloatType.SelectedRAODirection = nn+1;
%         nn = nn + 1;
%         WindFloatType.RAODirection = directions(jj);
%     end
    if myofxv>=10
        WindFloatType.SelectedRAODirection = num2str(directions(jj));
    else
        WindFloatType.SelectedRAODirection = jj-1;
    end
    %WindFloatType.RAODirection = directions(jj);
    WindFloatType.NumberOfRAOPeriodsOrFreqs = length(periods);
    for kk=1:length(periods)
        WindFloatType.RAOPeriodOrFreq(kk)=varname2(kk,1);
        WindFloatType.RAOSurgeAmp(kk)=varname2(kk,2);
        WindFloatType.RAOSwayAmp(kk)=varname2(kk,3);
        WindFloatType.RAOHeaveAmp(kk)=varname2(kk,4);
        WindFloatType.RAORollAmp(kk)=varname2(kk,5);
        WindFloatType.RAOPitchAmp(kk)=varname2(kk,6);
        WindFloatType.RAOYawAmp(kk)=varname2(kk,7);
        WindFloatType.RAOSurgePhase(kk)=varname2(kk,8);
        WindFloatType.RAOSwayPhase(kk)=varname2(kk,9);
        WindFloatType.RAOHeavePhase(kk)=varname2(kk,10);
        WindFloatType.RAORollPhase(kk)=varname2(kk,11);
        WindFloatType.RAOPitchPhase(kk)=varname2(kk,12);
        WindFloatType.RAOYawPhase(kk)=varname2(kk,13);
    end
    model.SaveData(datfile);
end
end
%clear all