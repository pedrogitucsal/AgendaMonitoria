#!/usr/bin/env sh
set -e
cd "$(dirname "$0")"
rm -rf build/testes
javac -encoding UTF-8 --release 21 -d build/testes -sourcepath src/main/java:src/test/java src/test/java/br/ucsal/agendamonitoria/teste/ExecutorTestes.java
java -cp build/testes br.ucsal.agendamonitoria.teste.ExecutorTestes
