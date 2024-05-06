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
    local curPath = ""
    for dir in path:gmatch('[^./]+') do
        curPath = curPath .. dir
        if not rawget(t, dir) then
            t[dir] = {}
        end
        t = t[dir]
        curPath = curPath .. "."
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

local function isModuleAvailable(name)
    if package.loaded[name] then
        return true
    else
        for _, searcher in ipairs(package.searchers or package.loaders) do
            local loader = searcher(name)
            if type(loader) == 'function' then
                package.preload[name] = loader
                return true
            end
        end
        return false
    end
end

local dir = {}
dir.__index = function (t, v)
    local path
    if not rawget(t, 'path') then
        path = v
    else
        path = t.path .. '.' .. v
    end
    if isModuleAvailable(path) then
        return require(path)
    else
        return setmetatable({path = path}, dir)
    end
end

setmetatable(root, dir)

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