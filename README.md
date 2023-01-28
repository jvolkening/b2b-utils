b2b-utils
=======================================================

[![Build Status](https://travis-ci.org/jvolkening/b2b-utils.svg?branch=master)](https://travis-ci.org/jvolkening/b2b-utils)

This package contains a set of programs and utilities for working with genomic
data. Software in the 'alpha' folder is awaiting updating, testing, or
documentation and should be handled with care. Please see the [documentation
page](https://jvolkening.github.io/b2b-utils/) or in-program `--help` for
usage and details.

## Installation

### Using **Conda**

These tools are now available through the
[Bioconda](https://bioconda.github.io/) package **b2b-utils**. You can install
with e.g.:

```bash
conda install -c bioconda b2b-utils
# or probably faster:
mamba install -c bioconda b2b-utils
```

Note that not all tool dependencies are automatically installed along with the
base package, in order to keep the installation footprint down. Each tool
checks for any underlying dependencies at run-time and should give an
informative error if they are not found. All dependencies are available within
Conda and can be installed individually as needed. Alternatively, you can
install a complete environment, including all tool dependencies, using the
`environment.yml` file included in this repository. The following command will
install **b2b-utils** and *all* dependencies into the `b2b-utils` environment:

```bash
conda env create -f <path-to-downloaded-environment.yml>
# or probably faster:
mamba env create -f <path-to-downloaded-environment.yml>
```

**NOTE:** This is *not* necessary for most of the tools in this suite, which
should run from the base Conda package without any additional installs.

### From source

For non-Conda users, the tools can be installed from source in Linux (and
possibly other platforms) as follows:

```bash
git clone https://github.com/jvolkening/b2b-utils.git
cd b2b-utils
perl Build.PL
./Build
./Build test
./Build install
```

