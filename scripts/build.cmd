:: Install dependencies.
pesde install

:: Build DialogueClientScript.
cd src\DialogueClientScript
rd /S /Q luau_packages 2>nul
rd /S /Q lune_packages 2>nul
rd /S /Q .pesde 2>nul
call scripts\build.cmd

:: Build DialoguePluginScript.
cd ..\..

:: Move the built files to the correct location.
rd /q /s dist 2>nul
echo d | xcopy /S src dist
rd /S /Q dist\DialogueClientScript\.github
rd /S /Q dist\DialogueClientScript\.vscode
rd /S /Q dist\DialogueClientScript\scripts
rd /S /Q dist\DialogueClientScript\src
echo d | xcopy /S dist\DialogueClientScript\dist dist\DialogueClientScript\src
rd /S /Q dist\DialogueClientScript\dist