//
//  TabbarViewController.swift
//  TIK TIK
//
//  Created by Rao Mudassar on 24/04/2019.
//  Copyright © 2019 Rao Mudassar. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController,UITabBarControllerDelegate {
    
    var button = UIButton(type: .custom)
    
    var bgView:UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
       // tabBar.barTintColor = UIColor.white
        self.tabBar.isTranslucent = true
        //self.tabBar.alpha = 0.3
//        self.tabBar.backgroundColor = UIColor.clear.withAlphaComponent(0.0)
//        self.tabBar.layer.backgroundColor = UIColor.clear.withAlphaComponent(0.0).cgColor
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        //self.tabBar.unselectedItemTintColor = UIColor.white
        UITabBar.appearance().barTintColor = UIColor.clear
        self.tabBar.unselectedItemTintColor = UIColor.lightGray
        self.bgView?.removeFromSuperview()
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        bgView = UIImageView(image: UIImage(named: "Untitled drawing"))
        bgView!.frame = CGRect(x: 0, y: screenHeight-60, width:screenWidth, height: 60)//you might need to modify this frame to your tabbar frame
        self.view.addSubview(bgView!)
        


    }
    
    
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.bringSubviewToFront(self.tabBar)
        self.addCenterButton()
        
      
        
           
        
    }
    
    // Add Custom video making button in tabbar
   private func addCenterButton() {
           button.setImage(UIImage(named: "33"), for: .normal)
           let square = self.tabBar.frame.size.height
           button.frame = CGRect(x: 0, y: 0, width: square, height: square)
           button.center = self.tabBar.center
           var menuButtonFrame = button.frame
           let screensize = UIScreen.main.bounds
           let screenHeight = screensize.height
           if screenHeight >= 812 {
               menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height - 30
           }else{
                menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height
           }
           menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
           button.frame = menuButtonFrame
           self.view.addSubview(button)
           self.view.bringSubviewToFront(button)
           tabBar.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
           tabBar.topAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
           button.addTarget(self, action: #selector(didTouchCenterButton(_:)), for: .touchUpInside)
       }
    @objc
    private func didTouchCenterButton(_ sender: AnyObject) {
        
        if(UserDefaults.standard.string(forKey: "uid") == ""){
            
            self.alertModule(title:"TIK TIK", msg: "Please login from profile to upload video!")
            
            
        }else{
            let vc = ActionViewContoller()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
       
    }
    
    // Tabbar delegate Method

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 1{
            self.tabBar.isTranslucent = true
            UITabBar.appearance().shadowImage = UIImage()
            UITabBar.appearance().backgroundImage = UIImage()
            UITabBar.appearance().barTintColor = UIColor.clear
            self.tabBar.unselectedItemTintColor = UIColor.white
            button.setImage(UIImage(named: "33"), for: .normal)
            self.bgView?.alpha = 1
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            bgView = UIImageView(image: UIImage(named: "Untitled drawing"))
            bgView!.frame = CGRect(x: 0, y: screenHeight-60, width:screenWidth, height: 60)//you might need to modify this frame to your tabbar frame
            self.view.addSubview(bgView!)
          
        }else{
            tabBar.barTintColor = UIColor.white
            self.tabBar.unselectedItemTintColor = UIColor.lightGray
            button.setImage(UIImage(named: "28"), for: .normal)
            self.bgView?.alpha = 0
          //you might need to modify this frame to your tabbar frame
            self.bgView?.removeFromSuperview()
            
        }
    }
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    

}

