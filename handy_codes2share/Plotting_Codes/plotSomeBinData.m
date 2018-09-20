function plotSomeBinData(data2plot,bindataraw,met,figdir,ix,dirstr)
if nargin<5
    ix=1;
    dirstr='FROM';
elseif nargin<6
    dirstr='FROM';
end
if ix
    ixstr='';
else
    ixstr='NoX';
end
 [nbins,nd]=size(bindataraw);   
 biMod=0;
 Wavestr='';
 if nd>5
     biMod=1;
      Wavestr='Swell ';
 end
    figure(1)
    str1='$H_s$ vs $T_p$' ;
    clf
    plot(data2plot(:,2),data2plot(:,1),'k.')
    hold on
    tp1s=2:.01:10;
    hsbreak=(tp1s/1.4/7.07).^2*9.81;
    if ix
        plot(bindataraw(:,2),bindataraw(:,1),'rx',tp1s,hsbreak,'g-','MarkerSize',6,'linewidth',2)
        legend('Raw data','Centroids','breaking-wave limit')
        titlestr=sprintf('%s   , %d Bins',str1,nbins);
    else
        titlestr=sprintf('%s   ',str1);
    end
    
    grid on
    xlabel([Wavestr 'Wave Period (s)'])
    ylabel([Wavestr  'Wave Height (m)'])
    title(titlestr,'FontSize',12,'interpreter','latex','FontWeight','demi')
    print( [figdir sprintf('FatigueBins_HsTp_N%d%s',nbins,ixstr) '.png'],'-dpng','-r300')
    
    figure(2)
    str1='$V_{wind}$ (m/s)   vs  $\theta_{wind}$';
    clf
    if strcmp(dirstr,'FROM')
        winddir=data2plot(:,4)*pi/180;
        winddirx=bindataraw(:,4)*pi/180;
    elseif strcmp(dirstr,'TOWARDS')
        winddir=mod(data2plot(:,4)*pi/180 -pi,2*pi);
        winddirx=mod(bindataraw(:,4)*pi/180-pi,2*pi);
    end
    h1=polar(winddir,data2plot(:,5),'k.');
    hold on
    %h3=polar(met.all.vdir*pi/180,met.all.vspdhh,'b.');
    if ix
        h2=polar(winddirx,bindataraw(:,5),'rx');%,linewidth',2)
        set(h2,'MarkerSize',6)
        legend([h1 h2],{'Raw data', 'Centroids'})
        titlestr=sprintf('%s       , %s which the wind is blowing, %d Bins',str1,dirstr,nbins);
    else
        titlestr=sprintf('%s       , %s which the wind is blowing',str1,dirstr);
    end
    grid on
    hold off
    %xlabel('Wind Direction ') %(TOWARDS, in deg clockwise from North)'
    %ylabel('Wind Speed (m/s)')
    %set(gca,'ytick',[0 3 5:2:max(data2plot(:,5))],'xtick',[0:30:360],'xlim',[0 360])
    
    view([90 -90])
    %set(gca,'thetaticks',[0:45:315],'thetaticklabels',{'N','NE','E','SE','S','SW','W','NW'})
    ht=title(titlestr,'FontSize',12,'interpreter','latex','FontWeight','demi');
    hAxes2=gca;
    axlimits=axis;
    currentAxesPosition=get(hAxes2,'Position'); % Get the axes' (polar plot) current position
    set(hAxes2,'Position',currentAxesPosition+[0 -0.04 0 0]);   % Shift that position downward
    title2=get(hAxes2,'Title'); % Get handle to the title object
    currentTitlePosition=get(title2,'Position');    % Get the title's current position
    set(title2,'Position',currentTitlePosition+[abs(axlimits(1))*.1 0 0]); % Shift the position upward
    %     Pt = get(ht,'Position')
%     set(ht,'Position',[Pt(1) Pt(2)+4 Pt(3)])
    print( [figdir sprintf('FatigueBins_VthV_N%d%s',nbins,ixstr) '.png'],'-dpng','-r300')

    figure(3)
    str1=['$H_{s}$   vs    $\theta_{' Wavestr '}$'];
    clf
    if strcmp(dirstr,'FROM')
        wavedir=data2plot(:,3)*pi/180;
        wavedirx=bindataraw(:,3)*pi/180;
    elseif strcmp(dirstr,'TOWARDS')
        wavedir=mod(data2plot(:,3)*pi/180 -pi,2*pi);
        wavedirx=mod(bindataraw(:,3)*pi/180-pi,2*pi);
    end
    h1=polar(wavedir,data2plot(:,1),'k.');
    hold on
    %polar(mod(met.all.wdir-180,360)*pi/180,met.all.Hs,'bo')
    if ix
        h3=polar(wavedirx,bindataraw(:,1),'rx');
        set(h3,'MarkerSize',6)
        legend('Raw data', 'Centroids')
         legend([h1 h3],{'Raw data', 'Centroids'})
        titlestr=sprintf('%s      , %s which the waves originate, %d Bins',str1,dirstr,nbins);
    else
        sprintf('%s      , %s which the waves originate',str1,dirstr);
    end
    grid on
    hold off
    %xlabel([Wavestr 'Wave Direction ']) %(TOWARDS, in deg clockwise from North)
    %ylabel([Wavestr  'Wave Height (m)'])
    %set(gca,'xtick',[0:30:360],'xlim',[0 360])
    
    view([90 -90])
    title(titlestr,'FontSize',12,'interpreter','latex','FontWeight','demi')
        hAxes2=gca;
    axlimits=axis;
    currentAxesPosition=get(hAxes2,'Position'); % Get the axes' (polar plot) current position
    set(hAxes2,'Position',currentAxesPosition+[0 -0.04 0 0]);   % Shift that position downward
    title2=get(hAxes2,'Title'); % Get handle to the title object
    currentTitlePosition=get(title2,'Position');    % Get the title's current position
    set(title2,'Position',currentTitlePosition+[abs(axlimits(1))*.1 0 0]); % Shift the position upward
    print( [figdir sprintf('FatigueBins_HsWth_N%d%s',nbins,ixstr) '.png'],'-dpng','-r300')

    figure(4)
    str1=['$V_{wind}$   vs   $H_{s ' Wavestr '}$'];
    clf
    plot(data2plot(:,1),data2plot(:,5),'k.')
    hold on
    if ix
        plot(bindataraw(:,1),bindataraw(:,5),'rx','MarkerSize',6,'linewidth',2)
        legend('Raw data', 'Centroids')
        titlestr=sprintf('%s    , %d Bins',str1,nbins);
    else
        sprintf('%s    ',str1);
    end
    grid on
    hold off
    ylabel('Wind Speed (m/s)')
    set(gca,'ytick',[0 3 5:2:max(data2plot(:,5))])
    xlabel([Wavestr  'Wave Height (m)'])
    
    title(titlestr,'FontSize',12,'interpreter','latex','FontWeight','demi');
    print( [figdir sprintf('FatigueBins_VspdHs_N%d%s',nbins,ixstr) '.png'],'-dpng','-r300')
    
    figure(5)
    str1=['$H_{s' Wavestr '}$ (m)   vs $\theta_{wind}$'];
    clf
    h1=polar(winddir,data2plot(:,1),'k.');
    hold on
    if ix
        h3=polar(winddirx,bindataraw(:,1),'rx');
        set(h3,'MarkerSize',6)
        legend([h1 h3],{'Raw data', 'Centroids'})
        titlestr = sprintf('%s     , %s which the wind is blowing, %d Bins',str1,dirstr,nbins);
    else
        titlestr=sprintf('%s     , %s which the wind is blowing',str1,dirstr);
    end
    grid on
    hold off
    %xlabel('Wind Direction ') %(TOWARDS, in deg clockwise from North)
    %ylabel([Wavestr  'Wave Height (m)'])
    %set(gca,'xtick',[0:30:360],'xlim',[0 360])
    
    view([90 -90])
    title(titlestr,'FontSize',12,'interpreter','latex','FontWeight','demi')
        hAxes2=gca;
    axlimits=axis;
    currentAxesPosition=get(hAxes2,'Position'); % Get the axes' (polar plot) current position
    set(hAxes2,'Position',currentAxesPosition+[0 -0.04 0 0]);   % Shift that position downward
    title2=get(hAxes2,'Title'); % Get handle to the title object
    currentTitlePosition=get(title2,'Position');    % Get the title's current position
    set(title2,'Position',currentTitlePosition+[abs(axlimits(1))*.1 0 0]); % Shift the position upward
    print( [figdir sprintf('FatigueBins_HsVth_N%d%s',nbins,ixstr) '.png'],'-dpng','-r300')
    
%     figure(6)
%     clf
%     h1=plot(data2plot(:,3),data2plot(:,4),'k.');
%     hold on
%     plot(bindataraw(:,3),bindataraw(:,4),'rx','MarkerSize',6,'linewidth',2)
%     legend('Raw data', 'Centroids')
%     grid on
%     hold off
%     ylabel('Wave direction (deg)')
%     set(gca,'ytick',[0:30:360])
%     set(gca,'xtick',[0:30:360])
%     xlabel('Wind direction (deg)')
%     str1=['$\theta_{wave,' Wavestr '}$   vs $\theta_{wind}$'];
%     title(sprintf('%s    , %d Bins',str1,nbins),'FontSize',12,'interpreter','latex','FontWeight','demi')
%     print( [figdir sprintf('FatigueBins_WthvVth_N%d',nbins) '.png'],'-dpng','-r300')
    
    
    if isfield(met,'chop') && size(bindataraw,2)>5
        figure(6)
        clf
        plot(met.chop.Tp,met.chop.Hs,'k.')
        hold on
        plot(bindataraw(:,7),bindataraw(:,6),'rx','MarkerSize',6,'linewidth',2)
        legend('Raw data', 'Centroids')
        grid on
        hold off
        xlabel('Wind-Wave Period (s)')
        ylabel('Wind-Wave Height (m)')
        %set(gca,'xtick',[0:30:360],'xlim',[0 360])
        str1='$H_{s,wind}$    vs $T_{p,wind}$';
        title(sprintf('%s     , %d Bins',str1,nbins),'FontSize',12,'interpreter','latex','FontWeight','demi')
        print( [figdir sprintf('FatigueBins_WTpWHs_N%d',nbins) '.png'],'-dpng','-r300')

       
        figure(7)
        clf
        plot(met.chop.wdir,met.all.vdir,'k.')
        hold on
        plot(bindataraw(:,8),bindataraw(:,4),'rx','MarkerSize',6,'linewidth',2)
        legend('Raw data', 'Centroids')
        grid on
        hold off
        xlabel('Wind-Wave Direction (deg)')
        ylabel('Wind Direction (deg)')
        set(gca,'xtick',[0:45:360],'xlim',[-45 360])
        str1='$\theta_{wind-wave}$    vs $\theta_{wind}$';
        title(sprintf('%s     , %d Bins',str1,nbins),'FontSize',12,'interpreter','latex','FontWeight','demi')
        print( [figdir sprintf('FatigueBins_WthVth_N%d',nbins) '.png'],'-dpng','-r300')    

        figure(8)
        clf
        plot(met.all.vspdhh,met.chop.Hs,'k.')
        hold on
        plot(bindataraw(:,5),bindataraw(:,6),'rx','MarkerSize',6,'linewidth',2)
        legend('Raw data', 'Centroids')
        grid on
        hold off
        xlabel('Wind Speed (m/s)')
        ylabel('Wind-Wave Height (m)')
        set(gca,'xtick',[0 3:2:max(data2plot(:,5))])
        %set(gca,'xtick',[0:30:360],'xlim',[0 360])
        str1='$V_{wind,hh}$    vs $H_{s,wind}$';
        title(sprintf('%s     , %d Bins',str1,nbins),'FontSize',12,'interpreter','latex','FontWeight','demi')
        print( [figdir sprintf('FatigueBins_VspdWHs_N%d',nbins) '.png'],'-dpng','-r300')

        figure(9)
        clf
        plot(met.all.vspdhh,met.chop.Tp,'k.')
        hold on
        plot(bindataraw(:,5),bindataraw(:,7),'rx','MarkerSize',6,'linewidth',2)
        legend('Raw data', 'Centroids')
        grid on
        hold off
        xlabel('Wind Speed (m/s)')
        ylabel('Wind-Wave Period (s)')
        %set(gca,'xtick',[0 3:2:max(data2plot(:,5))])
        %set(gca,'xtick',[0:30:360],'xlim',[0 360])
        str1='$V_{wind,hh}$    vs $T_{p,wind}$';
        title(sprintf('%s     , %d Bins',str1,nbins),'FontSize',12,'interpreter','latex','FontWeight','demi')
        print( [figdir sprintf('FatigueBins_VspdWTp_N%d',nbins) '.png'],'-dpng','-r300')

    end
    if isfield(met.all,'Uspd')
    figure(10)
    str1=['$U_{cur' '}$ (m)   vs $\theta_{cur}$'];
    clf
    h1=polar(met.all.Udir,met.all.Uspd,'k.');
    hold on
    if ix && size(bindataraw,2)>5
        h3=polar(bindataraw(:,6),bindataraw(:,7),'rx');
        set(h3,'MarkerSize',6)
        legend([h1 h3],{'Raw data', 'Centroids'})
        titlestr = sprintf('%s     , %s which the current is flowing, %d Bins',str1,dirstr,nbins);
    else
        titlestr=sprintf('%s     , %s which the current is flowing',str1,dirstr);
    end
    grid on
    hold off
    %xlabel('Wind Direction ') %(TOWARDS, in deg clockwise from North)
    %ylabel([Wavestr  'Wave Height (m)'])
    %set(gca,'xtick',[0:30:360],'xlim',[0 360])
    
    view([90 -90])
    title(titlestr,'FontSize',12,'interpreter','latex','FontWeight','demi')
        hAxes2=gca;
    axlimits=axis;
    currentAxesPosition=get(hAxes2,'Position'); % Get the axes' (polar plot) current position
    set(hAxes2,'Position',currentAxesPosition+[0 -0.04 0 0]);   % Shift that position downward
    title2=get(hAxes2,'Title'); % Get handle to the title object
    currentTitlePosition=get(title2,'Position');    % Get the title's current position
    set(title2,'Position',currentTitlePosition+[abs(axlimits(1))*.1 0 0]); % Shift the position upward
    print( [figdir sprintf('FatigueBins_UspdUth_N%d%s',nbins,ixstr) '.png'],'-dpng','-r300')
     
        
    end
end

%function plotSomeBinData(figdir,binN,data2plot,bindataraw)


% nbins=length(binN);
% %Plot 2D stuff
% figure(1)
% clf
% plot(data2plot(:,2),data2plot(:,1),'k.')
% hold on
% plot(bindataraw(:,2),bindataraw(:,1),'rx','MarkerSize',8,'linewidth',2)
% legend('Raw data', 'Centroids')
% grid on
% xlabel('Significant Wave Period (s)')
% ylabel('Significant Wave Height (m)')
% str1='$H_s$ vs $T_p$' ;
% title(sprintf('%s, %d Bins',str1,nbins),'FontSize',12,'interpreter','latex','FontWeight','demi')
% print( [figdir sprintf('FatigueBins_HsTp_N%d',nbins) '.png'],'-dpng','-r300')
% figure(2)
% clf
% plot(data2plot(:,4),data2plot(:,5),'k.')
% hold on
% plot(bindataraw(:,4),bindataraw(:,5),'rx','MarkerSize',8,'linewidth',2)
% legend('Raw data', 'Centroids')
% grid on
% hold off
% xlabel('Wind Direction (deg)')
% ylabel('Wind Speed (m/s)')
% str1='$V_{wind}$ vs $\theta_{wind}$';
% title(sprintf('%s, %d Bins',str1,nbins),'FontSize',12,'interpreter','latex','FontWeight','demi')
% print( [figdir sprintf('FatigueBins_VthV_Pt%s_N%d',strl,nbins) '.png'],'-dpng','-r300')
% figure(3)
% clf
% plot(data2plot(:,3),data2plot(:,1),'k.')
% hold on
% plot(bindataraw(:,3),bindataraw(:,1),'rx','MarkerSize',8,'linewidth',2)
% legend('Raw data', 'Centroids')
% grid on
% hold off
% xlabel('Wind Direction-Wave Direction (deg)')
% ylabel('Wave Height (m)')
% str1='$H_{s}$ vs $\theta_{wave}$';
% title(sprintf('%s, %d Bins',str1,nbins),'FontSize',12,'interpreter','latex','FontWeight','demi')
% print( [figdir sprintf('FatigueBins_HsWth_N%d',nbins) '.png'],'-dpng','-r300')

%end