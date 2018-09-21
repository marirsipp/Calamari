clear
clc
heading = [0:30:330];
for j=1:length(heading)
h = heading(j);
filename = strcat('D:\Data\ANSYS\WFA_Models\Secondary_Structure\J_Tube\Sriram\Loads\WFA_NM_FIT_UD03_SOL\DLC 8.4\AllAngles_',num2str(h),'.txt');
fileID = fopen(filename);
C = textscan(fileID,' %f %f %f %f %f %f %f %f %f %f %f');
fclose(fileID);
MaxDecCable1 = max(abs(C{1,2}));
MaxAzimCable1 = max(abs(C{1,3}));
MaxTenCable1 = max(abs(C{1,6}));
MaxDecCable2 = max(abs(C{1,7}));
MaxAzimCable2 = max(abs(C{1,8}))
MaxTenCable2 = max(abs(C{1,11}));
for i=1:length(C{1,2})
    Deccheck1 = C{1,2}(i);
    if Deccheck1 == max(abs(C{1,2}))
    MaxDecCable1Tens= C{1,6}(i)
    MaxDecCable1Azim = C{1,3}(i)
    end
end
j
MaxDec1(j,1) = h;
MaxDec1(j,2) = MaxDecCable1;
MaxDec1(j,3) = MaxDecCable1Azim;
MaxDec1(j,4) = MaxDecCable1Tens;
for i=1:length(C{1,3})
    Azimcheck1 = C{1,3}(i);
    if Azimcheck1 == max(abs(C{1,3}))
    MaxAzimCable1Tens= C{1,6}(i)
    MaxAzimCable1Dec = C{1,2}(i)
    end
end
j
MaxAzim1(j,1) = h;
MaxAzim1(j,2) = MaxAzimCable1Dec;
MaxAzim1(j,3) = MaxAzimCable1;
MaxAzim1(j,4) = MaxAzimCable1Tens;
for i=1:length(C{1,6})
    tensioncheck1 = C{1,6}(i);
    if tensioncheck1 == max(abs(C{1,6}))
    MaxTenCable1Dec= C{1,2}(i)
    MaxTenCable1Azim = C{1,3}(i)
    end
end
MaxTen1(j,1) = h;
MaxTen1(j,2) = MaxTenCable1Dec;
MaxTen1(j,3) = MaxTenCable1Azim;
MaxTen1(j,4) = MaxTenCable1;

% Cable 2

for i=1:length(C{1,7})
    Deccheck2 = C{1,7}(i);
    if Deccheck2 == max(abs(C{1,7}))
    MaxDecCable2Tens= C{1,11}(i)
    MaxDecCable2Azim = C{1,8}(i)
    end
end
j
MaxDec2(j,1) = h;
MaxDec2(j,2) = MaxDecCable2;
MaxDec2(j,3) = MaxDecCable2Azim;
MaxDec2(j,4) = MaxDecCable2Tens;
for i=1:length(C{1,8})
    Azimcheck2 = C{1,8}(i);
    if Azimcheck2 == max(abs(C{1,8}))
    MaxAzimCable2Tens= C{1,11}(i)
    MaxAzimCable2Dec = C{1,7}(i)
    end
end
j
MaxAzim2(j,1) = h;
MaxAzim2(j,2) = MaxAzimCable2Dec;
MaxAzim2(j,3) = MaxAzimCable2;
MaxAzim2(j,4) = MaxAzimCable2Tens;
for i=1:length(C{1,11})
    tensioncheck2 = C{1,11}(i);
    if tensioncheck2 == max(abs(C{1,11}))
    MaxTenCable2Dec= C{1,7}(i)
    MaxTenCable2Azim = C{1,8}(i)
    end
end
MaxTen2(j,1) = h;
MaxTen2(j,2) = MaxTenCable2Dec;
MaxTen2(j,3) = MaxTenCable2Azim;
MaxTen2(j,4) = MaxTenCable2;


end
xlswrite('D:\Data\ANSYS\WFA_Models\Secondary_Structure\J_Tube\Sriram\MaxDec1.xlsx',MaxDec1);
xlswrite('D:\Data\ANSYS\WFA_Models\Secondary_Structure\J_Tube\Sriram\MaxTen1.xlsx',MaxTen1);
xlswrite('D:\Data\ANSYS\WFA_Models\Secondary_Structure\J_Tube\Sriram\MaxAzim1.xlsx',MaxAzim1);
xlswrite('D:\Data\ANSYS\WFA_Models\Secondary_Structure\J_Tube\Sriram\MaxDec2.xlsx',MaxDec2);
xlswrite('D:\Data\ANSYS\WFA_Models\Secondary_Structure\J_Tube\Sriram\MaxTen2.xlsx',MaxTen2);
xlswrite('D:\Data\ANSYS\WFA_Models\Secondary_Structure\J_Tube\Sriram\MaxAzim2.xlsx',MaxAzim2);