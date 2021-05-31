local textbox = require("/lib/textbox")
local util = require('/lib/util')
local sha256 = require("/lib/sha256")
local file = util.loadModule("file")
local w, h = term.getSize()

print("Defina um nome de usuário e senha")
write("Nome de Usuáro: ")
local username = read()
write("Senha: ")
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
fs.makeDir("home/"..username.."/Musica")
fs.makeDir("home/"..username.."/Imagens")
fs.makeDir("home/"..username.."/Videos")
fs.makeDir("home/"..username.."/Downloads")
 
print("Usuário Criado!") sleep(0.2)
write("Reinicializando para aplicar alterações... ")
sleep(3)
os.reboot()