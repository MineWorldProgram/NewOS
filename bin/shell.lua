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
local first = true
local color = colors.green
local color2 = colors.lime

local sudoComand = "sudo -i"

local function falseRoot()
    term.setTextColor(color)
    print("Entre no Modo root digitando '"..sudoComand.."'")
    t = true
end


while true do
    local dir = shell.dir()

    if (dir == "" and root == false and first == false) then
        print("You need to be in root mode to acess this directory")
        print("To enable root mode type '"..sudoComand.."'")
        shell.run('cd '..dir)
    elseif first == true then
        for i, v in pairs(ps) do
            dir = v.homeDir	
        end
        shell.run('cd '..dir)
        first = false
    end

    term.setTextColor(color)
    for i, v in pairs(ps) do
      term.write(v.name)	
    end
    term.setTextColor(color)
    term.write("@")
    term.write(os.getComputerLabel() or os.getComputerID())
    term.setTextColor(color2)
    term.write(":")
    term.setTextColor(color)
    term.write(dir)
    term.setTextColor(colors.white)
    term.write("$".." ")
    
    local input = read(nil, history)
    if input == "exit" and root == true then
        root = false
        term.setTextColor(color)
	    print("sudo: false")
	    print("type exit again to close the terminal")
	    color = colors.green
	    color2 = colors.lime

	    t = true
    elseif input == "exit" then
	    os.unloadAPI("/lib/nc.lua")
	    wm.endProcess(id)
	    break
    elseif input == "nc" then
	    nc.start()
	    t = true
    end
    if root == false then
	if input == sudoComand then
	    term.setTextColor(color)
	    print("sudo: true")
	    color = colors.white
	    color2 = colors.white
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
                break
            elseif input == delPath then
	            falseRoot()
                break
            elseif input == editPath then
	            falseRoot()
                break
            elseif input == rmPath then
	            falseRoot()
                break
            elseif input == 'reboot' then
                falseRoot()
                break
            elseif input == 'shutdown' then
                falseRoot()
                break
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
