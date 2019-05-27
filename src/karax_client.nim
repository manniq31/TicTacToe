import 
  strformat,
  karax / [kbase, karax, karaxdsl, vdom, kdom, jstrutils, vstyles],

  game_logic


let game = new(GameOfTicTacToe)#
let settings = new(Settings)

var state = 0
var fieldBlocked = false


proc inputHandler(ev: Event, n: VNode) =
  case $n.id:
    of "name1":
      settings.name1 = if $n.value != "" : $n.value else: "player 1"
    of "name2":
      settings.name2 = if $n.value != "" : $n.value else: "player 2"
    of "AI":
      settings.ai = not settings.ai
    of "fieldSize":
      settings.size = if $n.value != "" : n.value.parseInt else: 3
    of "winCount":
      settings.winCount = if $n.value != "" : n.value.parseInt else: 3

proc startGame()=
  game.setup(settings)
  state = 2


proc clickField(ev: Event, n: VNode) =
  if settings.ai:
    #if playing against ai this might take a short time
    fieldBlocked = true
    redraw()
  #make the move
  game.make_turn($n.id)
  fieldBlocked = false
  if game.finished:
    window.alert(game.getPlayerName & " won the game")
  

proc setupGUI(): VNode =
  buildHtml(tdiv(class="center")):
    tdiv(class = "grid-container"):
      tdiv(class="grid-item"):
        label(`for`="name1"):
          text "Player 1: "
      tdiv(class="grid-item"):
        input(placeholder ="player 1", id="name1", onkeyup = inputHandler)
      tdiv(class="grid-item"):
        label(`for`="name2"):
          text "Player 2: "
      tdiv(class="grid-item"):
        input(placeholder="player 2" ,id="name2", onkeyup = inputHandler)
        label(style=style(StyleAttr.marginLeft,"5px")):
          text "AI"
          input(type="checkbox", id="AI", onClick = inputHandler)
      tdiv(class="grid-item"):
        label(`for`="fieldSize"):
          text "Field size: "
      tdiv(class="grid-item"):
        input(id="fieldSize", placeholder = "3", onkeyup=inputHandler)
      tdiv(class="grid-item"):
        label(`for`="winCount"):
          text "Win count: "
      tdiv(class="grid-item"):
        input(id="winCount", placeholder = "3", onkeyup=inputHandler)
    button(onclick=startGame, class="finish-setup command-buttons"):
      text "start Game"
    

proc playGUI():VNode =
  # choose smaller side as unit to fit field on page
  let unit = if window.innerWidth < window.innerHeight : "vw" else: "vh"
  let buttonStyle = style(
      (StyleAttr.width, kstring(fmt"calc(70{unit}/{game.size})")),
      (StyleAttr.height, kstring(fmt"calc(70{unit}/{game.size})")),
      (StyleAttr.lineHeight, kstring(fmt"calc(70{unit}/{game.size})")),
      (StyleAttr.fontSize, kstring(fmt"calc(70{unit}/{game.size})"))
    )
  buildHtml(tdiv(class = "center")):
    p:
      # show player names and highlight current player
      if state == 2:
        if game.getPlayerName == settings.name1:
          span(style = style((StyleAttr.background,kstring"orange"),(StyleAttr.marginRight,kstring"5px"))):
            text settings.name1
          span(style = style((StyleAttr.background,kstring"none"),(StyleAttr.marginRight,kstring"5px"))):
            text settings.name2
        else:
          span(style = style((StyleAttr.background,kstring"none"),(StyleAttr.marginLeft,kstring"5px"))):
            text settings.name1
          span(style = style((StyleAttr.background,kstring"orange"),(StyleAttr.marginLeft,kstring"5px"))):
            text settings.name2
      else:
        text "Setup game to play"

    if state == 2:
      table:
        for i,line in game.field:
          tr:
            for j,field in line:
              td:
                #create button-grid as field
                button(style = buttonStyle, class = "fieldButton", id=fmt"{i+1}.{j+1}", onclick = clickField,
                disabled = kstring(toDisabled(state==0 or field != 0 or game.finished or fieldBlocked))):
                  text desc[field]
    tdiv(class="command-buttons"):
      button(class = "start"):
        text "setup"
        proc onclick() =
          state = 1 
          settings.setDefault()
      button(class = "reset", id = "reset"):
        text "reset"
        proc onclick() =
          game.setup(settings)


proc createDom(): VNode =
  case state:
    of 1:
      result = setupGUI()
    of 0:
      result = playGUI()
    of 2:
      result = playGUI()
    else:
      discard


setRenderer createDom

