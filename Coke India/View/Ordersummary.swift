//
//  Ordersummary.swift
//  FlagOn
//
//  Created by SSDB on 22/12/16.
//  Copyright © 2016 IOS Development. All rights reserved.
//

import UIKit

class Ordersummary: UIViewController,UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var viewOffer: UIButton!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var confirmOrder: UIButton!
    @IBOutlet weak var totalAmountOffer: UIButton!
    @IBOutlet weak var `continue`: UIButton!
    @IBOutlet weak var offerDesc: UIButton!
    @IBOutlet weak var deposite: UILabel!
    @IBOutlet weak var previousDue: UILabel!
    @IBOutlet weak var totalBill: UILabel!
    @IBOutlet weak var GST: UILabel!
    
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var bottles: UILabel!
    @IBOutlet weak var goBack: UIButton!
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var customView: UIView!
    var customOfferView:UIView!
    var productArray:[AnyObject] = []
    var OfferTableView: UITableView = UITableView()
    
    var shippingAddress:[String] = []
    var shippingAddressID:[Int] = []
    var offer:[String] = []
    var offers:[AnyObject] = []
    var productOffer:[String] = []
    var cartList = [Cart]()
    var cartBillingOffer = [commonDataForCart]()
    var cacheCart = NSCache<AnyObject, AnyObject>()
    
    var offerOnGrandTotal = ""
    var billAmount = 0.0
    var billAmountBeforeDiscount  = 0.0
    var poNumber = ""
    var depositAmount = 0.0
    var  discountAmount = 0.0
    var totalTaxAmount = 0.0
    var noOfBottlesReturn = 0
    var offerDescription = ""
    var billingAddressID = 0
    var billingAmount = 0.0
    var productOfferIndex = [Int]()
    var loginScreen = false
    var updateCartDict = [String: AnyObject]()
    var appliedOfferList = [String]()
    var offerIndex = [Int]()
    var cartOfferProduct = [String]()
    var cartOfferProductQty = [Int]()
    var cancelButton : UIButton!
    var invalidOfferIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderTableView.delegate = self
        self.orderTableView.dataSource = self
        orderTableView.allowsSelection = false
        Commonhelper().buttonCornerRadius(confirmOrder)
        Commonhelper().buttonCornerRadius(`continue`)
        createPicker()
       
        goBack.addTarget(self, action:#selector(self.backPressed), for: .touchUpInside)
        let screenSize: CGRect = UIScreen.main.bounds
        
        customOfferView=UIView(frame: CGRect(x: screenSize.width*0.100, y: screenSize.height*0.23, width: screenSize.width*0.8, height: 180))
        customOfferView.backgroundColor=UIColor.white
        self.view.addSubview(customOfferView)

        OfferTableView.frame = CGRect(x: 0, y: 30, width: screenSize.width*0.8, height: 110)
        OfferTableView.delegate = self
        OfferTableView.dataSource = self
        //self.OfferTableView.separatorStyle = .none
        OfferTableView.backgroundColor = UIColor.white
        
        let offerText = UILabel()
           offerText.frame = CGRect(x: screenSize.width*0.300, y:10, width: 80, height: 15)
        customOfferView.addSubview(offerText)
        offerText.text = "-OFFERS-"
        offerText.textColor = UIColor.red
        offerText.font = UIFont.boldSystemFont(ofSize: 12)
        customOfferView.isHidden = true
        customOfferView.addSubview(OfferTableView)
        offerText.textAlignment = .center
        var view = UIView()
        view = UIView(frame: CGRect(x: 0, y: 27, width: screenSize.width*0.8, height: 1))
        customOfferView.addSubview(view)
        view.backgroundColor = UIColor.red
        
        customOfferView.layer.shadowColor = UIColor.black.cgColor
        customOfferView.layer.shadowOpacity = 1
        customOfferView.layer.shadowOffset = CGSize.zero
        customOfferView.layer.shadowRadius = 2
        
        
        cancelButton = UIButton(frame: CGRect(x:screenSize.width*0.29, y: 140, width: 70.00, height: 33.00))
        cancelButton.setImage(UIImage(named: "delete-cross"), for: UIControl.State.normal)
        customOfferView.addSubview(cancelButton)
        
         cancelButton.addTarget(self, action: #selector(Ordersummary.cancelButtonTapped), for: .touchUpInside)
        
        confirmOrder.addTarget(self, action:#selector(self.confirmOrderAction), for: .touchUpInside)
        `continue`.addTarget(self, action:#selector(self.continueOrder), for: .touchUpInside)
        viewOffer.isHidden = false
        OfferTableView.rowHeight = 30

        viewOffer.layer.borderWidth = 1
        viewOffer.layer.borderColor = UIColor.red.cgColor
        addressTextField.layer.borderColor = UIColor.red.cgColor
        addressTextField.layer.borderWidth = 1.0
    }
    
    @objc func cancelButtonTapped(){
        
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseIn, animations: {
            self.customOfferView.isHidden = true
            
        }) { _ in
            
            
            //self.customDateView.removeFromSuperview()
        }
        
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func continueOrder(){
     self.dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmOrderAction(){
        
//        let alertController = UIAlertController(title: "", message: "Are you credit customer?", preferredStyle: UIAlertControllerStyle.alert)
//        let creditCustomerAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: {
//            alert -> Void in
//        })
//        let subview :UIView = alertController.view.subviews.last! as UIView
//        let alertContentView = subview.subviews.last! as UIView
//        alertContentView.backgroundColor = UIColor.white
//        alertController.view.tintColor = UIColor.red
//        alertController.addAction(creditCustomerAction)
//        self.present(alertController, animated: true, completion: nil)
        
        
        self.view.makeToastActivity(.center)
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token"){
                let customerType = Api().callApi(token as NSString,url: "\(getCustomerType)")
                print(customerType)
                let customerDetails = customerType.1["Result"] as! NSDictionary
                for (key, value) in customerDetails {
                    if key as! String == "CustomerType" {
                        if value as! String == "Credit" {
                            
                            let alertController = UIAlertController(title: "", message: "Enter PO Number", preferredStyle: UIAlertController.Style.alert)
                            
                            let saveAction = UIAlertAction(title: "Skip", style: UIAlertAction.Style.default, handler: {
                                alert -> Void in
                                let responseBillOffer = Api().callApi(token as NSString,url: "\(offerOnBillAmt)\(Int(self.billAmount))")
                                
                                if let offerList = responseBillOffer.1["Result"] as? NSArray{
                                    if offerList.count > 0 {
                                        let amt = UserDefaults.standard
                                        amt.set(String(self.billAmount), forKey: "billAmount")
                                        
                                        UserDefaults.standard.set(self.billingAddressID, forKey: "shippingAddressID")
                                        UserDefaults.standard.set(true, forKey: "CartView")
                                        
                                        self.performSegue(withIdentifier: "summaryToOffer", sender: nil)
                                        
                                    }
                                    else{
                                        
                                        self.confirmOrderAfterBillOffer()
                                    }
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: {
                                (action : UIAlertAction!) -> Void in
                                let commentBox = alertController.textFields![0] as UITextField
                                self.poNumber = commentBox.text!
                                let responseBillOffer = Api().callApi(token as NSString,url: "\(offerOnBillAmt)\(Int(self.billAmount))")
                                
                                if let offerList = responseBillOffer.1["Result"] as? NSArray{
                                    if offerList.count > 0 {
                                        let amt = UserDefaults.standard
                                        amt.set(String(self.billAmount), forKey: "billAmount")
                                        
                                        UserDefaults.standard.set(self.billingAddressID, forKey: "shippingAddressID")
                                        UserDefaults.standard.set(true, forKey: "CartView")
                                        
                                        self.performSegue(withIdentifier: "summaryToOffer", sender: nil)
                                        
                                    }
                                    else{
                                        
                                        self.confirmOrderAfterBillOffer()
                                    }
                                }
                            })
                            
                            alertController.addTextField { (textField : UITextField!) -> Void in
                                textField.placeholder = "PO Number"
                                
                            }
                            let subview :UIView = alertController.view.subviews.last! as UIView
                            let alertContentView = subview.subviews.last! as UIView
                            alertContentView.backgroundColor = UIColor.white
                            alertController.view.tintColor = UIColor.red
                            alertController.addAction(saveAction)
                            alertController.addAction(cancelAction)
                            self.present(alertController, animated: true, completion: nil)
                        }else{
                            let responseBillOffer = Api().callApi(token as NSString,url: "\(offerOnBillAmt)\(Int(self.billAmount))")
                            
                            if let offerList = responseBillOffer.1["Result"] as? NSArray{
                                if offerList.count > 0 {
                                    let amt = UserDefaults.standard
                                    amt.set(String(self.billAmount), forKey: "billAmount")
                                    
                                    UserDefaults.standard.set(self.billingAddressID, forKey: "shippingAddressID")
                                    UserDefaults.standard.set(true, forKey: "CartView")
                                    
                                    self.performSegue(withIdentifier: "summaryToOffer", sender: nil)
                                    
                                }
                                else{
                                    
                                    self.confirmOrderAfterBillOffer()
                                }
                            }
                        }
                    }
                    break
                }
            }
        }
                
            else{
                
                Commonhelper().showErrorMessage(internalError)
            }
        }
    
    func confirmOrderAfterBillOffer(){
            
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token"){
            let post:NSString = "OrderShippingAddressId=\(billingAddressID)&SourceType=\(1)&PO_Number=\(poNumber)" as NSString
            let response = Api().postApiResponse(token as NSString, url: createOrder as NSString, post: post, method: "POST")
            
            print("created order")
            print(response)
            switch response.0 {
            case 200:
                self.view.hideToastActivity()
                self.view.makeToast("created successfully.")
                print("orderdone")
                
                if let orderID = response.1["Result"]{
                    print("orderIDtest")
                    print(orderID)
                    let defaultID = UserDefaults.standard
                    defaultID.set(String(describing: orderID), forKey: "summaryOrderID")
                }
                let placedOrderView : Placedorder = mainStoryboard.instantiateViewController(withIdentifier: "PlacedOrder") as! Placedorder
                self.present(placedOrderView, animated: true, completion: nil)
                
            case 400:
                self.view.hideToastActivity()
                
                let errors:NSArray = response.1.value(forKey: "Errors") as! NSArray
                for error in errors{
                    
                    Commonhelper().showErrorMessage(error as! String,title: "")
                }
                
            case 500:
                self.view.hideToastActivity()
                Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
            case 401:
                self.view.hideToastActivity()
                let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                self.present(signinScreen, animated: true, completion: nil)
            case 0:
                self.view.hideToastActivity()
                Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
            default:
                self.view.hideToastActivity()
                print("to do")
            }
            }
            
        }
        
        
        
    func hideOfferView(){
        customOfferView.isHidden = true
    }
    
    @objc func backPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if loginScreen == true{
            let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
            self.present(signinScreen, animated: true, completion: nil)
        }
        else{
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token"){
                let response =   Api().callApi(token as NSString,url: getAllShippingAddress)
                if (response.0 == 200 && (response.1["Result"]! as AnyObject).count>0)
                {
                    shippingAddress.removeAll()
                    
                    if let response = response.1["Result"] as? NSArray{
                        
                        for dict in response as! [NSDictionary]{
                            shippingAddress.append(dict["AddressTitle"] as! String)
                            shippingAddressID.append(dict["AddressId"] as! Int)
                        }
                        addressTextField.text = "Ship to: "+shippingAddress[0]
                        billingAddressID = shippingAddressID[0]
                    }
                }
                
            }
//            if let index = invalidOfferIndex{
//                //removeBillOffer()
//                viewCart()
//            }
            if cartList.count == 0{
                navigateToCategeory()
            }
        }
        else
        {
            Commonhelper().showErrorMessage(internetError)
        }
        }
        self.view.hideToastActivity()
    }
    
    func navigateToCategeory(){
    
        let alertController = UIAlertController(title: "Alert!", message: "There are no products in your cart.", preferredStyle: UIAlertController.Style.alert)
        
        let saveAction = UIAlertAction(title: "Continue shopping", style: UIAlertAction.Style.default, handler: {
            alert -> Void in
            
            self.dismiss(animated: true, completion: nil)
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            if appDelegate.window!.rootViewController as? UITabBarController != nil {
                
                let tababarController = appDelegate.window!.rootViewController as! UITabBarController
                
                tababarController.selectedIndex = 0
                var categoryView =  tababarController.viewControllers![0] as! Categories
            
            }
            
        })
        let subview :UIView = alertController.view.subviews.last! as UIView
        let alertContentView = subview.subviews.last! as UIView
        alertContentView.backgroundColor = UIColor.white
        alertController.view.tintColor = UIColor.red
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
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
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(Ordersummary.CancelPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        addressTextField.inputView = addressPicker
        addressTextField.inputAccessoryView = toolBar
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return shippingAddress.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return shippingAddress[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if shippingAddress.count > 0
        {
            addressTextField.text = "Ship to:"+shippingAddress[row]
            billingAddressID = shippingAddressID[row]
            print(billingAddressID)
        }
    }
    
    @objc func CancelPicker() {
        
        addressTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.view.makeToastActivity(.center)
        clearSearchProductData()
        viewCart()
        self.orderTableView.tableFooterView = UIView()
         UserDefaults.standard.set(false, forKey: "CartView")
    }
    
    func viewCart(){
        
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token"){
                let response = Api().callApi(token as NSString,url: viewShoppingCart)
                switch response.0 {
                case 200:
                    
                    appendCartProducts(response.1)
                case 400:
                    print("")
                case 500:
                   
                   Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                case 401:
                    print()
                    Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                    loginScreen = true
                    let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                    self.present(signinScreen, animated: true, completion: nil)
                case 0:
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView == self.orderTableView) ? cartList.count : productOffer.count
        
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = (indexPath as NSIndexPath).row
        if(tableView == self.orderTableView){
        let cell:Ordersummarycustomcell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Ordersummarycustomcell
            
        let cartData = cartList[(indexPath as NSIndexPath).row]
        print(cartData)
            
//            if cartData.productId == 0 {
//                cartList.remove(at:(indexPath as NSIndexPath).row)
//            }
        cell.productName?.text = cartData.productName
        cell.productPrice?.text = String(cartData.unitPrice)
        
        cell.productQuantity?.text = String(cartData.productQty)
        cell.quantityButton.tag = (indexPath as NSIndexPath).row
        print(offers)
            cell.amountLabel.isHidden  = false
            cell.offers.isHidden = false
       /// let offerList = offers[(indexPath as NSIndexPath).row]
       // print(offerList)
            cell.offers?.text = String(cartData.totalAmount)
            print("offer count2")
            cell.offerButton.isHidden = true
           // print(cartData.appliedOffer)
            print("cart offer")
            print()
            
            if offerIndex[(indexPath as NSIndexPath).row] == 1{
                cell.offerButton.isHidden = false
            }
            else{
                 cell.offerButton.isHidden = true
            }
            
            
        print(productOfferIndex)
            
        OfferTableView.reloadData()
     
            cell.quantityButton.addTarget(self, action: #selector(Ordersummary.changeProductQuantity(_:)), for: UIControl.Event.touchUpInside)
            cell.removeProduct.tag = (indexPath as NSIndexPath).row
            cell.removeProduct.addTarget(self, action: #selector(Ordersummary.deleteProduct(_:)), for: UIControl.Event.touchUpInside)
  
        cell.offerButton.tag = (indexPath as NSIndexPath).row
        cell.contentView.backgroundColor =  UIColor.clear
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 5, y: 8, width: self.view.frame.size.width - 5, height: 90))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.8])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubviewToBack(whiteRoundedView)
        
        if let img = cacheCart.object(forKey: cartData.imageUrl as AnyObject) {
            cell.productImage.image = img as? UIImage
            cell.productImage.contentMode = .scaleAspectFill
        }else{
            
            DispatchQueue.global().async {
                let url = URL(string:"\(imagePath)\(cartData.imageUrl)")
                DispatchQueue.main.async{
                    let data = try? Data(contentsOf: url!)
                    if data != nil {
                        cell.productImage.image = UIImage(data:data!)
                        cell.productImage.contentMode = .scaleAspectFill
                        self.cacheCart.setObject(UIImage(data: data! as Data)!, forKey: cartData.imageUrl as AnyObject)
                    }
                    
                }
            }
        }
          return cell
        }
        else{
            print(productOffer)
            let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
            cell.textLabel!.text = productOffer[row]
            
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12)

            return cell
        }
    }
    func clearSearchProductData(){
        UserDefaults.standard.removeObject(forKey: "idSearch")
        
        UserDefaults.standard.removeObject(forKey: "nameSearch")
    }
    
    @objc func deleteProduct(_ sender:UIButton){
        
        let alertController = UIAlertController(title: "Alert!", message: "Are you sure, want to delete product?", preferredStyle: UIAlertController.Style.alert)
        
        let saveAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: {
            alert -> Void in
            
            let sender: UIButton = sender
            let index : IndexPath = IndexPath(row: sender.tag, section: 0)
            print((index as NSIndexPath).row)
            
            if Reachability.isConnectedToNetwork() == true {
                self.view.makeToastActivity(.center)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    let removeProduct =  self.cartList[index.row]
                    let id = removeProduct.productId
                    let url = removeCartProduct+String(id)
                    let defaults = UserDefaults.standard
                    if let token = defaults.string(forKey: "Token"){
                        let result = Api().deleteById(token as NSString,url: url as NSString,method: "DELETE")
                        
                        switch result.0{
                        case 200:
                            print(result.0)
                            // self.updateCart()
                            self.offerOnGrandTotal = ""
                            self.productOfferIndex.removeAll()
                            self.offers.removeAll()
                            self.productOffer.removeAll()
                            self.removeBillOffer()
                            self.viewCart()
                            self.view.hideToastActivity()
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
                }
                self.view.hideToastActivity()
            }
            else{
                Commonhelper().showErrorMessage(internetError)
            }
            
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
       
        let subview :UIView = alertController.view.subviews.last! as UIView
        let alertContentView = subview.subviews.last! as UIView
        alertContentView.backgroundColor = UIColor.white
        alertController.view.tintColor = UIColor.red
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
  
    
    func appendCartProducts(_ cartData:(NSDictionary)){
        
        cartList.removeAll()
        let data = cartData.value(forKey: "Result") as! NSDictionary
        let cartBillingOffer = data.value(forKey: "ShoppingCartBillOfferDetails")
        if let items = cartBillingOffer as? [String:AnyObject] {
            billAmount = items["GrandTotal"] as! Double
            billAmountBeforeDiscount = items["BillAmountBeforeDiscount"] as! Double
            depositAmount = items["DepositAmount"] as! Double
            discountAmount = items["DiscountAmount"] as! Double
            totalTaxAmount = items["TotalTaxAmount"] as! Double
            noOfBottlesReturn = items["NoOfBottlesReturn"] as! Int
            billingAmount = items["BillAmount"] as! Double
            
            if let offerOnTotalAmount = items["OfferDescription"] as? String{
              offerOnGrandTotal = offerOnTotalAmount
             }
         }
        
        if let items = data["ShoppingCartProductDetails"] as? [[String:AnyObject]]
        {
            offerIndex.removeAll()
            cartOfferProduct.removeAll()
            cartOfferProductQty.removeAll()
            for item in items {
                print("offernonoe")
                print(item["OffersApplied"]?.count)
                cartList.append(Cart(dictionary:item ))
                offer.removeAll()
                
//                for invalidProduct in cartList{
//                    
//                }
                
                for (index, element) in cartList.enumerated() {
                    print("Item at index \(index): \(element)")
                    if element.productId == 0{
                        cartList.remove(at:index)
                        invalidOfferIndex = index
                        print("invalid offer")
                        //removeBillOffer()
                        print(invalidOfferIndex!)
                        print("test2")
                    }
                }
                
                
                if (item["OffersApplied"]?.count)! > 0{
                    //If offer present then appending 1 else 0
                    offerIndex.append(1)
                    if let cartOffer = item["OffersApplied"] as? NSArray{
                        for dict in cartOffer as! [NSDictionary]{
                            
                            
                            
                            
                            for (index, element) in cartOffer.enumerated()
                            {
                                print(invalidOfferIndex)
                                    print("invalid")
                                
                                
          
                                
                                //offerIndex.append(index)
                                cartOfferProduct.append(dict["OfferProducName"]! as! String)
                            
                                cartOfferProductQty.append(dict["OfferQuantity"]! as! Int)
                                
                                
//                                if index != invalidOfferIndex!{
                               
                                
                                //}
                            }
                            //print(dict["OfferProducName"])
                            
                        }
                    }
                   
                    
                }
                else{
                    offerIndex.append(0)
                }
                
                
                print("checkoffer")
                print(offerIndex)
//                for (key, value) in (item["OffersApplied"]) as? NSArray{
//                    print("key \(key) value2 \(value)")
//                    if key == "OfferProducName"{
//                        let applicableoffer = "#"+String(describing: value)
//                        print("offerappliva" + a)pplicableoffer)
//                    }
//                }
                
                
                
                
                if  (item["OffersApplied"]?.count)! > 0 {
                    
                    print(item["OffersApplied"]?["OfferProducName"])
                    
//                    for desc in item["OfferDescription"] as! NSArray{
//                        self.offer.append(desc as! String)
//                    }
                    
                }
                else{
//                    offer.removeAll()
//                    offer.append(("nil" as AnyObject) as! String)
                    
                }
   
            }
        }
        print("outside")
        print(invalidOfferIndex)
        print(offerIndex)
//        
//        if offerIndex.contains(invalidOfferIndex!){
//            offerIndex.remove(at: invalidOfferIndex!)
//            cartOfferProduct.remove(at: invalidOfferIndex!)
//        }
        
        
        productOfferIndex.removeAll()
        for (index, offerList) in offers.enumerated() {
             for offer in offerList as! [String]{
                print(offer)
                if offer == "nil"{
                    
                }
                else{
                    //show offers
                    if productOfferIndex.contains(index){
                        //already present
                    }
                    else{
                        productOfferIndex.append(index)
                    }
                }
            }
            
            print(productOfferIndex)
            
        }
        appliedOfferList.removeAll()
    orderTableView.reloadData()
    deposite.text = String(depositAmount)
    GST.text = String(totalTaxAmount)
    total.text = String(billAmount)
    bottles.text = String(noOfBottlesReturn)
    totalBill.text = String(billingAmount)
        if cartList.count == 0{
            navigateToCategeory()
        }
     
    }
    
    func updateCart(){
        do {
            print(updateCartDict)
            
            let jsonData = try JSONSerialization.data(withJSONObject: updateCartDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print(JSONString)
                
                if Reachability.isConnectedToNetwork() == true {
                    
                    let defaults = UserDefaults.standard
                    if let token = defaults.string(forKey: "Token"){
                        let result = Api().postApiResponse(token as NSString, url: updateShoppingCartList as NSString,post: JSONString as NSString,method: "PUT")
                        
                        switch result.0 {
                        case 200  :
                            self.view.makeToast("Quantity updated.")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            self.removeBillOffer()
                            self.viewCart()
                            }
                        case 401  :
                            let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                            self.present(signinScreen, animated: true, completion: nil)
                        case 500  :
                            Commonhelper().showErrorMessage(internalError,title: errorTitle)
                        case 0:
                            Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                        default :
                            print("")
                        }
                        print(result.0)
                    }
                }
                else{
                    Commonhelper().showErrorMessage(internetError)
                }
                
            }
            
         } catch {
            
        }
    }
    
    @objc func changeProductQuantity(_ sender:UIButton)
    {
        let sender: UIButton = sender
        let index : IndexPath = IndexPath(row: sender.tag, section: 0)
        
        let alertController = UIAlertController(title: "Enter Quantity", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let saveAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: {
            alert -> Void in
            
            let quantity = alertController.textFields![0] as UITextField
            if quantity.text?.length != 0 {
            let qty:Int = Int(quantity.text!)! as Int
            if qty != 0 && qty < 999{
                
                self.updateCartDict.removeAll()
                let cartChange = self.cartList[index.row]
                self.updateCartDict["ProductId"] =  cartChange.productId as AnyObject?
                self.updateCartDict["ProductQty"] = qty as AnyObject as AnyObject?
            self.checkOfferDetails(id: cartChange.productId as Int,qty: qty as Int,productName: cartChange.productName)
                
                
                //self.updateCart()
                
            }
            else{
                
                self.view.makeToast("Invalid quantity.")
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Change Quantity"
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
    
    func checkOfferDetails(id:Int,qty: Int,productName:String){
        
        print(getOffer+"productId="+String(id)+"&qty="+String(qty))
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token"){
                let result = Api().callApi(token as NSString,url: getOffer+"productId="+String(id)+"&qty="+String(qty))
                
                print("offernj")
                print(result.1)
                switch result.0 {
                case 200  :
                    let response :AnyObject = (result.1).value(forKey: "Result")! as AnyObject
                    if response.count > 0 {
                        let defaultID = UserDefaults.standard
                        defaultID.set(String(id), forKey: "ProductId")
                        let defaultQty = UserDefaults.standard
                        defaultQty.set(String(qty), forKey: "ProductQty")
                        let defaultName = UserDefaults.standard
                        defaultName.set(String(productName), forKey: "productName")
                        
                        
                        performSegue(withIdentifier: "summaryToOffer", sender: nil)
                    }
                    else{
                         self.updateCart()
                    }
                    
                case 401  :
                    Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                    // loginScreen = true
                    let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                    self.present(signinScreen, animated: true, completion: nil)
                case 500  :
                    Commonhelper().showErrorMessage(internalError,title: errorTitle)
                case 0:
                    Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                default :
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        
        if segue.identifier == "summaryToOffer"
        {
            var viewController = segue.destination as! Offers
            viewController.updateCartView = true
            
        }
        
    }
   
    @IBAction func Viewalloffers(_ sender: AnyObject) {
        customOfferView.isHidden = false
        productOffer.removeAll()
        for selectedRow in productOfferIndex{
            let offerCollection = offers[selectedRow]
        for offer in offerCollection as! [String]{
            productOffer.append(offer)
        }
            
        }
        if offerOnGrandTotal != ""
        {
            productOffer.append(offerOnGrandTotal)
        }
        for appliedoffer in appliedOfferList{
        productOffer.append(appliedoffer)
        }
        if cartOfferProduct.count > 0 {
            for (index, offer) in cartOfferProduct.enumerated(){
            //for offer in self.cartOfferProduct{
               // for qty in cartOfferProductQty{
        self.productOffer.append(offer + " - "+String(cartOfferProductQty[index]))//+" - ")//+String(qty))
               // }
            }
        }
        if productOffer.count == 0{
            productOffer.append("No offers applicable.")
            //self.view.makeToast("No offers applicable.")
        }
        OfferTableView.reloadData()
        
    }
    
    func removeBillOffer(){
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "Token"){
            let result = Api().deleteById(token as NSString,url: removeBillOfferProduct as NSString,method: "DELETE")
            
            switch result.0{
            case 200:
                print(result.0)
               
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
    }








