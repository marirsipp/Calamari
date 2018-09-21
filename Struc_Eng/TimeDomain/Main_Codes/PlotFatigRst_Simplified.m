function[] = PlotFatigRst_Simplified(path0, ItrNo, strBatch_Simp, AddShear)
%Plot and summarize fatigue life estimation using simplified method, also

%% Part I: General info
path_itr = [path0 ItrNo '\'];
path_rst = [path0 ItrNo '\' strBatch_Simp '\'];
if AddShear
    path_out = [path0 ItrNo '\' strBatch_Simp '\Simp_wShr\'];
else
    path_out = [path0 ItrNo '\' strBatch_Simp '\Simp\'];
end
path_plot = [path_out '\plot\'];

%Connection info
load([path_itr 'CnntInfo.mat']);
if ~strcmp(Cnnt.Itr,ItrNo)
    disp('Connection info does not contain the correct iteration no. Check input')
end

rst_col.x = 2; %Column No. that represents x axis 
rst_col.y = 3; %Column No. that represents y axis
rst_col.z = 4; %Column No. that represents z axis
rst_col.thk = 5; %Column No. for thickness

%% Part II: Plot fatigue damage results
if ~exist(path_plot,'dir')
    mkdir(path_plot)
end

cd(path_out)
fnames = dir('*.csv');
numfids = length(fnames);

for n = 1:numfids
    
    filename = fnames(n).name;
    ind1 = regexp(filename,'_');
    ind2 = regexp(filename,'.csv');
    LineNo = filename(1:ind1(1)-1);
    PartName = filename(ind1(1)+1:ind1(2)-1);
    TorB = filename(ind1(2)+1:ind2(1)-1);
    
    CnntName = filename(1:ind2(1)-1);
    CnntName1 = regexprep(CnntName,'_',' ');
    
    SimpRst = importdata(filename);
    SimpLife = SimpRst.data;
    
    [Nnode, Ncol] = size(SimpLife);
    for k=1:Nnode
        [SimpLife(k,Ncol+1), Mrot_ind] = min(SimpLife(k,5+1:Ncol));
        Mrot_str = SimpRst.textdata{5+Mrot_ind};
        ind = regexp(Mrot_str,'_');
        Mangle(k,1) = str2double(Mrot_str(ind(2)+2:end));
        Sangle(k,1) = str2double(Mrot_str(ind(1)+2:ind(1)+4));
    end
    
    [FatigLife, RowNo] = min(SimpLife(:,end));
    Life.worst.(CnntName) = FatigLife; %record worst fatigue life for current connnection
    Life.WorstLoc.(CnntName) = SimpLife(RowNo,1:rst_col.thk-1); %record worst node location of current connection
    Life.Thickness.(CnntName) = SimpLife(RowNo,rst_col.thk); 
    Life.Mdom.(CnntName) = Mangle(RowNo);
    Life.StrDir.(CnntName) = Sangle(RowNo);
    Life.(CnntName) = SimpLife;
    
    if strcmp(Cnnt.(LineNo).group,'circ')
        CirCol = rst_col.(Cnnt.(LineNo).axis);
        SimpLife_sort = sortrows(SimpLife,CirCol);
        coord = SimpLife_sort(:,CirCol);
        figure(1)
        plot(coord,1./SimpLife_sort(:,end))
        xlabel([Cnnt.(LineNo).axis ' (mm/deg)' ])
        ylabel('Annual fatigue damage')
        title(['Simplified method, all cases, annual damage of ' CnntName1])
        FigName = [path_plot CnntName '.fig'];
        hgsave(FigName)
    elseif strcmp(Cnnt.(LineNo).group,'rad')
        coord1 = SimpLife(:,rst_col.(Cnnt.(LineNo).axis_c));
        coord2 = SimpLife(:,rst_col.(Cnnt.(LineNo).axis_r));
        figure(1)
        scatter(coord1,coord2,50,1./SimpLife(:,end),'filled')
        colorbar
        xlabel([Cnnt.(LineNo).axis_c ' (mm/deg)' ])
        ylabel([Cnnt.(LineNo).axis_r ' (mm)' ])
        title(['Simplified method, all cases, annual damage of ' CnntName1])
        FigName = [path_plot CnntName '.fig'];
        hgsave(FigName)
    elseif strcmp(Cnnt.(LineNo).group,'flat') || strcmp(Cnnt.(LineNo).group,'other')
        coord1 = SimpLife(:,rst_col.(Cnnt.(LineNo).axis1));
        coord2 = SimpLife(:,rst_col.(Cnnt.(LineNo).axis2));
        figure(1)
        scatter(coord1,coord2,50,1./SimpLife(:,end),'filled')
        colorbar
        xlabel([Cnnt.(LineNo).axis1 ' (mm/deg)' ])
        ylabel([Cnnt.(LineNo).axis2 ' (mm)' ])
        title(['Simplified method, all cases, annual damage of ' CnntName1])
        FigName = [path_plot CnntName '.fig'];
        hgsave(FigName)
    end
end

%% Part III: Summarize fatigue damage results
cnames = fieldnames(Life.worst);
CnntNames = sort(cnames);
for n = 1:size(CnntNames,1)
    fatiglife(n,1) = Life.worst.(CnntNames{n});
    thickness(n,1) = Life.Thickness.(CnntNames{n});
    loc(n,:)=Life.WorstLoc.(CnntNames{n});
    if isfield(Life,'StrDir')
        strdir(n,1) = Life.StrDir.(CnntNames{n});
    else
        strdir(n,1) = 360; 
    end
    m_dir(n,1) = Life.Mdom.(CnntNames{n});
end
if AddShear
    outfile = [path_rst 'TmFatigSum_SimpShr_Srot.mat'];
    sumfile = [path_rst 'TmFatigSum_SimpShr_Srot.csv'];
else
    outfile = [path_rst 'TmFatigSum_Simp_Srot.mat'];
    sumfile = [path_rst 'TmFatigSum_Simp_Srot.csv'];
end
save(outfile,'Life','CnntNames','fatiglife','loc','strdir','m_dir')

header = {'CnntName','Thickness(mm)','Life(yr)','theta(deg)','WstLoc_X','WstLoc_Y','WstLoc_Z','Mdir(deg)'};
format1 = ['%8s',',', '%13s',',', '%8s', ',', '%10s', ',', repmat(['%8s',','],1,3), '%9s','\n'];
format2 = ['%16s', ',', '%3.0f', ',', '%6.1f', ',', '%3.0f', ',', repmat(['%6.2f',','],1,3), '%3.0f','\n'];

fid = fopen(sumfile,'w');
fprintf(fid,format1, header{1:end});
for ii=1:size(CnntNames,1)
    fprintf(fid,format2, CnntNames{ii},thickness(ii,1),fatiglife(ii,1), strdir(ii,1), loc(ii,2:4), m_dir(ii,1));
end
fclose(fid);

end
