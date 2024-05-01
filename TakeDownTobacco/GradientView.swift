//import UIKit
//import SwiftUI
//
//class GradientView: UIView {
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupGradient()
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupGradient()
//    }
//    
//    private func setupGradient() {
//        guard let gradientLayer = layer as? CAGradientLayer else { return }
//        gradientLayer.colors = [UIColor.black.cgColor, UIColor(red: 34/255, green: 17/255, blue: 77/255, alpha: 1.0).cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
//        print("DONEEEEE")
//    }
//}
