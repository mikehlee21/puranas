//
//  BookSeriesViewController.swift
//  Puranas
//
//  Created by Lucky Clover on 5/23/17.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import UIKit

class BookSeriesViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var str: String?
    var seriesArray: [Series] = []
    var filterdArray: [Series] = []
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        let db = DBManager()
        seriesArray = db.loadSeriesData()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 1.0, green: 192.0 / 255.0, blue: 0.0, alpha: 1.0)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSettingTapped(_ sender: Any) {
    }

    @IBAction func onLastBookTapped(_ sender: Any) {
        let db = DBManager()
        let temp = db.getLastReadingPos()
        if (temp.bookId == "") {
            let alert = UIAlertController(title: "Puranas", message: "No recording", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            controller.bookId = temp.bookId
            controller.lblBookName = getBookNameFromId(temp.bookId)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func getBookNameFromId(_ bookId: String) -> String {
        let db = DBManager()
        let temp = db.loadBooksData()
        var bookName = ""
        for i in 0..<temp.count {
            if (bookId == temp[i].bookId) {
                bookName = temp[i].name!
            }
        }
        return bookName
    }
    
    @IBAction func onFilterTapped(_ sender: Any) {
    }
    
    // Table View Delegate & DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isSearching == true) {
            return filterdArray.count
        }
        else {
            return seriesArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookSeriesCell", for: indexPath) as! BookSeriesTableViewCell
        if (isSearching == true) {
            cell.lblSeriesName.text = filterdArray[indexPath.row].name
            cell.lblLanguage.text = filterdArray[indexPath.row].lang
            cell.lblSeriesType.text = filterdArray[indexPath.row].type
            cell.lblVolumes.text = "\(filterdArray[indexPath.row].volumes!) Volumes"
        }
        else {
            cell.lblSeriesName.text = seriesArray[indexPath.row].name
            cell.lblLanguage.text = seriesArray[indexPath.row].lang
            cell.lblSeriesType.text = seriesArray[indexPath.row].type
            cell.lblVolumes.text = "\(seriesArray[indexPath.row].volumes!) Volumes"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BookSeriesTableViewCell
        str = cell.lblSeriesName.text
        self.performSegue(withIdentifier: "Series2Book", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Series2Book" {
            let vc = segue.destination as! BookViewController
            vc.lblSeriesName = str
        }
    }
    
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
        filterdArray.removeAll()
        
        for i in 0..<seriesArray.count {
            let temp = seriesArray[i].name
            if temp?.range(of: searchBar.text!) != nil{
                filterdArray.append(seriesArray[i])
            }
        }
        
        if searchBar.text! == "" {
            isSearching = false
        }
        else {
            isSearching = true
        }
        
        tableView.reloadData()
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
