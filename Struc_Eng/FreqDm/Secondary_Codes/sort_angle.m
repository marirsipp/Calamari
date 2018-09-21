function[data_sort] = sort_angle(data, angle_min, angle_max)
%Sort fatigue life results based on the element angle value in a polar
%coord system
%Input:
%data - 1st column, element number
%     - 2nd column, x value (mm) of element centroid
%     - 3rd column, y value (mm) of element centroid
%     - 4th column, z value (mm) of element centroid
%     - 5th column, fatigue life on element top surface (year)
%     - 6th column, fatigue life on element bottom surface (year)
%     - 7th column, angle (rad) of element centroid
%angle_min - target minimum angle value (deg)
%angle_max - target maximum angle value (deg)

angle = data(:,7)/pi*180;
ind = (angle >= angle_min) & (angle <= angle_max);
data_sort = data(ind,:);

% m = 1;
% ElemNo = size(data,1);
% 
% for n=1:ElemNo
%     angle = data(n,7)/pi*180; 
%     if (angle >= angle_min) && (angle <= angle_max)
% 	   data_sort(m,:) = data(n,:);
% 	   m = m+1;
%     end
% end

end