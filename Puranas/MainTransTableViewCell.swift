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
    @IBOutlet weak var lblChapter: UILabel!
    
    
    var index: Int = 0
    var sectionNo: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        self.contentView.addGestureRecognizer(tap)
        
        // Initialization code
    }
    
    func tapped() {
        if (bookDataArray[sectionNo]?[index].isBookmarked == 0) {
            self.backgroundColor = Const.highlightColor
            imgStar.image = #imageLiteral(resourceName: "bookmarked")
            bookDataArray[sectionNo]?[index].isBookmarked = 1
            
            bookDataArray[sectionNo]?[index].bmType = "f"
            var str = ""
            for _ in 0..<lblText.attributedText.length {
                str += "1"
            }
            bookDataArray[sectionNo]?[index].bmData = str
            
            let range = NSRange(location: 0, length: lblText.attributedText.length)
            let string = NSMutableAttributedString(attributedString: lblText.attributedText)
            let attributes = [NSBackgroundColorAttributeName: Const.highlightColor]
            string.addAttributes(attributes, range: range)
            lblText.attributedText = string
            
            let db = DBManager()
            db.insertBookmark(data: (bookDataArray[sectionNo]?[index])!, startPos: 0, bmlength: 0, totalLength: lblText.attributedText.length, type: "f")
        }
        else {
            imgStar.image = #imageLiteral(resourceName: "bookmarksOnly")
            bookDataArray[sectionNo]?[index].isBookmarked = 0
            
            let range = NSRange(location: 0, length: lblText.attributedText.length)
            let string = NSMutableAttributedString(attributedString: lblText.attributedText)
            let attributes = [NSBackgroundColorAttributeName: Const.cellBackColor]
            string.addAttributes(attributes, range: range)
            lblText.attributedText = string
            
            let db = DBManager()
            db.deleteBookmark(data: (bookDataArray[sectionNo]?[index])!)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
