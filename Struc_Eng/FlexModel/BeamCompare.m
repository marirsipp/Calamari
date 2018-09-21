function [] = BeamCompare(path_sap,path_orca,sap_case1,sap_case2,beam,orca_time)

%Input
%beam - beam to compare, has field name: name, axis and shrdir (V2 or V3)

path1 = [path_sap '\Compare'];

FileSAP1 = [path_sap '\SAP_BeamResult_' sap_case1 '.xls'];
FileSAP2 = [path_sap '\SAP_BeamResult_' sap_case2 '.xls'];

SAP_Force_Tab = beam.name;
SAP_Disp_Tab = [beam.name '_Disp'];

case1 = regexprep(sap_case1,'_',' ');
case2 = regexprep(sap_case2,'_',' ');

Force_SAP1 = xlsread(FileSAP1,SAP_Force_Tab);
% Disp_SAP1  = xlsread(FileSAP1,SAP_Disp_Tab);

Force_SAP2 = xlsread(FileSAP2,SAP_Force_Tab);
% Disp_SAP2  = xlsread(FileSAP2,SAP_Disp_Tab);

if strcmp(beam.axis, 'x')
    axis_col = 3;
elseif strcmp(beam.axis, 'y')
    axis_col = 4;
elseif strcmp(beam.axis, 'z')
    axis_col = 5;
end

if strcmp(beam.shrdir,'V2')
    P_col = 6;
    V_col = 7;
    M_col = 11;
elseif strcmp(beam.shrdir,'V3')
    P_col = 6;
    V_col = 8;
    M_col = 10;
end

[Rst_Orca,Disp_Orca] = OrcaRst(path_orca,orca_time);
Force_Orca = Rst_Orca.(beam.name);

figure(1)
if strcmp(beam.axis,'z')
    plot(Force_SAP1(:,P_col),Force_SAP1(:,axis_col),Force_SAP2(:,P_col),Force_SAP2(:,axis_col), ...
        Force_Orca(:,2), Force_Orca(:,1))
    ylabel(['Global' beam.axis '(m)'])
    xlabel('Axial force (N)')
else
    plot(Force_SAP1(:,axis_col),Force_SAP1(:,P_col), Force_SAP2(:,axis_col),Force_SAP2(:,P_col), ...
        Force_Orca(:,1), Force_Orca(:,2))
    xlabel(['Global ' beam.axis ' (m)'])
    ylabel('Axial force (N)')
end
legend (case1,case2,'Orca','Location','Best')
title('Axial force P (N)')

FigName1 = [path1 '\' sap_case2 '_' beam.name '_Wall'];
h1=figure(1);
print(h1,'-dpng',[FigName1 '.png'],'-r300')
hgsave(h1,FigName1)

figure(2)
if strcmp(beam.axis,'z')
    plot(Force_SAP1(:,V_col),Force_SAP1(:,axis_col),Force_SAP2(:,V_col),Force_SAP2(:,axis_col), ...
        Force_Orca(:,3), Force_Orca(:,1))
    ylabel(['Global' beam.axis '(m)'])
    xlabel('Shear force (N)')
else
    plot(Force_SAP1(:,axis_col),Force_SAP1(:,V_col), Force_SAP2(:,axis_col),Force_SAP2(:,V_col), ...
        Force_Orca(:,1), Force_Orca(:,3))
    xlabel(['Global ' beam.axis ' (m)'])
    ylabel('Shear force (N)')
end
legend (case1,case2,'Orca','Location','Best')
title('Shear force V2/V3 (N)')

FigName2 = [path1 '\' sap_case2 '_' beam.name '_Shear'];
h1=figure(2);
print(h1,'-dpng',[FigName2 '.png'],'-r300')
hgsave(h1,FigName2)

figure(3)
if strcmp(beam.axis,'z')
    plot(Force_SAP1(:,M_col),Force_SAP1(:,axis_col),Force_SAP2(:,M_col),Force_SAP2(:,axis_col), ...
        Force_Orca(:,4), Force_Orca(:,1))
    ylabel(['Global' beam.axis '(m)'])
    xlabel('Bending Moment (N-m)')
else
    plot(Force_SAP1(:,axis_col),Force_SAP1(:,M_col), Force_SAP2(:,axis_col),Force_SAP2(:,M_col), ...
        Force_Orca(:,1), Force_Orca(:,4))
    xlabel(['Global ' beam.axis ' (m)'])
    ylabel('Bending Moment (N-m)')
end
legend (case1,case2,'Orca','Location','Best')
title('Bending Moment M2/M3 (N-m)')

FigName3 = [path1 '\' sap_case2 '_' beam.name '_Bend'];
h1=figure(3);
print(h1,'-dpng',[FigName3 '.png'],'-r300')
hgsave(h1,FigName3)
   
end
