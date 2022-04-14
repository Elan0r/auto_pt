#!/usr/bin/env python3
import random
import argparse
import shutil
import os


# Get Arguments
def get_arguments():
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--bcc", action="store_true", help="Mails werden im Bcc: Header eingefügt")
    group.add_argument('--to', action="store_true", help="Mails werden im To: Header eingefügt")
    parser.add_argument("-m", dest="mail_file", help="INPUT: Mail Liste (Pfad)", required=True)
    parser.add_argument("-e", dest="eml_file", help="INPUT: EML Datei (Pfad)", required=True)
    parser.add_argument("-o", dest="filename", help="Output Datei Name (Folder/ZIP)", required=True)
    parser.add_argument("-a", dest="amount", help="Amount of Mails per Header", required=True)
    options = parser.parse_args()
    return options.mail_file, options.eml_file, options.filename, options.bcc, options.to, options.amount


# Parse File
def parse(file):
    file_parse = open(file, 'r')
    linebyline = file_parse.readlines()
    return linebyline


# Write new EML
def write(var_list, eml, bcc_active):
    EML = open(eml, "r")
    replacement = ""
    if bcc_active is True:
        crnt_mail = f"Bcc: {', '.join(var_list)}"
        # Main Parse
        for line in EML:
            changes = line.replace("Bcc:", crnt_mail)
            replacement = replacement + changes
    else:
        crnt_mail = f"To: {', '.join(var_list)}"
        # Main Parse
        for line in EML:
            changes = line.replace("To:", crnt_mail)
            replacement = replacement + changes
    # WRITE FILE
    eml_name = f"mail_{random.randrange(0, 1000000000)}.eml"
    print(f"Writing File: {eml_name} -> [{crnt_mail}]")
    os.chdir(filename)
    writing_file = open(eml_name, "w")
    writing_file.write(replacement)
    writing_file.close()
    os.chdir("..")


# MAIN
if __name__ == '__main__':
    # VAR
    varlist = []
    new_file_content = ""
    counter = 0
    # ARGPARSE
    mail_file, eml_file, filename, bcc, to, amount = get_arguments()
    # MAIN
    try:
        # PARSE FILES
        mail_lst = parse(mail_file)
        mail_lst = list(dict.fromkeys(mail_lst))
        # Create Output Folder
        os.mkdir(filename)
        for mail in mail_lst:
            if len(mail) >= 2:
                varlist.append(mail.strip("\n"))
            counter += 1
            if counter == int(amount):
                if varlist:
                    write(varlist, eml_file, bcc)
                # RESET
                counter = 0
                varlist.clear()
            else:
                pass
        # Remaining Mails
        varlist = list(filter(None, varlist))
        if varlist:
            write(varlist, eml_file, bcc)
        # ZIP Folder
        shutil.make_archive(filename, 'zip', filename)
    except Exception as E:
        print("Error:", E)
