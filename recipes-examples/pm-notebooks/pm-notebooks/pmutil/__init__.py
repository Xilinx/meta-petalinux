import subprocess
from pathlib import Path

__all__ = [
    'cpufreq',
    'hotplug'
]


def get_nr_cpus():
    '''
    returns the number of CPU cores of the system
    '''
    nr_cpus = subprocess.check_output("nproc", shell=True)
    return int(nr_cpus)


def write_to_sysfs(filepath, value):
    ret = -1
    if Path(filepath).is_file():
        with open(filepath, 'w') as sysfp:
            ret = sysfp.write(value)
    return ret
