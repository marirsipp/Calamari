function compareDecayTests(varargin)
%% Used after runDecayTest
% fname1 [string] = name of the first .dat file used in RunDecayTest
% fname2 [string] = name of the second .dat file used in RunDecayTest

%% TODO: improve code to have arbitrary number of input files
%% BEGIN User:
X_des=[1 NaN;10 NaN; 1  1; 1 1;1 1 ;1 NaN]; %dummy variable that mirrors in RunDecayTest
buoyname='Col1 U';% only used for flexible model
PtmType='WFA';
% END User
if nargin<3
    error('Please input a runname and a legend entry')
else
    fname1=varargin{1};
    legstr=varargin{nargin};
    nFiles=nargin-1;
end

isep=strfind(fname1,filesep);
maindir=fname1(1:isep(end-1));
%% Main Code
Ptfm=getMyPtfm(PtmType);
[nDof,nRuns]=size(X_des);
colorstr={[0 0 1], [1 0 1],[1 0 0],[0 1 0],[0 1 1],[.6 .6 0],[0 .6 .6],[.3 0 .3],[.6 0 .6]};
%pltstr={'k-','r-','b-','g-','m-','c-'};
for ii=1:nDof
    for jj=1:nRuns
        if ~isnan(X_des(ii,jj))
            for kk=1:nFiles
                simname=sprintf('_FreeDecay-%d_%d',ii,jj);
                %grab flex .sim
                %model = ofxModel([datfolder basename datname1 '.dat']);
                fname{kk}=[varargin{kk} simname '.sim'];
                model=ofxModel(fname{kk});
                general = model('general');
                Data(kk).tend=general.StageEndTime(end);
                [WindFloat,WindFloatType]=getWindFloatModel(model);
                if isempty(WindFloat)
                    WindFloat=model(buoyname);
                    disp(sprintf('Using Buoy: %s since a vessel was not found',WindFloat.Name))
                end
                position=[-2*Ptfm.Col.Lh/3 0 0];
                X1(1)=mean(getOFDisplacement(WindFloat,[0,.01],position, 1));
                X1(2)=mean(getOFDisplacement(WindFloat,[0,.01],position, 2));
                X1(3)=mean(getOFDisplacement(WindFloat,[0,.01],position, 3));
                %X1=[WindFloat.InitialX WindFloat.InitialY WindFloat.InitialZ];
                % take the displacement in the center of the triangle at the
                % MWL
                
                if ii<4
                    F=model('DecayForce');
                else
                    F=model('DecayMoment');
                end
                tFs=F.IndependentValue;
                Fs=F.DependentValue;
                tstop=max(tFs(Fs==0)); %find the latest time when the Force is zero
                Data(kk).X=getOFDisplacement(WindFloat,[tstop,Data(kk).tend],position-X1, ii);

                Data(kk).t = general.TimeHistory('Time',ofx.Period(tstop, Data(kk).tend));
            end

            h1=figure('name', 'Compare Free-Decay');
            xlstr='Time after Release (s)';
            if ii>3
                ylstr='Angular Displacement (deg)';
            else
                ylstr='Displacement (m)';
            end
            for kk=1:nFiles
                plot(Data(kk).t-Data(kk).t(1),Data(kk).X-mean(Data(kk).X),'color',colorstr{kk},'linestyle','-')
                hold on
            end
            hold off
            legend(legstr)
            xlabel(xlstr)
            ylabel(ylstr)
            %tf=min([Data(kk).tend-flexT(1) tend2-fastT(1)]);
            %xlim([0 tf]);
            title(['Free-Decay: Direction ' num2str(ii)])
            grid on
            saveas(h1,[maindir,'figs' filesep, simname(2:end) '.fig'])
            print(h1,'-dpng',[maindir, 'pngs' filesep simname(2:end) '.png'],'-r300')
        end
    end
end
end
% 
%             %grab FAST .sim
%             %model=ofxModel([fastfolder simname(2:end) filesep 'primary.dat']);
%             %fname_2=[fastfolder simname(2:end) filesep 'primary.sim'];
%             fname_2=[fname2 simname '.sim'];
%             model=ofxModel(fname_2);
%             general = model('general');
%             tend2=general.StageEndTime(end);
%             [WindFloat,WindFloatType]=getWindFloatModel(model);
%             if isempty(WindFloat)
%                 WindFloat=model(buoyname);
%                 disp(sprintf('Using Buoy: %s since a vessel was not found',WindFloat.Name))
%             end
%             %X2=[WindFloat.InitialX WindFloat.InitialY WindFloat.InitialZ];
%             % take the displacement in the center of the triangle at the
%             % MWL
%             X2(1)=mean(getOFDisplacement(WindFloat,[0,.01],position, 1));
%             X2(2)=mean(getOFDisplacement(WindFloat,[0,.01],position, 2));
%             X2(3)=mean(getOFDisplacement(WindFloat,[0,.01],position, 3));
%             position=[-2*Ptfm.Col.Lh/3 0 0]-X2;
%             if ii<4
%                 F2=model('DecayForce');
%             else
%                 F2=model('DecayMoment');
%             end
%             tF2s=F2.IndependentValue;
%             F2s=F2.DependentValue;
%             tstop2=max(tF2s(F2s==0)); %find the latest time when the Force is zero
%             fastX=getOFDisplacement(WindFloat,[tstop2,tend2],position, ii);
%             
%             fastT = general.TimeHistory('Time',ofx.Period(tstop2, tend2));
%             %[b,T]=getDecayResults(fastT,fastX,0);
% function [b,T]=getDecayResults(time,X,filt)
% iplot=0;
% [Xm,iM]=lmax(X,filt);
% [Xn,iN]=lmin(X,filt); % do we want to use the mins like Dominique?
% if iplot
%     plot(time,X,'k-',time(iM),Xm,'r+')
% end
% T=mean(diff(time(iM)));
% X1s=Xm(1:end-1); X2s=Xm(2:end); 
% dec=log(X1s./X2s);
% b=100*1./sqrt(1+(2*pi./dec).^2); % damping ratio as a percent of critical (b=100 is critical damping)
% end