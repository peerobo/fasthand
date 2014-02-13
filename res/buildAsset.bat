set DIRECTORY=%~dp0
set TPS_FOLDER=%DIRECTORY%asset\
set DIST=%DIRECTORY%..\bin\asset\textures\
cd "%TPS_FOLDER%"
for /d %%a in (*) do (
"C:\Program Files (x86)\CodeAndWeb\TexturePacker\bin\TexturePacker.exe" --texture-format png --sheet "%DIST%%%~na@4x.png" --data "%DIST%%%~na@4x.xml" --format sparrow --main-extension "@4x." --autosd-variant 0.25:"@1x." --autosd-variant 0.5:"@2x." --autosd-variant 0.375:"@1.5x." --autosd-variant 0.75:"@3x." --algorithm MaxRects %%~na
)
cd "%DIST%"
for %%b in (*.png) do (
"D:\dev\PowerVR\GraphicsSDK\PVRTexTool\CLI\Windows_x86_64\PVRTexToolCLI.exe" -m -f r8g8b8a8 -i %%b
"C:\Program Files (x86)\Adobe Gaming SDK 1.3\Utilities\ATF Tools\pvr2atf.exe" -4 -r "%%~nb.pvr" -o "%%~nb.atf"
)
pause