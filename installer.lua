-- [                 Installer (Version: 3.0)                 ] --
-- [      Created by: Space_Interprise && LoboMetalurgico     ] --
-- [ About: Downloads the main version of a GitHub Repository ] --

-- [ Global variables (Do not touch!) ] --
ScreenSizeX, ScreenSizeY = term.getSize()
backgroundColorBackup = term.getBackgroundColor()
textColorBackup = term.getTextColor()
cursorPosXBackup, cursorPosYBackup = term.getCursorPos()
runningInstaller = true
canBeClosed = true
animate = false
line1 = ''
line2 = ''
line3 = ''
os.loadAPI("json.lua")

-- [ Installer configs ] --
showLicensePage = false
filesToIgnore = {'README.md', '.gitignore', 'LICENSE', '.gitattributes', 'installer.lua'}
installerTitle = 'NewOS-installer'
installerCloseButton = string.char(7)
installerColors = {
    titleBar = colors.lime,
    titleBarText = colors.white,
    background = colors.gray,
    closeButton = colors.red
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
    drawnFilledBox(window, x, y, width, h, color1)
    term.setCursorPos(x + ( string.len(text) / 2 ) + 2, y + (h / 2) + 2)
    term.setBackgroundColor(color1)
    term.setTextColor(color2)
    term.write(text)
    local clicked = false
    while not clicked do
        if (not runningInstaller) then
            clicked = false
            break
        end
        local event, button, mx, my = os.pullEvent('mouse_click')
        if (mx > ((installerSize.x + x) - 3) and mx < ((installerSize.x + x + width) - 1)) then
            if (my > ((installerSize.y + y) - 2) and my < ((installerSize.y + y + h) - 1)) then
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

function inputHandler()
    while runningInstaller do
        local event, button, x, y = os.pullEventRaw()
        if (event == 'mouse_click') then
            -- Mouse Click Events
            if (button == 1) then
                -- Left click of mouse Events
                if (x == math.floor(installerSize.width + installerSize.x - 1) and y == math.floor(installerSize.y)) then
                    -- Close event
                    if (canBeClosed) then
                        installerWindow.setBackgroundColor(backgroundColorBackup)
                        installerWindow.setTextColor(textColorBackup)
                        installerWindow.clear()
                        installerWindow.setVisible(false)
                        term.setCursorPos(cursorPosXBackup, cursorPosYBackup)
                        runningInstaller = false
                    end
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
    while animate do
        line1 = '\\. '
        line2 = '~\\.'
        line3 = '~~\\'
        drawner()
        sleep(0.1)
        line1 = '-.'
        line2 = '~\\'
        line3 = '~~\\'
        drawner()
        sleep(0.1)
        line1 = '.-.'
        line2 = '/~\\'
        line3 = '~~~'
        drawner()
        sleep(0.1)
        line1 = ' ./'
        line2 = './~'
        line3 = '/~~'
        drawner()
        sleep(0.1)
        line1 = ' ./'
        line2 = '\\- '
        line3 = '~~~'
        drawner()
        sleep(0.1)
        line1 = '\\. '
        line2 = '~--'
        line3 = '~~~'
        drawner()
        sleep(0.1)
    end
end

-- InstallProcess
function page4()
    drawnMenu(installerWindow);
end

-- LicensePage
function page3()
    drawnMenu(installerWindow);
    print('Comming Soon™️!')
end

-- Install Info
function page2(canInstall, freeSize, osSize, finalSize)
    drawnMenu(installerWindow);

    linePosY = 2
    if (canInstall) then
        installerWindow.setTextColor(colors.lime)
        linePosY = centerText('Incrivel!', installerSize.width, linePosY)
    else 
        term.setTextColor(colors.red)
        linePosY = centerText('Oh No!', installerSize.width, linePosY)
    end

    
    if (canInstall) then
        generateButton(installerWindow, installerSize.width -9, installerSize.height - 1, 8, 0, colors.lime, colors.white, 'Continuar')
    end

    if (runningInstaller) then
        if (showLicensePage == true) then
            page3()
        else
            page4()
        end
    end
end

function page1()
    drawnMenu(installerWindow);
    
    installerWindow.setBackgroundColor(colors.gray)
    installerWindow.setTextColor(colors.white)

    linePosY = 2
    linePosY = centerText('Olá!', installerSize.width, linePosY)
    linePosY = centerText('', installerSize.width, linePosY)
    linePosY = centerText('Seja muito bem vindo(a) ao', installerSize.width, linePosY)
    linePosY = centerText('instalador do NewOS.', installerSize.width, linePosY)
    linePosY = centerText('', installerSize.width, linePosY)
    linePosY = centerText('Por Favor, aguarde enquanto', installerSize.width, linePosY)
    linePosY = centerText('verificamos se existe espaço', installerSize.width, linePosY)
    linePosY = centerText('suficiente em disco para a instalação', installerSize.width, linePosY)

    local canInstall = false
    local finalSize = 0
    local freeSize = 0
    local osSize = 0
    
    local function animator()
        animate = true
        loadingAnimation(installerSize.width, linePosY + 2)
        generateButton(installerWindow, (installerSize.width / 2) - 5, linePosY + 2, 10, 2, colors.lime, colors.white, 'Continuar')
    end
    
    local function getData()
        githubjson = http.get(githubApiUrl)
        
        if (githubjson == nil) then
            return print('Failed')
        end
        
        parsedResult = json.decode(githubjson.readAll())

        freeSize = fs.getFreeSpace("/") * 1024

        osSize = parsedResult.size

        finalSize = freeSize - osSize

        if (finalSize > 1024) then
            canInstall = true
        end

        animate = false
    end
    parallel.waitForAll(animator, getData)
    if (runningInstaller) then
        page2(canInstall, freeSize, osSize, finalSize)
    end
end

parallel.waitForAll(inputHandler, page1)