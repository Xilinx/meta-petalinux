#!/usr/bin/env python3

import subprocess, argparse

cmds = { 'boardid':'/usr/bin/fru-print.py', \
        'bootfw':'', \
	'bootfwupd':'', \
	'listapps':'dfx-mgr-client', \
	'loadapp':'dfx-mgr-client', \
	'unloadapp':'dfx-mgr-client', \
	'perfmon':'', \
	'ddrqos':'', \
	'axiqos':'', \
	'bist':'' \
	}

#have separate functions for each, in case some preprocessing/specialcommand/prints needed
#separate functions not necessarily needed, can run straight from top function
def boardid(args):
    subprocess.run([cmds['boardid']]+args)

def bootfw(args):
    subprocess.run([cmds['bootfw']]+args)

def bootfwupd(args):
    subprocess.run([cmds['bootfwupd']]+args)

def getpkgs(args):
    if ('-h' in args) or ('--help' in args):
        print("\ngetpkgs will use fru-print to determine the SOM + CC combination\nand search the package feed for compatible packages\n")
        exit()
    som=subprocess.getoutput("fru-print.py -b som -f product | awk -F- '{ print $2}' | tr '[:upper:]' '[:lower:]'")
    cc=subprocess.getoutput("fru-print.py -b cc -f product | awk -F- '{ print $2}' | tr '[:upper:]' '[:lower:]'")
    print("\nSearching package feed for packages compatible with: " + som+'_'+cc+'\n')
    subprocess.run('dnf list --available | grep ' + '\.' +som +'_'+ cc,shell=True)

def listapps(args):
    subprocess.run([cmds['listapps'],'-listPackage'])

def loadapp(args):
    subprocess.run([cmds['loadapp'],'-load']+args)

def unloadapp(args):
    subprocess.run([cmds['unloadapp'],'-remove'])

def perfmon(args):
    subprocess.run([cmds['perfmon']]+args)

def ddrqos(args):
    subprocess.run([cmds['ddrqos']]+args)

def axiqos(args):
    subprocess.run([cmds['axiqos']]+args)

def bist(args):
    subprocess.run([cmds['bist']]+args)


def top(cmd,args):
    globals()[cmd[0]](args)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='xmutil tool')
    parser.add_argument('cmd', choices=['boardid','bootfw','bootfwupd','getpkgs','listapps','loadapp','unloadapp','perfmon','ddrqos','axiqos','bist'], type=str, nargs=1,help='Enter a function')
    parser.add_argument('args', nargs=argparse.REMAINDER)
    args = parser.parse_args()
    top(args.cmd,args.args)
