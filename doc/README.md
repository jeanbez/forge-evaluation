# I/O Forwarding Explorer

This repository is structured in the following way:

```.
├── compile
├── doc
├── figures
│   ├── output
│   └── scripts
├── input
│   ├── marenostrum-4
│   ├── marenostrum-4-gpfs
│   ├── santos-dumont
│   └── santos-dumont-lustre
└── run
    ├── output
    │   ├── marenostrum-4
    │   │   ├── data
    │   │   └── results
    │   ├── marenostrum-4-gpfs
    │   │   ├── data
    │   │   └── results
    │   ├── santos-dumont
    │   │   ├── data
    │   │   └── results
    │   └── santos-dumont-lustre
    │       ├── data
    │       └── results
    └── scripts
        ├── marenostrum-4
        ├── marenostrum-4-gpfs
        ├── sample
        ├── santos-dumont
        └── santos-dumont-lustre
```

The `compile` directory can contain a set of compilation scripts. These scripts produce the binaries and libraries used by the scripts in `runs`. They also build all major dependencies that are required by the application under test.

You can build the dependencies and FORGE by issuing:

```
bash install-dependencies.sh
bash install-forge.sh
```

The `run` directory contains two subdirectories, a `scripts` subdirectory, and an `output` subdirectory. The `run/scripts` directory actually runs FORGE for the given inputs and creates the logs/output and results in `run/output` that can be used to plot by the `figures` scripts. The main script to run a sample test case with FORGE is located in `run/scripts/sample`. For the job scripts (`.slurm`) files used to generate the data, please, refer to one of the subdirectories of each machine.

You can run the FORGE's sample test case with:

```
bash run-sample.sh
```

It will generate three files (`.time`, `.map`, and `.log`).

The `figures` directory contains two subdirectories, a `scripts` subdirectory, and an `output` subdirectory. The script subdirectory can contain the scripts to re-create the plots of the paper. You can open each one of them in R (RStudio). They will generate the `.pdf` files of each figure used in our manuscript inside the `figures/output` directory.