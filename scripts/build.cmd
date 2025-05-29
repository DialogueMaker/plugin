:: Install dependencies.
pesde install

:: Build DialogueClientScript.
cd src\DialogueClientScript
scripts\build.cmd

:: Build DialoguePluginScript.
cd ..\..
rojo sourcemap -o sourcemap.json
darklua process src dist