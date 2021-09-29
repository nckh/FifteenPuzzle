/// A structure that represents a row of a sliding puzzle.
struct PuzzleRow: Sequence {

  let puzzle: Puzzle
  let position: Puzzle.RowPosition

  func makeIterator() -> Iterator {
    Iterator(puzzleRow: self)
  }

  func position(of tile: Puzzle.Tile) -> Puzzle.ColumnPosition? {
    for (columnPosition, t) in enumerated() {
      if t == tile { return columnPosition }
    }
    return nil
  }

  /// An iterator over the tiles on a puzzle's row.
  struct Iterator: IteratorProtocol {

    private let puzzleRow: PuzzleRow
    private var index = 0

    private var puzzle: Puzzle { puzzleRow.puzzle }

    init(puzzleRow: PuzzleRow) {
      self.puzzleRow = puzzleRow
      index = puzzleRow.position * puzzle.columns
    }

    mutating func next() -> Puzzle.Tile? {
      if index >= (puzzleRow.position + 1) * puzzle.columns { return nil }
      let tile = puzzle[index]
      index += 1
      return tile
    }

  }
}
