function [] = Plot_CnntElem_FatigueResult(path0,iteration,result,Method,PlotRAO,PlotSpec)
%Plot connection element fatigue results, including
%Stress RAO per direction
%Stress spectrum for bins/sea states with large damage

%Input:
%path0 - general path (e.g. 'C:\Users\Ansys.000\Documents\MATLAB\FreqDomain\')
%iteration - iteration info, including fields:
%          - name: iteration name (e.g. Itr13_10)
%          - theta0: platform orientation (angle of platform north from
%          global north) (340 degree for WFA model)
%result  - results to plot, including fields:
%        - group (e.g. Truss_CG1)
%        - surf (Top or Btm)
%Method  - Method used for calculating fatigue damage, including fields:
%        - No, method number
%        - Bin, total number of bins used for method 3 or 4
%PlotRAO - Whether to plot stress RAO
%PlotSpec - Whether to plot stress Spectrum

%Method used for calculating fatigue damage
%__Analysis Method 1:
%Damage_method_ABS = fatigue life (years) calc using ABS Fatigue Assesment
%of Offshore Structures 2003 and wave scatter diagram

%__Analysis Method 2:
%Damage = fatigue life (years) calc using Rainflow-Counting of simulated
%seastate time series determined from parameters listed in wave scatter diagram

%__Analysis Method 3:
%Damage_method_ABS = fatigue life (years) calc using ABS Fatigue Assesment
%and recorded environmental Hs/Tp/Wave Direction statistics 

%__Analysis Method 4:
%Damage = fatigue life (years) calc using Rainflow-Counting and recorded
%environmental Hs/Tp/Wave Direction statistics (slow analysis method)

Itr = iteration.name;
Itr1 =  regexprep(Itr, '_', ' ');
theta0 = iteration.theta0;

%Method
method = Method.No;
if ismember(method,[3 4 5 6 7])
    BinNo = Method.Bin;
end

%Plot Group results
GroupName = result.group;
TorB = result.surf;
path1 = [path0 Itr '\Results_Mthd' num2str(method) '\' GroupName '\'];
% path1 = [path0 Itr '\Results\' GroupName '\'];

if method == 1 || method == 2
    PartResultFile = [path1 'ElemResult_' TorB '_Method' num2str(method) '.mat' ]; 
elseif ismember(method,[3 4 5 6 7])
    PartResultFile = [path1 'ElemResult_' TorB '_Method' num2str(method) '_Bin' num2str(BinNo) '.mat' ]; 
end

load(PartResultFile);
NoElem = size(ElemRst,2);

%%
%Plot stress RAO
if PlotRAO
    if ismember(method,[3 4 5 6 7]) %Only works for output format of method 3&4 for now
        HeadNo = length(ElemRst{1}.Heading);
        for k=1:HeadNo
            TextHeading{k} = ['Heading ' num2str(theta0-ElemRst{1}.Heading(k))];
        end

        %Plot stress RAO per connection per heading
        path2 = [path1 'StrRAO\' TorB '\'];
        if ~exist(path2,'dir')
            mkdir(path2)
        end
        for n = 1:NoElem
            RAO_raw = ElemRst{n}.StrRAO;
            RAO = (reshape(RAO_raw,[],HeadNo))';

            if HeadNo <= 4
                figure(1)
                plot(ElemRst{n}.Period,RAO(1:end,:),'-o')
                legend( TextHeading(1:end) )
                xlabel('Wave period (s)')
                ylabel('Principle stress (MPa)')
                title( [Itr1 ', ' ElemRst{n}.CnntName] )
                FigureFile1 = [path2 ElemRst{n}.CnntName '_1.fig'];
                hgsave(FigureFile1)            
            elseif HeadNo <= 8
                LineNo = ceil(HeadNo/2);

                figure(1)
                plot(ElemRst{n}.Period,RAO(1:LineNo,:),'-o')
                legend( TextHeading(1:LineNo) )
                xlabel('Wave period (s)')
                ylabel('Principle stress (MPa)')
                title( [Itr1 ', ' ElemRst{n}.CnntName] )
                FigureFile1 = [path2 ElemRst{n}.CnntName '_1.fig'];
                hgsave(FigureFile1)

                figure(2)
                plot(ElemRst{n}.Period,RAO(LineNo+1:end,:),'-o')
                legend( TextHeading(LineNo+1:end) )
                xlabel('Wave period (s)')
                ylabel('Principle stress (MPa)')
                title( [Itr1 ', ' ElemRst{n}.CnntName] )
                FigureFile2 = [path2 ElemRst{n}.CnntName '_2.fig'];
                hgsave(FigureFile2)
            else
                LineNo = ceil(HeadNo/3);

                figure(1)
                plot(ElemRst{n}.Period,RAO(1:LineNo,:),'-o')
                legend( TextHeading(1:LineNo) )
                xlabel('Wave period (s)')
                ylabel('Principle stress (MPa)')
                title( [Itr1 ', ' ElemRst{n}.CnntName] )
                FigureFile1 = [path2 ElemRst{n}.CnntName '_1.fig'];
                hgsave(FigureFile1)

                figure(2)
                plot(ElemRst{n}.Period,RAO(LineNo+1:2*LineNo,:),'-o')
                legend( TextHeading(LineNo+1:2*LineNo) )
                xlabel('Wave period (s)')
                ylabel('Principle stress (MPa)')
                title( [Itr1 ', ' ElemRst{n}.CnntName] )
                FigureFile2 = [path2 ElemRst{n}.CnntName '_2.fig'];
                hgsave(FigureFile2)

                figure(3)
                plot(ElemRst{n}.Period,RAO(2*LineNo+1:end,:),'-o')
                legend( TextHeading(2*LineNo+1:end) )
                xlabel('Wave period (s)')
                ylabel('Principle stress (MPa)')
                title( [Itr1 ', ' ElemRst{n}.CnntName] )
                FigureFile3 = [path2 ElemRst{n}.CnntName '_3.fig'];
                hgsave(FigureFile3)            
            end
        end
        close all
    end
end

%%
%Find the sea states with largest damage, and plot stress spectrum of those
%sea states/bins
if PlotSpec
    if method == 1 || method == 2 %Not validated for method 1&2 yet
      
        path3 = [path1 'StrSpec\' TorB '\'];
        if ~exist(path3,'dir')
            mkdir(path3)
        end
        
        %Hs/Tp combinations considered (size of wave scatter diagram)
        Hs = ElemRst{1}.Hs;
        Tp = ElemRst{1}.Tp;
        PercentRef = Method.Perc; %Search for sea states with larger than PercentRef (e.g. 2%) of  the total damage
        
        %Simulated wave headings
        HeadingStart = 3; %Starting column of the wave heading simulated
        HeadingEnd = size(ElemRst{1}.Heading,2);

        for n = 1:NoElem
            for p = HeadingStart:HeadingEnd
                DmgPerc = ElemRst{n}.DmgPerSea(:,:,p)/(1/ElemRst{n}.TotalLife);
                [row,col] = find(DmgPerc >= PercentRef);
                if isempty(row) %if no bin has damage larger than criteria
                    DmgBig(n,p)=0;
                else
                    ind = sub2ind(size(DmgPerc),row,col);
                    DmgBig(n,p)= sum( DmgPerc(ind) );
                    NoBin = length(ind);
                    aa = ElemRst{n}.StrSpc(:,:,ind,p);
                    StrSpec = reshape(aa,[],NoBin)';
                    plot(ElemRst{n}.Period,StrSpec)
                    for i = 1:NoBin
                        LineLable{i}= [ 'Hs ' num2str(Hs(col(i))) 'm, Tp ' num2str(Tp(row(i))) 's, Dmg ' num2str(100*(DmgPerc(ind(i))),3) '%' ];
                    end
                    legend(LineLable)
                    LineLable=[];
                    xlabel('Wave period (s)')
                    ylabel('Stress energy per unit frequency (MPa^2/Hz)')
                    title([ElemRst{n}.CnntName ' Heading ' num2str(theta0-ElemRst{n}.Heading(p)) 'deg relative to platform'])
                    FigureFile3 = [path3 ElemRst{n}.CnntName '_Heading' num2str(theta0-ElemRst{n}.Heading(p)) '.fig'];
                    hgsave(FigureFile3)
                end        
            end
        end
    elseif ismember(method,[3 4 5 6 7])
        path4 = [path1 'StrSpec\Bin' num2str(BinNo) '\'];
        if ~exist(path4,'dir')
            mkdir(path4)
        end
        PercentRef = 0.05; %Search for sea states with larger than PercentRef (e.g. 2%) of  the total damage

        for n = 1:NoElem

            DmgPerc = ElemRst{n}.DmgPerBin(:,:)/(1/ElemRst{n}.TotalLife);
            col = find(DmgPerc >= PercentRef);
            if isempty(col) %if no bin has damage larger than criteria
                DmgBig(n)=0;
            else
                DmgBig(n)= sum( DmgPerc(col) );
                NoBigBin = length(col);
                aa = ElemRst{n}.StrSpc(:,:,col);
                StrSpec = reshape(aa,[],NoBigBin)';
                if method == 7
                    plot(ElemRst{n}.Period(1:end-1),StrSpec)
                else
                    plot(ElemRst{n}.Period,StrSpec)
                end                
                for i = 1:NoBigBin
                    LineLabel{i}= [ 'Bin No. ' num2str(col(i)) ', Dmg ' num2str(100*(DmgPerc(col(i))),3) '%' ];
                end
                legend(LineLabel)
                LineLabel=[];
                xlabel('Wave period (s)')
                ylabel('Stress energy per unit frequency (MPa^2/Hz)')
                title([ElemRst{n}.CnntName ' ' TorB ', damage due to large bins: ' num2str(100*(DmgBig(n)),3) '%'])
                FigureFile3 = [path4 ElemRst{n}.CnntName '_' TorB '.fig'];
                hgsave(FigureFile3)
            end        

        end
    end
    close all
end
end