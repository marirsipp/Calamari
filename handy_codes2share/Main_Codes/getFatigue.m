function fatigue=getFatigue(IPTfile)
tic
dotm=strfind(IPTfile,'.m');
if ~isempty(dotm)
    IPTfile=IPTfile(1:dotm-1);
end
run(IPTfile);
fullPath=which(IPTfile);
if isempty(fullPath)
    fullPath=IPTfile;
end
if strcmp(fatType,'ML')
       fatigue=getMLfatigue(fullPath);
elseif strcmp(fatType,'TwrB')
      fatigue=getTwrBDEL4RunOF(fullPath); %evalin('caller',varname); %or 'base'
 
end
toc
end