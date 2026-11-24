@echo off
setlocal
cd /d "%~dp0"
if exist build\classes rmdir /s /q build\classes
javac -encoding UTF-8 --release 21 -d build\classes -sourcepath src\main\java src\main\java\br\ucsal\agendamonitoria\App.java
if errorlevel 1 exit /b 1
java -cp build\classes br.ucsal.agendamonitoria.App %*
