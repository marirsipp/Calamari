function[] = PickWorstNode(path_rst, path_str, path_out, PrvStrOpt, tol_length, tol_angle)
%Pick the node with worst fatigue life result
%Output the worst nodes' stress matrix
%Input:
%path_rst - path for reference fatigue calculation results
%path_str - path for current iteration's stress matrix 
%path_out - path for outputing picked worst node stress matrix
%tol_length - tolerance for coordinates in mm
%tol_angle - tolerance for coordinates in degree

cd(path_rst)
fnames = dir(['*' PrvStrOpt '.csv']);
numfids = length(fnames);

for i = 1:numfids
    filename = fnames(i).name;
    ind1 = regexp(filename,'_');
    LineNo = filename(1:ind1(1)-1);
    PartName = filename(ind1(1)+1:ind1(2)-1);
    if ~isempty(PrvStrOpt)
        TorB = filename(ind1(2)+1:ind1(3)-1);
    else
        ind2 = regexp(filename,'.csv');
        TorB = filename(ind1(2)+1:ind2(1)-1);
    end
    
    result = importdata(filename);
    if isstruct(result)
        rst = result.data;
    else
        rst = result;
    end
    [life,row] = min(rst(:,end));
    node_coord = rst(row,2:4);
    
    StrFile = [path_str 'StrMtx_' LineNo '_' PartName '_' TorB '.csv'];
    fid1 = fopen(StrFile);
    if fid1 >-1
        Str = importdata(StrFile);
        status1 = fclose(fid1); 
        
        if isstruct(Str)
            StrMtrx = Str.data;
            header = Str.textdata;
        else
            StrMtrx = Str;
        end
    
        data1 = StrMtrx( ( abs(StrMtrx(:,2) - node_coord(1)) < tol_length),: );
        data2 = data1( ( abs(data1(:,3) - node_coord(2)) < tol_angle),: );
        data3 = data2( ( abs(data2(:,4) - node_coord(3)) < tol_length),: );
    
        OutFile = [path_out LineNo '_' PartName '_' TorB '_StrMtx.csv'];
        csvwrite(OutFile,data3)
        
    end    
end
end
