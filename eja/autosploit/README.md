## Autosploit Usage
```
usage: autosploit.py [-h] -w WORKSPACE
                     [-p {udp,ftp,telnet,http,dns,snmp,smtp,mssql,mysql,ipmi,smb,rdp,dcerpc,ldap,ssh,rsh,imap,pop3,ntp,vnc,ssdp,printer,konica,postgres}]

Autosploit Version 1.1.0

optional arguments:
  -h, --help            show this help message and exit
  -w WORKSPACE          workspace to scan via resource
  -p {udp,ftp,telnet,http,dns,snmp,smtp,mssql,mysql,ipmi,smb,rdp,dcerpc,ldap,ssh,rsh,imap,pop3,ntp,vnc,ssdp,printer,konica,postgres}
                        limit scant to given protocol
```

## JSON Structure
```json
"$PROTOCOL": {
    "port": [1337, 4444],
    "msf": {
        "$MODULE01": {},
        "$MODULE02": {
            "$OPTION": "$VALUE",
            "$OPTION": "$VALUE"
        }
    }
}
```
