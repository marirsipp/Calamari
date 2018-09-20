%% save all figures!!!
function SaveAllFig(Dir)
figlist=findobj('type','figure');
% chosendir = uigetdir;
% figpath=[chosendir '\' Dir '\'];
figpath=Dir;
if ~exist(Dir,'dir')
    mkdir(figpath);
else
    disp('Fig directory exists. If file exists with same name it will get overwritten.')
    pause(1)
end
for ii=1:numel(figlist)
    ifig=figure(figlist(ii));
    figname=get(ifig,'name');
    if isempty(figname)
        figname=sprintf('figure%d',ifig);
    else
        figname=strrep(figname,' ','');
        figname=strrep(figname,'.','');
        figname=strrep(figname,',','_');
        figname=strrep(figname,':','-');
    end
    saveas(figlist(ii),[figpath filesep figname '.fig']);
    print (figlist(ii),'-deps', [figpath filesep figname '.eps']);
    print (figlist(ii),'-dpng', [figpath filesep figname '.png']);
    crop([figpath filesep figname '.png'])
end
