:: Install dependencies.
pesde install

:: Build StandardTheme.
cd src\DialogueClientScript\src\Themes\StandardTheme
rojo sourcemap -o sourcemap.json

:: Build DialogueClientScript.
cd ..\..\..
rojo sourcemap -o sourcemap.json build.project.json
darklua process src dist

:: Build DialoguePluginScript.
cd ..\..
rojo sourcemap -o sourcemap.json build.project.json
darklua process src dist

:: Copy the build project files to the dist folder.
copy src\DialogueClientScript\build.project.json dist\DialogueClientScript\default.project.json
copy build.project.json dist\default.project.json