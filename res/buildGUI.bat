set DIRECTORY=%~dp0
set TPS_FOLDER=%DIRECTORY%
set WALL_FOLDER=%DIRECTORY%\wall\
set DIST=%DIRECTORY%..\bin\asset\textures\
set PATH=%PATH%;"D:\dev\PowerVR\GraphicsSDK\PVRTexTool\CLI\Windows_x86_64\"
set PATH=%PATH%;"C:\Program Files (x86)\Adobe Gaming SDK 1.3\Utilities\ATF Tools\"
set PATH=%PATH%;"D:\iosdev\atf"
cd "%TPS_FOLDER%"
"C:\Program Files (x86)\CodeAndWeb\TexturePacker\bin\TexturePacker.exe" --texture-format png --sheet "%DIST%gui@4x.png" --data "%DIST%gui@4x.xml" --format sparrow --main-extension "@4x." --autosd-variant 0.25:"@1x." --autosd-variant 0.5:"@2x." --autosd-variant 0.375:"@1.5x." --autosd-variant 0.75:"@3x."  --algorithm MaxRects gui
cd "%DIST%"
for %%b in ("*.png") do (
::PVRTexToolCLI.exe -m -f r8g8b8a8 -i %%b
::pvr2atf.exe -4 -r "%%~nb.pvr" -o "%%~nb.atf"
png2atf.exe -4 -q 0 -i "%%~nb.png" -o "%%~nb.atf"
::del /f /q %%~nb.pvr
del /f /q %%~nb.png
)
pause