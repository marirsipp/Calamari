clc
% clear all

%Compare principle stress results of different boundary conditions

%General input
path0 = 'D:\Bingbin\Documents\Fatigue assessment\@WFP WFA\WFA\FreqDomain\BCstudy';

%Boundary condition
BCname = {'BtmSpring','IRF','EF','CntrSpring','WLSpring'};

%Group results 
Group = {'ISbtm','OSbtm','LMBcol','LMBmid'};
Heading = 240;
Periods = [6,9,12,15];

%Unit of the output
unit_L = 'm';
unit_S = 'Pa';
%----------------Platform geometry factors---------------------------------
%Geometry parameters, in m
Ctr_Col1 = [30.426, 0, -18.000];
Ctr_Col2 = [-15.214, 26.350, -18.000];
Ctr_Col3 = [-15.214, -26.350, -18.000];

ColSpace = 52.700;

Z_Keel = -18.000; %Measured from free surface
EL_Top = 29.000;
EL_PlfmBtm = 6.000;
EL_LMBbtm = 0.800;
EL_UMBtop = 28.500;

R_IS_C1 = 3.250;
R_IS_C2 = 2.250;
R_OS_C1 = 6.000;
R_OS_C2 = 5.750;
R_LMB = 1.100;
R_UMB = 9.00;

L_LMBmidcan = 10.000; %Approximate number
L_LMBcolcan = 8.000; %Approximate number
L_UMBcolcan = 10.000; %Approximate number
L_VBcolcan = 9.500; %Approximate number
L_VBmidcan = 3.900; %Approximate number

L_VBtotal = sqrt((EL_UMBtop-R_UMB-EL_LMBbtm-R_LMB)^2 + (ColSpace/2)^2);
L_VB = 23.367;
L_VBcolcan1 = 9.5447; %Exact number
L_VBmidcan1 = L_VBtotal-L_VB-L_VBcolcan1; %Exact number

XBound = [40.238, 0, -25.026]; %Maximum x value of the model, platform center, minimum x value
YBound = [37.680, 0, -37.680]; %Maximum y value of the platform, platform center, minimum y value
ZBound = [12.000, 0, -18.000]; %Maximum z value of the platform, platform center, minimum z value

TrussCtr_Col1 = [Ctr_Col1(1), Ctr_Col1(2), Z_Keel+EL_UMBtop-R_UMB];
TrussCtr_Col2 = [Ctr_Col2(1), Ctr_Col2(2), Z_Keel+EL_UMBtop-R_UMB];
TrussCtr_Col3 = [Ctr_Col3(1), Ctr_Col3(2), Z_Keel+EL_UMBtop-R_UMB];

KJnt12_Ctr = 0.5*(Ctr_Col1 + Ctr_Col2) + [0,0, EL_LMBbtm + R_LMB];
KJnt13_Ctr = 0.5*(Ctr_Col1 + Ctr_Col3) + [0,0, EL_LMBbtm + R_LMB];
KJnt23_Ctr = 0.5*(Ctr_Col2 + Ctr_Col3) + [0,0, EL_LMBbtm + R_LMB];

DotSize = 50;
tolerance = 0.030;
%--------------------------------------------------------------------------

%%
% IS results
% GroupNo = 1;
% PartName = {'ISbtmCol1','ISbtmCol2','ISbtmCol3'};
% for n = 1:size(BCname,2)
%     path1 = [path0 '\' BCname{n} '\'];
%     path2 = [path1 Group{GroupNo} '\'];
%     for m = 1:size(Periods,2)
%        File_real = [path1 'ElemStr_' Group{GroupNo} '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_real.csv' ]; 
%        StrData_real = importdata(File_real);
%        
%        Data_col1 = sort_xval(StrData_real.data,XBound(2),XBound(1));
%        part = PartName{1}; %'ISbtm_Col1';
%        MaxStr_real.(part).(BCname{n})(m,1:2)=max(Data_col1(:,5:6));
%        MaxStr_real.(part).(BCname{n})(m,3:4)=min(Data_col1(:,7:8));
%        
%        FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Top_real.fig'];
%        figure(1)
%        scatter3(Data_col1(:,2),Data_col1(:,3),Data_col1(:,4),50,Data_col1(:,5),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Top\_real - ' BCname{n}]);
%        hgsave(FigFileS1)
%        
%        FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Top_real.fig'];
%        figure(2)
%        scatter3(Data_col1(:,2),Data_col1(:,3),Data_col1(:,4),50,Data_col1(:,7),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Top\_real - ' BCname{n}]);
%        hgsave(FigFileS3)
%        
%        Data_c2c3 = sort_xval(StrData_real.data,XBound(3),XBound(2));
%        Data_col2 = sort_yval(Data_c2c3,YBound(2),YBound(1));
%        part = PartName{2}; %'ISbtm_Col2';
%        MaxStr_real.(part).(BCname{n})(m,1:2)=max(Data_col2(:,5:6));
%        MaxStr_real.(part).(BCname{n})(m,3:4)=min(Data_col2(:,7:8));
%        
%        FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Top_real.fig'];
%        figure(1)
%        scatter3(Data_col2(:,2),Data_col2(:,3),Data_col2(:,4),50,Data_col2(:,5),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Top\_real - ' BCname{n}]);
%        hgsave(FigFileS1)
%        
%        FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Top_real.fig'];
%        figure(2)
%        scatter3(Data_col2(:,2),Data_col2(:,3),Data_col2(:,4),50,Data_col2(:,7),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Top\_real - ' BCname{n}]);
%        hgsave(FigFileS3)
%        
%        Data_col3 = sort_yval(Data_c2c3,YBound(3),YBound(2));
%        part = PartName{3}; %'ISbtm_Col3';
%        MaxStr_real.(part).(BCname{n})(m,1:2)=max(Data_col3(:,5:6));
%        MaxStr_real.(part).(BCname{n})(m,3:4)=min(Data_col3(:,7:8));
%        
%        FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Top_real.fig'];
%        figure(1)
%        scatter3(Data_col3(:,2),Data_col3(:,3),Data_col3(:,4),50,Data_col3(:,5),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Top\_real - ' BCname{n}]);
%        hgsave(FigFileS1)
%        
%        FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Top_real.fig'];
%        figure(2)
%        scatter3(Data_col3(:,2),Data_col3(:,3),Data_col3(:,4),50,Data_col3(:,7),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Top\_real - ' BCname{n}]);
%        hgsave(FigFileS3)
%        
%        clear StrData_real Data_col1 Data_c2c3 Data_col2 Data_col3
%        
%        File_imag = [path1 'ElemStr_' Group{GroupNo} '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_imag.csv' ]; 
%        StrData_imag = importdata(File_imag);
%        
%        Data_col1 = sort_xval(StrData_imag.data,XBound(2),XBound(1));
%        part = PartName{1}; %'ISbtm_Col1';
%        MaxStr_imag.(part).(BCname{n})(m,1:2)=max(Data_col1(:,5:6));
%        MaxStr_imag.(part).(BCname{n})(m,3:4)=min(Data_col1(:,7:8));
%        
%        FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Top_imag.fig'];
%        figure(1)
%        scatter3(Data_col1(:,2),Data_col1(:,3),Data_col1(:,4),50,Data_col1(:,5),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Top\_imag - ' BCname{n}]);
%        hgsave(FigFileS1)
%        
%        FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Top_imag.fig'];
%        figure(2)
%        scatter3(Data_col1(:,2),Data_col1(:,3),Data_col1(:,4),50,Data_col1(:,7),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Top\_imag - ' BCname{n}]);
%        hgsave(FigFileS3)
%        
%        Data_c2c3 = sort_xval(StrData_imag.data,XBound(3),XBound(2));
%        Data_col2 = sort_yval(Data_c2c3,YBound(2),YBound(1));
%        part = PartName{2}; %'ISbtm_Col2';
%        MaxStr_imag.(part).(BCname{n})(m,1:2)=max(Data_col2(:,5:6));
%        MaxStr_imag.(part).(BCname{n})(m,3:4)=min(Data_col2(:,7:8));
%        
%        FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Top_imag.fig'];
%        figure(1)
%        scatter3(Data_col2(:,2),Data_col2(:,3),Data_col2(:,4),50,Data_col2(:,5),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Top\_imag - ' BCname{n}]);
%        hgsave(FigFileS1)
%        
%        FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Top_imag.fig'];
%        figure(2)
%        scatter3(Data_col2(:,2),Data_col2(:,3),Data_col2(:,4),50,Data_col2(:,7),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Top\_imag - ' BCname{n}]);
%        hgsave(FigFileS3)
%        
%        Data_col3 = sort_yval(Data_c2c3,YBound(3),YBound(2));
%        part = PartName{3}; %'ISbtm_Col3';
%        MaxStr_imag.(part).(BCname{n})(m,1:2)=max(Data_col3(:,5:6));
%        MaxStr_imag.(part).(BCname{n})(m,3:4)=min(Data_col3(:,7:8));
%        
%        FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Top_imag.fig'];
%        figure(1)
%        scatter3(Data_col3(:,2),Data_col3(:,3),Data_col3(:,4),50,Data_col3(:,5),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Top\_imag - ' BCname{n}]);
%        hgsave(FigFileS1)
%        
%        FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Top_imag.fig'];
%        figure(2)
%        scatter3(Data_col3(:,2),Data_col3(:,3),Data_col3(:,4),50,Data_col3(:,7),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Top\_imag - ' BCname{n}]);
%        hgsave(FigFileS3)
%        
%        clear StrData_imag Data_col1 Data_c2c3 Data_col2 Data_col3
%     end    
% end

%%
%Plot comparison of boundary conditions
% for m = 1:size(PartName,2)
%     
%     for n = 1:size(BCname,2)
%         S1top_real(n,:) = (MaxStr_real.(PartName{m}).(BCname{n})(:,1))';
%         S1top_imag(n,:) = (MaxStr_imag.(PartName{m}).(BCname{n})(:,1))';
%         S3top_real(n,:) = (MaxStr_real.(PartName{m}).(BCname{n})(:,3))';
%         S3top_imag(n,:) = (MaxStr_imag.(PartName{m}).(BCname{n})(:,3))';
%     end
%     
%     figure(1)
%     plot(Periods,S1top_real);
%     legend(BCname)
%     xlabel('Wave period (s)')
%     ylabel('S1 (MPa)')
%     title([PartName{m} ' Top S1 Real'])
%     FigureFile1 = [path0 '\' PartName{m} '_S1Top_Real.fig'];
%     hgsave(FigureFile1)
%     
%     figure(2)
%     plot(Periods,S1top_imag);
%     legend(BCname)
%     xlabel('Wave period (s)')
%     ylabel('S1 (MPa)')
%     title([PartName{m} ' Top S1 Imag'])
%     FigureFile2 = [path0 '\' PartName{m} '_S1Top_Imag.fig'];
%     hgsave(FigureFile2)
%     
%     figure(3)
%     plot(Periods,S3top_real);
%     legend(BCname)
%     xlabel('Wave period (s)')
%     ylabel('S3 (MPa)')
%     title([PartName{m} ' Top S3 Real'])
%     FigureFile3 = [path0 '\' PartName{m} '_S3Top_Real.fig'];
%     hgsave(FigureFile3)
%     
%     figure(4)
%     plot(Periods,S3top_imag);
%     legend(BCname)
%     xlabel('Wave period (s)')
%     ylabel('S3 (MPa)')
%     title([PartName{m} ' Top S3 Imag'])
%     FigureFile4 = [path0 '\' PartName{m} '_S3Top_Imag.fig'];
%     hgsave(FigureFile4)
% end
%%
%LMB column can results
% GroupNo = 3;
% PartName = {'LMBCol1','LMBCol2','LMBCol3'};
% for n = 1:size(BCname,2)
%     path1 = [path0 '\' BCname{n} '\'];
%     path2 = [path1 Group{GroupNo} '\'];
%     for m = 1:size(Periods,2)
%         
%        File_real = [path1 'ElemStr_' Group{GroupNo} '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_real.csv' ]; 
%        StrData_real = importdata(File_real);
%        
%        %----------------------------------------------
%        Data_col1 = sort_xval(StrData_real.data,XBound(2),XBound(1));
%        part = PartName{1}; %'LMBCol1';
%        MaxStr_real.(part).(BCname{n})(m,1:2)=max(Data_col1(:,5:6));
%        MaxStr_real.(part).(BCname{n})(m,3:4)=min(Data_col1(:,7:8));
%        
%        FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Top_real.fig'];
%        figure(1)
%        scatter3(Data_col1(:,2),Data_col1(:,3),Data_col1(:,4),50,Data_col1(:,5),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Top\_real - ' BCname{n}]);
%        hgsave(FigFileS1)
% 
%        FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Top_real.fig'];
%        figure(2)
%        scatter3(Data_col1(:,2),Data_col1(:,3),Data_col1(:,4),50,Data_col1(:,7),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Top\_real - ' BCname{n}]);
%        hgsave(FigFileS3)
%        
%        %----------------------------------------------
%        Data_c2c3 = sort_xval(StrData_real.data,XBound(3),XBound(2));
%        Data_col2 = sort_yval(Data_c2c3,YBound(2),YBound(1));
%        part = PartName{2}; %'LMBCol2';
%        MaxStr_real.(part).(BCname{n})(m,1:2)=max(Data_col2(:,5:6));
%        MaxStr_real.(part).(BCname{n})(m,3:4)=min(Data_col2(:,7:8));
%        
%        FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Top_real.fig'];
%        figure(1)
%        scatter3(Data_col2(:,2),Data_col2(:,3),Data_col2(:,4),50,Data_col2(:,5),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Top\_real - ' BCname{n}]);
%        hgsave(FigFileS1)
%        
%        FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Top_real.fig'];
%        figure(2)
%        scatter3(Data_col2(:,2),Data_col2(:,3),Data_col2(:,4),50,Data_col2(:,7),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Top\_real - ' BCname{n}]);
%        hgsave(FigFileS3)
%        
%        %----------------------------------------------
%        Data_col3 = sort_yval(Data_c2c3,YBound(3),YBound(2));
%        part = PartName{3}; %'LMBCol3';
%        MaxStr_real.(part).(BCname{n})(m,1:2)=max(Data_col3(:,5:6));
%        MaxStr_real.(part).(BCname{n})(m,3:4)=min(Data_col3(:,7:8));
%        
%        FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Top_real.fig'];
%        figure(1)
%        scatter3(Data_col3(:,2),Data_col3(:,3),Data_col3(:,4),50,Data_col3(:,5),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Top\_real - ' BCname{n}]);
%        hgsave(FigFileS1)
%        
%        FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Top_real.fig'];
%        figure(2)
%        scatter3(Data_col3(:,2),Data_col3(:,3),Data_col3(:,4),50,Data_col3(:,7),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Top\_real - ' BCname{n}]);
%        hgsave(FigFileS3)
%        
%        clear StrData_real Data_col1 Data_c2c3 Data_col2 Data_col3
%        
%        %*******************************************************************
%        %*******************************************************************
%        
%        File_imag = [path1 'ElemStr_' Group{GroupNo} '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_imag.csv' ]; 
%        StrData_imag = importdata(File_imag);
%        
%        %----------------------------------------------
%        Data_col1 = sort_xval(StrData_imag.data,XBound(2),XBound(1));
%        part = PartName{1}; %'LMBCol1';
%        MaxStr_imag.(part).(BCname{n})(m,1:2)=max(Data_col1(:,5:6));
%        MaxStr_imag.(part).(BCname{n})(m,3:4)=min(Data_col1(:,7:8));
%        
%        FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Top_imag.fig'];
%        figure(1)
%        scatter3(Data_col1(:,2),Data_col1(:,3),Data_col1(:,4),50,Data_col1(:,5),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Top\_imag - ' BCname{n}]);
%        hgsave(FigFileS1)
%        
%        FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Top_imag.fig'];
%        figure(2)
%        scatter3(Data_col1(:,2),Data_col1(:,3),Data_col1(:,4),50,Data_col1(:,7),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Top\_imag - ' BCname{n}]);
%        hgsave(FigFileS3)
%        
%        %----------------------------------------------
%        Data_c2c3 = sort_xval(StrData_imag.data,XBound(3),XBound(2));
%        Data_col2 = sort_yval(Data_c2c3,YBound(2),YBound(1));
%        part = PartName{2}; %'LMBCol2';
%        MaxStr_imag.(part).(BCname{n})(m,1:2)=max(Data_col2(:,5:6));
%        MaxStr_imag.(part).(BCname{n})(m,3:4)=min(Data_col2(:,7:8));
%        
%        FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Top_imag.fig'];
%        figure(1)
%        scatter3(Data_col2(:,2),Data_col2(:,3),Data_col2(:,4),50,Data_col2(:,5),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Top\_imag - ' BCname{n}]);
%        hgsave(FigFileS1)
%        
%        FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Top_imag.fig'];
%        figure(2)
%        scatter3(Data_col2(:,2),Data_col2(:,3),Data_col2(:,4),50,Data_col2(:,7),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Top\_imag - ' BCname{n}]);
%        hgsave(FigFileS3)
%        
%        %----------------------------------------------
%        Data_col3 = sort_yval(Data_c2c3,YBound(3),YBound(2));
%        part = PartName{3}; %'LMBCol3';
%        MaxStr_imag.(part).(BCname{n})(m,1:2)=max(Data_col3(:,5:6));
%        MaxStr_imag.(part).(BCname{n})(m,3:4)=min(Data_col3(:,7:8));
%        
%        FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Top_imag.fig'];
%        figure(1)
%        scatter3(Data_col3(:,2),Data_col3(:,3),Data_col3(:,4),50,Data_col3(:,5),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Top\_imag - ' BCname{n}]);
%        hgsave(FigFileS1)
%        
%        FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Top_imag.fig'];
%        figure(2)
%        scatter3(Data_col3(:,2),Data_col3(:,3),Data_col3(:,4),50,Data_col3(:,7),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Top\_imag - ' BCname{n}]);
%        hgsave(FigFileS3)
%        
%        clear StrData_imag Data_col1 Data_c2c3 Data_col2 Data_col3
%     end    
% end
%%
%Plot comparison of boundary conditions
% for m = 1:size(PartName,2)
%     
%     for n = 1:size(BCname,2)
%         S1top_real(n,:) = (MaxStr_real.(PartName{m}).(BCname{n})(:,1))';
%         S1top_imag(n,:) = (MaxStr_imag.(PartName{m}).(BCname{n})(:,1))';
%         S3top_real(n,:) = (MaxStr_real.(PartName{m}).(BCname{n})(:,3))';
%         S3top_imag(n,:) = (MaxStr_imag.(PartName{m}).(BCname{n})(:,3))';
%     end
%     
%     figure(1)
%     plot(Periods,S1top_real);
%     legend(BCname)
%     xlabel('Wave period (s)')
%     ylabel('S1 (MPa)')
%     title([PartName{m} ' Top S1 Real'])
%     FigureFile1 = [path0 '\' PartName{m} '_S1Top_Real.fig'];
%     hgsave(FigureFile1)
%     
%     figure(2)
%     plot(Periods,S1top_imag);
%     legend(BCname)
%     xlabel('Wave period (s)')
%     ylabel('S1 (MPa)')
%     title([PartName{m} ' Top S1 Imag'])
%     FigureFile2 = [path0 '\' PartName{m} '_S1Top_Imag.fig'];
%     hgsave(FigureFile2)
%     
%     figure(3)
%     plot(Periods,S3top_real);
%     legend(BCname)
%     xlabel('Wave period (s)')
%     ylabel('S3 (MPa)')
%     title([PartName{m} ' Top S3 Real'])
%     FigureFile3 = [path0 '\' PartName{m} '_S3Top_Real.fig'];
%     hgsave(FigureFile3)
%     
%     figure(4)
%     plot(Periods,S3top_imag);
%     legend(BCname)
%     xlabel('Wave period (s)')
%     ylabel('S3 (MPa)')
%     title([PartName{m} ' Top S3 Imag'])
%     FigureFile4 = [path0 '\' PartName{m} '_S3Top_Imag.fig'];
%     hgsave(FigureFile4)
% end
%%
%LMB mid can results
GroupNo = 4;
PartName = {'LMB12mid','LMB13mid','LMB23mid'};
for n = 1:size(BCname,2)
    path1 = [path0 '\' BCname{n} '\'];
    path2 = [path1 Group{GroupNo} '\'];
    for m = 1:size(Periods,2)
       File_real = [path1 'ElemStr_' Group{GroupNo} '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_real.csv' ]; 
       StrData_real = importdata(File_real);
       %-------------------------------------------------------------------
       data1 = sort_yval(StrData_real.data, YBound(2), YBound(1));
       data11 = sort_xydist(data1, ColSpace/2-L_LMBmidcan/2, ColSpace/2+L_LMBmidcan/2, Ctr_Col1(1), Ctr_Col1(2));
       Data_K12 = sort_zval(data11, Z_Keel+EL_LMBbtm+1.2*R_LMB, Z_Keel+EL_LMBbtm+2*R_LMB);
       part = PartName{1}; %'LMB12mid';
       MaxStr_real.(part).(BCname{n})(m,1:2)=max(Data_K12(:,5:6));
       MaxStr_real.(part).(BCname{n})(m,3:4)=min(Data_K12(:,7:8));
       
       FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Top_real.fig'];
       figure(1)
       scatter(Data_K12(:,2),Data_K12(:,3),30,Data_K12(:,5),'filled');
       axis equal
       colorbar
       title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Top\_real - ' BCname{n}]);
       hgsave(FigFileS1)
       
       FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Top_real.fig'];
       figure(2)
       scatter(Data_K12(:,2),Data_K12(:,3),30,Data_K12(:,7),'filled');
       axis equal
       colorbar
       title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Top\_real - ' BCname{n}]);
       hgsave(FigFileS3)
       
       %-------------------------------------------------------------------
       data2 = sort_yval(StrData_real.data, YBound(3), YBound(2));
       data22 = sort_xydist(data2, ColSpace/2-L_LMBmidcan/2, ColSpace/2+L_LMBmidcan/2, Ctr_Col1(1), Ctr_Col1(2));
       Data_K13 = sort_zval(data22, Z_Keel+EL_LMBbtm+1.2*R_LMB, Z_Keel+EL_LMBbtm+2*R_LMB);
       part = PartName{2}; %'LMB13mid';
       MaxStr_real.(part).(BCname{n})(m,1:2)=max(Data_K13(:,5:6));
       MaxStr_real.(part).(BCname{n})(m,3:4)=min(Data_K13(:,7:8));
       
       FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Top_real.fig'];
       figure(1)
       scatter(Data_K13(:,2),Data_K13(:,3),30,Data_K13(:,5),'filled');
       axis equal
       colorbar
       title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Top\_real - ' BCname{n}]);
       hgsave(FigFileS1)
       
       FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Top_real.fig'];
       figure(2)
       scatter(Data_K13(:,2),Data_K13(:,3),30,Data_K13(:,7),'filled');
       axis equal
       colorbar
       title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Top\_real - ' BCname{n}]);
       hgsave(FigFileS3)
       
       %-------------------------------------------------------------------
       data3 = sort_xval(StrData_real.data,XBound(3),XBound(2));
       data33 = sort_yval(data3, -L_LMBmidcan/2,L_LMBmidcan/2);
       Data_K23 = sort_zval(data33, Z_Keel+EL_LMBbtm+1.2*R_LMB, Z_Keel+EL_LMBbtm+2*R_LMB);
       part = PartName{3}; %'LMB23mid';
       MaxStr_real.(part).(BCname{n})(m,1:2)=max(Data_K23(:,5:6));
       MaxStr_real.(part).(BCname{n})(m,3:4)=min(Data_K23(:,7:8));
       
       FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Top_real.fig'];
       figure(1)
       scatter(Data_K23(:,2),Data_K23(:,3),30,Data_K23(:,5),'filled');
       axis equal
       colorbar
       title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Top\_real - ' BCname{n}]);
       hgsave(FigFileS1)
       
       FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Top_real.fig'];
       figure(2)
       scatter(Data_K23(:,2),Data_K23(:,3),30,Data_K23(:,7),'filled');
       axis equal
       colorbar
       title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Top\_real - ' BCname{n}]);
       hgsave(FigFileS3)
       
       clear StrData_real Data_K12 Data_K13 Data_K23 Data_col3 data1 data2...
           data3 data11 data22 data33
       
       %*******************************************************************
       %*******************************************************************
       
       File_imag = [path1 'ElemStr_' Group{GroupNo} '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_imag.csv' ]; 
       StrData_imag = importdata(File_imag);
       
       %-------------------------------------------------------------------
       data1 = sort_yval(StrData_imag.data, YBound(2), YBound(1));
       data11 = sort_xydist(data1, ColSpace/2-L_LMBmidcan/2, ColSpace/2+L_LMBmidcan/2, Ctr_Col1(1), Ctr_Col1(2));
       Data_K12 = sort_zval(data11, Z_Keel+EL_LMBbtm+1.2*R_LMB, Z_Keel+EL_LMBbtm+2*R_LMB);
       part = PartName{1}; %'LMB12mid';
       MaxStr_imag.(part).(BCname{n})(m,1:2)=max(Data_K12(:,5:6));
       MaxStr_imag.(part).(BCname{n})(m,3:4)=min(Data_K12(:,7:8));
       
       FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Top_imag.fig'];
       figure(1)
       scatter(Data_K12(:,2),Data_K12(:,3),30,Data_K12(:,5),'filled');
       axis equal
       colorbar
       title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Top\_imag - ' BCname{n}]);
       hgsave(FigFileS1)
       
       FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Top_imag.fig'];
       figure(2)
       scatter(Data_K12(:,2),Data_K12(:,3),30,Data_K12(:,7),'filled');
       axis equal
       colorbar
       title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Top\_imag - ' BCname{n}]);
       hgsave(FigFileS3)
       
       %-------------------------------------------------------------------
       data2 = sort_yval(StrData_imag.data, YBound(3), YBound(2));
       data22 = sort_xydist(data2, ColSpace/2-L_LMBmidcan/2, ColSpace/2+L_LMBmidcan/2, Ctr_Col1(1), Ctr_Col1(2));
       Data_K13 = sort_zval(data22, Z_Keel+EL_LMBbtm+1.2*R_LMB, Z_Keel+EL_LMBbtm+2*R_LMB);
       part = PartName{2}; %'LMB13mid';
       MaxStr_imag.(part).(BCname{n})(m,1:2)=max(Data_K13(:,5:6));
       MaxStr_imag.(part).(BCname{n})(m,3:4)=min(Data_K13(:,7:8));
       
       FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Top_imag.fig'];
       figure(1)
       scatter(Data_K13(:,2),Data_K13(:,3),30,Data_K13(:,5),'filled');
       axis equal
       colorbar
       title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Top\_imag - ' BCname{n}]);
       hgsave(FigFileS1)
       
       FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Top_imag.fig'];
       figure(2)
       scatter(Data_K13(:,2),Data_K13(:,3),30,Data_K13(:,7),'filled');
       axis equal
       colorbar
       title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Top\_imag - ' BCname{n}]);
       hgsave(FigFileS3)
       
       %-------------------------------------------------------------------
       data3 = sort_xval(StrData_imag.data,XBound(3),XBound(2));
       data33 = sort_yval(data3, -L_LMBmidcan/2,L_LMBmidcan/2);
       Data_K23 = sort_zval(data33, Z_Keel+EL_LMBbtm+1.2*R_LMB, Z_Keel+EL_LMBbtm+2*R_LMB);
       part = PartName{3}; %'LMB23mid';
       MaxStr_imag.(part).(BCname{n})(m,1:2)=max(Data_K23(:,5:6));
       MaxStr_imag.(part).(BCname{n})(m,3:4)=min(Data_K23(:,7:8));
       
       FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Top_imag.fig'];
       figure(1)
       scatter(Data_K23(:,2),Data_K23(:,3),30,Data_K23(:,5),'filled');
       axis equal
       colorbar
       title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Top\_imag - ' BCname{n}]);
       hgsave(FigFileS1)
       
       FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Top_imag.fig'];
       figure(2)
       scatter(Data_K23(:,2),Data_K23(:,3),30,Data_K23(:,7),'filled');
       axis equal
       colorbar
       title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Top\_imag - ' BCname{n}]);
       hgsave(FigFileS3)
       
       clear StrData_real Data_K12 Data_K13 Data_K23 Data_col3 data1 data2...
           data3 data11 data22 data33
    end    
end
%%
%Plot comparison of boundary conditions
for m = 1:size(PartName,2)
    
    for n = 1:size(BCname,2)
        S1top_real(n,:) = (MaxStr_real.(PartName{m}).(BCname{n})(:,1))';
        S1top_imag(n,:) = (MaxStr_imag.(PartName{m}).(BCname{n})(:,1))';
        S3top_real(n,:) = (MaxStr_real.(PartName{m}).(BCname{n})(:,3))';
        S3top_imag(n,:) = (MaxStr_imag.(PartName{m}).(BCname{n})(:,3))';
    end
    
    figure(1)
    plot(Periods,S1top_real);
    legend(BCname)
    xlabel('Wave period (s)')
    ylabel('S1 (MPa)')
    title([PartName{m} ' Top S1 Real'])
    FigureFile1 = [path0 '\' PartName{m} '_S1Top_Real.fig'];
    hgsave(FigureFile1)
    
    figure(2)
    plot(Periods,S1top_imag);
    legend(BCname)
    xlabel('Wave period (s)')
    ylabel('S1 (MPa)')
    title([PartName{m} ' Top S1 Imag'])
    FigureFile2 = [path0 '\' PartName{m} '_S1Top_Imag.fig'];
    hgsave(FigureFile2)
    
    figure(3)
    plot(Periods,S3top_real);
    legend(BCname)
    xlabel('Wave period (s)')
    ylabel('S3 (MPa)')
    title([PartName{m} ' Top S3 Real'])
    FigureFile3 = [path0 '\' PartName{m} '_S3Top_Real.fig'];
    hgsave(FigureFile3)
    
    figure(4)
    plot(Periods,S3top_imag);
    legend(BCname)
    xlabel('Wave period (s)')
    ylabel('S3 (MPa)')
    title([PartName{m} ' Top S3 Imag'])
    FigureFile4 = [path0 '\' PartName{m} '_S3Top_Imag.fig'];
    hgsave(FigureFile4)
end
%%
%OS results
% GroupNo = 2;
% PartName = {'OSbtmCol1','OSbtmCol2','OSbtmCol3'};
% for n = 1:size(BCname,2)
%     path1 = [path0 '\' BCname{n} '\'];
%     path2 = [path1 Group{GroupNo} '\'];
%     for m = 1:size(Periods,2)
%        File_real = [path1 'ElemStr_' Group{GroupNo} '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_real.csv' ]; 
%        StrData_real = importdata(File_real);
%        
%        %-------------------------------------------------------------------
%        Data_col1 = sort_xval(StrData_real.data,XBound(2),XBound(1));
%        part = PartName{1}; %'OSbtm_Col1';
%        MaxStr_real.(part).(BCname{n})(m,1:2)=max(Data_col1(:,5:6));
%        MaxStr_real.(part).(BCname{n})(m,3:4)=min(Data_col1(:,7:8));
%        
%        FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Btm_real.fig'];
%        figure(1)
%        scatter3(Data_col1(:,2),Data_col1(:,3),Data_col1(:,4),50,Data_col1(:,6),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Btm\_real - ' BCname{n}]);
%        hgsave(FigFileS1)
%        
%        FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Btm_real.fig'];
%        figure(2)
%        scatter3(Data_col1(:,2),Data_col1(:,3),Data_col1(:,4),50,Data_col1(:,8),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Btm\_real - ' BCname{n}]);
%        hgsave(FigFileS3)
%        
%        %-------------------------------------------------------------------
%        Data_c2c3 = sort_xval(StrData_real.data,XBound(3),XBound(2));
%        Data_col2 = sort_yval(Data_c2c3,YBound(2),YBound(1));
%        part = PartName{2}; %'OSbtm_Col2';
%        MaxStr_real.(part).(BCname{n})(m,1:2)=max(Data_col2(:,5:6));
%        MaxStr_real.(part).(BCname{n})(m,3:4)=min(Data_col2(:,7:8));
%        
%        FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Btm_real.fig'];
%        figure(1)
%        scatter3(Data_col2(:,2),Data_col2(:,3),Data_col2(:,4),50,Data_col2(:,6),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Btm\_real - ' BCname{n}]);
%        hgsave(FigFileS1)
%        
%        FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Btm_real.fig'];
%        figure(2)
%        scatter3(Data_col2(:,2),Data_col2(:,3),Data_col2(:,4),50,Data_col2(:,8),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Btm\_real - ' BCname{n}]);
%        hgsave(FigFileS3)
%        
%        %-------------------------------------------------------------------
%        Data_col3 = sort_yval(Data_c2c3,YBound(3),YBound(2));
%        part = PartName{3}; %'OSbtm_Col3';
%        MaxStr_real.(part).(BCname{n})(m,1:2)=max(Data_col3(:,5:6));
%        MaxStr_real.(part).(BCname{n})(m,3:4)=min(Data_col3(:,7:8));
%        
%        FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Btm_real.fig'];
%        figure(1)
%        scatter3(Data_col3(:,2),Data_col3(:,3),Data_col3(:,4),50,Data_col3(:,6),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Btm\_real - ' BCname{n}]);
%        hgsave(FigFileS1)
%        
%        FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Btm_real.fig'];
%        figure(2)
%        scatter3(Data_col3(:,2),Data_col3(:,3),Data_col3(:,4),50,Data_col3(:,8),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Btm\_real - ' BCname{n}]);
%        hgsave(FigFileS3)
%        
%        clear StrData_real Data_col1 Data_c2c3 Data_col2 Data_col3
%        
%        %*******************************************************************
%        %*******************************************************************
%        
%        File_imag = [path1 'ElemStr_' Group{GroupNo} '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_imag.csv' ]; 
%        StrData_imag = importdata(File_imag);
%        
%        %-------------------------------------------------------------------
%        Data_col1 = sort_xval(StrData_imag.data,XBound(2),XBound(1));
%        part = PartName{1}; %'OSbtm_Col1';
%        MaxStr_imag.(part).(BCname{n})(m,1:2)=max(Data_col1(:,5:6));
%        MaxStr_imag.(part).(BCname{n})(m,3:4)=min(Data_col1(:,7:8));
%        
%        FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Btm_imag.fig'];
%        figure(1)
%        scatter3(Data_col1(:,2),Data_col1(:,3),Data_col1(:,4),50,Data_col1(:,6),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Btm\_imag - ' BCname{n}]);
%        hgsave(FigFileS1)
%        
%        FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Btm_imag.fig'];
%        figure(2)
%        scatter3(Data_col1(:,2),Data_col1(:,3),Data_col1(:,4),50,Data_col1(:,8),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Btm\_imag - ' BCname{n}]);
%        hgsave(FigFileS3)
%        
%        %-------------------------------------------------------------------
%        Data_c2c3 = sort_xval(StrData_imag.data,XBound(3),XBound(2));
%        Data_col2 = sort_yval(Data_c2c3,YBound(2),YBound(1));
%        part = PartName{2}; %'OSbtm_Col2';
%        MaxStr_imag.(part).(BCname{n})(m,1:2)=max(Data_col2(:,5:6));
%        MaxStr_imag.(part).(BCname{n})(m,3:4)=min(Data_col2(:,7:8));
%        
%        FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Btm_imag.fig'];
%        figure(1)
%        scatter3(Data_col2(:,2),Data_col2(:,3),Data_col2(:,4),50,Data_col2(:,6),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Btm\_imag - ' BCname{n}]);
%        hgsave(FigFileS1)
%        
%        FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Btm_imag.fig'];
%        figure(2)
%        scatter3(Data_col2(:,2),Data_col2(:,3),Data_col2(:,4),50,Data_col2(:,8),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Btm\_imag - ' BCname{n}]);
%        hgsave(FigFileS3)
%        
%        %-------------------------------------------------------------------
%        Data_col3 = sort_yval(Data_c2c3,YBound(3),YBound(2));
%        part = PartName{3}; %'OSbtm_Col3';
%        MaxStr_imag.(part).(BCname{n})(m,1:2)=max(Data_col3(:,5:6));
%        MaxStr_imag.(part).(BCname{n})(m,3:4)=min(Data_col3(:,7:8));
%        
%        FigFileS1 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S1Btm_imag.fig'];
%        figure(1)
%        scatter3(Data_col2(:,2),Data_col2(:,3),Data_col2(:,4),50,Data_col2(:,6),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S1Btm\_imag - ' BCname{n}]);
%        hgsave(FigFileS1)
%        
%        FigFileS3 = [path2 part '_Run' num2str(Heading) 'T' num2str(Periods(m)) '_S3Btm_imag.fig'];
%        figure(2)
%        scatter3(Data_col2(:,2),Data_col2(:,3),Data_col2(:,4),50,Data_col2(:,8),'filled');
%        axis equal
%        colorbar
%        title([part '\_Run' num2str(Heading) 'T' num2str(Periods(m)) '\_S3Btm\_imag - ' BCname{n}]);
%        hgsave(FigFileS3)
%        
%        clear StrData_imag Data_col1 Data_c2c3 Data_col2 Data_col3
%     end    
% end

%%
% Plot comparison of boundary conditions
% for m = 1:size(PartName,2)
%     
%     for n = 1:size(BCname,2)
%         S1btm_real(n,:) = (MaxStr_real.(PartName{m}).(BCname{n})(:,2))';
%         S1btm_imag(n,:) = (MaxStr_imag.(PartName{m}).(BCname{n})(:,2))';
%         S3btm_real(n,:) = (MaxStr_real.(PartName{m}).(BCname{n})(:,4))';
%         S3btm_imag(n,:) = (MaxStr_imag.(PartName{m}).(BCname{n})(:,4))';
%     end
%     
%     figure(1)
%     plot(Periods,S1btm_real);
%     legend(BCname)
%     xlabel('Wave period (s)')
%     ylabel('S1 (MPa)')
%     title([PartName{m} ' Btm S1 Real'])
%     FigureFile1 = [path0 '\' PartName{m} '_S1Btm_Real.fig'];
%     hgsave(FigureFile1)
%     
%     figure(2)
%     plot(Periods,S1btm_imag);
%     legend(BCname)
%     xlabel('Wave period (s)')
%     ylabel('S1 (MPa)')
%     title([PartName{m} ' Btm S1 Imag'])
%     FigureFile2 = [path0 '\' PartName{m} '_S1Btm_Imag.fig'];
%     hgsave(FigureFile2)
%     
%     figure(3)
%     plot(Periods,S3btm_real);
%     legend(BCname)
%     xlabel('Wave period (s)')
%     ylabel('S3 (MPa)')
%     title([PartName{m} ' Btm S3 Real'])
%     FigureFile3 = [path0 '\' PartName{m} '_S3Btm_Real.fig'];
%     hgsave(FigureFile3)
%     
%     figure(4)
%     plot(Periods,S3btm_imag);
%     legend(BCname)
%     xlabel('Wave period (s)')
%     ylabel('S3 (MPa)')
%     title([PartName{m} ' Btm S3 Imag'])
%     FigureFile4 = [path0 '\' PartName{m} '_S3Btm_Imag.fig'];
%     hgsave(FigureFile4)
% end
%%
ResultFile1 = [path0 'BCstudy_results_real.mat' ]; 
save (ResultFile1, 'MaxStr_real')
ResultFile2 = [path0 'BCstudy_results_imag.mat' ]; 
save (ResultFile2, 'MaxStr_imag')