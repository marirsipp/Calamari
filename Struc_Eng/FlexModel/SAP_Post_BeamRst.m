function[] = SAP_Post_BeamRst(path0, CaseName, col_P, WrtExcel)
%SAP output post processing - get force and moment results per beam

%Input 
% path0 = 'D:\Bingbin\Documents\Fatigue assessment\FlexModel\WFM_Itr0';
% CaseName = 'LinearStatic_Beta1000';
% col_P = 4; 4 for linear case
% WrtExcel = 1; 1 - write beam results in excel file, 0 - do not write

SAP_FileName = ['SAP_Output_' CaseName '.mat'];
SAP_File = [path0 '\' SAP_FileName];
BeamFile = [path0 '\BeamNo.mat'];

OutFileName1 = ['SAP_BeamResult_' CaseName '.xls'];
OutFileName2 = ['SAP_BeamResult_' CaseName '.mat'];
OutFile1 = [path0 '\' OutFileName1];
OutFile2 = [path0 '\' OutFileName2];

Header1 = [{'Frame'},{'Station'},{'Global_X'},{'Global_Y'},{'Global_Z'},{'P'},{'V2'},{'V3'},{'T'},{'M2'},{'M3'}, {'Arc_Length'}];
Header2 = [{'Text'},{'m'},{'m'},{'m'},{'m'},{'N'},{'N'},{'N'},{'N-m'},{'N-m'},{'N-m'}, {'m'}];

if ~exist(SAP_File, 'file')
    SAP_Post_ReadOutput(path0, CaseName, col_P)
    load(SAP_File)
else
    load(SAP_File)
end

Station_Frame = Station_Rst_Total(:,1);

%Beam information
BeamInfo = load(BeamFile);
BeamNames = fieldnames(BeamInfo.Beam);
BeamNo = length(BeamNames);
Beam_Result.Header = [Header1;Header2];

for ii = 1:BeamNo
    beam1 = BeamNames{ii};
    Beam_Frame = BeamInfo.Beam.(beam1);
    Beam_Rst = [];
    for n = 1:size(Beam_Frame,2)
        ind = find(Station_Frame==Beam_Frame(n));
        frm_rst = Station_Rst_Total (ind,:);
        Beam_Rst = [Beam_Rst;frm_rst];
    end
    for n = 1:size(Beam_Rst,1)
        Arc_Length(n,1) = sqrt( (Beam_Rst(n,3)-Beam_Rst(1,3))^2 + (Beam_Rst(n,4)-Beam_Rst(1,4))^2 + (Beam_Rst(n,5)-Beam_Rst(1,5))^2);
    end
    Beam1_Rst = [Beam_Rst,Arc_Length];
    Beam_Result.(beam1) = Beam1_Rst;
    if WrtExcel
        Output = [Header1;Header2;num2cell(Beam1_Rst)];
        xlswrite(OutFile1,Output,beam1)
    end
    clear Beam_Rst Beam1_Rst Arc_Length
end

save(OutFile2, 'Beam_Result')
end