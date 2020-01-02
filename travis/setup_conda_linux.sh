#!/bin/bash

# Install conda (http://conda.pydata.org/docs/travis.html#the-travis-yml-file)
# Note that we pin the Miniconda version to avoid issues when new versions are released.
# This can be updated from time to time.
if [[ -z "${MINICONDA_VERSION}" ]]; then
    MINICONDA_VERSION=4.7.10
fi
IS_SUDO=""
ARCHICONDA_PYTHON="python3.7"

# edit the locale file if needed
if [ -n "$LOCALE_OVERRIDE" ]; then
    echo "Adding locale to the first line of pandas/__init__.py"
    rm -f pandas/__init__.pyc
    SEDC="3iimport locale\nlocale.setlocale(locale.LC_ALL, '$LOCALE_OVERRIDE')\n"
    sed -i "$SEDC" pandas/__init__.py
    echo "[head -4 pandas/__init__.py]"
    head -4 pandas/__init__.py
    echo
    sudo locale-gen "$LOCALE_OVERRIDE"
fi

if [ `uname -m` = 'aarch64' ]; then
   MINICONDA_DIR="$HOME/archiconda3"
   IS_SUDO="sudo"
else
   MINICONDA_DIR="$HOME/miniconda3"
fi

if [ -d "$MINICONDA_DIR" ]; then
    echo
    echo "rm -rf "$MINICONDA_DIR""
    rm -rf "$MINICONDA_DIR"
fi

echo "Install Miniconda"
UNAME_OS=$(uname)
if [[ "$UNAME_OS" == 'Linux' ]]; then
    if [[ "$BITS32" == "yes" ]]; then
        CONDA_OS="Linux-x86"
    else
        CONDA_OS="Linux-x86_64"
    fi
elif [[ "$UNAME_OS" == 'Darwin' ]]; then
    CONDA_OS="MacOSX-x86_64"
else
  echo "OS $UNAME_OS not supported"
  exit 1
fi

if [ `uname -m` = 'aarch64' ]; then
   wget -q "https://github.com/Archiconda/build-tools/releases/download/0.2.3/Archiconda3-0.2.3-Linux-aarch64.sh" -O archiconda.sh
   chmod +x archiconda.sh
   $IS_SUDO apt-get install python-dev
   $IS_SUDO apt-get install python3-pip
   $IS_SUDO apt-get install lib$ARCHICONDA_PYTHON-dev
   $IS_SUDO apt-get install xvfb
   export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/local/lib:/usr/local/bin/python
   ./archiconda.sh -b
   echo "chmod MINICONDA_DIR"
   $IS_SUDO chmod -R 777 $MINICONDA_DIR
   $IS_SUDO cp $MINICONDA_DIR/bin/* /usr/bin/
   $IS_SUDO rm /usr/bin/lsb_release
   export PATH=$PATH:home/travis/archiconda3/bin/
   echo "conda activate base "
   sudo conda activate base 
else
   wget -q "https://repo.continuum.io/miniconda/Miniconda3-latest-$CONDA_OS.sh" -O miniconda.sh
   chmod +x miniconda.sh
   ./miniconda.sh -b-p $HOME/miniconda
    $HOME/miniconda/bin/conda init bash
    source ~/.bash_profile
    conda activate base

fi
source "$( dirname "${BASH_SOURCE[0]}" )"/setup_dependencies_common.sh
export PATH=$MINICONDA_DIR/bin:$PATH

echo
echo "which conda"
which conda
