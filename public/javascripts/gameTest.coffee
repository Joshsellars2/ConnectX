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

    isPlayerInCell: (player, row, col) =>
        if col >= @colCount or row >= @rowCount then return false
        @cells[row][col].player == player
    isAtCellAndTheCellToTheRight: (player, row, col) =>
        @isPlayerInCell(player, row, col) and @isPlayerInCell(player, row + 0, col + 1)
    isAtCellAndTheCellAbove: (player, row, col) =>
        @isPlayerInCell(player, row, col) and @isPlayerInCell(player, row + 1, col + 0)
    isAtCellAndTheCellAboveRight: (player, row, col) =>
        @isPlayerInCell(player, row, col) and @isPlayerInCell(player, row + 1, col + 1)
    isAtCellAndTheCellBelowRight: (player, row, col) =>
        @isPlayerInCell(player, row, col) and @isPlayerInCell(player, row + 1, col - 1)

    isPlayerWinner: (player) ->
        for row in [0...@rowCount]
            for col in [0...@colCount]
                if @isAtCellAndTheCellToTheRight(player, row, col) or @isAtCellAndTheCellAbove(player, row, col) or @isAtCellAndTheCellAboveRight(player, row, col) or @isAtCellAndTheCellBelowRight(player, row, col)
                    return true
        return false

passCount = 0
failCount = 0
assertAreEqual = (expected, actual) ->
    console.log 'expected: ' + expected
    console.log 'actual: ' + actual
    if expected == actual
        passCount = passCount + 1
        console.log 'pass!'
    else
        failCount = failCount + 1
        console.log 'FAIL *********'

tests =
    testIsPlayerInCellInBlankBoard: ->
        board = new Board(3,3)
        assertAreEqual false, board.isPlayerInCell(1, 0, 0)
    testIsPlayerInCell: ->
        board = new Board(3,3)
        board.cells[0][0].player = 1
        assertAreEqual true, board.isPlayerInCell(1, 0, 0)
    testIsPlayer2InCell: ->
        board = new Board(3,3)
        board.cells[0][0].player = 2
        assertAreEqual true, board.isPlayerInCell(2, 0, 0)
    testIsTwoHorizontallyOnEmptyBoard: ->
        board = new Board(3,3)
        assertAreEqual false, board.isAtCellAndTheCellToTheRight(2, 0, 0)
    testIsTwoHorizontally: ->
        board = new Board(3,3)
        board.cells[0][0].player = 2
        board.cells[0][1].player = 2
        assertAreEqual true, board.isAtCellAndTheCellToTheRight(2, 0, 0)
    testIsTwoHorizontally2: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[1][2].player = 1
        assertAreEqual true, board.isAtCellAndTheCellToTheRight(1, 1, 1)
    testIsTwoHorizontally2: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[1][2].player = 1
        assertAreEqual false, board.isAtCellAndTheCellToTheRight(2, 1, 1)
    testIsTwoHorizontallyAtLastCol: ->
        board = new Board(3,3)
        board.cells[1][2].player = 2
        assertAreEqual false, board.isAtCellAndTheCellToTheRight(2, 1, 2)
    testIsTwoVertically: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][1].player = 1
        assertAreEqual true, board.isAtCellAndTheCellAbove(1, 1, 1)
    testIsTwoVertically2: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][1].player = 1
        assertAreEqual false, board.isAtCellAndTheCellAbove(2, 1, 1)
    testIsTwoDiagonalUp: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][2].player = 1
        assertAreEqual true, board.isAtCellAndTheCellAboveRight(1, 1, 1)
    testIsTwoDiagonalUp2: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][2].player = 1
        assertAreEqual false, board.isAtCellAndTheCellAboveRight(2, 1, 1)
    testIsTwoBelowRight: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][0].player = 1
        assertAreEqual true, board.isAtCellAndTheCellBelowRight(1, 1, 1)
    testIsTwoBelowRight2: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][0].player = 1
        assertAreEqual false, board.isAtCellAndTheCellBelowRight(2, 1, 1)

    testIsPlayerWinnerHorizontally2: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[1][0].player = 1
        assertAreEqual false, board.isPlayerWinner(2)
    testIsPlayerWinnerHorizontally1: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[1][0].player = 1
        assertAreEqual true, board.isPlayerWinner(1)
    testIsPlayerWinnerVertically2: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][1].player = 1
        assertAreEqual false, board.isPlayerWinner(2)
    testIsPlayerWinnerVertically1: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][1].player = 1
        assertAreEqual true, board.isPlayerWinner(1)
    testIsPlayerWinnerDiagonalUp2: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][2].player = 1
        assertAreEqual false, board.isPlayerWinner(2)
    testIsPlayerWinnerDiagonalUp1: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][2].player = 1
        assertAreEqual true, board.isPlayerWinner(1)
    testIsPlayerWinnerDiagonalDown2: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][0].player = 1
        assertAreEqual false, board.isPlayerWinner(2)
    testIsPlayerWinnerDiagonalDown1: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][0].player = 1
        assertAreEqual true, board.isPlayerWinner(1)

for name,f of tests
    console.log '====================================================='
    console.log 'Running test ' + name
    f()
    console.log '====================================================='

console.log 'pass count: ' + passCount
console.log 'fail count: ' + failCount

if failCount == 0
    console.log 'All tests passed'
