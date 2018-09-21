function [runname_crit,bin_crit,Dmg_crit,DmgPerc_crit,prob_crit,met_crit] = RstStudy_TmDm(path0,ItrNo,strBatch, StrChoice, TBload, tstep, Cnnt2Chk, PlotOpt, OptInput)

%Study time domain fatigue results
%Including load time series, stress time series, DEL etc.

%--------------------------------Input-------------------------------------
% path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
% ItrNo = 'ItrR5_15_2dp3';
% strBatch = 'BatchA_Vestas2'; 

%S-N curve info
SNFile = [path0 'SNcurve.mat'];
load(SNFile)

%Metocean info
MetFile = [path0 strBatch '\Metocean\metocean.mat'];
if exist(MetFile,'file')
    load(MetFile)
end

%Load files
% file_pwr = [path0 strBatch '\' 'Combine_BB_POWandPAR.mat']; 
% file_tran = [path0 strBatch '\' 'Combine_BB_transients.mat']; 
file_prob = [path0 strBatch '\' 'prob.mat']; 
load(file_prob)

path1 = [path0 ItrNo '\' strBatch '\'];

path_str.mthd1 = [path0 ItrNo '\']; %Stress files
path_str.mthd2 = [path0 ItrNo '\HotSpots\']; 
path_str.mthd3 = [path0 ItrNo '\Worst\']; 
path_str.mthd4 = [path0 ItrNo '\Worst_Hsp\']; 

path_rst.mthd1 = [path1 'TmFatigue\' StrChoice.name '\data\']; %Result files
path_rst.mthd2 = [path1 'TmFatigueHsp\' StrChoice.name '\data\']; %Result files
path_rst.mthd3 = [path1 'TmFatigueWst\' StrChoice.name '\data\']; %Result files
path_rst.mthd4 = [path1 'TmFatigueWstHsp\' StrChoice.name '\data\']; %Result files

path_out.mthd1 = [path1 'TmFatigue\' StrChoice.name '\rst\' Cnnt2Chk '\'];
path_out.mthd2 = [path1 'TmFatigueHsp\' StrChoice.name '\rst\' Cnnt2Chk '\'];
path_out.mthd3 = [path1 'TmFatigueWst\' StrChoice.name '\rst\' Cnnt2Chk '\'];
path_out.mthd4 = [path1 'TmFatigueWstHsp\' StrChoice.name '\rst\' Cnnt2Chk '\'];

Cnnt2Chk1 = regexprep(Cnnt2Chk, '_', ' ');

%Stress matrix layout
ThkColN = 5; %Thickness column number
StrColN1 = 6; %Normal stress starting column number
StrColN2 = 23; %Normal stress ending column number

%Load file
file_pwr = [path0 strBatch '\' 'Combine_BB_POWandPAR.mat']; 
if isempty(TBload)
    TBload = load(file_pwr);
end

%Summary file
SumFile = [path1 'TmFatigSum_' StrChoice.name '.mat'];
load(SumFile)

%% For worst node of selected connection
RunNames = fieldnames(TBload.vals);
Nrun = length(RunNames);

method = Life.(Cnnt2Chk).wstmthd;
theta = Life.StrDir.(Cnnt2Chk);
sfname = ['theta' num2str(theta)];

strfile = [path_str.(method) Cnnt2Chk '_StrMtx.csv'];
rst=importdata(strfile);
rstfile1 = [path_rst.(method) 'test_Run12_' Cnnt2Chk '.mat'];
load(rstfile1)

%Locate the worst node in all nodes
mfname = [method 'wst'];
node_wst = Life.(Cnnt2Chk).(mfname)(1,1);
loc_node = Life.(Cnnt2Chk).(mfname)(1,2:4);
life_node = Life.(Cnnt2Chk).(mfname)(1,end);

if isstruct(rst)
    node_all = rst.data(:,1);
    loc_all = rst.data(:,2:4);
    thk_all = rst.data(:,ThkColN);
    StrNm_all = rst.data(:,StrColN1:StrColN2); %Normal stress matrix 
else
    node_all = rst(:,1);
    loc_all = rst(:,2:4);
    thk_all = rst(:,ThkColN);
    StrNm_all = rst(:,StrColN1:StrColN2); %Normal stress matrix 
end
row = find(node_all==node_wst);
if length(row) == 1
    StrNm = StrNm_all(row,:);
    Thk = thk_all(row);
elseif length(row) >1
    r1 = find(loc_all(:,1)==loc_node(1));
    r2 = find(loc_all(:,2)==loc_node(2));
    r3 = find(loc_all(:,3)==loc_node(3));
    row1 = intersect(intersect(r1,r2),r3);
    StrNm = StrNm_all(row1,:);
    Thk = thk_all(row1);
end
    
Dmg_Node = squeeze(DamageS(row,end,:)); %Damage per bin for the worst node
[B ind]=sort(Dmg_Node,'descend');

if isfield(OptInput,'NoCrit')
    bin_crit = ind(1:OptInput.NoCrit);
else
    bin_crit = ind(1:10);
end
runname_crit = RunNames(bin_crit);
Dmg_crit = Dmg_Node(bin_crit);
DmgPerc_crit = Dmg_crit/(1/life_node);

for k = 1:length(bin_crit)
    run_name = runname_crit{k};
    prob_crit(k,1)=prob.(run_name);
    M_vst = TBload.vals.(run_name);
    if isfield(OptInput,'RotLd') && OptInput.RotLd == 1
        M_wf = [-M_vst(:,2), M_vst(:,1), M_vst(:,3), -M_vst(:,5), M_vst(:,4), M_vst(:,6)];
    else
        M_wf = M_vst;
    end
    dmg = Dmg_crit(k);
    dmg_perc = dmg/(1/life_node)*100;
    time = tstep:tstep:tstep*size(M_wf,1);
    
    if exist('metocean','var')
        met_crit(k,1) = metocean.(run_name).Vhub;
        met_crit(k,2) = metocean.(run_name).Wdir;
        met_crit(k,3) = metocean.(run_name).Hs;
        met_crit(k,4) = metocean.(run_name).Tp;
        met_crit(k,5) = metocean.(run_name).WavDir;
        met_crit(k,6) = metocean.(run_name).Hs2;
        met_crit(k,7) = metocean.(run_name).Tp2;
        met_crit(k,8) = metocean.(run_name).WavDir2;
    end
    
    if PlotOpt.SrotByCs == 1
        stress_tmhist_PlotByLdCs(M_wf,StrNm,theta)
        if ~exist(path_out.(method),'dir')
            mkdir(path_out.(method))
        end
        figname1 = [path_out.(method) 'Srot_ByLdCs_' run_name '.fig'];
        title(['Srot time history, ' Cnnt2Chk1 ', Bin ' num2str(bin_crit(k)) ', ' num2str(dmg_perc,'%2.1f') '% of total damage'])
        hgsave(figure(1),figname1)
        close all
    end
    
    if PlotOpt.SdirByCs == 1
        stress_tmhist_PlotByLdCs(M_wf,StrNm)
        if ~exist(path_out.(method),'dir')
            mkdir(path_out.(method))
        end
        figname1 = [path_out.(method) 'Sdir_ByLdCs_' run_name '.fig'];
        h1=subplot(1,3,2);
        title(h1,['Sdir time history, ' Cnnt2Chk1 ', Bin ' num2str(bin_crit(k)) ', ' num2str(dmg_perc,'%2.1f') '% of total damage'])
        hgsave(figure(1),figname1)
        close all
    end
    
    if PlotOpt.Load == 1
        figure(1)
        plot(M_wf(:,4:6),'DisplayName',{'Mx','My','Mz'});
        legend('show')
        title(['TB moment time history, Bin ' num2str(bin_crit(k)) ', ' num2str(dmg_perc,'%2.1f') '% of total damage'])
        figname1 = [path_out.(method) 'TBMmt_' run_name '.fig'];
        hgsave(figure(1),figname1)
        close all
    end
    
    if PlotOpt.LoadSpec == 1
        [f4,Eng_Mx] = SpecDen (time,M_wf(:,4),OptInput.freqavg);
        [f5,Eng_My] = SpecDen (time,M_wf(:,5),OptInput.freqavg);
        [f6,Eng_Mz] = SpecDen (time,M_wf(:,6),OptInput.freqavg);
        
        figure(1)
        subplot(3,1,1)
        plot(f4,Eng_Mx);
        xlim(OptInput.freqzoom)
        xlabel('frequency (Hz)')
        ylabel('Mx SpecDen (kNm^2/Hz)')
        subplot(3,1,2)
        plot(f5,Eng_My);
        xlim(OptInput.freqzoom)
        xlabel('frequency (Hz)')
        ylabel('My SpecDen (kNm^2/Hz)')
        subplot(3,1,3)
        plot(f6,Eng_Mz);
        xlim(OptInput.freqzoom)
        xlabel('frequency (Hz)')
        ylabel('Mz SpecDen (kNm^2/Hz)')
        
        h1=subplot(3,1,1);
        title(h1,['TB moment spectral density, Bin ' num2str(bin_crit(k)) ', ' num2str(dmg_perc,'%2.1f') '% of total damage'])
        figname1 = [path_out.(method) 'TBMmtSpec_' run_name '.fig'];
        hgsave(figure(1),figname1)
        close all
    end
    
    if PlotOpt.RotStr == 1
        theta1 = 0:30:180;
        str = stress_tmhist(M_wf,StrNm,theta1);
        figure(1)
        scatter(str.Srot.theta0,str.Trot.theta0,'.')
        hold on
        scatter(str.Srot.theta30,str.Trot.theta30,'r.')
        scatter(str.Srot.theta60,str.Trot.theta60,'g.')
        scatter(str.Srot.theta90,str.Trot.theta90,'c.')
        scatter(str.Srot.theta120,str.Trot.theta120,'k.')
        scatter(str.Srot.theta150,str.Trot.theta150,'y.')
        scatter(str.Srot.theta180,str.Trot.theta180,'m.')
        axis equal
        legend('theta0','theta30','theta60','theta90','theta120','theta150','theta180')
        xlabel('rotated normal stress (MPa)')
        ylabel('rotated shear stress (MPa)')
        title(['Stress time trajectory, Bin ' num2str(bin_crit(k)) ', ' num2str(dmg_perc,'%2.1f') '% of total damage'])
        figname1 = [path_out.(method) 'RotateStress_' run_name '.fig'];
        hgsave(figure(1),figname1)
        close all
    end
    
    if PlotOpt.DirStr == 1
        str = stress_tmhist(M_wf,StrNm,[]);
        scatter3(str.SY,str.SZ,str.SYZ,'.')
        axis equal
        xlabel('SY (MPa)')
        ylabel('SZ (MPa)')
        zlabel('SYZ (MPa)')
        title(['Directional stress time trajectory, Bin ' num2str(bin_crit(k)) ', ' num2str(dmg_perc,'%2.1f') '% of total damage'])
        figname1 = [path_out.(method) 'DirStress_' run_name '.fig'];
        hgsave(figure(1),figname1)
        close all
    end
    
    if PlotOpt.S1S2 == 1
        str = stress_tmhist(M_wf,StrNm,[]);
        plot(str.S1,'DisplayName','S1')
        hold on
        plot(str.S2,'r','DisplayName','S2')
        plot(str.Smax,'g','DisplayName','Smax')
        legend('show')
        title(['Principle stress time history, Bin ' num2str(bin_crit(k)) ', ' num2str(dmg_perc,'%2.1f') '% of total damage'])
        figname1 = [path_out.(method) 'PrncplStress_' run_name '.fig'];
        hgsave(figure(1),figname1)
        close all
    end
    
    if PlotOpt.SrotTm == 1
        str = stress_tmhist(M_wf,StrNm,theta);
        plot(str.Srot.(sfname),'DisplayName',['Srot\_' sfname])
        hold on
        plot(str.Trot.(sfname),'r','DisplayName',['Trot\_' sfname])
        legend('show')
        title(['Rotated stress time history, Bin ' num2str(bin_crit(k)) ', ' num2str(dmg_perc,'%2.1f') '% of total damage'])
        figname1 = [path_out.(method) 'RorStrTm_' run_name '.fig'];
        hgsave(figure(1),figname1)
        close all
    end
    
    if PlotOpt.SrotByRtMmt == 1
        str_tmhist_PlotRotLoad(M_wf, StrNm, OptInput.Mtheta, theta)
        path_plot=[path_out.(method) '\Mrot_Bin' num2str(bin_crit(k)) '\'];
        SaveAllFig(path_plot)
        close all 
    end
      
end

end
