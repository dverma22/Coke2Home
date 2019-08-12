//
//  Setpassword.swift
//  Coke
//
//  Created by SSDB on 9/15/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

import UIKit

class Setpassword: UIViewController {
    
    @IBOutlet weak var newPassword: UITextField!
    
    override func viewDidLoad() {
        
        textFields = [newPassword]
        placeholdersText = ["Old Password"]
        //use correct method to show borderColor
        //Commonhelper().addBorderLineToTextField(textFields)
        Commonhelper().textFieldPlaceholder(textFields,placeholdersText: placeholdersText)
        createSetPasswordButton()
    
    }
    
    func createSetPasswordButton(){
        
        let changePasswordButton = UIButton(frame: CGRect(x: self.view.bounds.origin.x + (self.view.bounds.width * 0.325), y: self.view.bounds.origin.y + (self.view.bounds.height * 0.6), width: self.view.bounds.origin.x + (self.view.bounds.width * 0.35), height: self.view.bounds.origin.y + (self.view.bounds.height * 0.05)))
        changePasswordButton.layer.cornerRadius = 18.0
        changePasswordButton.layer.borderWidth = 2.0
        changePasswordButton.backgroundColor = UIColor.red
        changePasswordButton.layer.borderColor = UIColor.white.cgColor
        changePasswordButton.setTitle("Set Password", for: UIControl.State())
        changePasswordButton.setTitleColor(UIColor(red: 24.0/100, green: 116.0/255, blue: 205.0/205, alpha: 1.0), for: UIControl.State())
        changePasswordButton.titleLabel!.font =  UIFont(name: "Arial", size: 12)
        self.view.addSubview(changePasswordButton)
        
        changePasswordButton.addTarget(self, action: #selector(Setpassword.setPasswordAction(_:)), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func setPasswordAction(_ sender: UIButton!){
        
        let newPass = newPassword.text!
        if newPass.isEmpty{
            let alert = UIAlertController(title: "Alert", message: "Please enter New Password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
            let postData = "NewPassword=\(newPass)&ConfirmPassword=\(newPass)"
            if Reachability.isConnectedToNetwork() == true {
                let defaults = UserDefaults.standard
                if let token = defaults.string(forKey: "Token"){
                
                    let response = Api().postApiResponse(token as NSString, url: "Account/SetPassword", post: postData as NSString, method: "POST")
                let errors:NSArray = response.1.value(forKey: "Errors") as! NSArray
                if response.0 == 200 && errors.count == 0 {
                    print("Done")
                }
                else{
                    for error in errors{
                        Commonhelper().showErrorMessage(error as! String)
                    }
                    
                }
                }
            }
            else{
                Commonhelper().showErrorMessage("Something went wrong. Please check your Internet connection.")
            }
        }
    }

}
