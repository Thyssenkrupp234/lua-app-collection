#!/usr/local/bin/lua

-- variables --

local homedir = os.getenv("HOME").."/"
local cshell = os.getenv("SHELL")
local http = require("ssl.https")

--[[

Welcome to Lincoln's "useless" lua tool. this command-line tool can do lots of random things, like file delete/read/write, random numbers, randmon quotes, etc.




]]
function intro()
    io.write("\27[40m")
    io.write("\027[H\027[2J")
    io.write("\27[92mWelcome to Lincoln's useless Lua tool!\n\nDate: \27[95m"..os.date().."\n\27[92mShell: \27[95m"..cshell.."\n\27[92mHome Directory: \27[95m"..homedir.."\27[39m\n\nPick an \27[96moption\27[39m:\n1. Write a file\n2. Read a file\n3. Generate a random number\n4. Delete a file\n5. Print a random quote\n6. Print a random insult\nQ. Quit the app\nR. Relaunch app\n\nYour Choice: ")
    local response = io.read()
    local options = {
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "q",
        "Q",
        "r",
        "R"
    }
    local found = false
    for i, v in ipairs(options) do
        if v == response then
            found = true
            break
        end
    end
    if not found then
        intro()
    end
    main(response)
end
function write()
    io.write("\027[H\027[2J")
    io.write("\nEnter the \27[92mpath \27[39mof the file you want to create: ")
    local path = io.read()
    path = string.gsub(path, "~/", homedir)
    io.write("\nWhat do you want the \27[92mcontents \27[39mof the file to be: ")
    local contents = io.read()
    file = io.open(path, "w")
    file:write(contents)
    file:close()
    io.write("\n\nSuccessfully written the file. Press enter to return to the main menu.")
    io.read()
    intro()
    return
end

-- read function
function read()
    io.write("\027[H\027[2J")
    io.write("\nEnter the path of the file you want to read: ")
    local path = io.read()
    path = string.gsub(path, "~/", homedir)
    local file = io.open(path)
    if file then
        file:close()
        file = io.open(path, "r")
        local content = file:read()
        io.write("\n\nContents of the file are: "..content)
        file:close()
        io.write("\n\n\nPress enter to return to main menu")
        io.read()
        intro()
    else
        io.write("File doesn't exist, press enter to return to main menu")
        io.read()
        intro()
    end
end

-- random number generator
function random()
    io.write("\027[H\027[2J")
    io.write("\27[96mGenerate a random number tool\27[39m") --change font to blue and back
    io.write("\n\nChoose the \27[92mlowest number\27[39m: ")
    local lowest = io.read()
    io.write("\027[H\027[2J")
    io.write("\27[96mGenerate a random number tool\27[39m") --change font to blue and back
    io.write("\n\nChoose the \27[91mhighest number\27[39m: ")
    local highest = io.read()
    local result = math.random(lowest,highest)
    io.write("\n\n\27[92mChosen number\27[39m: \27[95m"..result.."\27[39m")
    io.write("\n\n\nPress return to enter main menu")
    io.read()
    intro()
    return
end

function delete()
    io.write("\027[H\027[2J") -- clear terminal
    io.write("\27[96mDelete a file tool\27[39m") --change font to blue and back
    io.write("\n\nEnter path of file you want to delete: ")
    local path = io.read()
    path = string.gsub(path, "~/", homedir)
    local file = io.open(path)
    if file then
        file:close()
        os.remove(path)
        io.write("File deleted. Press enter to return to main menu.")
        io.read()
        intro()
    else
        io.write("Welp, file doesn't exist. Press enter to return to main menu.")
        io.read()
        intro()
        return
    end
end

function quote()
    io.write("\027[H\027[2J") -- clear terminal
    local quotes = {
        "I'm brilliant half the time, you're brilliant all the time.\nI'm payed full time, you're payed no time.\n\n- Mark Kershaw, January, 2023.",
        "Dear Catamaran Detergent,\n\n- Rosemary",
        "Out of sight; out of mind.\n\n- Vincent, December, 2023.",
        "Live life vibing.\n\n- Lincoln Muller, 2022.",
        "Sh*t yourself, you poopfart on a sh*tstick.\n\n- Isiaah, Vincent, 2022."
    }
    local a = math.random(1,5)
    io.write(quotes[a])
    io.write("\n\nPress enter to return to main menu")
    io.read()
    intro()
end

function insult()
    local result = http.request("https://insult.mattbas.org/api/insult")
    io.write("\027[H\027[2J") -- clear terminal
    io.write(result)
    io.write("\n\nPress enter to return to main menu")
    io.read()
    intro()
end

function main(a)
    if a == "1" then
        write()
    elseif a == "2" then
        read()
    elseif a == "3" then
        random()
    elseif a == "4" then
        delete()
    elseif a == "5" then
        quote()
    elseif a == "6" then
        insult()
    elseif string.lower(a) == "q" then
        io.write("\27[0m")
        io.write("\027[H\027[2J") -- clear terminal
        io.write("Thank you for using Lincoln's useless lua tool. Cleaning cache and exiting utility...")
        io.write("\27[0m\n\n\n\n\n\n\n")
        os.execute("sleep 2.5")
        os.execute("clear")
        os.exit()
    elseif string.lower(a) == "r" then
        io.write("\027[H\027[2J")
        print("please wait")
        os.execute("sleep 3 && fs")
        os.exit()
    end
end

-- call the intro function
intro()