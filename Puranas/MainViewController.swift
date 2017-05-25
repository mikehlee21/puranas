//
//  MainViewController.swift
//  Puranas
//
//  Created by Lucky Clover on 5/24/17.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import UIKit

class CellData {
    var text: String = ""
    var isTrans: Bool = false
    var isBookmark: Bool = false
    var uvacha: String = ""
}

class MainViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var lblBookName: String?
    var bookContArray: [BookCont] = []
    var cellDataArray: [CellData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.title = lblBookName
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let db = DBManager()
        bookContArray = db.loadBookContData()
        
        for i in 0..<bookContArray.count {
            let t = CellData()
            t.text = bookContArray[i].content!
            t.isTrans = true
            t.uvacha = bookContArray[i].uvacha!
            cellDataArray.append(t)
            if (bookContArray[i].translation != nil) {
                let t1 = CellData()
                t1.text = bookContArray[i].translation!
                t1.isTrans = false
                t1.uvacha = bookContArray[i].uvacha!
                cellDataArray.append(t1)
            }
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onPencelTapped(_ sender: Any) {
        performSegue(withIdentifier: "PopupSegue", sender: nil)
    }

    // Table View Delegate & DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var cnt = 1
        for i in 0..<bookContArray.count {
            if (bookContArray[i].chapterNo! > cnt) {
                cnt = bookContArray[i].chapterNo!
            }
        }
        return cnt
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let temp = cellDataArray[indexPath.row]
        if (temp.isTrans == true) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell") as! MainTableViewCell
            
            if (temp.uvacha != "") {
                let attrString: NSMutableAttributedString = NSMutableAttributedString(string: "\(temp.uvacha.description):")
                attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 0.0, green: 0.8, blue: 0.0, alpha: 1.0), range: NSMakeRange(0, attrString.length))
            
                let descString: NSMutableAttributedString = NSMutableAttributedString(string:  String(format: "  %@", temp.text.description))
                descString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSMakeRange(0, descString.length))
            
                attrString.append(descString);
            
                cell.lblText.attributedText = attrString
            }
            else {
                cell.lblText?.text = temp.text
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainTransCell") as! MainTransTableViewCell
            cell.lblText?.text = temp.text
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let str = "Chapter \(section + 1)"
        return str
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "PopupSegue"
        {
            btnBack.isEnabled = false
            btnSearch.isEnabled = false
            let popupVC = segue.destination as! PopupViewController
            popupVC.delegate = self
        }
    }
    

}
