import UIKit

final class PuzzleView: UIView {

  private var puzzle: Puzzle
  private let tileViews: [TileView]
  private var tileMoveDirection: Puzzle.TileMove.Direction = .right
  private var tapAnimator: UIViewPropertyAnimator?
  private var panAnimator: UIViewPropertyAnimator?

  private let tileAnimationCurve: UIView.AnimationCurve = .easeIn
  private let tileAnimationDuration: TimeInterval = 0.1

  /// After a tile sliding gesture is interrupted, the progress ratio above which the move should be automatically
  /// completed.
  private let commitTileMovesThreshold = 0.5

  private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
    let gestureRecognizer = UITapGestureRecognizer()
    gestureRecognizer.addTarget(self, action: #selector(tap))
    return gestureRecognizer
  }()

  private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
    let gestureRecognizer = UIPanGestureRecognizer()
    gestureRecognizer.addTarget(self, action: #selector(pan))
    return gestureRecognizer
  }()

  init(frame: CGRect, puzzle: Puzzle) {
    self.puzzle = puzzle

    // Create tile views
    var tileViews = [TileView]()
    for index in 0..<(puzzle.size - 1) {
      let tileView = TileView(frame: .zero, number: index + 1)
      tileViews.append(tileView)
    }
    self.tileViews = tileViews

    super.init(frame: frame)

    backgroundColor = .systemGray4

    tileViews.forEach(addSubview)

    addGestureRecognizer(tapGestureRecognizer)
    addGestureRecognizer(panGestureRecognizer)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    reload()
  }

}

extension PuzzleView {

  private var tileSize: CGSize {
    CGSize(
      width: bounds.size.width / CGFloat(puzzle.columns),
      height: bounds.size.height / CGFloat(puzzle.rows)
    )
  }

  func shuffle() {
    puzzle.shuffle()
    reload()
  }

  private func reload() {
    for tileView in tileViews {
      guard let tilePosition = puzzle.position(ofTileNumbered: tileView.number) else { continue }
      tileView.frame.origin = origin(for: tilePosition)
      tileView.frame.size = tileSize
    }
  }

  private func origin(for tilePosition: Puzzle.TilePosition) -> CGPoint {
    CGPoint(
      x: CGFloat(tilePosition.column) * tileSize.width,
      y: CGFloat(tilePosition.row) * tileSize.height
    )
  }

  private func tileView(numbered number: Int) -> TileView {
    tileViews[number - 1]
  }

  private func tile(at point: CGPoint) -> Puzzle.Tile? {
    let row = Int(point.y / tileSize.height)
    let col = Int(point.x / tileSize.width)
    return puzzle[row, col]
  }

  @objc private func tap(_ tapGestureRecognizer: UITapGestureRecognizer) {
    guard tapGestureRecognizer.state == .ended else { return }

    // Don't start if any ongoing pan animation
    guard panAnimator == nil || !panAnimator!.isRunning else { return }

    tapAnimator?.finishRunningAnimation()

    // Stop if no moves to animate
    let tileMoves = tileMoves(for: tapGestureRecognizer)
    guard !tileMoves.isEmpty else { return }

    tapAnimator = makeAnimator(with: tileMoves, interactive: false)
    tapAnimator?.startAnimation()
  }

  @objc private func pan(_ panGestureRecognizer: UIPanGestureRecognizer) {
    switch panGestureRecognizer.state {
    case .began:
      // Finish any ongoing pan animation
      panAnimator?.finishRunningAnimation(completionThreshold: commitTileMovesThreshold)

      // Stop if no moves to animate
      let tileMoves = tileMoves(for: panGestureRecognizer)
      guard let direction = tileMoves.first?.direction else { return }
      tileMoveDirection = direction

      panAnimator = makeAnimator(with: tileMoves, interactive: true)

    case .changed:
      // Play tile moves animation based on gesture translation
      panAnimator?.fractionComplete = animationCompletion(
        gestureRecognizer: panGestureRecognizer,
        direction: tileMoveDirection
      )

    case .ended, .cancelled:
      // Complete animation, forward or backward, depending on where the gesture was interrupted.
      panAnimator?.reverseIfCompletionBelow(commitTileMovesThreshold)
      panAnimator?.continueAnimation(
        withTimingParameters: UICubicTimingParameters(animationCurve: tileAnimationCurve),
        durationFactor: 1 - panAnimator!.fractionComplete
      )

    default: break
    }
  }

  /// The completion ratio of a tile sliding gesture. 0 means the tile is at its original position, 1 means it is
  /// moved to its adjacent position.
  private func animationCompletion(
    gestureRecognizer: UIGestureRecognizer,
    direction: Puzzle.TileMove.Direction
  ) -> CGFloat {
    let translation = panGestureRecognizer.translation(in: self)

    switch direction {
    case .left: return -translation.x / tileSize.width
    case .right: return translation.x / tileSize.width
    case .up: return -translation.y / tileSize.height
    case .down: return translation.y / tileSize.height
    }
  }

  /// A list of tile moves based on the touch location of a gesture.
  private func tileMoves(for gestureRecognizer: UIGestureRecognizer) -> [Puzzle.TileMove] {
    let touchLocation = panGestureRecognizer.location(in: self)
    guard let tile = tile(at: touchLocation) else { return [] }
    return puzzle.moves(for: tile)
  }

  /// An object animating tile moves.
  /// - Parameters:
  ///   - tileMoves: A list of tile moves.
  ///   - interactive: Whether the animation is interactive.
  private func makeAnimator(with tileMoves: [Puzzle.TileMove], interactive: Bool) -> UIViewPropertyAnimator {
    let curve: UIView.AnimationCurve = interactive ? .linear : tileAnimationCurve

    let animator = UIViewPropertyAnimator(duration: tileAnimationDuration, curve: curve) {
      for move in tileMoves {
        guard case let .number(tileNumber) = move.tile else { continue }

        let tileView = self.tileView(numbered: tileNumber)
        let toOrigin = self.origin(for: move.toPosition)
        tileView.frame.origin = toOrigin
      }
    }

    // Commit model changes after animation completes
    animator.addCompletion { [weak self] position in
      guard position == .end else { return }
      self?.puzzle.commitMoves(tileMoves)
    }

    return animator
  }

}
