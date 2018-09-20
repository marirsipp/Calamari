function[x_dat,y_dat] = fig2data(FigName)

% Extract data from .fig plots, for line plots only (for now)
% Extraced data is stored in cell array x_dat and y_dat, in the order of
% line 1 to line n of subplot(1), line 1 to line n of subplot(2), etc..
% Written by Bingbin Yu and Sam Kanner 
% Copyright Principle Power inc. 2016

%Input
%FigName - file name of the figure

open(FigName)

h = gcf;
axesObjs = get(h, 'Children');  %axes handles
dataObjs = get(axesObjs, 'Children'); %handles to low-level graphics objects in axes
if iscell(dataObjs)
    nPlots=length(dataObjs);
    dataNum=[];
    for jj=1:nPlots
        dataNum=[dataNum; dataObjs{jj,1}];
    end
else
    dataNum=dataObjs;
end
nLines=length(dataNum);
for ii=1:nLines
    objTypes = get(dataNum(ii), 'Type');  %type of low-level graphics object
    try
        ixd=get(dataNum(ii), 'XData');
    catch
        ixd=[];
    end
    if length(ixd)>=2
        if nLines<2
           xdata = ixd;  %data from low-level grahics objects
           ydata = get(dataNum(ii), 'YData');
        else
            xdata{ii} = ixd;  %data from low-level grahics objects
            ydata{ii} = get(dataNum(ii), 'YData');
            
        end
    end
end
if sum(cellfun(@(x) isempty(x),xdata))>1
    iemptys=cellfun(@(x) isempty(x),xdata);
    xdata=xdata(logical(~iemptys));
    ydata=ydata(logical(~iemptys));
end

x_dat = fliplr(xdata);
y_dat = fliplr(ydata);
    
end