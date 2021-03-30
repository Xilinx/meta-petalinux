#!/usr/bin/env python3

import argparse, yaml, sys
from glob import glob
from fru import load

parser = argparse.ArgumentParser(description='print fru data of SOM/CC eeprom')
parser.add_argument('-b','--board', action='store', choices=['som','cc'], type=str, help='Enter som or cc')
parser.add_argument('-f','--field', action='store', nargs="+", type=str, help='enter fields to index using. (if entering one arg, it\'s assumed the field is from board area)')
parser.add_argument('-s','--sompath', type=str, nargs="?", default='/sys/bus/i2c/devices/*50/eeprom', help='enter path to SOM EEPROM')
parser.add_argument('-c','--ccpath', type=str, nargs="?", default='/sys/bus/i2c/devices/*51/eeprom', help='enter path to CC EEPROM')
args = parser.parse_args()

if args.board == 'som':
    try:
        som=glob(args.sompath)[0]
    except:
        sys.exit('\nsompath is incorrect:' + args.sompath)

elif args.board == 'cc':
    try:
        cc=glob(args.ccpath)[0]
    except:
        sys.exit('\nccpath is incorrect: ' + args.ccpath)
else:
    try:
        som=glob(args.sompath)[0]
        cc=glob(args.ccpath)[0]
    except:
        sys.exit('\nOne of the following paths is wrong:\nsom path: ' + args.sompath + '\n' + 'cc path: ' + args.ccpath)

if args.field and args.board is None:
    parser.error('\nIf entering a field, need board input as well')

elif args.board and args.field is None:
    print(yaml.dump(load(eval(args.board)), default_flow_style=False, allow_unicode=True))

elif args.board and args.field:
    try:
        if len(args.field) == 1:
            print(load(eval(args.board))['board'][args.field[0]])
        else:
            data = load(eval(args.board))
            for field in args.field:
                data = data[field]
            print(data)
    except KeyError:
        print("ERROR: "+str(args.field)+" is not a valid input for field.\nmultiple key values can be provided to the field arg, ex. -f multirecord DC_Load_Record max_V\n\
If just one value is given, it is assumed the field is under the board area.\n")
else:
    both={'som':load(som), 'cc':load(cc)}
    print(yaml.dump(both,default_flow_style=False, allow_unicode=True))
