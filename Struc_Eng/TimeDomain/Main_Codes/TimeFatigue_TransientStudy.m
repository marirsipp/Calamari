% clc
% clear all
% close all

%--------------------------------Input-------------------------------------
% path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
% ItrNo = 'ItrR5_15_2dp3';
% strBatch = 'BatchA_Vestas2'; 

%Strfiles selection: method 1 - around connection; method2 - hot spot;
%Method 3 - Worst node around connections; %Method 4 - Worst node from hot
%spot
% method = 4;
% filenum = [4,23,35];

%Stress choice - whose time history to be used for rainflow counting
%Options:
%S1or2 - Maximum or minimum principal stress
%Smax  - Choice of S1or2 with larger absolute value at each time instance
%Srot  - Normal stress at rotated surface wrt local coordinate system
%SY/SZ/SYZ - Normal stresses in local coordinate system
%TaoMax - Maximum shear stress
% StrChoice.name = 'Srot';
% StrChoice.theta = [60,90]; %0:30:150;

%Information regarding wind direction distribution
DirInfo.phi0 = 300; %Vestas transient cases wind/wave direction
DirInfo.phi = 35:30:365;
DirInfo.dir_prob = [0.182	0.075	0.029	0.029	0.060	0.094	0.120	0.082	0.058	0.052	0.066	0.153]; %Based on Bin 10311

% tstep = 0.2; %sec
% imat = 2; %load format
%%
%Rainflow path
% path_rainflow = [path0 '\Codes' ];

%S-N curve info
SNFile = [path0 'SNcurve.mat'];
load(SNFile)

%Connection info
CnntFile = [path0 ItrNo '\CnntInfo.mat'];
load(CnntFile)
if ~strcmp(Cnnt.Itr,ItrNo)
    disp('Connection info does not contain the correct iteration no. Check input')
end

%Load files
file_tran = [path0 strBatch '\' 'Combine_BB_transients.mat'];  
if strcmp(prob_adjust,'y')
    file_prob = [path0 strBatch '\' 'prob_adj.mat'];
else
    file_prob = [path0 strBatch '\' 'prob.mat'];
end

%Method 1 - Around connections
path_str = [path0 ItrNo '\'];
cd(path_str)
str_fnames = dir('*_StrMtx.csv');

%Method 2 - Hot spots
path_str_hsp = [path0 ItrNo '\HotSpots\'];
cd(path_str_hsp)
hsp_fnames = dir('*_StrMtx.csv');

%Method 3 - Worst node around connections (from previous iterations)
path_str_wst = [path0 ItrNo '\Worst\'];
cd(path_str_wst)
wst_fnames = dir('*_StrMtx.csv');

%Method 4 - Worst node from hot spot results (from previous iterations)
path_str_wsthsp = [path0 ItrNo '\Worst_Hsp\'];
cd(path_str_wsthsp)
wsthsp_fnames = dir('*_StrMtx.csv');

%Stress matrix layout
ThkColN = 5; %Thickness column number
StrColN1 = 6; %Normal stress starting column number
StrColN2 = 23; %Normal stress ending column numberpui
SNColN = 24; %SN curve info column number
ColNs = [ThkColN,StrColN1,StrColN2,SNColN];

if imat == 2
    if ~strcmp(StrChoice.name,'Srot')
        header = [{'NodeNo'},{'X(mm)'},{'Y(mm)'},{'Z(mm)'},{'Thk(mm)'},{'Life_Tran1(yr)'},{'Life_Tran2(yr)'}];
        format1 = ['%6s',',', repmat(['%5s',','],1,3), '%7s', repmat([',','%14s'],1,2),'\n'];
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
            header(5+k) = {['Life_' angle{k} '_Tran1(yr)']};
            header(6+Ntheta+k) = {['Life_' angle{k} '_Tran2(yr)']};
        end
        header(5+Ntheta+1) = {'Life_Tran1(yr)'};
        header(5+(Ntheta+1)*2) = {'Life_Tran2(yr)'};
        format1 = ['%6s',',', repmat(['%5s',','],1,3), '%7s', repmat([',','%18s'],1,Ntheta),',','%14s', repmat([',','%18s'],1,Ntheta),',','%14s','\n'];
        format2 = ['%10.0f', repmat([',','%10.3f'],1,3), ',', '%6.1f', repmat([',','%10.3f'],1,2*(Ntheta+1)),'\n'];
    end
end
%--------------------------------Input-------------------------------------
%%
%Load Tower base loads time series
if imat == 2
    TBtran = load(file_tran);
    load(file_prob)
end

if method == 1
    outpath = [path_str strBatch '\TmFatigue\' StrChoice.name];
    files = str_fnames;
    path_input = path_str;
elseif method == 2
    outpath = [path_str strBatch '\TmFatigueHsp\' StrChoice.name]; 
    files = hsp_fnames;
    path_input = path_str_hsp;
elseif method == 3
    outpath = [path_str strBatch '\TmFatigueWst\' StrChoice.name];
    files = wst_fnames;
    path_input = path_str_wst;
elseif method == 4
    outpath = [path_str strBatch '\TmFatigueWstHsp\' StrChoice.name]; 
    files = wsthsp_fnames;
    path_input = path_str_wsthsp;
end

path_data = [outpath '\data\'];
mkdir(path_data);
cd(path_data)

numfids = length(files);

if exist('filenum','var')
    runfile = filenum;
else
    runfile = 1:numfids;
end

for n = runfile %1:numfids 

    Rst_total = [];

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
%     cd(path_rainflow)
    if imat == 2
        if strcmp(StrChoice.name,'S1or2')
            Rst_tran = TmFatigS1or2_Vestas (tstep,TBtran,prob,strfile,ColNs, SNinfo);
            Rst_total = Rst_tran;
        elseif ~strcmp(StrChoice.name,'Srot')
            Rst_tran1 = TmFatigSothers_Vestas (tstep,TBtran,prob,strfile,ColNs, SNinfo, StrChoice);
            Rst_tran2 = TmFatigSothers_VestasTransient (tstep,TBtran,prob,strfile,ColNs, SNinfo, StrChoice, DirInfo);
            Rst_total = Rst_tran1;
            Rst_total(:,size(Rst_tran1,2)+1) = Rst_tran2(:,end);
        else
            Rst_tran1 = TmFatigSothers_Vestas (tstep,TBtran,prob,strfile,ColNs, SNinfo, StrChoice);
            Rst_tran2 = TmFatigSothers_VestasTransient (tstep,TBtran,prob,strfile,ColNs, SNinfo, StrChoice, DirInfo);
            Rst_total = Rst_tran1;
            Rst_total(:,size(Rst_tran1,2)+1:size(header,2)) = Rst_tran2(:,6:5+Ntheta+1);
        end

        Nnode = size(Rst_total,1);
        OutputName = [outpath '\',LineNo,'_',PartName,'_',TorB,'_', StrChoice.name,'_Tran.csv'];
        fid = fopen(OutputName,'w');
        fprintf(fid,format1, header{1:end});
        for i=1:Nnode
            fprintf(fid,format2, Rst_total(i,:));
        end
        fclose(fid);
    end
end
