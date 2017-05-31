//
//  EditViewController.swift
//  Puranas
//
//  Created by Lucky Clover on 5/29/17.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import UIKit
import CircularSpinner

class EditViewController: UIViewController {

    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var lblChapter: UILabel!
    @IBOutlet weak var btnNote: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    var isBookmarkMode : Bool = false
    var curCellData : CellData = CellData()
    var isNavHidden: Bool = false
    var section: Int = 0
    var row: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        if (self.navigationController?.isNavigationBarHidden == true) {
            isNavHidden = true
        }
        self.navigationController?.isNavigationBarHidden = false
        
        txtView.text = curCellData.text
        lblChapter.text = "\(curCellData.chapterNo).\(curCellData.contentId)"
        
        let fixedWidth = txtView.frame.size.width
        txtView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = txtView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        heightConstraint.constant = newSize.height

        initView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        imgStar.addGestureRecognizer(tap)
        
        let tap1 = UISwipeGestureRecognizer(target: self, action: #selector(swipeBack))
        tap1.direction = .right
        self.view.addGestureRecognizer(tap1)
        
        // Do any additional setup after loading the view.
    }
    
    func swipeBack() {
        goBack()
    }
    
    func goBack() {
        if isNavHidden == true {
            self.navigationController?.isNavigationBarHidden = true
        }
        self.navigationController?.popViewController(animated: true)
        bookDataArray[section]?[row] = curCellData
        mainVC?.tableView.reloadData()
    }
    
    func initView() {
        if (curCellData.isBookmarked == 1) {
            if (curCellData.highlightType == "f") {
                imgStar.image = #imageLiteral(resourceName: "bookmarked")
                containerView.backgroundColor = Const.highlightColor
                let range = NSRange(location: 0, length: txtView.attributedText.length)
                let string = NSMutableAttributedString(attributedString: txtView.attributedText)
                let attributes = [NSBackgroundColorAttributeName: Const.highlightColor]
                string.addAttributes(attributes, range: range)
                txtView.attributedText = string
            }
            else if (curCellData.highlightType == "p") {
                imgStar.image = #imageLiteral(resourceName: "bookmarksOnly")
                containerView.backgroundColor = Const.cellBackColor
                let string = NSMutableAttributedString(attributedString: txtView.attributedText)
                for i in 0..<txtView.attributedText.length {
                    let range1 = NSRange(location: i, length: 1)
                    var attributes = [NSBackgroundColorAttributeName: Const.cellBackColor]
                    if (curCellData.highlightData[i] == "1") {
                        attributes = [NSBackgroundColorAttributeName: Const.highlightColor]
                    }
                    string.addAttributes(attributes, range: range1)
                }
                txtView.attributedText = string
            }
        }
        else {
            imgStar.image = #imageLiteral(resourceName: "bookmarksOnly")
            containerView.backgroundColor = Const.cellBackColor
            let range = NSRange(location: 0, length: txtView.attributedText.length)
            let string = NSMutableAttributedString(attributedString: txtView.attributedText)
            let attributes = [NSBackgroundColorAttributeName: Const.cellBackColor]
            string.addAttributes(attributes, range: range)
            txtView.attributedText = string
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackTapped(_ sender: Any) {
        goBack()
    }
    
    func setBookmark() {

        if (txtView.selectedRange.length != 0) {
            let range = txtView.selectedRange
            let db = DBManager()
            curCellData.highlightData = db.insertBookmark(data: curCellData, startPos: range.location, bmlength: range.length, totalLength: txtView.attributedText.length, type: "p")
            
            if curCellData.highlightData.range(of: "1") == nil {
                curCellData.isBookmarked = 0
            }
            else {
                curCellData.isBookmarked = 1
                if curCellData.highlightData.range(of: "0") == nil {
                    curCellData.highlightType = "f"
                }
                else {
                    curCellData.highlightType = "p"
                }
            }
            
            initView()
        }
    }
    
    func tapped() {
        if (curCellData.isBookmarked == 0) {
            imgStar.image = #imageLiteral(resourceName: "bookmarked")
            curCellData.isBookmarked = 1
            curCellData.highlightType = "f"
            
            let db = DBManager()
            db.insertBookmark(data: curCellData, startPos: 0, bmlength: 0, totalLength: txtView.attributedText.length, type: "f")
        }
        else {
            if (curCellData.highlightType == "f") {
                imgStar.image = #imageLiteral(resourceName: "bookmarksOnly")
                curCellData.isBookmarked = 0
                
                let db = DBManager()
                db.deleteBookmark(data: curCellData)
            }
            else if (curCellData.highlightType == "p") {
                imgStar.image = #imageLiteral(resourceName: "bookmarked")
                curCellData.isBookmarked = 1
                curCellData.highlightType = "f"
                
                let db = DBManager()
                db.insertBookmark(data: curCellData, startPos: 0, bmlength: 0, totalLength: txtView.attributedText.length, type: "f")
            }
        }
        initView()
    }
    
    @IBAction func onNoteTapped(_ sender: Any) {
    }
    
    @IBAction func onBookmarkTapped(_ sender: Any) {
        if (isBookmarkMode == false) {
            isBookmarkMode = true
            self.txtView.isSelectable = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.btnNote.alpha = 0.0
                self.btnBack.alpha = 0.0
                self.btnBookmark.setImage(#imageLiteral(resourceName: "save"), for: .normal)
            }, completion: nil)
        }
        else {
            isBookmarkMode = false
            self.txtView.isSelectable = false
            setBookmark()
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.btnNote.alpha = 1.0
                self.btnBack.alpha = 1.0
                self.btnBookmark.setImage(#imageLiteral(resourceName: "currentBook"), for: .normal)
            }, completion: nil)
        }
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
