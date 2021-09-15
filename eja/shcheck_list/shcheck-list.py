#!/usr/bin/env python
import os
import subprocess

green = '\033[32m'
yellow = '\033[33m'
endc = '\033[m'
urls = []

xpoweredby = 'header \x1b[93mX-Powered-By\x1b[0m is present!'
xframe = 'Missing security header: \x1b[93mX-Frame-Options\x1b[0m'
stricttransport = 'Missing security header: \x1b[91mStrict-Transport-Security\x1b[0m'
contentsecurity = 'Missing security header: \x1b[93mContent-Security-Policy\x1b[0m'


# execute bash command
def cmd(command):
    try:
        bash = subprocess.check_output(command, shell=True, text=True)
        return bash
    except KeyboardInterrupt:
        exit()


def make_dir():
    try:
        cmd('mkdir results')
        os.chdir('results')
    except subprocess.CalledProcessError:
        os.chdir('results')
    with open('X-Powered-By.txt', 'w') as file:
        file.write('Missing X-Powered-By:')
    with open('X-Frame-Options.txt', 'w') as file:
        file.write('Missing X-Frame-Options:')
    with open('Strict-Transport-Security.txt', 'w') as file:
        file.write('Missing Strict-Transport-Security:')
    with open('Content-Security-Policy.txt', 'w') as file:
        file.write('Missing Content-Security-Policy:')
    os.chdir('..')


def write_file(vuln_url, type_url):
    os.chdir('results')
    if type_url == 'X-Powered-By':
        with open('X-Powered-By.txt', 'a') as f:
            f.write('\n' + vuln_url)
    if type_url == 'X-Frame-Options':
        with open('X-Frame-Options.txt', 'a') as f:
            f.write('\n' + vuln_url)
    if type_url == 'Strict-Transport-Security':
        with open('Strict-Transport-Security.txt', 'a') as f:
            f.write('\n' + vuln_url)
    if type_url == 'Content-Security-Policy':
        with open('Content-Security-Policy.txt', 'a') as f:
            f.write('\n' + vuln_url)
    os.chdir('..')


if __name__ == '__main__':
    try:
        print('# Remember, URLs from List arent allowed to contain "https://"')
        path = input(yellow + '[?] ' + endc + 'Please enter target URL Filepath: ')
        if not path:
            print("Test")
            exit()
        else:
            with open(path, 'r') as f:
                data = f.read()
                content = data.splitlines()
                for line in content:
                    url = 'https://' + line + '/'
                    urls.append(url)
            print(yellow + '[*] ' + endc + 'Creating Result Folder..')
            make_dir()
            for x in urls:
                try:
                    output = cmd('./shcheck.py -d -i ' + x)
                    out = str(output)
                    if xpoweredby in out:
                        print(green + '[+] ' + endc + x + ' available header: ' + yellow + 'X-Powered-By' + endc)
                        write_file(x, 'X-Powered-By')
                    if xframe in out:
                        print(green + '[+] ' + endc + x + ' is missing header: ' + yellow + 'X-Frame-Options' + endc)
                        write_file(x, 'X-Frame-Options')
                    if stricttransport in out:
                        print(green + '[+] ' + endc + x + ' is missing header: ' + yellow + 'Strict-Transport-Security' + endc)
                        write_file(x, 'Strict-Transport-Security')
                    if contentsecurity in out:
                        print(green + '[+] ' + endc + x + ' is missing header: ' + yellow + 'Content-Security-Policy' + endc)
                        write_file(x, 'Content-Security-Policy')
                    else:
                        pass
                except subprocess.CalledProcessError:
                    pass
    except KeyboardInterrupt:
        exit()
