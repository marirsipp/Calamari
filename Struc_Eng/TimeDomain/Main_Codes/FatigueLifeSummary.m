function[Life] = FatigueLifeSummary(path0, ItrNo, strBatch, StrChoice)
%This function summarize fatigue life calculation results

path_cnnt = [path0 ItrNo '\'];
path_rst = [path0 ItrNo '\' strBatch '\'];

CnntFile = [path_cnnt 'CnntInfo.mat'];
load(CnntFile)

path_rst_mthd1 = [path_rst 'TmFatigue\' StrChoice '\'];
path_rst_mthd2 = [path_rst 'TmFatigueHsp\' StrChoice '\'];
path_rst_mthd3 = [path_rst 'TmFatigueWst\' StrChoice '\'];
path_rst_mthd4 = [path_rst 'TmFatigueWstHsp\' StrChoice '\'];

Life.iteration = ItrNo;
Life.worst = [];

rst_col.x = 2; %Column No. that represents x axis 
rst_col.y = 3; %Column No. that represents y axis
rst_col.z = 4; %Column No. that represents z axis
rst_col.thk = 5; %Column No. for thickness

%% Method 1 - along connection

if exist(path_rst_mthd1,'dir')
    cd(path_rst_mthd1)
    fnames = dir('*.csv');
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
        [FatigLife RowNo] = min(rst.data(:,end));
        Life.worst.(CnntName) = FatigLife; %record worst fatigue life for current connnection
        Life.WorstLoc.(CnntName) = rst.data(RowNo,1:rst_col.thk-1); %record worst node location of current connection
        Life.Thickness.(CnntName) = rst.data(RowNo,rst_col.thk); %record thickness of the part at the worst node 
        Life.(CnntName).mthd1 = rst.data;
        Life.(CnntName).mthd1wst = rst.data(RowNo,:);
        Life.(CnntName).wstmthd = 'mthd1';

        path_plot = [path_rst_mthd1 'plot\'];
        mkdir(path_plot)
        if strcmp(StrChoice, 'Srot')
            Ntheta = (size(rst.data,2)-rst_col.thk - 2)/2; %total no. of stress directions calculated
            for k = 1:Ntheta
                text{k}=['theta\_' rst.textdata{rst_col.thk+k}(8:10)];
            end
            [a,ind]=min(rst.data(RowNo,rst_col.thk+1:rst_col.thk+Ntheta));
            Life.StrDir.(CnntName)=str2double(rst.textdata{rst_col.thk+ind}(8:10)); %record principal stress direction
            
            if strcmp(Cnnt.(CnntNo).group,'circ')
                coord = rst.data(:,rst_col.(Cnnt.(CnntNo).axis));
                figure(1)
                plot(coord,1./rst.data(:,rst_col.thk+1:rst_col.thk+Ntheta))
                legend(text{1:Ntheta})
                xlabel([Cnnt.(CnntNo).axis ' (mm/deg)' ])
                ylabel('Annual fatigue damage')
                title(['PwrProd case, annual damage of ' CnntName1 ',' StrChoice])
                FigName = [path_plot CnntName '_Pwr.fig'];
                hgsave(FigName)
            elseif strcmp(Cnnt.(CnntNo).group,'rad')
                coord1 = rst.data(:,rst_col.(Cnnt.(CnntNo).axis_c));
                coord2 = rst.data(:,rst_col.(Cnnt.(CnntNo).axis_r));
                figure(1)
                scatter(coord1,coord2,50,1./rst.data(:,rst_col.thk+Ntheta+1),'filled')
                colorbar
                xlabel([Cnnt.(CnntNo).axis_c ' (mm/deg)' ])
                ylabel([Cnnt.(CnntNo).axis_r ' (mm)' ])
                title(['PwrProd case, annual damage of ' CnntName1 ',' StrChoice])
                FigName = [path_plot CnntName '_Pwr.fig'];
                hgsave(FigName)
            elseif strcmp(Cnnt.(CnntNo).group,'flat') || strcmp(Cnnt.(CnntNo).group,'other')
                coord1 = rst.data(:,rst_col.(Cnnt.(CnntNo).axis1));
                coord2 = rst.data(:,rst_col.(Cnnt.(CnntNo).axis2));
                figure(1)
                scatter(coord1,coord2,50,1./rst.data(:,rst_col.thk+Ntheta+1),'filled')
                colorbar
                xlabel([Cnnt.(CnntNo).axis1 ' (mm/deg)' ])
                ylabel([Cnnt.(CnntNo).axis2 ' (mm)' ])
                title(['PwrProd case, annual damage of ' CnntName1 ',' StrChoice])
                FigName = [path_plot CnntName '_Pwr.fig'];
                hgsave(FigName)
            end
        else   %if strcmp(StrChoice,'Smax')
            if strcmp(Cnnt.(CnntNo).group,'circ')
                coord = rst.data(:,rst_col.(Cnnt.(CnntNo).axis));
                figure(1)
                plot(coord,1./rst.data(:,rst_col.thk+1))
                xlabel([Cnnt.(CnntNo).axis ' (mm/deg)' ])
                ylabel('Annual fatigue damage')
                title(['PwrProd case, annual damage of ' CnntName1 ',' StrChoice])
                FigName = [path_plot CnntName '_Pwr.fig'];
                hgsave(FigName)
            elseif strcmp(Cnnt.(CnntNo).group,'rad')
                coord1 = rst.data(:,rst_col.(Cnnt.(CnntNo).axis_c));
                coord2 = rst.data(:,rst_col.(Cnnt.(CnntNo).axis_r));
                figure(1)
                scatter(coord1,coord2,50,1./rst.data(:,rst_col.thk+1),'filled')
                colorbar
                xlabel([Cnnt.(CnntNo).axis_c ' (mm/deg)' ])
                ylabel([Cnnt.(CnntNo).axis_r ' (mm)' ])
                title(['PwrProd case, annual damage of ' CnntName1 ',' StrChoice])
                FigName = [path_plot CnntName '_Pwr.fig'];
                hgsave(FigName)
            elseif strcmp(Cnnt.(CnntNo).group,'flat') || strcmp(Cnnt.(CnntNo).group,'other')
                coord1 = rst.data(:,rst_col.(Cnnt.(CnntNo).axis1));
                coord2 = rst.data(:,rst_col.(Cnnt.(CnntNo).axis2));
                figure(1)
                scatter(coord1,coord2,50,1./rst.data(:,rst_col.thk+1),'filled')
                colorbar
                xlabel([Cnnt.(CnntNo).axis1 ' (mm/deg)' ])
                ylabel([Cnnt.(CnntNo).axis2 ' (mm)' ])
                title(['PwrProd case, annual damage of ' CnntName1 ',' StrChoice])
                FigName = [path_plot CnntName '_Pwr.fig'];
                hgsave(FigName)
            end
        end
    end
    close all
end
%% Method 2 - hot spots
if exist(path_rst_mthd2,'dir')
    cd(path_rst_mthd2)
    fnames = dir('*.csv');
    Nrst = length(fnames);
else
    Nrst = 0;
end

if Nrst >0
    for n = 1:Nrst
        filename = fnames(n).name;
        ind1 = regexp(filename,['_' StrChoice]);
        ind2 = regexp(filename,'_');
        CnntName = filename(1:ind1-1);
        CnntName1 = regexprep(CnntName,'_',' ');
        CnntNo = filename(1:ind2(1)-1);

        rst = importdata(filename);
        [FatigLife RowNo] = min(rst.data(:,end));
        if ~isfield(Life.worst,CnntName)
            Life.worst.(CnntName) = FatigLife;
            Life.(CnntName).wstmthd = 'mthd2';
            Life.WorstLoc.(CnntName) = rst.data(RowNo,1:rst_col.thk-1);
            Life.Thickness.(CnntName) = rst.data(RowNo,rst_col.thk);
            if strcmp(StrChoice, 'Srot')
                Ntheta = (size(rst.data,2)-rst_col.thk - 2)/2;
                [a,ind]=min(rst.data(RowNo,rst_col.thk+1:rst_col.thk+Ntheta));
                Life.StrDir.(CnntName)=str2double(rst.textdata{rst_col.thk+ind}(8:10)); %record principal stress direction
            end
        elseif Life.worst.(CnntName) > FatigLife
            Life.worst.(CnntName) = FatigLife;
            Life.(CnntName).wstmthd = 'mthd2';
            Life.WorstLoc.(CnntName) = rst.data(RowNo,1:rst_col.thk-1);
            Life.Thickness.(CnntName) = rst.data(RowNo,rst_col.thk);
            if strcmp(StrChoice, 'Srot')
                Ntheta = (size(rst.data,2)-rst_col.thk - 2)/2;
                [a,ind]=min(rst.data(RowNo,rst_col.thk+1:rst_col.thk+Ntheta));
                Life.StrDir.(CnntName)=str2double(rst.textdata{rst_col.thk+ind}(8:10)); %record principal stress direction
            end
        end
        Life.(CnntName).mthd2 = rst.data;
        Life.(CnntName).mthd2wst = rst.data(RowNo,:);
        
        path_plot = [path_rst_mthd2 'plot\'];
        mkdir(path_plot)
        if strcmp(StrChoice,'Srot')
            Ntheta = (size(rst.data,2)-rst_col.thk - 2)/2;
            for k = 1:Ntheta
                text{k}=['theta\_' rst.textdata{rst_col.thk+k}(8:10)];
            end
            if strcmp(Cnnt.(CnntNo).group,'circ')
                coord = rst.data(:,rst_col.(Cnnt.(CnntNo).axis));
                figure(1)
                plot(coord,1./rst.data(:,rst_col.thk+1:rst_col.thk+Ntheta))
                legend(text{1:Ntheta})
                xlabel([Cnnt.(CnntNo).axis ' (mm/deg)' ])
                ylabel('Annual fatigue damage')
                title(['PwrProd case, annual damage of ' CnntName1 ',' StrChoice])
                FigName = [path_plot CnntName '_Pwr.fig'];
                hgsave(FigName)
            else
                if strcmp(Cnnt.(CnntNo).group,'rad')
                    coord1 = rst.data(:,rst_col.(Cnnt.(CnntNo).axis_c));
                    coord2 = rst.data(:,rst_col.(Cnnt.(CnntNo).axis_r));
                    xname = [Cnnt.(CnntNo).axis_c ' (mm/deg)' ];
                    yname = [Cnnt.(CnntNo).axis_r ' (mm)' ];
                elseif strcmp(Cnnt.(CnntNo).group,'flat') || strcmp(Cnnt.(CnntNo).group,'other')
                    coord1 = rst.data(:,rst_col.(Cnnt.(CnntNo).axis1));
                    coord2 = rst.data(:,rst_col.(Cnnt.(CnntNo).axis2));
                    xname = [Cnnt.(CnntNo).axis1 ' (mm/deg)' ];
                    yname = [Cnnt.(CnntNo).axis2 ' (mm)' ];
                end
                figure(1)
                scatter(coord1,coord2,50,1./rst.data(:,rst_col.thk+Ntheta+1),'filled')
                colorbar
                xlabel(xname)
                ylabel(yname)
                title(['PwrProd case, annual damage of ' CnntName1 ',' StrChoice])
                FigName = [path_plot CnntName '_Pwr.fig'];
                hgsave(FigName)                
            end
        else
        end
    end
end
%% Method 3 - worst node from previous iterations' method 1 results
if exist(path_rst_mthd3,'dir')
    cd(path_rst_mthd3)
    fnames = dir('*.csv');
    Nrst = length(fnames);
else
    Nrst = 0;
end

if Nrst >0
    for n = 1:Nrst
        filename = fnames(n).name;
        ind1 = regexp(filename,['_' StrChoice]);
        ind2 = regexp(filename,'_');
        CnntName = filename(1:ind1-1);
        CnntName1 = regexprep(CnntName,'_',' ');
        CnntNo = filename(1:ind2(1)-1);

        rst = importdata(filename);
        [FatigLife RowNo] = min(rst.data(:,end));
        if ~isfield(Life.worst,CnntName)
            Life.worst.(CnntName) = FatigLife;
            Life.(CnntName).wstmthd = 'mthd3';
            Life.WorstLoc.(CnntName) = rst.data(RowNo,1:rst_col.thk-1);
            Life.Thickness.(CnntName) = rst.data(RowNo,rst_col.thk);
            if strcmp(StrChoice, 'Srot')
                Ntheta = (size(rst.data,2)-rst_col.thk - 2)/2;
                [a,ind]=min(rst.data(RowNo,rst_col.thk+1:rst_col.thk+Ntheta));
                Life.StrDir.(CnntName)=str2double(rst.textdata{rst_col.thk+ind}(8:10)); %record principal stress direction
            end
        elseif Life.worst.(CnntName) > FatigLife
            Life.worst.(CnntName) = FatigLife;
            Life.(CnntName).wstmthd = 'mthd3';
            Life.WorstLoc.(CnntName) = rst.data(RowNo,1:rst_col.thk-1);
            Life.Thickness.(CnntName) = rst.data(RowNo,rst_col.thk);
            if strcmp(StrChoice, 'Srot')
                Ntheta = (size(rst.data,2)-rst_col.thk - 2)/2;
                [a,ind]=min(rst.data(RowNo,rst_col.thk+1:rst_col.thk+Ntheta));
                Life.StrDir.(CnntName)=str2double(rst.textdata{rst_col.thk+ind}(8:10)); %record principal stress direction
            end
        end
        Life.(CnntName).mthd3 = rst.data;
        Life.(CnntName).mthd3wst = rst.data;
        Life.(CnntName).worst.mthd3 = rst.data(1,end);

        path_plot = [path_rst_mthd3 'plot\'];
        mkdir(path_plot)
        if strcmp(StrChoice, 'Srot')
            Ntheta = (size(rst.data,2)-rst_col.thk - 2)/2;
            theta = [];
            for k = 1:Ntheta
                theta(k)=str2double(rst.textdata{rst_col.thk+k}(8:10));
            end
            figure(1)
            bar(theta,1./[rst.data(1,rst_col.thk+1:rst_col.thk+Ntheta);rst.data(1,rst_col.thk+Ntheta+2:rst_col.thk+2*Ntheta+1)]')
            xlabel('Stress direction (deg)')
            ylabel('Annual fatigue damage')
            legend('Pwr','Total')
            title(['Annual damage of ' CnntName1 ',' StrChoice])
            FigName = [path_plot CnntName '.fig'];
            hgsave(FigName)
        end    
    end
    close all
end
%% Method 4 - worst hot spots from previous iterations' method 2 results
if exist(path_rst_mthd4,'dir')
    cd(path_rst_mthd4)
    fnames = dir('*.csv');
    Nrst = length(fnames);
else
    Nrst = 0;
end

if Nrst >0
    for n = 1:Nrst
        filename = fnames(n).name;
        ind1 = regexp(filename,['_' StrChoice]);
        ind2 = regexp(filename,'_');
        CnntName = filename(1:ind1-1);
        CnntName1 = regexprep(CnntName,'_',' ');
        CnntNo = filename(1:ind2(1)-1);

        rst = importdata(filename);
        [FatigLife RowNo] = min(rst.data(:,end));
        if ~isfield(Life.worst,CnntName)
            Life.worst.(CnntName) = FatigLife;
            Life.(CnntName).wstmthd = 'mthd4';
            Life.WorstLoc.(CnntName) = rst.data(RowNo,1:rst_col.thk-1);
            Life.Thickness.(CnntName) = rst.data(RowNo,rst_col.thk);
            if strcmp(StrChoice, 'Srot')
                Ntheta = (size(rst.data,2)-rst_col.thk - 2)/2;
                [a,ind]=min(rst.data(RowNo,rst_col.thk+1:rst_col.thk+Ntheta));
                Life.StrDir.(CnntName)=str2double(rst.textdata{rst_col.thk+ind}(8:10)); %record principal stress direction
            end
        elseif Life.worst.(CnntName) > FatigLife
            Life.worst.(CnntName) = FatigLife;
            Life.(CnntName).wstmthd = 'mthd4';
            Life.WorstLoc.(CnntName) = rst.data(RowNo,1:rst_col.thk-1);
            Life.Thickness.(CnntName) = rst.data(RowNo,rst_col.thk);
            if strcmp(StrChoice, 'Srot')
                Ntheta = (size(rst.data,2)-rst_col.thk - 2)/2;
                [a,ind]=min(rst.data(RowNo,rst_col.thk+1:rst_col.thk+Ntheta));
                Life.StrDir.(CnntName)=str2double(rst.textdata{rst_col.thk+ind}(8:10)); %record principal stress direction
            end
        end

        Life.(CnntName).mthd4 = rst.data;
        Life.(CnntName).mthd4wst = rst.data;
        Life.(CnntName).worst.mthd4 = rst.data(1,end);

        path_plot = [path_rst_mthd4 'plot\'];
        mkdir(path_plot)
        if strcmp(StrChoice, 'Srot')
            %Ntheta = (size(rst.data,2)-rst_col.thk - 2)/2;
            theta = [];
            for k = 1:Ntheta
                theta(k)=str2double(rst.textdata{rst_col.thk+k}(8:10));
            end
            figure(1)
            bar(theta,1./[rst.data(1,rst_col.thk+1:rst_col.thk+Ntheta);rst.data(1,rst_col.thk+Ntheta+2:rst_col.thk+2*Ntheta+1)]')
            xlabel('Stress direction (deg)')
            ylabel('Annual fatigue damage')
            legend('Pwr','Total')
            title(['Annual damage of ' CnntName1 ',' StrChoice])
            FigName = [path_plot CnntName '.fig'];
            hgsave(FigName)
        end    
    end
    close all
end

%% Output
cnames = fieldnames(Life.worst);
Cnnt = sort(cnames);
for n = 1:size(Cnnt,1)
    fatiglife(n,1) = Life.worst.(Cnnt{n});
    thickness(n,1) = Life.Thickness.(Cnnt{n});
    loc(n,:)=Life.WorstLoc.(Cnnt{n});
    if isfield(Life,'StrDir')
        strdir(n,1) = Life.StrDir.(Cnnt{n});
    else
        strdir(n,1) = 360; 
    end
    wst_mthd{n,1} = Life.(Cnnt{n}).wstmthd;
end

outfile = [path_rst 'TmFatigSum_' StrChoice '.mat'];
save(outfile,'Life','Cnnt','fatiglife','loc','strdir','wst_mthd')

sumfile = [path_rst 'TmFatigSum_' StrChoice '.csv'];
header = {'CnntName','Thickness(mm)','Life(yr)','theta(deg)','WstLoc_X','WstLoc_Y','WstLoc_Z','WstMthd'};
format1 = ['%8s',',', '%13s',',', '%8s', ',', '%10s', ',', repmat(['%8s',','],1,3), '%7s','\n'];
format2 = ['%16s', ',', '%3.0f', ',', '%6.1f', ',', '%3.0f', ',', repmat(['%6.2f',','],1,3), '%6s','\n'];

fid = fopen(sumfile,'w');
fprintf(fid,format1, header{1:end});
for i=1:size(Cnnt,1)
    fprintf(fid,format2, Cnnt{i},thickness(i,1),fatiglife(i,1), strdir(i,1), loc(i,2:4), wst_mthd{i,1});
end
fclose(fid);
end