local textbox = require("/lib/textbox")
local w, h = term.getSize()
local box = textbox.new(2, 4, w - 2)

local function draw()
    local w, h = term.getSize()
    term.setBackgroundColor(colors.black)
    term.clear()
    term.setCursorPos(5, 2)
    term.setTextColor(colors.gray)
    term.write("path do programa")
    box.redraw()
    term.setCursorPos(2, 6)
    term.setBackgroundColor(colors.green)
    term.setTextColor(colors.gray)
    term.write(" run ")
    term.setCursorPos(9, 6)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.red)
    term.write("*ainda em teste")

    local foregroundColor = colors.lightGray

    if wm.getSelectedProcessID() == id then
        foregroundColor = colors.lime
    end

    for i = 1, h - 1 do
        term.setCursorPos(1, i)
        term.setTextColor(foregroundColor)
        term.setBackgroundColor(colors.black)
        term.write("\149")
    end
    for i = 1, h - 1 do
        term.setCursorPos(w, i)
        term.setTextColor(colors.black)
        term.setBackgroundColor(foregroundColor)
        term.write("\149")
    end
    term.setCursorPos(2, h)
    term.setTextColor(colors.black)
    term.setBackgroundColor(foregroundColor)
    term.write(string.rep("\143", w - 2))

    term.setCursorPos(1, h)
    term.setTextColor(colors.black)
    term.setBackgroundColor(foregroundColor)
    term.write("\138")
    term.setCursorPos(w, h)
    term.setTextColor(colors.black)
    term.setBackgroundColor(foregroundColor)
    term.write("\133")
end

draw()
local content = ""
while true do
    draw()
    local e = {os.pullEvent()}
    if e[1] == "mouse_click" then
        local m, x, y = e[2], e[3], e[4]
        if x >= 2 and x <= w - 2 and y == 4 then
            content = box.select()
        elseif x >= 2 and x <= 6 and y == 6 then
            local myId = id
            wm.selectProcess(wm.createProcess(content, {
                x = 2,
                y = 3,
                width = 5,
                height = 5
            }))
            wm.endProcess(myId)
            break
        end
    end
end
