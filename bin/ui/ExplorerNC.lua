Colors = {
    window = {
        titlebar = {
            backgroundSelected = 32
        }
    },
    desktop = {
        background = 8192
    },
    menu = {
        background = 128,
        text = 1,
    },
    main = {
        background = 32768,
        backgroundSecondary = 256,
        text = 1,
    }
}
MaximazedOld = false
SizeXOld, SizeYOld = term.getSize()
OldDir = "/"
SideBarStoppingDown = false
ScrollMainBox = 0
ScrollSideBar = 0
ScrollMainBoxAllowed = false
ScrollSideBarAllowed = false
FilesToWork = {} --SIDEBAR --SCROLL SYSTEM
MainFilesToWork = {} --MainBox --SCROLL SYSTEM
DefaultDir = "/" --the folder you will seen when you open the explorer
FirstFolder = "/" -- the folder you cannot get out
CurrentDir = DefaultDir --Defines the initial folder to the defaltDir
DiskName = "C:" --Name of diskPartition --OBS: just used on TopBar Define it to "" if you dont want a Disk Partition Name
UndeletableFolders = {"rom"}
--[THIS NEED TO BE REFRESHED]--
function RefreshPosition()
    ScrollMainBoxAllowed = false
    ScreenSizeX, ScreenSizeY = term.getSize()
    ScreenSizeX=ScreenSizeX - 6
    ScreenSizeY=ScreenSizeY - 4
    SizeX = ScreenSizeX
    SizeY = ScreenSizeY
    PositionX = 3
    PositionY = 1
    SideBarX = (PositionX+(SizeX/6))+3
    SideBarY = (PositionY+SizeY+3)
end
RefreshPosition()
Files = {}
AllFiles = {}
SelectedFiles = ""
SideBarSelectedFile = ""
PathHistory = {}
PathHistoryF = {}

function OPENFILE(DirWithFileName)
--Do something Here!!!!!!
end

function DELETEFILE(DirWithFileName)
    fs.delete(DirWithFileName)
end

--[Colors]--
Colors.SelectedItem = 8
--[END OF COLORS]--

--[Drawn Functions]--
function DrawnPixel(color, X, Y) --[SUBS]
    term.setCursorPos(X, Y)
    term.setBackgroundColor(color)
    term.write(" ")
end

function Write(X,Y,TColor, BColor, Text)--[SUBS]
    term.setCursorPos(X, Y)
    term.setBackgroundColor(BColor)
    term.setTextColor(TColor)
    term.write(Text)
end

function LineBreakWrite(X1,Y,X2,TColor, BColor,Text)--[SUBS]
    LinesText = {}
    if (X1+string.len(Text) > X2) then
        for L = 1,string.len(Text)/(X2-X1) do
            table.insert(LinesText, string.sub(Text, ((L-1)*string.len(Text)/(X2-X1))+1, (L*(string.len(Text)/(X2-X1)))))
        end
    else
        LinesText[1] = Text
    end
    for Key,Value in ipairs(LinesText) do
        Write(X1,Y+(Key-1), TColor, BColor, Value)
    end
end

function DrawnBox(X1,Y1,X2,Y2,color)--[SUBS]
    if (X2-X1 < 0 or Y2-Y1 < 0) then return end
    for YC = 1, Y2-Y1 do
        for XC = 1, X2-X1 do
            if ((Y1+YC) == Y1+1 or (Y1+YC) == Y2) then
                DrawnPixel(color, (X1+XC)-1, (Y1+YC)-1)
            else
                DrawnPixel(color, X1, (Y1+YC)-1)
                DrawnPixel(color, X2-1, (Y1+YC)-1)
            end
        end
    end
end

function DrawnFilledBox(X1,Y1,X2,Y2,color)--[SUBS]
    if (X2-X1 < 1 or Y2-Y1 < 1) then return end
    for YC = 1, Y2-Y1 do
        for XC = 1, X2-X1 do
            DrawnPixel(color, (X1+XC)-1, (Y1+YC)-1)
        end
    end
end

--[Drawn Screens]--
function DrawnBaseSquare()
    --[Drawn Background of explorer]
    DrawnFilledBox(PositionX-1,PositionY+1,(PositionX+SizeX)+3, (PositionY+SizeY+3), Colors.menu.background) --Base
    DrawnFilledBox(PositionX-1,PositionY+1,SideBarX, SideBarY, Colors.main.backgroundSecondary) --SideBar
    DrawnFilledBox(PositionX-1,PositionY+1,(PositionX+SizeX)+3, PositionY+4, Colors.main.backgroundSecondary) --TopBar
    DrawnFilledBox(PositionX+4,PositionY+1,(PositionX+SizeX)+2, PositionY+4, Colors.main.backgroundSecondary)
    DrawnBox(PositionX+4,PositionY+1,(PositionX+SizeX)+2, PositionY+4, Colors.main.background)
    DrawnFilledBox(PositionX-1,PositionY+1,PositionX+4, PositionY+4, Colors.menu.background)
end

function DrawnTopBar()
    DrawnFilledBox(PositionX+4,PositionY+1,(PositionX+SizeX)+2, PositionY+4, Colors.main.backgroundSecondary)
    DrawnBox(PositionX+4,PositionY+1,(PositionX+SizeX)+2, PositionY+4, Colors.main.background)
    DrawnFilledBox(PositionX-1,PositionY+1,PositionX+4, PositionY+4, Colors.menu.background)
    if (string.len(DiskName..CurrentDir) > ((SizeX)-4)) then
        Write(PositionX+5,PositionY+2, Colors.main.text,Colors.main.backgroundSecondary, string.sub(DiskName..CurrentDir, 1, ((SizeX)-7)).."...") --CurrentDiretory in topBar
    else
        Write(PositionX+5,PositionY+2, Colors.main.text,Colors.main.backgroundSecondary, DiskName..CurrentDir) --CurrentDiretory in topBar
    end
    Write(PositionX+2, PositionY+2, Colors.main.backgroundSecondary, Colors.menu.background, string.char(24))
    Write(PositionX, PositionY+2, Colors.main.backgroundSecondary, Colors.menu.background, string.char(27))
    Write(PositionX+1, PositionY+2, Colors.main.backgroundSecondary, Colors.menu.background, string.char(26))
    if (table.getn(PathHistory) ~= 0) then
        Write(PositionX, PositionY+2, Colors.main.text, Colors.menu.background, string.char(27))
    end
    if (table.getn(PathHistoryF) ~= 0) then
        Write(PositionX+1, PositionY+2, Colors.main.text, Colors.menu.background, string.char(26))
    end
    if (CurrentDir ~= FirstFolder) then
        Write(PositionX+2, PositionY+2, Colors.main.text, Colors.menu.background, string.char(24))
    end
end

function DrawnTexts()
    DrawnFilledBox(PositionX-1,PositionY+4,SideBarX, SideBarY, Colors.main.backgroundSecondary)--SideBar
    --[SideBar Dirs]--

    ScrollSideBarAllowed = PositionY+2+table.getn(fs.list(CurrentDir)) >PositionY+SizeY
    if (ScrollSideBar > 0 and ScrollSideBarAllowed == true) then
        if (ScrollSideBar >= table.getn(fs.list(CurrentDir))-((SizeY-3))) then
            SideBarStoppingDown = true
            return
        end
        FilesToWork = {}
        for G = ScrollSideBar, table.getn(fs.list(CurrentDir)) do
            table.insert(FilesToWork, fs.list(CurrentDir)[G])
        end
        for K,V in ipairs(FilesToWork) do
            if (2+K <= SizeY) then
                if (fs.isDir(CurrentDir..V) == true) then
                    if (string.len(string.char(16).." "..V) > (SideBarX)-(PositionX-1)) then
                        Write(PositionX-1, PositionY+4+K, Colors.main.background, Colors.main.backgroundSecondary, string.sub(" "..string.char(16)..V, 1, (SideBarX)-(PositionX-1)))
                    else
                        Write(PositionX-1, PositionY+4+K, Colors.main.background, Colors.main.backgroundSecondary, " "..string.char(16)..V)
                    end
                else
                    if (string.len("  "..V) > (SideBarX)-(PositionX-1)) then
                        Write(PositionX-1, PositionY+4+K, Colors.main.background, Colors.main.backgroundSecondary, string.sub("  "..V, 1, (SideBarX)-(PositionX-1)))
                    else
                        Write(PositionX-1, PositionY+4+K, Colors.main.background, Colors.main.backgroundSecondary, "  "..V)
                    end
                end
            end
        end
    else
        for K,V in ipairs(fs.list(CurrentDir)) do
            if (PositionY+2+K <= PositionY+SizeY) then
                if (fs.isDir(CurrentDir..V) == true) then
                    if (string.len(string.char(16).." "..V) > (SideBarX)-(PositionX-1)) then
                        Write(PositionX-1, PositionY+4+K, Colors.main.background, Colors.main.backgroundSecondary, string.sub(" "..string.char(16)..V, 1, (SideBarX)-(PositionX-1)))
                    else
                        Write(PositionX-1, PositionY+4+K, Colors.main.background, Colors.main.backgroundSecondary, " "..string.char(16)..V)
                    end
                else
                    if (string.len("  "..V) > (SideBarX)-(PositionX-1)) then
                        Write(PositionX-1, PositionY+4+K, Colors.main.background, Colors.main.backgroundSecondary, string.sub("  "..V, 1, (SideBarX)-(PositionX-1)))
                    else
                        Write(PositionX-1, PositionY+4+K, Colors.main.background, Colors.main.backgroundSecondary, "  "..V)
                    end
                end
            end
        end
    end
end

function DrawnFolder(X,Y,C)
    DrawnFilledBox(math.floor(X+3.5),Y,X+4,Y+3, Colors.desktop.background)
    DrawnFilledBox(math.floor(X+3.5),Y,X+4,Y+2, Colors.window.titlebar.backgroundSelected)
    DrawnFilledBox(math.floor(X+3),Y,X+4,Y+3, Colors.desktop.background)
    DrawnFilledBox(math.floor(X+3),Y,X+4,Y+2, Colors.window.titlebar.backgroundSelected)
    DrawnFilledBox(X,Y,math.floor(X+3.9),Y+3, C)
    DrawnFilledBox(X,Y,X+3,Y+3, C)
end

function GetTypeOfFile(FileName)
    for number = 1,string.len(FileName) do
        if(string.sub(FileName,string.len(FileName)-number,string.len(FileName)-number)==".") then
            return string.sub(FileName,string.len(FileName)-(number-1),string.len(FileName))
        end
    end
end

function DrawnFile(X,Y, Type, C)
    Type = Type or "err"
    Type = string.sub(Type, 1, 3)
    DrawnFilledBox(X,Y,X+4, Y+3, C)
    Write(X, Y+2, C, Colors.main.background, "."..Type)
end

function DrawnFiles()
    DrawnFilledBox(SideBarX,PositionY+4,(PositionX+SizeX)+3, (PositionY+SizeY+3), Colors.menu.background)
    LV = 1
    LH = 0
    if (table.getn(fs.list(CurrentDir)) == 0) then
        Texto = "Esta pasta está vazia"
        Pos = 0
        PIS = 1
        for D = 1, string.len(Texto) do
            if (PIS > ScreenSizeX-SideBarX) then
                Pos = Pos + 1
                PIS = 1
            end
            Write(SideBarX+PIS, 5+Pos, Colors.main.backgroundSecondary, Colors.menu.background, string.sub(Texto, D, D))
            PIS = PIS + 1
        end
        return
    end
    for P,L in ipairs(fs.list(CurrentDir)) do
        LH = LH + 1
        if (SideBarX+1+(LH-1)*5 > (PositionX+SizeX)+3) then
            LV = LV + 1
            LH = 1
        end
    end
    if (SideBarX+LV*7 > SizeY) then
        ScrollMainBoxAllowed = true
    end
    function DrawningFO(Text, C)
        DrawnFolder((SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+5+((CurrentLineVertical-1)*7), C) 
        DrawnFilledBox((SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+9+((CurrentLineVertical-1)*7), (SideBarX+1)+4+(CurrentLineHorizontal-1)*5, PositionY+11+((CurrentLineVertical-1)*7), Colors.main.background)
        Write((SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+9+((CurrentLineVertical-1)*7), C, Colors.main.background, string.sub(Text, 1, 4))
        Write((SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+10+((CurrentLineVertical-1)*7), C, Colors.main.background, string.sub(Text, 5, 8))
        table.insert(Files, {(SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+5+((CurrentLineVertical-1)*7), "FO", "", ""})
        table.insert(MainFilesToWork, {(SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+5+((CurrentLineVertical-1)*7), "FO", "", "", "", "", Text})
    end
    function DrawningFI(Text, C)
        DrawnFile((SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+5+((CurrentLineVertical-1)*7), GetTypeOfFile(Text), C)
        DrawnFilledBox((SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+9+((CurrentLineVertical-1)*7), (SideBarX+1)+4+(CurrentLineHorizontal-1)*5, PositionY+11+((CurrentLineVertical-1)*7), Colors.main.background)
        print(Text)
        Write((SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+9+((CurrentLineVertical-1)*7), C, Colors.main.background, string.sub(string.sub(Text, 1, string.len(Text)-string.len(GetTypeOfFile(Text))-1), 1, 4))
        Write((SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+10+((CurrentLineVertical-1)*7), C, Colors.main.background, string.sub(string.sub(Text, 1, string.len(Text)-string.len(GetTypeOfFile(Text))-1), 5, 8))
        table.insert(Files, {(SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+5+((CurrentLineVertical-1)*7), "F", GetTypeOfFile(Text), string.sub(Text, 1, string.len(Text)-string.len(GetTypeOfFile(Text))-1)})
        table.insert(MainFilesToWork, {(SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+5+((CurrentLineVertical-1)*7), "F", GetTypeOfFile(Text), string.sub(Text, 1, string.len(Text)-string.len(GetTypeOfFile(Text))-1), Text})
    end
    if (ScrollMainBox > 0 and ScrollMainBoxAllowed == true) then
        MainFilesToWork = {}
        local MFTW = {}
        AllFiles = {}
        Files = {}
        if (ScrollMainBox+1 > table.getn(fs.list(CurrentDir))-math.floor(((SizeX-SideBarX)/5))) then ScrollMainBox = ScrollMainBox-1 end
        for M,N in ipairs(fs.list(CurrentDir)) do
            if (M >= ScrollMainBox) then
                table.insert(MFTW, N)
            end
        end
        CurrentLineVertical = 1
        CurrentLineHorizontal = 1
        for Item,V in ipairs(MFTW) do
            if (SideBarX+1+(CurrentLineHorizontal-1)*6 > (PositionX+SizeX)+3) then
                CurrentLineVertical = CurrentLineVertical + 1
                CurrentLineHorizontal = 1
            end
            if (MFTW[Item] ~= "" or MFTW[Item] ~= nil) then  
                if (fs.isDir(CurrentDir..MFTW[Item]) == true) then
                    if (SelectedFiles == MFTW[Item]) then
                        if (PositionY+3+((CurrentLineVertical)*7) < (PositionY+SizeY+3)) then
                            DrawningFO(MFTW[Item], Colors.SelectedItem)
                        end
                    else
                        if (PositionY+3+((CurrentLineVertical)*7) < (PositionY+SizeY+3)) then
                            DrawningFO(MFTW[Item], Colors.main.text)
                        end
                    end
                    table.insert(AllFiles, (SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+5+((CurrentLineVertical-1)*7), MFTW[Item], "FOLDER")
                else
                    if (SelectedFiles == CurrentDir..MFTW[Item]) then
                        if (PositionY+3+((CurrentLineVertical)*7) < (PositionY+SizeY+3)) then
                            DrawningFI(MFTW[Item], Colors.SelectedItem)
                        end
                    else
                        if (PositionY+3+((CurrentLineVertical)*7) < (PositionY+SizeY+3)) then
                            DrawningFI(MFTW[Item], Colors.main.text)
                        end
                    end
                    table.insert(AllFiles, (SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+5+((CurrentLineVertical-1)*7), MFTW[Item], "FILE")
                end
                CurrentLineHorizontal = CurrentLineHorizontal + 1
            end
        end
    else
        CurrentLineVertical = 1
        CurrentLineHorizontal = 1
        for Item,V in ipairs(fs.list(CurrentDir)) do
            if (SideBarX+1+(CurrentLineHorizontal-1)*6 > (PositionX+SizeX)+3) then
                CurrentLineVertical = CurrentLineVertical + 1
                CurrentLineHorizontal = 1
            end
            if (fs.list(CurrentDir)[Item] ~= "" or fs.list(CurrentDir)[Item] ~= nil) then 
                if (SelectedFiles == fs.list(CurrentDir)[Item]) then
                    if (fs.isDir(CurrentDir..fs.list(CurrentDir)[Item]) == true) then
                        if (PositionY+3+((CurrentLineVertical)*7) < (PositionY+SizeY+3)) then
                            DrawningFO(fs.list(CurrentDir)[Item], Colors.SelectedItem)
                        end
                        table.insert(AllFiles, {(SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+5+((CurrentLineVertical-1)*7), fs.list(CurrentDir)[Item], "FOLDER"})
                    else
                        if (PositionY+3+((CurrentLineVertical)*7) < (PositionY+SizeY+3)) then
                            DrawningFI(fs.list(CurrentDir)[Item], Colors.SelectedItem)
                        end
                        table.insert(AllFiles, {(SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+5+((CurrentLineVertical-1)*7), fs.list(CurrentDir)[Item], "FILE"})
                    end
                else
                    if (fs.isDir(CurrentDir..fs.list(CurrentDir)[Item]) == true) then
                        if (PositionY+3+((CurrentLineVertical)*7) < (PositionY+SizeY+3)) then
                            DrawningFO(fs.list(CurrentDir)[Item], Colors.main.text)
                        end
                        table.insert(AllFiles, {(SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+5+((CurrentLineVertical-1)*7), fs.list(CurrentDir)[Item], "FOLDER"})
                    else
                        if (PositionY+3+((CurrentLineVertical)*7) < (PositionY+SizeY+3)) then
                            DrawningFI(fs.list(CurrentDir)[Item], Colors.main.text)
                        end
                        table.insert(AllFiles, {(SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+5+((CurrentLineVertical-1)*7), fs.list(CurrentDir)[Item], "FILE"})
                    end
                end
                CurrentLineHorizontal = CurrentLineHorizontal + 1
            end
        end
    end
end

--Unicode codes (dont work in computercraft on minecraft 1.7.10 and i thing Under versions too)
--24 /|\
--26 ->
--27 <-
--30 /\
--31 \/

function Drawn()
    FilesToWork = {} --SIDEBAR --SCROLL SYSTEM
    MainFilesToWork = {} --MainBox --SCROLL SYSTEM
    Files = {}
    AllFiles = {}
    RefreshPosition()
    DrawnBaseSquare()
    DrawnTexts()
    DrawnTopBar()
    DrawnFiles()
    term.setBackgroundColor(colors.black)
    sleep(0.1)
end

function ACTION()
    local function A()
        while true do
            Event, Button, X, Y = os.pullEventRaw()
            if (Event == "key_up" and Button == 28 and SelectedFiles ~= "") then
                CurrentDir = CurrentDir..SelectedFiles.."/"
                SelectedFiles = ""
                SideBarSelectedFile = ""
                Drawn()
            end
            if (Event == "key_up" and Button == 211) then
                --Delete
                ER = false
                for G,V in ipairs(UndeletableFolders) do
                    if ((DefaultDir..V == CurrentDir..SelectedFiles) or (CurrentDir == FirstFolder and SelectedFiles == homedir[1].name)) then
                        ER = true
                    end
                end
                if (ER == false) then
                    fs.delete(CurrentDir..SelectedFiles)
                    DrawnTexts()
                    DrawnFiles()
                    DrawnFilledBox(SideBarX, ScreenSizeY+3, ScreenSizeX+7, ScreenSizeY+4, Colors.main.background)
                    Write(SideBarX, ScreenSizeY+3, Colors.main.text, Colors.main.background, "Deletado")
                else
                    DrawnFilledBox(SideBarX, ScreenSizeY+3, ScreenSizeX+7, ScreenSizeY+4, Colors.main.background)
                    Write(SideBarX, ScreenSizeY+3, Colors.main.text, Colors.main.background, "Acesso negado")
                end
                sleep(1)
                DrawnFiles()
            end
            if ((Event == "key" or Event == "key_up") and Button == 29) then
                ControlPressed = Event == "key"
            end
            if (ControlPressed == true and Event == "key" and Button == 46 and SelectedFiles ~= "") then
                --control c
                coppiedFile = CurrentDir..SelectedFiles
                DrawnFilledBox(SideBarX, ScreenSizeY+3, ScreenSizeX+7, ScreenSizeY+4, Colors.main.background)
                Write(SideBarX, ScreenSizeY+3, Colors.main.text, Colors.main.background, "Copiado")
                sleep(0.5)
                DrawnFiles()
            end
            if (Event == "paste" and coppiedFile ~= "" and coppiedFile ~= nil) then
                --control V
                ERR = false
                if (fs.isDir(coppiedFile) == true) then
                    function md(Dir)
                        FolderN = ""
                        if (string.sub(CurrentDir, string.len(CurrentDir)-string.len(Dir), string.len(CurrentDir)) == Dir.."/") then
                            DrawnFilledBox(SideBarX, ScreenSizeY+3, ScreenSizeX+7, ScreenSizeY+4, Colors.main.background)
                            Write(SideBarX, ScreenSizeY+3, Colors.main.text, Colors.main.background, "Recursão não permitida")
                            sleep(1)
                            ERR = true
                            return
                        end
                        for j = 1, string.len(Dir) do
                            if (string.sub(Dir, string.len(Dir)-j, string.len(Dir)-j) == "/") then
                                FolderN = string.sub(Dir, string.len(Dir)-(j-1), string.len(Dir))
                                break
                            end
                        end
                        if (string.sub(CurrentDir, string.len(CurrentDir), string.len(CurrentDir)) == "/") then
                            CurrentDir = string.sub(CurrentDir, 1, string.len(CurrentDir))
                        end
                        if (fs.exists(CurrentDir.."/"..FolderN) == true) then
                            DrawnFilledBox(SideBarX, ScreenSizeY+3, ScreenSizeX+7, ScreenSizeY+4, Colors.main.background)
                            Write(SideBarX, ScreenSizeY+3, Colors.main.text, Colors.main.background, "A pasta já existe!")
                            ERR = true
                            sleep(1)
                            return
                        end
                        ERR = false
                        fs.makeDir(CurrentDir.."/"..FolderN)
                        CurrentDir = CurrentDir.."/"..FolderN
                        for G,V in ipairs(fs.list(Dir)) do
                            if (fs.isDir(Dir.."/"..V) == true) then
                                b = CurrentDir
                                md(Dir.."/"..V)
                                CurrentDir = b
                            else
                                if (fs.exists(CurrentDir.."/"..V) == false) then
                                    fs.copy(Dir.."/"..V, CurrentDir.."/"..V)
                                else
                                    DrawnFilledBox(SideBarX, ScreenSizeY+3, ScreenSizeX+7, ScreenSizeY+4, Colors.main.background)
                                    Write(SideBarX, ScreenSizeY+3, Colors.main.text, Colors.main.background, V.." já existe!")
                                    sleep(1)
                                end
                            end
                        end
                    end
                    CurrentDirBackup = CurrentDir
                    md(coppiedFile)
                    CurrentDir = CurrentDirBackup
                else
                    FileN = ""
                    for j = 1, string.len(coppiedFile) do
                        if (string.sub(coppiedFile, string.len(coppiedFile)-j, string.len(coppiedFile)-j) == "/") then
                            FileN = string.sub(coppiedFile, string.len(coppiedFile)-(j-1), string.len(coppiedFile))
                            break
                        end
                    end
                    if (fs.exists(CurrentDir.."/"..FileN) == false) then
                        fs.copy(coppiedFile, CurrentDir.."/"..FileN)
                    else
                        DrawnFilledBox(SideBarX, ScreenSizeY+3, ScreenSizeX+7, ScreenSizeY+4, Colors.main.background)
                        Write(SideBarX, ScreenSizeY+3, Colors.main.text, Colors.main.background, "O arquivo já existe!")
                        ERR = true
                        sleep(1)
                    end
                end
                if (ERR == false) then
                    DrawnFiles()
                    DrawnTexts()
                    DrawnFilledBox(SideBarX, ScreenSizeY+3, ScreenSizeX+7, ScreenSizeY+4, Colors.main.background)
                    Write(SideBarX, ScreenSizeY+3, Colors.main.text, Colors.main.background, "Colado!")
                    sleep(1)
                end
                DrawnFilledBox(SideBarX, ScreenSizeY+3, ScreenSizeX+7, ScreenSizeY+4, Colors.menu.background)
                DrawnTexts()
                DrawnFiles()
            end
            if (Event == "mouse_scroll" and X > SideBarX and X < PositionX+SizeX+3 and Y > PositionY+4 and Y < PositionY+SizeY+3) then
                if (ScrollMainBoxAllowed == true) then
                    RefreshPosition()
                    if (ScrollMainBox == 0) then
                        ScrollMainBox = 1
                    end
                    if (Button == -1) then
                        if (ScrollMainBox > 1) then
                            ScrollMainBox = ScrollMainBox - 1
                            DrawnFiles()
                        end
                    else
                        if (ScrollMainBoxStopping == true) then
                            ScrollMainBox = ScrollMainBox + 1
                            DrawnFiles()
                        end
                    end
                end
            end
            if (Event == "mouse_scroll" and X < SideBarX-1 and Y < SizeY+3) then
                RefreshPosition()
                if (ScrollSideBarAllowed == true) then
                    if (ScrollSideBar == 0) then
                        ScrollSideBar = 1
                        DrawnTexts()
                    end
                    if (Button == -1) then
                        if (ScrollSideBar > 1) then
                            ScrollSideBar = ScrollSideBar - 1
                            DrawnTexts()
                        end
                    else
                        if (StopScrollDown == false) then
                            ScrollSideBar = ScrollSideBar + 1
                            DrawnTexts()
                        end
                    end
                end
            end
            if (Event == "mouse_click" and X > PositionX-2 and X < SideBarX and Y > PositionY+3 and Y < PositionY+5) then
                SideBarSelectedFile = ""
                DrawnTexts()
            end
            if (Event == "mouse_click" and X > PositionX-2 and X < SideBarX and Y > PositionY+4 and Y < PositionY+SizeY+3) then
                DrawnTexts()
                if (table.getn(FilesToWork) == 0) then
                    if (fs.list(CurrentDir)[(Y-(PositionY+4))] == nil) then
                        SideBarSelectedFile = ""
                        DrawnTexts()
                    end
                    if (fs.list(CurrentDir)[(Y-(PositionY+4))] and fs.isDir(CurrentDir..fs.list(CurrentDir)[(Y-(PositionY+4))]) == true) then
                            DrawnTexts()
                            if (SideBarSelectedFile == CurrentDir..fs.list(CurrentDir)[(Y-(PositionY+4))] and fs.isDir(SideBarSelectedFile) == true) then
                                SideBarSelectedFile = ""
                                table.insert(PathHistory, CurrentDir)
                                CurrentDir = CurrentDir..fs.list(CurrentDir)[(Y-(PositionY+4))].."/"
                                SelectedFiles = ""
                                SideBarSelectedFile = ""
                                DrawnTexts()
                            else
                                SideBarSelectedFile = CurrentDir..fs.list(CurrentDir)[(Y-(PositionY+4))]
                                DrawnTexts()
                                DrawnBox(PositionX-1, Y, SideBarX, Y+1, Colors.SelectedItem)
                                Write(PositionX, Y, Colors.menu.text, Colors.SelectedItem, string.char(16)..string.sub(fs.list(CurrentDir)[(Y-(PositionY+4))], 1, SideBarX-PositionX-1))
                            end
                    else
                        if (fs.list(CurrentDir)[(Y-(PositionY+4))] ~= nil) then 
                            SideBarSelectedFile = CurrentDir..fs.list(CurrentDir)[(Y-(PositionY+4))]
                            DrawnTexts()
                            DrawnBox(PositionX-1, Y, SideBarX, Y+1, Colors.SelectedItem)
                            Write(PositionX+1, Y, Colors.menu.text, Colors.SelectedItem, string.sub(fs.list(CurrentDir)[(Y-(PositionY+4))], 1, SideBarX-PositionX-1))
                            OPENFILE(CurrentDir..fs.list(CurrentDir)[(Y-(PositionY+4))])
                        end
                    end
                else
                    if (fs.isDir(CurrentDir..FilesToWork[(Y-(PositionY+4))]) == true) then
                            DrawnTexts()
                            if (SideBarSelectedFile == CurrentDir..FilesToWork[(Y-(PositionY+4))] and fs.isDir(SideBarSelectedFile) == true) then
                                SideBarSelectedFile = ""
                                table.insert(PathHistory, CurrentDir)
                                CurrentDir = CurrentDir..FilesToWork[(Y-(PositionY+4))].."/"
                                SelectedFiles = ""
                                SideBarSelectedFile = ""
                                DrawnTexts()
                            else
                                SideBarSelectedFile = CurrentDir..FilesToWork[(Y-(PositionY+4))]
                                DrawnTexts()
                            end
                            if (FilesToWork[(Y-(PositionY+4))] ~= nil) then
                                DrawnBox(PositionX-1, Y, SideBarX, Y+1, Colors.SelectedItem)
                                Write(PositionX, Y, Colors.menu.text, Colors.SelectedItem, string.char(16)..string.sub(FilesToWork[(Y-(PositionY+4))], 1, SideBarX-PositionX-1))
                            end
                    else
                        SideBarSelectedFile = FilesToWork[(Y-(PositionY+4))]
                        DrawnTexts()
                        DrawnBox(PositionX-1, Y, SideBarX, Y+1, Colors.SelectedItem)
                        Write(PositionX+1, Y, Colors.menu.text, Colors.SelectedItem, string.sub(FilesToWork[(Y-(PositionY+4))], 1, SideBarX-PositionX-1))
                        OPENFILE(CurrentDir..FilesToWork[(Y-(PositionY+4))])
                    end
                end
            end
            if (Event == "mouse_click" and X == PositionX and Y == PositionY+2 and table.getn(PathHistory) ~= 0) then
                Write(PositionX, PositionY+2, Colors.SelectedItem, Colors.menu.background, string.char(27))
                sleep(0.1)
                if (PathHistory[table.getn(PathHistory)] ~= nil) then
                    table.insert(PathHistoryF, CurrentDir)
                    CurrentDir = PathHistory[table.getn(PathHistory)] or DefaultDir
                    SelectedFiles = ""
                    SideBarSelectedFile = ""
                    table.remove(PathHistory, table.getn(PathHistory))
                    Drawn()
                end
            end
            if (Event == "mouse_click" and X == PositionX+1 and Y == PositionY+2 and table.getn(PathHistoryF) ~= 0) then
                Write(PositionX+1, PositionY+2, Colors.SelectedItem, Colors.menu.background, string.char(26))
                sleep(0.1)
                if (PathHistoryF[table.getn(PathHistoryF)] ~= nil) then
                    table.insert(PathHistory, CurrentDir)
                    CurrentDir = PathHistoryF[table.getn(PathHistoryF)] or DefaultDir
                    SelectedFiles = ""
                    SideBarSelectedFile = ""
                    table.remove(PathHistoryF, table.getn(PathHistoryF))
                    Drawn()
                end
            end
            if (Event == "mouse_click" and X == PositionX+2 and Y == PositionY+2 and CurrentDir ~= FirstFolder) then
                Write(PositionX+2, PositionY+2, Colors.SelectedItem, Colors.menu.background, string.char(24))
                sleep(0.1)
                NumberOfSlachs = 0
                for Index = 1, string.len(CurrentDir) do
                    if (string.sub(CurrentDir, string.len(CurrentDir)-Index, string.len(CurrentDir)-Index) == "/") then
                        NumberOfSlachs = NumberOfSlachs + 1
                    end
                end
                if (NumberOfSlachs > 0) then
                    for Index = 1, string.len(CurrentDir) do
                        if (string.sub(CurrentDir, string.len(CurrentDir)-Index, string.len(CurrentDir)-Index) == "/") then
                            table.insert(PathHistory, CurrentDir)
                            CurrentDir = string.sub(CurrentDir, 1, string.len(CurrentDir)-Index)
                            SelectedFiles = ""
                            SideBarSelectedFile = ""
                            Drawn()
                            break
                        end
                    end
                else
                    CurrentDir = FirstFolder
                    SelectedFiles = ""
                    SideBarSelectedFile = ""
                    table.insert(PathHistory, CurrentDir)
                    Drawn()
                end
            end
            if (Event == "mouse_click") then
                if (table.getn(MainFilesToWork) > 0) then
                    for K,V in ipairs(MainFilesToWork) do
                        if (K == nil or V == nil) then DrawnFiles() end
                        if (X >= V[1]-1 and X <= V[1]+3 and Y >= V[2] and Y <= V[2]+5) then
                            if (V[3] == "FO") then
                                if (SelectedFiles == MainFilesToWork[K][8]) then
                                    ScrollMainBox = 0
                                    table.insert(PathHistory, CurrentDir)
                                    CurrentDir = CurrentDir..MainFilesToWork[K][8].."/"
                                    SelectedFiles = ""
                                    SideBarSelectedFile = ""
                                    Drawn()
                                    break
                                else
                                    SelectedFiles=MainFilesToWork[K][8]
                                end
                                DrawnFiles()
                                break
                            else
                                if (SelectedFiles == MainFilesToWork[K][6]) then
                                    OPENFILE(CurrentDir..MainFilesToWork[K][6])
                                else
                                    SelectedFiles=MainFilesToWork[K][6]
                                end
                                DrawnFiles()
                                break
                            end
                        end
                    end
                else
                    for K,V in ipairs(fs.list(CurrentDir)) do
                        if (K == nil or V == nil or V[1] == nil) then return end
                        if (X >= V[1]-1 and X <= V[1]+3 and Y >= V[2] and Y <= V[2]+5) then
                            if (V[3] == "FO") then
                                if (SelectedFiles == fs.list(CurrentDir)[K]) then
                                    ScrollMainBox = 0
                                    CurrentDir = CurrentDir..fs.list(CurrentDir)[K].."/"
                                    SelectedFiles = ""
                                    SideBarSelectedFile = ""
                                    table.insert(PathHistory, CurrentDir)
                                    Drawn()
                                    break
                                end
                            else
                                if (SelectedFiles == fs.list(CurrentDir)[K]) then
                                    ScrollMainBox = 0
                                    OPENFILE(CurrentDir..fs.list(CurrentDir)[K])
                                end
                            end
                            SelectedFiles=fs.list(CurrentDir)[K]
                            DrawnFiles()
                            break
                        end
                    end
                end
            end
        end 
    end
    function Checker()
        while true do
            RefreshPosition()
            if (SideBarSelectedFile ~= "") then
                if (fs.isDir(SideBarSelectedFile) == true) then
                    --Is a folder
                    FN = ""
                    for k = 1, string.len(SideBarSelectedFile) do
                        if (string.sub(SideBarSelectedFile, string.len(SideBarSelectedFile)-k, string.len(SideBarSelectedFile)-k) == "/") then
                            FN = string.sub(SideBarSelectedFile, (string.len(SideBarSelectedFile)-k)+1, string.len(SideBarSelectedFile))
                        else
                            FN = SideBarSelectedFile
                        end
                    end
                    for k = 1, string.len(FN) do
                        if (string.sub(FN, string.len(FN)-k, string.len(FN)-k) == "/") then
                            if (string.sub(FN, (string.len(FN)-k)+1, string.len(FN)) == nil) then
                                break
                            else
                                FN = string.sub(FN, (string.len(FN)-k)+1, string.len(FN))
                            end
                        end
                    end
                    if (table.getn(FilesToWork) == 0) then
                        for G,J in ipairs(fs.list(CurrentDir)) do
                            if (J == FN) then
                                --We find the Folder, lets make it blue
                                DrawnFilledBox(PositionX-1, PositionY+4+G, SideBarX, PositionY+5+G, Colors.SelectedItem)
                                Write(PositionX, PositionY+4+G, Colors.menu.text, Colors.SelectedItem, string.char(16)..string.sub(FN, 1, SideBarX-PositionX-1))
                            end
                        end
                    else
                        for G,J in ipairs(FilesToWork) do
                            if (J == FN) then
                                --We find the Folder, lets make it blue
                                DrawnFilledBox(PositionX-1, PositionY+4+G, SideBarX, PositionY+5+G, Colors.SelectedItem)
                                Write(PositionX, PositionY+4+G, Colors.menu.text, Colors.SelectedItem, string.char(16)..string.sub(FN, 1, SideBarX-PositionX-1))
                            end
                        end
                    end
                else
                    --Isn't a folder
                    FN = ""
                    for k = 1, string.len(SideBarSelectedFile) do
                        if (string.sub(SideBarSelectedFile, string.len(SideBarSelectedFile)-k, string.len(SideBarSelectedFile)-k) == "/") then
                            FN = string.sub(SideBarSelectedFile, (string.len(SideBarSelectedFile)-k)+1, string.len(SideBarSelectedFile))
                        else
                            FN = SideBarSelectedFile
                        end
                    end
                    for k = 1, string.len(FN) do
                        if (string.sub(FN, string.len(FN)-k, string.len(FN)-k) == "/") then
                            FN = string.sub(FN, (string.len(FN)-k)+1, string.len(FN))
                        end
                    end
                    if (table.getn(FilesToWork) == 0) then
                        for G,J in ipairs(fs.list(CurrentDir)) do
                            if (J == FN) then
                                --We find the Folder, lets make it blue
                                DrawnFilledBox(PositionX-1, PositionY+4+G, SideBarX, PositionY+5+G, Colors.SelectedItem)
                                Write(PositionX, PositionY+4+G, Colors.menu.text, Colors.SelectedItem, " "..string.sub(FN, 1, SideBarX-PositionX-1))
                            end
                        end
                    else
                        for G,J in ipairs(FilesToWork) do
                            if (J == FN) then
                                --We find the Folder, lets make it blue
                                DrawnFilledBox(PositionX-1, PositionY+4+G, SideBarX, PositionY+5+G, Colors.SelectedItem)
                                Write(PositionX, PositionY+4+G, Colors.menu.text, Colors.SelectedItem, " "..string.sub(FN, 1, SideBarX-PositionX-1))
                            end
                        end
                    end
                end
            end
            if (OldDir ~=CurrentDir) then
                OldDir = CurrentDir
                Drawn()
            end
            sleep(0.1)
        end
    end
    Drawn()
    parallel.waitForAll(A,Drawn,Checker)
    sleep(1)
    --Drawn()
    --A()
end

while true do
ACTION()
end
