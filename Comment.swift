//
//  Comment.swift
//  TIK TIK
//
//  Created by Rao Mudassar on 02/05/2019.
//  Copyright © 2019 Rao Mudassar. All rights reserved.
//

import UIKit

class Comment: NSObject {
    
    
    var comments:String! = ""
    var first_name:String! = ""
    var last_name:String! = ""
    var profile_pic:String! = ""
  
    var v_id:String! = ""
 
    
    init(comments: String!, first_name: String!, last_name: String!,profile_pic: String!, v_id: String!) {
        
        self.comments = comments
        self.first_name = first_name
        self.last_name = last_name
        self.profile_pic = profile_pic
        self.v_id = v_id
       
        
    }

}
