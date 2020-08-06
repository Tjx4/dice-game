import UIKit

extension UIView{
    func rotate(_ vc: UIViewController, _ toDegree: Double, _ duration: Double, _ repeatCount: Int) {
        let rotation :CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: toDegree)
        //rotation.fromValue = NSNumber(value: 0)
        rotation.duration = duration
        rotation.isCumulative = true
        rotation.repeatCount = Float(repeatCount)
        var animationDelegate = vc as? CAAnimationDelegate
        rotation.delegate = animationDelegate
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    
    /*
        func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
            print("Well it works...")
        }
    */
    
    func fadeOut() {
        let fadeOutAnimation = CABasicAnimation()
        fadeOutAnimation.keyPath = "opacity"
        fadeOutAnimation.fromValue = 1
        fadeOutAnimation.toValue = 0
        fadeOutAnimation.duration = 0.25
        
        fadeOutAnimation.delegate = self as! CAAnimationDelegate
        
        // sublayer.add(fadeOutAnimation, forKey: "fade")
    }

    
}
