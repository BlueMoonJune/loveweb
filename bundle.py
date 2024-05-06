import os
import sys


output = "local bundle = [["
root = sys.argv[1]

def process(path):
    global output
    if os.path.isfile(path):
        output += ('### ' + path[len(root)+1:] + ' ###\n')
        with open(path, 'rb') as file:
            output += file.read().hex() + '\n'
    else:
        for item in os.listdir(path):
            process(path + "/" + item)

process(root)

output += '''
]]
for path, s in bundle:gmatch("### ([^ ]*) ###\\n([^\\n]*)\\n") do
	local bytes = s:gsub("%x%x", function(digits) return string.char(tonumber(digits, 16)) end)
	love.filesystem.write(path, bytes)
end

love.filesystem.load("run.lua")()
'''

with open('output.lua', 'w') as file:
    file.write(output)