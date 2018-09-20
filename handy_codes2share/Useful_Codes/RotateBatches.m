function RotateBatches(RPath,WindDirs,nSeeds)
% Run this after PostFat
    %RPath = 'D:\Data\WindFloat Numerical Codes\WindFloat 6MW WFNEDO\ForFatigue\Results\';
    dirs= dir(RPath);
    nbins=0;
    %throw out files named .. and .
    ikeep=nan(length(dirs),1);
    for ii=1:length(dirs)
        if isempty(strfind(dirs(ii).name, '.dat'))
            ikeep(ii)=0;
        else
            ikeep(ii)=1;
            BinNum(ii)=str2double(dirs(ii).name(1:end-4));
        end
    end
    dirs=dirs(logical(ikeep));
    if length(WindDirs)~= length(dirs)
        error(['Length of Wind Vector must equal number of bins in ' RPath])
    end
    for ii = 1:length(dirs) % to number of batch
        datname=[RPath dirs(ii).name];
        BinStr=dirs(ii).name(1:end-4);
        BinNum=str2double(BinStr);
        if ~exist(datname,'file')
            warning(['Bin ' dirs(ii).name 'is missing from the results folder'])   
        else
            nbins=nbins+1;
            donebin(nbins)=BinNum;
            donestr{nbins}=BinStr;
            % not rotated
            fid = fopen(datname);
            x = fread(fid,'double');
            fclose(fid);
            y = reshape(x,nSeeds,length(x)/nSeeds)';
            eval(['run' BinStr '= y;'])
            %rotated
            x1=nan(size(y));
            x1(:,1:3) = Rotate2DMat(y(:,1:3), -(360-WindDirs(ii))*pi/180);
            x1(:,4:6) = Rotate2DMat(y(:,4:6), -(360-WindDirs(ii))*pi/180);
            x1(:,end)=y(:,end);
            %x1(:,6) = y(:,6) + WindDirs(ii); % WTF?!?!? Why add degrees to N-m?!?!
            eval(['rot' BinStr '= x1;']) %matlab is case-sensitive!
        end
    end
    save([RPath 'BatchNoR.mat'], 'run*')
    display(['successfully saved ' RPath 'BatchNoR.mat'])
    clearvars run*
    for ii = 1:nbins
        eval(['run' donestr{ii} '=' 'rot' donestr{ii} ';']) 
    end
    save([RPath 'Batch01.mat'], 'run*')
    display(['successfully saved ' RPath 'Batch01.mat'])
%     clearvars run*
%     R01Path = RPath;
%     for ii = 1:length(WindDirs) %create batch01 as a vector of the headings
%         fid = fopen([R01Path num2str(ii,'%.3d') '.dat']);
%         x = fread(fid,'double');
%         fclose(fid);
%         y = reshape(x,6,length(x)/6)';
% 
%         clearvars x y x1
%     end
    
end


