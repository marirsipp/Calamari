%% This code run time domain fatigue damage calculation for all given connections
% Run TmFatig_XX_ipt.m before this code 

%% Input set up
% clc
% close all

%--------------------------------Input-------------------------------------
% path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
% ItrNo = 'ItrR5_15_2dp3';
% strBatch = 'BatchA_Vestas2'; 

%Strfiles selection: method 1 - around connection; method2 - hot spot;
%Method 3 - Worst node around connections; %Method 4 - Worst node from hot
%spot
% method = 1;
% filenum = 18;

%Stress choice - whose time history to be used for rainflow counting
%Options:
%S1or2 - Maximum or minimum principal stress
%Smax  - Choice of S1or2 with larger absolute value at each time instance
%Srot  - Normal stress at rotated surface wrt local coordinate system
%SY/SZ/SYZ - Normal stresses in local coordinate system
%TaoMax - Maximum shear stress
% StrChoice.name = 'Srot';
% StrChoice.theta = 0:30:150;

% tstep = 0.2; %sec
% imat = 2; %load format

%Rainflow path
%path_rainflow = [path0 '\Codes' ];

%S-N curve info
SNFile = [path0 'SNcurve.mat'];
load(SNFile)

%Connection info
CnntFile = [path0 ItrNo '\CnntInfo.mat'];
load(CnntFile)
if ~strcmp(Cnnt.Itr,ItrNo)
    disp('Connection info does not contain the correct iteration no. Check input')
    pause
end

%Load files
loadfile_pwr = [path0 strBatch '\' file_pwr]; 

if strcmp(prob_adjust,'y')
    file_prob = [path0 strBatch '\' 'prob_adj.mat']; 
else
    file_prob = [path0 strBatch '\' 'prob.mat']; 
end

%Method 1 - Around connections
path_str = [path0 ItrNo '\']; %Path for input stress matrix files
cd(path_str)
str_fnames = dir('*_StrMtx.csv');

%Method 2 - Hot spots
path_str_hsp = [path0 ItrNo '\HotSpots\'];
cd(path_str_hsp)
hsp_fnames = dir('*_StrMtx.csv');

%Method 3 - Worst node around connections (from previous iterations)
path_str_wst = [path0 ItrNo '\Worst\']; mkdir(path_str_wst)
cd(path_str_wst)
wst_fnames = dir('*_StrMtx.csv');

%Method 4 - Worst node from hot spot results (from previous iterations)
path_str_wsthsp = [path0 ItrNo '\Worst_Hsp\']; mkdir(path_str_wsthsp)
cd(path_str_wsthsp)
wsthsp_fnames = dir('*_StrMtx.csv');

%Stress matrix layout
ThkColN = 5; %Thickness column number
StrColN1 = 6; %Normal stress starting column number
StrColN2 = 23; %Normal stress ending column numberpui
SNColN = 24; %SN curve info column number
ColNs = [ThkColN,StrColN1,StrColN2,SNColN];

if imat == 2 || imat == 3
    if ~strcmp(StrChoice.name,'Srot')
        header = [{'NodeNo'},{'X(mm)'},{'Y(mm)'},{'Z(mm)'},{'Thk(mm)'},{'Life_Pwr(yr)'},{'Life_Tot(yr)'}];
        format1 = ['%6s',',', repmat(['%5s',','],1,3), '%7s', repmat([',','%12s'],1,2),'\n'];
        format2 = ['%10.0f', repmat([',','%10.3f'],1,3), ',', '%6.1f', repmat([',','%10.3f'],1,2),'\n'];
    else
        Ntheta = length(StrChoice.theta);
        angle=cell(1,Ntheta);
        header = cell(1,5+(Ntheta+1)*2);
        header(1:5) = [{'NodeNo'},{'X(mm)'},{'Y(mm)'},{'Z(mm)'},{'Thk(mm)'}];
        for k = 1:Ntheta
            if StrChoice.theta(k)<10;
                angle{k} = ['00' num2str(StrChoice.theta(k))];
            elseif StrChoice.theta(k)<100;
                angle{k} = ['0' num2str(StrChoice.theta(k))];
            else
                angle{k} = num2str(StrChoice.theta(k));
            end
            header(5+k) = {['Life_' angle{k} '_Pwr(yr)']};
            header(6+Ntheta+k) = {['Life_' angle{k} '_Tot(yr)']};
        end
        header(5+Ntheta+1) = {'Life_Pwr(yr)'};
        header(5+(Ntheta+1)*2) = {'Life_Tot(yr)'};
        format1 = ['%6s',',', repmat(['%5s',','],1,3), '%7s', repmat([',','%18s'],1,Ntheta),',','%12s', repmat([',','%18s'],1,Ntheta),',','%12s','\n'];
        format2 = ['%10.0f', repmat([',','%10.3f'],1,3), ',', '%6.1f', repmat([',','%10.3f'],1,2*(Ntheta+1)),'\n'];
    end
end
%--------------------------------Input-------------------------------------

%% Loads
%Load Tower base loads time series
if imat == 2
    if ~exist('TBloads','var')
        TBloads = load(loadfile_pwr);
        if exist('RotateLoad','var') %Legacy from Vestas loads
            TBloads.rotate = RotateLoad;
        end
    end
    if strcmp(include_tran,'y')
        loadfile_tran = [path0 strBatch '\' file_tran]; 
        TBtran = load(loadfile_tran);
        if exist('RotateLoad','var')
            TBtran.rotate = RotateLoad;
        end
    end
    load(file_prob)
end

%Load Tower base loads time series stored in separate files
if imat == 3
    l = 1;
    vals = [];
    files_loads = dir([path0 strBatch]);
    for i = 1:length(files_loads)
        if isempty(strfind(files_loads(i).name,'.mat')) == 0 % For each mat file in the folder
            Data = load([path0 strBatch '\' files_loads(i).name]);  % Load data
            if isempty(vals) == 1 % Initialisation: 
                %Check if fields are the same than the Loads variables
                for j = 1:length(Loads)
                    if isfield(Data,Loads{j}) == 0
                        disp(['Please check Loads input - ' Loads{j} ' missing'])
                    end
                end
                % Check if the timestep match
                dt = (Data.Time(end)-Data.Time(1))/length(Data.Time);
                if (abs(dt-tstep)/tstep)>1e4 % if more than an 0.01% difference
                    disp(['Time Step in file seems to be ' num2str(dt) 's - Please Check'])
                end
            end   
            tostruct = [];
            for j = 1:length(Loads)
                tostruct = [tostruct , Data.(Loads{j})];
            end
            
            TBloads.vals.(['run' num2str(l,'%.3d')]) = tostruct;
            TBloads.stats.prob.(['run' num2str(l,'%.3d')]) = Data.Info.Stats(2);
            s(l) = Data.Info.Stats(2);
%             if strcmp(include_tran,'n')
%                 k = find(Data.Time<TranTime);
%             end
            l = l+1;
            clear Data
%             files(i).name = files_loads(i).name;
        end
    end
%     prob = []; % Probabilities are directly in the TBloads structure
    prob = TBloads.stats.prob;
    if strcmp(prob_adjust,'y')
        sum_prob = sum(s);
        if sum_prob>1
            for i = 1:l-1
                prob.(['run' num2str(i,'%.3d')]) = prob.(['run' num2str(i,'%.3d')])/sum_prob;
            end
            disp('Probabilities adjusted to a sum equal to 1')
        end
    end
end

% Load - probability QAQC
if imat == 2 || imat == 3
    runnames = fieldnames(TBloads.vals);
    runnames_prob =  fieldnames(prob);
    nruns = length(runnames);
    nruns_prob = length(runnames_prob);
   
    if strcmp(include_tran,'y')
        nruns_tran = length(fieldnames(TBtran.vals));
        if nruns_prob ~= nruns+nruns_tran
            disp('Warning: total no. of runs different in the load file from prob file, check input')
            pause
        end
        for ii = 1:nruns_prob
            prob_test(ii) = prob.(runnames_prob{ii});
        end
    else
        for ii = 1:nruns
            prob_test(ii) = prob.(runnames{ii});
        end
    end
    
    if abs(sum(prob_test)-1) > 1e-3
        disp('Warning: probabilities of all runs do not sum to 1, check input')
        pause
    end
end
%%
if method == 1 %%&& imat ~= 3 
    outpath = [path_str strBatch '\TmFatigue\' StrChoice.name '\']; %output path for fatigue life result files
    files = str_fnames; 
    path_input = path_str;    
elseif method == 2
    outpath = [path_str strBatch '\TmFatigueHsp\' StrChoice.name '\']; 
    files = hsp_fnames;
    path_input = path_str_hsp;
elseif method == 3
    outpath = [path_str strBatch '\TmFatigueWst\' StrChoice.name '\'];
    files = wst_fnames;
    path_input = path_str_wst;
elseif method == 4
    outpath = [path_str strBatch '\TmFatigueWstHsp\' StrChoice.name '\']; 
    files = wsthsp_fnames;
    path_input = path_str_wsthsp;
end

path_data = [outpath 'data\'];
mkdir(path_data);

numfids = length(files);
if exist('filenum','var')
    runfile = filenum;
else
    runfile = 1:numfids;
end

for n = runfile  

    Rst_total = [];
    tstart=tic;
    
    %Connection info
    filename = files(n).name;
    ind = regexp(filename,'_');
    LineNo = filename(1:ind(1)-1);
    PartName = filename(ind(1)+1:ind(2)-1);
    TorB = filename(ind(2)+1:ind(3)-1);
    if method == 2 || method == 4  %Worst hot spot node may not be picked from a previous hot spot selection with the same SN curve as the current selection
        if isfield(Cnnt.(LineNo).(PartName),'HspSN')
            SNname = Cnnt.(LineNo).(PartName).HspSN;
        else
            SNname = Cnnt.(LineNo).SN;
        end
    else
        SNname = Cnnt.(LineNo).SN;
    end    
    SNinfo = SNcurve.(SNname);
    
    strfile = [path_input filename];
    cd(path_data)
    if imat == 2 || imat == 3
        if strcmp(StrChoice.name,'S1or2')
            Rst_pwr = TmFatigS1_or_S2 (tstep,TBloads,prob,strfile,ColNs, SNinfo);
            Rst_total = Rst_pwr;
            if strcmp(include_tran,'y')
                Rst_tran = TmFatigS1_or_S2 (tstep,TBtran,prob,strfile,ColNs, SNinfo);
                Rst_total(:,size(Rst_pwr,2)+1) = 1./(1./Rst_pwr(:,end)+1./Rst_tran(:,end));
            else
                Rst_total(:,size(Rst_pwr,2)+1) = Rst_pwr(:,end);
            end
            
        elseif ~strcmp(StrChoice.name,'Srot')
            Rst_pwr = TmFatigSothers (tstep,TBloads,prob,strfile,ColNs, SNinfo, StrChoice);
            Rst_total = Rst_pwr;
            if strcmp(include_tran,'y')
                Rst_tran = TmFatigSothers (tstep,TBtran,prob,strfile,ColNs, SNinfo, StrChoice);
                Rst_total(:,size(Rst_pwr,2)+1) = 1./(1./Rst_pwr(:,end)+1./Rst_tran(:,end));
            else
                Rst_total(:,size(Rst_pwr,2)+1) = Rst_pwr(:,end);
            end
        else
            Ntheta = length(StrChoice.theta);
            Rst_pwr = TmFatigSothers (tstep,TBloads,prob,strfile,ColNs, SNinfo, StrChoice);
            Rst_total = Rst_pwr;
            if strcmp(include_tran,'y')
                Rst_tran = TmFatigSothers (tstep,TBtran,prob,strfile,ColNs, SNinfo, StrChoice);
                Dmg_pwr = 1./Rst_pwr(:,6:5+Ntheta+1);
                Dmg_tran = 1./Rst_tran(:,6:5+Ntheta+1);
                Rst_total(:,size(Rst_pwr,2)+1:size(header,2)) = 1./(Dmg_pwr+Dmg_tran);
            else
                Rst_total(:,size(Rst_pwr,2)+1:size(header,2)) = Rst_pwr(:,6:5+Ntheta+1);
            end
                        
        end

        Nnode = size(Rst_total,1);
        % Save data in a csv file
        OutputName = [outpath, LineNo,'_',PartName,'_',TorB,'_', StrChoice.name,'.csv'];
        sheetName = [LineNo,'_',PartName,'_',TorB,'_', StrChoice.name,'.csv'];
        fid = fopen(OutputName,'w');
        fprintf(fid,format1, header{1:end});
        for i=1:Nnode
            fprintf(fid,format2, Rst_total(i,:));
        end
        fclose(fid);
        % Issue with printing format in csv file: save data in a mat file
        fileout = [outpath, LineNo,'_',PartName,'_',TorB,'_', StrChoice.name,'.mat'];
        DataOut.textdata = header;
        DataOut.data = Rst_total;
        save(fileout,'-struct','DataOut')
    end
    telapsed=toc(tstart);
    disp(['It took ' num2str(telapsed) 's for running ' LineNo '_',PartName,'_',TorB])
end

