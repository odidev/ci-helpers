
if [ `uname -m` = 'aarch64' ]; then
   wget -q "https://github.com/Archiconda/build-tools/releases/download/0.2.3/Archiconda3-0.2.3-Linux-aarch64.sh" -O archiconda.sh
   chmod +x archiconda.sh
   bash archiconda.sh -b -p $HOME/miniconda
   export PATH="$HOME/miniconda/bin:$PATH">> ~/.bashrc
   source ~/.bashrc
   sudo cp -r $HOME/miniconda/bin/* /usr/bin/
   hash -r
   sudo mkdir /home/travis/.condarc
   sudo chmod -R 777  /home/travis/.condarc
   sudo conda config --set always_yes yes --set changeps1 no
   sudo conda update -q conda
   sudo conda info -a
   sudo activate base
   if [[ -z $CONDA_ENVIRONMENT ]]; then
   sudo conda create $QUIET -n test $PYTHON_OPTION
   else
   sudo conda env create $QUIET -n test -f $CONDA_ENVIRONMENT
   fi
   sudo activate test
else
   wget -q "https://repo.continuum.io/miniconda/Miniconda3-latest-$CONDA_OS.sh" -O miniconda.sh
   chmod +x miniconda.sh
   ./miniconda.sh -b-p $HOME/miniconda
   $HOME/miniconda/bin/conda init bash
   source ~/.bash_profile
   conda activate base
   source "$( dirname "${BASH_SOURCE[0]}" )"/setup_dependencies_common.sh
fi
export PATH=$MINICONDA_DIR/bin:$PATH

echo
echo "which conda"
which conda
