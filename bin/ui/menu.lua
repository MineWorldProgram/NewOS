local tw, th = wm.getSize()

local applicationsA = {
  {
    title = " ",
  },
  {
    title = "@:Desligar",
    path = "/bin/ui/shutdown.lua",
    settings = {
      width = 14,
      height = 6,
      showTitlebar = false,
      dontShowInTitlebar = true,
      title = "Power"
    }
  },
  {
    title = " ",
  },
  {
    title = "Loja",
    path = "/bin/ui/store.lua",
    settings = {
      width = 30,
      height = 15,
      title = "Store"
    }
  },
  {
    title = "Task",
    path = "/bin/ui/tskmgr.lua",
    settings = {
      width = 30,
      height = 15,
      title = "Task_Manager"
    }
  },
  {
    title = "Terminal",
    path = "/bin/shell.lua",
    settings = {
      width = 25,
      height = 8,
      title = "Terminal"
  }
  },
  {
    title = "Run",
    path = "/bin/ui/run.lua",
    settings = {
      width = 24,
      height = 7,
      title = "Run"
    }
  }									
}


local util = require("/lib/util")
local file = util.loadModule("file")
local theme = file.readTable("/etc/colors.cfg")
local wm = _G.wm

local function draw()
  term.setBackgroundColor(theme.menu.background)
  term.clear()
  term.setTextColor(theme.menu.text)
  for i, v in pairs(applicationsA) do
    print(v.title)
  end
end

draw()

while true do
  local e = {os.pullEvent()}
  if e[1] == "mouse_click" then
    local m, x, y = e[2], e[3], e[4]
    for i, v in pairs(applicationsA) do
      if y == i then
	if v.title == " " then
	else
        wm.endProcess(id)
        wm.selectProcess(wm.createProcess(v.path, v.settings))
	end      
      end
    end
  end
end
