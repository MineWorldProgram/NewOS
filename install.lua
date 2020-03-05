print("Iniciando o instalador...") sleep(2)

local link
local standardTag = "beta1.0"

local function clr(x,y,cmd)
    if cmd == 1 then
    else	
	term.clear()
    end
    term.setCursorPos(x, y)
end

local function barra()
    print("===================================================")
end

local function getArquivo(nome)
    local arquivo, seg = http.get(link .. nome)
    local volum
    if arquivo then
        volum = arquivo.readAll()
    end
    print("link:"..link..nome) sleep(2)
    return volum, seg
end

local function downloadArquivo(nome)
    local volum = getArquivo(nome)
    local arquivo = fs.open(nome, "w")
    arquivo.write(volum)
    arquivo.close()
    return true
end

local function getInformOS(tag)
    link = "https://raw.githubusercontent.com/NewCraft/NewOS/"..standardTag
    print("Buscando informações de instalação da Versão...") sleep(2)
    local inst, err = getArquivo("/inst/installation.lua")
    if not inst then
        printError("Não foi possível buscar informações de instalação")
        return
    else 
        inst = textutils.unserialize(inst)
    end
    return inst
end

local function install(insta)
    clr(1, 1)
    barra()
    print(("Versão obtida: %s"):format(insta.version)) sleep(0.5)
    print(("Tipo de lançamento: %s"):format(insta.release)) sleep(0.5)
    print(("Espaço necessário: %d"):format(insta.space)) sleep(1)
    print("STATUS de Instalação:")
    if fs.getFreeSpace("/") < insta.space then
        print()
        printError("Não foi possível instalar o OS. Razão: espaço insuficiente")
    else
	barra() sleep(1)
	clr(22, 5, 1)
	term.setTextColor(colors.black)
        print(" (OK)") 
	term.setTextColor(colors.white)
	sleep(1)
	print()
    end

    print(("A instalação criará %d diretórios e instalará %d  arquivos."):format(#insta.directories, #insta.files))
    write("Confirma? Y/n :")
    local ready = read()
    if string.lower(ready) == "n" then
        print("Instalação cancelada.") sleep(0.5)
	term.setBackgroundColor(colors.black)
	clr(1,1)
    else
        print("Criando diretórios...") sleep(1)
        for i, v in pairs(insta.directories) do 
            print(("Criando: %s"):format(v))
            fs.makeDir(v) sleep(0.2)
        end

        print("Fazendo download de arquivos...") sleep(1)
        for i, v in pairs(insta.files) do 
            print(("Baixando: %s"):format(v))
            downloadArquivo(v) sleep(1)
        end

        print("Instalação completa")
	print() sleep(0.5)
        local sha256 = require("/lib/sha256")

        print("Defina um nome de usuário e senha")
        write("nome de usuário: ")
        local username = read()
        write("senha: ")
        local password = sha256(read("*"))
        local data = {
            {
                name = username,
                passwordHash = password,
                homeDir = "/home/"..username
            }
        }

        local file = fs.open("/etc/accounts.cfg", "w")
        file.write(textutils.serialize(data))
        file.close()
	fs.makeDir("home/"..username.."/Documentos")
	fs.makeDir("home/"..username.."/Música")
	fs.makeDir("home/"..username.."/Imagens")
	fs.makeDir("home/"..username.."/Vídeos")
	fs.makeDir("home/"..username.."/Downloads")

        print("Definido informações") sleep(0.2)
        write("Reinicie agora? Y/n ")
        local rsn = read()
        if string.lower(rsn) ~= "n" then
            os.reboot()
	else
	    term.setBackgroundColor(colors.black)
	    clr(1,1)
        end
    end
end

local inst = getInformOS(tag)
install(inst)
