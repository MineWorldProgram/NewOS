local function nc()
    print()
    term.setTextColor(colors.gray)
    term.write("suporte ")
    term.setTextColor(colors.white)
    term.write("NewCraft Corporation ")
    term.setTextColor(colors.gray)
    term.write("e")
    term.setTextColor(colors.white)
    term.write(" NC System")
    term.setTextColor(colors.gray)
    term.write(": ")
    term.setTextColor(colors.lime)
    print("OK \n")
end

local function nchelp()
    print("\nUse:")
    print("nc")
    print("update")
    print("run\n")
end

local function ncUpdate()
    print("não tem update nessa versão do NewOS")
end

local function ncRun()
    print("não tem run nessa versão do NewOS")
end

function start()
    term.clear()
    term.setCursorPos(1,1)
    term.setTextColor(colors.lime)
    term.write("NC: ")
    term.setTextColor(colors.white)
    local arg = read()
    if arg == "nc" then
	nc()
    elseif arg == "-help" then
	nchelp()
    elseif arg == "update" then
	ncUpdate()
    elseif arg == "run" then
	ncRun()
    else
        term.setTextColor(colors.lime)
	print("este comando não existe")
	print()
	return
    end
end
