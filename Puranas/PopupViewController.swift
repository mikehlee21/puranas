//
//  PopupViewController.swift
//  Puranas
//
//  Created by Lucky Clover on 5/24/17.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import UIKit
import MIBlurPopup

class PopupViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var popupMainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //popupMainView.layer.cornerRadius = 10
        //contentView.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func onDismiss(_ sender: Any) {
        
        mainVC?.btnBack.isEnabled = true
        mainVC?.btnBookmark.isEnabled = true
        
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension PopupViewController: MIBlurPopupDelegate {
    
    var popupView: UIView {
        return contentView ?? UIView()
    }
    var blurEffectStyle: UIBlurEffectStyle {
        return .light
    }
    var initialScaleAmmount: CGFloat {
        return 0.5
    }
    var animationDuration: TimeInterval {
        return 0.5
    }
    
}
