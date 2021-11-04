#!/usr/bin/env bash

HELP=$(cat <<-END
Usage: ./setup-ogre.sh [OGRE_VERSION_TAG]

Setup Ogre in the system given the tag version.

OGRE_VERSION_TAG: default value is v13.1.1
.
END
)

is_package_installed() {
  PACKAGE=$1;
  IS_INSTALL=$(dpkg-query -W --showformat='${Status}\n' $PACKAGE | grep "install ok installed")
  echo $(if [ "$IS_INSTALL" = "install ok installed" ]; then echo "yes"; else echo "no"; fi)
}

if [ "$1" = "-h" ] || [ "$1" = "help" ]; then
  echo "$HELP"
else

  # Set ogre version
  OGRE_VERSION_TAG="${OGRE_VERSION_TAG:-v13.1.1}";
  echo "Ogre version: $OGRE_VERSION_TAG"

  # Install dependencies if is needed
  DEPENDENCIES=(libgles2-mesa-dev libsdl2-dev libxt-dev libxaw7-dev doxygen zziplib-bin cmake-qt-gui cmake)
  for i in "${DEPENDENCIES[@]}"; do
    if [ "$(is_package_installed $i)" = "no" ]; then
      echo $i
      sudo apt install -y $i
    fi
  done

  git clone https://github.com/OGRECave/ogre.git
  cd ogre

  git checkout $OGRE_VERSION_TAG

  # Build ogre
  cmake .
  cmake --build . --config Release

  # Install ogre
  sudo cmake --build . --config Release --target install

  # Remove ogre repo
  cd ..
  rm -rf ogre

fi
