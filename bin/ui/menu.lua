local tw, th = wm.getSize()
local positionHandled = false
local reRender = true

local applicationsA = {
  {
    title = " ",
  },
  {
    title = "@:Desligar",
    path = "/bin/ui/shutdown.lua",
    settings = {
      width = 15,
      height = 8,
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
    title = "Arquivos",
    path = "/bin/ui/ExplorerNC.lua",
    settings = {
      width = 30,
      height = 15,
      title = "Arquivos"
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
      width = 30,
      height = 13,
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
  procList = wm.listProcesses()
  if (procList[id] ~= nil and positionHandled == false) then
    local biggetsWordSize = 0
    for i, v in pairs(applicationsA) do
      if (string.len(v.title) > biggetsWordSize) then
        biggetsWordSize = string.len(v.title)
      end
    end
    if (biggetsWordSize + 1 > procList[id].width) then
      procList[id].width = biggetsWordSize + 1
    end
    procList[id].height = table.getn(applicationsA) + 1
    procList[id].y = (th - (table.getn(applicationsA) + 1))
    os.queueEvent('term_resize')
    positionHandled = true
  end
  term.setCursorPos(1,1)
  term.setBackgroundColor(theme.menu.background)
  term.clear()
  term.setTextColor(theme.menu.text)
  for i, v in pairs(applicationsA) do
    print(v.title)
  end
end

while true do
  if (reRender) then
    draw()
  end
  local e = {os.pullEvent()}
  if e[1] == "mouse_click" then
    reRender = false
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
