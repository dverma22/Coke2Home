//
//  Userdetailcontainer.swift
//  FlagOn
//
//  Created by SSDB on 8/26/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

import UIKit

class Userdetailcontainer: UIViewController {


    @IBOutlet weak var FeedbackBar: UIView!
    @IBOutlet weak var profileSegment: UISegmentedControl!
    @IBOutlet weak var depositBar: UIView!
    @IBOutlet weak var addressBar: UIView!
    @IBOutlet weak var profileBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileSegment.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "GillSans", size: 13.0)! ], for: .normal)
        addressBar.isHidden = true
        depositBar.isHidden = true
        FeedbackBar.isHidden = true
        profileSegment.layer.shadowColor = UIColor.black.cgColor
        profileSegment.layer.shadowOpacity = 0.60
        profileSegment.layer.shadowOffset = CGSize.zero
        profileSegment.layer.shadowRadius = 1
        self.tabBarController?.moreNavigationController.navigationBar.isHidden = true
      }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.moreNavigationController.navigationBar.isHidden = false
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.moreNavigationController.navigationBar.isHidden = true
    }
    
    @IBAction func changeSegmentIndex(_ sender: AnyObject) {
        
        switch profileSegment.selectedSegmentIndex
        {
        case 0:
            profileBar.isHidden = false
            addressBar.isHidden = true
            depositBar.isHidden = true
            FeedbackBar.isHidden = true
        case 1:
            profileBar.isHidden = true
            addressBar.isHidden = false
            depositBar.isHidden = true
            FeedbackBar.isHidden = true
        case 2:
            depositBar.isHidden = false
            addressBar.isHidden = true
            profileBar.isHidden = true
            FeedbackBar.isHidden = true
        case 3:
            print("")
            depositBar.isHidden = true
            addressBar.isHidden = true
            profileBar.isHidden = true
            FeedbackBar.isHidden = false
        case 4:
            print("")
           
            signOut()
            
        default:
            break;
        }
    }
    
    func signOut() {
        
       
        let alertController = UIAlertController(title: "", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
        
        let saveAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: {
            alert -> Void in
            
            //need to change order id
            
            
            
        })
        
        
        let cancelAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in
            if Reachability.isConnectedToNetwork() == true {
                let defaults = UserDefaults.standard
                
                if let token = defaults.string(forKey: "Token"){
                    
                    let response = Api().callApi(token as NSString, post: "",url: logOut as NSString)
                    if response.0 == 200{
                        print(token)
                        deleteToken()
                        print(token)
                        let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                        self.present(signinScreen, animated: true, completion: nil)
                    }
                }
                else{
                    let token = defaults.string(forKey: "Token")
                    print(token)
                    print("token nil")
                }
            }
            else{
                Commonhelper().showErrorMessage(internetError)
            }
            
        })
        
        
        let subview :UIView = alertController.view.subviews.last! as UIView
        let alertContentView = subview.subviews.last! as UIView
        alertContentView.backgroundColor = UIColor.white
        alertController.view.tintColor = UIColor.red
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

}


