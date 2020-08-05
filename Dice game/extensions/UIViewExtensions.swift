import UIKit

extension UIView{
    func rotate(_ toDegree: Double, _ repeatCount: Int) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: toDegree)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float(repeatCount)
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
