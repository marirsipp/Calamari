function RunOF_Queue(matname)
load(matname);
abort = 0; 
jj = 1;
start_time = now;
handle_wait = waitbar(0, 'Initializing...','CreateCancelBtn', 'abort = 1;','CloseRequestFcn',@my_closereq);
set(handle_wait, 'name', 'Running OrcaFAST...', 'units', 'normalized', 'Position', [.4,.4,.25,.15])

nruns = length(RunListX);
tid = tic;
for ii = 1: nruns
    General.iAgain=1;
        % check if you're running an RAOs
    iRunList=RunListX(ii);
    RunInfo=RunInfoX;
    while General.iAgain
        if ii == 1
            waitbar((ii-1)/nruns, handle_wait, sprintf('Run %i of %i... %3.0f%% Complete...', ii, nruns, (ii-1)/nruns*100));
        else
            hw=waitbar((ii-1)/nruns, handle_wait, sprintf('Run %i of %i... %3.0f%% Complete...\nPrevious run duration: %3.2f seconds. \nEstimated completion time: %s', ii, nruns,(ii-1)/nruns*100,toc(tid)/(ii-1),datestr(start_time + (now-start_time)/(jj-1)*nruns,'mmm dd, HH:MM:SS')),'CreateCancelBtn');
            if getappdata(hw,'canceling')
                break
            end
        end
        [~,General]=RunOF(RunInfo,iRunList);
        if General.iAgain
            oldRunname=General.RunName;
            RunNumsCell=regexp(General.RunName,'\d*','match');
            RunNums=cellfun(@str2num,cat(1,RunNumsCell));
            nIter=RunNums(2);
            iRunList.Runname=[General.RunName(1:end-1) num2str(nIter+1)];
        end
        jj = jj + 1;
    end
end
delete(handle_wait)
sprintf('Simulations completed at %s. Elapsed time: %3.2f seconds for %i runs. Average time of %3.2f seconds per run.', datestr(now, 'HH:MM:SS'), toc(tid), jj-1, toc(tid)/(jj-1))
clear handle_wait 
end