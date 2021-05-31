term.clear()
term.setCursorPos(1, 1)
print("Inicializando Sistema...")
print()
sleep(0.5)

local function loadt(path)
    local file = fs.open(path, "r")
    local content = textutils.unserialize(file.readAll())
    file.close()
    return content
end


if not term.isColor() then
    printError("Por favor, use o Advanced Computer")
    return false
end

local ArquivosA = {}

print("Verificando Arquivos do Sistema...")
print("===================================================")
print("")
sleep(0.5)
if fs.exists("/boot/arquivos.cfg") then
    local files = loadt("/boot/arquivos.cfg")
    for i, v in pairs(files) do
        if fs.exists(v) then
            term.blit("[ OK ]", "005500", "ffffff")
            term.write(" " .. v)
        else
            if (fs.exists("/etc/accounts-default.cfg") and v == "/etc/accounts.cfg") then
                fs.move("/etc/accounts-default.cfg", "/etc/accounts.cfg")
                term.blit("[ OK ]", "005500", "ffffff")
                term.write(" " .. v)
            else
                term.blit("[FAIL]", "0eeee0", "ffffff")
                term.write(" " .. v)
                table.insert(ArquivosA, v)
            end
        end
        print()
        sleep(0.01)
    end
else
    term.blit("[FAIL]", "0eeee0", "ffffff")
    term.write(" /boot/arquivos.cfg")
    print()
    printError("Arquivo /boot/arquivos.cfg não Encontrado!\nAlguns arquivos não forão encontrados! Reporte para os mantenedores em: https://github.com/MineWorldProgram/NewOS/issues")
    return false
end

if #ArquivosA > 0 then
    printError(string.format("Arquivos Ausentes: %s\nAlguns arquivos não forão encontrados! Reporte para os mantenedores em: https://github.com/MineWorldProgram/NewOS/issues", table.concat(ArquivosA, ", ")))
    return false
end

sleep(0.3)

local systempath = loadt("/boot/system.path")
shell.run(
    systempath[1]
)
