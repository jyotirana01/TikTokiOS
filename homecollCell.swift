//
//  homecollCell.swift
//  TIK TIK
//
//  Created by Rao Mudassar on 25/04/2019.
//  Copyright © 2019 Rao Mudassar. All rights reserved.
//

import UIKit
import VersaPlayer
import AVKit
import DSGradientProgressView


class homecollCell: UICollectionViewCell {
    
    @IBOutlet weak var progressView: DSGradientProgressView!
    @IBOutlet weak var playerView: UIView!
    var player:AVPlayer? = nil
    var playerItem:AVPlayerItem? = nil
    var playerLayer:AVPlayerLayer? = nil
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var other_profile: UIButton!
    
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var inner_view: UIView!
    
    
    @IBOutlet weak var btn_like: UIButton!
    
    @IBOutlet weak var btnshare: UIButton!
    
    @IBOutlet weak var btn_comments: UIButton!
    
    
    @IBOutlet weak var user_view: UIView!
    
    @IBOutlet weak var user_img: UIImageView!
    
    @IBOutlet weak var user_name: UILabel!
    
    @IBOutlet weak var music_name: UILabel!
    
   
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        self.playerItem = nil
        self.playerLayer?.removeFromSuperlayer()
        
       
    }
    
    
    
}
