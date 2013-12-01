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
    isWinHorizontallyAtCell: (player, row, col, numberThatMustMatch) =>
        @isAtCellAndRelativeCell(player, row, col, 0, 1, numberThatMustMatch)
    isAtCellAndTheCellAbove: (player, row, col, numberThatMustMatch) =>
        @isAtCellAndRelativeCell(player, row, col, 1, 0, numberThatMustMatch)
    isAtCellAndTheCellAboveRight: (player, row, col, numberThatMustMatch) =>
        @isAtCellAndRelativeCell(player, row, col, 1, 1, numberThatMustMatch)
    isWinDiagonallyDown: (player, row, col, numberThatMustMatch) =>
        @isAtCellAndRelativeCell(player, row, col, 1, -1, numberThatMustMatch)
    isAtCellAndRelativeCell: (player, row, col, offsetRow, offsetCol, numberThatMustMatch) =>
        for factor in [0...numberThatMustMatch]
            unless @isPlayerInCell(player, row + offsetRow * factor, col + offsetCol * factor)
                return false
        true
    isPlayerWinner: (player, numberThatMustMatch) ->
        for row in [0...@rowCount]
            for col in [0...@colCount]
                if @isWinHorizontallyAtCell(player, row, col, numberThatMustMatch) or @isAtCellAndTheCellAbove(player, row, col, numberThatMustMatch) or @isAtCellAndTheCellAboveRight(player, row, col, numberThatMustMatch) or @isWinDiagonallyDown(player, row, col, numberThatMustMatch)
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
        assertAreEqual false, board.isWinHorizontallyAtCell(2, 0, 0, 2)
    testIsTwoHorizontally: ->
        board = new Board(3,3)
        board.cells[0][0].player = 2
        board.cells[0][1].player = 2
        assertAreEqual true, board.isWinHorizontallyAtCell(2, 0, 0, 2)
    testIsTwoHorizontally2: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[1][2].player = 1
        assertAreEqual true, board.isWinHorizontallyAtCell(1, 1, 1, 2)
    testIsTwoHorizontally2: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[1][2].player = 1
        assertAreEqual false, board.isWinHorizontallyAtCell(2, 1, 1, 2)
    testIsTwoHorizontallyAtLastCol: ->
        board = new Board(3,3)
        board.cells[1][2].player = 2
        assertAreEqual false, board.isWinHorizontallyAtCell(2, 1, 2, 2)
    testIsTwoVertically: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][1].player = 1
        assertAreEqual true, board.isAtCellAndTheCellAbove(1, 1, 1, 2)
    testIsTwoVertically2: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][1].player = 1
        assertAreEqual false, board.isAtCellAndTheCellAbove(2, 1, 1, 2)
    testIsTwoDiagonalUp: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][2].player = 1
        assertAreEqual true, board.isAtCellAndTheCellAboveRight(1, 1, 1, 2)
    testIsTwoDiagonalUp2: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][2].player = 1
        assertAreEqual false, board.isAtCellAndTheCellAboveRight(2, 1, 1, 2)
    testIsTwoBelowRight: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][0].player = 1
        assertAreEqual true, board.isWinDiagonallyDown(1, 1, 1, 2)
    testIsTwoBelowRight2: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][0].player = 1
        assertAreEqual false, board.isWinDiagonallyDown(2, 1, 1, 2)

    testIsPlayerWinnerHorizontally2: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[1][0].player = 1
        assertAreEqual false, board.isPlayerWinner(2, 2)
    testIsPlayerWinnerHorizontally1: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[1][0].player = 1
        assertAreEqual true, board.isPlayerWinner(1, 2)
    testIsPlayerWinnerVertically2: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][1].player = 1
        assertAreEqual false, board.isPlayerWinner(2, 2)
    testIsPlayerWinnerVertically1: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][1].player = 1
        assertAreEqual true, board.isPlayerWinner(1, 2)
    testIsPlayerWinnerDiagonalUp2: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][2].player = 1
        assertAreEqual false, board.isPlayerWinner(2, 2)
    testIsPlayerWinnerDiagonalUp1: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][2].player = 1
        assertAreEqual true, board.isPlayerWinner(1, 2)
    testIsPlayerWinnerDiagonalDown2: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][0].player = 1
        assertAreEqual false, board.isPlayerWinner(2, 2)
    testIsPlayerWinnerDiagonalDown1: ->
        board = new Board(3,3)
        board.cells[1][1].player = 1
        board.cells[2][0].player = 1
        assertAreEqual true, board.isPlayerWinner(1, 2)

    testIsPlayerWinnerWhenItTakes3: ->
        board = new Board(3,3)
        board.cells[2][0].player = 1
        board.cells[1][0].player = 1
        board.cells[0][0].player = 1
        board.cells[2][1].player = 2
        board.cells[1][1].player = 2
        board.cells[0][1].player = 2
        assertAreEqual true, board.isPlayerWinner(1, 3)

for name,f of tests
    console.log '====================================================='
    console.log 'Running test ' + name
    f()
    console.log '====================================================='

console.log 'pass count: ' + passCount
console.log 'fail count: ' + failCount

if failCount == 0
    console.log 'All tests passed'
