#!/usr/bin/env python3
# IMPORT
import os
import json
import argparse
from simple_term_menu import TerminalMenu

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

# Args
parser = argparse.ArgumentParser(description='Autosploit Version 1.1.0')
parser.add_argument('WORKSPACE', type=str, help='workspace to scan via resource')
args = parser.parse_args()


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


def generate_resource(protocol, db):
    ports_lst = db["autosploit"]["protocol"][protocol]["port"]
    modules = db["autosploit"]["protocol"][protocol]["msf"]
    os.mkdir(f"output/{protocol}")
    if len(ports_lst) >= 1:
        ports_str = ','.join(str(e) for e in ports_lst)
    else:
        ports_str = ports_lst[0]
    for current, optional_args in modules.items():
        f.write(f"spool {os.getcwd()}/output/{protocol}/{current.replace('/', '_')}.txt\n")
        f.write(f"echo '#### {current} ####'\n")
        f.write(f"use {current}\n")
        f.write(f"services -p {ports_str} -u -R\n")
        if optional_args:
            for opt, val in optional_args.items():
                f.write(f"set {opt} {val}\n")
        f.write("run\n")
        f.write("back\n")


def menu_selection(db):
    option_db.append("[ EVERYTHING ]")
    for x in db["autosploit"]["protocol"].keys():
        option_db.append(x)
    terminal_menu = TerminalMenu(option_db)
    menu_entry_index = terminal_menu.show()
    if menu_entry_index == 0:
        option_db.pop(0)
        return True
    else:
        msf_protocol = option_db[menu_entry_index]
        return msf_protocol


if __name__ == "__main__":
    try:
        # Parse JSON
        data = parse("modules.json")
        # Main Menu
        var_service = menu_selection(data)
        # Write Resource Init
        f = open("resource.txt", "w")
        f.write(f"workspace {args.WORKSPACE}\n")
        f.write("setg THREADS 150\n")
        # Create Main Output Folder
        os.mkdir("output")
        # Generate Resource
        if var_service is True:
            for var_srvc in option_db:
                generate_resource(db=data, protocol=var_srvc)
        else:
            generate_resource(db=data, protocol=var_service)
        f.close()
    except Exception as E:
        print(f"{error} ERROR: {E}")
        exit()
    # Main Execution
    user_input = input(f"{info} Are you sure you want to Execute? [y/n]: ")
    if user_input.lower() == "y":
        execute()
        try:
            os.system("rm resource.txt")
        except Exception as E:
            print(error, E)
    else:
        exit("Leaving..")
