#!/usr/bin/env python3
import os
import requests
import argparse
import urllib3

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
pos = green + '[+]' + endc
query = yellow + '[!]' + endc
gen = purple + '[%]' + endc

# Var
user_agent = {'User-Agent': 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0) Gecko/20100101 Firefox/102.0'}

security_headers = [
    'X-Frame-Options',
    'Strict-Transport-Security',
    'X-XSS-Protection',
    'Content-Security-Policy'
]

information_headers = [
    'X-Powered-By',
    'Server'
]

# Arg Parser
parser = argparse.ArgumentParser()
group = parser.add_mutually_exclusive_group(required=True)
group.add_argument('-t', '--target', dest='target', help='Target / URL to Check.', action='store', type=str)
group.add_argument('-tf', '--target-file', dest='target_file', help='Target File containing URLs to Check.', action='store', type=str)
parser.add_argument('-out', '--timeout', dest='timeout', default=10, help='Request Timeout Value in Seconds (Default: 10)', type=int)
args = parser.parse_args()


# Functions
def startup():
    urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
    if os.path.isdir('output'):
        os.system('rm -rf output')
    else:
        pass
    os.mkdir('output')
    os.chdir('output')
    os.mkdir('information_disclosure')
    os.mkdir('security')
    os.chdir('..')


def parse(file):
    try:
        lst = []
        trgt = open(file, 'r')
        lines = trgt.readlines()
        for x in lines:
            lst.append(x.strip('\n'))
        return lst
    except Exception as E:
        print(error, 'Unable to Parse given File:', E)
        exit()


def write(header, output, art):
    name = f'output/{art}/{header}.txt'
    try:
        out = open(name, 'a')
        out.write(output + '\n')
        out.close()
    except Exception as E:
        print(error, 'Unable to Parse given File:', E)
        exit()


def get_head(url):
    info_headers = []
    found_sec_headers = []
    r = requests.get(url, timeout=args.timeout, verify=False, headers=user_agent)
    if r:
        print(pos, f'[{url}]: {green}{r.status_code}{endc}')
        for x, y in r.headers.items():
            # print(f'{x} // {y}')
            if str(x) in information_headers:
                print(info, f'[{x}]: {y}')
                write(x, f'{url}: {y}', 'information_disclosure')
                info_headers.append(x)
            if str(x) in security_headers:
                found_sec_headers.append(x)
        missing_headers = list(set(security_headers)^set(found_sec_headers))
        for x in missing_headers:
            print(query, f'[Missing Security Header]:', x)
            write(x, url, 'security')
    else:
        print(error, f'[{url}]: {red}{r}{endc}')


if __name__ == '__main__':
    try:
        # Startup
        startup()
        # Main
        if args.target:
            try:
                get_head(f'https://{args.target}')
            except requests.exceptions.ConnectTimeout:
                try:
                    print(error, f'[https://{args.target}]: {red}TIMEOUT{endc} (after {args.timeout}/s) => Attempting HTTP Fallback')
                    get_head(f'http://{args.target}')
                except requests.exceptions.ConnectTimeout:
                    print(error, f'[http://{args.target}]: {red}TIMEOUT (after {args.timeout}/s){endc}')
                except Exception as E:
                    print(error, 'Error:', E)
            except Exception as E:
                print(error, 'Error:', E)
        elif args.target_file:
            target_lst = parse(args.target_file)
            for target in target_lst:
                try:
                    get_head(f'https://{target}')
                except requests.exceptions.ConnectTimeout:
                    try:
                        print(error, f'[https://{target}]: {red}TIMEOUT (after {args.timeout}/s){endc} => Attempting HTTP Fallback')
                        get_head(f'http://{target}')
                    except requests.exceptions.ConnectTimeout:
                        print(error, f'[http://{target}]: {red}TIMEOUT (after {args.timeout}/s){endc}')
                    except Exception as E:
                        print(error, 'Error:', E)
                except Exception as E:
                    print(error, 'Error:', E)
        else:
            pass
    except KeyboardInterrupt:
        exit(' Keyboard Interrupt Detected => Leaving..')
