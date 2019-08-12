//
//  Signup.swift
//  FlagOn
//
//  Created by SSDB on 7/2/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

import UIKit
import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l >= r
    default:
        return !(lhs < rhs)
    }
}

class Signup: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var ageRestrictionSwitch: UISwitch!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var mobileErrorMessage: UILabel!
    @IBOutlet weak var passwordErrorMessage: UILabel!
    @IBOutlet weak var nameErrorMessage: UILabel!
    @IBOutlet weak var emailErrorMessage: UILabel!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var SignupView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var selectedField = ""
    var toggleState = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mobile.delegate = self
        password.delegate = self
        email.delegate = self
        name.delegate = self
        let errorMessageLables = [nameErrorMessage,passwordErrorMessage,mobileErrorMessage,emailErrorMessage]
        Commonhelper().labelCornerRadius(errorMessageLables as! [UILabel])
        Commonhelper().hideLabels(errorMessageLables as! [UILabel])
        textFields = [name,email,mobile,password]
        placeholdersText = ["Full Name","Email","Mobile Number","Set Password"]
        Commonhelper().addBorderToTextField(textFields,color: "white")
        Commonhelper().textFieldPlaceholder(textFields,placeholdersText: placeholdersText)
        mobile.keyboardType = UIKeyboardType.numberPad
        email.keyboardType = .emailAddress
        password.isSecureTextEntry = true
        //Commonhelper().buttonCornerRadius(signUp)
        Commonhelper().removeAutoSuggestion(textFields)
        Commonhelper().createPrefixLabel(textField: mobile)
        textFields = [name,email,password]
        Commonhelper().paddingView(textFields)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Signup.handleTap(_:)))
        SignupView.addGestureRecognizer(tapGesture)
        ageRestrictionSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        ageRestrictionSwitch.setOn(false, animated: false)
        ageRestrictionSwitch.tintColor = UIColor.white
        ageRestrictionSwitch.onTintColor = UIColor.white
        ageRestrictionSwitch.thumbTintColor = UIColor.red
    }
    
    
    @IBAction func signUP(_ sender: AnyObject) {
        
        
        let fullNameValue:NSString = name.text! as NSString
        let emailValue:NSString = email.text! as NSString
        let mobileValue:NSString = mobile.text! as NSString
        let passwordValue:NSString = password.text! as NSString
        let trimmedMobile = mobileValue.replacingOccurrences(of: " ", with: "")
        
        if validateName(name.text!) == false{
            nameErrorMessage.isHidden = false
            Commonhelper().animateObject(name)
        }
            
        else if validateEmail(email.text!) == false{
            
            emailErrorMessage.isHidden = false
            Commonhelper().hideLabels([nameErrorMessage])
            Commonhelper().animateObject(email)
        }
        else if !((trimmedMobile.length) == 7)
        {
            mobileErrorMessage.isHidden = false
            Commonhelper().hideLabels([emailErrorMessage,nameErrorMessage])
            Commonhelper().animateObject(mobile)
        }
        else if !(((password.text?.length)! >= 6) && ((password.text?.length)! < 20))
        {
            passwordErrorMessage.isHidden = false
            Commonhelper().hideLabels([emailErrorMessage,nameErrorMessage,mobileErrorMessage])
            Commonhelper().animateObject(password)
        }
        else if (ageRestrictionSwitch.isOn == false)
        {
           self.view.makeToast("Make sure you are over 18 years old.")
        }
        else
        {
            self.view.makeToastActivity(.center)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                let post:NSString = "FullName=\(fullNameValue)&Email=\(emailValue)&Mobile=\(mobileValue)&Password=\(passwordValue)&ConfirmPassword=\(passwordValue)&Source=\(1)" as NSString
                print(post)
                if Reachability.isConnectedToNetwork() == true {
                    
                    let signupResponse = Api().postApiResponse("", url: register as NSString, post: post, method: "POST")
                    
                    switch signupResponse.0{
                    case 200:
                        let grantType = "password"
                        let tokenData = "UserName=\(emailValue)&Password=\(passwordValue)&grant_type=\(grantType)"
                        let getTokenResponse = Api().postApiResponse("", url: login as NSString, post: tokenData as NSString, method: "POST")
                        let token:NSString = getTokenResponse.1.value(forKey: "access_token") as! NSString
                        if token != NSNull() && (token).length > 0 && getTokenResponse.0 == 200
                        {
                            storeSignupData(token as String,mobile: mobileValue as String)
                            self.sendDeviceToken()
                            //self.generateVerifyCode()
                            let otpVerificationScreen : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Otpscreen") as UIViewController
                            self.present(otpVerificationScreen, animated: true, completion: nil)
                        }
                        else{
                            //Token not generated
                            let loginError:NSString = getTokenResponse.1.value(forKey: "error_description") as! NSString
                            Commonhelper().showErrorMessage(loginError as String)
                        }
                    case 400:
                        
                        self.view.hideToastActivity()
                        let errors:NSArray = signupResponse.1.value(forKey: "Errors") as! NSArray
                        for error in errors{
                            Commonhelper().showErrorMessage(error as! String)
                        }
                    case 401:
                        
                        let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                        self.present(signinScreen, animated: true, completion: nil)
                    case 500:
                        
                        self.view.hideToastActivity()
                        Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                    case 0:
                        Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                    default:
                        print("")
                    }
                }
                    
                else{
                    
                    Commonhelper().showErrorMessage(internetError)
                }
            }
        }
        
    }
    
    @IBAction func ageRestrictionSwitchChanged(_ sender: AnyObject) {
//     if sender.isOn == false{
//        print("off")
//        self.view.makeToast("Make sure you are over 18 years old.")
//        signupButton.isUserInteractionEnabled = false
//        
//        }
//     else{
//        signupButton.isUserInteractionEnabled = true
//        print("on")
//        }
    
    }
    func sendDeviceToken(){
        let defaults = UserDefaults.standard
        
        if let token = defaults.string(forKey: "Token"){
            if let deviceToken = UserDefaults.standard.string(forKey: "tokenForFirebase"){
                let tokenForFCM = "DeviceType=\(1)&DeviceId=\(deviceToken)"
                let deviceTokenResponse = Api().postApiResponse(token as NSString, url: addDevice as NSString, post: tokenForFCM as NSString, method: "POST")
                print(deviceTokenResponse)
                print("devicetoken")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    @IBAction func signInAction(_ sender: AnyObject) {
        
        let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
        self.present(signinScreen, animated: true, completion: nil)
    }
    
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        SignupView.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func generateVerifyCode(){
        
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "Token")
        {
            let otpStatus = Api().callApi(token as NSString,url: generateOtp)
            print(otpStatus)
            let errors:NSArray = otpStatus.1.value(forKey: "Errors") as! NSArray
            if otpStatus.0 == 200 && errors.count == 0{
                
                let otpVerificationScreen : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Otpscreen") as UIViewController
                self.present(otpVerificationScreen, animated: true, completion: nil)
            }
            else{
                
                for error in errors{
                    Commonhelper().showErrorMessage(error as! String)
                }
            }
        }
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == name{
            clearTextField(placeholder: "Full Name",textField: name,errorLabel: nameErrorMessage)
        }
        if textField == email{
            clearTextField(placeholder: "Email",textField: email,errorLabel: emailErrorMessage)
        }
        if textField == mobile{
            clearTextField(placeholder: "Mobile Number",textField: mobile,errorLabel: mobileErrorMessage)
        }
        if textField == password{
            clearTextField(placeholder: "Set Password",textField: password,errorLabel: passwordErrorMessage)
            
        }
        
    }
    
    func clearTextField(placeholder:String,textField:UITextField,errorLabel:UILabel){
        
        placeholdersText = [placeholder]
        textFields = [textField]
        Commonhelper().addBorderToTextField(textFields,color: "")
        Commonhelper().textFieldPlaceholder(textFields,placeholdersText: placeholdersText)
        errorLabel.isHidden = true
        Commonhelper().textFieldPlaceholder(textFields,placeholdersText: placeholdersText)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textFields = [textField]
        Commonhelper().addBorderToTextField(textFields,color: "white")
    }
    
    @IBAction func passwordSecureEntry(_ sender: AnyObject) {
        
        if toggleState == 1
        {
            toggleState = 2
            password.isSecureTextEntry = false
            
        }
        else{
            toggleState = 1
            password.isSecureTextEntry = true
        }
        
    }
}

