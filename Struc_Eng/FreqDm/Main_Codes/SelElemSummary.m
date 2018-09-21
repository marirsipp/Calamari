function[Life, Sum1] = SelElemSummary(path_rst, method, SeedNo, plot_rst)
%% Summary of fatigue life results of the pre-screened elements (results 
%from FreqFatig_SelectElem.m) 

%Inputs:
%path_rst - path where the results files are and the summary will be saved
%method - the method used for FreqFatig_SelectElem
%SeedNo - if method 7 is used for FreqFatig_SelectElem, input a array of
%         seed numbers, e.g. SeedNo = 1:6

cd(path_rst)
if method == 7
    for n = SeedNo
        rstfile = ['Life_SelElem_Seed' num2str(n) '.mat'];
        load(rstfile);
        loadfunc=['Rst.Seed' num2str(n) '=GroupResult;'];
        eval(loadfunc);
    end
    FirstSeed = ['Seed' num2str(SeedNo(1))];
    Groups = fieldnames(Rst.(FirstSeed));
    N_grp = length(Groups);
    for ii = 1:N_grp
        GroupName = Groups{ii};
        Cnnts = fieldnames(Rst.(FirstSeed).(GroupName));
        N_cnnt = length(Cnnts);

        for kk = 1:N_cnnt
            CnntName = Cnnts{kk};
            if ~isempty(Rst.(FirstSeed).(GroupName).(CnntName).Top)
                Life.(GroupName).(CnntName).Top(:,1)=Rst.(FirstSeed).(GroupName).(CnntName).Top.Elem;
                Life.(GroupName).(CnntName).Top(:,2:4)=Rst.(FirstSeed).(GroupName).(CnntName).Top.Loc;
                Life.(GroupName).(CnntName).Top(:,5)=Rst.(FirstSeed).(GroupName).(CnntName).Top.Life;
                m=1;
                for nn=SeedNo
                    rstfunc=['Rst.Seed' num2str(nn) '.(GroupName).(CnntName).Top.Life_Mthd7_Seed' num2str(nn)];
                    Life.(GroupName).(CnntName).Top(:,5+m)=eval(rstfunc);
                    m = m+1;
                end
                Life.(GroupName).(CnntName).Top(:,end+1)=1./(mean(1./Life.(GroupName).(CnntName).Top(:,6:end),2));
                [minlife,row] = min(Life.(GroupName).(CnntName).Top(:,end));
                FatigLife.(GroupName).(CnntName).Top = Life.(GroupName).(CnntName).Top(row,[1:5,end]);
            end
            
            if ~isempty(Rst.(FirstSeed).(GroupName).(CnntName).Btm)
                Life.(GroupName).(CnntName).Btm(:,1)=Rst.(FirstSeed).(GroupName).(CnntName).Btm.Elem;
                Life.(GroupName).(CnntName).Btm(:,2:4)=Rst.(FirstSeed).(GroupName).(CnntName).Btm.Loc;
                Life.(GroupName).(CnntName).Btm(:,5)=Rst.(FirstSeed).(GroupName).(CnntName).Btm.Life;
                m=1;
                for nn=SeedNo
                    rstfunc=['Rst.Seed' num2str(nn) '.(GroupName).(CnntName).Btm.Life_Mthd7_Seed' num2str(nn)];
                    Life.(GroupName).(CnntName).Btm(:,5+m)=eval(rstfunc);
                    m = m+1;
                end
                Life.(GroupName).(CnntName).Btm(:,end+1)=1./(mean(1./Life.(GroupName).(CnntName).Btm(:,6:end),2));
                [minlife,row] = min(Life.(GroupName).(CnntName).Btm(:,end));
                FatigLife.(GroupName).(CnntName).Btm = Life.(GroupName).(CnntName).Btm(row,[1:5,end]);
            end            
        end
    end
    
    Sum1 = [];
    Sum1{1,1} = 'Cnnt_Name'; %Result header
    Sum1{1,2} = 'TorB';
    Sum1{1,3} = 'ELemNo'; %Actual thickness of the part
    Sum1{1,4} = 'X(mm)';
    Sum1{1,5} = 'Y(mm)';
    Sum1{1,6} = 'Z(mm)';
    Sum1{1,7} = 'Life_Mthd6';
    Sum1{1,8} = 'Life_Mthd7';
    
    m=2;
    NzGroups = fieldnames(FatigLife);
    for nn=1:length(NzGroups)
        NzCnnts = fieldnames(FatigLife.(NzGroups{nn}));
        for kk=1:length(NzCnnts)
            Sum1{m,1} = NzCnnts{kk};
            TBs = fieldnames(FatigLife.(NzGroups{nn}).(NzCnnts{kk}));
            for ii = 1:length(TBs)
                Sum1{m,2} = TBs{ii};
                Sum1{m,3} = FatigLife.(NzGroups{nn}).(NzCnnts{kk}).(TBs{ii})(1);
                Sum1{m,4} = FatigLife.(NzGroups{nn}).(NzCnnts{kk}).(TBs{ii})(2);
                Sum1{m,5} = FatigLife.(NzGroups{nn}).(NzCnnts{kk}).(TBs{ii})(3);
                Sum1{m,6} = FatigLife.(NzGroups{nn}).(NzCnnts{kk}).(TBs{ii})(4);
                Sum1{m,7} = FatigLife.(NzGroups{nn}).(NzCnnts{kk}).(TBs{ii})(5);
                Sum1{m,8} = FatigLife.(NzGroups{nn}).(NzCnnts{kk}).(TBs{ii})(6);
                m=m+1;
            end
        end
    end
    OutFile = [path_rst '\SelElem_Summary.xls'];
    xlswrite(OutFile,Sum1)
    OutFile1 =  [path_rst '\SelElem_Results.mat'];
    save(OutFile1, 'Life')
    
    if plot_rst
        path_plot = [path_rst '\Plot'];
        if ~exist(path_plot,'dir')
            mkdir(path_plot)
        end
        RstGroups = fieldnames(Life);
        N_rstgrp = length(RstGroups);
        for ii = 1:N_rstgrp
            RstGrpName = RstGroups{ii};
            RstCnnts = fieldnames(Life.(RstGrpName));
            N_RstCnnt = length(RstCnnts);
            for kk = 1:N_RstCnnt
                RstCnntName = RstCnnts{kk};
                RstCnntName1 = regexprep(RstCnntName,'_',' ');
                if isfield(Life.(RstGrpName).(RstCnntName),'Top')
                    LifeRst = Life.(RstGrpName).(RstCnntName).Top;                    
                    figure(1)
                    scatter3(LifeRst(:,2),LifeRst(:,3),LifeRst(:,4),40,1./LifeRst(:,end),'filled')
                    axis equal
                    colorbar
                    title(['Annual fatigue damage, ' RstCnntName1 ', top surface'])
                    FigName = [path_plot '\SelElem_' RstCnntName '_Top.fig'];
                    hgsave(figure(1),FigName)
                end
                if isfield(Life.(RstGrpName).(RstCnntName),'Btm')
                    LifeRst = Life.(RstGrpName).(RstCnntName).Btm;
                    figure(1)
                    scatter3(LifeRst(:,2),LifeRst(:,3),LifeRst(:,4),40,1./LifeRst(:,end),'filled')
                    axis equal
                    colorbar
                    title(['Annual fatigue damage, ' RstCnntName1 ', bottom surface'])
                    FigName = [path_plot '\SelElem_' RstCnntName '_Btm.fig'];
                    hgsave(figure(1),FigName)
                end
            end
        end
    end
end
end