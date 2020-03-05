local textbox = require("/lib/textbox")
local w, h = term.getSize()
local box = textbox.new(2, 1, w - 2, nil, "_")
local util = require("/lib/util")
local fl = util.loadModule("file")
local apps = fl.readTable("/etc/storeApps.cfg")

local function draw()
    local w, h = term.getSize()
    term.setBackgroundColor(colors.black)
    term.clear()
    box.redraw()
    term.setCursorPos(1, 3)
    if w == 30 then
	term.setTextColor(colors.lime)
	term.write("\149")
	term.setTextColor(colors.gray)
	term.write(" Name      ")
	term.setTextColor(colors.lime)
	term.write("\149")
	term.setTextColor(colors.gray)
	term.write(" Type      ")
	term.setTextColor(colors.lime)
	term.write("\149")
	term.setTextColor(colors.gray)
	term.write(" mb ")
	term.setTextColor(colors.lime)
	term.write("\149")
    else
	term.setTextColor(colors.lime)
	term.write("\149")
	term.setTextColor(colors.gray)
	term.write(" Name      ")
	term.setTextColor(colors.lime)
	term.write("\149")
	term.setTextColor(colors.gray)
	term.write(" Type      ")
	term.setTextColor(colors.lime)
	term.write("\149")
	term.setTextColor(colors.gray)
	term.write(" mb ")
	term.setTextColor(colors.lime)
	term.write("\149")
	term.setTextColor(colors.gray)
	term.write(" repository       ")
	term.setTextColor(colors.lime)
	term.write("\149")
	term.setTextColor(colors.gray)
	term.write("\8\8")
    end	
    term.setCursorPos(4, h - 1)
    term.setTextColor(colors.gray)
    term.setBackgroundColor(colors.green)
    term.write(" OK ")
    term.setTextColor(colors.white)
    local c = 4
    for i, v in pairs(apps) do
	term.setTextColor(colors.white)
	term.setBackgroundColor(colors.gray)
        term.setCursorPos(1, c)
        term.clearLine()
	if sLi == i then
	    term.setBackgroundColor(colors.lightGray)
            term.clearLine()
	end
        term.setCursorPos(3, c)
	term.write(v.name)
        term.setCursorPos(15, c)
	term.write(v.type)
        term.setCursorPos(26, c)
	term.write(v.size)
    	if w > 30 then
            term.setCursorPos(32, c)
	    term.write(v.repo)
            term.setCursorPos(50, c)
	    if v.vist == "n" then
	        term.setTextColor(colors.red)
	        term.write(" \8")
	    else 
	        term.setTextColor(colors.lime)
	        term.write("\8")
	    end
	end
    	c = c + 1
        if c == h - 3 then
	    break
	end
    end
    

end

local function draw2(name)
    local w, h = term.getSize()
    term.setBackgroundColor(colors.black)
    term.clear()
    term.setCursorPos(2, 1)
    term.setBackgroundColor(colors.green)
    term.setTextColor(colors.gray)
    term.write("<")
    term.setCursorPos(w / 6 * 5, 1)
    term.write("add")
    term.setBackgroundColor(colors.black)
    term.setCursorPos(w / 6 , 2)
    term.setTextColor(colors.white)
    for i, v in pairs(apps) do
	if name == v.name then
    	    term.write(v.name)
   	    term.setTextColor(colors.gray)
    	    term.setCursorPos(w / 6 , 3)
    	    term.write(v.config.autor)
   	    term.setTextColor(colors.white)
    	    term.setCursorPos(w / 10 , 5)
    	    term.write(("Descrição: %s"):format(v.config.descrition))
    	    term.setCursorPos(w / 6 , h - 2)
    	    term.write(("Versão: %s"):format(v.config.version))
	end
    end
    
    
    
end


local function whileDraw2(name)
    local cmd = true
    while cmd do
        draw2(name)
	local e = {os.pullEvent()}
	if e[1] == "mouse_click" then
	    local m, x, y = e[2], e[3], e[4]
	    if x == 2  and y == 1 then
		cmd = false
	    end
	end
    end
end

draw()
while true do
    local w, h = term.getSize()
    draw()
    local e = {os.pullEvent()}
    if e[1] == "mouse_click" then
        local m, x, y = e[2], e[3], e[4]
        if x >= 2 and x <= w - 7 and y == 1 then
            content = box.select()
	    for i, v in pairs(apps) do
	        if content == v.name then
		    whileDraw2(v.name)
		end
	    end
	elseif x >= 4 and x <= 7 and y == h - 1 then
	    if sLi == nil then
	    else
		for i, v in pairs(apps) do
		    if sLi == i then
	                whileDraw2(v.name)
		    end
		end
	    end
        elseif m == 1 then
	    local c = 4
	    for i, v in pairs(apps) do
	        if y == c then
		    sLi = i
	    	    break      
	        end
	        c = c + 1
	    end
        end
        
    end
end
