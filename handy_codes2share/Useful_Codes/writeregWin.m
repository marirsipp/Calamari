% Write Values to the Windows Registry: 
%  writereg(rootkey,subkey,valname,value,...)
%
%  Example:
%  writeregWin7('HKEY_LOCAL_MACHINE','SOFTWARE\My Software, Inc.\AppName',...
%           'TextSetting','c:\0.txt',...
%           'NumSetting',1);
%
%  The following registry value types are used:
%    "REG_SZ": when value is a string.
%    "REG_DWORD": when value is an integer.
%  No other value types are supported.
%
%  See also: winqueryreg
%
%  Alex Nelson, August 29, 2007
%  Peter Nagy, August 6, 2011 (modification for Windows7 based on
%  Script Elevation PowerToys for Vista:
%  http://technet.microsoft.com/en-us/magazine/2007.06.utilityspotlight.aspx
%
%  This function was based on code available at:
%  www.compactech.com/forum/index.php?showtopic=241&mode=threaded&pid=590 
%
function writeregWin(rootkey,subkey,varargin)
  if mod(length(varargin),2)
    error('writereg:Value names and values must be in pairs');
  end
  tmpregfile = [getenv('TEMP') '\write_reg.reg']; 
  fp = fopen(tmpregfile,'wt'); 
  fprintf(fp,'Windows Registry Editor Version 5.00\n\n'); 
  fprintf(fp,'[%s\\%s]\n',rootkey,subkey);
  
  ii = 1;
  while ii<length(varargin) 
    valname =varargin{ii};
    value = varargin{ii+1};
    if ischar(value)                       % string value
      value = strrep(value,'\','\\');     %  escape backslashes
      vstr=sprintf('"%s"="%s"',valname,value);
    elseif isint(value) && value<2^32     % 32-bit integer values
      vstr=sprintf('"%s"=dword:%.8X',valname,value); % write as hexidecimal
    else
      error('Only values of type string or integer are supported');
    end
    ii=ii+2;
    fprintf(fp,'%s\n',vstr);
  end 
  fprintf(fp,'\n');
  fclose(fp); 
  
  winsys=system_dependent('getwinsys');
  c1=findstr(winsys,'Version');
  c2=findstr(winsys,'.');
  winversion=winsys(c1(1)+8:c2(1)-1);
  if str2double(winversion)>9
      elevatefile=[getenv('TEMP'),'\elevate.js'];
      fp=fopen(elevatefile,'wt');
      fprintf(fp,'if (WScript.Arguments.Length >= 1) {\n');
      fprintf(fp,'Application = WScript.Arguments(0);\n');
      fprintf(fp,'Arguments = "";\n');
      fprintf(fp,'for (Index = 1; Index < WScript.Arguments.Length; Index += 1) {\n');
      fprintf(fp,'if (Index > 1) {\n');
      fprintf(fp,'Arguments += " ";\n');
      fprintf(fp,'}\n');
      fprintf(fp,'Arguments += WScript.Arguments(Index);\n');
      fprintf(fp,'}\n');
      fprintf(fp,'new ActiveXObject("Shell.Application").ShellExecute(Application, Arguments, "", "runas");\n');
      fprintf(fp,'} else {\n');
      fprintf(fp,'WScript.Echo("Usage:");\n');
      fprintf(fp,'WScript.Echo("elevate Application Arguments");\n');
      fprintf(fp,'}\n');
      fclose(fp);
      doscmd=sprintf('wscript %s\\elevate.js regedit.exe /s %s',getenv('TEMP'),tmpregfile);
      dos(doscmd);
      delete(tmpregfile);
      delete(elevatefile);
  else
      doscmd=sprintf('C:\\windows\\regedit.exe /s %s', tmpregfile);
      dos(doscmd);
      delete(tmpregfile);
  end
     


% ISINT(A) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Returns 1 for entries in matrix which are integers, and 0 for entries
%  which are non-integer.
% Alex Nelson 12/18/03
function a = isint(A)
  a = A==fix(A);

