function WAMITOutput8toOrcaflex(varargin)
% Input .8 to OrcaFLEX Drift Forces
% Reads .8 file and inputs it to orcaflex, with modes 3, 4, 5
% with values of 0.
% Created by Alan Lum (modified by Yannick Debruyne on 07/06/2013)
% Modified by Sam Kanner, 03/17/2017, Copyright Principle Power Inc 

%%%%%%%%%%%%%%%%%%%%%%%% ORCAFLEX VERSION %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Orcina changed the selectedRAO syntax from 9.7 -> 10.1
myofxv=str2double(regexp(ofx.DLLVersion,['\d+\.\d*'],'match'));
%%%%%%%%%%%%%%%%%%%%%%%% ORCAFLEX VERSION %%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin==0
    [filename, fpath]=uigetfile('*.8', 'Select WAMIT output.8');
    dot8file=[fpath filename];
elseif nargin>0
    dot8file=varargin{1};
end
fid_8 = fopen(dot8file);
fgets(fid_8);
rho = 1025;
g = 9.8065;
% rho=1025*0.068521/(3.28^3); %slug/ft^3
% g=32.17405; %ft/s^2
rhog = rho*g;
data_8 = fscanf(fid_8, '%f %f %f %i %f %f %f %f', [8 inf]);
fclose all;
periods = unique(data_8(1,:));
directions = unique(data_8(2,:));
for jj = 1:length(directions)
    index_1 = find(data_8(2,:) == directions(jj) & data_8(4,:) == 1);
    index_2 = find(data_8(2,:) == directions(jj) & data_8(4,:) == 2);
    index_6 = find(data_8(2,:) == directions(jj) & data_8(4,:) == 6);
    varname = sprintf('driftforce_%d', directions(jj));
    eval([varname ' = transpose(periods);']);
    eval([varname '(:,2) = rhog .* transpose(data_8(7, index_1));']);   %%%% take column 7 (not 5 !)
    eval([varname '(:,3) = rhog .* transpose(data_8(7, index_2));']);
    eval([varname '(:,7) = rhog .* transpose(data_8(7, index_6));']);
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
WindFloatType.SelectedRAOs = 'QTF';
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
    varname = sprintf('driftforce_%d', directions(jj));
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
    end
    model.SaveData(datfile);
end
end
%clear all