#!/usr/bin/python3

from impacket import version
from impacket.examples import logger
from impacket.examples.utils import parse_credentials

import argparse
import logging
import sys
import ldapdomaindump
import ldap3

from utils.helper import *

def maq(options):

    domain, username, password, lmhash, nthash = parse_identity(options)
    ldap_server, ldap_session = init_ldap_session(options, domain, username, password, lmhash, nthash)

    cnf = ldapdomaindump.domainDumpConfig()
    cnf.basepath = None
    domain_dumper = ldapdomaindump.domainDumper(ldap_server, ldap_session, cnf)

    for i in domain_dumper.getDomainPolicy():
        MachineAccountQuota = int(str(i['ms-DS-MachineAccountQuota']))

    dcinfos = get_dc_hosts(ldap_session, domain_dumper)
    if len(dcinfos) == 0:
        logging.critical("Cannot get domain info")
        exit(1)

    dcinfo = dcinfos[0]
    found = False

    dc_host = dcinfo['name'][0].lower()
    dcfull = dcinfo['dNSHostName'][0].lower()
    logging.info(f'Selected Target {dcfull}')
    if MachineAccountQuota < 0:
        logging.info(f'ms-DS-MachineAccountQuota {MachineAccountQuota}')
        exit()
    else:
        logging.info(f'Current ms-DS-MachineAccountQuota = {MachineAccountQuota}')
        exit()

if __name__ == '__main__':
    # Init the example's logger theme
    logger.init()
    parser = argparse.ArgumentParser(add_help=True, description="MAQ")

    parser.add_argument('account', action='store', metavar='[domain/]username[:password]',
                        help='Account used to authenticate to DC.')
    parser.add_argument('-domain-netbios', action='store', metavar='NETBIOSNAME',
                        help='Domain NetBIOS name. Required if the DC has multiple domains.')
    parser.add_argument('-debug', action='store_true', help='Turn DEBUG output ON')

    parser.add_argument('-port', type=int, choices=[139, 445, 636],
                        help='Destination port to connect to. SAMR defaults to 445, LDAPS to 636.')

    group = parser.add_argument_group('authentication')
    group.add_argument('-hashes', action="store", metavar="LMHASH:NTHASH", help='NTLM hashes, format is LMHASH:NTHASH')
    group.add_argument('-no-pass', action="store_true", help='don\'t ask for password (useful for -k)')
    group.add_argument('-k', action="store_true",
                       help='Use Kerberos authentication. Grabs credentials from ccache file '
                       '(KRB5CCNAME) based on account parameters. If valid credentials '
                       'cannot be found, it will use the ones specified in the command '
                       'line')
    group.add_argument('-aesKey', action="store", metavar="hex key",
                       help='AES key to use for Kerberos Authentication (128 or 256 bits)')
    group.add_argument('-dc-host', action='store', metavar="hostname",
                       help='Hostname of the domain controller to use. If ommited, the domain part (FQDN) '
                       'specified in the account parameter will be used')
    group.add_argument('-dc-ip', action='store', metavar="ip",
                       help='IP of the domain controller to use. Useful if you can\'t translate the FQDN.'
                       'specified in the account parameter will be used')
    parser.add_argument('-use-ldaps', action='store_true', help='Use LDAPS instead of LDAP')

    if len(sys.argv)==1:
        parser.print_help()
        sys.exit(1)

    options = parser.parse_args()

    if options.debug is True:
        logging.getLogger().setLevel(logging.DEBUG)
        # Print the Library's installation path
        logging.debug(version.getInstallationPath())
    else:
        logging.getLogger().setLevel(logging.INFO)

    domain, username, password = utils.parse_credentials(options.account)
    account_format_invalid = False
    try:
        while domain is None or domain == '':
            account_format_invalid = True
            logging.critical('Domain should be specified!')
            domain = input("[*] Please specify a domain: ")

        if password == '' and username != '' and options.hashes is None and options.no_pass is False and options.aesKey is None:
            account_format_invalid = True
            from getpass import getpass
            password = getpass(f"[*] Password for account {username}: ")

        if options.aesKey is not None:
            options.k = True

        if account_format_invalid and password and password != "":
            options.account = f"{domain}/{username}:{password}"

        if account_format_invalid and not password and password == "":
            options.account = f"{domain}/{username}"

        maq(options)
    except Exception as e:
        if logging.getLogger().level == logging.DEBUG:
            import traceback
            traceback.print_exc()
        print(str(e))