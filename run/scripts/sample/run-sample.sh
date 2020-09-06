#!/bin/bash

AGIOS=../../../compile/forge/agios
FORGE=../../../compile/forge/build/forge
INPUT=../../../compile/forge/test/sample.json
OUTPUT=.

# Copy AGIOS configuration files to /tmp
cp ${AGIOS:?}/* /tmp/

# Execute a simple run
mpirun -np 4 \
	--oversubscribe \
	${FORGE:?} \
	${INPUT:?} \
	${OUTPUT:?}
