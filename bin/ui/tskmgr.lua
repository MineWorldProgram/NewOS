local selectedID = 0
local procList

local util = require("/lib/util")
local file = util.loadModule("file")
local theme = file.readTable("/etc/colors.cfg")
local wm = _G.wm

local function draw()
  local w, h = term.getSize()
  term.setBackgroundColor(theme.main.background)
  term.clear()
  term.setTextColor(theme.menu.text)
  term.setCursorPos(2, 1)
  term.setBackgroundColor(theme.menu.background)
  term.clearLine()
  term.write("PID")
  term.setCursorPos(7, 1)
  term.write("Nome")
  procList = wm.listProcesses()
  term.setTextColor(theme.main.text)
  local c = 2
  for i, v in pairs(procList) do
    term.setBackgroundColor(theme.main.background)
    term.setCursorPos(2, c)
    if selectedID == i then
      term.setBackgroundColor(theme.main.backgroundSecondary)
      term.clearLine()
    end
    term.write(i)
    term.setCursorPos(7, c)
    term.write(v.title)
    c = c + 1
  end

  if contextShown then
    drawContextMenu()
  end
end

while true do
  draw()
  local e = {os.pullEvent()}
  if e[1] == "mouse_click" then
    local m, x, y = e[2], e[3], e[4]
    if m == 1 then
      local c = 2
      for i, v in pairs(procList) do
        if y == c then
          selectedID = i
          break
        end
        c = c + 1
      end
    end
  elseif e[1] == "key" then
    local key = e[2]
    if key == keys.delete then
      wm.endProcess(selectedID)
    end
  end
end
