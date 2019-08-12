//
//  Orderdetail.swift
//  Coke
//
//  Created by Deepak on 18/04/17.
//  Copyright © 2017 IOS Development. All rights reserved.
//

import UIKit

class Orderdetail: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource{

    @IBOutlet weak var gst: UILabel!
    @IBOutlet weak var totalAmt: UILabel!
    //@IBOutlet weak var previousDue: UILabel!
    @IBOutlet weak var deposit: UILabel!
    @IBOutlet weak var grandTotal: UILabel!
   
    @IBOutlet weak var Viewoffers: UIButton!
    @IBOutlet weak var shippingAddress: UILabel!
    @IBOutlet weak var bottleReturn: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var orderID: UILabel!
    
    @IBOutlet weak var addressShipping: UITextField!
    var orderMaster = [OrdersMaster]()
    @IBOutlet weak var OrderList: UITableView!
    var orderProductList = [Orderdetails]()
    var allOfferList = [OffersOnOrder]()
    var orderDetailID:Int?
    var shippingAddressCollection:[String] = []
    var shippingAddressID:[Int] = []
    var orderNumber:Int?
    var shippingID:Int?
    var selectedAddress:String?
    var customOfferView:UIView!
    var OfferTableView: UITableView = UITableView()
    var cancelButton : UIButton!
    var offerList = ["Test offer1","Test offer2"]
    override func viewDidLoad() {
        super.viewDidLoad()
        print("orderty")
        
        print(orderDetailID)
        self.OrderList.delegate = self
        self.OrderList.dataSource = self
        OrderList.tableFooterView = UIView()
        Viewoffers.layer.borderWidth = 1
        Viewoffers.layer.borderColor = UIColor.red.cgColor
        createPicker()
        OfferTableView.dataSource = self
        OfferTableView.delegate = self
//        //addressShipping.rightViewMode = UITextFieldViewMode.always
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        let image = UIImage(named:"home-interface")
//        imageView.image = image
//        addressShipping.leftView = imageView
        
        addressShipping.layer.borderColor = UIColor.white.cgColor
        addressShipping.layer.borderWidth = 1.0
        addressShipping.font = UIFont.boldSystemFont(ofSize: 12)
        addressShipping.textColor = UIColor.white
        addressShipping.textAlignment = .center
        
        let screenSize: CGRect = UIScreen.main.bounds
        customOfferView=UIView(frame: CGRect(x: screenSize.width*0.100, y: screenSize.height*0.23, width: screenSize.width*0.8, height: 180))
        customOfferView.backgroundColor=UIColor.white
        self.view.addSubview(customOfferView)
        let offerText = UILabel()
        offerText.frame = CGRect(x: screenSize.width*0.300, y:10, width: 80, height: 14)
        customOfferView.addSubview(offerText)
        
       
        
        offerText.text = "-OFFERS-"
        offerText.textColor = UIColor.red
        offerText.font = UIFont.boldSystemFont(ofSize: 14)
        offerText.textAlignment = .center
        customOfferView.layer.shadowColor = UIColor.black.cgColor
        customOfferView.layer.shadowOpacity = 1
        customOfferView.layer.shadowOffset = CGSize.zero
        customOfferView.layer.shadowRadius = 2
        cancelButton = UIButton(frame: CGRect(x:screenSize.width*0.30, y: 140, width: 70.00, height: 33.00))
        cancelButton.setImage(UIImage(named: "delete-cross"), for: UIControl.State.normal)
        customOfferView.addSubview(cancelButton)
        
        cancelButton.addTarget(self, action: #selector(Orderdetail.cancelButtonTapped), for: .touchUpInside)
        Viewoffers.addTarget(self, action: #selector(Orderdetail.showOfferView), for: .touchUpInside)
        var view = UIView()
       view = UIView(frame: CGRect(x: 0, y: 27, width: screenSize.width*0.8, height: 1))
        customOfferView.addSubview(view)
        view.backgroundColor = UIColor.red
        customOfferView.isHidden = true
        OfferTableView.frame = CGRect(x: 0, y: 30, width: screenSize.width*0.8, height: 110)
        OfferTableView.delegate = self
        OfferTableView.dataSource = self
        //self.OfferTableView.separatorStyle = .none
        OfferTableView.backgroundColor = UIColor.white
        OfferTableView.rowHeight = 20
        customOfferView.addSubview(OfferTableView)
    }
    @objc func showOfferView(){
        if(allOfferList.count == 0)
        {
             let screenSize: CGRect = UIScreen.main.bounds
            let noneOffer = UILabel()
            noneOffer.frame = CGRect(x: screenSize.width*0.200, y:37.5, width: 150, height: 10)
            customOfferView.addSubview(noneOffer)
            noneOffer.text = "No offers applicable."
            noneOffer.font = UIFont.systemFont(ofSize: 12)
        }
        OfferTableView.reloadData()
        customOfferView.isHidden = false
        
    }
    @objc func cancelButtonTapped(){
        customOfferView.isHidden = true
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
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(Orderdetail.CancelPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let changeButton = UIBarButtonItem(title: "Change address", style: UIBarButtonItem.Style.plain, target: self, action: #selector(Orderdetail.changeAddress))
        toolBar.setItems([changeButton,spaceButton, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        addressShipping.inputView = addressPicker
        addressShipping.inputAccessoryView = toolBar
        
    }
    
    @objc func CancelPicker() {
        
        addressShipping.resignFirstResponder()
    }
    
    @objc func changeAddress() {
        
        //{OrderId}&ShippingAddressId={ShippingAddressId}
        
        
        if Reachability.isConnectedToNetwork() == true {
            self.view.makeToastActivity(.center)
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token"){
                
                let postData = "OrderId=\(orderNumber!)&ShippingAddressId=\(shippingID!)"
                print(postData)
                //Api().callApi(token as NSString,url:updateOrderAddress as NSString)
                //Api().postApiResponse(token, url: updateOrderAddress as NSString, post: postData as NSString, method: "POST")
                
                let response = Api().postApiResponse(token as NSString, url: updateOrderAddress as NSString, post: postData as NSString, method: "POST")
                print(updateOrderAddress+postData)
                print(response)
                
                switch response.0 {
                case 200:
                     self.view.hideToastActivity()
                    self.view.makeToast("Shipping address changed successfully.")
                addressShipping.text = selectedAddress
                addressShipping.resignFirstResponder()
                case 400:
                    addressShipping.resignFirstResponder()
                    
                    let errors:NSArray = response.1.value(forKey: "Errors") as! NSArray
                    for error in errors{
                        Commonhelper().showErrorMessage(error as! String)
                    }
                    
//                    let errors:NSString = response.1.value(forKey: "Errors") as! NSS
//                    Commonhelper().showErrorMessage(errors as String)
                case 401  :
                    let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                    self.present(signinScreen, animated: true, completion: nil)
                case 500  :
                    addressShipping.resignFirstResponder()
                    Commonhelper().showErrorMessage(internalError,title: errorTitle)
                case 0:
                    addressShipping.resignFirstResponder()
                    Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                    
                default:
                    addressShipping.resignFirstResponder()
                    print("")
                    
                }
                self.view.hideToastActivity()
                
               
            }
        }
           else {
            self.view.hideToastActivity()
            Commonhelper().showErrorMessage(internetError)
   
        }
    }
    
    
    
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return shippingAddressCollection.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return shippingAddressCollection[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if shippingAddressCollection.count > 0
        {
            print("added addd"+String(row))
            selectedAddress = shippingAddressCollection[row]
            shippingID = shippingAddressID[row]
            print(shippingID)
        }
    }
    
        override var prefersStatusBarHidden: Bool {
            return true
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Reachability.isConnectedToNetwork() == true {
            
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token"){
                let result = Api().callApi(token as NSString,url:orderListUrl+String(describing: orderDetailID!))
                print(orderListUrl+String(describing: orderDetailID!))
                switch result.0  {
                case 200:
                    
                        self.orderProductList.removeAll()
                        let data = (result.1).value(forKey: "Result") as? NSDictionary
                        let order = data?.value(forKey: "OrderList") as! NSArray
                        let orders = order.value(forKey: "OrderProductViewModel") as! NSArray
                        
                        for dict in (orders as? [NSArray])!
                        {
                            
                           for item in dict {
                            self.orderProductList.append(Orderdetails(dictionary:item as! [String : AnyObject]))
                            }
                            
                        }
                        allOfferList.removeAll()
                        let offers = order.value(forKey: "OfferProducts") as! NSArray
                        if offers.count > 0{
                        for dict in (offers as? [NSArray])!
                        {
                            
                            for item in dict {
                                self.allOfferList.append(OffersOnOrder(dictionary:item as! [String : AnyObject]))
                            }
                            
                        }
                        }
                        print("offerproduct")
                        
                        let resultMaster:AnyObject = (result.1).value(forKey: "Result")! as AnyObject
                        let allOrders:AnyObject = (resultMaster).value(forKey: "OrderList")! as AnyObject
                        if let items = allOrders as? [AnyObject]
                        {
                            for item in items {
                                orderMaster.append(OrdersMaster(dictionary:item as! [String : AnyObject]))
                                print(orderMaster)
                            }
                    }
                    print(allOfferList)
                    showMasterData()
                    OrderList.reloadData()
               case 500:
                    Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                case 0:
                    Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                    
                default:
                    let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                    self.present(signinScreen, animated: true, completion: nil)
                }
            }
        }
        else
        {
            Commonhelper().showErrorMessage(internetError)
        }
        
    }
    
    
    func showMasterData(){
        
        let orders = orderMaster[0]
        print("orders.erpInvoiceID")
        print(orders.erpInvoiceID)
      if orders.erpInvoiceID == "" && orders.orderStatus == "Ready for Delivery"{
            status.text = "Confirmed"
        
       }
       else{
        status.text = orders.orderStatus
     }
        
        totalAmt.text = String(orders.totalAmount)
        grandTotal.text = String(orders.grandTotal)
        gst.text = String(orders.taxAmt)
        //previousDue.text = String(orders.due)
        bottleReturn.text = String(orders.bottleReturn)
        addressShipping.text = orders.address
        
       
        
       orderID.text = "#"+String(orders.orderId)
        orderNumber = orders.orderId
        deposit.text = String(orders.deposit)
        let dateSplitted = String(orders.orderDate).trimmingCharacters(in: .whitespaces).components(separatedBy: "T")
          date.text = String(dateSplitted[0])
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token"){
                let response =   Api().callApi(token as NSString,url: getAllShippingAddress)
                if (response.0 == 200 && (response.1["Result"]! as AnyObject).count>0)
                {
                    shippingAddressCollection.removeAll()
                    
                    if let response = response.1["Result"] as? NSArray{
                        
                        for dict in response as! [NSDictionary]{
                            shippingAddressCollection.append(dict["AddressTitle"] as! String)
                            shippingAddressID.append(dict["AddressId"] as! Int)
                        }
                       // addressTextField.text = "SHIP TO: "+shippingAddress[0]
                        //billingAddressID = shippingAddressID[0]
                    }
                }
            }
        }
        else
        {
            Commonhelper().showErrorMessage(internetError)
        }
        
        if shippingAddressID.count > 0{
            self.shippingID = self.shippingAddressID[0]
        }
        
    }
    
    @IBAction func makePayment(_ sender: AnyObject) {
        
       performSegue(withIdentifier: "detailTopayment", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "detailTopayment"
        {
            let placedOrderView = segue.destination as! Placedorder
            let order = orderMaster[0]
            
            placedOrderView.orderID = order.orderId
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       

        return (tableView == self.OrderList) ? orderProductList.count : allOfferList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = (indexPath as NSIndexPath).row
        if(tableView == self.OrderList){
        let cell:Orderlistcustomcell = OrderList.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Orderlistcustomcell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let orders = orderProductList[(indexPath as NSIndexPath).row]
        cell.qty.text = String(orders.quantity)
        cell.productName.text = orders.productName
        cell.price.text = String(orders.unitPrice) + " M.V.R"
        let imageUrl = orders.imageUrl
        let url = URL(string:"\(imagePath)\(imageUrl)")
        let data = try? Data(contentsOf: url!)
        if data != nil {
            cell.productImage.image = UIImage(data:data!)
            cell.productImage.contentMode = .scaleAspectFill
            
        }
        
        return cell
        }
        else{
            let row = (indexPath as NSIndexPath).row
             let offer = allOfferList[row]
            let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
            cell.textLabel!.text = offer.productName+" - "+String(offer.quantity)
            
            cell.textLabel?.font = UIFont.systemFont(ofSize: 11)
            
            return cell
        }
    }
    
    @IBAction func navigateToOrderView(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        
    }
   
}
