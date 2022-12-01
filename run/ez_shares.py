#General Imports
import os

#1337 Banner FTW
def banner():
    print("""
            $$$$$$__ ______ _______ _$$$$$__ _______ _______ __$$$$$$$_ $$$$$$$_ ___$$$$$__ $$_____ _______ ______ _______ ______ 
            $$___$$_ ______ _______ $$___$$_ _$$$$__ _______ __$$______ ____$$__ __$$___$$_ $$_____ $$$$$__ ______ _$$$$__ _$$$$_ 
            $$___$$_ $$_$$_ _$$$$__ _$$$____ $$__$$_ _$$$$$_ __$$$$$___ ___$$___ ___$$$____ $$_____ ____$$_ $$_$$_ $$__$$_ $$____ 
            $$$$$$__ $$$_$_ $$__$$_ ___$$$__ $$$$$$_ $$_____ __$$______ __$$____ _____$$$__ $$$$$__ _$$$$$_ $$$_$_ $$$$$$_ _$$$__ 
            $$______ $$____ $$__$$_ $$___$$_ $$_____ $$_____ __$$______ _$$_____ __$$___$$_ $$__$$_ $$__$$_ $$____ $$_____ ___$$_ 
            $$______ $$____ _$$$$__ _$$$$$__ _$$$$$_ _$$$$$_ __$$$$$$$_ $$$$$$$_ ___$$$$$__ $$__$$_ _$$$$$_ $$____ _$$$$$_ $$$$__ 
                                                                                                                    v.0.1 @ run""")

#Define functions
def ask_credentials():
    global creds, sharefile, username, password, domain
    creds = input("Do you want to provide credentials? [Y/N]:\n\n")

    if creds.upper() == "Y":
        username = input("Username: ")
        password = input("Password OR Hash: ")
        domain = input("Domain: ")
        sharefile = "shares.txt"

    else:
        username = ''
        password = ''
        domain = ''
        sharefile = "anon_shares.txt"

    return username,password,domain,sharefile,creds

    

def scopefile():
    global sfile
    sfile = input("Please provide absolute path of scope file:\n\n")

    return sfile


def build_folders():
    print("Creating folders...")
    os.mkdir("ezshares")
    os.mkdir("ezshares/shares")
    os.mkdir("ezshares/scans")
    os.mkdir("ezshares/beautified")


def scan_scope():
    print("Scanning Scope for open SMB Ports. This might take a while...")
    os.system("nmap -p445 -oA ezshares/scans/raw_445 -iL {0} 1>/dev/null".format(sfile))
    print("Grepping output...")
    os.system("cat ezshares/scans/raw_445.gnmap | grep open | cut -d ' ' -f 2 > ezshares/scans/445_open.txt")

def grab_shares():
    if creds.upper() == "Y":
        print("Grabbing existing shares. This might take a while...")

        if len(password) == 32:
            os.system("crackmapexec smb ezshares/scans/445_open.txt -u '{0}' -H '{1}' -d '{2}' --shares > ezshares/shares/shares.txt".format(username,password,domain))
        
        else:
            os.system("crackmapexec smb ezshares/scans/445_open.txt -u '{0}' -p '{1}' -d '{2}' --shares > ezshares/shares/shares.txt".format(username,password,domain))

    else:
        print("Grabbing anonymous shares. This might take a while...")
        os.system("crackmapexec smb ezshares/scans/445_open.txt -u '' -p '' --shares > ezshares/shares/anon_shares.txt")

def clean_shares():
    with open("ezshares/shares/%s" % sharefile,"r") as share_input:
        with open("ezshares/beautified/loot.txt","w") as share_output:
            for line in share_input:
                if "(Pwn3d!)" in line:
                    print("LOCAL ADMIN FOUND! GG BOI :3\n\n")
                    print(line)
                if "READ" in line or "WRITE" in line or "READ,WRITE" in line:
                    if "IPC$" in line  or "print$" in line:
                        continue
                    else:
                        share_output.write(line)

banner()
print("""
        !!!DISCLAIMER!!!

        1. NO ERROR HANDLING! If you mess up, you messed up. No babysit :D.
        2. Somehow you need to press Enter after the "Blowfish deprecated" warning from CME...
        3. Ensure that you are in a writable directory!
        4. You need an input file with the scope in CIDR Notation (/24) OR a file with single hosts!
        5. Don't overdo it! Better use it on smaller subnets first.
        6. This script is using nmap and CME and therefore WILL BE LOUD. 
           (Like really. SOC will go brrrrrr after this...)
        
        
        Do you understand?\n\n""")

choice = input("[Y]es, I'm an adult. [N]o, plz abort...\n\n")

if choice.upper() == "Y":
    ask_credentials()
    build_folders()
    scopefile()
    scan_scope()
    grab_shares()
    clean_shares()
    
    print("Script is done! Enjoy!")