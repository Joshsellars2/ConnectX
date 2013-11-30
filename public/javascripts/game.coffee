class Cell
   constructor: (@row, @col) ->
      @player = null

class Board
   constructor: (rowCount, colCount) ->
      @nextPlayer = 1
      @rowCount = rowCount
      @colCount = colCount
      @playerColor = [0, 0x00FF00, 0xFF0000]
      @cells = for row in [0...rowCount]
         for col in [0...colCount]
            new Cell(row, col)
      

board = new Board(6,7)
board.cells[0][3].player = 1
board.cells[1][3].player = 2

width = 40
height = 40
rate = 5

# create an new instance of a pixi stage
stage = new PIXI.Stage 0xc0c0c0, true 

stage.setInteractive true 

#sprite=  PIXI.Sprite.fromImage "spinObj_02.png" 
#stage.addChild sprite 
# create a renderer instance
#renderer = new PIXI.CanvasRenderer 800, 600 #PIXI.autoDetectRenderer 800, 600 
renderer = PIXI.autoDetectRenderer 620, 380 

# set the canvas width and height to fill the screen
#renderer.view.style.width = window.innerWidth + "px"
#renderer.view.style.height = window.innerHeight + "px"
renderer.view.style.display = "block"
 
# add render view to DOM
document.body.appendChild renderer.view 

graphics = new PIXI.Graphics()
   
stage.addChild graphics 

# lets create moving shape
thing = new PIXI.Graphics()
stage.addChild thing 
thing.position.x = 0
thing.position.y = 0

count = 0

stage.click = stage.tap = (e)->
   if board.checkerMotion then return
   relPoint = e.getLocalPosition(graphics)
   col = getColumn relPoint.x
   row = getNextAvailableRow col
   if row < 0 then return
   board.checkerMotion = {col: col, y: 0, row: row, rate:1}

getColumn = (x) ->
   if x < 0
      -1
   else
      col = x / width
      if col < board.colCount
         Math.floor col
      else
         -1

getNextAvailableRow = (col) ->
   if col >= 0
      for r in [0...board.rowCount]
         if board.cells[r][col].player
            continue
         return r
   return -1

getOtherPlayer = (player) ->
   if player == 1
      2
   else
      1

animate = ->
   
   thing.clear()
   thing.lineStyle 3, 0xff0000, 1 
   thing.beginFill 0xffFF00, 0.5 

   getRowTop = (row) ->
      height * board.rowCount - height * (row - 1)

   getRowBottom = (row) ->
      height * board.rowCount - height * row

   getColLeft = (col) ->
      width * col

   getColRight = (col) ->
      width * (col + 1)

   updateCheckerMotion = ->
      cm = board.checkerMotion
      if cm
         finalY = (getRowBottom(cm.row) + getRowTop(cm.row)) / 2
         if cm.y >= finalY
            board.cells[cm.row][cm.col].player = board.nextPlayer
            board.nextPlayer = getOtherPlayer board.nextPlayer
            board.checkerMotion = null
         else
            cm.y += cm.rate
            cm.rate++

   drawGrid = ->
      for row in [0...board.rowCount]
         rowYTop = getRowTop(row)
         rowYBottom = getRowBottom(row)
         thing.lineStyle 3, 0xff0000, 1 
         thing.moveTo getColLeft(0), rowYTop
         thing.lineTo getColRight(board.colCount - 1), rowYTop
         thing.lineStyle 2, 0x0000ff, 1 
         thing.moveTo getColLeft(0), rowYBottom
         thing.lineTo getColRight(board.colCount - 1), rowYBottom
      for col in [0...board.colCount]
         colXLeft = getColLeft col
         colXRight = getColRight col
         thing.lineStyle 2, 0x00FFff, 1 
         thing.moveTo colXLeft, getRowTop(0)
         thing.lineTo colXLeft, getRowBottom(board.rowCount - 1)
         thing.lineStyle 1, 0x00FF00, 1 
         thing.moveTo colXRight, getRowTop(0)
         thing.lineTo colXRight, getRowBottom(board.rowCount - 1)

   drawCheckerMotion = ->
      if board.checkerMotion
         drawChecker board.nextPlayer, getColLeft(board.checkerMotion.col) + width /2, board.checkerMotion.y

   drawCheckers = ->
      for row in [0...board.rowCount]
         for col in [0...board.colCount]
            cell = board.cells[row][col]
            if cell.player > 0
               rowYTop = getRowTop(row)
               rowYBottom = getRowBottom(row)
               colXLeft = getColLeft(col)
               colXRight = getColRight(col)
               centerX = (colXLeft + colXRight) / 2
               centerY = (rowYTop + rowYBottom) / 2
               drawChecker cell.player, centerX, centerY

   drawCheckerMotion = ->
      if board.checkerMotion
         drawChecker board.nextPlayer, getColLeft(board.checkerMotion.col) + width /2, board.checkerMotion.y

   drawChecker = (playerNumber, centerX, centerY) ->
               thing.lineStyle 2, 0x000000, 1 
               thing.beginFill board.playerColor[playerNumber], 1.0 
               thing.drawCircle centerX, centerY, width / 3

   drawNextPlayer = ->
      centerX = 50
      centerY = getRowBottom(0) + 80
      thing.lineStyle 2, 0x000000, 1

      thing.beginFill board.playerColor[board.nextPlayer], 0.5 
      thing.drawCircle centerX, centerY, width / 3

   updateCheckerMotion()
   drawGrid()
   drawCheckers()
   drawNextPlayer()
   drawCheckerMotion()

   thing.moveTo -120 + Math.sin count  * 20, -100 + Math.cos count * 20 
   
   thing.rotation = count * 0.1
   renderer.render stage 
   requestAnimFrame  animate  

requestAnimFrame animate 

