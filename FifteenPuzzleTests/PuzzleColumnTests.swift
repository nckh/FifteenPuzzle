import XCTest
@testable import FifteenPuzzle

class PuzzleColumnTests: XCTestCase {

  private var puzzleColumn: PuzzleColumn!

  override func setUp() {
    let puzzle = Puzzle(rows: 3, columns: 4)
    puzzleColumn = PuzzleColumn(puzzle: puzzle, position: 1)
  }

  func testIterator() throws {
    var iterator = puzzleColumn.makeIterator()

    XCTAssertEqual(iterator.next(), .number(2))
    XCTAssertEqual(iterator.next(), .number(6))
    XCTAssertEqual(iterator.next(), .number(10))
    XCTAssertNil(iterator.next())
  }

}
