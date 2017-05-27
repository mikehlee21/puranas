//
//  SettingViewController.swift
//  Puranas
//
//  Created by Lucky Clover on 5/28/17.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.setHidesBackButton(true, animated: true)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.imgView?.image = #imageLiteral(resourceName: "contactUs")
            cell.lblText1.text = "email@domain.com"
            cell.lblText2.text = "Questions / Feedback"
            break
        case 1:
            cell.imgView?.image = #imageLiteral(resourceName: "webSite")
            cell.lblText1.text = "www.website.com"
            cell.lblText2.text = "Website"
            break
        case 2:
            cell.imgView?.image = #imageLiteral(resourceName: "appDesign")
            cell.lblText1.text = "Keshav Vadrevu"
            cell.lblText2.text = "App Design"
            break
        case 3:
            cell.imgView?.image = #imageLiteral(resourceName: "developer")
            cell.lblText1.text = "Ren Nakamura"
            cell.lblText2.text = "App Development"
            break
        default:
            break
        }
        
        return cell
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
