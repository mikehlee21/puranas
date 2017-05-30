//
//  PopupMenuViewController.swift
//  Puranas
//
//  Created by Lucky Clover on 2017/05/26.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import UIKit
import CircularSpinner

class PopupMenuViewController: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.borderColor = UIColor(red: 200.0 / 255.0, green: 150.0 / 255.0, blue: 50.0 / 255.0, alpha: 1.0).cgColor
        backView.layer.borderWidth = 3.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissReadingModePopup(_ mode: Int) {
        self.parent?.dismiss(animated: true, completion: { 
            mainVC?.btnBack.isEnabled = true
            if mode != mainVC?.readingMode {
                mainVC?.manageReadingMode(mode)
            }
        })
    }
    
    func dismissNavModePopup(_ mode: Int) {
        mainVC?.btnBack.isEnabled = true
        dismiss(animated: true, completion: nil)
        mainVC?.manageNavMode(mode)
    }
    
    @IBAction func onCont(_ sender: Any) {
        dismissReadingModePopup(1)
    }
    
    @IBAction func onTrans(_ sender: Any) {
        dismissReadingModePopup(2)
    }
    
    @IBAction func onContAndTrans(_ sender: Any) {
        dismissReadingModePopup(0)
    }
    
    @IBAction func onBookmark(_ sender: Any) {
        dismissReadingModePopup(3)
    }
    
    @IBAction func onFirstChapter(_ sender: Any) {
        dismissNavModePopup(3)
    }
    
    @IBAction func onPrevChapter(_ sender: Any) {
        dismissNavModePopup(1)
    }
    
    @IBAction func onCurrent(_ sender: Any) {
        dismissNavModePopup(5)
    }
    
    @IBAction func onNextChapter(_ sender: Any) {
        dismissNavModePopup(2)
    }
    
    @IBAction func onLastChapter(_ sender: Any) {
        dismissNavModePopup(4)
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
