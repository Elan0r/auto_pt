#General Imports
import requests

#Initialize lists
dead_ends = []
alive = []
wordpress = []
typo3 = []
undefined = []

#Print Banner
print("""
______          _____             _____ ___  ___ _____   _____ _               _    
| ___ \        /  ___|           /  __ \|  \/  |/  ___| /  __ \ |             | |   
| |_/ / __ ___ \ `--.  ___  ___  | /  \/| .  . |\ `--.  | /  \/ |__   ___  ___| | __
|  __/ '__/ _ \ `--. \/ _ \/ __| | |    | |\/| | `--. \ | |   | '_ \ / _ \/ __| |/ /
| |  | | | (_) /\__/ /  __/ (__  | \__/\| |  | |/\__/ / | \__/\ | | |  __/ (__|   < 
\_|  |_|  \___/\____/ \___|\___|  \____/\_|  |_/\____/   \____/_| |_|\___|\___|_|\_\\
                                                                        v0.1 @ run
    \n
""")

#Feed Subdom File
inputfile = input("Fullpath to File with subdomains: ")
print("\nChecking if the hosts are alive.\n")
print("This might take a while. Be patient...\n")

#Check if the Page is reachable
with open(inputfile,"r") as subdoms:
    for line in subdoms:
        url = "http://" + str(line).strip()
        
        try:
            print("Trying: " + str(url))
            r = requests.get(url = url, timeout = 5)
        except requests.exceptions.RequestException as e:
            dead_ends.append(url)
            continue

        if r.url not in dead_ends:
            alive.append(str(r.url))

print("Listing complete! Checking for Wordpress and Typo3 now!\n")

#Remove Duplicates
alive = list(dict.fromkeys(alive))
dead_ends = list(dict.fromkeys(dead_ends))

#Checking wordpress and Typo3 CMS
for element in alive:
    try:
        r = requests.get(url = element, timeout = 5)
    except requests.exceptions.RequestException as e:
        print(url + "iz ded boi!")
        continue
    
    if "Wordpress" in r.text or "wordpress" in r.text:
        wordpress.append(str(element) + " --- (From HTML Source)")
    else:
        r = requests.get(url = element + "/robots.txt", timeout = 5)
        if "/wp-admin/" in r.text or "/wp-json/" in r.text:
            wordpress.append(str(element) + " --- (From robots.txt)")
        else:
            r = requests.get(url = element + str("/typo3"), timeout = 5)
            if "TYPO3 CMS" in r.text or "typo3 cms" in r.text:
                typo3.append(str(element) + " --- (From HTML Source)")
            else:
                undefined.append(str(element))

#Print everything
print("Scanning done. Here you go:\n")

print("+++++WORDPRESS+++++")
for element in wordpress:
    print(str(element))

print("\n+++++TYPO3+++++")
for element in typo3:
    print(str(element))

print("\n+++++UNDEFINED+++++")
for element in undefined:
    print(str(element))

print("\n+++++DEAD ENDS+++++")
for element in dead_ends:
    print(str(element))

print("\n")