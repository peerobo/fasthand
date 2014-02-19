set PATH=%PATH%;"C:\Program Files\7-Zip"
set DIRECTORY=%~dp0
set TPS_FOLDER=%DIRECTORY%remoteReady
cd "%TPS_FOLDER%"
for /d %%c in (*) do (
cd %TPS_FOLDER%\%%~nc
7z a -tzip -mx0 %%~nc.zip *.mp3
)
pause