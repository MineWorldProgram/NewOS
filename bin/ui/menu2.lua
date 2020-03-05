local tw, th = wm.getSize()

local applicationsA = {
  {
    title = " ",
  },
  {
    title = "Sobre",
    path = "/bin/ui/about.lua",
    settings = {
      width = 15,
      height = 6,
      title = "about"
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
