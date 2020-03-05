local history = {}
term.setCursorPos(1, 1)
term.clear()
local shell = _G.shell
local util = require("/lib/util")
local fl = util.loadModule("file")
local ps = fl.readTable("/etc/accounts.cfg")
local flArq = fl.readTable("/etc/arqPasta.cfg")
os.loadAPI("/lib/nc.lua")
local t = false
local root = false
local color = colors.green
local color2 = colors.lime

local function falseRoot()
    term.setTextColor(color)
    print("entre no modo: root")
    t = true
end


while true do
    local dir = shell.dir()
    if dir == "" then
	for i, v in pairs(ps) do
          dir = v.homeDir	
        end
	local dire = "cd "..dir
	shell.run(dire)
    end
    term.setTextColor(color)
    for i, v in pairs(ps) do
      term.write(v.name)	
    end
    term.setTextColor(color2)
    term.write("@")
    term.setTextColor(color)
    term.write(os.getComputerLabel() or os.getComputerID())
    term.setTextColor(color2)
    term.write("#")
    term.setTextColor(color)
    term.write(dir.." ")
    term.setTextColor(colors.white)
    
    local input = read(nil, history)
    if input == "exit" then
	os.unloadAPI("/lib/nc.lua")
	wm.endProcess(id)
	break
    elseif input == "nc" then
	nc.start()
	t = true
    end
    if root == false then
	if input == "root" then
	    term.setTextColor(color)
	    print("root: true")
	    color = colors.white
	    color2 = colors.gray
            root = true
	    t = true
	end   
	for i, v in pairs(flArq) do
	    local cdPath = "cd "..v
	    local delPath = "delete "..v
	    local editPath = "edit "..v
	    local rmPath = "rm "..v
            if input == cdPath then
	       falseRoot()
            elseif input == delPath then
	       falseRoot()
            elseif input == editPath then
	       falseRoot()
            elseif input == rmPath then
	       falseRoot()
            end
    	end
    end
    if input ~= history[#history] then
        table.insert(history, input)
    end
    if t == false then
	shell.run(input)
    else
	t = false
    end
end
