set DIRECTORY=%~dp0
set TPS_FOLDER=%DIRECTORY%remoteReady\
cd %TPS_FOLDER%
del /f /q /s "*.pvr"
del /f /q /s "*.png"
pause