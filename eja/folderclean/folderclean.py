#!/usr/bin/env python3
import os
import argparse
import shutil

# Arg Parse
ap = argparse.ArgumentParser()
ap.add_argument("path", nargs='?', default=None)
args = ap.parse_args()

# Remove Empty Folders
def drop_empty_folders(directory):
    for dirpath, dirnames, filenames in os.walk(directory, topdown=False):
        if ".DS_Store" in filenames: filenames.remove(".DS_Store")
        if not dirnames and not filenames:
            shutil.rmtree(dirpath, ignore_errors=True)
            print("-> Removed (", dirpath, ")")

# Main
if __name__ == '__main__':
    if not args.path: print("[x] Missing Postional Argument"); exit()
    if not os.path.exists(args.path): print("[x] Invalid Path"); exit()
    for x in range(10): drop_empty_folders(args.path)
    print("[ Deleted All Unnecessary Folders & Subdirecotories ]"); exit()
