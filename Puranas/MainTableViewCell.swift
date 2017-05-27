//
//  MainTableViewCell.swift
//  Puranas
//
//  Created by Lucky Clover on 5/24/17.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {


    @IBOutlet weak var lblChapter: UILabel!
    @IBOutlet weak var lblText: UITextView!
    @IBOutlet weak var imgStar: UIImageView!
    
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
            imgStar.image = #imageLiteral(resourceName: "bookmarked")
            bookDataArray[sectionNo]?[index].isBookmarked = 1
            
            
            let db = DBManager()
            //db.insertBookmark(data: (bookDataArray[sectionNo]?[index])!)
        }
        else {
            self.backgroundColor = Const.cellBackColor
            imgStar.image = #imageLiteral(resourceName: "bookmarksOnly")
            bookDataArray[sectionNo]?[index].isBookmarked = 0
            
            let db = DBManager()
            //db.deleteBookmark(data: (bookDataArray[sectionNo]?[index])!)
        }

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
