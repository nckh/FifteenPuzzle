import UIKit

final class TileView: UIView {

  let number: Int
  private let label: UILabel

  init(frame: CGRect, number: Int) {
    self.number = number
    label = UILabel(frame: .zero)

    super.init(frame: frame)

    backgroundColor = .systemPurple
    layer.borderColor = UIColor.black.cgColor
    layer.borderWidth = 2

    label.text = "\(number)"
    label.center = center
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
    label.sizeToFit()
    label.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]

    addSubview(label)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
