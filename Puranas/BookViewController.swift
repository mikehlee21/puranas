//
//  BookViewController.swift
//  Puranas
//
//  Created by Lucky Clover on 5/23/17.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import UIKit

class BookViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var lblSeriesName: String?
    var bookArray: [Book] = []
    var filterdArray: [Book] = []
    var selectedBook: Book?
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.title = lblSeriesName
        
        let db = DBManager()
        bookArray = db.loadBooksData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Table View Delegate and DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isSearching == true) {
            return filterdArray.count
        }
        else {
            return bookArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookTableViewCell
        
        if (isSearching) {
            cell.lblBookName.text = filterdArray[indexPath.row].name
            cell.lblLanguage.text = filterdArray[indexPath.row].lang
            cell.lblVolumes.text = "Volume \(filterdArray[indexPath.row].volumeNo!)"
        }
        else {
            cell.lblBookName.text = bookArray[indexPath.row].name
            cell.lblLanguage.text = bookArray[indexPath.row].lang
            cell.lblVolumes.text = "Volume \(bookArray[indexPath.row].volumeNo!)"
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = tableView.cellForRow(at: indexPath) as! BookTableViewCell
        if (isSearching) {
            selectedBook = filterdArray[indexPath.row]
        }
        else {
            selectedBook = bookArray[indexPath.row]
        }
        performSegue(withIdentifier: "Book2Reading", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MainViewController
        vc.lblBookName = selectedBook?.name
        vc.bookId = selectedBook?.bookId
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
        
        for i in 0..<bookArray.count {
            let temp = bookArray[i].name
            if temp?.range(of: searchBar.text!) != nil{
                filterdArray.append(bookArray[i])
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
