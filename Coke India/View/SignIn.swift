//
//  SignIn.swift
//  Coke
//
//  Created by SSDB on 7/2/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

import UIKit
import Toast_Swift

class SignIn: UIViewController, UITextFieldDelegate {
    
   
    @IBOutlet var signinView: UIView!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var signinContainer: UIView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    var toggleState = 1
    var nextButton:UIButton!
    var backButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.username.delegate = self
        self.password.delegate = self
        textFields = [username,password]
        Commonhelper().addBorderToTextField(textFields,color: "white")
        placeholdersText = ["Email","Password"]
        Commonhelper().textFieldPlaceholder(textFields,placeholdersText: placeholdersText)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignIn.handleTap(_:)))
        signinView.addGestureRecognizer(tapGesture)
        password.isSecureTextEntry = true
        Commonhelper().paddingView([username,password])
        Commonhelper().removeAutoSuggestion(textFields)
       
    }
    
   
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        signinView.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signIn(_ sender: AnyObject) {
       // let alert = UIAlertController(title: UserDefaults.standard.string(forKey: "tokenForFirebase"), message: "This is my message.", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        //alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        //self.present(alert, animated: true, completion: nil)
        let usernameValue:NSString = (username.text! as NSString).replacingOccurrences(of: " ", with: "") as NSString
        let passwordValue:NSString = (password.text! as NSString).replacingOccurrences(of: " ", with: "") as NSString
        
        if validateEmail(usernameValue as String) == false {
            username.text = ""
            username.attributedPlaceholder = NSAttributedString(string:"Check email format.",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            Commonhelper().animateObject(username)
        }
        else if !(((passwordValue.length) >= 6) && ((passwordValue.length) <= 20)){
            password.text = ""
            password.attributedPlaceholder = NSAttributedString(string:"Should be 6-20 characters.",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            Commonhelper().animateObject(password)
        }
        else
        {
            if Reachability.isConnectedToNetwork() == true {
                self.view.makeToastActivity(.center)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                    let grantType = "password"
                    let tokenData = "UserName=\(usernameValue)&Password=\(passwordValue)&grant_type=\(grantType)"
                    
                    let getTokenResponse = Api().postApiResponse("", url: login as NSString, post: tokenData as NSString, method: "POST")
                    
                    if getTokenResponse.0 == 200{
                        let token:NSString = getTokenResponse.1.value(forKey: "access_token") as! NSString
                        
                        updateToken(token as String)
                        
                        let defaults = UserDefaults.standard
                        print(defaults.string(forKey: "Token"))
                        if let token = defaults.string(forKey: "Token"){
                            let response = Api().callApi(token as NSString,url: userStatus)
                            self.sendDeviceToken(token: token)
                          
                            print(response)
                            switch response.0{
                            case 200:
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
                                    self.view.hideToastActivity()
                                    Commonhelper().showErrorMessage("Your account is locked, please contact admin for further assistance." as String,title: "Alert!")
                                    self.navigateView(identifier: "Signin")
                                default:
                                    self.view.hideToastActivity()
                                    self.navigateView(identifier: "Signin")
                                }
                            case 400:
                                
                                print("token issue")
                            case 500:
                                self.view.hideToastActivity()
                                Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                            case 0:
                                self.view.hideToastActivity()
                                Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                            default:
                                print("default")
                            }
                        }
                    }
                    else{
                        self.view.hideToastActivity()
                        let loginError:NSString = getTokenResponse.1.value(forKey: "error_description") as! NSString
                        Commonhelper().showErrorMessage(loginError as String)
                    }
                }
            }
                
            else{
                Commonhelper().showErrorMessage(internetError)
            }
        }
    }
   
    func sendDeviceToken(token:String){
        if let deviceToken = UserDefaults.standard.string(forKey: "tokenForFirebase"){
            let tokenForFCM = "DeviceType=\(1)&DeviceId=\(deviceToken)"
            let deviceTokenResponse = Api().postApiResponse(token as NSString, url: addDevice as NSString, post: tokenForFCM as NSString, method: "POST")
            print(deviceTokenResponse)
            //Commonhelper().showErrorMessage(deviceToken as String,title: errorTitle)
             //Commonhelper().showErrorMessage(String(deviceTokenResponse.0 )as String,title: errorTitle)
            print("devicetoken")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        self.view.hideToastActivity()
    }
    
    func navigateView(identifier:String)
    {
            // Fallback on earlier versions
            let presentView : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: identifier) as UIViewController
            self.present(presentView, animated: true, completion: nil)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textFields = [textField]
        Commonhelper().addBorderToTextField(textFields,color: "white")
   
    }
        
    func textFieldDidBeginEditing(_ textField: UITextField)  {
            
            if textField == username{
                placeholdersText = ["Email"]
                textFields = [username]
                Commonhelper().addBorderToTextField(textFields,color: "")
            Commonhelper().textFieldPlaceholder(textFields,placeholdersText: placeholdersText)
            }
            if textField == password{
                placeholdersText = ["Password"]
                textFields = [password]
                Commonhelper().addBorderToTextField(textFields,color: "")
                Commonhelper().textFieldPlaceholder(textFields,placeholdersText: placeholdersText)
            
            }
        }
    
    @IBAction func forgotPassword(_ sender: AnyObject) {
        self.view.makeToastActivity(.center)
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
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
                    let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = viewController
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


