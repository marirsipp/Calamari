function moveLabel(ax,offset,hFig,hAxes)
    % get figure position
    posFig = get(hFig,'Position');

    % get axes position in pixels
    set(hAxes,'Units','pixels')
    posAx = get(hAxes,'Position');

    % get label position in pixels
    if ax=='x'
        set(get(hAxes,'XLabel'),'Units','pixels')
        posLabel = get(get(hAxes,'XLabel'),'Position');
    else
        set(get(hAxes,'YLabel'),'Units','pixels')
        posLabel = get(get(hAxes,'YLabel'),'Position');
    end

    % resize figure
    if ax=='x'
        posFigNew = posFig + [0 -offset 0 offset];
    else
        posFigNew = posFig + [-offset 0 offset 0];
    end
    set(hFig,'Position',posFigNew)

    % move axes
    if ax=='x'
        set(hAxes,'Position',posAx+[0 offset 0 0])
    else
        set(hAxes,'Position',posAx+[offset 0 0 0])
    end

    % move label
    if ax=='x'
        set(get(hAxes,'XLabel'),'Position',posLabel+[0 -offset 0])
    else
        set(get(hAxes,'YLabel'),'Position',posLabel+[-offset 0 0])
    end

    % set units back to 'normalized' and 'data'
    set(hAxes,'Units','normalized')
    if ax=='x'
        set(get(hAxes,'XLabel'),'Units','data')
    else
        set(get(hAxes,'YLabel'),'Units','data')
    end
end