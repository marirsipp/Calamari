function OutTotal=combineStats(DLCfs,sdir)
%combines OutS files
%%hahahahahahah
matname='SeedStats_';
files = dir(sdir);
if ~strcmp(sdir(end),filesep)
    sdir=[sdir filesep];
end 
% get seed stats files
nmats=0;
for jj=1:length(files)
    if length(files(jj).name)>=length(matname)
        if strcmp(files(jj).name(1:length(matname)),matname) % we have a proper .mat file
            nmats=nmats+1;
            fmats(nmats)=str2double( files(jj).name(length(matname)+1:end-4) ); % take out .mat, bad memory allocation
        end
    end
end
for ii=1:length(DLCfs)
    if sum(DLCfs(ii)==fmats)
        DLCstr=sprintf('%d',DLCfs(ii));
        disp(['found DLC family mat file: ' matname DLCstr])
        load([sdir matname DLCstr '.mat']);
        if ii==1
            OutTotal=OutS;
        else
            % compare the variable names
            varNamesT=fieldnames(OutTotal);
            if isstruct(OutS)
                varNamesS=fieldnames(OutS);
                for jj=1:length(varNamesS)
                    if isfield(OutTotal,varNamesS{jj})
                        runNamesS=fieldnames(OutS.(varNamesS{jj}));
                        for kk=1:length(runNamesS)
                            OutTotal.(varNamesS{jj}).(runNamesS{kk})=OutS.(varNamesS{jj}).(runNamesS{kk});
                        end
                    end
                end
            end
        end
    else
        disp(['did not find DLC family mat file: ' matname DLCfs(ii) '. Moving on...'])
    end
end
end