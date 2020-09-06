import os
import glob
import sys
import csv
import logging

if sys.version_info[0] < 3:
    print('You must use Python 3')

    exit()

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('parser.log'),
        logging.StreamHandler()
    ]
)

DIRECTORY = '../data/'

# Generate a CSV file with the results
output = csv.writer(open('results.csv', 'w'), delimiter=';')

header = [
    'forwarders',
    'clients',
    'processes',
    'layout',
    'spatiality',
    'odirect',
    'stonewall',
    'request',
    'total',
    'operation',
    'time',
    'transfered',
    'bandwidth'
]

output.writerow(header)

# Get all .bash files
experiments = sorted([f for f in glob.glob(DIRECTORY + "*.slurm", recursive=True)])

for experiment in experiments:
    logging.info('parsing {}'.format(experiment))

    # Open the file and get the configuration
    with open(experiment) as f:
        lines = f.readlines()

    # Ge the number of processes
    slurm_processes = None
    slurm_forwarders = None
    slurm_clients = None

    for line in lines:
        if 'EXPERIMENT_NUMBER_PROCESSES' in line and slurm_processes is None:
            slurm_processes = int(line.strip().split('=')[1])
            continue

        if 'EXPERIMENT_NUMBER_FORWARDERS' in line and slurm_forwarders is None:
            slurm_forwarders = int(line.strip().split('=')[1])
            continue

        if 'EXPERIMENT_NUMBER_CLIENTS' in line and slurm_clients is None:
            slurm_clients = int(line.strip().split('=')[1])
            continue

    # Get the experiment ID

    experiment_id = (experiment.split('-')[1]).split('.')[0]

    # Get the .time file
    path = '{}/FORGE-{}-*/emulation.time'.format(DIRECTORY, experiment_id)

    files = glob.glob(path)

    if not files:
        logging.warning('missing .time file for experiment {}'.format(experiment_id))
    else:
        for filename in files:
            with open(filename, 'r') as f:
                lines = f.readlines()

                json_operation = ''

                json_write_time = None
                json_read_time = None

                for line in lines:
                    if 'forwarders' in line:
                        json_forwarders = int(line.strip().split()[1])
                        continue
                    if 'clients' in line:
                        json_clients = int(line.strip().split()[1])
                        continue
                    if 'layout' in line:
                        json_layout = int(line.strip().split()[1])
                        continue
                    if 'spatiality' in line:
                        json_spatiality = int(line.strip().split()[1])
                        continue
                    if 'odirect' in line:
                        json_odirect = int(line.strip().split()[1])
                        continue
                    if 'stonewall' in line:
                        json_stonewall = int(line.strip().split()[1])
                        continue
                    if 'request' in line:
                        json_request = int(line.strip().split()[1])
                        continue
                    if 'total' in line:
                        json_total = int(line.strip().split()[1])
                        continue

                    if 'WRITE' in line:
                        json_operation = 'write'
                        continue
                    if 'READ' in line:
                        json_operation = 'read'
                        continue

                    if 'max' in line and json_operation == 'write':
                        json_write_time = float(line.strip().split(':')[1].split()[0])
                        continue
                    if 'data' in line and json_operation == 'write':
                        json_write_transfered = float(line.strip().split(':')[1].split()[0])
                        continue
                    if 'bandwidth' in line and json_operation == 'write':
                        json_write_bandwidth = float(line.strip().split(':')[1].split()[0])
                        continue

                    if 'max' in line and json_operation == 'read':
                        json_read_time = float(line.strip().split(':')[1].split()[0])
                        continue
                    if 'data' in line and json_operation == 'read':
                        json_read_transfered = float(line.strip().split(':')[1].split()[0])
                        continue
                    if 'bandwidth' in line and json_operation == 'read':
                        json_read_bandwidth = float(line.strip().split(':')[1].split()[0])
                        continue

                if json_write_time:
                    write_results = [
                        slurm_forwarders,
                        slurm_clients,
                        json_clients,
                        json_layout,
                        json_spatiality,
                        json_odirect,
                        json_stonewall,
                        json_request,
                        json_total,
                        'write',
                        json_write_time,
                        json_write_transfered,
                        json_write_bandwidth
                    ]

                    output.writerow(write_results)

                if json_read_time:
                    read_results = [
                        slurm_forwarders,
                        slurm_clients,
                        json_clients,
                        json_layout,
                        json_spatiality,
                        json_odirect,
                        json_stonewall,
                        json_request,
                        json_total,
                        'read',
                        json_read_time,
                        json_read_transfered,
                        json_read_bandwidth
                    ]

                    output.writerow(read_results)
