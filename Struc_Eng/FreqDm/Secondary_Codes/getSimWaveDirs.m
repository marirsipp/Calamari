function [sim_bins,sim_dirs,loc1,loc2] = getSimWaveDirs(Hs1,Hs2,Dir1,Dir2,wave_theta_input,theta0,MetConv)
% This function finds the simulated and non-zero fatigue bins for frequency
% domain fatigue analysis
% Input:
% Hs1 - Hs information of first wave train (size: total no. of bins * 1)
% Hs2 - Hs information of second wave train (size: total no. of bins * 1)
% Dir1 - Wave direction information of first wave train (size: total no. of bins * 1)
% Dir2 - Wave direction information of first wave train (size: total no. of bins * 1)
% wave_theat_input - has fields: simulated (Simulated wave headings); total
%                    (Total wave headings, toward); conv (wave heading 
%                    directional conventions)
% theta0 - platform heading, Convention: TOWARD, CCW
% MetConv - metocean data convention
% Output:
% sim_bins - bins numbers that have been simulated and have non-zero Hs
% sim_dirs - simulated wave headings that have non-zero probabilities
% loc1, loc2 - index of fatigue bin wave heading in simulated wave heading,
% eventually linked to transfer function


NoBin = length(Hs1);
if strcmp(wave_theta_input.conv,'TOWARDS+CCW, rel to platform')
    if strcmp(MetConv, 'TOWARDS+CCW')
        
        %Wave headings input are defined relative to the platform
        wave_theta_total = wave_theta_input.total;
        Head2Cal = wave_theta_input.simulated;
        Wave_theta_int = abs(wave_theta_total(2)-wave_theta_total(1));

        %First wave train
        Dir_Twd1 = mod(Dir1-theta0,360);  %Convert wave direction in fatigue bins to platform relative      
        aa = find(Dir_Twd1>= max(wave_theta_total)+ Wave_theta_int/2); %this is to move directions that are larger than 330 but actually closer to 0deg to be grouped as 0 deg 
        Dir_Twd1(aa)=Dir_Twd1(aa)-360;
        
        %Second wave train
        Dir_Twd2 = mod(Dir2-theta0,360);
        aa = find(Dir_Twd2>= max(wave_theta_total)+ Wave_theta_int/2);
        Dir_Twd2(aa)=Dir_Twd2(aa)-360;
                
    else
        error ('The code is ready to deal with other metocean conventions ;p. Check your directional convention definitions')
    end
else
    error('wave_theta needs to be defined relative to platform, in Orcaflex convention. Check your input file')
end

%Find wave headings with non-zero probability
%First wave train
[bb1 xout1] = hist(Dir_Twd1,wave_theta_total);
mm=find(bb1>0);
wave_theta1 = xout1(mm); 
%Second wave train
[bb2 xout2] = hist(Dir_Twd2,wave_theta_total);
mm2=find(bb2>0);
wave_theta2 = xout2(mm2); 
wave_theta = union(wave_theta1, wave_theta2);

%Find the intersection of simulated wave headings and wave headings
%with non-zero probability
sim_dirs = intersect(wave_theta, Head2Cal);
% if ~issorted(Head2Cal) %Tried to be backward compatible %%Gave up on dealing with it here... too many extra steps
%     sim_dirs = sort(sim_dirs,'descend');
% end
    
%Establish index between bins and stress RAOs based on wave headings
%First wave train
dir_index1 = round( (Dir_Twd1-wave_theta_total(1))/Wave_theta_int ) + 1;
dir_index1(dir_index1==0)=1; %in case a -0.5 is rounded to -1
wave_theta_bin1 = wave_theta_total(dir_index1);
[tf1,loc1] = ismember(wave_theta_bin1,sim_dirs);
%Second wave train
dir_index2 = round( (Dir_Twd2-wave_theta_total(1))/Wave_theta_int ) + 1;
dir_index2(dir_index2==0)=1; %in case a -0.5 is rounded to -1
wave_theta_bin2 = wave_theta_total(dir_index2);
[tf2,loc2] = ismember(wave_theta_bin2,sim_dirs);

Bins = 1:NoBin;
SimBin1 = Bins(tf1); %Bins whose 1st wave train heading is simulated
SimBin2 = Bins(tf2); %Bins whose 2nd wave train heading is simulated
NonzeroBin1 = Bins(Hs1>0); %Bins whose 1st wave train has non-zero Hs/Tp
NonzeroBin2 = Bins(Hs2>0); %Bins whose 2nd wave train has non-zero Hs/Tp
NzSimBin1=intersect(SimBin1,NonzeroBin1);
NzSimBin2=intersect(SimBin2,NonzeroBin2);
sim_bins = union(NzSimBin1,NzSimBin2);
end