import XCTest
@testable import FifteenPuzzle

class PuzzleRowTests: XCTestCase {

  private var puzzleRow: PuzzleRow!

  override func setUp() {
    let puzzle = Puzzle(rows: 3, columns: 4)
    puzzleRow = PuzzleRow(puzzle: puzzle, position: 1)
  }

  func testIterator() throws {
    var iterator = puzzleRow.makeIterator()

    XCTAssertEqual(iterator.next(), .number(5))
    XCTAssertEqual(iterator.next(), .number(6))
    XCTAssertEqual(iterator.next(), .number(7))
    XCTAssertEqual(iterator.next(), .number(8))
    XCTAssertNil(iterator.next())
  }

}
