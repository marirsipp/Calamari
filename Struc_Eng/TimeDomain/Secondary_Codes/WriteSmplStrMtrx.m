function[] = WriteSmplStrMtrx(path_out,path_str,path_hsp,Cnnt)

%Create sampled stress matrix for time domain fatigue calcuation
%Input
%path_out - output path for regular sampled connection stress matrix
%path_str - path for stress matrix the sampling based on
%path_hsp - output path for hot spots stress matrix
%Cnnt - data structure that contains connection info

%Stress matrix info
axis_col.x = 2; %Column No. that represents x axis 
axis_col.y = 3; %Column No. that represents y axis
axis_col.z = 4; %Column No. that represents z axis
ThkCol = 5; %Column No. that contains member thickness
format1 = ['%8s',',', repmat(['%6s',','],1,3), '%7s', repmat([',','%5s',',','%5s',',','%6s'],1,6),'\n'];
format2 = ['%10.0f', repmat([',','%10.3f'],1,3), ',', '%6.1f', repmat([',','%10.6e'],1,18),'\n'];

%Sampling for connection
cd(path_str)
fnames = dir('*.csv');
numfids = length(fnames);

for n = 1:numfids
    filename = fnames(n).name;
    ind1 = regexp(filename,'_');
    ind2 = regexp(filename,'.csv');
    LineNo = filename(ind1(1)+1:ind1(2)-1);
    PartName = filename(ind1(2)+1:ind1(3)-1);
    TorB = filename(ind1(3)+1:ind2-1);
    
    rst = importdata(fnames(n).name);
    
    header = rst.textdata;
        
    if strcmp(Cnnt.(LineNo).group,'circ')
                
        ColNo = axis_col.(Cnnt.(LineNo).axis);
        data1 = Smpl_byIntrvl(rst.data, ColNo, Cnnt.(LineNo).(PartName).int);
         
    elseif strcmp(Cnnt.(LineNo).group,'rad')
        
        Col_c = axis_col.(Cnnt.(LineNo).axis_c);
        Col_r = axis_col.(Cnnt.(LineNo).axis_r);
        data1 = Smpl_byAxisVal(rst.data,Col_c,Col_r,Cnnt.(LineNo).(PartName).int);
        
    elseif strcmp(Cnnt.(LineNo).group,'flat')
        
        Col1 = axis_col.(Cnnt.(LineNo).axis1);
        Col2 = axis_col.(Cnnt.(LineNo).axis2);
        data1 = Smpl_byPath(rst.data,Cnnt.(LineNo).(PartName).path,Col1,Col2,Cnnt.(LineNo).(PartName).int); 
        
    else
        Col_c = axis_col.(Cnnt.(LineNo).axis1);
        Col_r = axis_col.(Cnnt.(LineNo).axis2);
        data2 = sortrows(rst.data,Col_r);
        data1 = Smpl_byIntrvl(data2,Col_c,Cnnt.(LineNo).(PartName).int);
    end
    
    OutName = [path_out LineNo,'_',PartName,'_',TorB,'_','StrMtx','.csv'];
    Nnode = size(data1,1);
    fid = fopen(OutName,'w');
    fprintf(fid,format1, header{1:23});
    for i=1:Nnode
        fprintf(fid,format2, data1(i,:));
    end
    fclose(fid);
    clear data1
    
    if isfield(Cnnt.(LineNo).(PartName),'Hsp')
        
        HspVal = Cnnt.(LineNo).(PartName).Hsp;
        tolerance = Cnnt.(LineNo).(PartName).HspTol;

        if strcmp(Cnnt.(LineNo).group,'circ')
            ColNo = axis_col.(Cnnt.(LineNo).axis);
            data2 = Smpl_byVal(rst.data, ColNo, HspVal, tolerance);
        else
            ColNo = axis_col.(Cnnt.(LineNo).(PartName).HspAxis);
            axisall = 'xyz';
            num = 6 - findstr(axisall,Cnnt.(LineNo).(PartName).HspAxis) - findstr(axisall,Cnnt.(LineNo).(PartName).axisTT);
            ColNo2 = axis_col.(axisall(num));
            
            data1 = Smpl_byVal(rst.data, ColNo, HspVal, tolerance);
            if isfield(Cnnt.(LineNo).(PartName),'HspInt')
                data1_int = Smpl_byIntrvl(data1, ColNo2, Cnnt.(LineNo).(PartName).HspInt);
            else
                data1_int = sortrows(data1,ColNo2);
            end
            
            if isfield(Cnnt.(LineNo).(PartName),'HspAxis2')
                HspVal2 = Cnnt.(LineNo).(PartName).Hsp2;
                ColNo3 = axis_col.(Cnnt.(LineNo).(PartName).HspAxis2);
                num2 = 6 - findstr(axisall,Cnnt.(LineNo).(PartName).HspAxis2) - findstr(axisall,Cnnt.(LineNo).(PartName).axisTT);
                ColNo4 = axis_col.(axisall(num2));
                data3 = Smpl_byVal(rst.data, ColNo3, HspVal2, tolerance);
                if isfield(Cnnt.(LineNo).(PartName),'HspInt')
                    data3_int = Smpl_byIntrvl(data3, ColNo3, Cnnt.(LineNo).(PartName).HspInt);
                else
                    data3_int = sortrows(data3,ColNo4);
                end
                data2 = [data1_int;data3_int];
            else
                data2 = data1_int;
            end
        end        
        
        if isfield(Cnnt.(LineNo).(PartName),'HspThk')
            data2(:,ThkCol) = Cnnt.(LineNo).(PartName).HspThk;
        end
        
        OutName = [path_hsp LineNo,'_',PartName,'_',TorB,'_','StrMtx','.csv'];
        Nnode = size(data2,1);
        fid = fopen(OutName,'w');
        fprintf(fid,format1, header{1:23});
        for i=1:Nnode
            fprintf(fid,format2, data2(i,:));
        end
        fclose(fid);
        clear data1 data2 data3 data1_int data3_int
    end
    clear rst 
end
end
