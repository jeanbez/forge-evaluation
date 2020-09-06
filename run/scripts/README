# I/O Forwarding Explorer - Run (script)

In this directory, you can find the `.slurm` files used to launch all the experiments of our paper:

- `marenostrum-4`
- `marenostrum-4-gpfs`
- `santos-dumont`
- `santos-dumont-lustre`

You can also find a sample test case that will run FORGE with its test cases. Notice that this is a simple test. To run FORGE in another platform, you can use any of the `.slurm` files as a baseline. Just be sure to change the loaded modules and fix the paths.

The `sample/run-sample.sh` script will lanuch FORGE:

```
mpirun -np 4 \
	--oversubscribe \
	${FORGE:?} \
	${INPUT:?} \
	${OUTPUT:?}
``` 

Each execution of FORGE generates a `.time` file with all the metrics required for you to analyze.