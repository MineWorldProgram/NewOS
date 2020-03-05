local nameOS = "NewOS"
local versionOS = "b 1.0"
local baseOS = "zwm"
local versionLua = "v5.1"

local function draw()
    local w, h = term.getSize()
    term.setBackgroundColor(colors.black)
    term.clear()
    term.setCursorPos(w/2-1,2)
    term.setTextColor(colors.lime)
    term.write(nameOS)
    term.setCursorPos(w/2-5,3)
    term.setTextColor(colors.white)
    term.write("Versão:"..versionOS)
    term.setCursorPos(w/2-3,4)
    term.write("Base:"..baseOS)
    term.setCursorPos(w/2-2,5)
    term.write("Lua:"..versionLua)

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
while true do
    draw()
    local e = {os.pullEvent()}
end
