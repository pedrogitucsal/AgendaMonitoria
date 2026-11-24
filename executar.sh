#!/usr/bin/env sh
set -e
cd "$(dirname "$0")"
rm -rf build/classes
javac -encoding UTF-8 --release 21 -d build/classes -sourcepath src/main/java src/main/java/br/ucsal/agendamonitoria/App.java
java -cp build/classes br.ucsal.agendamonitoria.App "$@"
