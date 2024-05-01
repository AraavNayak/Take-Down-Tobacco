//
//  StatsVC.swift
//  TakeDownTobacco
//
//  Created by Araav Nayak on 4/20/24.
//

import UIKit
import SwiftUI

class StatsVC: UIViewController, UIPopoverPresentationControllerDelegate {

    
    @IBOutlet weak var numDeathsStatistic: UILabel!
    @IBOutlet weak var lungCancerStatistic: UILabel!
    @IBOutlet weak var impactOnBloodVesselStatistic: UILabel!
    @IBOutlet weak var increasedLungCancerStatistic: UILabel!
    var screenDisplayed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientView()
        
        
        if !screenDisplayed {
            screenDisplayed = true
            numDeathsStatistic.center.x = -100
            lungCancerStatistic.center.x = -200
            impactOnBloodVesselStatistic.center.x = -300
            increasedLungCancerStatistic.center.x = -400
        }

        UIView.animate(withDuration: 2, animations: {
            self.numDeathsStatistic.center.x = 200
        })
        
        UIView.animate(withDuration: 4, animations: {
            self.lungCancerStatistic.center.x = 200
        })
        
        UIView.animate(withDuration: 5, animations: {
            self.impactOnBloodVesselStatistic.center.x = 200
        })
        
        UIView.animate(withDuration: 6, animations: {
            self.increasedLungCancerStatistic.center.x = 200
        })
        // Do any additional setup after loading the view.
    }
    
    private func setupGradientView() {
        let gradientView = GradientViewI(frame: view.bounds)
        view.addSubview(gradientView)
        view.sendSubviewToBack(gradientView)
    }
    

    @IBAction func quizBtnClicked(_ sender: Any) {
        //NOTE: USING SHOW SEGUE, make a new view pop up.
        // - will display a (randomly selected) MCQ quiz question
        // - and have 4 chooices/answers which the user can click
        // - and a button at the bottom saying grade/submit/whatev
        // - once the button is clicked, use red/green highlighting to display the correct answer
        // - OOOH AND HAVE THE ARROW GO BACK BUTTON THING TO THE MAIN VIEW
        
        
        
        // Create a UIHostingController with the QuestionView
        let contentView = QuestionView(question: "How many many deaths due to cardiovascular diseases (eg. heart attack, stroke) are caused directly by tobacco usage each year?", answers: ["2,000", "575,000", "1,000,000", "3,000,000"], vc: self)
        let hostingController = UIHostingController(rootView: contentView)
        
        hostingController.modalPresentationStyle = .popover
        
        hostingController.popoverPresentationController?.delegate = self
        
        present(hostingController, animated: true, completion: nil)
        
        // Set the size of the popover
        hostingController.preferredContentSize = CGSize(width: 300, height: 300)
        
        // Set the source view and source rect for the popover
        hostingController.popoverPresentationController?.sourceView = view
        hostingController.popoverPresentationController?.sourceRect = view.bounds

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}

class GradientViewI: UIView {
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
