local textbox = require("/lib/textbox")
local util = require('/lib/util')
local sha256 = require("/lib/sha256")
local file = util.loadModule("file")
local w, h = term.getSize()
local username = textbox.new(2, 4, w - 2, nil, "Usuario")
local password = textbox.new(2, 6, w - 2, "\7", "Senha")

local usrRaw = ""
local pswrdRaw = ""
local errorText = ""

local function draw()
    local w, h = term.getSize()
    term.setBackgroundColor(colors.white)
    term.clear()
    username.redraw()
    password.redraw()
    term.setCursorPos(2,2)
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.gray)
    term.write("Crie sua conta")
    term.setCursorPos(2,8)
    term.setBackgroundColor(colors.green)
    term.setTextColor(colors.gray)
    term.write(" Registrar ")
    term.setCursorPos((13 + 1), 8)
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.red)
    term.write(errorText)

    local foregroundColor = colors.lightGray

    if wm.getSelectedProcessID() == id then
        foregroundColor = colors.green
    end

    for i = 1, h - 1 do
        term.setCursorPos(1, i)
        term.setTextColor(foregroundColor)
        term.setBackgroundColor(colors.white)
        term.write("\149")
    end
    for i = 1, h - 1 do
        term.setCursorPos(w, i)
        term.setTextColor(colors.white)
        term.setBackgroundColor(foregroundColor)
        term.write("\149")
    end
    term.setCursorPos(2, h)
    term.setTextColor(colors.white)
    term.setBackgroundColor(foregroundColor)
    term.write(string.rep("\143", w - 2))

    term.setCursorPos(1, h)
    term.setTextColor(colors.white)
    term.setBackgroundColor(foregroundColor)
    term.write("\138")
    term.setCursorPos(w, h)
    term.setTextColor(colors.white)
    term.setBackgroundColor(foregroundColor)
    term.write("\133")
end

draw()
while true do
    draw()
    local e = {os.pullEvent()}
    if e[1] == "mouse_click" then
        local m, x, y = e[2], e[3], math.ceil(e[4])
        if x >= 2 and x <= w - 2 and y == 4 then
            usrRaw, goToNext = username.select()
            if goToNext then
                pswrdRaw = password.select()
            end
        elseif x >= 2 and x <= w - 2 and y == 6 then
            pswrdRaw = password.select()
        elseif x >= 2 and x <= 12 and y == 8 then
            if (usrRaw ~= '' and pswrdRaw ~= '') then
                local data = {
                    {
                        name = usrRaw,
                        passwordHash = sha256(pswrdRaw),
                        homeDir = "/home/"..usrRaw
                    }
                }
                
                local file = fs.open("/etc/accounts.cfg", "w")
                file.write(textutils.serialize(data))
                file.close()
                fs.makeDir("home/"..usrRaw.."/Documentos")
                fs.makeDir("home/"..usrRaw.."/Musica")
                fs.makeDir("home/"..usrRaw.."/Imagens")
                fs.makeDir("home/"..usrRaw.."/Videos")
                fs.makeDir("home/"..usrRaw.."/Downloads")
                term.setCursorPos(2,8)
                term.setBackgroundColor(colors.gray)
                term.setTextColor(colors.white)
                term.write(" Registrar ")
                sleep(1)
                os.reboot()
            else
                errorText = 'Preencha os campos'
            end
        end
    end
end