#!/bin/bash

# Install conda (http://conda.pydata.org/docs/travis.html#the-travis-yml-file)
# Note that we pin the Miniconda version to avoid issues when new versions are released.
# This can be updated from time to time.
if [[ -z "${MINICONDA_VERSION}" ]]; then
    MINICONDA_VERSION=4.7.10
fi

if [ `uname -m` = 'aarch64' ]; then
     CONDA_URL="https://github.com/conda-forge/miniforge/releases/download/4.8.2-1/Miniforge3-4.8.2-1-Linux-aarch64.sh"
else
    CONDA_URL="https://repo.continuum.io/miniconda/Miniconda3-latest-$CONDA_OS.sh"
fi
wget -q $CONDA_URL -O miniconda.sh
chmod +x miniconda.sh
mkdir $HOME/.conda
bash miniconda.sh -b -p $HOME/miniconda
export PATH= $HOME/miniconda/bin:$PATH
mkdir $HOME/.condarc
$HOME/miniconda/bin/conda init bash
source ~/.bash_profile
conda activate base
source "$( dirname "${BASH_SOURCE[0]}" )"/setup_dependencies_common.sh
if [[ $SETUP_XVFB == True ]]; then
   export DISPLAY=:99.0
   /sbin/start-stop-daemon --start --quiet --pidfile /tmp/custom_xvfb_99.pid --make-pidfile --background --exec /usr/bin/Xvfb -- :99 -screen 0 1920x1200x24 -ac +extension GLX +render -noreset
fi
export PATH=$MINICONDA_DIR/bin:$PATH
