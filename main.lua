http = require 'socket.http'
local baseURL = "https://https://raw.githubusercontent.com//BlueMoonJune/loveweb/main/"

function require(path)
  local url = baseURL..path:gsub("%.", "/")..".lua"
  local func, err = load(http.request(url))
  if func then
    return func()
  else
    error("syntax error in " .. path .. ":\n" .. err)
  end
end

require("helloworld")
