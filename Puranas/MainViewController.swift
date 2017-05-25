//
//  MainViewController.swift
//  Puranas
//
//  Created by Lucky Clover on 5/24/17.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import UIKit

class MainViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var lblBookName: String?
    //var cellDataArray: [CellData] = []
    var bookId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.title = lblBookName
        
        tableView.delegate = self
        tableView.dataSource = self
        
        initCellDataArray()
        
        // Do any additional setup after loading the view.
    }
    
    func initCellDataArray() {
        
        let db = DBManager()
        let bookContArray = db.loadBookContData()
        let bookmarkArray = db.loadBookmark()
        
        for i in 0..<bookContArray.count {
            let t = CellData()
            t.text = bookContArray[i].content!
            t.isCont = 1
            t.uvacha = bookContArray[i].uvacha!
            t.volumeNo = bookContArray[i].volumeNo
            t.chapterNo = bookContArray[i].chapterNo
            t.cantoNo = bookContArray[i].cantoNo
            t.contentId = bookContArray[i].contentId
            t.bookId = bookId!
            
            dataArray.append(t)
            if (bookContArray[i].translation != nil) {
                let t1 = CellData()
                t1.text = bookContArray[i].translation!
                t1.isCont = 0
                t1.uvacha = bookContArray[i].uvacha!
                t1.volumeNo = bookContArray[i].volumeNo
                t1.chapterNo = bookContArray[i].chapterNo
                t1.cantoNo = bookContArray[i].cantoNo
                t1.contentId = bookContArray[i].contentId
                t1.bookId = bookId!
                
                dataArray.append(t1)
            }
        }
        
        for i in 0..<bookmarkArray.count {
            for j in 0..<dataArray.count {
                if ((bookmarkArray[i].bookId == dataArray[j].bookId) && (bookmarkArray[i].volumeNo == dataArray[j].volumeNo) && (bookmarkArray[i].cantoNo == dataArray[j].cantoNo) && (bookmarkArray[i].chapterNo == dataArray[j].chapterNo) && (bookmarkArray[i].contentId == dataArray[j].contentId) && (bookmarkArray[i].isCont == dataArray[j].isCont)) {
                    dataArray[j].isBookmarked = 1
                }
            }
        }
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
        for i in 0..<dataArray.count {
            if (dataArray[i].chapterNo > cnt) {
                cnt = dataArray[i].chapterNo
            }
        }
        return cnt
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let temp = dataArray[indexPath.row]
        
        if (temp.isCont == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell") as! MainTableViewCell
            cell.index = indexPath.row
            
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
            
            if (temp.isBookmarked == 1) {
                cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
                cell.imgStar.isHidden = false
            }
            else {
                cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.imgStar.isHidden = true
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainTransCell") as! MainTransTableViewCell
            cell.lblText?.text = temp.text
            cell.index = indexPath.row
            
            if (temp.isBookmarked == 1) {
                cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
                cell.imgStar.isHidden = false
            }
            else {
                cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.imgStar.isHidden = true
            }
            
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
