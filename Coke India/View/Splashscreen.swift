//
//  Splashscreen.swift
//  FlagOn
//
//  Created by SSDB on 8/31/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

import UIKit

class Splashscreen: UIViewController {
    
    @IBOutlet weak var cokeLogo: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
   @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        indicator.startAnimating()
        cokeLogo.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if Reachability.isConnectedToNetwork() == true {
                loadImage()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token")
            {
            
                print(token)
            let response = Api().callApi(token as NSString,url: userStatus)
                print(response)
                //if response.0 = 0 then error occurs for below line if "The requested URL can't be reached"
                let apiResponse = response.0
         switch apiResponse{
         case 200:
            
            let code = response.1
            let statusCode:Int = code.value(forKey: "Result") as! Int
           // statusCode = 7
        switch statusCode {
        case 1:
            
          self.navigateView(identifier: "Otpscreen")
        case 2:
            
         self.navigateView(identifier: "Addaddress")
        case 3:
            
            self.navigateView(identifier: "Awaitingconfirmation")
        case 4,5:
            
         self.defaultView()
        case 6:
        
        Commonhelper().showErrorMessage("Your account is locked, please contact admin for further assistance." as String,title: "Alert!")
           self.navigateView(identifier: "Signin")
        default:
            self.navigateView(identifier: "Signin")
        }
                case 400:
                    self.navigateView(identifier: "Signin")
                    print("wrong screen")
                case 500:
                    self.view.hideToastActivity()
                    Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                case 0:
                    self.view.hideToastActivity()
                    Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                default:
                     self.navigateView(identifier: "Signin")
                    print("")
                }
                
            }
            else{
                //Token doesn't exist
                self.navigateView(identifier: "Signin")
                }
            }
        }
            
        else{
            Commonhelper().showErrorMessage(internetError)
            self.view.hideToastActivity()
            
        }
    }

    func navigateView(identifier:String)
     
    {
       if #available(iOS 10.0, *) {
                        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
         let presentView : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: identifier) as UIViewController
                            self.present(presentView, animated: true, completion: nil)
            }
                    } else {
                        // Fallback on earlier versions
        let presentView : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: identifier) as UIViewController
        self.present(presentView, animated: true, completion: nil)
                    }
    }
    
    func loadImage(){
        
        
        self.indicator.stopAnimating()
        self.cokeLogo.isHidden = true
        imageView.image = UIImage(named:"splashimage")
        
        
        
//        let response = Api().callApi("",url: splashScreen)
//        if response.0 == 200{
//            let getImageresponse = response.1
//            if let image = getImageresponse["Result"] as? NSArray{
//              
//               if image.count > 0{
//                let imageUrl =   image[0]
//                print(imageUrl)
//                let url = URL(string:"\(imagePath)\(imageUrl)")
//                
//                let data = try? Data(contentsOf: url!)
//                if data != nil {
//                    self.indicator.stopAnimating()
//                    self.cokeLogo.isHidden = true
//                    imageView.image = UIImage(data:data!)
//                    
//                  }
//                }
//            }
//        }
        
    }
  
 
 func defaultView()
  {
    let defaults = UserDefaults.standard
    if let token = defaults.string(forKey: "Token")
    {
        
        let verificationStatus = Api().callApi(token as NSString,url: isPhoneVerified)
        
        switch verificationStatus.0{
        case 200:
            //tab
            let boolStatus = verificationStatus.1.value(forKey: "Result") as! Bool
            if boolStatus == true{
                let isPendingFeedBackForOrder = Api().callApi(token as NSString, url:getPendingFeedbackOrderId)
                print(isPendingFeedBackForOrder)
                switch isPendingFeedBackForOrder.0 {
                case 200:
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
                    let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = viewController
                    break
                default:
                    navigateView(identifier: "Signin")
                }
            
            }
            else{
               navigateView(identifier: "Otpscreen")
            }
        case 500:
            Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
        case 401:
            navigateView(identifier: "Signin")
        default:
           navigateView(identifier: "Signin")
        }
        
     }
  }
    
    
}
        
                        


                        
        

        




