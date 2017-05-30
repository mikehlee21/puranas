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
        tap.numberOfTapsRequired = 1
        imgStar.addGestureRecognizer(tap)
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longTapped))
        self.contentView.addGestureRecognizer(longTap)
        // Initialization code
    }

    func tapped() {
        if (bookDataArray[sectionNo]?[index].isBookmarked == 0) {
            imgStar.image = #imageLiteral(resourceName: "bookmarked")
            self.contentView.backgroundColor = Const.highlightColor
            bookDataArray[sectionNo]?[index].isBookmarked = 1
            bookDataArray[sectionNo]?[index].highlightType = "f"
            
            let range = NSRange(location: 0, length: lblText.attributedText.length)
            let string = NSMutableAttributedString(attributedString: lblText.attributedText)
            let attributes = [NSBackgroundColorAttributeName: Const.highlightColor]
            string.addAttributes(attributes, range: range)
            lblText.attributedText = string
            
            let db = DBManager()
            db.insertBookmark(data: (bookDataArray[sectionNo]?[index])!, startPos: 0, bmlength: 0, totalLength: lblText.attributedText.length, type: "f")
        }
        else {
            if (bookDataArray[sectionNo]?[index].highlightType == "f") {
                imgStar.image = #imageLiteral(resourceName: "bookmarksOnly")
                self.contentView.backgroundColor = Const.cellBackColor
                bookDataArray[sectionNo]?[index].isBookmarked = 0
                
                let range = NSRange(location: 0, length: lblText.attributedText.length)
                let string = NSMutableAttributedString(attributedString: lblText.attributedText)
                let attributes = [NSBackgroundColorAttributeName: Const.cellBackColor]
                string.addAttributes(attributes, range: range)
                lblText.attributedText = string
                
                let db = DBManager()
                db.deleteBookmark(data: (bookDataArray[sectionNo]?[index])!)
            }
            else if (bookDataArray[sectionNo]?[index].highlightType == "p") {
                imgStar.image = #imageLiteral(resourceName: "bookmarked")
                self.contentView.backgroundColor = Const.highlightColor
                bookDataArray[sectionNo]?[index].isBookmarked = 1
                bookDataArray[sectionNo]?[index].highlightType = "f"
                
                let range = NSRange(location: 0, length: lblText.attributedText.length)
                let string = NSMutableAttributedString(attributedString: lblText.attributedText)
                let attributes = [NSBackgroundColorAttributeName: Const.highlightColor]
                string.addAttributes(attributes, range: range)
                lblText.attributedText = string
                
                let db = DBManager()
                db.insertBookmark(data: (bookDataArray[sectionNo]?[index])!, startPos: 0, bmlength: 0, totalLength: lblText.attributedText.length, type: "f")
            }
        }

    }
    
    func longTapped(sender: UILongPressGestureRecognizer) {
        if (sender.state == .began) {
            mainVC?.goToEdit(data: (bookDataArray[sectionNo]?[index])!, section: sectionNo, row: index)
        }
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
