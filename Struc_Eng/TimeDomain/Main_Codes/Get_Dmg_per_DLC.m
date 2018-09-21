%Break down the total fatigue damage by DLCs

%% Set up input and output path
% path0 ='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\'; 
% ItrNo = 'ItrR5_15_20';
% strBatch = 'BatchA_Conv_Bin198';
% StrChoice = 'Srot';
% tstep = 0.2;
path1 = [path0 ItrNo '\' strBatch '\'];

path_rst.mthd1 = [path1 'TmFatigue'];
path_rst.mthd2 = [path1 'TmFatigueHsp\']; %Stress files
path_rst.mthd3 = [path1 'TmFatigueWst\']; %Stress files
path_rst.mthd4 = [path1 'TmFatigueWstHsp\']; %Stress files

%Summary file
SumFile = [path1 'TmFatigSum_' StrChoice.name '.mat'];
load(SumFile)

%%
DLC_ind.BatchA_Vestas3_adj_Tran.Run12 = 1:9734;
DLC_ind.BatchA_Vestas3_adj_Tran.Run64 = 9735:10311;
DLC_ind.BatchA_Vestas3_adj_Tran.Run24 = 1:720;
DLC_ind.BatchA_Vestas3_adj_Tran.Run31 = 721:936;
DLC_ind.BatchA_Vestas3_adj_Tran.Run41 = 937:1368;
DLC_ind.BatchA_Vestas3_adj_Tran.Run51 = 1369:5184;
DLC_ind.BatchA_Vestas3_adj_Tran.Run84 = 5185:5256;

N_cnnt = length(Cnnt); %Total number of connections

for n=1:N_cnnt
    CnntName = Cnnt{n};
    ind = regexp(CnntName,'_');
    LineNo = CnntName(1:ind(1)-1);
    PartName = CnntName(ind(1)+1:ind(2)-1);
    method = wst_mthd{n};
    
    rstfile1 = [path_rst.(method) '\' StrChoice.name '\data\test_Run12_' CnntName '.mat'];
    rstfile2 = [path_rst.(method) '\' StrChoice.name '\data\test_Run24_' CnntName '.mat'];
    
    DmgRst_pwr = load(rstfile1);
    DmgRst_tran = load(rstfile2);
    
    if size(DmgRst_pwr.DamageS,1) ~= 1
        life_file = [path_rst.(method) StrChoice.name '\' CnntName '_' StrChoice.name '.csv'];
        life_rst = importdata(life_file);
        loc_node = loc(n,2:4);
        if isstruct(life_rst)
            loc_all = life_rst.data(:,2:4);
        else
            loc_all = life_rst(:,2:4);
        end
        r1 = find(loc_all(:,1)==loc_node(1));
        r2 = find(loc_all(:,2)==loc_node(2));
        r3 = find(loc_all(:,3)==loc_node(3));
        row1 = intersect(intersect(r1,r2),r3);
    else
        row1 = 1;
    end
    
    dmg(n,1) = sum(DmgRst_pwr.DamageS(row1,end,DLC_ind.(strBatch).Run12),3);
    dmg(n,2) = sum(DmgRst_pwr.DamageS(row1,end,DLC_ind.(strBatch).Run64),3);
    dmg(n,3) = sum(DmgRst_tran.DamageS(row1,end,DLC_ind.(strBatch).Run24),3);
    dmg(n,4) = sum(DmgRst_tran.DamageS(row1,end,DLC_ind.(strBatch).Run31),3);
    dmg(n,5) = sum(DmgRst_tran.DamageS(row1,end,DLC_ind.(strBatch).Run41),3);
    dmg(n,6) = sum(DmgRst_tran.DamageS(row1,end,DLC_ind.(strBatch).Run51),3);
    dmg(n,7) = sum(DmgRst_tran.DamageS(row1,end,DLC_ind.(strBatch).Run84),3);
    
end
