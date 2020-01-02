
if [ `uname -m` = 'aarch64' ]; then
   wget -q "https://github.com/Archiconda/build-tools/releases/download/0.2.3/Archiconda3-0.2.3-Linux-aarch64.sh" -O archiconda.sh
   chmod +x archiconda.sh
   bash archiconda.sh -b -p $HOME/miniconda
   chmod -R 777 $HOME/miniconda/
   export PATH="$HOME/miniconda/bin:$PATH"
   hash -r
   chmod -R 777 $HOME/miniconda/
   conda config --set always_yes yes --set changeps1 no
   conda update -q conda
   conda info -a
   conda activate 
   mkdir /home/travis/.condrac
   sudo chmod -R 777 $HOME/miniconda/bin/activate 
   sudo chmod -R 777 /home/travis/.condarc
   conda info --envs
   conda activate base
else
   wget -q "https://repo.continuum.io/miniconda/Miniconda3-latest-$CONDA_OS.sh" -O miniconda.sh
   chmod +x miniconda.sh
   ./miniconda.sh -b-p $HOME/miniconda
   $HOME/miniconda/bin/conda init bash
   source ~/.bash_profile
   activate base

fi
source "$( dirname "${BASH_SOURCE[0]}" )"/setup_dependencies_common.sh
export PATH=$MINICONDA_DIR/bin:$PATH

echo
echo "which conda"
which conda
