//
//  Productdetail.swift
//  Coke
//
//  Created by Deepak on 19/12/16.
//  Copyright © 2016 IOS Development. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift

class Productdetail: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var quantityContainerView: UIView!
    @IBOutlet weak var categoryTopLabel: UILabel!
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var reminder: UIButton!
    @IBOutlet weak var productTable: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var unitPrice: UILabel!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var offerFirst: UILabel!
    var cartCustom:UIButton!
    
    var categoryId = [Int]()
    var favoriteList = [Favorites]()
    var listOfproductName = [String]()
    var id:Int!
    var selectedProductName = ""
    var cartButton : MIBadgeButton!
    var listOfproductId = [Int]()
    var selectedIndex = 0
    var listOfFavoritePoductId = [Int]()
    var increaseQuantity:UIButton!
    var quantityLabel:UILabel!
    var decreaseQuantity:UIButton!
    var productQuantity = 1
    var objectPosition = 33
    var selectedCategory = ""
    var defaultIndex = 0
    var cache = NSCache<AnyObject, AnyObject>()
    var offerList = [String]()
    var productDict = [String: AnyObject]()
    var loginScreen = false
    var productID:Int?
    var productOfferList = [String]()
    var customOfferView:UIView!
    var OfferTableView: UITableView = UITableView()
    var cancelButton : UIButton!
    var productIDForReminder:Int?
    var productId :Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        
        let screenSize = UIScreen.main.bounds
        let width = self.view.frame.width
        addToCart.isHidden = true
        var quantityWidth = 50
        var quantityLabelFromIncreaseButton = 53
        var cartButtonPosition:CGFloat = 0.77 as CGFloat
        switch width {
        case 375.0:
            objectPosition = 63
            cartButtonPosition = 0.77
        //6plus
        case 414.0:
            objectPosition = 72
            quantityWidth = 35
            quantityLabelFromIncreaseButton = 46
            cartButtonPosition = 0.73
        case 320.0:
            if screenSize.height == 568{
                objectPosition = 63
                cartButtonPosition = 0.88
            }
            else{
                //ipad
                objectPosition = 63
                //dont want to show
                cartButtonPosition = -0.25
                addToCart.isHidden = false
            }
            
        default:
            print("not an iPhone")
            
        }
        
       // offerSecond.isHidden = true
        cartCustom = UIButton()
        cartCustom.frame = CGRect(x: screenSize.width*0.46, y: screenSize.height*cartButtonPosition, width: 125, height: 31)
        cartCustom.backgroundColor = UIColor.red
        
        cartCustom.setTitle("ADD TO CART", for: UIControl.State.normal)
        cartCustom.titleLabel!.font =  UIFont.boldSystemFont(ofSize: 14)
        
        self.view.addSubview(cartCustom)
        increaseQuantity = UIButton(frame: CGRect(x:objectPosition+55+23, y:5, width:quantityWidth, height:40))
        
        
        let increaseImage = UIImage(named: "plus-symbol-in-a-rounded-black-square_27x27") as UIImage?
        increaseQuantity.setImage(increaseImage, for: UIControl.State())
        increaseQuantity.tintColor = UIColor(red: 244.0/255, green: 0.0/255, blue: 0.0/255, alpha: 1.0)
        
        quantityContainerView.addSubview(increaseQuantity)
        quantityLabel = UILabel(frame: CGRect(x: objectPosition+quantityLabelFromIncreaseButton, y: Int(16.5), width: 29, height: 20))
        quantityLabel.text = "1"
        quantityLabel.textAlignment = .center
        quantityLabel.textColor = UIColor.black
        quantityLabel.font = UIFont.boldSystemFont(ofSize: 12)
        self.quantityContainerView.addSubview(quantityLabel)
        
        let decreaseQuantity = UIButton(frame: CGRect(x:objectPosition, y:5, width:quantityWidth, height:40))
        
        let decreaseImage = UIImage(named: "minus-sign-inside-a-black-rounded-square-shape_27x27") as UIImage?
        decreaseQuantity.setImage(decreaseImage, for: UIControl.State())
        quantityContainerView.addSubview(decreaseQuantity)
        
        increaseQuantity.addTarget(self, action:#selector(self.increaseProductQuantity), for: .touchUpInside)
        decreaseQuantity.addTarget(self, action:#selector(self.decreaseProductQuantity), for: .touchUpInside)
        backButton.addTarget(self, action:#selector(self.backPressed), for: .touchUpInside)
        favorite.addTarget(self, action:#selector(Productdetail.setFavorites), for: .touchUpInside)
        reminder.addTarget(self, action:#selector(Productdetail.setCokeReminder), for: .touchUpInside)
        Commonhelper().buttonCornerRadius(addToCart)
        categoryTopLabel.text = selectedCategory
        cartCustom.addTarget(self, action:#selector(Productdetail.updateCart), for: .touchUpInside)
        
        
        let screenWidth = screenSize.width
        cartButton  = MIBadgeButton(frame: CGRect(x: screenWidth/1.2, y: 15, width: 35, height: 30))
        cartButton.setImage(UIImage(named: "empty-shopping-cart"), for: UIControl.State.normal)
        cartButton.badgeTextColor = UIColor.black
        
        cartButton.badgeBackgroundColor = UIColor.yellow
        cartButton.addTarget(self, action: #selector(Productdetail.cartManager(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(cartButton)
        productTable.tableFooterView = UIView()
         Commonhelper().buttonCornerRadius(cartCustom)
        
        customOfferView=UIView(frame: CGRect(x: screenSize.width*0.100, y: screenSize.height*0.23, width: screenSize.width*0.8, height: 180))
        customOfferView.backgroundColor=UIColor.white
        self.view.addSubview(customOfferView)
        let offerText = UILabel()
        offerText.frame = CGRect(x: screenSize.width*0.300, y:10, width: 80, height: 15)
        customOfferView.addSubview(offerText)
        
        
        
        offerText.text = "-OFFERS-"
        offerText.textColor = UIColor.red
        offerText.font = UIFont.boldSystemFont(ofSize: 15)
        customOfferView.layer.shadowColor = UIColor.black.cgColor
        offerText.textAlignment = .center
        customOfferView.layer.shadowOpacity = 1
        customOfferView.layer.shadowOffset = CGSize.zero
        customOfferView.layer.shadowRadius = 2
        cancelButton = UIButton(frame: CGRect(x:screenSize.width*0.30, y: 140, width: 70.00, height: 33.00))
        cancelButton.setImage(UIImage(named: "delete-cross"), for: UIControl.State.normal)
        customOfferView.addSubview(cancelButton)
        
        cancelButton.addTarget(self, action: #selector(Orderdetail.cancelButtonTapped), for: .touchUpInside)
        customOfferView.isHidden = true
        OfferTableView.frame = CGRect(x: 0, y: 30, width: screenSize.width*0.8, height: 110)
        OfferTableView.delegate = self
        OfferTableView.dataSource = self
        //self.OfferTableView.separatorStyle = .none
        OfferTableView.backgroundColor = UIColor.white
        OfferTableView.rowHeight = 20
        customOfferView.addSubview(OfferTableView)
        var view = UIView()
        view = UIView(frame: CGRect(x: 0, y: 27, width: screenSize.width*0.8, height: 1))
        view.backgroundColor = UIColor.red
        customOfferView.addSubview(view)
    }
    
    @objc func updateCart(){
        //clearSearchProductData()
       checkOfferDetails()
    }
    
    func cancelButtonTapped(){
        customOfferView.isHidden = true
    }
    func addProductsToCart(){
        if defaultIndex != 0{
            selectedIndex = defaultIndex
        }
        let products = productList[selectedIndex]
        productDict.removeAll()
        //
        productDict["ProductId"] =  products.productId as AnyObject?
        productDict["ProductQty"] = productQuantity as AnyObject?
        
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: productDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print(JSONString)
                
                if Reachability.isConnectedToNetwork() == true {
                    let defaults = UserDefaults.standard
                    if let token = defaults.string(forKey: "Token"){
                        let result = Api().callApi(token as NSString, post: JSONString as NSString,url: addProduct as NSString)
                        
                        switch result.0 {
                        case 200  :
                            print(result)
                            setProductCount()
                            self.view.makeToast("Successfully added.")
                        case 401  :
                            Commonhelper().showErrorMessage(internalError,title: errorTitle)
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


    @objc func increaseProductQuantity(){
        
        
        if productQuantity < 5 {
            self.productQuantity = 1+self.productQuantity
            self.quantityLabel.text = String(productQuantity)
            
        }
        else{
           changeQty()
        }
    }
    
    func changeQty(){
        
        let alertController = UIAlertController(title: "Enter Quantity", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let saveAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: {
            alert -> Void in
            
            let quantity = alertController.textFields![0] as UITextField
            if quantity.text?.length != 0 {
                let qty:Int = Int(quantity.text!)! as Int
                if qty != 0 && qty < 999{
                    self.productQuantity = qty
                    self.quantityLabel.text = String(self.productQuantity)
                    //self.updateCart()
                    
                }
                else{
                    self.view.makeToast("Invalid quantity.")
                }
            }
            
           //self.productQuantity = self.productQuantity-1
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in
//            if self.productQuantity > 5{
//            self.productQuantity = self.productQuantity-1
//            self.quantityLabel.text = String(self.productQuantity)
//            }
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
    
    
    
    @objc func decreaseProductQuantity(){
        
        if productQuantity > 1 {
            productQuantity = productQuantity-1
            quantityLabel.text = String(productQuantity)
        }
    }
    
    @objc func backPressed() {
        clearSearchProductData()
        self.dismiss(animated: true, completion: nil)
//        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
//        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = viewController
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (tableView == self.productTable) ? productList.count : productOfferList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if(tableView == self.productTable){
        let cell:Productdetailcustomcell = productTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Productdetailcustomcell
        
        let view = UIView()
        view.backgroundColor = UIColor(red:244/255,green:0/255,blue:0/255 ,alpha:0.80)
        cell.selectedBackgroundView = view
        
        cell.contentView.backgroundColor =  UIColor.clear
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 2, y: 8, width: self.view.frame.size.width - 10, height: 149))
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.8])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubviewToBack(whiteRoundedView)
        
        let productThumb = productList[(indexPath as NSIndexPath).row]
        cell.name.text = productThumb.productName
        
        if let img = cache.object(forKey: productThumb.productImage as AnyObject) {
            cell.productThumbnail.image = img as? UIImage
            cell.productThumbnail.contentMode = .scaleAspectFill
        }else{
            
            DispatchQueue.global().async {
                let url = URL(string:"\(imagePath)\(productThumb.thumbnail)")
                print(url)
                print("url data")
                DispatchQueue.main.async{
                    let data = try? Data(contentsOf: url!)
                    if data != nil {
                        cell.productThumbnail.image = UIImage(data:data!)
                        cell.productThumbnail.contentMode = .scaleAspectFill
                        self.cache.setObject(UIImage(data: data! as Data)!, forKey: productThumb.productImage as AnyObject)
                    }
                }
            }
        }
        
        return cell
        }
         else{
            let row = (indexPath as NSIndexPath).row
           
            let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
            cell.textLabel!.text =  productOfferList[row]
            
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
            
            return cell
        }
    }
    
    @IBAction func moreOffers(_ sender: AnyObject) {
        customOfferView.isHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        productQuantity = 1
        self.quantityLabel.text = String(productQuantity)
        self.view.makeToastActivity(.center)
        updateProductList()
        moreButton.isHidden = true
    }
    
    func updateProductList(){
        
        let defaultnsuser = UserDefaults.standard
        if let token = defaultnsuser.string(forKey: "Token"){
            let productApiResponse = Api().callApi(token as NSString,url: "\(getProductByCategoryId)\(Int(id))")
            print(id)
            if Reachability.isConnectedToNetwork() == true {
                switch productApiResponse.0 {
                case 200  :
                    listOfproductId.removeAll()
                    listOfproductName.removeAll()
                    productList.removeAll()
                    appendProducts(productApiResponse)
                    if let response = productApiResponse.1["Result"] as? NSArray{
                       
                        for dict in response as! [NSDictionary]{
                            
                            listOfproductName.append(dict["ProductName"] as! String)
                            listOfproductId.append(dict["ProductId"] as! Int)
                            
                        }
                        
                       
                    }
                    for (index, item) in listOfproductId.enumerated() {
                        
                        if item == defaultIndex{
                            defaultIndex =  index
                        }
                    }
                    print(listOfproductId)
                    print(defaultIndex)
                    
                   setDefaultProduct()
                    
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
            }
            else{
                Commonhelper().showErrorMessage(internetError)
            }
        }
            
    }
    
    func navigateToCategeory(){
        
        let alertController = UIAlertController(title: "Alert!", message: "There are no products in this category.Please choose another category.", preferredStyle: UIAlertController.Style.alert)
        
        let saveAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {
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
    
    
    func viewOfferDetails(id:Int){
        
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "Token"){
            //print(orderID)
            let response = Api().callApi(token as NSString, url: offerDesc+String(describing: id))
            print(response.1)
            if response.0 == 200{
                print("id")
                print("Got offer")
                productOfferList.removeAll()
                let offers:NSArray = response.1.value(forKey: "Result") as! NSArray
                if offers.count > 0 {
                    for offer in offers{
                        
                        productOfferList.append(offer as! String)
                    }
                    if productOfferList.count > 1{
                    moreButton.isHidden = false
                    }
                    else{
                        moreButton.isHidden = true
                    }
                }
                
                
            }
        }
    }
    
    func setDefaultProduct(){
        
        if productList.count > 0{
            let selectedProduct = productList[defaultIndex]
            
          viewOfferDetails(id: selectedProduct.productId)
            
            
            print(productOfferList)
            print("appended")
            
            
            productName.text = selectedProduct.productName
            offerFirst.text = "* No offer for today"
           // offerSecond.isHidden = true
            //offerList.removeAll()
            if productOfferList.count>0{
                offerFirst.text = "* "+productOfferList[0]
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    if self.productOfferList.count > 1{
                self.moreButton.isHidden = false
                    }
                    else{
                       self.moreButton.isHidden = true
                    }
                }

            }
            if selectedProduct.favouriteId != 0{
                
                favorite.tintColor = UIColor.red
            }
            
            unitPrice.text = String(selectedProduct.unitPrice)
            let url = URL(string:"\(imagePath)\(selectedProduct.productImage)")
            let data = try? Data(contentsOf: url!)
            if data != nil {
                productImage.image = UIImage(data:data!)
                productImage.contentMode = .scaleAspectFill
            }
            
        }
    }
    
    func setProductCount(){
        
        let defaults = UserDefaults.standard
        
        if let token = defaults.string(forKey: "Token"){
            
            let response = Api().callApi(token as NSString,url: productCartCount)
            if Reachability.isConnectedToNetwork() == true {
                switch response.0 {
                case 200  :
                    if let totalItems = response.1["Result"]{
                        cartButton.badgeString = String(describing: totalItems)
                    }
                case 401  :
                    let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                    self.present(signinScreen, animated: true, completion: nil)
                case 500  :
                    Commonhelper().showErrorMessage(internetError,title: errorTitle)
                case 0:
                    Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                default :
                    print("")
                }
            }
            else{
                //2times so commented
                //Commonhelper().showErrorMessage(internetError)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.makeToastActivity(.center)
        if loginScreen == true{
            let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
            self.present(signinScreen, animated: true, completion: nil)
        }
        setProductCount()
        self.view.hideToastActivity()
        if productList.count == 0{
            navigateToCategeory()
        }
    }
    
    func appendProducts(_ productApiResponse:(Int,NSDictionary)){
        
        productList.removeAll()
        if let items = productApiResponse.1["Result"] as? [[String:AnyObject]]
        {
            for item in items {
                
                productList.append(products(dictionary:item))
            }
        }
        
        productTable.reloadData()
    }
    
    @IBAction func addProducts(_ sender: AnyObject) {
        //clearSearchProductData()
        checkOfferDetails()
        print("check why it is ipad")
        
        
    }
    
    func checkOfferDetails(){
        
        if defaultIndex != 0{
            selectedIndex = defaultIndex
        }
        if productList.count > 0 {
        let products = productList[selectedIndex]
        productDict.removeAll()
        //
        productDict["ProductId"] =  products.productId as AnyObject?
        productDict["ProductQty"] = productQuantity as AnyObject?
        
            
            print(getOffer+"productId="+String(products.productId)+"&qty="+String(productQuantity))
            if Reachability.isConnectedToNetwork() == true {
                let defaults = UserDefaults.standard
                if let token = defaults.string(forKey: "Token"){
                    let result = Api().callApi(token as NSString,url: getOffer+"productId="+String(products.productId)+"&qty="+String(productQuantity))
                    
                    print("offernj")
                    print(result.1)
                    switch result.0 {
                    case 200  :
                        let response :AnyObject = (result.1).value(forKey: "Result")! as AnyObject
                        if response.count > 0 {
                            let defaultID = UserDefaults.standard
                            defaultID.set(String(products.productId), forKey: "ProductId")
                            let defaultQty = UserDefaults.standard
                            defaultQty.set(String(productQuantity), forKey: "ProductQty")
                            let defaultName = UserDefaults.standard
                            defaultName.set(String(products.productDescription), forKey: "productName")
                            performSegue(withIdentifier: "offerSegue", sender: nil)
                        }
                        else{
                           addProductsToCart()
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
                    
                    let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                    self.present(signinScreen, animated: true, completion: nil)
                }
            }
            else{
                Commonhelper().showErrorMessage(internetError)
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = (indexPath as NSIndexPath).row
        defaultIndex = selectedIndex
        let selectedProduct = productList[selectedIndex]
        productName.text = selectedProduct.productDescription
        productQuantity = 1
        self.quantityLabel.text = String(productQuantity)
        favorite.tintColor = UIColor(red: 113.0/255, green: 119.0/255, blue: 130.0/255, alpha: 1.0)
        offerFirst.text = "* No offer for Today"
       // offerSecond.isHidden = true
        clearSearchProductData()
        viewOfferDetails(id: selectedProduct.productId)
        
        
        
        
        
        if productOfferList.count>0{
            
            //offerList.removeAll()
            //moreButton.isHidden = false
             offerFirst.text = "* "+productOfferList[0]
            OfferTableView.reloadData()
            
//            for offer in selectedProduct.offerDescription{
//                offerList.append(offer)
//            }
//            if offerList.count == 1{
//                offerFirst.text = "* "+offerList[0]
//                //offerSecond.isHidden = true
//            }
//            if offerList.count == 2{
//                offerFirst.text = "* "+offerList[0]
//                //offerSecond.isHidden = false
//                //offerSecond.text = "* "+offerList[1]
//            }
        }
        
        unitPrice.text = String(selectedProduct.unitPrice)
        if selectedProduct.favouriteId != 0{
            favorite.tintColor = UIColor.red
        }
        let url = URL(string:"\(imagePath)\(selectedProduct.productImage)")
        let data = try? Data(contentsOf: url!)
        if data != nil {
            productImage.image = UIImage(data:data!)
        }
        
    }
    
    @objc func setCokeReminder(_ sender:UIButton){
        
        if productList.count > 0{
            let list = productList[selectedIndex]
            selectedProductName = (list.productName)
           
            // self.dismiss(animated: true, completion: nil)
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            if appDelegate.window!.rootViewController as? UITabBarController != nil {
                
                let tababarController = appDelegate.window!.rootViewController as! UITabBarController
                
                tababarController.selectedIndex = 2
                let remainderView =  tababarController.viewControllers![2] as! Setreminder
           
                    remainderView.product.text = selectedProductName
                    print(list.productId)
                    remainderView.productID = list.productId
                    productIDForReminder = list.productId
                     remainderView.setFavoriteFromPrductDetail = true
                
            }
        }
    }
    
    func clearSearchProductData(){
        UserDefaults.standard.removeObject(forKey: "idSearch")
        
        UserDefaults.standard.removeObject(forKey: "nameSearch")
    }
    
 
    
    @objc func setFavorites(_ sender:UIButton){
        
        listOfFavoritePoductId.removeAll()
        if productList.count > 0{
            favorite.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            let list = productList[selectedIndex]
            if let ID = (UserDefaults.standard.value(forKey: "idSearch")){
                print(ID)
                print("getting id")
                productId = ID as! Int
                
            }
            
            else{
                productId = list.productId
            }
            
//            if defaultIndex != 0{
//                productId = defaultIndex
//                listOfFavoritePoductId.append(productId!)
//            }
//            else{
            
            listOfFavoritePoductId.append(productId!)
           // }
            let openingBracks = "{"
            let closingBracks = "}"
            let post = openingBracks+"ProductId:\(listOfFavoritePoductId)\(closingBracks)"
            if Reachability.isConnectedToNetwork() == true {
                let defaults = UserDefaults.standard
                if let token = defaults.string(forKey: "Token"){
                    let result = Api().callApi(token as NSString, post: post as NSString,url: createFavorite as NSString)
                    
                    switch result.0 {
                    case 200  :
                        
                        UIView.animate(withDuration: 1.0,
                                       delay: 0,
                                       usingSpringWithDamping: CGFloat(0.20),
                                       initialSpringVelocity: CGFloat(6.0),
                                       options: UIView.AnimationOptions.allowUserInteraction,
                                       animations: {
                                        self.favorite.transform = CGAffineTransform.identity
                            },
                                       completion: { Void in()  }
                        )
                        self.view.makeToast("Product added to favorite successfully.")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            self.favorite.tintColor = UIColor.red
                            
                            self.updateProductList()
                            self.productTable.reloadData()
                            self.defaultIndex = self.selectedIndex
                            self.setDefaultProduct()
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
                    
                    let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                    self.present(signinScreen, animated: true, completion: nil)
                }
            }
            else{
                Commonhelper().showErrorMessage(internetError)
            }
        }
    }
    
    @objc func cartManager(_ sender: UIButton!){
        self.view.makeToastActivity(.center)
        clearSearchProductData()
        performSegue(withIdentifier: "navigateToOrderSummary", sender: nil)
        
    }
   
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "navigateToOrderSummary"
        {
            _ = segue.destination as! Ordersummary
            
        }
        if segue.identifier == "offerSegue"
        {
            _ = segue.destination as! Offers
            
        }
        
    }
    
    
}





