function[]=SAP_Post_ReadOutput(path0, CaseName, col_P)

%SAP output post processing, read output .xlsx file

%% Input 
% path0 = 'D:\Bingbin\Documents\Fatigue assessment\FlexModel\WFM_Itr0_Test';
% CaseName = 'TwrTp_100thWt';
% col_P = 4; %4 for linear case

RstFileName = ['SAP_Output_' CaseName '.xlsx'];
RstFile = [path0 '\' RstFileName];

JointTab = 'Joint Coordinates';
FrameTab = 'Connectivity - Frame';
ForceTab = 'Element Forces - Frames';
ElemJntTab = 'Objects And Elements - Joints';
JntDispTab = 'Joint Displacements';
row_start = 4;

%Output
% OutFileName = ['SAP_Output_' CaseName '.mat'];
% OutFile = [path0 '\' OutFileName];
% Header1 = [{'Frame'},{'Station'},{'Global_X'},{'Global_Y'},{'Global_Z'},{'P'},{'V2'},{'V3'},{'T'},{'M2'},{'M3'}, {'Arc_Length'}];
% Header2 = [{'Text'},{'m'},{'m'},{'m'},{'m'},{'N'},{'N'},{'N'},{'N-m'},{'N-m'},{'N-m'}, {'m'}];
Header3 = [{'JointElem'}, {'Global_X'},{'Global_Y'},{'Global_Z'},{'U1'},{'U2'},{'U3'},{'R1'},{'R2'},{'R3'},];
Header4 = [{'Text'}, {'m'},{'m'},{'m'},{'m'},{'m'},{'m'},{'Radians'},{'Radians'},{'Radians'},];

%% Read SAP output file
%Joint information
[num1, txt1] = xlsread(RstFile,JointTab);
for i=1:size(num1,1)
    JointNo(i,1) = str2num( txt1{row_start+i-1,1} );
end
JointCoord = num1(:,5:7);

%Frame information
[num2, txt2] = xlsread(RstFile,FrameTab);
for i=1:size(num2,1)
    FrameNo(i,1) = str2num(txt2{row_start+i-1,1});
    Frame_JointI(i,1) = str2num(txt2{row_start+i-1,2});
    Frame_JointJ(i,1) = str2num(txt2{row_start+i-1,3});
end
FrameLength = num2(:,1);

%Frame force/moment output
[num3, txt3] = xlsread(RstFile,ForceTab);
NoStation = size(num3,1);
for i=1:NoStation
    Station_Frame(i,1) = str2num(txt3{row_start+i-1,1});
end
Station_Force = num3(:,col_P:col_P+6-1);
Station_offset = num3(:,1);

loads = txt3(row_start:end,3);
[LoadCases ind1 ind2]=unique(loads);
Station_LdCs = ind2;

%Element Joint Information
[num4, txt4] = xlsread(RstFile,ElemJntTab);
JntNo_C = txt4(row_start:end,1);
[ObjJnt_Coord, ElemJnt_Coord] = JointDiff(JntNo_C,num4);

%Element Joint Displacement
[num5, txt5] = xlsread(RstFile,JntDispTab);

loads_jnt = txt5(row_start:end,2);
[LoadCases_jnt ind1 ind2]=unique(loads_jnt);
Jnt_LdCs = ind2;

JntNo_D = txt5(row_start:end,1);
[ObjJnt_Disp_All, ElemJnt_Disp_All] = JointDiff(JntNo_D,[num5,Jnt_LdCs]);
%xlswrite(OutFile,ElemJnt_Rst,'Displacement')
%% Calculate global coordinates of all stations
for ii = 1:NoStation
    frm = Station_Frame(ii);
    frm_row = find(FrameNo==frm);
    frm_i = Frame_JointI (frm_row ,1);
    frm_j = Frame_JointJ (frm_row ,1);
    coord_i = JointCoord ( find(JointNo==frm_i), :);
    coord_j = JointCoord ( find(JointNo==frm_j), :);
    portion(ii,1) = Station_offset(ii)/FrameLength(frm_row ,1);
    Station_Coord(ii,:) = coord_i + portion(ii,1)* (coord_j-coord_i);
end
Station_Rst_All = [Station_Frame,Station_offset,Station_Coord,Station_Force*1000, Station_LdCs]; %Force/Mmt unit N and N-m

%% Sort by load cases
%Save all useful data
N_LdCs = length(LoadCases);

for n=1:N_LdCs
    CaseName = LoadCases{n};
    OutFileName = ['SAP_Output_' CaseName '.mat'];
    OutFile = [path0 '\' OutFileName];
    
    ObjJnt_Disp = ObjJnt_Disp_All((ObjJnt_Disp_All(:,end)==n),:);
    ElemJnt_Disp = ElemJnt_Disp_All((ElemJnt_Disp_All(:,end)==n),:);    
    ElemJnt_Rst = [Header3;Header4; num2cell([ObjJnt_Coord,ObjJnt_Disp(:,2:end-1);ElemJnt_Coord,ElemJnt_Disp(:,2:end-1)])];
    
    Station_Rst = Station_Rst_All((Station_Rst_All(:,end)==n),:);
    Station_Rst_Total = Station_Rst(:,1:end-1);
    save(OutFile, 'JointNo', 'JointCoord', 'FrameNo', 'Frame_JointI', 'Frame_JointJ', 'FrameLength', 'Station_Rst_Total', 'ElemJnt_Rst')

end

end