/// A structure that represents a sliding puzzle.
struct Puzzle {

  let rows: Int
  let columns: Int

  var size: Int { rows * columns }

  private var tiles = [Tile]()

  init(rows: Int, columns: Int) {
    self.rows = rows
    self.columns = columns

    // Create tiles
    for i in 0..<(rows * columns) {
      let tile: Tile
      if i == rows * columns - 1 {
        tile = .empty
      } else {
        tile = .number(i + 1)
      }
      tiles.append(tile)
    }
  }

  subscript(index: Int) -> Tile {
    tiles[index]
  }

  subscript(position: TilePosition) -> Tile {
    get {
      self[position.row, position.column]
    }

    set {
      self[position.row, position.column] = newValue
    }
  }

  subscript(row: RowPosition, column: ColumnPosition) -> Tile {
    get {
      let index = row * columns + column
      return tiles[index]
    }

    set {
      let index = row * columns + column
      tiles[index] = newValue
    }
  }

  mutating func shuffle() {
    tiles.shuffle()
  }

  func position(ofTileNumbered number: Int) -> TilePosition? {
    let tile = Tile.number(number)
    return position(of: tile)
  }

  /// Returns a list of moves required in order to slide a tile.
  mutating func moves(for tile: Tile) -> [TileMove] {
    guard tile != .empty, let tilePosition = position(of: tile) else { return [] }

    let row = puzzleRow(at: tilePosition.row)
    let column = puzzleColumn(at: tilePosition.column)

    if let emptyTileColumn = row.position(of: .empty) {
      return movesForTile(inRow: tilePosition.row, fromColumn: emptyTileColumn, toColumn: tilePosition.column)

    } else if let emptyTileRow = column.position(of: .empty) {
      return movesForTile(inColumn: tilePosition.column, fromRow: emptyTileRow, toRow: tilePosition.row)
    }

    return []
  }

  /// Applies a list of tile moves to the puzzle.
  mutating func commitMoves(_ moves: [TileMove]) {
    moves.forEach { move in
      guard let fromPosition = position(of: move.tile) else {
        print("ERROR: Could not find current position of tile \(move.tile)")
        return
      }

      self[fromPosition] = .empty
      self[move.toPosition] = move.tile
    }
  }

  /// Returns a list of moves to do in order to slide a tile horizontally.
  private func movesForTile(
    inRow row: RowPosition,
    fromColumn: ColumnPosition,
    toColumn: ColumnPosition
  ) -> [TileMove] {
    var moves = [TileMove]()

    let sequence: StrideTo<Puzzle.ColumnPosition>

    if fromColumn < toColumn {
      sequence = stride(from: fromColumn, to: toColumn, by: 1)
    } else {
      sequence = stride(from: fromColumn - 1, to: toColumn - 1, by: -1)
    }

    for column in sequence {
      let swapFromColumn: Int
      let swapToColumn: Int
      let direction: TileMove.Direction

      if fromColumn < toColumn {
        swapFromColumn = column + 1
        swapToColumn = column
        direction = .left
      } else {
        swapFromColumn = column
        swapToColumn = column + 1
        direction = .right
      }

      let tile = self[row, swapFromColumn]
      let move = TileMove(tile: tile, toPosition: .init(row: row, column: swapToColumn), direction: direction)
      moves.append(move)
    }

    return moves
  }

  /// Returns a list of moves to do in order to slide a tile vertically.
  private func movesForTile(inColumn column: ColumnPosition, fromRow: RowPosition, toRow: RowPosition) -> [TileMove] {
    var moves = [TileMove]()

    let sequence: StrideTo<Puzzle.RowPosition>
    if fromRow < toRow {
      sequence = stride(from: fromRow, to: toRow, by: 1)
    } else {
      sequence = stride(from: fromRow - 1, to: toRow - 1, by: -1)
    }

    for row in sequence {
      let swapFromRow: Int
      let swapToRow: Int
      let direction: TileMove.Direction

      if fromRow < toRow {
        swapFromRow = row + 1
        swapToRow = row
        direction = .up
      } else {
        swapFromRow = row
        swapToRow = row + 1
        direction = .down
      }

      let tile = self[swapFromRow, column]
      let move = TileMove(tile: tile, toPosition: .init(row: swapToRow, column: column), direction: direction)
      moves.append(move)
    }

    return moves
  }

  private func indexOfTile(at position: TilePosition) -> Int {
    position.row * rows + position.column
  }

  private func positionOfTile(atIndex index: Int) -> TilePosition {
    TilePosition(
      row: index / columns,
      column: index % columns
    )
  }

  private func position(of tile: Tile) -> TilePosition? {
    guard let index = tiles.firstIndex(where: { tile == $0 }) else { return nil }
    return positionOfTile(atIndex: index)
  }

  private func puzzleRow(at row: RowPosition) -> PuzzleRow {
    PuzzleRow(puzzle: self, position: row)
  }

  private func puzzleColumn(at column: ColumnPosition) -> PuzzleColumn {
    PuzzleColumn(puzzle: self, position: column)
  }

  // MARK: - Types

  typealias RowPosition = Int
  typealias ColumnPosition = Int

  enum Tile: Equatable {
    case empty
    case number(Int)
  }

  struct TilePosition: Equatable {

    let row: RowPosition
    let column: ColumnPosition

  }

  struct TileMove: Equatable {

    let tile: Tile
    let toPosition: TilePosition
    let direction: Direction

    enum Direction {
      case left, right, up, down
    }

  }

}

// MARK: - Equatable

extension Puzzle: Equatable {

  static func == (lhs: Puzzle, rhs: Puzzle) -> Bool {
    guard lhs.size == rhs.size else { return false }
    for i in 0..<lhs.size {
      if lhs.tiles[i] != rhs.tiles[i] { return false }
    }
    return true
  }

}
