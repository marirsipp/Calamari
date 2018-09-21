function[Life] = FatigueLifeSummary_Tran(path0, ItrNo, strBatch, StrChoice)
%Calculate total fatigue life using different transient case adjustments
%tran1 - as is
%tran2 - rotate tower base loads 

path_cnnt = [path0 ItrNo '\'];
path_rst = [path0 ItrNo '\' strBatch '\'];

CnntFile = [path_cnnt 'CnntInfo.mat'];
load(CnntFile)

path_rst_mthd.mthd1 = [path_rst 'TmFatigue\' StrChoice '\'];
path_rst_mthd.mthd2 = [path_rst 'TmFatigueHsp\' StrChoice '\'];
path_rst_mthd.mthd3 = [path_rst 'TmFatigueWst\' StrChoice '\'];
path_rst_mthd.mthd4 = [path_rst 'TmFatigueWstHsp\' StrChoice '\'];

Life.iteration = ItrNo;
Life.worst = [];

rst_col.x = 2; %Column No. that represents x axis 
rst_col.y = 3; %Column No. that represents y axis
rst_col.z = 4; %Column No. that represents z axis
rst_col.thk = 5; %Column No. for thickness

for m = 1:4
    method = ['mthd' num2str(m)];
    if exist(path_rst_mthd.(method),'dir')
        cd(path_rst_mthd.(method))
        fnames = dir(['*' StrChoice '.csv']);
        Nrst = length(fnames);
    else
        Nrst = 0;
    end
    
    if Nrst > 0 
        for n = 1:Nrst
            filename = fnames(n).name;
            ind1 = regexp(filename,['_' StrChoice]);
            ind2 = regexp(filename,'_');
            CnntName = filename(1:ind1-1);
            CnntName1 = regexprep(CnntName,'_',' ');
            CnntNo = filename(1:ind2(1)-1);

            rst = importdata(filename);
            Ncol = size(rst.data,2);
            for k=rst_col.thk+1:Ncol
                a =regexp(rst.textdata{1,k},'L');
                b =regexp(rst.textdata{1,k},'(');
                CnntRst.(rst.textdata{1,k}(a(1):b(1)-1))=rst.data(:,k);
            end
            CnntLife.(CnntName).(method) = rst.data(:,1:rst_col.thk);
            CnntLife.(CnntName).(method)(:,rst_col.thk+1) = CnntRst.Life_Pwr;            
            
            file_tran = [CnntName '_' StrChoice '_Tran.csv'];
            if exist(file_tran,'file')
                rst_tran = importdata(file_tran);
                Ncol = size(rst_tran.data,2);
                for k=rst_col.thk+1:Ncol
                    a =regexp(rst_tran.textdata{1,k},'L');
                    b =regexp(rst_tran.textdata{1,k},'(');
                    CnntRst.(rst_tran.textdata{1,k}(a(1):b(1)-1))=rst_tran.data(:,k);
                end
                CnntRst.Life_Tot1 = 1./(1./CnntRst.Life_Pwr+1./CnntRst.Life_Tran1);
                CnntRst.Life_Tot2 = 1./(1./CnntRst.Life_Pwr+1./CnntRst.Life_Tran2);
                CnntLife.(CnntName).(method)(:,rst_col.thk+2) = CnntRst.Life_Tot1; 
                CnntLife.(CnntName).(method)(:,rst_col.thk+3) = CnntRst.Life_Tot2;                
            end
            clear CnntRst
        end
    end    
end

cnames = fieldnames(CnntLife);
Cnnt = sort(cnames);
for n = 1:size(Cnnt,1)
    Mnames = fieldnames(CnntLife.(Cnnt{n}));
    Nmthd = size(Mnames,1);
    for k = 1:Nmthd
        pwr = sortrows(CnntLife.(Cnnt{n}).(Mnames{k}),rst_col.thk+1);
        life_pwr(k,:) = pwr(1,:);
        if size(pwr,2) > rst_col.thk+1
            tot1 = sortrows(CnntLife.(Cnnt{n}).(Mnames{k}),rst_col.thk+2);
            life_tot1(k,:) = tot1(1,:);
            tot2 = sortrows(CnntLife.(Cnnt{n}).(Mnames{k}),rst_col.thk+3);
            life_tot2(k,:) = tot2(1,:);
        end
    end
    
    [l1,r1]=min(life_pwr(:,rst_col.thk+1));
    worst_pwr(n,1) = l1;
    worst_loc_pwr(n,:) = life_pwr(r1,rst_col.x:rst_col.z);
    Life.worst.Pwr.(Cnnt{n})= l1;
    
    if exist('life_tot1','var')
        [l2,r2]=min(life_tot1(:,rst_col.thk+2));
        [l3,r3]=min(life_tot2(:,rst_col.thk+3));
        
        worst_tot1(n,1) = l2;
        worst_loc_tot1(n,:) = life_tot1(r2,rst_col.x:rst_col.z);
        Life.worst.Tot1.(Cnnt{n})= l2;
        worst_tot2(n,1) = l3;
        worst_loc_tot2(n,:) = life_tot2(r3,rst_col.x:rst_col.z);
        Life.worst.Tot2.(Cnnt{n})= l3;
    end
    
    clear life_pwr life_tot1 life_tot2
end
Life.CnntRst = CnntLife;
end