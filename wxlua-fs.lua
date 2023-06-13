#!/usr/bin/env lua

local wx = require("wx")
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

local frame = wx.wxFrame(wx.NULL, wx.wxID_ANY, "wxLua Minimal Demo",
                         wx.wxDefaultPosition, wx.wxSize(450, 450),
                         wx.wxDEFAULT_FRAME_STYLE)

-- create a simple file menu
local fileMenu = wx.wxMenu()
fileMenu:Append(wx.wxID_EXIT, "E&xit", "Quit the program")

-- create a simple help menu
local helpMenu = wx.wxMenu()
helpMenu:Append(wx.wxID_ABOUT, "&About", "About the wxLua Minimal Application")

-- create a menu bar and append the file and help menus
local menuBar = wx.wxMenuBar()
menuBar:Append(fileMenu, "&File")
menuBar:Append(helpMenu, "&Help")
-- attach the menu bar into the frame
frame:SetMenuBar(menuBar)

-- create a simple status bar
frame:CreateStatusBar(1)
frame:SetStatusText("Welcome to wxLua.")

-- create a button
local button = wx.wxButton(frame, wx.wxID_ANY, "Click Me",
                           wx.wxDefaultPosition, wx.wxDefaultSize)

-- create a text box
local textBox = wx.wxTextCtrl(frame, wx.wxID_ANY, "",
                              wx.wxDefaultPosition, wx.wxDefaultSize,
                              wx.wxTE_MULTILINE + wx.wxTE_READONLY)

-- create a sizer to layout the button and text box vertically
local sizer = wx.wxBoxSizer(wx.wxVERTICAL)
sizer:Add(button, 0, wx.wxALIGN_CENTER_HORIZONTAL + wx.wxALL, 10)
sizer:Add(textBox, 1, wx.wxEXPAND + wx.wxALL, 10)

-- set the sizer for the frame
frame:SetSizer(sizer)

-- function to unlock the text box
local function UnlockTextBox()
    -- Remove the wxTE_READONLY style
    local style = textBox:GetWindowStyleFlag()
    style = style - wx.wxTE_READONLY
    textBox:SetWindowStyleFlag(style)
end

local function generateNumbers()
  for i=1,1000 do
    local text = textBox:GetValue()
    text = text..tostring(i).."\n"
    textBox:SetValue(text)
    wx:wxGetApp():MainLoop()
  end
end

-- connect the button click event to an event handler
frame:Connect(button:GetId(), wx.wxEVT_COMMAND_BUTTON_CLICKED,
  function (event)
    generateNumbers()
end)

io.write()
-- finally, show the frame window
frame:Show(true)
UnlockTextBox()
-- Start the main event loop
wx.wxGetApp():MainLoop()