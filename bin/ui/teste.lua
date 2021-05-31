--[###################################################################################]--
--[                                                                                   ]--
--[                                    Explorer V1                                    ]--
--[                                   Inportance: 1                                   ]--
--[                                By Space_Interprise                                ]--
--[                  Search files and folders in a beauty UI program                  ]--
--[                                                                                   ]--
--[###################################################################################]--

--TODO:
--  Make the sideBar folders droppable (Comming Soon because isn't sufficiently inportant to be added now and will not interrupt you)
--  Make the topbar dir editable for navegation (Comming Soon because isn't sufficiently inportant to be added now and will not interrupt you)

--[CONFIGS]--
local util = require("/lib/util")
local file = util.loadModule("file")
local homedir = file.readTable("/etc/accounts.cfg")
Wm = _G.wm
Colors = file.readTable("/etc/colors.cfg")

MaximazedOld = false
SizeXOld = Wm.listProcesses()[Wm.getSelectedProcessID()].width -4
SizeYOld = Wm.listProcesses()[Wm.getSelectedProcessID()].height - 2
OldDir = string.sub(homedir[1].homeDir,2, string.len(homedir[1].homeDir)).."/"

SideBarStoppingDown = false
ScrollMainBox = 0
ScrollSideBar = 0
ScrollMainBoxAllowed = false
ScrollSideBarAllowed = false
FilesToWork = {} --SIDEBAR --SCROLL SYSTEM
MainFilesToWork = {} --MainBox --SCROLL SYSTEM
--[Get the homeDir]-- (WARNING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! change this to support more than 1 user!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!)
DefaultDir = string.sub(homedir[1].homeDir,2, string.len(homedir[1].homeDir)).."/" --the folder you will seen when you open the explorer
--End of home dir
FirstFolder = "home/" -- the folder you cannot get out
CurrentDir = DefaultDir --Defines the initial folder to the defaltDir
DiskName = "S:/" --Name of diskPartition --OBS: just used on TopBar Define it to "" if you dont want a Disk Partition Name
--[THIS NEED TO BE REFRESHED]--
function RefreshPosition()
    if (Wm.listProcesses()[Wm.getSelectedProcessID()].maximazed == true) then
        ScreenSizeX, ScreenSizeY = term.getSize()
        ScreenSizeX = ScreenSizeX-4
        ScreenSizeY = ScreenSizeY-2
    else
        ScreenSizeX = Wm.listProcesses()[Wm.getSelectedProcessID()].width -4
        ScreenSizeY = Wm.listProcesses()[Wm.getSelectedProcessID()].height - 2
    end
    if (ScreenSizeY < 9) then
        if (Wm.listProcesses()[Wm.getSelectedProcessID()].title == "folders") then
            Wm.listProcesses()[Wm.getSelectedProcessID()].height = 10
        end
    end
    ScrollMainBoxAllowed = false
    SizeX = ScreenSizeX
    SizeY = ScreenSizeY
    PositionX = 2
    PositionY = 0
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

--function DELETEFILE(DirWithFileName)
--Do something Here!!!!!!
--end

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
    if (Wm.listProcesses()[Wm.getSelectedProcessID()].maximazed ~= true) then
        DrawnPixel(Colors.menu.text, (PositionX+SizeX)+2, (PositionY+SizeY+2)) --RESIZING SYSTEM]
        Write((PositionX+SizeX)+2, (PositionY+SizeY+2), Colors.menu.background, Colors.menu.text, string.char(127))
    end
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
    if (Wm.listProcesses()[Wm.getSelectedProcessID()].maximazed ~= true) then
        DrawnPixel(Colors.menu.text, (PositionX+SizeX)+2, (PositionY+SizeY+2)) --RESIZING SYSTEM]
        Write((PositionX+SizeX)+2, (PositionY+SizeY+2), Colors.menu.background, Colors.menu.text, string.char(127))
    end
end

function DrawnTexts()
    DrawnFilledBox(PositionX-1,PositionY+4,SideBarX, SideBarY, Colors.main.backgroundSecondary)--SideBar
    --[SideBar Dirs]--

    ScrollSideBarAllowed = PositionY+2+table.getn(fs.list(CurrentDir)) >PositionY+SizeY
    if (ScrollSideBar > 0 and ScrollSideBarAllowed == true) then
        if (ScrollSideBar >= table.getn(fs.list(CurrentDir))-((SizeY-3))) then
            SideBarStoppingDown = true
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
    if (Wm.listProcesses()[Wm.getSelectedProcessID()].maximazed ~= true) then
        DrawnPixel(Colors.menu.text, (PositionX+SizeX)+2, (PositionY+SizeY+2)) --RESIZING SYSTEM]
        Write((PositionX+SizeX)+2, (PositionY+SizeY+2), Colors.menu.background, Colors.menu.text, string.char(127))
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
    DrawnFilledBox(SideBarX,4,(PositionX+SizeX)+3, (PositionY+SizeY+3), Colors.menu.background)
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
                        table.insert(AllFiles, (SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+5+((CurrentLineVertical-1)*7), fs.list(CurrentDir)[Item], "FOLDER")
                    else
                        if (PositionY+3+((CurrentLineVertical)*7) < (PositionY+SizeY+3)) then
                            DrawningFI(fs.list(CurrentDir)[Item], Colors.SelectedItem)
                        end
                        table.insert(AllFiles, (SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+5+((CurrentLineVertical-1)*7), fs.list(CurrentDir)[Item], "FILE")
                    end
                else
                    if (fs.isDir(CurrentDir..fs.list(CurrentDir)[Item]) == true) then
                        if (PositionY+3+((CurrentLineVertical)*7) < (PositionY+SizeY+3)) then
                            DrawningFO(fs.list(CurrentDir)[Item], Colors.main.text)
                        end
                        table.insert(AllFiles, (SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+5+((CurrentLineVertical-1)*7), fs.list(CurrentDir)[Item], "FOLDER")
                    else
                        if (PositionY+3+((CurrentLineVertical)*7) < (PositionY+SizeY+3)) then
                            DrawningFI(fs.list(CurrentDir)[Item], Colors.main.text)
                        end
                        table.insert(AllFiles, (SideBarX+1)+(CurrentLineHorizontal-1)*5, PositionY+5+((CurrentLineVertical-1)*7), fs.list(CurrentDir)[Item], "FILE")
                    end
                end
                CurrentLineHorizontal = CurrentLineHorizontal + 1
            end
        end
    end
    if (Wm.listProcesses()[Wm.getSelectedProcessID()].maximazed ~= true) then
        DrawnPixel(Colors.menu.text, (PositionX+SizeX)+2, (PositionY+SizeY+2)) --RESIZING SYSTEM]
        Write((PositionX+SizeX)+2, (PositionY+SizeY+2), Colors.menu.background, Colors.menu.text, string.char(127))
    end
end

--Unicode codes (dont work in computercraft on minecraft 1.7.10 and i thing Under versions too)
--24 /|\
--26 ->
--27 <-
--30 /\
--31 \/

function Drawn()
        --Wm.changeSettings(Wm.getSelectedProcessID(), {title="Arroz doce"})
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
        --[MOUSE GETTER]--
        Event, Button, X, Y = os.pullEventRaw()
        if (Event == "key_up" and Button == 28 and SelectedFiles ~= "") then
            CurrentDir = CurrentDir..SelectedFiles.."/"
            SelectedFiles = ""
            SideBarSelectedFile = ""
            Drawn()
        end
        --if (Event == "key_up" and Button == 211 and SelectedFiles ~= "") then
            --DELETEFILE(CurrentDir..SelectedFiles)
            --Drawn()
            --break
        --end
            if (Event == "mouse_scroll" and X > SideBarX and X < PositionX+SizeX+3 and Y > PositionY+4 and Y < PositionY+SizeY+3) then
                if (ScrollMainBoxAllowed == true) then
                    if (ScrollMainBox == 0) then
                        ScrollMainBox = 1
                    end
                    if (Button == -1) then
                        --ToUp
                        if (ScrollMainBox > 0) then
                            ScrollMainBox = ScrollMainBox - 1
                        end
                    else
                        --ToDown
                        ScrollMainBox = ScrollMainBox + 1
                    end
                    DrawnFiles()
                end
            end
            if (Event == "mouse_scroll" and X > PositionX-2 and X < SideBarX-1 and Y > PositionY+3 and Y < PositionY+SizeY+3) then
                if (ScrollSideBarAllowed == true) then
                    if (ScrollSideBar == 0) then
                        ScrollSideBar = 1
                    end
                    if (Button == -1) then
                        --ToUp
                        if (ScrollSideBar >= 1) then
                            ScrollSideBar = ScrollSideBar - 1
                            DrawnTexts()
                        end
                    else
                        if (SideBarStoppingDown == false) then
                            --ToDown
                            ScrollSideBar = ScrollSideBar + 1
                            DrawnTexts()
                        end
                    end
                end
            end
            --SideBarClickable
            if (Event == "mouse_click" and X > PositionX-2 and X < SideBarX and Y > PositionY+3 and Y < PositionY+5) then
                SideBarSelectedFile = ""
                DrawnTexts()
            end
            if (Event == "mouse_click" and X > PositionX-2 and X < SideBarX and Y > PositionY+4 and Y < PositionY+SizeY+3) then
                --No Scroll
                DrawnTexts()
                if (table.getn(FilesToWork) == 0) then
                    if (fs.list(CurrentDir)[(Y-(PositionY+4))] == nil) then
                        SideBarSelectedFile = ""
                        DrawnTexts()
                    end
                    if (fs.list(CurrentDir)[(Y-(PositionY+4))] and fs.isDir(CurrentDir..fs.list(CurrentDir)[(Y-(PositionY+4))]) == true) then
                        --if (X == PositionX) then --Droppable system 
                            --Drop Folder
                        --else
                            --Enter in the folder
                            DrawnTexts()
                            if (SideBarSelectedFile == CurrentDir..fs.list(CurrentDir)[(Y-(PositionY+4))] and fs.isDir(SideBarSelectedFile) == true) then
                                --Open the folder in a big exibition
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
                        --end
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
                        --if (X == PositionX) then --Droppable system
                            --Drop folder
                        --else
                            --Enter in the folder
                            DrawnTexts()
                            if (SideBarSelectedFile == CurrentDir..FilesToWork[(Y-(PositionY+4))] and fs.isDir(SideBarSelectedFile) == true) then
                                --Open the folder in a big exibition
                                SideBarSelectedFile = ""
                                table.insert(PathHistory, CurrentDir)
                                CurrentDir = CurrentDir..FilesToWork[(Y-(PositionY+4))]
                                SelectedFiles = ""
                                SideBarSelectedFile = ""
                                DrawnTexts()
                            else
                                SideBarSelectedFile = CurrentDir..FilesToWork[(Y-(PositionY+4))]
                                DrawnTexts()
                            end
                            DrawnBox(PositionX-1, Y, SideBarX, Y+1, Colors.SelectedItem)
                            Write(PositionX, Y, Colors.menu.text, Colors.SelectedItem, string.char(16)..string.sub(FilesToWork[(Y-(PositionY+4))], 1, SideBarX-PositionX-1))
                        --end
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
                            CurrentDir = string.sub(CurrentDir, 1, string.len(CurrentDir)-Index)
                            SelectedFiles = ""
                            SideBarSelectedFile = ""
                            table.insert(PathHistory, CurrentDir)
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
            --[Big Files View Clicable files]--
            if (Event == "mouse_click") then
                if (table.getn(MainFilesToWork) > 0) then
                    for K,V in ipairs(MainFilesToWork) do
                        if (K == nil or V == nil) then Drawn() end
                        if (X >= V[1]-1 and X <= V[1]+3 and Y >= V[2] and Y <= V[2]+5) then
                            if (V[3] == "FO") then
                                if (SelectedFiles == MainFilesToWork[K][8]) then
                                    ScrollMainBox = 0
                                    table.insert(PathHistory, CurrentDir)
                                    CurrentDir = CurrentDir..MainFilesToWork[K][8].."/"
                                    SelectedFiles = ""
                                    SideBarSelectedFile = ""
                                    MainFilesToWork = {}
                                    Drawn()
                                else
                                    SelectedFiles=MainFilesToWork[K][8]
                                end
                            else
                                if (SelectedFiles == MainFilesToWork[K][6]) then
                                    OPENFILE(CurrentDir..MainFilesToWork[K][6])
                                end
                                SelectedFiles=MainFilesToWork[K][6]
                            end
                            Drawn()
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
                                end
                            else
                                if (SelectedFiles == fs.list(CurrentDir)[K]) then
                                    ScrollMainBox = 0
                                    OPENFILE(CurrentDir..fs.list(CurrentDir)[K])
                                end
                            end
                            SelectedFiles=fs.list(CurrentDir)[K]
                            Drawn()
                        end
                    end
                end
            end
            
        --[END]--
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
            if (Wm.listProcesses()[Wm.getSelectedProcessID()].maximazed ~= MaximazedOld) then
                MaximazedOld = Wm.listProcesses()[Wm.getSelectedProcessID()].maximazed
                Drawn()
            end
            if (SizeXOld ~= ScreenSizeX and Wm.listProcesses()[Wm.getSelectedProcessID()].maximazed == false) then
                SizeXOld = ScreenSizeX
                Drawn()
            end
            if (SizeYOld ~= ScreenSizeY and Wm.listProcesses()[Wm.getSelectedProcessID()].maximazed == false) then
                SizeYOld = ScreenSizeY
                Drawn()
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
