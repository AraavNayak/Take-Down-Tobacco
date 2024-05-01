import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    
    @IBOutlet weak var chooseHealthHeader: UILabel!
    @IBOutlet weak var ditchTobaccoHeader: UILabel!
    @IBOutlet weak var takeDownTobaccoHeader: UILabel!
    @IBOutlet weak var plantIcon: UIImageView!
    @IBOutlet weak var beginBtn: UIButton!
    var appLaunched = false
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var arrowDown: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        
        setupGradientView()
        beginBtn.layer.cornerRadius = 20
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                // Permission granted
            } else {
                // Permission denied
            }
        }
        
        
        if(!appLaunched) {
            chooseHealthHeader.alpha = 0
            //ditchTobaccoHeader.alpha = 0
            takeDownTobaccoHeader.alpha = 0
            plantIcon.alpha = 0
            beginBtn.alpha = 0
            
            ditchTobaccoHeader.center.x = -50
            
            UIView.animate(withDuration: 1.5, animations: {
                self.chooseHealthHeader.alpha = 1
                // Gradually decrease the alpha to make it clearer
            })
            UIView.animate(withDuration: 2, animations: {
                self.ditchTobaccoHeader.center.x = 100
            })
            
            UIView.animate(withDuration: 2.5, animations: {
                self.takeDownTobaccoHeader.alpha = 1
            })
            
            UIView.animate(withDuration: 3, animations: {
                self.plantIcon.alpha = 1
                self.beginBtn.alpha = 1
            })
            appLaunched = true
            
            startBlink()
        }
    }
    
    func showBadgeNotification(badgeName: String) {
        let content = UNMutableNotificationContent()
        content.title = "Congratulations!"
        content.body = "You've earned the \(badgeName) badge."
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: "badgeNotification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    private func setupGradientView() {
        let gradientView = GradientView(frame: view.bounds)
        let gradientView2 = InvGradientView(frame: view.bounds)
        topView.addSubview(gradientView)
        topView.sendSubviewToBack(gradientView)
        
        bottomView.addSubview(gradientView2)
        bottomView.sendSubviewToBack(gradientView2)
    }
    
    @IBAction func beginBtnClicked(_ sender: Any) {
        print("hi???")
        self.showBadgeNotification(badgeName: "Start")
        self.tabBarController?.selectedIndex = 2
//        guard let nextViewController = storyboard?.instantiateViewController(withIdentifier: "ShowNextScreen") as? ProgressVC else {
//            return
//        }
//        guard let tabBarController = tabBarController else {
//            return
//        }
//        var viewControllers = tabBarController.viewControllers
//        viewControllers?[2] = nextViewController // Replace selectedIndex with the index of the tab you want to replace
//        tabBarController.setViewControllers(viewControllers, animated: true)
//        performSegue(withIdentifier: "ShowNextScreen", sender: nil)
//        guard let nextViewController = storyboard?.instantiateViewController(withIdentifier: "ShowNextScreen") as? ProgressVC else {
//            return
//        }
//        present(nextViewController, animated: true, completion: nil)
    }
    
    func startBlink() {
        UIView.animate(withDuration: 1,//Time duration
                       delay:0.5,
                       options:[.allowUserInteraction, .curveEaseInOut,    .autoreverse, .repeat],
                       animations: {
            
            UIView.setAnimationRepeatCount(5) // repeat 30 times.
            self.arrowDown.alpha = 0
        }, completion: nil)
    }
    
    
    private func createBlurMask(blurredLabel: UILabel) -> CALayer {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurredLabel.bounds
        let maskLayer = blurEffectView.layer
        maskLayer.masksToBounds = true
        return maskLayer
    }
    
    
    private func applyBlurEffect() {
        guard case let plantIcon.image = plantIcon.image else { return }
        let context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: plantIcon.image!)
        currentFilter?.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter?.setValue(10, forKey: kCIInputRadiusKey)
        if let output = currentFilter?.outputImage,
           let cgimg = context.createCGImage(output, from: output.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            plantIcon.image = processedImage
        }
    }
    
}

class GradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    private func setupGradient() {
        guard let gradientLayer = layer as? CAGradientLayer else {
            fatalError("Unable to access gradient layer")
        }
        gradientLayer.colors = [UIColor.black.cgColor, UIColor(red: 34/255, green: 17/255, blue: 77/255, alpha: 1.0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    }
    
}


class InvGradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    private func setupGradient() {
        guard let gradientLayer = layer as? CAGradientLayer else {
            fatalError("Unable to access gradient layer")
        }
        gradientLayer.colors = [UIColor(red: 26/255, green: 13/255, blue: 58/255, alpha: 1.0).cgColor, UIColor.black.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    }
    
   
}
