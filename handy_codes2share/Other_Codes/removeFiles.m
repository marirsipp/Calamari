function removeFiles(basedir,filetype)
% basedir string of absolute folder location you want the files deleted
% (can be a root folder). the function will delete all files in the folder
% AND SUBFOLDERS with the file extension given by 'filetype'
% string of types of files to be deleted, such as '.sim'
if ~strcmp(basedir(end),filesep)
    basedir=[basedir filesep];
end
files=rdir([basedir '**' filesep '*' filetype]);
nf=length(files);
if isempty(nf)
    error(['No files found, check location for existence of ' filetype(2:end) 'files.'])
else
    disp(['Removing ' sprintf('%d',nf) ' files. Click to continue'])
    pause
end

for ii=1:nf
    fname=files(ii).name;
    disp(['Removed ' fname])
    delete(fname);
end
end