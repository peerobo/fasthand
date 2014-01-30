set DIRECTORY=%~dp0
set TPS_FOLDER=%DIRECTORY%asset\
set DIST=%DIRECTORY%..\bin\asset\textures\
cd "%TPS_FOLDER%"
"C:\Program Files (x86)\CodeAndWeb\TexturePacker\bin\TexturePacker.exe" --texture-format png --sheet "%DIST%gui-hd.png" --data "%DIST%gui-hd.xml" --format sparrow --main-extension "-hd." --autosd-variant 0.666667:"-sd." --autosd-variant 0.333333:"-ld." --algorithm MaxRects gui
cd "%DIST%"
for %%b in ("gui-*.png") do (
"C:\Program Files (x86)\Adobe Gaming SDK 1.3\Utilities\ATF Tools\png2atf.exe" -i "%%~nb.png" -o "%%~nb.atf"
)
pause