//
//  PopupMenuViewController.swift
//  Puranas
//
//  Created by Lucky Clover on 2017/05/26.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import UIKit

class PopupMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissReadingModePopup(_ mode: Int) {
        mainVC?.btnBack.isEnabled = true
        mainVC?.btnSearch.isEnabled = true
        dismiss(animated: true, completion: nil)
        mainVC?.manageReadingMode(mode)
    }
    
    func dismissNavModePopup(_ mode: Int) {
        mainVC?.btnBack.isEnabled = true
        mainVC?.btnSearch.isEnabled = true
        dismiss(animated: true, completion: nil)
        mainVC?.manageNavMode(mode)
    }
    
    @IBAction func onContAndTrans(_ sender: Any) {
        dismissReadingModePopup(0)
    }
    
    @IBAction func onCont(_ sender: Any) {
        dismissReadingModePopup(1)
    }
    
    @IBAction func onTrans(_ sender: Any) {
        dismissReadingModePopup(2)
    }
    
    @IBAction func onBookmark(_ sender: Any) {
        dismissReadingModePopup(3)
    }

    @IBAction func onPrevChapter(_ sender: Any) {
        dismissNavModePopup(1)
    }
    
    @IBAction func onNextChapter(_ sender: Any) {
        dismissNavModePopup(2)
    }
    
    @IBAction func onBegining(_ sender: Any) {
        dismissNavModePopup(3)
    }
    
    @IBAction func onPrevPos(_ sender: Any) {
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
