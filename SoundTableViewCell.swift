//
//  SoundTableViewCell.swift
//  TIK TIK
//
//  Created by Rao Mudassar on 02/05/2019.
//  Copyright © 2019 Rao Mudassar. All rights reserved.
//

import UIKit

class SoundTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sound_type: UILabel!
    
    @IBOutlet weak var sound_name: UILabel!
    
    @IBOutlet weak var btn_favourites: UIButton!
    
    @IBOutlet weak var sound_img: UIImageView!
    
    @IBOutlet weak var outerview: UIView!
    
    @IBOutlet weak var btn_play: UIImageView!
    
    @IBOutlet weak var select_view: UIView!
    
    @IBOutlet weak var select_btn: UIButton!
    
    
    @IBOutlet weak var innerview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
