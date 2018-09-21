function[] = plot2d_TopBtm_FatigLife (data,path,PartName,DotSize)
%Plots fatigue damage results of a part on both top and bottom surface
%Input:
%data - 1st column, element number
%     - 2nd column, x value (mm) of element centroid
%     - 3rd column, y value (mm) of element centroid
%     - 4th column, z value (mm) of element centroid
%     - 5th column, fatigue life on element top surface (year)
%     - 6th column, fatigue life on element bottom surface (year)
%path - path for saving the result
%PartName - name of the part
%DotSize - size of the data points in the figure

FigName1t = [path PartName '_Top'];
FigName1b = [path PartName '_Btm'];

figure(1)
scatter(data(:,2),data(:,3),DotSize,1./data(:,5),'filled')
axis equal
colorbar
title(['Annual Fatigue Damage - ' PartName ' - Top Surface'])
hgsave(FigName1t)

figure(2)
scatter(data(:,2),data(:,3),DotSize,1./data(:,6),'filled')
axis equal
colorbar
title(['Annual Fatigue Damage - ' PartName ' - Btm Surface'])
hgsave(FigName1b)

end