//
//  DiscoverCategoryVC.swift
//  TIK TIK
//
//  Created by User on 02/07/20.
//  Copyright © 2020 Rao Mudassar. All rights reserved.
//

import UIKit
import SDWebImage

class DiscoverCategoryVC: UIViewController {

    @IBOutlet var discoverCollection: UICollectionView!
    
    var categoryName = ""
    var videoArray =  [ItemVideo]()
    var filteredArray = [ItemVideo]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var search = Bool()
    @IBOutlet var lblTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text = categoryName
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnPopToBack(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension DiscoverCategoryVC : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if search == true{
            return filteredArray.count
        }else{
        return videoArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = discoverCollection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? categoryCell{
            if search == true{
                let obj = self.filteredArray[indexPath.row]
                    cell.tik_img.layer.masksToBounds = false
                    cell.tik_img.layer.cornerRadius = 4
                    cell.tik_img.clipsToBounds = true
                     cell.tik_img.sd_setImage(with: URL(string:self.appDelegate.imgbaseUrl!+obj.thum), placeholderImage: UIImage(named:"Spinner-1s-200px.gif"))
                
            }else{
                let obj = self.videoArray[indexPath.row]
                cell.tik_img.layer.masksToBounds = false
                cell.tik_img.layer.cornerRadius = 4
                cell.tik_img.clipsToBounds = true
                 cell.tik_img.sd_setImage(with: URL(string:self.appDelegate.imgbaseUrl!+obj.thum), placeholderImage: UIImage(named:"Spinner-1s-200px.gif"))
            }
             return cell

        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(self.search == true){
        let obj =  self.filteredArray[indexPath.row]
        UserDefaults.standard.set(obj.video, forKey: "dis_url")
        UserDefaults.standard.set(obj.thum, forKey: "dis_img")
        StaticData.obj.userName = obj.first_name+" "+obj.last_name
        StaticData.obj.userImg = obj.profile_pic
        StaticData.obj.liked = obj.liked
        StaticData.obj.comment_count = obj.video_comment_count
        StaticData.obj.like_count = obj.like_count
        StaticData.obj.soundName = obj.sound_name
        StaticData.obj.videoID = obj.v_id
       StaticData.obj.other_id = obj.u_id
            
        DispatchQueue.main.async {

            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DiscoverVideoViewController") as! DiscoverVideoViewController
           
            self.present(vc, animated: true, completion: nil)
        }
        }else{
            let obj =  self.videoArray[indexPath.row]
            UserDefaults.standard.set(obj.video, forKey: "dis_url")
            UserDefaults.standard.set(obj.thum, forKey: "dis_img")
            StaticData.obj.userName = obj.first_name+" "+obj.last_name
            StaticData.obj.userImg = obj.profile_pic
            StaticData.obj.liked = obj.liked
            StaticData.obj.comment_count = obj.video_comment_count
            StaticData.obj.like_count = obj.like_count
            StaticData.obj.soundName = obj.sound_name
            StaticData.obj.videoID = obj.v_id
            StaticData.obj.other_id = obj.u_id
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DiscoverVideoViewController") as! DiscoverVideoViewController
                self.present(vc, animated: true, completion: nil)
            }
        }

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = discoverCollection.frame.size.width / 3
        return  CGSize(width: width, height: width)
    }
 
}

class  categoryCell : UICollectionViewCell{
    
    @IBOutlet weak var tik_img: SDAnimatedImageView!

}
