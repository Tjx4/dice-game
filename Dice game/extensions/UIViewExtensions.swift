import UIKit

extension UIView{
    func rotate(_ toDegree: Double, _ duration: Double, _ repeatCount: Int) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: toDegree)
        rotation.duration = duration
        rotation.isCumulative = true
        rotation.repeatCount = Float(repeatCount)
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func rotate(_ toDegree: Double, _ duration: Double, _ repeatCount: Int, onCompleteCallback: String) {
       rotate(toDegree, duration, repeatCount)
    }
    
}
