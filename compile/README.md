# I/O Forwarding Explorer - Compile

In this directory, you can find two scripts:

- `install-dependencies.sh`
- `install-forge.sh`

You must execute them both in the pre-defined order. You are expected to have `cmake` (>= 3.10), `gcc` (>= 7.0), and OpenMPI (>= 3.0) in your system. You must have OpenMPI with MPI_THREAD_MULTIPLE thread-level support. These requirements are not installed by the script.

The first script will install some required packages:

```
sudo apt install -y \
	libconfig-dev \
	libgsl-dev \
	libgsl-dev
```

It will also clone and compile the AGIOS scheduling library used by this version of FORGE.

```
git clone https://github.com/jeanbez/forwarding-explorer-agios agios
cd agios
make library
make library_install
``` 

Once you all the dependencies (including GSL and AGIOS) installed, we can now install FORGE.

The second script will do that by cloning the version used in our experiments and compiling it.

```
git clone https://github.com/jeanbez/forwarding-explorer forge
cd forge
mkdir build
cd build
cmake ..
make
```

If you want to customize FORGE's installation by enabling or disabling any additional modules, please refer to FORGE's repository for the detailed documentation.