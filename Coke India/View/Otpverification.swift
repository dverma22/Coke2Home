//
//  Otpverification.swift
//  FlagOn
//
//  Created by SSDB on 7/3/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

import UIKit
class Otpverification: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var otp: UITextField!
    @IBOutlet weak var wrongOtpLabel: UILabel!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet var verifyOtpView: UIView!
    @IBOutlet weak var wrongOtpImage: UIImageView!
    @IBOutlet weak var textFieldBottomLine: UIView!
    var mobileNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFields = [otp,mobile]
        self.otp.delegate = self
        placeholdersText = ["Enter Code","Mobile"]
        Commonhelper().textFieldPlaceholder(textFields,placeholdersText: placeholdersText)
        Commonhelper().removeAutoSuggestion(textFields)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Otpverification.handleTap(_:)))
        verifyOtpView.addGestureRecognizer(tapGesture)
        wrongOtpLabel.isHidden = true
        Commonhelper().addBorderToTextField(textFields,color: "white")
        Commonhelper().createPrefixLabel(textField: mobile)
        otp.keyboardType = UIKeyboardType.numberPad
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "Token"){
            let response = Api().callApi(token as NSString, url: userInfo)
            
            switch response.0{
            case 200:
                let userDetails = (response.1).value(forKey: "Result") as! NSDictionary
                for (key, value) in userDetails {
                    
                    if key as! String == "Phone" {
                        mobile.text = value as? String
                        mobileNumber = (value as? String)!
                    }
                }
                Commonhelper().showErrorMessage("OTP sent to registered mobile number." as String,title: "Alert!")
                
            case 401:
                let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                self.present(signinScreen, animated: true, completion: nil)
            case 500:
                Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
            case 0:
                Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
            default:
                print("")
            }
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == otp{
            textFields = [otp]
            Commonhelper().addBorderToTextField(textFields,color: "white")
        }
        if textField == mobile{
            textFields = [mobile]
            Commonhelper().addBorderToTextField(textFields,color: "white")
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)  {
        
        if textField == otp{
            placeholdersText = ["Enter Code"]
            textFields = [otp]
            textFieldBottomLine.isHidden = true
            Commonhelper().addBorderToTextField(textFields,color: "")
            Commonhelper().textFieldPlaceholder(textFields,placeholdersText: placeholdersText)
        }
        if textField == mobile{
            textFields = [mobile]
            Commonhelper().addBorderToTextField(textFields,color: "")
            updateNumber()
            
        }
    }
    
    func updateNumber(){
        
        let alertController = UIAlertController(title: "Enter new number", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let saveAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: {
            alert -> Void in
            
            let numberTextbox = alertController.textFields![0] as UITextField
            
            if (numberTextbox.text?.length)! == 7{
                let post:NSString = "Mobile=\(numberTextbox.text!)" as NSString
                
                if Reachability.isConnectedToNetwork() == true {
                    let defaults = UserDefaults.standard
                    if let token = defaults.string(forKey: "Token"){
                        let response = Api().postApiResponse(token as NSString, url: updateMobile as NSString, post: post, method: "POST")
                        if let errors:NSArray = response.1.value(forKey: "Errors") as! NSArray?{
                            if response.0 == 200 && errors.count == 0{
                                print(numberTextbox.text)
                                self.mobile.text = numberTextbox.text
                                alertController.dismiss(animated: true, completion: nil)
                            }
                            else{
                                for error in errors{
                                    Commonhelper().showErrorMessage(error as! String)
                                }
                            }
                        }
                    }
                    else{
                        let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                        self.present(signinScreen, animated: true, completion: nil)
                    }
                }
                else{
                    Commonhelper().showErrorMessage(internetError)
                }
                
                
            }
            else{
                self.view.makeToast("Invalid mobile number.")
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "(+960) New phone number(Max-7 characters)"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        let subview :UIView = alertController.view.subviews.last! as UIView
        let alertContentView = subview.subviews.last! as UIView
        alertContentView.backgroundColor = UIColor.white
        alertController.view.tintColor = UIColor.red
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        verifyOtpView.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func verifyOtp(_ sender: AnyObject) {
        
        wrongOtpLabel.isHidden = true
        let otpNumber:String = (otp.text!).replacingOccurrences(of: " ", with: "")
        let verificationData = "Code=\(otpNumber)&PhoneNumber=\(mobile.text!)"
        
        if otpNumber.length != 0{
            
            if Reachability.isConnectedToNetwork() == true {
                let defaults = UserDefaults.standard
                if let token = defaults.string(forKey: "Token"){
                    self.view.makeToastActivity(.center)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        let getVerificationResponse = Api().postApiResponse(token as NSString, url: verifyNumber as NSString, post: verificationData as NSString, method: "POST")
                        
                        switch getVerificationResponse.0{
                        case 200:
                            UserDefaults.standard.setValue(otpNumber, forKey: "mobileNumber")
                            self.getPhoneVerificationStatus()
                            
                        case 400:
                            
                            self.view.hideToastActivity()
                            
                            let errors:NSArray = getVerificationResponse.1.value(forKey: "Errors")! as AnyObject as! NSArray
                            for error in errors{
                                Commonhelper().showErrorMessage(error as! String)
                            }
                            self.wrongOtpLabel.isHidden = true
                        case 401:
                            
                            let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                            self.present(signinScreen, animated: true, completion: nil)
                            
                        case 500:
                            print(token)
                            Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                            self.view.hideToastActivity()
                        case 0:
                            Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                        default:
                            print("")
                        }
                        
                    }
                }
                else{
                    let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                    self.present(signinScreen, animated: true, completion: nil)
                }
            }
            else
            {
                Commonhelper().showErrorMessage(internetError)
                
            }
        }
        else{
            otp.attributedPlaceholder = NSAttributedString(string:"Required",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            Commonhelper().animateObject(otp)
        }
        self.view.hideToastActivity()
    }
    
    func defaultView()
    {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = viewController
        
    }
    
    @IBAction func resendOtp(_ sender: AnyObject) {
        
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token"){
                self.view.makeToastActivity(.center)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    let otpStatus = Api().callApi(token as NSString,url: generateOtp)
                    switch otpStatus.0{
                    case 200:
                        Commonhelper().showErrorMessage("OTP sent to registered mobile number." as String,title: "Alert!")
                    case 401:
                        
                        let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                        self.present(signinScreen, animated: true, completion: nil)
                    case 500:
                        
                        Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                    case 0:
                        Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                    default:
                        print("")
                    }
                }
            }
            else{
                let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                self.present(signinScreen, animated: true, completion: nil)
            }
        }
        else
        {
            Commonhelper().showErrorMessage(internetError)
        }
        self.view.hideToastActivity()
    }
    
    func getPhoneVerificationStatus(){
        
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "Token"){
            
            
            let verificationStatus = Api().callApi(token as NSString,url: isPhoneVerified)
            
            switch verificationStatus.0{
            case 200:
                //tab
                let boolStatus = verificationStatus.1.value(forKey: "Result") as! Bool
                if boolStatus == true{
                    
                    let response = Api().callApi(token as NSString,url: userStatus)
                    print(response)
                    
                    //if response.0 = 0 then error occurs for below line if "The requested URL can't be reached"(check api status like splash screen
                    let code = response.1
                    let statusCode:Int = code.value(forKey: "Result") as! Int
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
    
    func navigateView(identifier:String)
    {
        
        let presentView : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: identifier) as UIViewController
        self.present(presentView, animated: true, completion: nil)
        
    }
    
    @IBAction func changeNumber(_ sender: AnyObject) {
        updateNumber()
    }
}






