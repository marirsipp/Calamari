function[] = SAP_Post_BeamDisp(path0, CaseName, col_P, WrtExcel)
%% Plot joint displacement results per beam

%Input 
% path0 = 'D:\Bingbin\Documents\Fatigue assessment\FlexModel\WFM_Itr0';
% CaseName = 'LinearStatic_Beta1000';
% col_P = 4; 4 for linear case
% WrtExcel = 1; 1 - write beam results in excel file, 0 - do not write

SAP_FileName = ['SAP_Output_' CaseName '.mat'];
Rst_FileName = ['SAP_BeamResult_' CaseName '.mat'];
SAP_File = [path0 '\' SAP_FileName];
BeamFile = [path0 '\BeamNo.mat'];
BeamRstFile = [path0 '\' Rst_FileName];

OutFileName1 = ['SAP_BeamDisp_' CaseName '.xls'];
OutFileName2 = ['SAP_BeamDisp_' CaseName '.mat'];
OutFile1 = [path0 '\' OutFileName1];
OutFile2 = [path0 '\' OutFileName2];

Header1 = [{'Global_X'},{'Global_Y'},{'Global_Z'},{'U1'},{'U2'},{'U3'},{'R1'},{'R2'},{'R3'},{'Arc_Length'}];
Header2 = [{'m'},{'m'},{'m'},{'m'},{'m'},{'m'},{'Radians'},{'Radians'},{'Radians'},{'m'}];

%% Read joint displacement results and beam results
if ~exist(SAP_File, 'file')
    SAP_Post_ReadOutput(path0, CaseName, col_P)
    load(SAP_File)
else
    load(SAP_File)
end
JntDispRst = cell2mat(ElemJnt_Rst(3:end,2:end));

if ~exist(BeamRstFile, 'file')
    SAP_Post_BeamRst(path0, CaseName, col_P, 0)
    load(BeamRstFile)
else
    load(BeamRstFile)
end
%% Beam information
BeamInfo = load(BeamFile);
BeamNames = fieldnames(BeamInfo.Beam);
BeamNo = length(BeamNames);
Beam_DispRst.Header = [Header1;Header2];

for ii = 1:BeamNo
    beam1 = BeamNames{ii};
        
    Beam_start = Beam_Result.(beam1)(1,3:5); %Global coordinate of the starting point of the current beam
    Beam_end = Beam_Result.(beam1)(end,3:5); %Global coordinate of the ending point of the current beam
    Beam_vector = Beam_end - Beam_start;
    
    for m = 1:size(JntDispRst,1)
        jnt_vector = (JntDispRst(m,1:3) - Beam_start);
        a = cross(jnt_vector,Beam_vector);
        b(m,1) = sum(a.^2);
    end
    Beam_disp = JntDispRst(abs(b)<=1e-3,:);
    Beam_disp(:,end+1) = sqrt( (Beam_disp(:,1)-Beam_start(1)).^2 + (Beam_disp(:,2)-Beam_start(2)).^2 + (Beam_disp(:,3)-Beam_start(3)).^2);
    Beam_disp1 = sortrows(Beam_disp,size(Beam_disp,2));
    
    Beam_DispRst.(beam1) = Beam_disp1;
    if WrtExcel
        Output = [Header1;Header2;num2cell(Beam_disp1)];
        xlswrite(OutFile1,Output,beam1)
    end
    clear Beam_disp Beam_disp1 
end
save(OutFile2, 'Beam_DispRst')
end