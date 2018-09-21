function [] = BuildStrMtx (path, LineNo, PartName, TorB, Thk, DorA, SN)

    fileMx = [path,'NormStr\',LineNo,'_',PartName,'_',TorB,'_Mx','.csv'];
    fileMy = [path,'NormStr\',LineNo,'_',PartName,'_',TorB,'_My','.csv'];
    fileMz = [path,'NormStr\',LineNo,'_',PartName,'_',TorB,'_Mz','.csv'];

    fileFx = [path,'NormStr\',LineNo,'_',PartName,'_',TorB,'_Fx','.csv'];
    fileFy = [path,'NormStr\',LineNo,'_',PartName,'_',TorB,'_Fy','.csv'];
    fileFz = [path,'NormStr\',LineNo,'_',PartName,'_',TorB,'_Fz','.csv'];

    data=importfile1(fileFx);
    Nnode = size(data,1); %Total number of nodes
    StrMtx = zeros(Nnode,24);

    StrMtx(:,1:4) = data(:,1:4); %Node number, x-coord, y-coord, z-coord
    StrMtx(:,5) = Thk * ones(Nnode,1); %Thickness, mm
    StrMtx(:,24) = SN * ones(Nnode,1); %Thickness, mm
    
    if DorA == 0 %default local coordinate system, x is through thickness dir
        StrMtx(:,6) = data(:,6); %S_Y, MPa
        StrMtx(:,7) = data(:,7); %S_Z, MPa
        StrMtx(:,8) = data(:,9); %S_YZ, MPa
    else if DorA == 1 %z is through thickness direction
            StrMtx(:,6) = data(:,5); %S_X, MPa
            StrMtx(:,7) = data(:,6); %S_Y, MPa
            StrMtx(:,8) = data(:,8); %S_XY, MPa
        else if DorA == 2 %y is through thickness direction
                StrMtx(:,6) = data(:,5); %S_X, MPa
                StrMtx(:,7) = data(:,7); %S_Z, MPa
                StrMtx(:,8) = data(:,10); %S_XZ, MPa
            else
                disp('DorA value should be 0,1 or 2')
            end
        end
    end

    data=importfile1(fileFy);
    if DorA == 0 %default local coordinate system
        StrMtx(:,9) = data(:,6); %S_Y, MPa
        StrMtx(:,10) = data(:,7); %S_Z, MPa
        StrMtx(:,11) = data(:,9); %S_YZ, MPa
    else if DorA == 1 %alternative local coordinate system
            StrMtx(:,9) = data(:,5); %S_X, MPa
            StrMtx(:,10) = data(:,6); %S_Y, MPa
            StrMtx(:,11) = data(:,8); %S_XY, MPa
        else if DorA == 2 %y is through thickness direction
                StrMtx(:,9) = data(:,5); %S_X, MPa
                StrMtx(:,10) = data(:,7); %S_Z, MPa
                StrMtx(:,11) = data(:,10); %S_XZ, MPa
            else
                disp('DorA value should be 0,1 or 2')
            end
        end
    end

    data=importfile1(fileFz);
    if DorA == 0 %default local coordinate system
        StrMtx(:,12) = data(:,6); %S_Y, MPa
        StrMtx(:,13) = data(:,7); %S_Z, MPa
        StrMtx(:,14) = data(:,9); %S_YZ, MPa
    else if DorA == 1
            StrMtx(:,12) = data(:,5); %S_X, MPa
            StrMtx(:,13) = data(:,6); %S_Y, MPa
            StrMtx(:,14) = data(:,8); %S_XY, MPa
        else if DorA == 2 %y is through thickness direction
                StrMtx(:,12) = data(:,5); %S_X, MPa
                StrMtx(:,13) = data(:,7); %S_Z, MPa
                StrMtx(:,14) = data(:,10); %S_XZ, MPa
            else
                disp('DorA value should be 0,1 or 2')
            end
        end
    end

    data=importfile1(fileMx);
    if DorA == 0 %default local coordinate system
        StrMtx(:,15) = data(:,6); %S_Y, MPa
        StrMtx(:,16) = data(:,7); %S_Z, MPa
        StrMtx(:,17) = data(:,9); %S_YZ, MPa
    else if DorA == 1
            StrMtx(:,15) = data(:,5); %S_X, MPa
            StrMtx(:,16) = data(:,6); %S_Y, MPa
            StrMtx(:,17) = data(:,8); %S_XY, MPa
        else if DorA == 2 %y is through thickness direction
                StrMtx(:,15) = data(:,5); %S_X, MPa
                StrMtx(:,16) = data(:,7); %S_Z, MPa
                StrMtx(:,17) = data(:,10); %S_XZ, MPa
            else
                disp('DorA value should be 0,1 or 2')
            end
        end
    end

    data=importfile1(fileMy);
    if DorA == 0 %default local coordinate system
        StrMtx(:,18) = data(:,6); %S_Y, MPa
        StrMtx(:,19) = data(:,7); %S_Z, MPa
        StrMtx(:,20) = data(:,9); %S_YZ, MPa
    else if DorA == 1
            StrMtx(:,18) = data(:,5); %S_X, MPa
            StrMtx(:,19) = data(:,6); %S_Y, MPa
            StrMtx(:,20) = data(:,8); %S_XY, MPa
        else if DorA == 2 %y is through thickness direction
                StrMtx(:,18) = data(:,5); %S_X, MPa
                StrMtx(:,19) = data(:,7); %S_Z, MPa
                StrMtx(:,20) = data(:,10); %S_XZ, MPa
            else
                disp('DorA value should be 0,1 or 2')
            end
        end
    end

    data=importfile1(fileMz);
    if DorA == 0 %default local coordinate system
        StrMtx(:,21) = data(:,6); %S_Y, MPa
        StrMtx(:,22) = data(:,7); %S_Z, MPa
        StrMtx(:,23) = data(:,9); %S_YZ, MPa
    else if DorA == 1
            StrMtx(:,21) = data(:,5); %S_X, MPa
            StrMtx(:,22) = data(:,6); %S_Y, MPa
            StrMtx(:,23) = data(:,8); %S_XY, MPa
        else if DorA == 2 %y is through thickness direction
                StrMtx(:,21) = data(:,5); %S_X, MPa
                StrMtx(:,22) = data(:,7); %S_Z, MPa
                StrMtx(:,23) = data(:,10); %S_XZ, MPa
            else
                disp('DorA value should be 0,1 or 2')
            end
        end
    end

    OutputName = [path,'StrMtrx\','StrMtx_',LineNo,'_',PartName,'_',TorB,'.csv'];
    csvwrite(OutputName,StrMtx)

end 