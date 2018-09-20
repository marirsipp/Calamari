function plotWithBars(OutS,runs2plot,vars2plot,seedvar, dlcnums,figdir,lstrs,divis,h2s,iText,varargin)
%OutS is the structure of all the data
% runs2plot is a numerical array of the family names to plotclose 
% vars2plot is a cell array of the variable names to plot
% seedvar is the cell array of the variable that was used for seed
% selection
%dlcnums is an array of three-digit number corresponding to the DLC number and the
%family number, which is just used for labeling purposes or could just be a
%cell array with a string for the title of the plots
%figdir is a string corresponding to where the figures should be saved: figdir='\\SUP\Longboard\SUP\WFJ_Hitachi5MW\Statistics\Figs\LikeSam\';
%h2s='max'; %if 'COLtrack' is the variable name, then this is set to min
colors={[0 0 0],[.8 0 0],[0 0 .8],[0 .8 0]};
nS=length(OutS);
nHead=7;
nVars=length(vars2plot);
if ~iscell(h2s)
    h2s={h2s};
end
if nargin<7
    for jj=1:nS
        lstrs{jj}=sprintf('Run %d',jj);
    end
    divis=ones(1,nVars);
    h2s=repmat({'max'},[1 nVars]);
    iText=0;
elseif nargin<8
    divis=ones(1,nVars);
    h2s=repmat({'max'},[1 nVars]);
    iText=0;
elseif nargin<9
     h2s=repmat({'max'},[1 nVars]);
     iText=0;
elseif nargin<10
    iText=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT STATISTICS
txtstr='';
if iText
    txtstr='Txt';
end
for j=1:nVars
    variable=vars2plot{j};
    ylabelstr=getSeedLabel(variable);
    jdiv=divis(j);
    jvar=seedvar{j};
    % replace units string with blank if divisor is specified
    if jdiv>1
        ylabelstr=regexprep(ylabelstr,'\((.*?)\)','(-)');
    end

    allrunames=fieldnames(OutS(1).(variable)); % some seed names in here
    if isempty(runs2plot)
        runs=allrunames;
    else
        runs=runs2plot;
    end
    nruns=length(runs);
    lf=1;
    if nruns<15
        lf=.5;
    end
    if ~strcmp(variable,'COLtrack') && ~strcmp(variable,'WEPtrack')
        %OutS(1).(variable).(allrunames{1})
        
        basevar = regexprep(variable,'\d*','');
        numvar = str2double(regexprep(variable,'\D',''));
        if any(cellfun('isempty',strfind({'ml', 'bar', 'baz'},basevar))) && ~isnan(numvar)
            basevar2plot = basevar;
            dirs=numvar;
        else
            basevar2plot = variable;
            if isfield(OutS(1).(basevar2plot).(allrunames{1}),'Mean')
               % the first run is OK         
                ndirs=length(OutS(1).(basevar2plot).(allrunames{1}).Mean);
                dirs=1:ndirs;
            else
               ndirs=ones(nruns,1);
               for pp=1:nruns
                    if isfield(OutS(1).(basevar2plot).(allrunames{pp}),'Mean')
                        ndirs(pp)=length(OutS(1).(basevar2plot).(allrunames{pp}).Mean);
                    end
               end
               ndirs=max(ndirs);
               dirs=1:ndirs;
            end
        end
        ndirs=length(dirs);                
        for l = dirs % could be 1, 1:3, 1:6
            if ndirs>1
                dirstr=sprintf('%d',l);
            else
                dirstr='';
            end
            figname=[variable dirstr];
            if isnumeric(dlcnums)
                figstr=sprintf('DLC_%1.1f',dlcnums);
                figstr= strrep(figstr,'.','-');
            else
                figstr=dlcnums;
            end
            h1=figure('Position',[0+15*j 0 800 800],'name',figname);
            hold all;
            maxvalue = zeros(1,length(runs));
            imin=0;
            imax=-9999;
            for ss=1:nS
                scol=colors{mod(ss-1,length(colors))+1}; %rotate through colors
                if nS>1
                    xshft=interp1([1:nS],linspace(-.15,.15,nS),ss);
                    estr='_comp';
                else
                    xshft=0;
                    estr='';
                end
                for ii=1:nruns
                    if ~isempty(jvar)
                        seedstr=['Seed' sprintf('%d',runs(ii)) h2s{j}];
                        if ~isfield(OutS(ss).(jvar),seedstr)
                            jvarXY = [jvar 'XY'];
                            jvarRXY = [jvar 'RXY'];
                            if isfield(OutS(ss).(jvarXY),seedstr) && l<=3
                                jvar=jvarXY;
                            elseif isfield(OutS(ss).(jvarRXY),seedstr) && l>3
                                jvar=jvarRXY;
                            else
                             error(['Please run seedSelection_BATCH script with ' jvar ' used as one of the vars2seed for ' sprintf('%d',runs(ii))])                               
                            end
                        end
                        runnum = OutS(ss).(jvar).(seedstr);
                        if ~isnan(runnum)
                            runstrtmp=['Run' sprintf('%d',runnum)];
                        else
                            runstrtmp=['Run' sprintf('%d',runs(ii))];
                        end
                    else
                        runstrtmp=runs{ii};
                        nHead=5; % OVERWRITE nHead 
                    end
                    if isfield(OutS(ss).(variable),runstrtmp)
                        maxvalue(ii)=OutS(ss).(variable).(runstrtmp).Max(l);
                    else
                        maxvalue(ii)=nan;
                    end
                end
                if strcmp(variable,'basebendRXY')
                  %  jdiv=jdiv*max(maxvalue);
                end
                for ii=1:nruns
                    if ~isempty(jvar)
                        seedstr=['Seed' sprintf('%d',runs(ii)) h2s{j}];
                        runnum = OutS(ss).(jvar).(seedstr);
                        if ~isnan(runnum)
                            runstr{ii}=['Run' sprintf('%d',runnum)];
                        else
                            runstr{ii}=['Run' sprintf('%d',runs(ii))];
                        end
                    else
                        runstr{ii}=runs{ii};
                        nHead=5; % OVERWRITE nHead 
                    end

                    if isfield(OutS(ss).(basevar2plot),runstr{ii})
                        mymin=OutS(ss).(basevar2plot).(runstr{ii}).Min(l)/jdiv;
                        mymax=OutS(ss).(basevar2plot).(runstr{ii}).Max(l)/jdiv;
                        mymean=OutS(ss).(basevar2plot).(runstr{ii}).Mean(l)/jdiv;

                        if isfield(OutS(ss).(basevar2plot).(runstr{ii}),'Std')
                            mystd=OutS(ss).(basevar2plot).(runstr{ii}).Std(l)/jdiv; %---> is this a legal math operation? 
                        else
                            mystd=nan;
                        end
                    else
                        mymin=nan;
                        mymax=nan;
                        mymean=nan;
                        mystd=nan;
                    end
                    if strcmp(basevar2plot,'motions') && l==6
                        if mymax <-270
                            mymax=mymax+360;
                        elseif mymax>360
                            mymax=mymax-360;
                        end
                        if mymin<-270
                            mymin=mymin+360;
                        elseif mymin>360
                            mymin=mymin-360;
                        end
                        if mymean<-270
                            mymean=mymean+360;
                        elseif mymin>360
                            mymean=mymean-360;
                        end
                    end
                    imin=min([imin mymin]); %track the min, ignores nans
                    imax =max([imax mymax]); %track the min
                    if ~isnan(mymax)
                        line([ii-.3*lf ii+.3*lf]+xshft,[mymin mymin],'linewidth',3,'color',scol)
                        line([ii-.25*lf ii+.25*lf]+xshft,[mymean mymean],'linewidth',6,'color',scol)
                        line([ii-.3*lf ii+.3*lf]+xshft,[mymax mymax],'linewidth',3,'color',scol)
                        if strcmp(basevar2plot,'MaxAnchorEffT')
                            text(ii-.3*lf+xshft,mymax*1.03,sprintf('ML%d',OutS(ss).(basevar2plot).(runstr{ii}).MaxLine))
                        end
                        if exist('mystd','var')
                            line([ii ii]+xshft,[mymean mymean+mystd],'linewidth',4,'color',scol)
                            line([ii ii]+xshft,[mymean mymean-mystd],'linewidth',4,'color',scol)
                        end
                        line([ii ii]+xshft,[mymean mymax],'linewidth',2,'color',scol)
                        line([ii ii]+xshft,[mymean mymin],'linewidth',2,'color',scol)
                        if iText
                           text(ii+xshft,mymin*1.05,sprintf('Min = %2.2E',mymin));
                           text(ii+xshft,mymax*1.05,sprintf('Max = %2.2E',mymax)); 
                           text(ii+xshft,mymean*1.05,sprintf('Mean = %2.2E',mymean));
                           if exist('mystd','var')
                               text(ii+xshft,(mymean+mystd)*1.05,sprintf('Std = %2.2E',mystd))
                           end
                        end
                    else
                        text(ii,imin,'No data')
                    end
                end

                title([variable ' ' dirstr])
            end
            nmax = floor(log(abs(imax))./log(10)); %order of magnitude of max val
            xmin=0; xmax=ii+.5; 
            ymin=floor( (imin-abs(imin)*.1)/10^nmax)*10^nmax ;
            ymax=ceil( (imax+abs(imax)*.1)/10^nmax)*10^nmax;
            yint=round(ymax/10^nmax);
            Dy=abs((ymax-ymin)/yint); %how to ensure I go through 0??!
            divs=[2 5 10];
            dyint= divs- (10-yint);
            dyint(dyint<0)=nan;
            [foo,idiv]=min(dyint);
            dy=Dy/divs(idiv);
            axis([xmin xmax ymin ymax])
            newdirs=.5:nHead:ii;
            alldirs=setdiff(.5:.5:ii,newdirs);
            ndlcs=nruns/nHead;
            if strcmp(basevar2plot,'naccel')
                %ymax=3; ymin=-3;
                % line([0 nruns],[5 5],'linewidth',2,'color','k')
                % text(nruns/2,4.8, 'Within Turbine Specifications')
                % line([0 nruns],-1*[5 5],'linewidth',2,'color','k')
                % text(nruns/2,-4.8, 'Within Turbine Specifications')
                %set(gca,'ylim',[ymin ymax])
            end
            if ymin<0
                ly=1;
            else
                ly=.7;
            end
            for ii=1:nruns
                if ~isempty(jvar)
                    seedstr=['Seed' sprintf('%d',runs(ii)) h2s{j}];
                    if isfield(OutS(ss).(jvar),seedstr)
                        runnum = OutS(ss).(jvar).(seedstr);
                    else
                        runnum=nan;
                    end
                   if ~mod(ii,nHead)
                    % we are at the end of a DLC fam
                        dlcstr=getdlclabel(runnum);
                        rectangle('pos',[ii-nHead+(1/ndlcs)*5.9, ymax- (ymax-ymin)*ly*.125, ndlcs*1,(ymax-ymin)*ly*.08],'facecolor','w','edgecolor','k')
                        for pp=1:length(dlcstr)
                            text(ii-nHead+(1/ndlcs)*6.05,ymax- (ymax-ymin)*ly*.13 + (ymax-ymin)*ly*.025*pp,dlcstr{pp},'fontsize',7)
                        end
                   end
                end
            end
            %ymax*(1-ly*(2.7+ly))
            runstr=strrep(runstr,'_','-');
            gridxy(alldirs,ymin:dy:ymax,'linestyle',':','linewidth',.5)
            gridxy(newdirs,ymin:Dy:ymax,'linestyle','--','linewidth',.5)
            set(gca,'xtick', 1:length(runs), 'XtickLabel', runstr,'fontsize',6)
            rotateXLabels(gca, 60)
            ylabel(ylabelstr{l})
            if nS>1
                if ymax<0 && ymin<0
                    ymult=.2;
                    ylmult=.03;
                    yimult=.05;
                elseif ymax>0 && ymin<0
                    ymult=.1;
                    ylmult=.06;
                    yimult=.02;
                else
                    ymult=.2;
                    ylmult=.02;
                    yimult=.03;
                end
                leg_pos=[nruns*.67,ymax-ymult*(ymax-ymin),ii/3,(ymax-ymin)*.08];
                hr=rectangle('position',leg_pos,'facecolor','w','edgecolor','k');
                hl=[leg_pos(1)+0.5, leg_pos(2)+(ymax-ymin)*yimult];
                for ss=1:nS
                %create legend
                    line([hl(1) hl(1)+nruns*3/100], [hl(2) hl(2)],'color',colors{ss},'linewidth',2 )
                    text(hl(1)+nruns*6/100,hl(2),lstrs{ss})
                    hl=hl+[0 ymax*ylmult];
                end
            end
            pause
            fullname=[figdir,  figstr  '_' figname, estr, txtstr ];
            if ~exist(figdir,'dir')
                mkdir(figdir)
            end
            saveas(h1,[fullname '.fig'])
            %try
            %    export_fig([figdir,  figstr  '_' figname, estr '.png'],'-png','-r300',h1)
            %catch
             %   disp('Download GS at ghostscript.com to get prettier pictures')
                print(h1,'-dpng',[fullname '.png'],'-r300')
                crop([fullname '.png'])
            %end
            
        end
    else
        %% COLtrack or WEPtrack
        if strcmp(variable,'COLtrack')
            lineStr='COL Center';
            ylabelstr='Water Height Below Center of Column (m)';
        elseif strcmp(variable,'WEPtrack')
            lineStr='WEP';
            ylabelstr='Water Height Below Worst Point on WEP (m)';
        end
        figname=[variable num2str(1)];
        if isnumeric(dlcnums)
            figstr=sprintf('DLC_%1.1f',dlcnums);
            figstr= strrep(figstr,'.','-');
        else
            figstr=dlcnums;
        end
        h1=figure('Position',[0+15*j 0 800 800],'name',figname);
        hold all; grid minor;
        colval=ones(1,length(runs));
        exval=nan(1,length(runs));
        for ii=1:length(runs)
            seedstr=['Seed' sprintf('%d',runs(ii)) h2s{j}];
            runnum = OutS.(jvar).(seedstr);
            runstr{ii}=['Run' sprintf('%d',runnum)];
            if isfield(OutS.(variable),runstr{ii})
                if strcmp(h2s{j},'min')
                    allmins=OutS.(variable).(runstr{ii}).Min;
                    [exval(ii),colval(ii)]=min(allmins);
                elseif strcmp(h2s{j},'max')
                    allmaxs=OutS.(variable).(runstr{ii}).Max;
                    [exval(ii),colval(ii)]=max(allmaxs);                   
                end
            end
            exval(ii)=exval(ii)./jdiv;
            %colmean=mean( allmins( nProbe*(colval-1)+1: nProbe*(colval-1)+nProbe));
            plot(ii,exval(ii),'b.','MarkerSize',25)
            if iText
                ptstr=sprintf('%s %d %2.2E','Col',colval(ii),exval(ii));
            else
                ptstr= sprintf('%s %d %s','Col',colval(ii),'');
            end
            text(ii,exval(ii)*1.05,ptstr) 
            %text(ii,colmean*.95,sprintf('%s %d %s','Col',colval,'')) 
        end
        ymax=max([5 ceil(max(exval))]);
        ymin=min([-1 floor(min(exval))]);
        set(gca,'ylim',[ymin ymax]./jdiv); %2.2
        set(gca,'Ydir','reverse','xtick', 1:length(runs), 'XtickLabel', runstr, 'XLim', [1 length(runs)],'fontsize',5)
        rotateXLabels(gca, 60)
        line([0 ii],[0 0],'color','k','linewidth',2)
        text(ii/2,.1/2/jdiv,[lineStr ' Unsubmerged'],'color',[0 .8 0])
        text(ii/2,-.1/2/jdiv,[lineStr ' Submerged'],'color',[.8 0 0])
        %legend('Min','Mean')
        
        if jdiv>1
            ylabelstr=regexprep(ylabelstr,'\((.*?)\)','(-)');
        end
        ylabel(ylabelstr)
        fullname=[figdir, 'DLC_' figstr  '_' figname ];
        saveas(h1,[fullname '.fig'])
        print(h1,'-dpng',[fullname '.png'],'-r300')
        pause
        crop([fullname '.png'])
            
    end

end

end
function dlcstr=getdlclabel(runnum)
nmax = floor(log(abs(runnum))./log(10)); %order of magnitude of max val
dlc=floor(runnum/10^(nmax-3+1));
if dlc==160
    dlcstr={'Power Producing', 'V_{rated}', '1 yr storm'};
elseif dlc==130
    dlcstr={'Power Producing', 'V_{rated}', 'ETM, NSS'};
elseif dlc==140
    dlcstr={'Power Producing', 'V_{rated}', 'EDC, NSS'};
elseif dlc==150
    dlcstr={'Power Producing', 'V_{rated}', 'EWSH, NSS'};
elseif dlc==210
    dlcstr={'Power Producing', 'V_{rated}', 'Fault of Control System (-)'};
elseif dlc==220
    dlcstr={'Power Producing', 'V_{rated}', 'Fault of Protection System (-)'};  
elseif dlc==320
    dlcstr={'Start-up at V_{rated}', 'EOG', 'NSS'};
elseif dlc==330
    dlcstr={'Start-up at V_{rated}', 'EDC', 'NSS'};
elseif dlc==420
    dlcstr={'Turbine normal shutdown', 'Vrated EOG', 'NSS'};
elseif dlc==430
    dlcstr={'Turbine normal shutdown', 'Vrated', '1 yr storm'};
elseif dlc==511
    dlcstr={'Turbine Shutdown', 'Vrated', '1 yr storm'};
elseif dlc==510
    dlcstr={'Turbine Shutdown', 'Vrated', 'Normal Sea-State'};
elseif dlc==520
    dlcstr={'Turbine Shutdown', 'Vrated', '1 yr storm'};
elseif dlc==610
    dlcstr={'Turbine: Parked', '50-year storm', 'Aligned'};
elseif dlc==620 
    dlcstr={'Turbine: Parked', '50-year storm', '30 deg NacYaw'};
elseif dlc==621 
    dlcstr={'Turbine: Parked', '50-year storm', '60 deg NacYaw'};
elseif dlc==622 
    dlcstr={'Turbine: Parked', '50-year storm', '-30 deg NacYaw'};
elseif dlc==630
    dlcstr={'Turbine: Parked', '1-year storm', 'Yaw Error'};
elseif dlc==710
    dlcstr={'Turbine: Parked', '1-year storm', 'Ballast Fault (+)'}; 
elseif dlc==711
    dlcstr={'Turbine: Parked', '1-year storm', 'Ballast Fault (-)'}; 
elseif dlc==840
    dlcstr={'Turbine: Parked', 'Transport', '-'}; 
elseif dlc==320
    dlcstr={'Turbine: Startup', 'EOG', 'NSS'}; 
else
    dlcstr='';
end

end

