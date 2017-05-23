//
//  BookTableViewCell.swift
//  Puranas
//
//  Created by Lucky Clover on 5/23/17.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var lblVolumes: UILabel!
    @IBOutlet weak var lblBookName: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var imgBook: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
