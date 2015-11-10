#!/bin/bash -x

hash -r
conda config --set always_yes yes --set changeps1 no
conda config --add channels astropy-ci-extras
conda update -q conda
conda info -a

if [[ -z $PYTHON_VERSION ]]; then
    PYTHON_VERSION=$TRAVIS_PYTHON_VERSION
fi

# CONDA
conda create -n test python=$PYTHON_VERSION pip
source activate test

# EGG_INFO
if [[ $SETUP_CMD == egg_info ]]; then
    return  # no more dependencies needed
fi

# CORE DEPENDENCIES
conda install pytest pip $CONDA_ADDITIONAL_DEPENDENCIES

if [[ ! -z $PIP_ADDITIONAL_DEPENDENCIES ]]; then
    $PIP_INSTALL $PIP_ADDITIONAL_DEPENDENCIES
fi

# PEP8
if [[ $MAIN_CMD == pep8* ]]; then
    $PIP_INSTALL pep8
    return  # no more dependencies needed
fi

# NUMPY
if [[ $NUMPY_VERSION == dev ]] || [[ $NUMPY_VERSION == development ]]; then
    $PIP_INSTALL git+http://github.com/numpy/numpy.git
    export CONDA_INSTALL="conda install python=$PYTHON_VERSION"
else
    conda install  numpy=$NUMPY_VERSION
    export CONDA_INSTALL="conda install python=$PYTHON_VERSION numpy=$NUMPY_VERSION"
fi

# ASTROPY
if [[ ! -z $ASTROPY_VERSION ]]; then
    if [[ $ASTROPY_VERSION == development ]] || [[ $ASTROPY_VERSION == dev ]]; then
        # Install Astropy core dependencies first
        $CONDA_INSTALL Cython jinja2
        $PIP_INSTALL git+http://github.com/astropy/astropy.git#egg=astropy;
    elif [[ $ASTROPY_VERSION == stable ]]; then
        $CONDA_INSTALL astropy;
    else
        $CONDA_INSTALL astropy=$ASTROPY_VERSION;
    fi
fi

# Now set up shortcut to conda install command to make sure the Python and Numpy
# versions are always explicitly specified.

# OPTIONAL DEPENDENCIES
if [[ ! -z $CONDA_OPTIONAL_DEPENDENCIES ]]; then
    $CONDA_INSTALL $CONDA_OPTIONAL_DEPENDENCIES
fi

if [[ ! -z $PIP_OPTIONAL_DEPENDENCIES ]]; then
    $PIP_INSTALL $PIP_OPTIONAL_DEPENDENCIES
fi

# DOCUMENTATION DEPENDENCIES
# build_sphinx needs sphinx and matplotlib (for plot_directive).
if [[ $SETUP_CMD == build_sphinx* ]]; then
    $CONDA_INSTALL Sphinx matplotlib
fi

# COVERAGE DEPENDENCIES
if [[ $SETUP_CMD == 'test --coverage' ]]; then
  # TODO can use latest version of coverage (4.0) once astropy 1.1 is out
  # with the fix of https://github.com/astropy/astropy/issues/4175.
  pip install coverage==3.7.1;
  pip install coveralls;
fi
