import XCTest
@testable import FifteenPuzzle

class PuzzleTests: XCTestCase {

  private var puzzle: Puzzle!

  override func setUp() {
    puzzle = Puzzle(rows: 3, columns: 4)
  }

  func testSubscript() {
    let tile = puzzle[2, 2]

    XCTAssertEqual(tile, .number(11))
  }

  func testMovesSingleTileRightward() {
    let moves = puzzle.moves(for: .number(11))

    XCTAssertEqual(moves.count, 1)
    guard moves.count == 1 else { return }
    XCTAssertEqual(moves[0].tile, .number(11))
    XCTAssertEqual(moves[0].toPosition, .init(row: 2, column: 3))
    XCTAssertEqual(moves[0].direction, .right)
  }

  func testCommitMovesSingleTileRightward() {
    puzzle.commitMoves([
      .init(tile: .number(11), toPosition: .init(row: 2, column: 3), direction: .right)
    ])

    XCTAssertEqual(puzzle[2, 0], .number(9))
    XCTAssertEqual(puzzle[2, 1], .number(10))
    XCTAssertEqual(puzzle[2, 2], .empty)
    XCTAssertEqual(puzzle[2, 3], .number(11))
  }

  func testMovesMultipleTilesRightward() {
    let moves = puzzle.moves(for: .number(9))

    XCTAssertEqual(moves.count, 3)
    guard moves.count == 3 else { return }
    XCTAssertEqual(moves[0].tile, .number(11))
    XCTAssertEqual(moves[0].toPosition, .init(row: 2, column: 3))
    XCTAssertEqual(moves[0].direction, .right)
    XCTAssertEqual(moves[1].tile, .number(10))
    XCTAssertEqual(moves[1].toPosition, .init(row: 2, column: 2))
    XCTAssertEqual(moves[1].direction, .right)
    XCTAssertEqual(moves[2].tile, .number(9))
    XCTAssertEqual(moves[2].toPosition, .init(row: 2, column: 1))
    XCTAssertEqual(moves[2].direction, .right)
  }

  func testCommitMovesMultipleTilesRightward() {
    puzzle.commitMoves([
      .init(tile: .number(11), toPosition: .init(row: 2, column: 3), direction: .right),
      .init(tile: .number(10), toPosition: .init(row: 2, column: 2), direction: .right),
      .init(tile: .number(9), toPosition: .init(row: 2, column: 1), direction: .right)
    ])

    XCTAssertEqual(puzzle[2, 0], .empty)
    XCTAssertEqual(puzzle[2, 1], .number(9))
    XCTAssertEqual(puzzle[2, 2], .number(10))
    XCTAssertEqual(puzzle[2, 3], .number(11))
  }

  func testMovesSingleTileLeftward() {
    puzzle[2, 0] = .empty
    puzzle[2, 1] = .number(9)
    puzzle[2, 2] = .number(10)
    puzzle[2, 3] = .number(11)

    let moves = puzzle.moves(for: .number(9))

    XCTAssertEqual(moves.count, 1)
    guard moves.count == 1 else { return }
    XCTAssertEqual(moves[0].tile, .number(9))
    XCTAssertEqual(moves[0].toPosition, .init(row: 2, column: 0))
    XCTAssertEqual(moves[0].direction, .left)
  }

  func testCommitMovesSingleTileLeftward() {
    puzzle[2, 0] = .empty
    puzzle[2, 1] = .number(9)
    puzzle[2, 2] = .number(10)
    puzzle[2, 3] = .number(11)

    puzzle.commitMoves([
      .init(tile: .number(9), toPosition: .init(row: 2, column: 0), direction: .left)
    ])

    XCTAssertEqual(puzzle[2, 0], .number(9))
    XCTAssertEqual(puzzle[2, 1], .empty)
    XCTAssertEqual(puzzle[2, 2], .number(10))
    XCTAssertEqual(puzzle[2, 3], .number(11))
  }

  func testMovesMultipleTilesLeftward() {
    puzzle[2, 0] = .empty
    puzzle[2, 1] = .number(9)
    puzzle[2, 2] = .number(10)
    puzzle[2, 3] = .number(11)

    let moves = puzzle.moves(for: .number(11))

    XCTAssertEqual(moves.count, 3)
    guard moves.count == 3 else { return }
    XCTAssertEqual(moves[0].tile, .number(9))
    XCTAssertEqual(moves[1].tile, .number(10))
    XCTAssertEqual(moves[2].tile, .number(11))
    XCTAssertEqual(moves[0].toPosition, .init(row: 2, column: 0))
    XCTAssertEqual(moves[1].toPosition, .init(row: 2, column: 1))
    XCTAssertEqual(moves[2].toPosition, .init(row: 2, column: 2))
    XCTAssertEqual(moves[0].direction, .left)
    XCTAssertEqual(moves[1].direction, .left)
    XCTAssertEqual(moves[2].direction, .left)
  }

  func testCommitMovesMultipleTilesLeftward() {
    puzzle[2, 0] = .empty
    puzzle[2, 1] = .number(9)
    puzzle[2, 2] = .number(10)
    puzzle[2, 3] = .number(11)

    puzzle.commitMoves([
      .init(tile: .number(9), toPosition: .init(row: 2, column: 0), direction: .left),
      .init(tile: .number(10), toPosition: .init(row: 2, column: 1), direction: .left),
      .init(tile: .number(11), toPosition: .init(row: 2, column: 2), direction: .left)
    ])

    XCTAssertEqual(puzzle[2, 0], .number(9))
    XCTAssertEqual(puzzle[2, 1], .number(10))
    XCTAssertEqual(puzzle[2, 2], .number(11))
    XCTAssertEqual(puzzle[2, 3], .empty)
  }

  func testMovesSingleTileDownward() {
    let moves = puzzle.moves(for: .number(8))

    XCTAssertEqual(moves.count, 1)
    guard moves.count == 1 else { return }
    XCTAssertEqual(moves[0].tile, .number(8))
    XCTAssertEqual(moves[0].toPosition, .init(row: 2, column: 3))
    XCTAssertEqual(moves[0].direction, .down)
  }

  func testCommitMovesSingleTileDownward() {
    puzzle.commitMoves([
      .init(tile: .number(8), toPosition: .init(row: 2, column: 3), direction: .down)
    ])

    XCTAssertEqual(puzzle[0, 3], .number(4))
    XCTAssertEqual(puzzle[1, 3], .empty)
    XCTAssertEqual(puzzle[2, 3], .number(8))
  }

  func testMovesMultipleTilesDownward() {
    let moves = puzzle.moves(for: .number(4))

    XCTAssertEqual(moves.count, 2)
    guard moves.count == 2 else { return }
    XCTAssertEqual(moves[0].tile, .number(8))
    XCTAssertEqual(moves[1].tile, .number(4))
    XCTAssertEqual(moves[0].toPosition, .init(row: 2, column: 3))
    XCTAssertEqual(moves[1].toPosition, .init(row: 1, column: 3))
    XCTAssertEqual(moves[0].direction, .down)
    XCTAssertEqual(moves[1].direction, .down)
  }

  func testCommitMovesMultipleTilesDownward() {
    puzzle.commitMoves([
      .init(tile: .number(8), toPosition: .init(row: 2, column: 3), direction: .down),
      .init(tile: .number(4), toPosition: .init(row: 1, column: 3), direction: .down)
    ])

    XCTAssertEqual(puzzle[0, 3], .empty)
    XCTAssertEqual(puzzle[1, 3], .number(4))
    XCTAssertEqual(puzzle[2, 3], .number(8))
  }

  func testMovesSingleTileUpward() {
    puzzle[0, 3] = .empty
    puzzle[1, 3] = .number(4)
    puzzle[2, 3] = .number(8)

    let moves = puzzle.moves(for: .number(4))

    XCTAssertEqual(moves.count, 1)
    guard moves.count == 1 else { return }
    XCTAssertEqual(moves[0].tile, .number(4))
    XCTAssertEqual(moves[0].toPosition, .init(row: 0, column: 3))
    XCTAssertEqual(moves[0].direction, .up)
  }

  func testCommitMovesSingleTileUpward() {
    puzzle[0, 3] = .empty
    puzzle[1, 3] = .number(4)
    puzzle[2, 3] = .number(8)

    puzzle.commitMoves([
      .init(tile: .number(4), toPosition: .init(row: 0, column: 3), direction: .up)
    ])

    XCTAssertEqual(puzzle[0, 3], .number(4))
    XCTAssertEqual(puzzle[1, 3], .empty)
    XCTAssertEqual(puzzle[2, 3], .number(8))
  }

  func testMovesMultipleTilesUpward() {
    puzzle[0, 3] = .empty
    puzzle[1, 3] = .number(4)
    puzzle[2, 3] = .number(8)

    let moves = puzzle.moves(for: .number(8))

    XCTAssertEqual(moves.count, 2)
    guard moves.count == 2 else { return }
    XCTAssertEqual(moves[0].tile, .number(4))
    XCTAssertEqual(moves[1].tile, .number(8))
    XCTAssertEqual(moves[0].toPosition, .init(row: 0, column: 3))
    XCTAssertEqual(moves[1].toPosition, .init(row: 1, column: 3))
    XCTAssertEqual(moves[0].direction, .up)
    XCTAssertEqual(moves[1].direction, .up)
  }

  func testCommitMovesMultipleTilesUpward() {
    puzzle[0, 3] = .empty
    puzzle[1, 3] = .number(4)
    puzzle[2, 3] = .number(8)

    puzzle.commitMoves([
      .init(tile: .number(4), toPosition: .init(row: 0, column: 3), direction: .up),
      .init(tile: .number(8), toPosition: .init(row: 1, column: 3), direction: .up)
    ])

    XCTAssertEqual(puzzle[0, 3], .number(4))
    XCTAssertEqual(puzzle[1, 3], .number(8))
    XCTAssertEqual(puzzle[2, 3], .empty)
  }

  func testMoveUnmovableTile() {
    var puzzleCopy = puzzle!
    let moves = puzzleCopy.moves(for: .number(6))

    XCTAssertTrue(moves.isEmpty)
  }

}
