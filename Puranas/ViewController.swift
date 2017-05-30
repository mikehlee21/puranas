//
//  ViewController.swift
//  Puranas
//
//  Created by Lucky Clover on 5/23/17.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import UIKit
import EAIntroView

class ViewController: UIViewController , EAIntroDelegate{

    @IBOutlet weak var introView: EAIntroView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let page1 = EAIntroPage()
        page1.desc = "Browse through series of books"
        page1.descFont = UIFont(name: "Mallanna", size: 25)
        page1.descPositionY = 180
        page1.titleIconView = UIImageView(image: #imageLiteral(resourceName: "tutor1"))
        page1.titleIconView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 150, height: self.view.frame.height - 250)
        page1.titleIconPositionY = 50
        
        let page2 = EAIntroPage()
        page2.desc = "Browse through the books in the series selected"
        page2.descFont = UIFont(name: "Mallanna", size: 25)
        page2.descPositionY = 180
        page2.titleIconView = UIImageView(image: #imageLiteral(resourceName: "tutor2"))
        page2.titleIconView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 150, height: self.view.frame.height - 250)
        page2.titleIconPositionY = 50
        
        let page3 = EAIntroPage()
        page3.desc = "The reading experience"
        page3.descFont = UIFont(name: "Mallanna", size: 25)
        page3.descPositionY = 180
        page3.titleIconView = UIImageView(image: #imageLiteral(resourceName: "tutor3"))
        page3.titleIconView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 150, height: self.view.frame.height - 250)
        page3.titleIconPositionY = 50
        
        let page4 = EAIntroPage()
        page4.desc = "How to highlight and bookmark content?"
        page4.descFont = UIFont(name: "Mallanna", size: 25)
        page4.descPositionY = 180
        page4.titleIconView = UIImageView(image: #imageLiteral(resourceName: "tutor4"))
        page4.titleIconView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 150, height: self.view.frame.height - 250)
        page4.titleIconPositionY = 50
        
        introView.pageControlY = 110
        introView.pages = [page1, page2, page3, page4]
        
        introView.delegate = self
        
        introView.skipButton = UIButton()
        introView.skipButton.setImage(#imageLiteral(resourceName: "save1"), for: .normal)
        introView.skipButton.frame = CGRect(x: introView.skipButton.frame.origin.x, y: introView.skipButton.frame.origin.y, width: introView.skipButton.frame.width / 2, height: introView.skipButton.frame.height / 2)
        introView.skipButtonAlignment = .center
        introView.skipButtonY = 50
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.configureUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

