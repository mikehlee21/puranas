//
//  MainTransTableViewCell.swift
//  Puranas
//
//  Created by Lucky Clover on 2017/05/25.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import UIKit

class MainTransTableViewCell: UITableViewCell {

    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 2
        self.contentView.addGestureRecognizer(tap)
        
        // Initialization code
    }
    
    func tapped() {
        if (dataArray[index].isBookmarked == 0) {
            self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
            imgStar.isHidden = false
            dataArray[index].isBookmarked = 1
            
            let db = DBManager()
            db.insertBookmark(data: dataArray[index])
        }
        else {
            self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            imgStar.isHidden = true
            dataArray[index].isBookmarked = 0
            
            let db = DBManager()
            db.deleteBookmark(data: dataArray[index])
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
