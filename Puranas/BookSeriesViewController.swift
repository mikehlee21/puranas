//
//  BookSeriesViewController.swift
//  Puranas
//
//  Created by Lucky Clover on 5/23/17.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import UIKit

class BookSeriesViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var str: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 1.0, green: 0.75, blue: 0, alpha: 1.0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSettingTapped(_ sender: Any) {
    }

    @IBAction func onLastBookTapped(_ sender: Any) {
    }
    
    @IBAction func onFilterTapped(_ sender: Any) {
    }
    
    // Table View Delegate & DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookSeriesCell", for: indexPath) as! BookSeriesTableViewCell
        cell.lblSeriesName.text = "Series Name \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BookSeriesTableViewCell
        str = cell.lblSeriesName.text
        self.performSegue(withIdentifier: "Series2Book", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! BookViewController
        vc.lblSeriesName = str
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
