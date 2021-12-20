# SETUP
pip3 install -r requirements.txt


# USAGE
```
usage: log4burp.py [-h] (-u TARGET_URL | -f TARGET_FILE) -c BURP_COLLABORATOR [-t TIMEOUT] [-i] [-w]

optional arguments:
  -h, --help            show this help message and exit
  -u TARGET_URL, --url TARGET_URL
                        Target URLs to Check for Log4Shell.
  -f TARGET_FILE, --file TARGET_FILE
                        File Cotaining URLs to Check for Log4Shell.
  -c BURP_COLLABORATOR, --collaborator BURP_COLLABORATOR
                        Burp Collaborater address for Reverse Connection.
  -t TIMEOUT, --timeout TIMEOUT
                        Custom Request Timeout (default=4).
  -i, --ignore-checkup  Deactivates Connection Checkup before Scanning Attempts (default=False).
  -w, --waf-bypass      Uses obfuscated Payloads to bypass Web Application Firewalls (default=False).
```
