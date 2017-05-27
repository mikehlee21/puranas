//
//  MainViewController.swift
//  Puranas
//
//  Created by Lucky Clover on 5/24/17.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import UIKit
import CircularSpinner

class MainViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnPencil: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var lblBookName: String?
    var bookId: String?
    var lastContentOffset: CGFloat = 0
    var isButtonsHidden: Bool = false
    var allowHidden: Bool = true
    var prevFlag: Bool = false
    var isNav: Bool = false
    var isSearching: Bool = false
    var filteredArray: [Int:[CellData]] = [:]
    var navModeContentOffset: CGFloat = 0
    var dataArray: [CellData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.title = lblBookName
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        //CircularSpinner.show("Loading Book ...", animated: true, type: .indeterminate, showDismissButton: nil, delegate: nil)
        initSectionData(0)
        //CircularSpinner.hide()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 
        //let indexPath = tableView.indexPathForRow(at: CGPoint(x: 1.0, y: navModeContentOffset))
        
        let db = DBManager()
        let temp = db.loadLastReadingPos(bookId!)
        
        if (temp.chapterNo != 0) {
            var row = 0
            let cnt = bookDataArray[temp.chapterNo - 1]?.count
            for i in 1..<cnt! {
                let t = bookDataArray[temp.chapterNo - 1]?[i]
                if (t?.contentId == temp.contentId) {
                    if (temp.isCont == 1) {
                        row = i
                    }
                    else {
                        row += i
                    }
                    break
                }
            }
        
            let indexPath = IndexPath(row: row, section: temp.chapterNo - 1)
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
    
    func initCellDataArray(_ readingMode: Int) {
        
        let db = DBManager()
        let bookContArray = db.loadBookContData(bookId!)
        let bookmarkArray = db.loadBookmark()
        
        dataArray.removeAll()
        
        for i in 0..<bookContArray.count {
            if (readingMode != 2) {
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
            }
            
            if (readingMode != 1) {
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
        }
        
        for i in 0..<bookmarkArray.count {
            for j in 0..<dataArray.count {
                if ((bookmarkArray[i].bookId == dataArray[j].bookId) && (bookmarkArray[i].volumeNo == dataArray[j].volumeNo) && (bookmarkArray[i].cantoNo == dataArray[j].cantoNo) && (bookmarkArray[i].chapterNo == dataArray[j].chapterNo) && (bookmarkArray[i].contentId == dataArray[j].contentId) && (bookmarkArray[i].isCont == dataArray[j].isCont)) {
                    dataArray[j].isBookmarked = 1
                }
            }
        }
        
        if (readingMode == 3) {
            var tempArray:[CellData] = []
            for i in 0..<dataArray.count {
                if (dataArray[i].isBookmarked == 1) {
                    tempArray.append(dataArray[i])
                }
            }
            dataArray = tempArray
        }
    }
    
    func initSectionData(_ readingMode: Int) {
        
        initCellDataArray(readingMode)
        
        bookDataArray.removeAll()
        
        for i in 0..<getSectionCount() {
            var temp: [CellData] = []
            for j in 0..<dataArray.count {
                if (dataArray[j].chapterNo - 1 == i) {
                    temp.append(dataArray[j])
                }
            }
            bookDataArray[i] = temp
        }
        
        if (isSearching == true) {
            initFilteredArray()
        }
    }
    
    func getSectionCount() -> Int {
        var cnt = 1
        for i in 0..<dataArray.count {
            if (dataArray[i].chapterNo > cnt) {
                cnt = dataArray[i].chapterNo
            }
        }
        return cnt
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
        return getSectionCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isSearching == true) {
            return (filteredArray[section]?.count)!
        }
        else {
            return (bookDataArray[section]?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var temp = CellData()
        if (isSearching == true) {
            temp = (filteredArray[indexPath.section]?[indexPath.row])!
        }
        else {
            temp = (bookDataArray[indexPath.section]?[indexPath.row])!
        }
        
        if (temp.isCont == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell") as! MainTableViewCell
            cell.index = indexPath.row
            cell.sectionNo = indexPath.section
            
            if (temp.uvacha != "") {
                let attrString: NSMutableAttributedString = NSMutableAttributedString(string: "\(temp.uvacha.description):")
                attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 0.0, green: 0.8, blue: 0.0, alpha: 1.0), range: NSMakeRange(0, attrString.length))
            
                let descString: NSMutableAttributedString = NSMutableAttributedString(string:  String(format: "  %@", temp.text.description))
                descString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSMakeRange(0, descString.length))
            
                attrString.append(descString);
                
                let style = NSMutableParagraphStyle()
                style.lineSpacing = 10
                attrString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, attrString.length))
            
                cell.lblText.attributedText = attrString
            }
            else {
                cell.lblText.text = temp.text
            }
            
            if (temp.isBookmarked == 1) {
                cell.backgroundColor = Const.highlightColor
                cell.imgStar.isHidden = false
            }
            else {
                cell.backgroundColor = Const.cellBackColor
                cell.imgStar.isHidden = true
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainTransCell") as! MainTransTableViewCell
            //cell.lblText?.text = temp?.text
            cell.lblText.text = temp.text
            cell.index = indexPath.row
            cell.sectionNo = indexPath.section
            
            if (temp.isBookmarked == 1) {
                cell.backgroundColor = Const.highlightColor
                cell.imgStar.isHidden = false
            }
            else {
                cell.backgroundColor = Const.cellBackColor
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
            btnBookmark.isEnabled = false
            mainVC = self
        }
    }
    
    func hidebuttons() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.navigationController?.isNavigationBarHidden = true
            self.btnPencil.alpha = 0.0
            self.btnBack.alpha = 0.0
            self.btnBookmark.alpha = 0.0
            self.searchBar.isHidden = true
        }, completion: nil)
    }
    
    func showbuttons() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.navigationController?.isNavigationBarHidden = false
            self.btnPencil.alpha = 1.0
            self.btnBack.alpha = 1.0
            self.btnBookmark.alpha = 1.0
            self.searchBar.isHidden = false
        }, completion: nil)
    }
    // ScrollView Delegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (allowHidden == true) {
            if (self.lastContentOffset < scrollView.contentOffset.y) {
                // moved to top
                if (isButtonsHidden == false) {
                    hidebuttons()
                    isButtonsHidden = true
                }
            } else if (self.lastContentOffset > scrollView.contentOffset.y) {
                // moved to bottom
                if (isButtonsHidden == true) {
                    showbuttons()
                    isButtonsHidden = false
                }
            } else {
                // didn't move
            }
        }
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        lastContentOffset = scrollView.contentOffset.y
        allowHidden = true
        prevFlag = false
        if (isNav == false) {
            navModeContentOffset = scrollView.contentOffset.y
        }
        
        saveLastReadingPos()
    }
    
    func saveLastReadingPos() {
        let indexPath = tableView.indexPathForRow(at: CGPoint(x: 1, y: lastContentOffset))
        let temp = bookDataArray[(indexPath?.section)!]?[(indexPath?.row)!]
        let db = DBManager()
        db.saveLastReadingPos(bookId: (temp?.bookId)!, chapterNo: (temp?.chapterNo)!, contentId: (temp?.contentId)!, isCont: (temp?.isCont)!)
    }
    
    /*
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        allowHidden = true
        prevFlag = false
        lastReadingPos = scrollView.contentOffset.y
        if (isNav) {
            navModeContentOffset = scrollView.contentOffset.y
        }
    }*/
    
    func manageReadingMode(_ readingMode: Int) {
        //CircularSpinner.show("Loading Book ...", animated: true, type: .indeterminate, showDismissButton: nil, delegate: nil)
        initSectionData(readingMode)
        //CircularSpinner.hide()
        tableView.reloadData()
    }
    
    func manageNavMode(_ navMode: Int) {
        allowHidden = false
        
        let rows = tableView.indexPathsForVisibleRows
        let section = (rows?[0].section)!
        
        
        switch navMode {
        case 1:
            
            if (rows?.count != 0) {
                if (prevFlag == false) {
                    let indexPath = IndexPath(row: 0, section: section)
                    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    prevFlag = true
                }
                else {
                    if (section > 0) {
                        let indexPath = IndexPath(row: 0, section: section - 1)
                        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                }
            }
            
            isNav = true
            
            break
        case 2:
            if (rows?.count != 0) {
                if (section != (tableView.numberOfSections - 1)) {
                    let indexPath = IndexPath(row: 0, section: (section + 1))
                    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    prevFlag = true
                }
            }
            
            isNav = true
            
            break
        case 3:
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
            isNav = true
            
            break
        case 4:
            let indexPath = IndexPath(row: 0, section: tableView.numberOfSections - 1)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
            isNav = true
            prevFlag = true
            
            break
        case 5:
            if (isNav) {
                let indexPath = tableView.indexPathForRow(at: CGPoint(x: 1.0, y: navModeContentOffset))
                tableView.scrollToRow(at: indexPath!, at: .top, animated: true)
                isNav = false
                prevFlag = false
            }
            break
        default:
            break
        }
    }
    
    // SearchBar Delegate
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableView.reloadData()
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        initFilteredArray()
        tableView.reloadData()
    }
    
    func initFilteredArray() {
        filteredArray.removeAll()
        
        for i in 0..<getSectionCount() {
            var temp : [CellData] = []
            for j in 0..<(bookDataArray[i]?.count)! {
                let temp1 = bookDataArray[i]?[j].text
                if temp1?.range(of: searchBar.text!) != nil {
                    temp.append((bookDataArray[i]?[j])!)
                }
            }
            filteredArray[i] = temp
        }
        
        if searchBar.text! == "" {
            isSearching = false
        }
        else {
            isSearching = true
        }

    }

}
