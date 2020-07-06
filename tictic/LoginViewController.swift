//
//  LoginViewController.swift
//  TIK TIK
//
//  Created by Rao Mudassar on 14/05/2019.
//  Copyright © 2019 Rao Mudassar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
        self.view.backgroundColor = UIColor(white: 0.5, alpha: 0.4)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func fbLogin(_ sender: Any) {
        
        
    }
    

    @IBAction func GmailLogin(_ sender: Any) {
        
        
    }
    

}
