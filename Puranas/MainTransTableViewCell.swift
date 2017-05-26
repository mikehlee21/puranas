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
    @IBOutlet weak var lblText: UITextView!
    
    
    var index: Int = 0
    var sectionNo: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 2
        self.contentView.addGestureRecognizer(tap)
        
        // Initialization code
    }
    
    func tapped() {
        if (bookDataArray[sectionNo]?[index].isBookmarked == 0) {
            self.backgroundColor = Const.highlightColor
            imgStar.isHidden = false
            bookDataArray[sectionNo]?[index].isBookmarked = 1
            
            let db = DBManager()
            db.insertBookmark(data: (bookDataArray[sectionNo]?[index])!)
        }
        else {
            self.backgroundColor = Const.cellBackColor
            imgStar.isHidden = true
            bookDataArray[sectionNo]?[index].isBookmarked = 0
            
            let db = DBManager()
            db.deleteBookmark(data: (bookDataArray[sectionNo]?[index])!)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
