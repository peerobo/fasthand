set DIRECTORY=%~dp0
set DIST=%DIRECTORY%..\bin\asset\textures\
cd "%DIST%"
del /f /q "*.pvr"
del /f /q "*.png"
pause