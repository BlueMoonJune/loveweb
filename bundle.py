import os

output = ""

def process(path):
    global output
    print(path, "is a...")
    if os.path.isfile(path):
        print("file.")
        output += "### " + path + "\n"
        with open(path, 'r') as file:
            for line in file.readlines():
                output += line
    else:
        print("directory.")
        for item in os.listdir(path):
            process(path + "/" + item)

process("src")

with open('output', 'w') as file:
    file.write(output)