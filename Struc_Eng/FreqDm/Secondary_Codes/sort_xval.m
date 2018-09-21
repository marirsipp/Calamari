function[data_sort] = sort_xval(data, xmin, xmax)
%Sort fatigue life results based on the element x value
%Input:
%data - 1st column, element number
%     - 2nd column, x value (mm) of element centroid
%     - 3rd column, y value (mm) of element centroid
%     - 4th column, z value (mm) of element centroid
%     - 5th column, fatigue life on element top surface (year)
%     - 6th column, fatigue life on element bottom surface (year)
%xmin - target minimum x value (mm)
%xmax - target maximum x value (mm)

ind = (data(:,2) >= xmin) & (data(:,2) <= xmax);
data_sort = data(ind,:);

% m = 1;
% ElemNo = size(data,1);
% for n=1:ElemNo
%     if (data(n,2) >= xmin) && (data(n,2) <= xmax)
% 	   data_sort(m,:) = data(n,:);
% 	   m = m+1;
%     end
% end

end