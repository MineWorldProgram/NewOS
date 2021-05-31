-- [                 Installer (Version: 3.0)                 ] --
-- [      Created by: Space_Interprise && LoboMetalurgico     ] --
-- [ About: Downloads the main version of a GitHub Repository ] --

-- [ Global variables (Do not touch!) ] --
cursorPosXBackup, cursorPosYBackup = term.getCursorPos()
backgroundColorBackup = term.getBackgroundColor()
ScreenSizeX, ScreenSizeY = term.getSize()
textColorBackup = term.getTextColor()
runningInstaller = true
os.loadAPI("json.lua")
canBeClosed = true
animate = false
line1 = ''
line2 = ''
line3 = ''

-- [ Installer configs ] --
showLicensePage = false
filesToIgnore = {'README.md', '.gitignore', 'LICENSE', '.gitattributes', 'installer.lua'}
installerTitle = 'NewOS-installer'
installerCloseButton = string.char(7)
installerColors = {
    titleBar = colors.lime,
    titleBarText = colors.white,
    mainTextColor = colors.white,
    background = colors.gray,
    closeButton = colors.red,
    greenText = colors.green,
    yellowText = colors.yellow,
    redText = colors.red,
    lightGreenText = colors.lime,
    grayText = colors.lightGray
}
installerSize = {
    x = (ScreenSizeX / 8) + 1,
    y = (ScreenSizeY / 8) + 1,
    width = ((ScreenSizeX / 4) + (ScreenSizeX / 2) + 1),
    height = ((ScreenSizeY / 4) + (ScreenSizeY / 2) + 1)
}

-- [ Repository information ] --
githubUsername = 'MineWorldProgram'
githubRepository = 'NewOS'

-- [ Global variables 2 (Do not touch!) ] --
githubApiUrl = 'https://api.github.com/repos/'..githubUsername..'/'..githubRepository

local installerWindow = window.create(term.current(), installerSize.x, installerSize.y, installerSize.width, installerSize.height, true)

function drawnPixel(window, x, y, color)
    window.setBackgroundColor(color)
    window.setCursorPos(x, y)
    window.write(' ')
end

function drawnBox(window, x, y, w, h, color)
    for px = x, (x + w) do 
        drawnPixel(window, px, y, color)
        drawnPixel(window, px, (y + h), color)
    end
    for py = y, (y + h) do 
        drawnPixel(window, x, py, color)
        drawnPixel(window, (x + w), py, color)
    end
end

function drawnFilledBox(window, x, y, w, h, color)
    for px = x, (x + w) do 
        for py = y, (y + h) do 
            drawnPixel(window, px, py, color)
        end
    end
end

function generateButton(window, x,y,width,h,color1,color2, text)
    if (not runningInstaller) then return end
    x = math.floor(x)
    y = math.floor(y)
    width = math.floor(width)
    h = math.floor(h)
    drawnFilledBox(window, x, y, width - 1, h - 1, color1)
    window.setCursorPos((x) + (math.floor((width) / 2) - math.floor( string.len(text) / 2 )), y + (h / 2))
    window.setBackgroundColor(color1)
    window.setTextColor(color2)
    window.write(text)
    local clicked = false
    while not clicked do
        if (not runningInstaller) then
            clicked = false
            break
        end
        local event, button, mx, my = os.pullEvent('mouse_click')
        if (mx > (x + math.floor(installerSize.x) - 2) and mx < (math.floor(installerSize.x) + x + width) - 1) then
            if (my > (y + math.floor(installerSize.y) - 2) and my < (math.floor(installerSize.y) + y + h) - 1) then
                clicked = true
            end
        end
        sleep(0)
    end
end

function drawnTitleBar(window, data) 
    drawnBox(window, data.x, data.y, data.w, data.y, installerColors.titleBar)
    window.setCursorPos(data.x, data.y)
    window.setTextColor(installerColors.titleBarText)
    window.write(installerTitle)
    window.setCursorPos((data.x + data.w - 1), data.y)
    window.setTextColor(installerColors.closeButton)
    window.write(installerCloseButton)
end

function drawnMenu(window) 
    window.clear()
    WindowSizeX, WindowSizeY = window.getSize()
    drawnTitleBar(window, {x=1, y=1, w=WindowSizeX, h=0})
    drawnFilledBox(window, 1, 2, WindowSizeX, WindowSizeY, installerColors.background)
end

function closeInstaller()
    if (canBeClosed) then
        installerWindow.setBackgroundColor(backgroundColorBackup)
        installerWindow.setTextColor(textColorBackup)
        installerWindow.clear()
        installerWindow.setVisible(false)
        term.setCursorPos(cursorPosXBackup, cursorPosYBackup)
        runningInstaller = false
    end
end

function inputHandler()
    while runningInstaller do
        local event, button, x, y = os.pullEventRaw()
        if (event == 'mouse_click') then
            -- Mouse Click Events
            if (button == 1) then
                -- Left click of mouse Events
                if (x == math.floor(installerSize.width + installerSize.x - 1) and y == math.floor(installerSize.y)) then
                    -- Close event
                    closeInstaller()
                end
            end
        end
        sleep(0)
    end
end

function centerText(text, w, linePosY)
    linePosY = linePosY + 1 
    installerWindow.setCursorPos(((w / 2) - (string.len(text) / 2)) + 1,linePosY)
    installerWindow.write(text)
    return linePosY
end

function loadingAnimation(w,y) 
    local function drawner()
        installerWindow.setCursorPos((w / 2) - 2, y)
        installerWindow.write(line1)
        installerWindow.setCursorPos((w / 2) - 2, y + 1)
        installerWindow.write(line2)
        installerWindow.setCursorPos((w / 2) - 2, y + 2)
        installerWindow.write(line3)
    end
    while (animate and runningInstaller) do
        line1 = '\\. '
        line2 = '~\\.'
        line3 = '~~\\'
        if (not animate) then return end
        drawner()
        sleep(0.1)
        line1 = '-.'
        line2 = '~\\'
        line3 = '~~\\'
        if (not animate) then return end
        drawner()
        sleep(0.1)
        line1 = '.-.'
        line2 = '/~\\'
        line3 = '~~~'
        if (not animate) then return end
        drawner()
        sleep(0.1)
        line1 = ' ./'
        line2 = './~'
        line3 = '/~~'
        if (not animate) then return end
        drawner()
        sleep(0.1)
        line1 = ' ./'
        line2 = '\\- '
        line3 = '~~~'
        if (not animate) then return end
        drawner()
        sleep(0.1)
        line1 = '\\. '
        line2 = '~--'
        line3 = '~~~'
        if (not animate) then return end
        drawner()
        sleep(0.1)
    end
end

function pageError(errorCode, description)
    drawnMenu(installerWindow)
    
    canBeClosed = true

    local linePosY = 2
    
    linePosY = centerText('Oh No!', installerSize.width, linePosY)
    linePosY = centerText('', installerSize.width, linePosY)
    linePosY = centerText('Ocorreu um erro durante a instalação', installerSize.width, linePosY)
    linePosY = centerText(' do NewOs.', installerSize.width, linePosY)
    linePosY = centerText('', installerSize.width, linePosY)
    linePosY = centerText('Código de Erro: ' .. errorCode, installerSize.width, linePosY)

    if not (description == nil) then
        linePosY = centerText('Descrição do Erro: '..description, installerSize.width, linePosY)
    end

    generateButton(installerWindow, installerSize.width - 4, installerSize.height - 1, 4, 1, installerColors.closeButton, installerColors.mainTextColor, 'Sair')
    closeInstaller()
end

-- InstallProcess
function page4()
    runningInstaller = true
    canBeClosed = false
    installerColors.closeButton = colors.lightGray
    drawnMenu(installerWindow)
    
end

-- LicensePage
function page3()
    drawnMenu(installerWindow)
    print('Comming Soon™️!')
end

-- Install Info
function page2(canInstall, freeSize, osSize, finalSize, license)
    drawnMenu(installerWindow)

    local linePosY = 2
    if (canInstall) then
        installerWindow.setTextColor(installerColors.lightGreenText)
        linePosY = centerText('Incrivel!', installerSize.width, linePosY)

        linePosY = linePosY + 2
        
        installerWindow.setCursorPos(2, linePosY)
        installerWindow.setTextColor(installerColors.mainTextColor)
        installerWindow.write('Espaço disponivel: ')
        if (math.floor(freeSize) > 1024) then
            installerWindow.setTextColor(installerColors.greenText)
        elseif (math.floor(freeSize) > 512) then
            installerWindow.setTextColor(installerColors.yellowText)
        else
            installerWindow.setTextColor(installerColors.redText)
        end
        installerWindow.write(math.floor(freeSize))
        installerWindow.setTextColor(installerColors.mainTextColor)
        installerWindow.write(' KB(s)')
        
        linePosY = linePosY + 1
        installerWindow.setCursorPos(2, linePosY)
        installerWindow.setTextColor(installerColors.mainTextColor)
        installerWindow.write('Tamanho do sistema: ')
        installerWindow.setTextColor(installerColors.lightGreenText)
        installerWindow.write(osSize)
        installerWindow.setTextColor(installerColors.mainTextColor)
        installerWindow.write(' KB(s)')

        linePosY = linePosY + 1
        installerWindow.setCursorPos(2, linePosY)
        installerWindow.setTextColor(installerColors.mainTextColor)
        installerWindow.write('Espaço restante: ')
        if (math.floor(finalSize) > 1024) then
            installerWindow.setTextColor(installerColors.greenText)
        elseif (math.floor(finalSize) > 512) then
            installerWindow.setTextColor(installerColors.yellowText)
        else
            installerWindow.setTextColor(installerColors.redText)
        end
        installerWindow.write(math.floor(finalSize))
        installerWindow.setTextColor(installerColors.mainTextColor)
        installerWindow.write(' KB(s)')

        if (showLicensePage == false) then
            linePosY = linePosY + 2
            installerWindow.setCursorPos(2, linePosY)
            installerWindow.write('Licença: '..license)
        end

    else 
        installerWindow.setTextColor(installerColors.closeButton)
        linePosY = centerText('Oh No!', installerSize.width, linePosY)
        linePosY = centerText('Espaço insuficiente!', installerSize.width, linePosY)
        linePosY = centerText('Libere '.. osSize ..' kb de espaço!', installerSize.width, linePosY)

        generateButton(installerWindow, installerSize.width - 4, installerSize.height - 1, 4, 1, installerColors.closeButton, installerColors.mainTextColor, 'Sair')
        closeInstaller()
    end
    
    
    if (canInstall) then
        local function nextButton()
            generateButton(installerWindow, installerSize.width - 8, installerSize.height - 1, 8, 1, installerColors.greenText, installerColors.mainTextColor, 'Instalar')
        end
        local function cancelButton()
            generateButton(installerWindow, 2, installerSize.height - 1, 8, 1, installerColors.grayText, installerColors.mainTextColor, 'Cancelar')
            closeInstaller()
        end
        parallel.waitForAny(nextButton, cancelButton)
    end

    if (runningInstaller) then
        if (showLicensePage == true) then
            page3(license)
        else
            page4()
        end
    end
end

function page1()
    drawnMenu(installerWindow)
    
    installerWindow.setBackgroundColor(installerColors.background)
    installerWindow.setTextColor(installerColors.mainTextColor)

    local linePosY = 2
    linePosY = centerText('Olá!', installerSize.width, linePosY)
    linePosY = centerText('', installerSize.width, linePosY)
    linePosY = centerText('Seja muito bem vindo(a) ao', installerSize.width, linePosY)
    linePosY = centerText('instalador do NewOS.', installerSize.width, linePosY)
    linePosY = centerText('', installerSize.width, linePosY)
    linePosY = centerText('Por Favor, aguarde enquanto', installerSize.width, linePosY)
    linePosY = centerText('verificamos se existe espaço', installerSize.width, linePosY)
    linePosY = centerText('suficiente em disco para a instalação', installerSize.width, linePosY)

    local canInstall = false
    local license = nil
    local finalSize = 0
    local freeSize = 0
    local osSize = 0
    local githubjson = nil
    
    local function animator()
        animate = true
        loadingAnimation(installerSize.width, linePosY + 2)
        if (githubjson) then
            generateButton(installerWindow, (installerSize.width / 2) - 5, linePosY + 2, 11, 3, installerColors.greenText, installerColors.mainTextColor, 'Continuar')
        end
    end
    
    local function getData()
        githubjson, httpErrorMessage, pageErrorContent = http.get(githubApiUrl)
        if (githubjson == nil) then
            animate = false
            if (not pageErrorContent == nil) then
                local errorJson = pageErrorContent.readAll()
                local parsedError = json.decode(errorJson)
                local keyWord = string.sub(parsedError.message, 4, 10)
                if (keyWord == 'rate limit') then
                    pageError('0x10c', 'GitHubRateLimit')
                else
                    pageError('0x01a', 'GitHubUnknow')
                end
            end
            pageError('0x01a', 'GitHubUnknow')
            return
        end
        
        parsedResult = json.decode(githubjson.readAll())

        freeSize = fs.getFreeSpace("/") / 1024

        osSize = parsedResult.size

        finalSize = freeSize - osSize

        license = parsedResult.license.name

        if (finalSize > 0) then
            canInstall = true
        end

        animate = false
    end
    parallel.waitForAll(animator, getData)
    if (runningInstaller) then
        page2(canInstall, freeSize, osSize, finalSize, license)
    end
end

parallel.waitForAll(inputHandler, page4)