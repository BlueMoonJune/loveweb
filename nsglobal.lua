local gmeta = getmetatable(_G) or {}
local _require = require
local root = {}
local pathCache = {}
PATH = "main"
RAWG = {
    __index = function (_, k)
        return rawget(_G, k)
    end,
    __newindex = function (_, k, v)
        rawset(_G, k, v)
    end
}
setmetatable(RAWG, RAWG)

local function getNamespace(path)
    local ns = pathCache[path]
    if ns then
        return ns
    end
    local t = root
    for dir in path:gmatch('[^./]+') do
        if not t[dir] then
            t[dir] = {}
        end
        t = t[dir]
    end
    return t
end

function require(modname)
    local oldpath = PATH
    PATH = modname
    local ret = {_require(modname)}
    PATH = oldpath
    return getNamespace(modname), table.unpack(ret)
end

function gmeta.__index(_, k)
    return getNamespace(PATH)[k] or root[k]
end

function gmeta.__newindex(_, k, v)
    getNamespace(PATH)[k] = v
end

setmetatable(_G, gmeta)

function RAWG.printTable(t, depth)
    depth = depth or 1
    if depth == 1 then
        print("{")
    end
    local indent = ("    "):rep(depth)
    for k, v in pairs(t) do
        if type(v) == "table" then
            print(indent .. k .. " = {")
            printTable(v, depth + 1)
            print(indent .. "},")
        else
            print(indent .. k .. " = " .. v)
        end
    end
    if depth == 1 then
        print("}")
    end
end