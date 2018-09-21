function[runname_crit,Dmg_crit,Dmg_vdir,prob_crit] = RstStudy_TmDmTran(path0,ItrNo,strBatch,Cnnt, HspChoice, StrChoice, Vsprd, dmg1, TBtran)

%Study time domain fatigue results
%For different adjustment 

%Metocean info
% MetFile = [path0 strBatch '\Metocean\metocean.mat'];
% load(MetFile)

if HspChoice == 1
%     path_str = [path0 ItrNo '\']; %Stress files
    path_rst = [path0 ItrNo '\' strBatch '\TmFatigue\' StrChoice '\data\']; %Result files
%     path_out = [path0 ItrNo '\' strBatch '\TmFatigue\' StrChoice '\rst\' Cnnt '\']; %Output files
elseif HspChoice == 2
%     path_str = [path0 ItrNo '\HotSpots\']; %Stress files
    path_rst = [path0 ItrNo '\' strBatch '\TmFatigueHsp\' StrChoice '\data\']; %Result files
%     path_out = [path0 ItrNo '\' strBatch '\TmFatigueHsp\' StrChoice '\rst\' Cnnt '\']; %Output files
elseif HspChoice == 3
%     path_str = [path0 ItrNo '\Worst\']; %Stress files
    path_rst = [path0 ItrNo '\' strBatch '\TmFatigue_Worst\' StrChoice '\data\']; %Result files
%     path_out = [path0 ItrNo '\' strBatch '\TmFatigue_Worst\' StrChoice '\rst\' Cnnt '\']; %Output files
elseif HspChoice == 4
%     path_str = [path0 ItrNo '\Worst_Hsp\']; %Stress files
    path_rst = [path0 ItrNo '\' strBatch '\TmFatigueWstHsp\' StrChoice '\data\']; %Result files
%     path_out = [path0 ItrNo '\' strBatch '\TmFatigueWstHsp\' StrChoice '\rst\' Cnnt '\']; %Output files
end

Cnnt1 = regexprep(Cnnt,'_',' ');
if strcmp(Vsprd,'y') %if the tower base loads are rotated according to wind directionsd
    rstfile1 = [path_rst 'test_dirsprd_Run24_' Cnnt '.mat']; 
end

if HspChoice == 1 || HspChoice == 2
else
    load(rstfile1) 
    names = fieldnames(TBtran.vals);
    Nrun = size(names,1);
    if strcmp(StrChoice,'S1or2')
%         run_crit = find(DamageS1or2>dmg1);
%         runname_crit = names(run_crit);
%         Dmg_crit = [DamageS1or2(run_crit)',DamageS1(run_crit)',DamageS2(run_crit)'];
    elseif ~strcmp(StrChoice,'Srot')
%         run_crit = find(DamageS>dmg1);
%         runname_crit = names(run_crit);
%         Dmg_crit = [DamageS1or2(run_crit)',DamageS1(run_crit)',DamageS2(run_crit)'];
    else
        Colmax = size(DamageS,2);       
        D1 = DamageS(:,Colmax,:);
        Dmax = reshape(D1,Nrun,1);
        run_crit = find(Dmax>dmg1);
        runname_crit = names(run_crit);
        prob_crit=p_test(run_crit)';
        
        if strcmp(Vsprd,'y')
            D2 = DamageS(:,1:Colmax-1,run_crit);
            [m,ind] = max(D2,[],2);
            ind1 = reshape(ind,[1 size(run_crit,1)]);
            Dmg_crit=Dmax(run_crit);
            Nvdir = size(DamageS_vdir,3);
            for n=1:length(run_crit)
                D3 = DamageS_vdir(:,ind1(n),:,run_crit(n));
                Dmg_vdir(n,:)=reshape(D3,[1 Nvdir]);
            end
        else
            D2 = DamageS(:,:,run_crit);
            Dmg_crit = reshape(D2,Colmax,size(run_crit,1))';
        end
    end
end
end