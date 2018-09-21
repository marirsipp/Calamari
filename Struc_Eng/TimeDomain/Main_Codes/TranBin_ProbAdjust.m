%Adjust fatigue bins probability for Vestas power production and transient
%bins to have total 100% 
%Methodology check: Vestas_TransientBin_Study.xlsx
%\\Shark\Bingbin\Documents\Fatigue assessment\@WFP WFA\WFA\Time Domain\New model\Bin\Vestas

prob_file_orig = [path0 strBatch '\prob.mat' ];
prob_file_adj = [path0 strBatch '\prob_adj.mat'];
list_file = [path0 strBatch '\TranBin_Adjust\Run12_ProbAdjust.xlsx'];
TBload_tran = [path0 strBatch '\Combine_BB_transients.mat'];

% tab_name = {'Vspd04';'Vspd10';'Vspd12';'Vspd23';'Vspd25'};
tab_name = {'Vspd04';'Vspd07';'Vspd10';'Vspd12';'Vspd14';'Vspd23';'Vspd25'};
Ntab = size(tab_name,1);

TBtran = load(TBload_tran);
tran_case = fieldnames(TBtran.vals);
Ntran = size(tran_case,1);

prob_orig = load(prob_file_orig);
tot_case = fieldnames(prob_orig.prob);
Ntot = size(tot_case,1);
%%
for m = 1:Ntran
    p.(tran_case{m}) = prob_orig.prob.(tran_case{m})/2;
end
%%
for n = 1:Ntab
    [num,txt]=xlsread(list_file,tab_name{n});
    Nrun = length(num);
    for k = 1:Nrun
        run_name = ['Run' txt{k+1,1} '_PPI'];
        p.(run_name)=num(k);
    end
    clear num txt
end
%%
case_adj = fieldnames(p);
Nadj = size(case_adj,1);
prob = prob_orig.prob;

for n = 1:Nadj
    prob.(case_adj{n})=p.(case_adj{n});
end

%%
for n = 1:Ntot
    p_check(1,n)=prob_orig.prob.(tot_case{n});
    p_check(2,n)=prob.(tot_case{n});
end

save(prob_file_adj,'prob');