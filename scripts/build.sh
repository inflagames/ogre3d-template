#!/usr/bin/env bash

HELP=$(cat <<-END
Usage: ./build.sh [option]

Build project.

options:
  -h/help    Show the help of the script.
.
END
)

if [ "$1" = "-h" ] || [ "$1" = "help" ]; then
  echo "$HELP"
else

  # Create build folder
  rm -rf build
  mkdir build
  cd build

  # Build project
  cmake ../

  # Generate executable
  make

fi
