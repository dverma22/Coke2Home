//
//  Profilebar.swift
//  FlagOn
//
//  Created by IOS SSDB on 8/4/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

import UIKit

class Profilebar: UIViewController,UITextFieldDelegate{
    
    @IBOutlet var Profileview: UIView!
    var datePicker: UIDatePicker = UIDatePicker()
    var selectedField = ""
    var userName: UITextField!
    var mobileNumber: UITextField!
    var emailId: UITextField!
    var dateOfBirth: UITextField!
    var dateOfAnniversary: UITextField!
    var tinNumber: UITextField!
    var nid: UITextField!
    var save:UIButton!
    var cancel:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createProfileView()
        dateOfAnniversary.delegate = self
        dateOfBirth.delegate = self
        Commonhelper().paddingView(textFields)
        createDatePicker()
        Commonhelper().createPrefixCountryCode(textField: mobileNumber)
        //datePicker.maximumDate = Date()
         mobileNumber.keyboardType = UIKeyboardType.numberPad
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Profilebar.handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Reachability.isConnectedToNetwork() == true {
            getUserInfo()
        }
        else
        {
            Commonhelper().showErrorMessage(internetError)
        }
    }
    
    @objc func donePressed(_ sender: UIBarButtonItem) {
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        if selectedField == "dateOfBirth"{
            dateOfBirth.text = selectedDate
            datePicker.isHidden = true
            dateOfBirth.resignFirstResponder()
        }
        if selectedField == "dateOfAnniversary"{
             dateOfAnniversary.text = selectedDate
            datePicker.isHidden = true
            dateOfAnniversary.resignFirstResponder()
        }
        
    }
    
    @objc func cancelPressed(_ sender: UIBarButtonItem) {
        
       if selectedField == "dateOfBirth"{
            dateOfBirth.text = ""
            datePicker.isHidden = true
            dateOfBirth.resignFirstResponder()
        }
        if selectedField == "dateOfAnniversary"{
            dateOfAnniversary.text = ""
            datePicker.isHidden = true
            dateOfAnniversary.resignFirstResponder()
        }
        
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == dateOfBirth{
            
            selectedField = "dateOfBirth"
            datePicker.isHidden = false
            let result = ageRestrict()
            datePicker.maximumDate = result
            let min = ageRestrictFromCustomDate(customDate: Date(),value: -500)
            datePicker.minimumDate = min
            placeholdersText = ["Date Of Birth"]
            textFields = [dateOfBirth]
            Commonhelper().textFieldPlaceholderProfile(textFields,placeholdersText: placeholdersText)
            Commonhelper().addBorderToTextField(textFields,color: "")
        }
        if textField == dateOfAnniversary{
            selectedField = "dateOfAnniversary"
            if !((dateOfBirth.text?.isEmpty)!){
                let date = stringToDate(dateString: dateOfBirth.text!)
                
                let customDate = ageRestrictFromCustomDate(customDate: date,value: +18)
                 datePicker.minimumDate = customDate
                let maxDOA = ageRestrictFromCustomDate(customDate: Date(),value: +500)
                datePicker.maximumDate = maxDOA
            }

            datePicker.isHidden = false
            placeholdersText = ["Date Of Anniversary"]
            textFields = [dateOfAnniversary]
            Commonhelper().textFieldPlaceholderProfile(textFields,placeholdersText: placeholdersText)
            Commonhelper().addBorderToTextField(textFields,color: "")
        }
        if textField == userName{
            selectedField = "userName"
            datePicker.isHidden = false
            placeholdersText = ["User Name"]
            textFields = [userName]
            Commonhelper().textFieldPlaceholderProfile(textFields,placeholdersText: placeholdersText)
            Commonhelper().addBorderToTextField(textFields,color: "")
        }
        if textField == nid{
            
            datePicker.isHidden = false
            placeholdersText = ["Enter NID"]
            textFields = [nid]
            Commonhelper().textFieldPlaceholderProfile(textFields,placeholdersText: placeholdersText)
            Commonhelper().addBorderToTextField(textFields,color: "")
        }
        if textField == tinNumber{
            
            datePicker.isHidden = false
            placeholdersText = ["Enter Tin Number"]
            textFields = [tinNumber]
            Commonhelper().textFieldPlaceholderProfile(textFields,placeholdersText: placeholdersText)
            Commonhelper().addBorderToTextField(textFields,color: "")
        }
        if textField == mobileNumber{
            
            datePicker.isHidden = false
            placeholdersText = ["Enter Mobile Number"]
            textFields = [mobileNumber]
            Commonhelper().textFieldPlaceholderProfile(textFields,placeholdersText: placeholdersText)
            Commonhelper().addBorderToTextField(textFields,color: "")
        }
        
    }
    
    func ageRestrict()-> Date{
        let date = Calendar.current.date(byAdding: .year, value: -18, to: Date())
         return date!
        
    }
    
    func ageRestrictFromCustomDate(customDate:Date,value:Int)-> Date{
        let date = Calendar.current.date(byAdding: .year, value: +value, to: customDate)
        return date!
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textFields = [textField]
        Commonhelper().addBorderToTextField(textFields,color: "red")
        if textField == dateOfAnniversary{
            datePicker.resignFirstResponder()
        }
    }
    
    func stringToDate(dateString:String) -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        return (date!)
    }
    
    func createProfileView(){
        
        let screenSize: CGRect = UIScreen.main.bounds
        userName = UITextField(frame: CGRect(x: screenSize.width*0.12, y: screenSize.height*0.12, width: screenSize.width*0.8, height: 30))
        
        mobileNumber = UITextField(frame: CGRect(x: screenSize.width*0.12, y: screenSize.height*0.18, width: screenSize.width*0.8, height: 30))
        
        tinNumber = UITextField(frame: CGRect(x: screenSize.width*0.12, y: screenSize.height*0.24, width: screenSize.width*0.8, height: 30))
        
        nid = UITextField(frame: CGRect(x: screenSize.width*0.12, y: screenSize.height*0.30, width: screenSize.width*0.8, height: 30))
        
        emailId = UITextField(frame: CGRect(x: screenSize.width*0.12, y: screenSize.height*0.36, width: screenSize.width*0.8, height: 30))
        
        dateOfBirth = UITextField(frame: CGRect(x: screenSize.width*0.12, y: screenSize.height*0.42, width: screenSize.width*0.8, height: 30))
        
        dateOfAnniversary = UITextField(frame: CGRect(x: screenSize.width*0.12, y: screenSize.height*0.48, width: screenSize.width*0.8, height: 30))
        
        emailId.isUserInteractionEnabled = false
        
        textFields = [userName,mobileNumber,nid,tinNumber,emailId,dateOfBirth,dateOfAnniversary]
        
        placeholdersText = ["User Name","Enter Mobile Number","Enter NID","Enter Tin Number","Enter Email","Date Of Birth","Date Of Anniversary"]
        Commonhelper().textFieldPlaceholderProfile(textFields,placeholdersText: placeholdersText)
        
        Commonhelper().addBorderToTextField(textFields,color: "red")
        textFieldStyle(textFields as [UITextField])
        save = UIButton()
        cancel = UIButton()
        save.frame = CGRect(x: screenSize.width*0.65, y: screenSize.height*0.63, width: 90, height: 30)
        
         cancel.frame = CGRect(x: screenSize.width*0.15, y: screenSize.height*0.63, width: 90, height: 30)
        cancel.backgroundColor = UIColor.black
        save.backgroundColor = UIColor.red
        save.setTitle("Update", for: UIControl.State())
        cancel.setTitle("Cancel", for: UIControl.State())
        Commonhelper().buttonCornerRadius(cancel)
        Commonhelper().buttonCornerRadius(save)
        save.addTarget(self, action:#selector(self.saveButtonAction(_:)), for: .touchUpInside)
        cancel.addTarget(self, action:#selector(self.cancelButtonAction(_:)), for: .touchUpInside)
        self.view.addSubview(cancel)
        self.view.addSubview(save)
        
    }
    
    func textFieldStyle(_ fieldList : [UITextField]) {
        
        for textField in fieldList{
            textField.autocorrectionType = .no
            textField.backgroundColor = UIColor.clear
            textField.borderStyle = UITextField.BorderStyle.none
            textField.font = UIFont(name: "Gill Sans", size: 13)!
            textField.keyboardType = UIKeyboardType.default
            textField.textColor = UIColor.black
            textField.delegate = self
            self.view.addSubview(textField)
        }
        
    }
    
    func createDatePicker(){
        
        let inputView = UIView(frame: CGRect(x: 0,y: 0, width: self.view.frame.width, height: 200))
        let size = Commonhelper().countScreenSize()
        var xAxisPosition = CGFloat(0)
        if size.width == 320.0{
            xAxisPosition = CGFloat(0)
            print(xAxisPosition)
        }
        else{
            xAxisPosition = CGFloat((size.width-320)/2)
        }
        datePicker = UIDatePicker(frame: CGRect(x: xAxisPosition, y: 40, width: 0, height: 0))
        datePicker.backgroundColor = UIColor.white
        inputView.addSubview(datePicker)
        datePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MMM dd"
        let doneButton = UIButton(frame: CGRect(x: size.width*0.12, y: 0, width: 70, height: 50))
        doneButton.setTitleColor(UIColor.black, for: UIControl.State())
        doneButton.setTitle("Done", for: UIControl.State())
        inputView.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(Profilebar.donePressed(_:)), for: .touchUpInside)
       // (self.view.frame.size.width/4)
        let cancelButton = UIButton(frame: CGRect(x: size.width*0.70, y: 0, width: 70, height: 50))
        cancelButton.setTitleColor(UIColor.black, for: UIControl.State())
        cancelButton.setTitle("Cancel", for: UIControl.State())
        //cancelButton.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(Profilebar.cancelPressed(_:)), for: .touchUpInside)
        inputView.addSubview(cancelButton)
        dateOfBirth.inputView = inputView
        dateOfAnniversary.inputView = inputView
        
    }
    
    func getUserInfo(){
        
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "Token"){
            
            let response = Api().callApi(token as NSString, url: userInfo)
            if response.0 == 200{
                let userDetails = (response.1).value(forKey: "Result") as! NSDictionary
                for (key, value) in userDetails {
                    print("key \(key) value2 \(value)")
                    if key as! String == "Email"{
                        emailId.text = value as? String
                    }
                    if key as! String == "FullName"{
                        userName.text = value as? String
                    }
                    if key as! String == "Phone" {
                        mobileNumber.text = value as? String
                    }
                    if key as! String == "DOB" {
                        if (value as AnyObject?) != nil{
                            let dobSplitted = (value as? String)?.trimmingCharacters(in: .whitespaces).components(separatedBy: "T")
                            dateOfBirth.text = dobSplitted?[0]
                        }
                    }
                    if key as! String == "DOA"{
                        if (value as AnyObject?) != nil{
                            let doaSplitted = (value as? String)?.trimmingCharacters(in: .whitespaces).components(separatedBy: "T")
                            dateOfAnniversary.text = doaSplitted?[0]
                        }
                        
                    }
                    
                    if key as! String == "CustomerTINNumber"{
                        tinNumber.text = value as? String
                    }
                    if key as! String == "NationalIdNumber"{
                        nid.text = value as? String
                    }
                }
            }
            else{
                if response.0 == 401{
                    //Token not valid
                    let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                    self.present(signinScreen, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func cancelButtonAction(_ sender: AnyObject) {
        
        if Reachability.isConnectedToNetwork() == true {
            self.view.makeToastActivity(.center)
            getUserInfo()
            self.view.hideToastActivity()
            
        }
        else{
            Commonhelper().showErrorMessage(internetError)
        }
    }
    
    @objc func saveButtonAction(_ sender: AnyObject) {
        
        let mobileValue:NSString = mobileNumber.text! as NSString
        let trimmedMobile = mobileValue.replacingOccurrences(of: " ", with: "")
        if validateName(userName.text!) == false{
            userName.text = ""
            Commonhelper().animateAndRequiredWithRed(userName,errorMeaage: "Min 6 characters(Special characters not allowed.)")
        }
        else if !(trimmedMobile.length == 7){
            mobileNumber.text = ""
            Commonhelper().animateAndRequiredWithRed(mobileNumber,errorMeaage: "Should be 7 digits.")
            
        }
        else{
            self.view.makeToastActivity(.center)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                let post:NSString = "FullName=\(self.userName.text!)&Mobile=\(self.mobileNumber.text!)&DOB=\(self.dateOfBirth.text!)&DOA=\(self.dateOfAnniversary.text!)&TINNumber=\(self.tinNumber.text!)&NIDNumber=\(self.nid.text!)" as NSString
                if Reachability.isConnectedToNetwork() == true {
                    let defaults = UserDefaults.standard
                    if let token = defaults.string(forKey: "Token"){
                        let response = Api().postApiResponse(token as NSString, url: updateUserInfo as NSString, post: post, method: "POST")
                        let errors:NSArray = response.1.value(forKey: "Errors")! as AnyObject as! NSArray
                        if response.0 == 200 && errors.count == 0{
                            let verificationStatus = Api().callApi(token as NSString,url: isPhoneVerified)
                            let boolStatus = verificationStatus.1.value(forKey: "Result") as! Bool
                            if verificationStatus.0 == 200 && boolStatus == true{
                                print("Verified")
                                self.view.makeToast("Updated successfully.")
                            }
                                
                            else{
                                //Generate otp screen
                                let defaults = UserDefaults.standard
                                if let token = defaults.string(forKey: "Token"){
                                    let otpStatus = Api().callApi(token as NSString,url: generateOtp)
                                    let errors:NSArray = otpStatus.1.value(forKey: "Errors") as! NSArray
                                    if otpStatus.0 == 200 && errors.count == 0{
                                        let presentView : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Otpscreen") as UIViewController
                                        self.present(presentView, animated: true, completion: nil)
                                    }
                                }
                                
                            }
                            
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
            self.view.hideToastActivity()
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        Profileview.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
}
