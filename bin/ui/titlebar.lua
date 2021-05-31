local ok, err = pcall(function()
  local menuPID
  local hiddenNames = {"menu", "titlebar"}
  local running = {}
  local procList
  local positionHandled = false

  local util = require("/lib/util")
  local file = util.loadModule("file")
  local theme = file.readTable("/etc/colors.cfg")
  local wm = _G.wm

  for i, v in pairs(_G) do
    write(i .. " ")
  end

  local function draw()
    procList = wm.listProcesses()
    tw, th = wm.getSize()
    if (procList[id] ~= nil and positionHandled == false) then
      procList[id].width = tw
      procList[id].height = 1
      procList[id].y = th
      procList[id].x = 1
      procList[id].showTitlebar = false
      procList[id].dontShowInTitlebar = true
      procList[id].resizable = false
      os.queueEvent('term_resize')
      positionHandled = true
    end

    term.setBackgroundColor(theme.menu.background)
    term.clear()
    term.setCursorPos(1,1)
    term.setTextColor(theme.menu.textSecondary)
    if menuPID and procList[menuPID] then
      term.setBackgroundColor(theme.menu.background)
      term.setTextColor(theme.menu.text)
    else
      menuPID = nil
    end
    term.write("NewOS ")

    for i, v in pairs(procList) do
      if not v.dontShowInTitlebar then
        local x, y = term.getCursorPos()
        v.startX = x
        if v == wm.getSelectedProcess() then
          term.setTextColor(theme.menu.text)
        else
          term.setTextColor(theme.menu.textSecondary)
        end
        local ins = v
        term.write(v.title .. " ")
        local x, y = term.getCursorPos()
        v.endX = x
        v.pid = i
        table.insert(running, v)
      end
    end
  end

  while true do
    local e = {os.pullEvent()}
    draw()
    if e[1] == "mouse_click" then
      local m, x, y = e[2], e[3], e[4]
      if m == 1 then
        if x < 6 and y == 1 then
          if menuPID and wm.listProcesses()[menuPID] == nil then
            menuPID = nil
          else
            if menuPID ~= nil then
              wm.endProcess(menuPID)
              menuPID = nil
            else
              local w, h = wm.getSize()
              menuPID = wm.createProcess("/bin/ui/menu.lua", {
                x = 1,
                y = 1,
                width = 12,
                height = 2,
                showTitlebar = false,
                dontShowInTitlebar = true
              })
  
              wm.selectProcess(menuPID)
            end
          end
        else
          local pid
          for i, v in pairs(running) do
            if x >= v.startX and x <= v.endX then
              pid = v.pid
            end
          end

          if pid then
            if procList[pid].minimized then
              wm.unminimizeProcess(pid)
            end
            wm.selectProcess(pid)
          end
        end
      elseif m == 2 then
        if x < 6 and y == 1 then
          if menuPID and wm.listProcesses()[menuPID] == nil then
            menuPID = nil
          else
            if menuPID ~= nil then
              wm.endProcess(menuPID)
              menuPID = nil
            else
              local w, h = wm.getSize()
              menuPID = wm.createProcess("/bin/ui/menu2.lua", {
                x = 1,
                y = h - 1,
                width = 6,
                height = 5,
                showTitlebar = false,
                dontShowInTitlebar = true
              })
  
              wm.selectProcess(menuPID)
            end
          end
        else
          local pid
          for i, v in pairs(running) do
            if x >= v.startX and x <= v.endX then
              pid = v.pid
            end
          end

          if pid then
            if procList[pid].minimized then
              wm.unminimizeProcess(pid)
            end
            wm.selectProcess(pid)
          end
        end
      end
    end
  end
end)

print(tostring(ok) .. " " .. err)
sleep(1000)
