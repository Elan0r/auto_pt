#!/usr/bin/env python3
# Imports
import argparse
import os

# Colors
red = '\033[31m'
green = '\033[32m'
yellow = '\033[33m'
blue = '\033[34m'
purple = '\033[35m'
endc = '\033[m'

# Interface
info = blue + '[*]' + endc
error = red + '[x]' + endc
query = yellow + '[?]' + endc
gen = purple + '[%]' + endc

# Arg Parser
parser = argparse.ArgumentParser()
parser.add_argument('-t', '--target-file',
                    dest='target_file',
                    help='Target File containing Targets IPs / URLs for Command Execution.',
                    action='store',
                    required=True)
parser.add_argument('-c', '--command',
                    dest='command',
                    help='Command which will be Executed containing "%PLACEHOLDER" to be Replaced with the Target.',
                    action='store',
                    required=True)
parser.add_argument('-q', '--quiet',
                    help='Supress Command Line Output excluding the executed Command.',
                    action='store',
                    required=False)
args = parser.parse_args()


def parse(file):
    try:
        lst = []
        trgt = open(file, 'r')
        lines = trgt.readlines()
        for x in lines:
            lst.append(x)
        return lst
    except Exception as E:
        print(red + '[x] Unable to Parse given File:' + endc, E)
        exit()


def execute(cmd, lst):
    for target in lst:
        try:
            exec_cmd = cmd.replace('%PLACEHOLDER', target)
            print(blue + "[#] Executing:" + endc, exec_cmd)
            os.system(exec_cmd)
        except Exception as E:
            print(red + '[x] Failed to Execute Command:' + endc, E)


if __name__ == '__main__':
    # Usage Example
    print(blue + '[EXAMPLE]:' + green, './repeater.py' +
          purple, '-t' + yellow, 'TARGETS.txt' +
          purple, '-c' + yellow, '"nmap -sSV -Pn %PLACEHOLDER"', endc)
    # Parse Target File
    target_lst = parse(file=args.target_file)
    # Execute Command & Insert Targets
    execute(cmd=str(args.command), lst=target_lst)
