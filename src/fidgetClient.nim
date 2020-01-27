import fidget,os,chroma

import game_logic,colorScheme

let game = new(GameOfTicTacToe)
let settings = new(Settings)
settings.setDefault()
game.setup(settings)

when not defined(js):
    import typography,tables
    fonts["IBM Plex Sans Regular"] = readFontSvg(getAppDir() & "/data/IBMPlexSans-Regular.svg")
    fonts["IBM Plex Sans Bold"] = readFontSvg(getAppDir() & "/data/IBMPlexSans-Bold.svg")

proc startGame() = 
    game.setup(settings)

proc makeSquare() =
    if current.box.w > current.box.h:
        current.box.w = current.box.h
    if current.box.h > current.box.w:
        current.box.h = current.box.w
    
proc createGameField() =
    let fieldWidth = min(current.box.w,current.box.h)
    let boxWidth = (int)(fieldWidth - 2) / game.field.len - 2
    var x,y = 2.0
    var dark = false
    for i,row in game.field:
        x = 2
        for j,field in row:
            rectangle "field":
                box x,y,boxWidth,boxWidth
                if dark:
                    fill colors.fieldDark
                else:
                    fill colors.fieldLight
                dark = not dark
                # if field is empty allow clicking
                if field == 0:
                    onClick:
                        game.makeTurn($(i+1) & "." & $(j+1))
                text "symbol":
                    box 0,0,boxWidth,boxWidth
                    characters desc[field]
                    fill blackColor
                    font "IBM Plex Sans Bold", fieldWidth, 200, 0, 0, 0
            x += boxWidth + 2
        y += boxWidth + 2


proc drawMainFrame() =
    frame "Frame 1":
        orgBox 0,0,1280,720
        box root.box
        constraints cMin, cMin
        fill "#ffffff"
        strokeWeight 1
        rectangle "Heading":
            box 400, 20, 480, 60
            constraints cCenter, cMin
            fill "#d7ba56"
            cornerRadius 30
            strokeWeight 1
            text "Tic-Tac-Toe":
                box 0, 0, 480, 60
                constraints cMin, cMin
                fill "#000000"
                strokeWeight 1
                stroke color(0,1,0)
                font "IBM Plex Sans Bold", 48, 200, 0, 0, 0
                characters "Tic-Tac-Toe"
        frame "GameFrame":
            box 335, 90, 610, 610
            constraints cBoth, cBoth
            makeSquare()
            rectangle "Rectangle 2":
                box 0, 0, parent.box.h, parent.box.w
                fill "#c4c4c4"
                rectangle "Rectangle 3":
                    box 5, 5, parent.box.w - 10, parent.box.h - 10
                    fill "#eeeeee"
                    createGameField()
        frame "Leaderboard":
            box 960, 40, 300, 655
            orgBox 960, 40, 300, 655
            constraints cMax, cBoth
            cornerRadius 0
            strokeWeight 1
            rectangle "Rectangle 4":
                box 20, 10, 260, 50
                constraints cMin, cMin
                fill "#c4c4c4"
                cornerRadius 25
                strokeWeight 1
            text "Leaderboard":
                box 20, 10, 260, 50
                constraints cMin, cMin
                fill "#000000"
                strokeWeight 1
                font "IBM Plex Sans Regular", 36, 200, 0, 0, 0
                characters "Leaderboard"
            group "Table":
                box 0, 70, 300, 585
                orgBox 0, 70, 300, 585
                constraints cMin,cBoth
                rectangle "Rectangle 6":
                    box 0, 41, 300, 40
                    constraints cMin, cMin
                    fill "#d7ba56"
                    cornerRadius 0
                    strokeWeight 1
                text "Sum":
                    box 0, 41, 100, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    characters "Sum"
                text "Score1":
                    box 100, 41, 100, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    characters "0"
                text "Score2":
                    box 200, 41, 100, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    characters "0"
                text "Player1":
                    box 100, 1, 100, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    characters "Player 1"
                text "Player2":
                    box 200, 1, 100, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    characters "Player 2"
                rectangle "hline":
                    box 0, 40, 300, 2
                    constraints cMin, cMin
                    fill "#c4c4c4"
                    cornerRadius 0
                    strokeWeight 1
                rectangle "hline":
                    box 0, 80, 300, 2
                    constraints cMin, cMin
                    fill "#c4c4c4"
                    cornerRadius 0
                    strokeWeight 1
                rectangle "vline1":
                    box 99, 0, 2, 585
                    constraints cMin, cBoth
                    fill "#c4c4c4"
                    cornerRadius 0
                    strokeWeight 1
                rectangle "vline2":
                    box 199, 0, 2, 585
                    constraints cMin, cBoth
                    fill "#c4c4c4"
                    cornerRadius 0
                    strokeWeight 1
                text "Match":
                    box 0, 1, 100, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    characters "Match"
        frame "Settings":
            var buttonColor: Color
            box 20, 40, 300, 655
            constraints cMin, cBoth
            cornerRadius 0
            strokeWeight 1
            rectangle "Rectangle 4":
                box 20, 10, 260, 50
                constraints cMin, cMin
                fill "#c4c4c4"
                cornerRadius 25
                strokeWeight 1
            text "Settings":
                box 20, 10, 260, 50
                constraints cMin, cMin
                fill "#000000"
                strokeWeight 1
                font "IBM Plex Sans Regular", 36, 200, 0, 0, 0
                characters "Settings"
            group "SettingButtons":
                box 45, 360, 200, 50
                rectangle "startButton":
                    box 0, 0, 200, 50
                    constraints cMin, cMin
                    fill colors.buttonColor
                    cornerRadius 25
                    strokeWeight 1
                    onClick:
                        startGame()
                    onHover:
                        fill colors.buttonHover
                    onDown:
                        fill colors.buttonPressed
                text "start":
                    box 0, 0, 200, 50
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 36, 200, 0, 0, 0
                    characters "start"
            group "P2Name":
                box 0, 155, 276, 40
                text "Player 2:":
                    box 0, 0, 120, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, -1, 0
                    characters "Player 2: "
                rectangle "P1Name":
                    box 120, 0, 156, 40
                    constraints cMin, cMin
                    fill "#c4c4c4"
                    cornerRadius 0
                    strokeWeight 1
                rectangle "P1Name":
                    box 121, 1, 154, 38
                    constraints cMin, cMin
                    fill "#eeeeee"
                    cornerRadius 0
                    strokeWeight 1
                text "P2NameInput":
                    box 121, 1, 154, 38
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    binding settings.name2
            group "P1Name":
                box 0, 110, 276, 40
                text "Player 1:":
                    box 0, 0, 120, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, -1, 0
                    characters "Player 1: "
                rectangle "P1Name":
                    box 120, 0, 156, 40
                    constraints cMin, cMin
                    fill "#c4c4c4"
                    cornerRadius 0
                    strokeWeight 1
                rectangle "P1Name":
                    box 121, 1, 154, 38
                    constraints cMin, cMin
                    fill "#eeeeee"
                    cornerRadius 0
                    strokeWeight 1
                text "P1NameInput":
                    box 121, 0, 154, 38
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    binding settings.name1
            group "FieldSize":
                box 0, 225, 265, 40
                text "Field Size:":
                    box 0, 0, 130, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, -1, 0
                    characters "Field Size:"
                rectangle "P1Name":
                    box 181, 0, 50, 40
                    constraints cMin, cMin
                    fill "#c4c4c4"
                    cornerRadius 0
                    strokeWeight 1
                rectangle "P1Name":
                    box 182, 1, 48, 38
                    constraints cMin, cMin
                    fill "#eeeeee"
                    cornerRadius 0
                    strokeWeight 1
                text "FieldSizeInput":
                    box 182, 1, 48, 38
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    characters $(settings.size)
                frame "MinField":
                    box 145, 5, 30, 30
                    constraints cMin, cMin
                    buttonColor = colors.buttonColor
                    onClick:
                        if settings.size > settings.winCount:
                            settings.size -= 1
                    onHover:
                        buttonColor = colors.buttonHover
                    onDown:
                        buttonColor = colors.buttonPressed
                    rectangle "Rectangle 8":
                        box 0, 12.5, 30, 5
                        constraints cMin, cMin
                        fill buttonColor
                        cornerRadius 0
                frame "plusField":
                    box 235, 5, 30, 30
                    constraints cMin, cMin
                    onClick:
                        if settings.size < 9:
                            settings.size += 1
                    buttonColor = colors.buttonColor
                    onHover:
                        buttonColor = colors.buttonHover
                    onDown:
                        buttonColor = colors.buttonPressed
                    rectangle "Rectangle 7":
                        box 12.5, 0, 5, 30
                        constraints cMin, cMin
                        fill buttonColor
                        cornerRadius 0
                        strokeWeight 1
                    rectangle "Rectangle 8":
                        box 0, 12.5, 30, 5
                        constraints cMin, cMin
                        fill buttonColor
                        cornerRadius 0
                        strokeWeight 1
            group "Win Count":
                box 0, 270, 265, 40
                text "Win Count:":
                    box 0, 0, 130, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, -1, 0
                    characters "Win Count: "
                rectangle "P1Name":
                    box 181, 0, 50, 40
                    constraints cMin, cMin
                    fill "#c4c4c4"
                    cornerRadius 0
                    strokeWeight 1
                rectangle "P1Name":
                    box 182, 1, 48, 38
                    constraints cMin, cMin
                    fill "#eeeeee"
                    cornerRadius 0
                    strokeWeight 1
                text "WinCountInput":
                    box 182, 1, 48, 38
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    characters $(settings.winCount)
                frame "MinField":
                    box 145, 5, 30, 30
                    constraints cMin, cMin
                    onClick:
                        if settings.winCount > 0:
                            settings.winCount -= 1
                    buttonColor = colors.buttonColor
                    onHover:
                        buttonColor = colors.buttonHover
                    onDown:
                        buttonColor = colors.buttonPressed
                    rectangle "Rectangle 8":
                        box 0, 12.5, 30, 5
                        constraints cMin, cMin
                        fill buttonColor
                        cornerRadius 0
                        strokeWeight 1
                frame "plusField":
                    box 235, 5, 30, 30
                    constraints cMin, cMin
                    onClick:
                        if settings.winCount < settings.size:
                            settings.winCount += 1
                    buttonColor = colors.buttonColor
                    onHover:
                        buttonColor = colors.buttonHover
                    onDown:
                        buttonColor = colors.buttonPressed
                    rectangle "Rectangle 7":
                        box 12.5, 0, 5, 30
                        constraints cMin, cMin
                        fill buttonColor
                        cornerRadius 0
                        strokeWeight 1
                    rectangle "Rectangle 8":
                        box 0, 12.5, 30, 5
                        constraints cMin, cMin
                        fill buttonColor
                        cornerRadius 0
                        strokeWeight 1
                
drawMain = drawMainFrame
startFidget()