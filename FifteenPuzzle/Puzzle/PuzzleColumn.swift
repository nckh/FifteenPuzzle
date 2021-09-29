/// A structure that represents a column of a sliding puzzle.
struct PuzzleColumn: Sequence {

  let puzzle: Puzzle
  let position: Puzzle.ColumnPosition

  func makeIterator() -> Iterator {
    Iterator(puzzleColumn: self)
  }

  func position(of tile: Puzzle.Tile) -> Puzzle.RowPosition? {
    for (rowPosition, t) in enumerated() {
      if t == tile { return rowPosition }
    }
    return nil
  }

  /// An iterator over the tiles on a puzzle's column.
  struct Iterator: IteratorProtocol {

    private let puzzleColumn: PuzzleColumn
    private var index = 0

    private var puzzle: Puzzle { puzzleColumn.puzzle }

    init(puzzleColumn: PuzzleColumn) {
      self.puzzleColumn = puzzleColumn
      index = puzzleColumn.position
    }

    mutating func next() -> Puzzle.Tile? {
      if index >= puzzle.size { return nil }
      let tile = puzzle[index]
      index += puzzle.columns
      return tile
    }

  }
}
