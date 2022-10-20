#!/usr/bin/env python3
# IMPORT
import os
import shutil
import json
import argparse
import sys
from datetime import datetime

# Var
option_db = []

# Colors
red = '\033[31m'
green = '\033[32m'
yellow = '\033[33m'
blue = '\033[34m'
purple = '\033[35m'
cyan = '\033[36m'
endc = '\033[m'  # reset to default

# Response Types
error = red + '[x]' + endc
info = yellow + '[i]' + endc
module = blue + '[→]' + endc
executing = green + '[~$]:' + endc


# Modules
def parse(database):
    try:
        with open(database) as json_file:
            parsed_data = json.load(json_file)
            return parsed_data
    except Exception as E:
        return E


def execute():
    cmd = f'msfconsole -qx "resource resource.txt; exit"'
    print(executing, cmd)
    os.system(cmd)


def generate_resource(db, protocol, out):
    ports_lst = db['autosploit']['protocol'][protocol]['port']
    modules = db['autosploit']['protocol'][protocol]['msf']
    os.mkdir(f'{out}/msf/{protocol}')
    if len(ports_lst) >= 1:
        ports_str = ','.join(str(e) for e in ports_lst)
    else:
        ports_str = ports_lst[0]
    for current, optional_args in modules.items():
        f.write(f'spool {os.getcwd()}/{out}/msf/{protocol}/{current.replace("/", "_")}.txt\n')
        f.write(f'echo "$(date) - Executed Module ({current})" >> {os.getcwd()}/{out}/runtime.log\n')
        f.write(f'use {current}\n')
        f.write(f'services -p {ports_str} -u -R\n')
        if optional_args:
            for opt, val in optional_args.items():
                f.write(f'set {opt} {val}\n')
        f.write('run\n')
        f.write('sleep 1\n')


if __name__ == '__main__':
    # Parse JSON
    try:
        data = parse('modules.json')
        for x in data['autosploit']['protocol'].keys():
            option_db.append(x)
    except Exception as E:
        print(error, f'Unable to parse modules.json: {E}')
        sys.exit()
    # Args
    parser = argparse.ArgumentParser(description='Autosploit Version 1.1.0')
    parser.add_argument('-w', type=str, dest='workspace', help='workspace to scan via resource', required=True)
    parser.add_argument('-p', type=str, dest='protocol', choices=option_db, nargs='+', help='limit scant to given protocol')
    args = parser.parse_args()
    # Write Resource Init
    f = open('resource.txt', 'w')
    f.write(f'workspace {args.workspace}\n')
    f.write('setg THREADS 150\n')
    f.write('setg BLANK_PASSWORDS true\n')
    f.write('setg BRUTEFORCE_SPEED 5\n')
    f.write('setg VERBOSE true\n')
    f.write('setg DB_ALL_CREDS true\n')
    f.write(f'echo "$(date) - Autosploit Started!" >> output_{args.workspace}/runtime.log\n')
    # Create Main Output Folder
    foldername = f'output_{args.workspace}'
    try:
        os.mkdir(f'{foldername}')
        os.mkdir(f'{foldername}/msf')
        os.mkdir(f'{foldername}/list')
        print(info, 'Output Folders Created..')
    except FileExistsError:
        user_input = input(f'{info} Output Folder already Exists. Do you want to Delete it? [y/n]: ')
        if user_input.lower() == 'y':
            shutil.rmtree(foldername)
            os.mkdir(f'{foldername}')
            os.mkdir(f'{foldername}/msf')
            os.mkdir(f'{foldername}/list')
            print(info, 'Output Folders Created..')
        else:
            exit('Leaving..')
    except Exception as E:
        print(E)
    # Generate Resource
    if args.protocol:
        for selection in args.protocol:
            generate_resource(db=data, protocol=selection, out=foldername)
    else:
        for selection in option_db:
            generate_resource(db=data, protocol=selection, out=foldername)
    # Export Lists
    f.write('spool off\n')
    f.write('sessions -K\n')
    f.write(f'hosts -o {foldername}/list/msf_hosts.txt\n')
    f.write(f'services -o {foldername}/list/msf_services.csv\n')
    f.write(f'hosts -S printer -o {foldername}/list/msf_hosts_printer.txt\n')
    f.write(f'services -S printer -o {foldername}/list/msf_services_printer.txt\n')
    f.write(f'db_export -f xml {foldername}/list/db_export.xml\n')
    f.write(f'db_export -f pwdump {foldername}/list/pwdump.xml\n')
    f.close()
    # Main Execution
    user_input = input(f'{info} Are you sure you want to Execute? [y/n]: ')
    if user_input.lower() == 'y':
        # Getting the current date and time
        dt = datetime.now()
        ts = datetime.timestamp(dt)
        print(executing, f'Autosploit Started: {dt} ({ts})')
        # Execute Resource script
        execute()
        if os.path.isfile('resource.txt'):
            os.remove('resource.txt')
    else:
        exit('Leaving..')
