//
//  Addressbar.swift
//  FlagOn
//
//  Created by IOS Development on 8/4/16.
//  Copyright © 2016 IOS Development. All rights reserved.
//



import UIKit

class Addressbar: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet weak var locationTableView: UITableView!
    var editTag:Bool!
    var buttonText:String!
    var apiUrl:String!
    var toggleState = 1
    var locationId = ""
    var autocompleteLocation = [String]()
    var location: UITextField!
    var addresstitle: UITextField!
    var address2: UITextField!
    var address1: UITextField!
    var mobile: UITextField!
    var updateAddress1:String!
    var updateAddress2:String!
    var updateLocation:String!
    var updateMobile:String!
    var updateLocationText:String!
    var addressTitleEdit:String!
    var addressIdEdit:Int?
    var addressArray:[AnyObject] = []
    let openingBracks = "{"
    let closingBracks = "}"
    var addressCollection = [String: AnyObject]()
    var mapButton:UIButton!
    var activeField = ""
    var type = ""
    var addessType:Int?
    var locationIdArray = [Int]()
    var placeholdersText = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        createNewAddressButton()
        createAddressView()
        
        self.location.delegate = self
        self.addresstitle.delegate = self
        self.address1.delegate = self
        self.address2.delegate = self
        self.mobile.delegate = self
        locationTableView.isHidden = true
        mobile.keyboardType = UIKeyboardType.numberPad
        
        let screenSize: CGRect = UIScreen.main.bounds
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 20))
        self.view.addSubview(customView)
        
        UserDefaults.standard.set(nil, forKey: "selectedAdd")
        Commonhelper().createPrefixCountryCode(textField: mobile)
        createPicker()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Addressbar.handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
    }
    
    func keyboardWillShow(_ sender: Foundation.Notification) {
        
        if activeField == "location"{
            
            let screenSize: CGRect = UIScreen.main.bounds
            switch screenSize.height {
                
            case 736  :
                self.view.frame.origin.y -= 100
                
            case 667  :
                self.view.frame.origin.y -= 100
                
            case 568  :
                self.view.frame.origin.y -= 100
                
            case 480  :
                self.view.frame.origin.y -= 110
                
            default :
                self.view.frame.origin.y -= 150
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == addresstitle{
            self.view.frame.origin.y = 0
            placeholdersText = ["Give your address a name(Eg. Home, Office)"]
            activeField = "addressTitle"
            textFields = [addresstitle]
            
            Commonhelper().textFieldPlaceholderProfile(textFields,placeholdersText: placeholdersText)
            Commonhelper().addBorderToTextField(textFields,color: "")
            
        }
        if textField == address1{
            self.view.frame.origin.y = 0
            placeholdersText = ["Full address"]
            textFields = [address1]
            
            Commonhelper().textFieldPlaceholderProfile(textFields,placeholdersText: placeholdersText)
            Commonhelper().addBorderToTextField(textFields,color: "")
            activeField = "address1"
        }
        
        if textField == address2{
            self.view.frame.origin.y = 0
            placeholdersText = ["Floor number"]
            textFields = [address2]
            Commonhelper().textFieldPlaceholderProfile(textFields,placeholdersText: placeholdersText)
            Commonhelper().addBorderToTextField(textFields,color: "")
            activeField = "address2"
        }
        
        if textField == mobile{
            self.view.frame.origin.y = 0
            placeholdersText = ["Mobile"]
            textFields = [mobile]
            
            Commonhelper().textFieldPlaceholderProfile(textFields,placeholdersText: placeholdersText)
            Commonhelper().addBorderToTextField(textFields,color: "")
            activeField = "mobile"
        }
        
        if textField == location{
            
            placeholdersText = ["Select location"]
            textFields = [location]
            Commonhelper().textFieldPlaceholderProfile(textFields,placeholdersText: placeholdersText)
            Commonhelper().addBorderToTextField(textFields,color: "")
            activeField = "location"
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textFields = [textField]
        Commonhelper().addBorderToTextField(textFields,color: "red")
        
    }
    
    func createAddressView(){
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        addresstitle = UITextField(frame: CGRect(x: screenSize.width*0.10, y: screenSize.height*0.2, width: screenSize.width*0.8, height: 35))
        
        location =  UITextField(frame: CGRect(x: screenSize.width*0.10, y: screenSize.height*0.2 + 40, width: screenSize.width*0.8, height: 35))
        
        
        address1 = UITextField(frame: CGRect(x: screenSize.width*0.10, y: screenSize.height*0.2 + 80, width: screenSize.width*0.8, height: 35))
        
        
        address2 = UITextField(frame: CGRect(x: screenSize.width*0.10, y: screenSize.height*0.2 + 120, width: screenSize.width*0.8, height: 35))
        
        mobile = UITextField(frame: CGRect(x: screenSize.width*0.10, y: screenSize.height*0.2 + 160, width: screenSize.width*0.8, height: 35))
        
        mapButton = UIButton(frame: CGRect(x: screenSize.width*0.10 + screenSize.width*0.8, y: screenSize.height*0.2 + 80, width: 30, height: 35))
        let mapImage = UIImage(named: "maps-and-flags") as UIImage?
        mapButton.setImage(mapImage, for: UIControl.State())
        
        mapButton.addTarget(self, action: #selector(Addressbar.showMap(_:)), for: UIControl.Event.touchUpInside)
        view.addSubview(mapButton)
        
        placeholdersText = ["Give your address a name (Eg. Home, Office)","Select location","Full address","Floor number","Mobile"]
        
        textFields = [addresstitle,location,address1,address2,mobile]
        Commonhelper().paddingView(textFields)
        Commonhelper().textFieldPlaceholderProfile(textFields,placeholdersText: placeholdersText)
        Commonhelper().addBorderToTextField(textFields,color: "red")
        textFieldStyle(textFields as [UITextField])
        
    }
    
    @objc func CancelPicker(){
        location.resignFirstResponder()
    }
    
    @IBAction func goBack(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
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
        
        location.text = locationTextArray[row]
        locationId = String(locationIdArray[row])
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
        let cancelButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(Addressbar.CancelPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        location.inputView = addressPicker
        location.inputAccessoryView = toolBar
        
        
    }
    
    @objc func showMap(_ sender: UIButton!){
        
        if !((location.text?.isEmpty)!){
            performSegue(withIdentifier: "navigateToMapView", sender: nil)
            
        }
        else{
            location.text = ""
            Commonhelper().animateAndRequiredWithRed(location,errorMeaage: "Location required.")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
        
    {
        if segue.identifier == "navigateToMapView"
            
        {
            let mapView = segue.destination as! Mapview
            mapView.defaultLocation = location.text!
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        
        super.viewWillAppear(animated)
        
        if let editBool = editTag{
            
            if editBool == true{
                
                addresstitle.text = addressTitleEdit
                address1.text = updateAddress1
                address2.text = updateAddress2
                location.text = updateLocationText
                locationId = updateLocation
                mobile.text = updateMobile
            }
            
        }
        if let address = UserDefaults.standard.string(forKey: "selectedAdd"){
            address1.text = address
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.tabBarController?.moreNavigationController.navigationBar.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
      if buttonText == "Update Address"{
            
            apiUrl = updateAddress
            
        }else
        {
            apiUrl = addAddress
        }
        if Reachability.isConnectedToNetwork() == true {
            
            fetchLocation()
        }
        else{
            Commonhelper().showErrorMessage(internetError)
        }
        
    }
    
    
    
    func fetchLocation(){
        
        let response = Api().callApi("",url: getLocation)
        let jsonData = response.1
        
        if response.0 == 200{
            
            appendLocationsInDictionary(jsonData)
        }
        
    }
    
    func createNewAddressButton(){
        
        let screenSize: CGRect = UIScreen.main.bounds
        var yAxisButtonPosition = 0.65
        
        if screenSize.height == 480.0{
            
            yAxisButtonPosition = 0.62
            
        }
        
        let newAddress = UIButton(frame: CGRect(x: self.view.bounds.origin.x + (self.view.bounds.width * 0.325), y: self.view.bounds.height * CGFloat(yAxisButtonPosition), width: self.view.bounds.origin.x + (self.view.bounds.width * 0.35), height: self.view.bounds.origin.y + (self.view.bounds.height * 0.05)))
        
        newAddress.layer.cornerRadius = 18.0
        
        newAddress.layer.borderWidth = 2.0
        
        newAddress.backgroundColor = UIColor.white
        
        newAddress.layer.borderColor = UIColor.red.cgColor
        
        newAddress.setTitle(buttonText, for: UIControl.State())
        
        newAddress.setTitleColor(UIColor.red, for: UIControl.State())
        
        newAddress.titleLabel!.font =  UIFont(name: "Arial", size: 10)
        
        self.view.addSubview(newAddress)
        
        newAddress.addTarget(self, action: #selector(Addressbar.createNewAddressAction(_:)), for: UIControl.Event.touchUpInside)
        
    }
    
    
    
    func textFieldStyle(_ fieldList : [UITextField]) {
        
        for textField in fieldList{
            
            textField.autocorrectionType = .no
            textField.backgroundColor = UIColor.clear
            textField.borderStyle = UITextField.BorderStyle.none
            
            textField.font = UIFont(name: "Gill Sans", size: 13)!
            
            textField.textColor = UIColor.black
            
            textField.delegate = self
            
            self.view.addSubview(textField)
            
        }
     }
    
    func appendLocationsInDictionary(_ jsontokenData: NSDictionary)
    {
        locationTextArray.removeAll(keepingCapacity: false)
        if let predictions = jsontokenData["Result"] as? NSArray{
            for dict in predictions as! [NSDictionary]{
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
    
    
    @objc func createNewAddressAction(_ sender: UIButton!){
        
        print(autocompleteLocation)
        let mobileValue:NSString = mobile.text! as NSString
        let trimmedMobile = mobileValue.replacingOccurrences(of: " ", with: "")
        if !(((addresstitle.text?.length)! >= 5) && ((addresstitle.text?.length)!<=100))
            
        {
            
            addresstitle.text = ""
            Commonhelper().animateAndRequiredWithRed(addresstitle,errorMeaage: "Should be in between 5-100 characters.")
            
        }
        else if(location.text!.length == 0) && (locationId == ""){
            
            location.text = ""
            Commonhelper().animateAndRequiredWithRed(location,errorMeaage: "Location required")
            
        }
        else if !(((address1.text?.length)! >= 5) && ((address1.text?.length)!<=250)){
            
            address1.text = ""
            Commonhelper().animateAndRequiredWithRed(self.address1,errorMeaage: "Should be in between 5-250 characters.")
            
        }
           
        else if !(((address2.text?.length)! >= 1) && ((address2.text?.length)!<=20)){
            address2.text = ""
            Commonhelper().animateAndRequiredWithRed(address2,errorMeaage: " Should be in between 1-20 characters.")
            
            
        }
        else if !(trimmedMobile.length == 7)
        {
            mobile.text = ""
            Commonhelper().animateAndRequiredWithRed(mobile,errorMeaage: "Should be 7 digits.")
            
        }
            
        else
        {
            
            let address1Value:NSString = address1.text! as NSString
            let address2Value:NSString = address2.text! as NSString
            let addressTitleValue:NSString = addresstitle.text! as NSString
            let mobileValue:NSString = mobile.text! as NSString
            print(type)
          
            addressCollection.removeAll()
            addressCollection["AddressTitle"] =  addressTitleValue
            
            addressCollection["Address1"] = address1Value
            
            addressCollection["Address2"] = address2Value
            
            addressCollection["LocationId"] = locationId as AnyObject?
            
            addressCollection["AddressType"] = 1 as AnyObject?
            
            addressCollection["IsDefault"] = false as AnyObject?
            
            addressCollection["ContactNumber"] = mobileValue as AnyObject?
            
            addressCollection["AddressId"] = addressIdEdit! as AnyObject?
            
            
            print(addressCollection)
            
            let jsonShippingData = try! JSONSerialization.data(withJSONObject: addressCollection, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            let jsonShippingString = NSString(data: jsonShippingData, encoding: String.Encoding.utf8.rawValue)! as String
            
            addressArray.removeAll()
            addressArray.append(jsonShippingString as AnyObject)
            print(jsonShippingString)
            var post = ""
            if buttonText == "Update Address"{
                
                post = jsonShippingString
                
            }
            else
                
            {
                post = openingBracks+"Address:\(addressArray)\(closingBracks)"
                
            }
            
            addAndUpdateAddress(post: post)
            
        }
        
    }
    
    func addAndUpdateAddress(post:String){
        
        if Reachability.isConnectedToNetwork() == true {
            
            let defaults = UserDefaults.standard
            
            if let token = defaults.string(forKey: "Token"){
                
                print(post)
                //
                self.view.makeToastActivity(.center)
                let addAddressResponse = Api().postApiResponse(token as NSString, url: apiUrl as NSString, post: post as NSString, method: "POST")
                
                switch addAddressResponse.0{
                    
                case 200:
                    self.view.hideToastActivity()
                    
                    Commonhelper().showErrorMessage("Added successfully.")
                    //                    self.dismiss(animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                        
                        self.navigationController?.popViewController(animated: true);
                        
                        
                    }
                case 400:
                    self.view.hideToastActivity()
                    let errors:NSArray = addAddressResponse.1.value(forKey: "Errors") as! NSArray
                    for error in errors{
                        Commonhelper().showErrorMessage(error as! String)
                    }
                case 401:
                    
                    self.view.hideToastActivity()
                    let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                    self.present(signinScreen, animated: true, completion: nil)
                    
                case 500:
                    
                    self.view.hideToastActivity()
                    Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                    
                case 0:
                    self.view.hideToastActivity()
                    Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                    
                default:
                    
                    print("")
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        self.view.frame.origin.y = 0
        return true
    }
    
    
}

