import UIKit

class ViewController: UIViewController {

  private var puzzle: Puzzle!
  private var puzzleView: PuzzleView!

  override func viewDidLoad() {
    super.viewDidLoad()

    puzzle = Puzzle(rows: 4, columns: 4)

    puzzleView = PuzzleView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 300)), puzzle: puzzle)
    puzzleView.center = view.center
    puzzleView.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]

    view.addSubview(puzzleView)
  }

  @IBAction private func shuffle() {
    puzzleView.shuffle()
  }

}
