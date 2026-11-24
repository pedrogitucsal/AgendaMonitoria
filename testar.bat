@echo off
setlocal
cd /d "%~dp0"
if exist build\testes rmdir /s /q build\testes
javac -encoding UTF-8 --release 21 -d build\testes -sourcepath "src\main\java;src\test\java" src\test\java\br\ucsal\agendamonitoria\teste\ExecutorTestes.java
if errorlevel 1 exit /b 1
java -cp build\testes br.ucsal.agendamonitoria.teste.ExecutorTestes
