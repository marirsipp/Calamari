function[] = GenStrDiagram(path0,ItrNo,strBatch,StrChoice, tstep, imat, TBload, TBtran)
%% Generate stress diagram for the worst nodes of one iteration and one load batch
%By Bingbin Yu, Principle Power Inc. May 2017.

%Based on fatigue calculation results, need to run TimeFatigue_AllCnnt_Gen
%and FatigueLifeSummary and generate result summary file:
%TmFatigSum_(StrChoice).mat before running this code

%The summary file include:
%Life - Structure containing all fatigue analysis results
%Cnnt - N-by-1 cell array of all connection names
%fatiglife - N-by-1 array of fatigue lives of all connection
%loc - N-by-4 array of node number and x-y-z location (in local
%      coordinate) of worst nodes of each connection
%strdir - N-by-1 array of worst stress directions of worst nodes of each
%         connection
%wst_mthd - N-by-1 array of worst method for each connection

%% Set up input and output path
% path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
% ItrNo = 'ItrR5_15_20';
% strBatch = 'BatchA_Conv_Bin198';
% StrChoice = 'Srot';
% tstep = 0.2;

path1 = [path0 ItrNo '\' strBatch '\'];

path_str.mthd1 = [path0 ItrNo '\'];
path_str.mthd2 = [path0 ItrNo '\HotSpots\']; %Stress files
path_str.mthd3 = [path0 ItrNo '\Worst\']; %Stress files
path_str.mthd4 = [path0 ItrNo '\Worst_Hsp\']; %Stress files

path_out_orig = [path1 '\PlotStrHist_Orig\' ];
path_out_corr = [path1 '\PlotStrHist_Corr\' ];

if ~exist(path_out_orig,'dir')
    mkdir(path_out_orig)
end
if ~exist(path_out_corr,'dir')
    mkdir(path_out_corr)
end

%% Read in necessary information
%S-N curve info
SNFile = [path0 'SNcurve.mat'];
load(SNFile)

%Connection info
CnntFile = [path0 ItrNo '\CnntInfo.mat'];
CnntInfo = load(CnntFile);
if ~strcmp(CnntInfo.Cnnt.Itr,ItrNo)
    disp('Connection info does not contain the correct iteration no. Check input')
end

%Probability per fatigue bin
if strcmp(prob_adjust,'y')
    file_prob = [path0 strBatch '\' 'prob_adj.mat']; 
else
    file_prob = [path0 strBatch '\' 'prob.mat']; 
end
load(file_prob)

%Load files
file_pwr = [path0 strBatch '\' 'Combine_BB_POWandPAR.mat']; 
file_tran = [path0 strBatch '\' 'Combine_BB_transients.mat']; 
if ~exist('TBload','var')
    TBload = load(file_pwr);
end
if strcmp(include_tran,'y') && ~exist('TBtran','var')
    TBtran = load(file_tran);
end

%Summary file
SumFile = [path1 'TmFatigSum_' StrChoice.name '.mat'];
load(SumFile)

%% Set up useful constants
%Stress histogram setting
str_interval = 1;
str_int = 0:str_interval:1000; %Interval for stress histogram plot
oneyear=24*365.25; %hours

%Stress matrix layout
ThkColN = 5; %Thickness column number
StrColN1 = 6; %Normal stress starting column number
StrColN2 = 23; %Normal stress ending column number

N_cnnt = length(Cnnt); %Total number of connections
RunNames = fieldnames(TBload.vals);
Nrun = length(RunNames);
if strcmp(include_tran,'y')
    RunNames_Tran = fieldnames(TBtran.vals);
    Nrun_Tran = length(RunNames_Tran);
else
    Nrun_Tran = 0;
end

%% Generate stress diagrams per connection
for n=1:N_cnnt
    CnntName = Cnnt{n};
    ind = regexp(CnntName,'_');
    LineNo = CnntName(1:ind(1)-1);
    PartName = CnntName(ind(1)+1:ind(2)-1);
    
    method = wst_mthd{n};
    theta = strdir(n);
    sfname = ['theta' num2str(theta)];
    loc_node = loc(n,2:4);
    
    SNcnnt = SNcurve.(CnntInfo.Cnnt.(LineNo).SN);
    
    strfile = [path_str.(method) CnntName '_StrMtx.csv'];
    rst=importdata(strfile);
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
    row = find(node_all==loc(n,1));
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
    
    Ncycle = zeros(length(str_int),Nrun+Nrun_Tran);
    Ncycle_cr = zeros(length(str_int),Nrun+Nrun_Tran);
    
    for k=1:Nrun
        disp(['Running bin ' num2str(k) ' for ' CnntName])
        run_name = RunNames{k};
        p = prob.(run_name);
        
        M_vst = TBload.vals.(run_name);
        M_wf = [-M_vst(:,2), M_vst(:,1), M_vst(:,3), -M_vst(:,5), M_vst(:,4), M_vst(:,6)];
        Trun = size(M_vst,1)*tstep/3600; % length of run - convert in hours
        str = stress_tmhist(M_wf,StrNm,theta);
        
        [ NCH,NC ] = rainflowdotexe(str.Srot.(sfname));
        Nfull = histc(NC,str_int);
        Nhalf = 0.5*histc(NCH,str_int);
        Ncycle(:,k) = (Nfull+Nhalf)*p*oneyear/Trun;
        
        NC_corr = NC*(Thk/SNcnnt.t_ref)^SNcnnt.kcorr; %Thickness correction
        NCH_corr = NCH*(Thk/SNcnnt.t_ref)^SNcnnt.kcorr;
        Nfull_cr = histc(NC_corr,str_int);
        Nhalf_cr = 0.5*histc(NCH_corr,str_int);
        Ncycle_cr(:,k) = (Nfull_cr+Nhalf_cr)*p*oneyear/Trun;
        
        MaxStr.(CnntName).(run_name)=max([NC_corr;NCH_corr]);
    end
    
    if strcmp(include_tran,'y')
        for k = 1:Nrun_Tran
            disp(['Running tran bin ' num2str(k) ' for ' CnntName])
            run_name = RunNames_Tran{k};
            p = prob.(run_name);
            
            M_vst = TBtran.vals.(run_name);
            M_wf = [-M_vst(:,2), M_vst(:,1), M_vst(:,3), -M_vst(:,5), M_vst(:,4), M_vst(:,6)];
            Trun = size(M_vst,1)*tstep/3600; % length of run - convert in hours
            str = stress_tmhist(M_wf,StrNm,theta);

            [ NCH,NC ] = rainflowdotexe(str.Srot.(sfname));
            Nfull = histc(NC,str_int);
            Nhalf = 0.5*histc(NCH,str_int);
            Ncycle(:,Nrun+k) = (Nfull+Nhalf)*p*oneyear/Trun;

            NC_corr = NC*(Thk/SNcnnt.t_ref)^SNcnnt.kcorr; %Thickness correction
            NCH_corr = NCH*(Thk/SNcnnt.t_ref)^SNcnnt.kcorr;
            Nfull_cr = histc(NC_corr,str_int);
            Nhalf_cr = 0.5*histc(NCH_corr,str_int);
            Ncycle_cr(:,Nrun+k) = (Nfull_cr+Nhalf_cr)*p*oneyear/Trun;
            MaxStr.(CnntName).(run_name)=max([NC_corr;NCH_corr]);
        end
    end
    Nc_total=sum(Ncycle,2);
    Nc_tot_cr = sum(Ncycle_cr,2);
    
    NCycle_total_corr.(CnntName)=Nc_tot_cr;
    
    figure(1)
    bar(str_int(Nc_total>0)+str_interval/2,Nc_total(Nc_total>0))
    xlabel('Stress range, original(MPa)','FontSize',14)
    ylabel('No. of cycles in one year','FontSize',14)
    set(gca,'FontSize',14)
    title(['Stress Diagram of Member ' PartName])%,'FontSize',14)
    figname1 = [path_out_orig CnntName];
    h1=figure(1);
    print(h1,'-dpng',[figname1 '.png'],'-r300')
    hgsave(h1,figname1)
    
    figure(2)
    bar(str_int(Nc_tot_cr>0)+str_interval/2,Nc_tot_cr(Nc_tot_cr>0))
    xlabel('Stress range, thickness corrected(MPa)','FontSize',14)
    ylabel('No. of cycles in one year','FontSize',14)
    set(gca,'FontSize',14)
    title(['Stress Diagram of Member ' PartName])%,'FontSize',14)
    figname2 = [path_out_corr CnntName];
    h2=figure(2);
    print(h2,'-dpng',[figname2 '.png'],'-r300')
    hgsave(h2,figname2)
    
    close all
%     clear rst strNm_all node_all StrNm
end
file_cycle = [path1 'Ncycle_TmFatig_' StrChoice.name '.mat'];
save(file_cycle,'NCycle_total_corr','MaxStr')
end