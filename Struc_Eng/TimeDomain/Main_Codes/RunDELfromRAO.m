function RunDELfromRAO(IPTfile)
run(IPTfile);
% run for certain Hs, Tp and Dir windows

for pp=1:length(Plfm_orient)
    disp(sprintf('-------------- PLATFORM ORIENTATION: %d deg--------------',Plfm_orient(pp)))

    %% STEP0.5: Create files/directories if they do not exist
    Run_Name = sprintf('Orient%03ddT%02dLt%ddTp%02d',Plfm_orient(pp),round(tstep*10),round(Length_Timeseries),round(dT_fine*10));
    newmatdir=[path_out filesep Run_Name];
    TBmatfile=[newmatdir filesep TBmatname];
    DELmatfile=[newmatdir filesep DELmatname];
    newfigdir = [newmatdir filesep figdir];
    %RAO_fname = ['RunRAO_Iteration' num2str(ItrNo) '_TWR_2m.csv'];
    if ~exist(newmatdir,'dir')
        mkdir(newmatdir)
    end
    % scatter Matname
    Scatter_matname = [ PrjctName '_' MetName '_Orient_' sprintf('%+04d',wP(pp)) '_ScatterTable.mat']; % to figure out what the WaveScatter matname is, see write2dScatterTable)

    if ~exist(DELmatfile,'file') || iRunRain
        %RAO_file = [path_out filesep RAO_fname];
        if ~exist(TBmatfile,'file') || iRunGenTbsLoads
            %% STEP1: Come up with a timeseries of a TwrBs load using IFFT of Output spectrum=RAO.^2*WaveScatter
            TBloads= GenRAObsTBloads(TBmatfile,RAO_matname,Scatter_matname,Plfm_orient(pp),tstep,Length_Timeseries,dT_fine,isave,isaveSpc);
            disp('Generated TwrBs timeseries Success!')
            %---------------------------------------------
        else
            disp(['Loading... ' TBmatfile])
            load(TBmatfile);
        end
    
        %% STEP2: Run setupCalDel for each non-empty environmental condition
        nWdir = length(TBloads);
        nBins=0;
        for nn = 1:nWdir
            nBins = nBins+length(TBloads(nn).Prob);
        end
        nDOF=7; % default is 6 + comboRXY
        DEL.Meq=nan(nDOF,nBins); DEL.Dmg=nan(nDOF,nBins); DEL.Wdmg=nan(nDOF,nBins); DEL.Hs=nan(1,nBins); DEL.Tp=nan(1,nBins); DEL.Hs=nan(1,nBins); DEL.Prob=nan(1,nBins); DEL.Wdir=nan(1,nBins);
        nBins=0;
        for nn = 1:nWdir
            nP = length(TBloads(nn).Prob);
            disp(sprintf('-------------- Running Rainflow Counting on %d bins in Wave Heading: %d-%d deg--------------',nP,TBloads(nn).Wdir1,TBloads(nn).Wdir2))
            for mm = 1:nP
                nBins=nBins+1;
                M= squeeze(TBloads(nn).TBload(mm,:,:));
                [Meq,Dmg]=setupCalDEL(M,Tfilt,RotAngle,tstep,MNcurve,Life_DEL,0,n_order);
                nDOF=size(Meq,1);
                DEL.Meq(:,nBins) = Meq(:,1); DEL.Dmg(:,nBins) =  Dmg(:,1) ; % save to struct array, don't use Tfilt
                DEL.Prob(nBins) = TBloads(nn).Prob(mm); DEL.Hs(nBins) = TBloads(nn).Hs(mm);  DEL.Tp(nBins) = TBloads(nn).Tp(mm);  DEL.Wdir(nBins) = TBloads(nn).Wdir; % transfer all bin data to smaller matfile
                DEL.Wdmg(:,nBins) = DEL.Dmg(:,nBins).* repmat(DEL.Prob(nBins),[nDOF 1]);
            end
        end
        TotDmg = sum(DEL.Wdmg,2); % [nDOF x 1]
        TotDEL = (TotDmg .* Life_DEL * MNcurve.Mu^MNcurve.m / MNcurve.N0) .^ (1/MNcurve.m); % [nDOF x 1]
        %% STEP2.5: Save it to a folder
        if isave
            save(DELmatfile,'DEL','TotDmg','TotDEL');
        end
    else
        disp(['Loading... ' DELmatfile])
        load(DELmatfile);
    end
    %---------------------------------------------
    %% STEP3: Plot the bin ranked bin data
    % creates 2 plots, 1 is based on 'weighted' data, taking into account the
    % probability of occurrence, the other is unweighted.
    if iplot
        close all
        RankDELfromRAO(DELmatfile);
        SaveAllFig(newfigdir);
    end
end
if iplot
    plotDELfromRAO([path_out filesep],DELmatname)
end
end


        %RAO_matfile = 'TwrRAO_2m.mat'; % hard-coded in ReadScatter, grrrr...
        %Wave_matfile = 'WaveScatter.mat'; % hard-coded in ReadScatter, grrrr...
        %% STEP1: Create Wave Scatter and RAO scatter .mat's if necssary
        %ReadScatterRAO(ItrNo, path_out, wave_file, RAO_file, read_scatter, read_RAO);
        %disp('Loaded RAO and Wave Scatter Success!')
        %---------------------------------------------
        
                %---------------------------------------------
        %% STEP3:  Set input parameters
        %path0=basefolder;
        %imat = 2; % like Vestas
        %file_pwr = 'Combine_BB_POWandPAR.mat'; % for imat = 2, name of file of basebend loads
        %prob_adjust = 'n'; %Use adjusted probability in DEL and dmg calculation (Vestas had 113%!!)
        %include_tran = 'n'; %Include transient cases or not, 'y' - yes, 'n' - no ()

        %TranTime = 0; %[sec] total transient time to take out in the beginning of simulation
        %CalRotMmt = 'y';% [logical] calculate DEL at a certain angle in local coordinates (project the bending moments onto an arbitrary axis)
        %CalFilter = 'n'; % [logical] whether or not to filter the time series before running rainflow counting
