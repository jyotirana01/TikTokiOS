//
//  CommentTableViewCell.swift
//  TIK TIK
//
//  Created by Rao Mudassar on 02/05/2019.
//  Copyright © 2019 Rao Mudassar. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var comment_img: UIImageView!
    
    @IBOutlet weak var comment_title: UILabel!
    
    @IBOutlet weak var comment_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       comment_img.layer.masksToBounds = false
        comment_img.layer.cornerRadius = comment_img.frame.height/2
        comment_img.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
