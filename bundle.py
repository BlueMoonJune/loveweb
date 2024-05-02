import os
import base64
import sys

output = ""

def process(path):
    global output
    print(path, "is a...")
    if os.path.isfile(path):
        print("file.")
        output += ("### " + path + " ###\n")
        with open(path, 'rb') as file:
            output += str(base64.b64encode(file.read()))[2:-1] + "\n"
    else:
        print("directory.")
        for item in os.listdir(path):
            process(path + "/" + item)

process(sys.argv[1])

with open('output', 'w') as file:
    file.write(output)