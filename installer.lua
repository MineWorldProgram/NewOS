-- [                 Installer (Version: 3.0)                 ] --
-- [               Created by: Space_Interprise               ] --
-- [ About: Downloads the main version of a GitHub Repository ] --

-- [ Global variables] --
ScreenSizeX, ScreenSizeY = term.getSize()

-- [ Installer configs ] --
showLicensePage = true
filesToIgnore = {'README.md', '.gitignore', 'LICENSE', 'version'}
installerTitle = 'NewOS installer'
installerColors = {
    titleBarColor = colors.lime,
    backgroundColor = colors.gray
}
installerSize = {
    x = (ScreenSizeX / 4) + 1,
    y = (ScreenSizeY / 4) + 1,
    width = ((ScreenSizeX / 4) + (ScreenSizeX / 2) + 1),
    height = ((ScreenSizeY / 4) + (ScreenSizeY / 2) + 1)
}

-- [ Repository information ] --
githubUsername = 'MineWorldProgram'
githubRepository = 'NewOS'

function drawnTitleBar(data) 
    paintutils.drawBox(data.x, data.y, data.w, data.y, installerColors.titleBarColor)
    
end

function drawnMenu() 
    drawnTitleBar({x=installerSize.x, y=installerSize.y-1, w=installerSize.width})
    paintutils.drawFilledBox(installerSize.x, installerSize.y, installerSize.width, installerSize.height, installerColors.backgroundColor)
end

drawnMenu()