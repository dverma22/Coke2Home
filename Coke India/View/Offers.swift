//
//  Offers.swift
//  Coke
//
//  Created by Deepak on 06/06/17.
//  Copyright © 2017 IOS Development. All rights reserved.
//

import UIKit

class Offers: UIViewController,UITableViewDelegate,UITableViewDataSource{

    
    @IBOutlet weak var selectedOffer: UILabel!
    @IBOutlet weak var product: UILabel!
    @IBOutlet weak var offerTableView: UITableView!
    var offerProductID:String?
    var offerProductQty:String?
    var loginScreen = false
    var selected:Int?
    var offerList = [Offer]()
    var productDict = [String: AnyObject]()
    var selectedOfferList = [Int]()
    var offerType = [Int]()
    var index:Int?
    var updateCartDict = [String: AnyObject]()
    var updateCartView:Bool?
    var url = ""
    var method = "POST"
    var specialOfferProduct = [Int]()
    var grandTotal:String?
    var billOfferDict = [String: AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.offerTableView.delegate = self
        self.offerTableView.dataSource = self
        
        offerTableView.tableFooterView = UIView()
    // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if defaults.bool(forKey: "CartView") == true{
                
                if let amt = defaults.string(forKey: "billAmount")
                {
                    grandTotal = amt
                    offerOnBillingAmount()
                }
            }
            else{
                
                if let id = defaults.string(forKey: "ProductId")
                {
                    offerProductID = id
                    product.text = defaults.string(forKey: "productName")
                }
                if let qty = defaults.string(forKey: "ProductQty")
                {
                    offerProductQty = qty
                }
                
                getOffers()
                
            }
        
        
    }
    
    
    func offerOnBillingAmount(){
        
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token"){
                
                print(grandTotal)
                let responseBillOffer = Api().callApi(token as NSString,url: "\(offerOnBillAmt)\(String(describing: grandTotal!))")
                
                let result :AnyObject = (responseBillOffer.1).value(forKey: "Result")! as AnyObject
                
                    if result.count > 0 {
                        let amt = UserDefaults.standard
                        amt.set(nil, forKey: "billAmount")
                        appendOffers(responseBillOffer.1)
                        //performSegue(withIdentifier: "summaryToOffer", sender: nil)
                        
                    }
//
//                }
            }
                
            else{
                
                Commonhelper().showErrorMessage(internalError)
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if loginScreen == true{
            let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
            self.present(signinScreen, animated: true, completion: nil)
        }
        
    }
    
    func getOffers(){
        
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token"){
                let result = Api().callApi(token as NSString,url: getOffer+"productId="+String(describing: offerProductID!)+"&qty="+String(describing: offerProductQty!))
                
                print("offernj")
                print(result.1)
                switch result.0 {
                case 200  :
                    let response :AnyObject = (result.1).value(forKey: "Result")! as AnyObject
                    if response.count > 0 {
                        appendOffers(result.1)
                    }
                    
                case 401  :
                    Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                    loginScreen = true
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
                loginScreen = true
                let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                self.present(signinScreen, animated: true, completion: nil)
            }
        }
        else{
            Commonhelper().showErrorMessage(internetError)
        }
    }
    
    func appendOffers(_ response:(NSDictionary)){
        
        if response.count > 0
        {
            offerList.removeAll()
            if let items = response["Result"] as? [[String:AnyObject]]
            {
                for item in items {
                    self.offerList.append(Offer(dictionary:item))
                }
            }
            
            
        }
        
    }
    
    func tableView(_ locationTableview: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedOfferList.removeAll()
        offerType.removeAll()
       index = indexPath.row
         let selected = offerList[indexPath.row]
        if specialOfferProduct.contains(index!){
            
        Commonhelper().showErrorMessage("This offer is applied offer please choose another one.",title: "Alert!")
           
        }
        else{
            selectedOfferList.append(selected.OfferId)
            offerType.append(selected.OfferTypeId)
            selectedOffer.text = selected.OfferProductName
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return offerList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:offerCustomCell = tableView.dequeueReusableCell(withIdentifier: "offersCell", for: indexPath) as! offerCustomCell
       let offer = offerList[(indexPath as NSIndexPath).row]
        
        cell.qty?.text = String(offer.OfferQuantity)
        cell.productName?.text = offer.OfferProductName
        if offer.defaultType == true{
            cell.qty?.text = String(offer.OfferQuantity)
            cell.productName?.text = offer.AppliedType+"-"+offer.OfferProductName
            cell.qty?.textColor = UIColor.red
            cell.productName?.textColor = UIColor.red
            specialOfferProduct.append((indexPath as NSIndexPath).row)
           // selectedOfferList.append(offer.OfferId)
            //offerType.append(offer.OfferTypeId)
         }
        
        return cell
        
    }
    
    @IBAction func dissmissView(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func Done(_ sender: AnyObject) {
        
        if defaults.bool(forKey: "CartView") == true{
             if index != nil{
                applyBillOffer()
                
            }
             else{
                confirmOrderAfterBillOffer()
            }
            
        }
        else{
            addToCart()
        }
        
      }
    
    func applyBillOffer(){
        
//        let offer = offerList[index!]
//        offerList.removeAll()
       
        
        do {
            let offer = offerList[index!]
            self.billOfferDict.removeAll()
            billOfferDict["OfferId"] = offer.OfferId as AnyObject?
            billOfferDict["OfferTypeId"] = offer.OfferTypeId as AnyObject?
            print(billOfferDict)
            
         let jsonData = try JSONSerialization.data(withJSONObject: billOfferDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print(JSONString)
                
                if Reachability.isConnectedToNetwork() == true {
                    let defaults = UserDefaults.standard
                    if let token = defaults.string(forKey: "Token"){
                        print(url)
                        let result = Api().postApiResponse(token as NSString, url: addBillOffer as NSString,post: JSONString as NSString,method: "POST")
                        
                        switch result.0 {
                        case 200  :
                            //not working toast
                           confirmOrderAfterBillOffer()
                        case 400:
                            Ordersummary().removeBillOffer()
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
    
    func addToCart(){
        if index != nil{
            
            if updateCartView == true{
                print(updateShoppingCartList)
                url = updateShoppingCartList
                method = "PUT"
                updateCartQty()
                
            }
            else{
                url = addProduct
                method = "POST"
                updateCartQty()
            }
            
        }
        else{
            if updateCartView == true{
                url = updateShoppingCartList
                method = "PUT"
                updateCart()
                
            }
            else{
                url = addProduct
                method = "POST"
                updateCart()
            }
        }
    }
    
    func updateCartQty(){
        do {
           if specialOfferProduct.count > 0{
                for special in specialOfferProduct{
                     let offer = offerList[special]
                   selectedOfferList.append(offer.OfferId)
                    offerType.append(offer.OfferTypeId)
                }
                
            }
            let offer = offerList[index!]
            offerList.removeAll()
            productDict["ProductId"] =  offer.ProductId as AnyObject?
            productDict["ProductQty"] = offer.ProductQty as AnyObject?
            productDict["OfferIds"] = selectedOfferList as AnyObject?
            productDict["OfferTypeIds"] = offerType as AnyObject?
             print(productDict)
            
            let jsonData = try JSONSerialization.data(withJSONObject: productDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print(JSONString)
                
                if Reachability.isConnectedToNetwork() == true {
                    
                    let defaults = UserDefaults.standard
                    if let token = defaults.string(forKey: "Token"){
                        print(url)
                        print(method)
                        let result = Api().postApiResponse(token as NSString, url: url as NSString,post: JSONString as NSString,method: method as NSString)
                        
                        switch result.0 {
                        case 200  :
                            self.view.makeToast("Product added to cart.")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                //Disappear screen
                                self.dismiss(animated: true, completion: nil)
                               // self.viewCart()
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

    
   func updateCart(){
        do {
            
            self.updateCartDict.removeAll()
            self.updateCartDict["ProductId"] =  offerProductID! as AnyObject?
            self.updateCartDict["ProductQty"] = offerProductQty! as AnyObject?
            print(updateCartDict)
            
            
            let jsonData = try JSONSerialization.data(withJSONObject: updateCartDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print(JSONString)
                
                if Reachability.isConnectedToNetwork() == true {
                    let defaults = UserDefaults.standard
                    if let token = defaults.string(forKey: "Token"){
                        print(url)
                        let result = Api().postApiResponse(token as NSString, url: url as NSString,post: JSONString as NSString,method: method as NSString)
                        
                        switch result.0 {
                        case 200  :
                            //not working toast
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                                self.view.makeToast("Successfully added.")
                                print("Added product")
                                self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func noneOftheOfferSelected(_ sender: AnyObject) {
        
        if defaults.bool(forKey: "CartView") == true{
             Ordersummary().removeBillOffer()
            confirmOrderAfterBillOffer()
           
        }
        else{
            url = addProduct
            method = "POST"
            updateCart()
        }
    }
    
    func confirmOrderAfterBillOffer(){
        
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "Token"){
            var selectedShippingAddress:String?
            if let selectedAddress = defaults.string(forKey: "shippingAddressID")
            {
                
                selectedShippingAddress = selectedAddress
                //offerOnBillingAmount()
            }
            let post:NSString = "OrderShippingAddressId=\(selectedShippingAddress!)&SourceType=\(2)" as NSString
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
                Ordersummary().removeBillOffer()
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
    
    
    
    
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
