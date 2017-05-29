//
//  EditViewController.swift
//  Puranas
//
//  Created by Lucky Clover on 5/29/17.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet weak var btnNote: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtView: UITextView!
    
    var isBookmarkMode : Bool = false
    var curCellData : CellData = CellData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.isNavigationBarHidden = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setBookmark() {
        /*
        let temp = tableView.indexPathsForVisibleRows
        for i in 0..<(temp?.count)! {
            let indexPath = temp?[i]
            let t = bookDataArray[(indexPath?.section)!]?[(indexPath?.row)!]
            
            let cell = tableView.cellForRow(at: (temp?[i])!) as! MainTableViewCell
            if (cell.lblText.selectedRange.length != 0) {
                let range = cell.lblText.selectedRange
                let string = NSMutableAttributedString(attributedString: cell.lblText.attributedText)
                let attributes = [NSBackgroundColorAttributeName: Const.highlightColor]
                string.addAttributes(attributes, range: cell.lblText.selectedRange)
                cell.lblText.attributedText = string
                
                let db = DBManager()
                db.insertBookmark(data: t!, startPos: range.location, bmlength: range.length, totalLength: cell.lblText.attributedText.length, type: "p")
            }
        }
        initSectionData()
 */
    }
    
    @IBAction func onNoteTapped(_ sender: Any) {
    }
    
    @IBAction func onBookmarkTapped(_ sender: Any) {
        /*if (isBookmarkMode == false) {
            isBookmarkMode = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.btnPencil.alpha = 0.0
                self.btnBack.alpha = 0.0
                self.searchBar.isHidden = true
                self.tableView.isScrollEnabled = false
            }, completion: nil)
        }
        else {
            isBookmarkMode = false
            setBookmark()
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.btnPencil.alpha = 1.0
                self.btnBack.alpha = 1.0
                self.searchBar.isHidden = false
                self.tableView.isScrollEnabled = true
            }, completion: nil)
        }*/
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
