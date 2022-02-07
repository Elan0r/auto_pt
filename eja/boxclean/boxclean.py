#!/usr/bin/env python3
import os
import argparse
import shutil
import subprocess
import sys

# Set current PWD
main_pwd = os.getcwd()

# Colors
red = '\033[31m'
green = '\033[32m'
blue = '\033[34m'
endc = '\033[m'

# Signals
error = red + "[x] " + endc
positive = green + "[+] " + endc
info = blue + "[*] " + endc

# Vars
cmd_count = 0
path_count = 0

# Check if python3 is used
if sys.version_info <= (3,0):
    print(error + "Script requires Python 3.x")
    sys.exit(1)


# Get arguments
def get_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", dest="cmd_file", help="File Including Commands to Execute")
    parser.add_argument("-p", dest="path_file", help="File including Paths line by line to Remove")
    options = parser.parse_args()
    return options.cmd_file, options.path_file


# Parse selected files
def parse(filepath):
    try:
        a_file = open(filepath)
        file_contents = a_file.read()
        content = file_contents.splitlines()
        return content
    except IOError as F:
        print(error + "Given file doesn't exist")
        print(red + str(F) + endc)
        exit()


# Execute bash command
def cmd(command):
    try:
        print(positive + "Executing " + command)
        process = subprocess.Popen(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
        process.communicate()
    except Exception as D:
        print(error + "Failed Executing " + command)
        print(red + str(D) + endc)
        exit()


# Execute cleaning commands
def clean_cmd(content):
    counter = 0
    for command in content:
        counter += 1
        cmd(command)
    return counter


# Remove given directories
def clean_path(content):
    counter = 0
    for x in content:
        try:
            os.chdir(x)
            for f in os.listdir(x):
                try:
                    if os.path.isdir(f) is True:
                        shutil.rmtree(str(f))
                    elif os.path.isfile(f) is True:
                        os.remove(f)
                    else:
                        print(error + "Failed to Remove " + f)
                    print(positive + "Removed " + f)
                    counter += 1
                except OSError as G:
                    print(error + "OS Error probably missing privileges")
                    print(red + str(G) + endc)
                    exit()
            os.chdir(main_pwd)
        except OSError as E:
            print(error + "Folder or File given in target file doesn't exist")
            print(red + str(E) + endc)
    return counter


# Result Counter
def result(counter1, counter2):
    element_count = counter1 + counter2
    if element_count == 1:
        print(info + "Finished Cleaning " + str(element_count) + " Element!")
    else:
        print(info + "Finished Cleaning " + str(element_count) + " Elements!")
    exit()


# Main Function
if __name__ == '__main__':
    try:
        com, path = get_arguments()
        print(info + "Initializing Cleaning Process!")
        flag = 0
        if com is not None:
            cmd_content = parse(com)
            cmd_count = clean_cmd(cmd_content)
        else:
            flag += 1
        if path is not None:
            path_content = parse(path)
            path_count = clean_path(path_content)
        else:
            flag += 1
        if flag == 2:
            print(error + "No Arguments given. Check './boxclean.py -h' for more Information!")
            exit()
        else:
            result(cmd_count, path_count)
    except KeyboardInterrupt:
        print(error + "Keyboard Interrupt")
        exit()
