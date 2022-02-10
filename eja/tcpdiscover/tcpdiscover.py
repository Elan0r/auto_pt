#!/usr/bin/python3
# -*- coding: utf-8 -*-
import subprocess
import ipaddress
import argparse
import os
import re

# color codes
red = '\033[31m'
green = '\033[32m'
blue = '\033[34m'


# text styles
bold = '\033[1m'
underline = '\033[4m'
endc = '\033[m'  # reset to default

# response types
error = red + '[x] ' + endc
info = blue + '[*] ' + endc
positive = green + '[✓] ' + endc

banner = bold + '''
 __                 __ __
|  |_.----.-----.--|  |__|.-----.----.-----.--.--.-----.----.
|   _|  __|  _  |  _  |  ||__ --|  __|  _  |  |  |  -__|   _|
|____|____|   __|_____|__||_____|____|_____|\___/|_____|__|
          |__|                                               ''' + endc


# get arguments
def get_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument("-o", dest="filename", help="Write Output to TXT file")
    options = parser.parse_args()
    return options.filename


# validate ip address
def validate(ip):
    try:
        if ipaddress.ip_address(ip).is_private:
            if ip.startswith("192"):
                return True
            if ip.startswith("172"):
                return True
            if ip.startswith("10"):
                return True
            else:
                return False
        else:
            return False
    except ValueError:
        return False


# main method
def main():
    discovered = []
    try:
        p = subprocess.Popen(('sudo', 'tcpdump', '-nn', '-v'), stdout=subprocess.PIPE)
        for row in iter(p.stdout.readline, b''):
            output = str(row.rstrip())
            mac = re.findall(re.compile(r'(?:[0-9a-fA-F]:?){12}'), output)
            ip = re.findall(r'[0-9]+(?:\.[0-9]+){3}', output)
            for x in ip:
                for y in mac:
                    if validate(x) is True:
                        if x not in discovered:
                            print(positive + 'Discovered' + green + ':' + endc, bold + x + endc)
                            discovered.append(x)
                            if out is True:
                                outfile.write(x + '\n')
                            else:
                                pass
                        else:
                            pass
                else:
                    pass
    except KeyboardInterrupt:
        print('\n' + blue + str(len(discovered)) + endc + ' Unique IPs detected ')
        exit()


if __name__ == '__main__':
    print(banner)
    file = get_arguments()
    if file is not None:
        if os.path.exists(file):
            os.remove(file)
        else:
            pass
        outfile = open(file, 'a')
        out = True
    else:
        out = False
    print(info + bold + 'Version: ' + blue + '1.1' + endc + ' / ' + underline + 'Requires Root Privileges' + endc)
    main()
