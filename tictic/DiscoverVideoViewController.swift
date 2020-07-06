//
//  DiscoverVideoViewController.swift
//  TIK TIK
//
//  Created by Rao Mudassar on 08/05/2019.
//  Copyright © 2019 Rao Mudassar. All rights reserved.
//

import UIKit
import AVKit
import SDWebImage
import Alamofire
import DSGradientProgressView

class DiscoverVideoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var user_img: UIImageView!
    
    @IBOutlet weak var user_name: UILabel!
    
    @IBOutlet weak var sound_name: UILabel!
    @IBOutlet weak var btn_comment: UIButton!
    
    @IBOutlet weak var tableview: UITableView!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var out_view: UIView!
    
    
    @IBOutlet weak var txt_comment: UITextField!
    
     var comments_array:NSMutableArray = []
    
     @IBOutlet weak var progressView: DSGradientProgressView!
    
    
    @IBOutlet weak var btn_fav: UIButton!
    
    @IBOutlet weak var btn_play: UIButton!
    
    @IBOutlet weak var video_img: UIImageView!
    
    @IBOutlet weak var playerview: UIView!
    
    @IBOutlet weak var play_view: UIView!
    
    @IBOutlet weak var user_view: UIView!
    
    var playerItem:AVPlayerItem?
    
    var avplayer:AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        
        
        let url = URL.init(string: self.appDelegate.imgbaseUrl!+UserDefaults.standard.string(forKey: "dis_url")!)
        playerItem = AVPlayerItem(url: url!)
        //cell.player!.replaceCurrentItem(with: cell.playerItem)
        avplayer = AVPlayer(playerItem: playerItem!)
        let playerLayer=AVPlayerLayer(player: avplayer!)
        playerLayer.frame = CGRect(x:0,y:0,width:screenSize.width,height: screenSize.height)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerview.layer.addSublayer(playerLayer)
        
        avplayer!.play()
        
        video_img.sd_setImage(with: URL(string:self.appDelegate.imgbaseUrl!+UserDefaults.standard.string(forKey: "dis_img")!), placeholderImage: UIImage(named:""))
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.videoDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        self.user_view.layer.cornerRadius = 5.0
        self.user_view.clipsToBounds = true
        
        self.user_name.text = StaticData.obj.userName
        self.user_img.sd_setImage(with: URL(string:StaticData.obj.userImg), placeholderImage: UIImage(named: ""))
        self.user_img.layer.masksToBounds = false
        self.user_img.layer.cornerRadius = self.user_img.frame.height/2
        self.user_img.clipsToBounds = true
        self.sound_name.text = StaticData.obj.soundName
        self.btn_fav.setTitle(StaticData.obj.like_count
            , for:.normal)
        self.btn_comment.setTitle(StaticData.obj.comment_count, for: .normal)
        
        if(StaticData.obj.liked == "0"){
            
            self.btn_fav.setBackgroundImage(UIImage(named:"ic_like"), for: .normal)
        }else{
            self.btn_fav.setBackgroundImage(UIImage(named:"ic_like_fill"), for: .normal)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.play_view.addGestureRecognizer(tap)
        
        self.play_view.isUserInteractionEnabled = true
        
        self.progressView.wait()
        
    
     
            self.avplayer?.addObserver(self, forKeyPath:"timeControlStatus", options: [.old, .new], context: nil)
        
    

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
  
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
      
            if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
                let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
                let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
                if newStatus != oldStatus {
                    DispatchQueue.main.async {[weak self] in
                        if newStatus == .playing || oldStatus == .paused  {
                            self!.progressView.signal()
                            self!.progressView.isHidden = true
                            
                        } else {
                            
                            self!.progressView.wait()
                            self!.progressView.isHidden = false
                            
                        }
                    }
                }
            }
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        
      
        if(self.btn_play.backgroundImage(for: .normal) == UIImage(named: "ic_pause_icon")){
            
            
            
            self.btn_play.setBackgroundImage(UIImage(named:"ic_play_icon"), for: .normal)
            self.btn_play.isHidden = false
            self.avplayer?.pause()
        }
    }
    
    @objc func videoDidEnd(notification: NSNotification) {
        
            avplayer!.seek(to: CMTime.zero)
            avplayer!.play()
        }

    
    @IBAction func dismiss(_ sender: Any) {
        
        self.dismiss(animated:true, completion: nil)
    }
    
    // share Button action
    
    
    @IBAction func share(_ sender: Any) {
        
        let text = self.appDelegate.imgbaseUrl!+UserDefaults.standard.string(forKey: "dis_url")!
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func comment(_ sender: Any) {
        
        if(UserDefaults.standard.string(forKey: "uid") == ""){
            
             self.alertModule(title:"TIK TIK", msg: "Please login from profile to comment on video!")
            
        }else{
        self.out_view.alpha = 1
        
        UIView.animate(withDuration: 0.5, animations: {
            print(self.out_view.frame.origin.y)
            
            
            
            
            self.out_view.frame = CGRect(x: 0, y:UIScreen.main.bounds.height-335 , width: self.view.frame.width, height: self.view.frame.height)
            
            
            
            
        },  completion: { (finished: Bool) in
            
       
            
            
            self.getComents()
        })
            
        }
        
    }
    
    // Get All Comments list
    
    func getComents() {
        
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.showVideoComments!
        let  sv = HomeViewController.displaySpinner(onView: self.out_view)
        
        
        
        let parameter :[String:Any]? = ["video_id":StaticData.obj.videoID]
        
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:nil).validate().responseJSON(completionHandler: {
            
            respones in
            
            
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                
                HomeViewController.removeSpinner(spinner: sv)
                
                self.comments_array = []
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSString
                if(code == "200"){
                    let myCountry = (dic["msg"] as? [[String:Any]])!
                    for Dict in myCountry {
                        
                        let myRestaurant = Dict as NSDictionary
                        var comments:String! = ""
                        var v_id:String! = ""
                        var first_name:String! = ""
                        var last_name:String! = ""
                        var profile_pic:String! = ""
                        if let comm =  myRestaurant["comments"] as? String{
                            
                            comments = comm
                        }
                        if let myID =  myRestaurant["video_id"] as? String{
                            
                            v_id = myID
                        }
                        if let u_info = myRestaurant["user_info"] as? NSDictionary{
                            if let myFirest =  u_info["first_name"] as? String{
                                
                                first_name = myFirest
                            }
                            if let myLast =  u_info["last_name"] as? String{
                                
                                last_name = myLast
                            }
                            if let myPic =  u_info["profile_pic"] as? String{
                                
                                profile_pic = myPic
                            }
                        }
                        
                        let obj = Comment(comments: comments, first_name: first_name, last_name: last_name,profile_pic: profile_pic, v_id: v_id)
                        
                        self.comments_array.add(obj)
                        
                        
                        
                    }
                    
                    self.comments_array = NSMutableArray(array: self.comments_array.reversed())
                    
                    
                    self.tableview.delegate = self
                    self.tableview.dataSource = self
                    self.tableview.reloadData()
                    if(self.comments_array.count > 0){
                        DispatchQueue.main.async {
                            let indexPath = IndexPath(row: self.comments_array.count-1, section: 0)
                            self.tableview.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        }
                    }
                    
                }else{
                    
                    self.alertModule(title:"Error", msg:dic["msg"] as! String)
                    
                }
                
                
                
            case .failure(let error):
                print(error)
                HomeViewController.removeSpinner(spinner: sv)
                self.alertModule(title:"Error",msg:error.localizedDescription)
            }
        })
    }
    
    // Send Comment Api
    
    @IBAction func sendComment(_ sender: Any) {
        
     
        
        if(txt_comment.text != ""){
            
            
            
            let url : String = self.appDelegate.baseUrl!+self.appDelegate.postComment!
            
            let  sv = HomeViewController.displaySpinner(onView: self.out_view)
            
            let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,"video_id":StaticData.obj.videoID,"comment":self.txt_comment.text!]
            
            print(url)
            print(parameter!)
            
            Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:nil).validate().responseJSON(completionHandler: {
                
                respones in
                
                switch respones.result {
                case .success( let value):
                    
                    let json  = value
                    HomeViewController.removeSpinner(spinner: sv)
                    
                    print(json)
                    let dic = json as! NSDictionary
                    let code = dic["code"] as! NSString
                    if(code == "200"){
                        self.txt_comment.text = ""
                        
                        //                        var str:Int! = Int(obj.video_comment_count)
                        //                        str = str+1
                        //                        obj.video_comment_count = String(str)
                        //                        cell.btn_comments.setTitle(obj.video_comment_count, for: .normal)
                        
                        self.getComents()
                        
                        
                    }else{
                        
                        self.alertModule(title:"Error", msg:dic["msg"] as! String)
                        
                    }
                    
                    
                    
                case .failure(let error):
                    print(error)
                    HomeViewController.removeSpinner(spinner: sv)
                    self.alertModule(title:"Error",msg:error.localizedDescription)
                }
            })
            
        }
        
        
    }
    
    // tableview Deleagte methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CommentTableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "cell01", for: indexPath) as! CommentTableViewCell
        
        let obj = self.comments_array[indexPath.row] as! Comment
        
        cell.comment_title.text = obj.first_name+" "+obj.last_name
        
        cell.comment_name.text = obj.comments
        
        cell.comment_img.sd_setImage(with: URL(string:obj.profile_pic), placeholderImage: UIImage(named: "nobody_m.1024x1024"))
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    @IBAction func cross(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            print(self.out_view.frame.origin.y)
            
            self.out_view.frame = CGRect(x: 0, y:1000 , width: self.view.frame.width, height: self.view.frame.height)
            
            self.out_view.alpha = 0
            
            
            
        },  completion: nil)
        
        
    }
    
    
    
    
    @IBAction func like(_ sender: Any) {
        
        var action:String! = ""
     
//        if(StaticData.obj.liked == "0"){
//
//            action = "1"
//        }else{
//            action = "0"
//        }
        
        if(UserDefaults.standard.string(forKey: "uid") == ""){
                         
                          self.alertModule(title:"TIK TIK", msg: "Please login from profile to like the video!")
                         
                     }else{
        
        if(StaticData.obj.liked == "0"){
            
            action = "1"
            
            self.btn_fav.setBackgroundImage(UIImage(named:"ic_like"), for: .normal)
            
        }else{
            
            
            self.btn_fav.setBackgroundImage(UIImage(named:"ic_like_fill"), for: .normal)
            action = "0"
        }
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.likeDislikeVideo!
        
        let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,"video_id":StaticData.obj.videoID,"action":action!]
        
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:nil).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                
                
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSString
                if(code == "200"){
                    
                    StaticData.obj.liked = action
                    
                    
                    if(StaticData.obj.liked  == "0"){
                        
                        
                        self.btn_fav.setBackgroundImage(UIImage(named:"ic_like"), for: .normal)
                        
                        if(Int(StaticData.obj.like_count)! > 0){
                            
                            let str:Int! = Int(StaticData.obj.like_count)!-1
                            
                            
                            self.btn_fav.setTitle(String(str), for: .normal)
                            
                        }
                        
                    }else{
                        
                        let str:Int! = Int(StaticData.obj.like_count)!+1
                       
                        
                        self.btn_fav.setTitle(String(str), for: .normal)
                        self.btn_fav.setBackgroundImage(UIImage(named:"ic_like_fill"), for: .normal)
                    }
                    
                    
                }else{
                    
                    
                    
                }
                
                
                
            case .failure(let error):
                print(error)
            }
        })
        }
    }
    
    
    
    @IBAction func play(_ sender: Any) {
        
      
        if(self.btn_play.backgroundImage(for: .normal) == UIImage(named: "ic_play_icon")){
            self.btn_play.setBackgroundImage(UIImage(named:"ic_pause_icon"), for: .normal)
            self.avplayer?.play()
            self.btn_play.isHidden = true
         
        }
    }
    
    
    @IBAction func next(_ sender: Any) {
        
        if(StaticData.obj.other_id != UserDefaults.standard.string(forKey: "uid")!){
        
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let yourVC: Profile1ViewController = storyboard.instantiateViewController(withIdentifier: "Profile1ViewController") as! Profile1ViewController
            
            present(yourVC , animated: true, completion: nil)
        }else{
            
           
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
extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}


