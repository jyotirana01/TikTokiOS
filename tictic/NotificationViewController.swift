//
//  NotificationViewController.swift
//  TIK TIK
//
//  Created by Rao Mudassar on 24/04/2019.
//  Copyright © 2019 Rao Mudassar. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import Alamofire
import AuthenticationServices

class NotificationViewController: UIViewController,GIDSignInDelegate  {
    
    @IBOutlet weak var inner_view: UIView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var first_name:String! = ""
    var last_name:String! = ""
    var email:String! = ""
    var my_id:String! = ""
    var profile_pic:String! = ""
    var signUPType:String! = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

      
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       
            UIApplication.shared.statusBarStyle = .default
        
        
        if(UserDefaults.standard.string(forKey: "uid") == ""){
            
            self.inner_view.alpha = 1
            
            self.navigationItem.title = "Login"
            
            
        }else{
            
            self.inner_view.alpha = 0
            self.navigationItem.title = "Notifications"
        }
       
    }
    
    // Facebook Login Method
    
    
    @IBAction func FBLogin(_ sender: Any) {
        
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        
                        
                    }
                }
            }
        }
    }
    
    func getFBUserData(){
        
        let sv = HomeViewController.displaySpinner(onView: self.view)
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email,age_range"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let dict = result as! [String : AnyObject]
                    print(dict)
                    if let dict = result as? [String : AnyObject]{
                        if(dict["email"] as? String == nil || dict["id"] as? String == nil || dict["email"] as? String == "" || dict["id"] as? String == "" ){
                            
                            HomeViewController.removeSpinner(spinner: sv)
                            
                            self.alertModule(title:"Error", msg:"You cannot login with this facebook account because your facebook is not linked with any email")
                            
                        }else{
                            HomeViewController.removeSpinner(spinner: sv)
                            self.email = dict["email"] as? String
                            self.first_name = dict["first_name"] as? String
                            self.last_name = dict["last_name"] as? String
                            self.my_id = dict["id"] as? String
                            self.signUPType = "facebook"
                            let dic1 = dict["picture"] as! NSDictionary
                            let pic = dic1["data"] as! NSDictionary
                            self.profile_pic = pic["url"] as? String
                
                            
                            self.SignUpApi()
                            
                        }
                    }
                    
                }else{
                    
                    HomeViewController.removeSpinner(spinner: sv)
                    
                    
                }
            })
        }
        
    }
    
    // Gmail Login Method
    
    
    func GoogleApi(user: GIDGoogleUser!){
        
        let sv = HomeViewController.displaySpinner(onView: self.view)
        
        if(user.profile.email == nil || user.userID == nil || user.profile.email == "" || user.userID == ""){
            
            
            
            HomeViewController.removeSpinner(spinner: sv)
            self.alertModule(title:"Error", msg:"You cannot signup with this Google account because your Google is not linked with any email.")
            
        }else{
            
            
            HomeViewController.removeSpinner(spinner: sv)
            //SliderViewController.removeSpinner(spinner: sv)
            self.email = user.profile.email
            self.first_name = user.profile.givenName
            self.last_name = user.profile.familyName
            self.my_id = user.userID
            if user.profile.hasImage
            {
                let pic = user.profile.imageURL(withDimension: 100)
                self.profile_pic = pic!.absoluteString
                
            }else{
                self.profile_pic = ""
            }
            
            self.signUPType = "gmail"
            self.SignUpApi()
        }
        
        
    }
    
    // Signup Api
    
    func SignUpApi(){
       let  sv = HomeViewController.displaySpinner(onView: self.view)
        
        var VersionString:String! = ""
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            VersionString = version
        }
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.signUp!
        
        let parameter:[String:Any]?  = ["fb_id":self.my_id!,"first_name":self.first_name!,"last_name":self.last_name!,"profile_pic":self.profile_pic!,"gender":"m","signup_type":self.signUPType!,"version":VersionString!,"device":"iOS"]
        
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
                    
                    let myCountry = dic["msg"] as? NSArray
                    if let data = myCountry![0] as? NSDictionary{
                        print(data)
                        
                        
                        let uid = data["fb_id"] as! String
                        
                        
                        UserDefaults.standard.set(uid, forKey: "uid")
                        
                        self.inner_view.alpha = 1
                   
                        self.navigationItem.title = "Notifications"
                        
                        self.tabBarController?.selectedIndex = 3
                        
                        
                    
                        
                        
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
    
    // Gmail Login Delegate Methods
    
    @IBAction func GoogleLogin(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    
    private func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        //UIActivityIndicatorView.stopAnimating()
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            self.GoogleApi(user: user)
            
            // ...
        } else {
            
            //            self.view.isUserInteractionEnabled = true
            //            KRProgressHUD.dismiss {
            //                print("dismiss() completion handler.")
            //
            //            }
            print("\(error.localizedDescription)")
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
        
        
        
    }
    
    
    @IBAction func privacy(_ sender: Any) {
        
        guard let url = URL(string: "https://termsfeed.com/privacy-policy/9a03bedc2f642faf5b4a91c68643b1ae") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func terms(_ sender: Any) {
        
        guard let url = URL(string: "https://termsfeed.com/terms-conditions/72b8fed5b38e082d48c9889e4d1276a9") else { return }
        UIApplication.shared.open(url)
        
    }
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    @available(iOS 13.0, *)
    @IBAction func Applelogin(_ sender: Any) {
        
        self.setupAppleIDCredentialObserver()
        let appleSignInRequest = ASAuthorizationAppleIDProvider().createRequest()
         appleSignInRequest.requestedScopes = [.fullName, .email]

         let controller = ASAuthorizationController(authorizationRequests: [appleSignInRequest])
         controller.delegate = self
         controller.presentationContextProvider = self

         controller.performRequests()
    }
  @available(iOS 13.0, *)
        private func setupAppleIDCredentialObserver() {
             let authorizationAppleIDProvider = ASAuthorizationAppleIDProvider()
             authorizationAppleIDProvider.getCredentialState(forUserID: "currentUserIdentifier") { (credentialState: ASAuthorizationAppleIDProvider.CredentialState, error: Error?) in
               if let error = error {
                 print(error)
                 // Something went wrong check error state
                 return
               }
               switch (credentialState) {
               case .authorized:
                 //User is authorized to continue using your app
                 break
               case .revoked:
                 //User has revoked access to your app
                 break
               case .notFound:
                 //User is not found, meaning that the user never signed in through Apple ID
                 break
               default: break
               }
             }
           }
        
        

    }
    extension NotificationViewController: ASAuthorizationControllerDelegate {
        @available(iOS 12.0, *)
        @available(iOS 13.0, *)
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }

            print("User ID: \(appleIDCredential.user)")
            
            switch authorization.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                print(appleIDCredential)
            case let passwordCredential as ASPasswordCredential:
                print(passwordCredential)
            default: break
            }
            
            if let userEmail = appleIDCredential.email {
              print("Email: \(userEmail)")
                self.email = userEmail
                self.my_id = appleIDCredential.user
            }

            if let userGivenName = appleIDCredential.fullName?.givenName,
                
              let userFamilyName = appleIDCredential.fullName?.familyName {
                //print("Given Name: \(userGivenName)")
               // print("Family Name: \(userFamilyName)",
                    
                self.first_name = userGivenName
                self.last_name = userFamilyName
                
                
            }
            
            

            if let authorizationCode = appleIDCredential.authorizationCode,
              let identifyToken = appleIDCredential.identityToken {
              print("Authorization Code: \(authorizationCode)")
              print("Identity Token: \(identifyToken)")
              //First time user, perform authentication with the backend
              //TODO: Submit authorization code and identity token to your backend for user validation and signIn
                //self.signUp(self)
               if(self.email != ""){
                                          
                                          self.signUPType = "apple"
                                          self.profile_pic = ""
                                          self.SignUpApi()
                                      }else{
                                       
                                       self.alertModule(title:"Error", msg: "Please share your email.")
                                   }
              return
            }
            //TODO: Perform user login given User ID
            
            
            
            
          }
          
        @available(iOS 13.0, *)
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            print("Authorization returned an error: \(error.localizedDescription)")
          }
        }
        extension NotificationViewController: ASAuthorizationControllerPresentationContextProviding {
            @available(iOS 13.0, *)
            func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            return view.window!
          }
    }
