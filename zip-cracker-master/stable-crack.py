"""
Created on Sat Sep 26 16:42:54 2020

@author: mohit
"""
import os
import zipfile
from tqdm import tqdm
import time

# todo: Instead of Extracting files, do Open only!

def gettingValues():
    print("Do you have a wordlist?[y]/[n]: ")   
    checkWordList = input()

    if checkWordList == 'n' or checkWordList == 'N':
        found=0
        print("Specify zip file [with destination in case in a foreign directory]: ")
        zippedForlater=input()
        zyndra(found,zippedForlater)
    else:
        pass

    print("Specify the zip file [with destination in case in a foreign directory]: ")
    zip_file = input()
    zippedForlater=zip_file #this is for zyndra if dict. crack doesn't work.

    # wordlist for cracking the zip file
    print("Specify wordlist file [with destination in case in a foreign directory]: ")
    wordlist = input()
    theCrack(zip_file,wordlist,zippedForlater)


def theCrack(zip_file,wordlist,zippedForlater):
    zipped=zippedForlater
    # initialize the Zip File object
    zip_file = zipfile.ZipFile(zip_file)
    # count the number of words in this wordlist
    n_words = len(list(open(wordlist, "rb")))
    # print the total number of passwords
    print("Total passwords to test:", n_words)

    # Checking for corrupted zip files
    if zip_file==zipfile.BadZipFile:
        print("{} is a corrupted zip file.Repair the zip file before continuing".format(zip_file))
        exit()
    else:
        pass
    # doing the actual crack.
    with open(wordlist, "rb") as wordlist:
        for word in tqdm(wordlist, total=n_words, unit="word"):
            try:
                zip_file.extractall(pwd=word.strip())
            except:
                continue
            else:
                print("[+] Password found:", word.decode().strip())
                exit()
    print("[!] Password not found, try other wordlist.")
    found=0
    zyndra(found,zipped)

def zyndra(found,zippedForlater):
    if found==0:
        print("Opening ZYDRA for bruteforcing...")
        print("Enter the number of characters: ")
        maxChar=input()
        print("Enter the type of characters: [digits,letters,symbols,space]")
        typeChar=input()
        print("You will be leaving this program now...")
        time.sleep(3)
        openingZydra=os.system("python3 zydra.py -f {} -b {} -m 1 -x {}".format(zippedForlater,typeChar,maxChar))
        
        if openingZydra != 0:
            os.system("python zydra.py -f {} -b {} -m 1 -x {}".format(zippedForlater,typeChar,maxChar))
        
        # print("Something went wrong with the installation, please download/clone the repository again :)")
        
        exit()


def main():

    print ("""  _    ___          __  _______        _        _____ _       _     
 | |  | \ \        / / |__   __|      | |      / ____| |     | |    
 | |__| |\ \  /\  / /     | | ___  ___| |__   | |    | |_   _| |__  
 |  __  | \ \/  \/ /      | |/ _ \/ __| '_ \  | |    | | | | | '_ \ 
 | |  | |  \  /\  /       | |  __/ (__| | | | | |____| | |_| | |_) |
 |_|  |_|   \/  \/        |_|\___|\___|_| |_|  \_____|_|\__,_|_.__/

        A Zip Password cracking tool-*use this tool wisely*\n """)
    gettingValues()


if __name__ == "__main__":
    main()

