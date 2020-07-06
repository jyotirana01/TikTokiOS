//
//  dicoverTableCell.swift
//  TIK TIK
//
//  Created by Rao Mudassar on 08/05/2019.
//  Copyright © 2019 Rao Mudassar. All rights reserved.
//

import UIKit

class dicoverTableCell: UITableViewCell {
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    @IBOutlet weak var dis_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
