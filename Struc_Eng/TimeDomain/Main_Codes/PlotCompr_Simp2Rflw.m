function[]=PlotCompr_Simp2Rflw(path0, ItrNo, Batch_Simp, Batch_Rflw, AddShear)
%Compare simplified results to time domain results 

%% Part I: General info
path_itr = [path0 ItrNo '\'];
path_rst_simp = [path0 ItrNo '\' Batch_Simp '\'];
path_rst_rflw = [path0 ItrNo '\' Batch_Rflw '\'];

if AddShear
    path_out = [path_rst_simp 'Simp_wShr\'];
    SimpFatig_file = [path_rst_simp 'TmFatigSum_SimpShr_Srot.mat'];
else
    path_out = [path_rst_simp 'Simp\'];
    SimpFatig_file = [path_rst_simp 'TmFatigSum_Simp_Srot.mat'];
end
path_plot = [path_out '\plot\'];
path_comp = [path_out '\comp2_' Batch_Rflw '\'];

%Time domain results, if any
TmFatig_file = [path_rst_rflw '\TmFatigSum_Srot.mat'];

%Connection info
load([path_itr 'CnntInfo.mat']);
if ~strcmp(Cnnt.Itr,ItrNo)
    disp('Connection info does not contain the correct iteration no. Check input')
end

rst_col.x = 2; %Column No. that represents x axis 
rst_col.y = 3; %Column No. that represents y axis
rst_col.z = 4; %Column No. that represents z axis
rst_col.thk = 5; %Column No. for thickness

%% Part IV: Compare results with full time domain rainflow counted results
if ~exist(path_comp,'dir')
    mkdir(path_comp)
end

cd(path_out)
fnames = dir('*.csv');
numfids = length(fnames);

TmRst = load(TmFatig_file);
SimpRst = load(SimpFatig_file);
for n = 1:numfids    
    filename = fnames(n).name;
    
    ind1 = regexp(filename,'_');
    ind2 = regexp(filename,'.csv');
    LineNo = filename(1:ind1(1)-1);
    PartName = filename(ind1(1)+1:ind1(2)-1);
    TorB = filename(ind1(2)+1:ind2(1)-1);
    
    CnntName = filename(1:ind2(1)-1);
    CnntName1 = regexprep(CnntName,'_',' ');
    
    CnntSimpRst = SimpRst.Life.(CnntName);
    
    CnntTmRst = [];
    Nnode_mthd1 = 0;
    Nnode_mthd2 = 0;
    if isfield(TmRst.Life,CnntName)
        if isfield(TmRst.Life.(CnntName),'mthd1')
            CnntTmRst = TmRst.Life.(CnntName).mthd1;
            Nnode_mthd1 = size(CnntTmRst,1);
        end
        if isfield(TmRst.Life.(CnntName),'mthd2')
            CnntTmRst = [CnntTmRst; TmRst.Life.(CnntName).mthd2];
            Nnode_mthd2 = size(CnntTmRst,1);
        end
        if isfield(TmRst.Life.(CnntName),'mthd3')
            CnntTmRst = [CnntTmRst; TmRst.Life.(CnntName).mthd3];
        end
        if isfield(TmRst.Life.(CnntName),'mthd4')
            CnntTmRst = [CnntTmRst; TmRst.Life.(CnntName).mthd4];
        end
    
        if strcmp(Cnnt.(LineNo).group,'circ')
            CirCol = rst_col.(Cnnt.(LineNo).axis);
            CnntTmRst1 = sortrows(CnntTmRst,CirCol);
            CnntSimpRst1 = sortrows(CnntSimpRst,CirCol);
            figure(1)
            plot(CnntSimpRst1(:,CirCol),1./CnntSimpRst1(:,end))
            hold on
            if Nnode_mthd1 > 0
                plot(CnntTmRst1(:,CirCol),1./CnntTmRst1(:,end),'r-*')
            else
                scatter(CnntTmRst1(:,CirCol),1./CnntTmRst1(:,end),'r*')
            end
            legend('Simplified','Rainflow')
            title([CnntName1 ', annual damage, simplified'])
            hold off
            FigName = [path_comp CnntName '.fig'];
            hgsave(FigName)
            close all
        else
            if strcmp(Cnnt.(LineNo).group,'rad')
                axis1 = Cnnt.(LineNo).axis_c;
                axis2 = Cnnt.(LineNo).axis_r;
                Ax1Col = rst_col.(Cnnt.(LineNo).axis_c);
                Ax2Col = rst_col.(Cnnt.(LineNo).axis_r);
            else
                axis1 = Cnnt.(LineNo).axis1;
                axis2 = Cnnt.(LineNo).axis2;
                Ax1Col = rst_col.(Cnnt.(LineNo).axis1);
                Ax2Col = rst_col.(Cnnt.(LineNo).axis2);
            end
            if Nnode_mthd1 > 0 || Nnode_mthd2 > 0
                x_range = max(CnntSimpRst(:,Ax1Col))-min(CnntSimpRst(:,Ax1Col));
                y_range = max(CnntSimpRst(:,Ax2Col))-min(CnntSimpRst(:,Ax2Col));
                
                h1=figure(1);
                h1_1=subplot(1,2,1);
                scatter(CnntSimpRst(:,Ax1Col),CnntSimpRst(:,Ax2Col),50,1./CnntSimpRst(:,end),'filled')
                xlabel([axis1 '(mm/deg)'])
                ylabel([axis2 '(mm)'])
                xlim([min(CnntSimpRst(:,Ax1Col))-0.1*x_range,max(CnntSimpRst(:,Ax1Col))+0.1*x_range]);
                ylim([min(CnntSimpRst(:,Ax2Col))-0.1*y_range,max(CnntSimpRst(:,Ax2Col))+0.1*y_range]);
                title('Annual damage, simplified')
                colorbar
                
                h1_2=subplot(1,2,2);
                scatter(CnntTmRst(:,Ax1Col),CnntTmRst(:,Ax2Col),50,1./CnntTmRst(:,end),'filled')
                xlabel([axis1 '(mm/deg)'])
                ylabel([axis2 '(mm)'])
                xlim([min(CnntSimpRst(:,Ax1Col))-0.1*x_range,max(CnntSimpRst(:,Ax1Col))+0.1*x_range]);
                ylim([min(CnntSimpRst(:,Ax2Col))-0.1*y_range,max(CnntSimpRst(:,Ax2Col))+0.1*y_range]);
                colorbar
                legend(CnntName1)
                title('Annual damage, rainflow counted')
                FigName = [path_comp CnntName '.fig'];
                hgsave(FigName)
                close all
            else
%                 figure(1)
%                 scatter(CnntSimpRst(:,Ax1Col),CnntSimpRst(:,Ax2Col),50,1./CnntSimpRst(:,end),'filled')
%                 
%                 xlabel([Cnnt.(LineNo).axis1 '(mm/deg)'])
%                 ylabel([Cnnt.(LineNo).axis2 '(mm/deg)'])
            end
            
        end    
    end
   
end
end