function[data] = ElemInfo(path0, PartName, WaveHeading, unit)
%ElemInfo.m opens one frequency domain output file and reads element number
%and element centroid locations x, y, z(mm)

heading = num2str(WaveHeading);
period = '3';
TorB = 'Top';

% path1 = [path0 Iteration '\'];
path1 = [path0 'Run' heading '\'];

S_real_file = [path1 'ElemStr_' PartName '_Run' heading 'T' period '_real_' TorB '.csv'];

file_real = importdata(S_real_file);
data_real = file_real.data; 

if strcmp(unit,'Pa')
    data(:,1) = data_real(:,1);
    data(:,2:4) =data_real(:,2:4)*1000; %Element centroid location converted to mm
else
    data = data_real(:,1:4);
end

end