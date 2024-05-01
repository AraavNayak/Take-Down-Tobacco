//
//  ProgressVC.swift
//  TakeDownTobacco
//
//  Created by Araav Nayak on 4/30/24.
//

import UIKit

class ProgressVC: UIViewController {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var firstDayTobaccoFree: UIImageView!
    @IBOutlet weak var firstWeekTobaccoFree: UIImageView!
    @IBOutlet weak var firstMonthTobaccoFree: UIImageView!
    @IBOutlet weak var tobaccoFreeYear: UIImageView!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        setupGradientView()
        
        dayLabel.text = "x 8"
        weekLabel.text = "x 1"
        firstMonthTobaccoFree.alpha = 0.2
        tobaccoFreeYear.alpha = 0.2
        
        // Do any additional setup after loading the view.
        let number = 8 //Int.random(in: 6...15)
        animateNumber(to: number, on: numberLabel)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowNextScreen" {
            // No data to pass, simply perform the segue
        }
    }
    

    private func setupGradientView() {
        let gradientView = GradientViewIV(frame: view.bounds)
        view.addSubview(gradientView)
        view.sendSubviewToBack(gradientView)
    }
    
    func animateNumber(to endValue: Int, on myLabel: UILabel) {
        let duration: Double = 0.5
        DispatchQueue.global().async {
            for i in 0..<(endValue + 1) {
                let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                usleep(sleepTime)
                DispatchQueue.main.async {
                    myLabel.text = "\(i)"
                }
            }
        }
    }
}


class GradientViewIV: UIView {
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

