//
//  Videos.swift
//  TIK TIK
//
//  Created by Rao Mudassar on 14/05/2019.
//  Copyright © 2019 Rao Mudassar. All rights reserved.
//

import UIKit

class Videos: NSObject {
    
    var video:String! = ""
    var thum:String! = ""
    var liked:String! = "0"
    var like_count:String! = "0"
    var video_comment_count:String! = "0"
    var first_name:String! = ""
    var last_name:String! = ""
    var profile_pic:String! = ""
    var sound_name:String! = ""
    var v_id:String! = "0"
    var view:String! = "0"
    var u_id:String! = ""
    
    init(video: String!, thum: String!, liked: String!,like_count: String!, video_comment_count: String!,first_name: String!, last_name: String!, profile_pic: String!,sound_name: String!, v_id: String!, view: String!,u_id: String!) {
        
        self.video = video
        self.thum = thum
        self.liked = liked
        self.like_count = like_count
        self.video_comment_count = video_comment_count
        self.first_name = first_name
        self.last_name = last_name
        self.profile_pic = profile_pic
        self.sound_name = sound_name
        self.v_id = v_id
        self.view = view
        self.u_id = u_id
        
        
    }

}
