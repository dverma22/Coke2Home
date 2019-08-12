//
//  Placedorder.swift
//  Coke
//
//  Created by SSDB on 7/26/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

import UIKit

class Placedorder: UIViewController {
    
    var paymentLabel:UILabel!
    var confirmButton:UIButton!
    var selectedPaymentMode = 0
    var globalID : String?
    var orderID:Int?
    var dueAmount:Double?
    var totalAmt:Double?
    var paymentMode:String?
    var mode:Int?
    var invoiceID:Int?
    var dueBalanceAmt:Double?
    var StatusDescription:String?
    var cancelOrderDict = [String: AnyObject]()
    var modeString = "Cod"
    @IBOutlet weak var confirmed: UILabel!
    @IBOutlet weak var outForDelivery: UILabel!
    @IBOutlet weak var orderStatusImage: UIImageView!
    @IBOutlet weak var placedTime: UILabel!
    @IBOutlet weak var placed: UILabel!
    @IBOutlet weak var confirmedTime: UILabel!
    @IBOutlet weak var delivered: UILabel!
    @IBOutlet weak var id: UILabel!
    var cancelledLabel:UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var cancelOrder: UIButton!
    @IBOutlet weak var viewOrder: UIButton!
    let paymentSegmentedControl = UISegmentedControl (items: ["Cash on delivery","Online payment"])
    var codLabel:UILabel!
    var paymentCollection = [String: AnyObject]()
    var dueLabel:UILabel!
    weak var timer: Timer?
    @IBOutlet weak var paymentStatusLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        cancelledLabel = UILabel(frame: CGRect(x: 5, y: screenSize.height*0.63, width: screenSize.width-5, height: 50))
        cancelledLabel.numberOfLines = 0
        cancelledLabel.textAlignment = .center
        cancelledLabel.text = "Your order has been cancelled."
        cancelledLabel.font = UIFont.boldSystemFont(ofSize: 11)
        cancelledLabel.textColor = UIColor.blue
        self.view.addSubview(cancelledLabel)
        cancelledLabel.isHidden = true
        cancelOrder.addTarget(self, action: #selector(Placedorder.cancelOrder(_:)), for: UIControl.Event.touchUpInside)
        var labelYPosition:Double = 0.0
        var segmentYPosition = 0.0
        var buttonYPostion = 0.0
        var segmentXPosition = 0.10
        
        switch screenSize.width {
        case 375.0:
            labelYPosition = Double(screenSize.height) * 0.70
            segmentYPosition = Double(screenSize.height) * 0.75
            buttonYPostion = Double(screenSize.height) * 0.82
            segmentXPosition = Double(screenSize.height) * 0.14
        //6plus
        case 414.0:
            labelYPosition = Double(screenSize.height) * 0.60
            segmentYPosition = Double(screenSize.height) * 0.65
            buttonYPostion = Double(screenSize.height) * 0.72
            segmentXPosition = Double(screenSize.height) * 0.14
        case 320.0:
            if screenSize.height == 568{
                labelYPosition = Double(screenSize.height) * 0.80
                segmentYPosition = Double(screenSize.height) * 0.85
                buttonYPostion = Double(screenSize.height) * 0.92
                segmentXPosition = Double(screenSize.height) * 0.10
            }
            else{
                //ipad
                labelYPosition = Double(screenSize.height) * 0.84
                segmentYPosition = Double(screenSize.height) * 0.87
                buttonYPostion = Double(screenSize.height) * 0.93
                segmentXPosition = Double(screenSize.height) * 0.12
            }
        default:
            print("")
        }
        print(screenSize.width)
        
        paymentLabel = UILabel(frame: CGRect(x: Double(screenSize.height*0.20), y: labelYPosition, width: 150, height: 13))
        self.view.addSubview(paymentLabel)
        paymentLabel.text = "Select payment method :"
        paymentLabel.font =  UIFont(name: "Arial", size: 13)
        confirmButton = UIButton(frame: CGRect(x: Double(screenSize.height*0.24), y:buttonYPostion, width:100, height:28))
        self.view.addSubview(confirmButton)
        
        dueLabel = UILabel(frame: CGRect(x: Double(screenSize.height*0.20), y:labelYPosition - 50, width:140, height:28))
        self.view.addSubview(dueLabel)
        
        dueLabel.font = UIFont.systemFont(ofSize: 11)
        
        codLabel = UILabel(frame: CGRect(x: Double(screenSize.height*0.12),y:buttonYPostion-165, width:200, height:28))
        self.view.addSubview(codLabel)
        codLabel.font = UIFont.systemFont(ofSize: 11)
        codLabel.numberOfLines = 0
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.addTarget(self, action:#selector(Placedorder.OrderConfirmed), for: .touchUpInside)
        confirmButton.backgroundColor = UIColor.red
        paymentSegmentedControl.frame = CGRect(x: CGFloat(segmentXPosition), y: CGFloat(segmentYPosition), width: 240, height: 25)
        
        paymentSegmentedControl.selectedSegmentIndex = 0
        paymentSegmentedControl.tintColor = UIColor.red
        paymentSegmentedControl.addTarget(self, action: #selector(Placedorder.segmentedValueChanged(_:)), for: .valueChanged)
        self.view.addSubview(paymentSegmentedControl)
        confirmedTime.isHidden = true
        placedTime.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.hideToastActivity()
    }
    
    @objc func OrderConfirmed(){
        
        switch selectedPaymentMode{
        case 0:
            if Reachability.isConnectedToNetwork() == true {
                mode = 0
                modeString = "Cod"
                passPaymentData()
            }
            else{
                Commonhelper().showErrorMessage(internetError)
            }
        case 1:
            
            mode = 1
            modeString = "Online"
            passPaymentData()
            performSegue(withIdentifier: "paymentSegue", sender: nil)
        default:
            print("None")
            
        }
    }
    
    func passPaymentData(){
        
        paymentCollection.removeAll()
        print(paymentMode as AnyObject?)
        
        paymentCollection["orderPaymentMode"] =  mode as AnyObject?
        paymentCollection["OrderId"] = orderID as AnyObject?
        
        let jsonPaymentData = try! JSONSerialization.data(withJSONObject: paymentCollection, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonPaymentString = NSString(data: jsonPaymentData, encoding: String.Encoding.utf8.rawValue)! as String
        
        if Reachability.isConnectedToNetwork() == true {
            
            let defaults = UserDefaults.standard
            
            if let token = defaults.string(forKey: "Token"){
                
                let paymentResponse = Api().postApiResponse(token as NSString, url: makePayment as NSString, post: jsonPaymentString as NSString, method: "POST")
                
                switch paymentResponse.0{
                    
                case 200:
                    self.view.hideToastActivity()
                    self.view.makeToast("Selected payment mode " + modeString)
                    self.getOrderStatus()
                case 400:
                    self.view.hideToastActivity()
                    let errors:NSArray = paymentResponse.1.value(forKey: "Errors") as! NSArray
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
    
    @objc func getOrderStatus(){
        
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "Token"){
            print(orderID)
            let response = Api().callApi(token as NSString, url: orderStatus+String(describing: orderID!))
            print(response.1)
            if response.0 == 200{
                self.cancelOrder.isUserInteractionEnabled = false
                let orderDetails = (response.1).value(forKey: "Result") as! NSDictionary
                for (key, value) in orderDetails {
                    
                    if key as! String == "OrderId"{
                        id.text = "#"+String(describing: value)
                        print("ids"+String(describing: value))
                    }
                    if key as! String == "GlobalOrderId"{
                        globalID = (value as? String)!
                        print("globalID"+globalID!)
                    }
                    
                    if let due = orderDetails["BillDuePayment"]{
                        dueBalanceAmt = due as? Double
                        print("duetest")
                        print(dueAmount)
                    }
                    if let total = orderDetails["TotalAmount"]{
                        totalAmt = total as? Double
                        print("Total")
                        print(total)
                    }
                    if let due = orderDetails["DueAmount"]{
                        dueAmount = due as? Double
                        print("Due")
                        print(dueAmount)
                    }
                    if let paymentmodeString = orderDetails["Paymentmode"]{
                        paymentMode = (paymentmodeString as? String)
                        
                    }
                    
                    if let invoice = orderDetails["InvoiceId"]{
                        invoiceID = (invoice as? Int)!
                    }
                    if let status = orderDetails["StatusDescription"]{
                        StatusDescription = (status as? String)!
                        
                    }
                    
                    if key as! String == "StatusId"{
                        switch value as! Int {
                            
                            
                        case 1,2,3,4:
                            //erpiD not present in api need to change once added in api -
                            var  erpInvoiceID:String?
                            if erpInvoiceID == ""{
          if ((value as! Int == 1 || value as! Int == 2 || value as! Int == 3 ) && (dueAmount! < 0.0 && totalAmt! > 0.0 && invoiceID == 0)){
                                Commonhelper().showErrorMessage("It seems you have paid in advance. Advance will be automatically applied when order status changes to “Ready for Delivery”.")
                            }
                            }
                            else{
                                print(dueAmount!)
                                if ((value as! Int == 1 || value as! Int == 2 || value as! Int == 3 ) && (dueAmount! < 0.0 && dueBalanceAmt! > 0.0) ){
                                    Commonhelper().showErrorMessage("It seems you have paid in advance. Advance will be automatically applied when order status changes to “Ready for Delivery”.")
                                  }
                                }
                                
                            
                            
                            
                            
                            if (value as! Int == 1){
                                
                                // DispatchQueue.main.async {
                                self.statusVisibility(boolValue: false)
                                self.cancelledLabel.isHidden = true
                                //self.cancelOrder.isUserInteractionEnabled = true
                                self.orderStatusImage.image = UIImage(named:"stage_1")
                                
                                self.paymentSegmentVisibility(boolValue: true)
                                self.placed.textColor = UIColor.red
                                //self.placed.shadowColor = UIColor.red
                                self.statusLabel.text = "Your order has been confirmed."
                                // }
                            }
                            
                            
                            if (value as! Int == 2 && invoiceID! > 0) {
                                self.statusVisibility(boolValue: false)
                                
                                statusVisibility(boolValue: false)
                                self.cancelledLabel.isHidden = true
                                self.orderStatusImage.image = UIImage(named:"stage_2")
                                self.placed.textColor = UIColor.red
                                self.confirmed.textColor = UIColor.red
                                self.statusLabel.text = "Your order is ready for delivery."
                                self.cancelledLabel.isHidden = true
                            }
                                
                            else if (value as! Int == 2) {
                                
                                self.cancelledLabel.isHidden = true
                                statusVisibility(boolValue: false)
                                self.placed.textColor = UIColor.red
                                paymentSegmentVisibility(boolValue: true)
                                self.statusLabel.text = "Your order has been confirmed."
                                self.orderStatusImage.image = UIImage(named:"stage_1")
                                
                            }
                            
                            if (value as! Int == 3) {
                                DispatchQueue.main.async {
                                    self.statusVisibility(boolValue: false)
                                    //self.cancelledLabel.isUserInteractionEnabled = true
                                    self.placed.isHidden = false
                                    self.placed.textColor = UIColor.red
                                    self.confirmed.textColor = UIColor.red
                                    
                                    self.outForDelivery.textColor = UIColor.red
                                    self.statusLabel.text = "Your order is out for delivery."
                                    self.orderStatusImage.image = UIImage(named:"stage_3")
                                }
                            }
                            if (value as! Int == 4) {
                                statusVisibility(boolValue: false)
                                //cancelOrder.isUserInteractionEnabled = true
                                self.placed.textColor = UIColor.red
                                self.confirmed.textColor = UIColor.red
                                self.outForDelivery.textColor = UIColor.red
                                self.delivered.textColor = UIColor.red
                                self.statusLabel.text = "Your order has been delivered."
                                self.orderStatusImage.image = UIImage(named:"stage_4")
                                
                            }
                            
                            if invoiceID! > 0 {
                                if(dueBalanceAmt! == 0.0){
                                    paymentSegmentVisibility(boolValue: true)
                                    if(paymentMode != nil && paymentMode! == "OnlinePayment" ){
                                        self.cancelledLabel.isHidden = false
                                        //cancelOrder.isUserInteractionEnabled = false
                                        self.cancelledLabel.text = "Your payment has been done for this order.\(self.paymentMode!)"
                                        
                                    }
                                    else{
                                        self.cancelledLabel.isHidden = false
                                        //self did false cancel- match with android
                                        //cancelOrder.isUserInteractionEnabled = false
                                        self.cancelledLabel.text = "Your payment has been done for this order."
                                    }
                                    
                                }else{
                                    paymentSegmentVisibility(boolValue: false)
                                    dueLabel.isHidden = false
                                    dueLabel.text = "Billdue Amount: "+String(describing: dueBalanceAmt!)
                                    
                                    if(paymentMode != nil && paymentMode! == "Cod"){
                                        
                                        paymentSegmentedControl.selectedSegmentIndex = 0
                                        
                                        codLabel.isHidden = false
                                        
                                    }
                                    else{
                                        //Cod check default online failed need to handle
                                    }
                                }
                            }
                            else{
                                DispatchQueue.main.async {
                                    self.paymentSegmentVisibility(boolValue: false)
                                    self.dueLabel.isHidden = false
                                    self.dueLabel.text = "Billdue Amount: "+String(describing: self.totalAmt!)
                                    if (self.totalAmt! > 0.0) {
                                        self.cancelOrder.isUserInteractionEnabled = true
                                    }
                                }
                            }
                        case 5,6,7:
                            
                            paymentSegmentVisibility(boolValue: true)
                            dueLabel.isHidden = true
                            if (value as? Int == 5) {
                                
                                DispatchQueue.main.async {
                                    
                                    self.cancelledLabel.isHidden = false
                                    
                                    self.placed.isHidden = true
                                    
                                    self.confirmed.isHidden = true
                                    
                                    self.delivered.isHidden = true
                                    
                                    self.outForDelivery.isHidden = true
                                    
                                    self.orderStatusImage.isHidden = true
                                    
                                    self.cancelledLabel.text = "#"+String(describing: self.orderID!)+" This order is cancelled.In case you didn't cancel the order then please contact customer care or place new order."
                                    self.statusLabel.text = "Your order has been cancelled."
                                    
                                    DispatchQueue.main.async {
                                        
                                        self.paymentSegmentedControl.isHidden = true
                                        
                                        self.paymentLabel.isHidden = true
                                        
                                        self.confirmButton.isHidden = true
                                        
                                    }
                                    
                                }
                            }
                            
                            if (value as? Int == 6) {
                                
                                cancelledLabel.isHidden = false
                                
                                placed.isHidden = true
                                
                                confirmed.isHidden = true
                                
                                delivered.isHidden = true
                                
                                outForDelivery.isHidden = true
                                
                                orderStatusImage.isHidden = true
                                
                                cancelledLabel.text = "Order ID: "+String(describing: orderID!)+"  This order is undelivered.please contact customer care or place new order."
                                statusLabel.text = "This order is undelivered."
                                
                            }
                            
                            if (value as? Int == 7) {
                                
                                cancelledLabel.isHidden = false
                                placed.isHidden = true
                                confirmed.isHidden = true
                                
                                delivered.isHidden = true
                                
                                outForDelivery.isHidden = true
                                
                                orderStatusImage.isHidden = true
                                
                                cancelledLabel.text = "Order ID: "+String(describing: orderID!)+" Update you soon."
                                statusLabel.text = "Update to soon."
                                
                            }
                            
                            
                        default:
                            print("")
                        }
                        
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
    
    func paymentSegmentVisibility(boolValue:Bool){
        DispatchQueue.main.async {
            self.paymentLabel.isHidden = boolValue
            
            self.confirmButton.isHidden = boolValue
            
            self.paymentSegmentedControl.isHidden = boolValue
        }
    }
    
    func statusVisibility(boolValue:Bool){
        DispatchQueue.main.async {
            
            self.placed.isHidden = boolValue
            self.confirmed.isHidden = boolValue
            self.delivered.isHidden = boolValue
            self.outForDelivery.isHidden = boolValue
            self.orderStatusImage.isHidden = boolValue
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.makeToastActivity(.center)
        statusVisibility(boolValue: true)
        cancelOrder.isUserInteractionEnabled = false
        cancelledLabel.isHidden = true
        dueLabel.isHidden = true
        statusVisibility(boolValue: true)
        
        codLabel.isHidden = true
        codLabel.textAlignment = .center
        codLabel.textColor = UIColor.red
        codLabel.text = "You have choosen payment mode Cod."
        if let id = defaults.string(forKey: "summaryOrderID")
        {
            orderID = Int(id)
            
        }
        let defaultID = UserDefaults.standard
        defaultID.set(nil, forKey: "summaryOrderID")
        timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(Placedorder.getOrderStatus), userInfo: nil, repeats: false)
        // getOrderStatus
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "paymentSegue"
        {
            let paymentView = segue.destination as! Makepayment
            paymentView.globalOrderID = globalID
            
        }
        if segue.identifier == "placedorderToDetail"
        {
            let orderListView = segue.destination as! Orderdetail
            orderListView.orderDetailID = orderID!
            
        }
        if segue.identifier == "cancelOrder"
        {
            let cancelOrder = segue.destination as! Cancelorder
            cancelOrder.orderDatailId = orderID!
        }
    }
    
    
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!)
    {
        print(sender.selectedSegmentIndex)
        selectedPaymentMode = sender.selectedSegmentIndex
        
    }
    
    @IBAction func cancelOrder(_ sender: AnyObject) {
     if (invoiceID == 0 && totalAmt! > 0.0) {
        performSegue(withIdentifier: "cancelOrder", sender: nil)
    }
//        if (invoiceID == 0 && totalAmt! > 0.0) {
//            print("cancelOrder called")
//            let alertController = UIAlertController(title: "", message: "Are you sure, you want to cancel your order?", preferredStyle: UIAlertControllerStyle.alert)
//
//            let saveAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: {
//                alert -> Void in
//
//
//            })
//            let cancelAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: {
//                (action : UIAlertAction!) -> Void in
//                let commentTextbox = alertController.textFields![0] as UITextField
//                if (commentTextbox.text?.length)! > 0{
//                    let post:NSString = "comment=\(commentTextbox.text!)&orderId=\(self.orderID!)" as NSString
//
//                    let jsonCancelData = try! JSONSerialization.data(withJSONObject: self.cancelOrderDict, options: JSONSerialization.WritingOptions.prettyPrinted)
//                    let jsonCancelString = NSString(data: jsonCancelData, encoding: String.Encoding.utf8.rawValue)! as String
//                    print(jsonCancelString)
//                    if Reachability.isConnectedToNetwork() == true {
//                        let defaults = UserDefaults.standard
//                        if let token = defaults.string(forKey: "Token"){
//                            let response = Api().postApiResponse(token as NSString, url: cancelOrderAPI as NSString, post: post, method: "POST")
//                            print(response.0)
//                            if let errors:NSArray = response.1.value(forKey: "Errors") as! NSArray?{
//                                if response.0 == 200 && errors.count == 0{
//                                    print(commentTextbox.text)
//
//                                    alertController.dismiss(animated: true, completion: nil)
//                                    self.getOrderStatus()
//                                }
//                                else{
//                                    for error in errors{
//                                        Commonhelper().showErrorMessage(error as! String)
//                                    }
//                                }
//                            }
//                        }
//                        else{
//                            let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
//                            self.present(signinScreen, animated: true, completion: nil)
//                        }
//                    }
//                    else{
//                        Commonhelper().showErrorMessage(internetError)
//                    }
//
//
//                }
//                else{
//                    self.view.makeToast("Reason required.")
//                }
//            })
//
//            alertController.addTextField { (textField : UITextField!) -> Void in
//                textField.placeholder = "Reason"
//
//            }
//            let subview :UIView = alertController.view.subviews.last! as UIView
//            let alertContentView = subview.subviews.last! as UIView
//            alertContentView.backgroundColor = UIColor.white
//            alertController.view.tintColor = UIColor.red
//            alertController.addAction(saveAction)
//            alertController.addAction(cancelAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
//
//        else {
//            self.view.makeToast("You can't cancel your order.Please contact customer care.")
//
//        }

    }
    
    
    
    @IBAction func viewOrders(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "placedorderToDetail", sender: nil)
        
        
    }
    
    @IBAction func goBack(_ sender: AnyObject) {
        
        self.view.makeToastActivity(.center)
        
    }
}
