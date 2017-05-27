//
//  SettingTableViewCell.swift
//  Puranas
//
//  Created by Lucky Clover on 5/28/17.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var lblText2: UILabel!
    @IBOutlet weak var lblText1: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
