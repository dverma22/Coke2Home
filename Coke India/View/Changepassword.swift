//
//  Changepassword.swift
//  Coke
//
//  Created by SSDB on 9/15/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

import UIKit

class Changepassword: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oldPassword.delegate = self
        newPassword.delegate = self
        textFields = [oldPassword,newPassword]
        placeholdersText = ["Old Password","New Password"]
       // Commonhelper().addBorderLineToTextField(textFields)
        createchangePasswordButton()
        Commonhelper().textFieldPlaceholder(textFields,placeholdersText: placeholdersText)
    
    }
    
    func createchangePasswordButton(){
        
        let changePasswordButton = UIButton(frame: CGRect(x: self.view.bounds.origin.x + (self.view.bounds.width * 0.325), y: self.view.bounds.origin.y + (self.view.bounds.height * 0.6), width: self.view.bounds.origin.x + (self.view.bounds.width * 0.35), height: self.view.bounds.origin.y + (self.view.bounds.height * 0.05)))
        changePasswordButton.layer.cornerRadius = 18.0
        changePasswordButton.layer.borderWidth = 2.0
        changePasswordButton.backgroundColor = UIColor.red
        changePasswordButton.layer.borderColor = UIColor.white.cgColor
        changePasswordButton.setTitle("Change Password", for: UIControl.State())
        changePasswordButton.setTitleColor(UIColor(red: 24.0/100, green: 116.0/255, blue: 205.0/205, alpha: 1.0), for: UIControl.State())
        changePasswordButton.titleLabel!.font =  UIFont(name: "Arial", size: 12)
        self.view.addSubview(changePasswordButton)
        
        changePasswordButton.addTarget(self, action: #selector(Changepassword.changePasswordAction(_:)), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func changePasswordAction(_ sender: UIButton!){
        
        let oldPass = oldPassword.text!
        let newPass = newPassword.text!
        if (oldPass.length == 0) {
            Commonhelper().animateAndRequired(oldPassword,errorMeaage: "Old Password")
            
        }
        else if(newPass.length == 0){
            Commonhelper().animateAndRequired(newPassword,errorMeaage: "New Password")
        }
        else
        {
            let postData = "OldPassword=\(oldPass)&NewPassword=\(newPass)&ConfirmPassword=\(newPass)"
            if Reachability.isConnectedToNetwork() == true {
                let defaults = UserDefaults.standard
                
                if let token = defaults.string(forKey: "Token"){
                let response = Api().postApiResponse(token as NSString, url: "Account/ChangePassword", post: postData as NSString, method: "POST")
                let errors:NSArray = response.1.value(forKey: "Errors") as! NSArray
                
                if response.0 == 200 && errors.count == 0{
                    print("sucessfully changed")
                }
                    
                else{
                    for error in errors{
                        Commonhelper().showErrorMessage(error as! String)
                    }
                }
                }
            }
                
            else{
                Commonhelper().showErrorMessage(internetError)
            }
            
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            
            if textField == oldPassword{
                placeholdersText = ["Old Password"]
                textFields = [oldPassword]
                Commonhelper().textFieldPlaceholder(textFields,placeholdersText: placeholdersText)
            }
            if textField == newPassword{
                placeholdersText = ["New Password"]
                textFields = [newPassword]
                Commonhelper().textFieldPlaceholder(textFields,placeholdersText: placeholdersText)
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
}
