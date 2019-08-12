//
//  Addbilling.swift
//  FlagOn
//
//  Created by SSDB on 14/02/17.
//  Copyright © 2017 IOS Development. All rights reserved.
//

import UIKit

class Addbilling: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet weak var billingAndShippingSubmit: UIButton!
    @IBOutlet weak var billingSubmit: UIButton!
    var locationIdArray = [Int]()
    var placeholdersText = [String]()
    
    @IBOutlet weak var shippingMobileView: UIView!
    @IBOutlet weak var shippingAddress2View: UIView!
    @IBOutlet weak var shippingAddress1View: UIView!
    
    
    @IBOutlet weak var billingMobileView: UIView!
    @IBOutlet weak var billingAddress2View: UIView!
    
    
    @IBOutlet weak var addresstitleView: UIView!
    @IBOutlet weak var billingaddresstTitle: UITextField!
    
    @IBOutlet weak var billinglocationView: UIView!
    @IBOutlet weak var billinglocation: UITextField!
    
    @IBOutlet weak var billingAddress1View: UIView!
    
    @IBOutlet weak var shippinglocationView: UIView!
    @IBOutlet weak var shippinglocation: UITextField!
    
    
    @IBOutlet weak var shippingaddresstitleView: UIView!
    @IBOutlet weak var shippingaddresstitle: UITextField!
    
    @IBOutlet weak var shippingMobile: UITextField!
    @IBOutlet weak var shippingAddress2: UITextField!
    @IBOutlet weak var shippingAddress1: UITextField!
    
    
    @IBOutlet weak var billingMobile: UITextField!
    @IBOutlet weak var billingAddress2: UITextField!
    @IBOutlet weak var billingaddress1: UITextField!
    var address2: UITextField!
    
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var containerView: UIView!
    var shippingTextFields:[UITextField]!
    
    var addressArray:[AnyObject] = []
    var shippingViews:[UIView]!
    var state = "Notchecked"
    var activeField = ""
    var locationIdBilling = ""
    var locationIdShipping = ""
    var addressCollection = [String: AnyObject]()
    //var customView:UIView!
    //var locationTableView: UITableView  = UITableView()
    var autocompleteLocation = [String]()
    var location = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        textFields = [billingaddresstTitle,billingaddress1,billingAddress2,billingMobile,billinglocation,shippingaddresstitle,shippingAddress1,shippingAddress2,shippingMobile,shippinglocation]
        
        placeholdersText = ["Address title","Full address","Floor number","Mobile number","Select location","Address title","Full address","Floor number","Mobile number","Select location"]
        Commonhelper().removeAutoSuggestion(textFields)
        Commonhelper().createPrefixLabel(textField: billingMobile)
        Commonhelper().createPrefixLabel(textField: shippingMobile)
        textFieldStyle(textFields as [UITextField])
        billingMobile.keyboardType = UIKeyboardType.numberPad
        shippingMobile.keyboardType = UIKeyboardType.numberPad
        Commonhelper().textFieldPlaceholder(textFields,placeholdersText: placeholdersText)
        switchButton.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switchButton.setOn(true, animated: false)
        switchButton.tintColor = UIColor.white
        switchButton.onTintColor = UIColor.white
        switchButton.thumbTintColor = UIColor.red
        switchButton.addTarget(self, action: #selector(switchChanged(_:)), for: UIControl.Event.valueChanged)
        Commonhelper().buttonCornerRadius(billingAndShippingSubmit)
        Commonhelper().buttonCornerRadius(billingSubmit)
        shippingTextFields = [shippinglocation,shippingaddresstitle,shippingAddress1,shippingAddress2,shippingMobile]
        
        shippingViews = [shippingaddresstitleView,shippingAddress1View,shippingAddress2View,shippinglocationView,shippingMobileView]
        ShippingFieldsStyle(fields: shippingTextFields ,views: shippingViews ,action: "Hide")
        billingSubmit.addTarget(self, action: #selector(Addbilling.signUpAction(_:)), for: .touchUpInside)
        billingAndShippingSubmit.addTarget(self, action: #selector(Addbilling.signUpAction(_:)), for: .touchUpInside)
        print(screenSize.height)
        var locationViewPosition = 0.0 as CGFloat
        switch screenSize.height {
            
        case 736  :
            print("")
            locationViewPosition = screenSize.height*0.57
        case 667  :
            locationViewPosition = screenSize.height*0.62
        //moveView()
        case 568  :
            locationViewPosition = screenSize.height*0.67
        //moveView()
        case 480  :
            print("")
            locationViewPosition = screenSize.height*0.76
        default :
            locationViewPosition = screenSize.height*0.65
            //moveView()
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Addbilling.handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        //         customView=UIView(frame: CGRect(x: screenSize.width*0.098, y: locationViewPosition, width: screenSize.width*0.8, height: 100))
        //        customView.backgroundColor=UIColor.white
        //        self.containerView.addSubview(customView)
        //locationTableView.frame = CGRect(x: 0, y: 10, width: screenSize.width*0.8, height: 120)
        //locationTableView.delegate = self
        //locationTableView.dataSource = self
        //        self.locationTableView.separatorStyle = .none
        //        locationTableView.backgroundColor = UIColor(red: 255.0/255, green: 250.0/255, blue: 250.0/255, alpha: 1.0)
        //        customView.addSubview(locationTableView)
        //        customView.layer.shadowColor = UIColor.black.cgColor
        //        customView.layer.shadowOpacity = 1
        //        customView.layer.shadowOffset = CGSize.zero
        //        customView.layer.shadowRadius = 2
        //        customView.isHidden = true
        let textField = [billingaddresstTitle,billingaddress1,billingAddress2,billinglocation,shippingaddresstitle,shippingAddress1,shippingAddress2,shippinglocation]
        Commonhelper().paddingView(textField as! [UITextField])
        NotificationCenter.default.addObserver(self, selector: #selector(Addbilling.keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(Addbilling.keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        let buttonBillingLocation = UIButton(type: .custom)
        buttonBillingLocation.setImage(UIImage(named: "currentLocation.png"), for: .normal)
        
        buttonBillingLocation.frame = CGRect(x: CGFloat(shippingAddress1.frame.size.width - 15), y: CGFloat(5), width: CGFloat(25), height: CGFloat(22))
        buttonBillingLocation.addTarget(self, action: #selector(self.getBillingLocation), for: .touchUpInside)
        billingaddress1.rightView = buttonBillingLocation
        billingaddress1.rightViewMode = .always
        
        let buttonShippingLocation = UIButton(type: .custom)
        buttonShippingLocation.setImage(UIImage(named: "currentLocation.png"), for: .normal)
        
        buttonShippingLocation.frame = CGRect(x: CGFloat(shippingAddress1.frame.size.width - 15), y: CGFloat(5), width: CGFloat(25), height: CGFloat(22))
        buttonShippingLocation.addTarget(self, action: #selector(self.getShippingLocation), for: .touchUpInside)
        shippingAddress1.rightView = buttonShippingLocation
        shippingAddress1.rightViewMode = .always
        // locationTableView.rowHeight = 20
        
        //        if let billingNumber = UserDefaults.standard.string(forKey: "mobileNumber"){
        //            billingMobile.text = billingNumber
        //        }
        billingaddress1.delegate = self
        createPicker()
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        if let address = UserDefaults.standard.string(forKey: "selectedAdd"){
            print(activeField)
            if activeField == "BillingButton"{
                billingaddress1.text = address
                // location.text = "Male"
            }
            if activeField == "shippingButton"{
                shippingAddress1.text = address
                // location.text = "Male"
            }
        }
        
    }
    
    func createPicker(){
        
        let addressPicker: UIPickerView
        addressPicker = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 100))
        addressPicker.backgroundColor = .white
        addressPicker.showsSelectionIndicator = true
        addressPicker.delegate = self
        addressPicker.dataSource = self
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.red
        toolBar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(Addbilling.CancelPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        shippinglocation.inputView = addressPicker
        shippinglocation.inputAccessoryView = toolBar
        billinglocation.inputView = addressPicker
        billinglocation.inputAccessoryView = toolBar
        
    }
    
    func appendLocationsInDictionary(_ jsontokenData: NSDictionary)
    {
        locationTextArray.removeAll(keepingCapacity: false)
        if let predictions = jsontokenData["Result"] as? NSArray{
            for dict in predictions as! [NSDictionary]{
                //dict["Description"] as! String
                if(dict["IsActive"] as! Bool){
                    print("---",dict["IsActive"] as! Bool);
                    locationIdArray.append(dict["LocationId"] as! Int)
                    locationTextArray.append(dict["Description"] as! String)
                    
                }
               
            }
        }
        print(locationTextArray)
        print(locationIdArray)
    }
    
    
    @objc func CancelPicker(){
        billinglocation.resignFirstResponder()
        shippinglocation.resignFirstResponder()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return locationTextArray.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return locationTextArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if activeField == "Billing"{
            
            billinglocation.text = locationTextArray[row]
            
            locationIdBilling = String(locationIdArray[row])
            
            
        }
        if activeField == "Shipping"{
            
            shippinglocation.text = locationTextArray[row]
            
            locationIdShipping = String(locationIdArray[row])
            
        }
    }
    
    @IBAction func getBillingLocation(_ sender: Any) {
        print("clicked button")
        if(!(billinglocation.text?.isEmpty)!){
            activeField = "BillingButton"
            location = billinglocation.text!
            performSegue(withIdentifier: "navigateAddAddressToMap", sender: nil)
        }
        else{
            billinglocation.text = ""
            Commonhelper().animateAndRequired(billinglocation,errorMeaage: " Required")
        }
    }
    
    @IBAction func getShippingLocation(_ sender: Any) {
        print("clicked button")
        if(!(shippinglocation.text?.isEmpty)!){
            activeField = "shippingButton"
            location = shippinglocation.text!
            performSegue(withIdentifier: "navigateAddAddressToMap", sender: nil)
        }
        else{
            shippinglocation.text = ""
            Commonhelper().animateAndRequired(shippinglocation,errorMeaage: " Required")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
        
    {
        if segue.identifier == "navigateAddAddressToMap"
            
        {
            let mapView = segue.destination as! Mapview
            mapView.defaultLocation = location
            
            
        }
        
    }
    
    
    @objc func keyboardWillShow(_ sender: Foundation.Notification) {
        
        let screenSize: CGRect = UIScreen.main.bounds
        switch screenSize.height {
            
        case 736  :
            print("736")
            moveView()
        case 667  :
            print("667")
            moveView()
        case 568  :
            print("568")
            moveView()
        case 480  :
            print("480")
            if  activeField == "Billing" || activeField == "shippingAddress2" || activeField == "shippingAddress1" || activeField == "ShippingMobile"{
                self.view.frame.origin.y = CGFloat(-185)
            }
        default :
            print("480def")
            moveView()
        }
        
    }
    
    func moveView(){
        
        let yAxisPosition = -145
        print(activeField)
        
        if  activeField == "shippingAddress2" || activeField == "shippingAddressTitle" || activeField == "shippingAddress1" || activeField == "ShippingMobile"{
            
            self.view.frame.origin.y = CGFloat(yAxisPosition)
        }
        
        //        if activeField == "Shipping" || activeField == "Billing" || activeField == "shippingAddress2" || activeField == "shippingAddressTitle" || activeField == "shippingAddress1" || activeField == "ShippingMobile"{
        //
        //            self.view.frame.origin.y = CGFloat(yAxisPosition)
        //        }
    }
    
    @objc func keyboardWillHide(_ sender: Foundation.Notification) {
        
        self.view.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //customView.isHidden = true
        self.view.frame.origin.y = 0
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Reachability.isConnectedToNetwork() == true {
            
            fetchLocation()
        }
        else{
            Commonhelper().showErrorMessage(internetError)
        }
        // locationTableView.reloadData()
    }
    
    func fetchLocation(){
        
        let response = Api().callApi("",url: getLocation)
        let jsonData = response.1
        if response.0 == 200{
            print(response)
            appendLocationsInDictionary(jsonData)
        }
    }
    
    
    @objc func signUpAction(_ sender:UIButton){
        
        let trimmedMobileBilling = billingMobile.text?.replacingOccurrences(of: " ", with: "")
        let trimmedMobileShipping = shippingMobile.text?.replacingOccurrences(of: " ", with: "")
        if(billinglocation.text!.length == 0){
            billinglocation.text = ""
            Commonhelper().animateAndRequired(billinglocation,errorMeaage: " Required")
        }
            
            
        else if  !(((billingaddress1.text?.length)! >= 5) && ((billingaddress1.text?.length)!<=250))
        {
            billingaddress1.text = ""
            Commonhelper().animateAndRequired(billingaddress1,errorMeaage: " Should be in between 5-250 characters.")
        }
            
        else if !(((billingAddress2.text?.length)! >= 1) && ((billingAddress2.text?.length)!<=20))
        {
            billingAddress2.text = ""
            Commonhelper().animateAndRequired(billingAddress2,errorMeaage: " Should be in between 1-20 characters.")
        }
        else if !((trimmedMobileBilling?.length) == 7 )
        {
            billingMobile.text = ""
            Commonhelper().animateAndRequired(billingMobile,errorMeaage: " Should be 7 digits.")
        }
        else if !(((billingaddresstTitle.text?.length)! >= 5) && ((billingaddresstTitle.text?.length)!<=100)){
            billingaddresstTitle.text = ""
            Commonhelper().animateAndRequired(billingaddresstTitle,errorMeaage: " Should be in between 5-100 characters.")
        }
            
        else
        {
            if state == "Checked"{
                
                if(shippinglocation.text!.length == 0){
                    
                    shippinglocation.text = ""
                    Commonhelper().animateAndRequired(shippinglocation,errorMeaage: " Required")
                }
                    
                    
                else if  !(((shippingAddress1.text?.length)! >= 5) && ((shippingAddress1.text?.length)!<=250)){
                    shippingAddress1.text = ""
                    Commonhelper().animateAndRequired(shippingAddress1,errorMeaage: " Should be in between 5-250 characters.")
                }
                    
                else if !(((shippingAddress2.text?.length)! >= 1) && ((shippingAddress2.text?.length)!<=20)){
                    shippingAddress2.text = ""
                    Commonhelper().animateAndRequired(shippingAddress2,errorMeaage: " Should be in between 1-20 characters.")
                }
                else if !((trimmedMobileShipping?.length) == 7)
                {
                    shippingMobile.text = ""
                    Commonhelper().animateAndRequired(shippingMobile,errorMeaage: " Should be 7 digits.")
                }
                else if !(((shippingaddresstitle.text?.length)! >= 5) && ((shippingaddresstitle.text?.length)!<=100)){
                    shippingaddresstitle.text = ""
                    Commonhelper().animateAndRequired(shippingaddresstitle,errorMeaage: " Should be in between 5-100 characters.")
                }
                    
                else{
                    
                    addBillingAndShipping()
                }
                
            }
                
            else
            {
                
                addBillingAndShipping()
            }
            
        }
        
    }
    
    func addBillingAndShipping(){
        
        addressArray.removeAll()
        addressCollection.removeAll()
        addressCollection["AddressTitle"] =  billingaddresstTitle.text as AnyObject?
        addressCollection["Address1"] = billingaddress1.text! as AnyObject
        addressCollection["Address2"] = billingAddress2.text! as AnyObject
        addressCollection["LocationId"] = locationIdBilling as AnyObject
        addressCollection["AddressType"] = 0 as AnyObject
        addressCollection["IsDefault"] = false as AnyObject?
        addressCollection["ContactNumber"] = billingMobile.text! as AnyObject
        
        let jsonBillingData = try! JSONSerialization.data(withJSONObject: addressCollection, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonBillingString = NSString(data: jsonBillingData, encoding: String.Encoding.utf8.rawValue)! as String
        addressArray.append(jsonBillingString as AnyObject)
        
        if state == "Notchecked"{
            
            addressCollection["AddressTitle"] =  billingaddresstTitle.text as AnyObject?
            addressCollection["Address1"] = billingaddress1.text! as AnyObject
            addressCollection["Address2"] = billingAddress2.text! as AnyObject
            addressCollection["LocationId"] = locationIdBilling as AnyObject
            addressCollection["AddressType"] = 1 as AnyObject
            addressCollection["IsDefault"] = true as AnyObject?
            addressCollection["ContactNumber"] = billingMobile.text! as AnyObject
            
            let jsonBillingData = try! JSONSerialization.data(withJSONObject: addressCollection, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonBillingString = NSString(data: jsonBillingData, encoding: String.Encoding.utf8.rawValue)! as String
            addressArray.append(jsonBillingString as AnyObject)
            
        }
            
        else{
            addressCollection["AddressTitle"] =  (shippingaddresstitle?.text)! as AnyObject?
            addressCollection["Address1"] = (shippingAddress1?.text)! as AnyObject
            addressCollection["Address2"] = (shippingAddress2?.text)! as AnyObject
            addressCollection["LocationId"] = locationIdShipping as AnyObject
            addressCollection["AddressType"] = 1 as AnyObject
            addressCollection["IsDefault"] = true as AnyObject
            addressCollection["ContactNumber"] = shippingMobile.text! as AnyObject
            
            let jsonShippingData = try! JSONSerialization.data(withJSONObject: addressCollection, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonShippingString = NSString(data: jsonShippingData, encoding: String.Encoding.utf8.rawValue)! as String
            addressArray.append(jsonShippingString as AnyObject)
        }
        
        let openingBracks = "{"
        let closingBracks = "}"
        let post = openingBracks+"Address:\(addressArray)\(closingBracks)"
        print(addressArray)
        if Reachability.isConnectedToNetwork() == true {
            
            let defaults = UserDefaults.standard
            
            if let token = defaults.string(forKey: "Token"){
                self.view.makeToastActivity(.center)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    let addAddressResponse = Api().postApiResponse(token as NSString, url: addAddress as NSString, post: post as NSString, method: "POST")
                    
                    switch addAddressResponse.0{
                        
                    case 200:
                        
                        let awaitingScreen : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Awaitingconfirmation") as UIViewController
                        self.present(awaitingScreen, animated: true, completion: nil)
                        
                    case 400:
                        
                        self.view.hideToastActivity()
                        let errors:NSArray = addAddressResponse.1.value(forKey: "Errors") as! NSArray
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
            }
            else{
                let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                self.present(signinScreen, animated: true, completion: nil)
            }
            
        }
            
        else{
            
            Commonhelper().showErrorMessage(internetError)
            //locationTableView.isHidden = true
        }
        
    }
    
    func ShippingFieldsStyle(fields:[UITextField],views:[UIView],action:String){
        if action == "Hide"{
            for field in fields{
                for view in views{
                    field.isHidden = true
                    view.isHidden = true
                }
            }
            billingSubmit.isHidden = false
            billingAndShippingSubmit.isHidden = true
        }
        else{
            for field in fields{
                for view in views{
                    field.isHidden = false
                    view.isHidden = false
                }
            }
            billingSubmit.isHidden = true
            billingAndShippingSubmit.isHidden = false
        }
    }
    
    @objc func switchChanged(_ sender: UISwitch!) {
        
        if sender.isOn == false{
            
            state = "Checked"
            billingAndShippingSubmit.isHidden = true
            shippingAddress1.isHidden = false
            shippingAddress2.isHidden = false
            shippinglocation.isHidden = false
            shippingaddresstitle.isHidden = false
            shippingMobile.isHidden = false
            ShippingFieldsStyle(fields: shippingTextFields ,views: shippingViews ,action: "")
        }
            
        else{
            state = "Notchecked"
            billingSubmit.isHidden = false
            billingAndShippingSubmit.isHidden = true
            shippingAddress1.isHidden = true
            shippingAddress2.isHidden = true
            shippinglocation.isHidden = true
            shippingaddresstitle.isHidden = true
            shippingMobile.isHidden = true
            ShippingFieldsStyle(fields: shippingTextFields ,views: shippingViews ,action: "Hide")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case billingaddresstTitle:
            clearColor(bottomView: addresstitleView)
        case billingaddress1:
            clearColor(bottomView: billingAddress1View)
        case billingAddress2:
            clearColor(bottomView: billingAddress2View)
        case billingMobile:
            clearColor(bottomView: billingMobileView)
        case billinglocation:
            clearColor(bottomView: billinglocationView)
        case shippingaddresstitle:
            clearColor(bottomView: shippingaddresstitleView)
        case shippingAddress1:
            clearColor(bottomView: shippingAddress1View)
        case shippingAddress2:
            clearColor(bottomView: shippingAddress2View)
        case shippingMobile:
            clearColor(bottomView: shippingMobileView)
        case shippinglocation:
            clearColor(bottomView: shippinglocationView)
        default:
            print("non")
        }
        
    }
    
    func clearColor(bottomView:UIView){
        
        bottomView.backgroundColor = UIColor.white
        
    }
    
    func textFieldStyle(_ fieldList : [UITextField]) {
        
        for textField in fieldList{
            
            textField.backgroundColor = UIColor.clear
            textField.borderStyle = UITextField.BorderStyle.none
            textField.font = UIFont(name: "Gill Sans", size: 16)!
            textField.keyboardType = UIKeyboardType.default
            textField.textColor = UIColor.white
            textField.delegate = self
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //if any issue then refer 12/2/2017 before code
        if textField == billingaddresstTitle{
            
            clearTextField(placeholderString: "Address title",field: billingaddresstTitle,activeFieldString: "AddressTitle")
            self.view.frame.origin.y = 0
        }
        if textField == billingaddress1{
            
            clearTextField(placeholderString: "Full address",field: billingaddress1,activeFieldString: "BillingAddress1")
            self.view.frame.origin.y = 0
        }
        if textField == billingAddress2{
            
            clearTextField(placeholderString: "Floor number",field: billingAddress2,activeFieldString: "BillingAddress2")
            self.view.frame.origin.y = 0
        }
        if textField == billingMobile{
            
            clearTextField(placeholderString: "Mobile number",field: billingMobile,activeFieldString: "BillingMobile")
            self.view.frame.origin.y = 0
        }
        if textField == billinglocation{
            clearTextField(placeholderString: "Select location",field: billinglocation,activeFieldString: "Billing")
            if Reachability.isConnectedToNetwork() == true {
                activeField = "Billing"
                handleBillingLocation()
                
            }
            else{
                Commonhelper().showErrorMessage(internetError)
            }
            
        }
        if textField == shippingaddresstitle{
            
            clearTextField(placeholderString: "Address title",field: shippingaddresstitle,activeFieldString: "shippingAddressTitle")
            self.view.frame.origin.y = 0
        }
        
        if textField == shippingAddress1{
            
            clearTextField(placeholderString: "Full address",field: shippingAddress1,activeFieldString: "shippingAddress1")
            self.view.frame.origin.y = 0
        }
        
        if textField == shippingAddress2{
            
            clearTextField(placeholderString: "Floor number",field: shippingAddress2,activeFieldString: "shippingAddress2")
            self.view.frame.origin.y = 0
        }
        if textField == shippingMobile{
            
            clearTextField(placeholderString: "Mobile number",field: shippingMobile,activeFieldString: "ShippingMobile")
            self.view.frame.origin.y = 0
        }
        if textField == shippinglocation{
            
            clearTextField(placeholderString: " Select location",field: shippinglocation,activeFieldString: "Shipping")
            if Reachability.isConnectedToNetwork() == true {
                activeField = "Shipping"
                textFields = [shippinglocation]
                handleShippingLocation()
                
            }
            else{
                Commonhelper().showErrorMessage(internetError)
            }
        }
        
    }
    
    func handleShippingLocation(){
        
        if !locationTextArray.isEmpty{
            activeField = "Shipping"
            // customView.isHidden = false
            //locationTableView.isHidden = false
            placeholdersText = ["Select location"]
            textFields = [shippinglocation]
            Commonhelper().textFieldPlaceholder(textFields,placeholdersText: placeholdersText)
        }
        else
        {
            fetchLocation()
            //customView.isHidden = false
            // locationTableView.isHidden = false
            // locationTableView.reloadData()
        }
    }
    
    func handleBillingLocation(){
        
        if !locationTextArray.isEmpty{
            
            activeField = "Billing"
            //customView.isHidden = false
            //locationTableView.isHidden = false
            placeholdersText = ["Select location"]
            textFields = [billinglocation]
            Commonhelper().textFieldPlaceholder(textFields,placeholdersText: placeholdersText)
        }
        else
        {
            fetchLocation()
            //customView.isHidden = false
            //locationTableView.isHidden = false
            //locationTableView.reloadData()
        }
    }
    
    func clearTextField(placeholderString:String,field:UITextField,activeFieldString:String){
        
        placeholdersText = [placeholderString]
        textFields = [field]
        activeField = activeFieldString
        switch field {
        case billingaddresstTitle:
            focusColor(bottomView: addresstitleView)
        //locationTableView.isHidden = true
        case billingaddress1:
            focusColor(bottomView: billingAddress1View)
        //locationTableView.isHidden = true
        case billingAddress2:
            focusColor(bottomView: billingAddress2View)
        //locationTableView.isHidden = true
        case billingMobile:
            focusColor(bottomView: billingMobileView)
        //locationTableView.isHidden = true
        case billinglocation:
            focusColor(bottomView: billinglocationView)
        case shippingaddresstitle:
            focusColor(bottomView: shippingaddresstitleView)
        //locationTableView.isHidden = true
        case shippingAddress1:
            focusColor(bottomView: shippingAddress1View)
        //locationTableView.isHidden = true
        case shippingAddress2:
            focusColor(bottomView: shippingAddress2View)
        //locationTableView.isHidden = true
        case shippingMobile:
            focusColor(bottomView: shippingMobileView)
        //locationTableView.isHidden = true
        case shippinglocation:
            focusColor(bottomView: shippinglocationView)
        default:
            print("none")
        }
        Commonhelper().textFieldPlaceholder(textFields,placeholdersText: placeholdersText)
    }
    
    func focusColor(bottomView:UIView){
        bottomView.backgroundColor = UIColor.black
    }
    
    
}
