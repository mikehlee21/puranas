//
//  MainTableViewCell.swift
//  Puranas
//
//  Created by Lucky Clover on 5/24/17.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var txtView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
