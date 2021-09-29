import UIKit

extension UIViewPropertyAnimator {

  func finishRunningAnimation() {
    guard isRunning else { return }
    stopAnimation(false)
    finishAnimation(at: .end)
  }

  func finishRunningAnimation(completionThreshold threshold: CGFloat) {
    guard isRunning else { return }
    stopAnimation(false)
    finishAnimation(at: fractionComplete >= threshold ? .end : .start)
  }

  func reverseIfCompletionBelow(_ threshold: CGFloat) {
    if fractionComplete < threshold {
      isReversed = true
    }
  }

}
