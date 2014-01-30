set DIRECTORY=%~dp0
set TPS_FOLDER=%DIRECTORY%asset\
set DIST=%DIRECTORY%..\bin\asset\textures\
cd "%TPS_FOLDER%"
"C:\Program Files (x86)\CodeAndWeb\TexturePacker\bin\TexturePacker.exe" --texture-format png --sheet "%DIST%gui-hd.png" --data "%DIST%gui-hd.xml" --format sparrow --main-extension "-hd." --autosd-variant 0.666667:"-sd." --autosd-variant 0.333333:"-ld." --algorithm MaxRects gui
cd "%DIST%"
for %%b in ("gui-*.png") do (
"D:\dev\PowerVR\GraphicsSDK\PVRTexTool\CLI\Windows_x86_64\PVRTexToolCLI.exe" -m -f r8g8b8a8 -i %%b
"C:\Program Files (x86)\Adobe Gaming SDK 1.3\Utilities\ATF Tools\pvr2atf.exe" -4 -r "%%~nb.pvr" -o "%%~nb.atf"
del /f /q %%~nb.pvr
del /f /q %%~nb.png
)
pause