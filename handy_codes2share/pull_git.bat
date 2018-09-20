cd %HOMEPATH%\Documents\MATLAB\%1
"%ProgramFiles%\Git\bin\git.exe" diff > %HOMEPATH%\Documents\MATLAB\%1_last_diff.txt
for /f %%i in ("%HOMEPATH%\Documents\MATLAB\%1_last_diff.txt") do set size=%%~zi
if %size% gtr 0 ("%ProgramFiles%\Git\bin\git.exe" diff > %HOMEPATH%\Documents\MATLAB\%1_changes.txt 
"%ProgramFiles%\Git\usr\bin\date.exe" >> %HOMEPATH%\Documents\MATLAB\%1_changes_log.txt
"%ProgramFiles%\Git\bin\git.exe" diff >> %HOMEPATH%\Documents\MATLAB\%1_changes_log.txt 
set "modstr=Modified on "
) else (
set "modstr=Unchanged on ")
echo|set /P =%modstr% >> %HOMEPATH%\Documents\MATLAB\%1_log.txt
"%ProgramFiles%\Git\usr\bin\date.exe" >> %HOMEPATH%\Documents\MATLAB\%1_log.txt
"%ProgramFiles%\Git\bin\git.exe" reset --hard
"%ProgramFiles%\Git\bin\git.exe" pull 

timeout 2