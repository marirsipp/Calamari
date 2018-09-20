function hooray=ExecuteOF(outputdir,FlexOrFAST)
%TO DO: use Cyril's code to make runs in parallel?
%[runname,Turbine,Wind,Wave,Cur,Time]=readOFinpt(iptname);
%[outputdir]=CreateOFRun(datfile,inputdir,runname,Turbine,Wind,Wave,Cur,Time);
if FlexOrFAST==0
    model = ofxModel([outputdir 'primary.dat']);
    disp('Running OrcaFlex')
    try
        model.RunSimulation;
        model.SaveSimulation([outputdir 'primary.sim']);
        disp('Done Running OrcaFlex')
        hooray=1;
    catch
        %should be an error from OrcaFlex
        hooray=0;
    end
elseif FlexOrFAST==1 || FlexOrFAST==2
    homedir = cd(outputdir); %#ok<*MCCD> %Quick cd to FAST, then back after running
    [~,cmdout]=dos([outputdir 'Fast.exe'],'-echo');
    cd(homedir);
    istr=strfind(cmdout,'FAST terminated normally');
    if ~isempty(istr)
        hooray=1;
    else
        hooray=0;
    end
else
    error('What code do you want to run?')
end
end