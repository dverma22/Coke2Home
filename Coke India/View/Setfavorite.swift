//
//  Wishlist.swift
//  FlagOn
//
//  Created by SSDB on 7/26/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import MIBadgeButton_Swift

class Setfavorite: UIViewController,UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate,UIActionSheetDelegate{
    
    @IBOutlet weak var favoriteTableView: UITableView!
    var favoriteList = [Favorites]()
    var productName:String!
    //var productDescription:String!
    var selectedIndex = 0
    var cartButton : MIBadgeButton!
    var updateCartDict = [String: AnyObject]()
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "FavoriteProduct", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "FavoriteProduct"
        {
            let favoriteList = self.favoriteList[selectedIndex]
            let productDetail = segue.destination as! Productdetail
            productDetail.defaultIndex = favoriteList.productId
            print(favoriteList.categoryID)
            print(favoriteList.productId)
            productDetail.id = favoriteList.categoryID
            productDetail.selectedCategory = favoriteList.categoryName
            
            UserDefaults.standard.set(favoriteList.productId, forKey: "idSearch")
            UserDefaults.standard.setValue(favoriteList.productName, forKey: "nameSearch")
            
        }
        if segue.identifier == "favoriteToOffer"
        {
            _ = segue.destination as! Offers
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.view.makeToastActivity(.center)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        favoriteTableView.tableFooterView = UIView()
        if Reachability.isConnectedToNetwork() == true {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token"){
                let result = Api().callApi(token as NSString,url:getAllFavorites)
                if  result.0 == 200 {
                let allFavorites = (result.1).value(forKey: "Result") as! NSDictionary
                
                if (allFavorites).count > 0{
                    self.favoriteList.removeAll()
                    let data = allFavorites.value(forKey: "FavoriteProductlist")
                    for dict in data as! [NSDictionary]{
                        self.favoriteList.append(Favorites(dictionary:dict as! [String : AnyObject]))
                        print(self.favoriteList)
                        self.favoriteTableView.reloadData()
                        
                    }
                }
                    if self.favoriteList.count == 0{
                        self.navigateToCategeory()
                    }
                }
            }
                self.setProductCount()
        }
         self.view.hideToastActivity()
  
        }
        else
        {
            Commonhelper().showErrorMessage(internetError)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds
        cartButton  = MIBadgeButton(frame: CGRect(x: screenSize.width/1.2, y: 16, width: 35, height: 30))
        cartButton.setImage(UIImage(named: "empty-shopping-cart"), for: UIControl.State.normal)
        cartButton.badgeTextColor = UIColor.black
        
        cartButton.badgeBackgroundColor = UIColor.yellow
        cartButton.addTarget(self, action: #selector(Setfavorite.navigateToSummary(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(cartButton)
        
    }
    func navigateToCategeory(){
        
        let alertController = UIAlertController(title: "Alert!", message: "There are no products in your favorites.", preferredStyle: UIAlertController.Style.alert)
        
        let saveAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
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

    
    @objc func navigateToSummary(_ sender: UIButton!)
    {
        self.view.makeToastActivity(.center)
        let orderSummary : Ordersummary = mainStoryboard.instantiateViewController(withIdentifier: "OrderSummary") as! Ordersummary
        self.present(orderSummary, animated: true, completion: nil)
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
                Commonhelper().showErrorMessage(internetError)
            }
        }
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favoriteList.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let reuseIdentifier = "programmaticCell"
        var cell = self.favoriteTableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! MGSwipeTableCell?
        
        
         if cell == nil
        {
            cell = MGSwipeTableCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        }
        let favoriteList = self.favoriteList[(indexPath as NSIndexPath).row]
        
        cell?.textLabel!.text = favoriteList.productName
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell?.detailTextLabel!.text = "MVR: "+String(favoriteList.unitPrice)
        cell?.detailTextLabel?.textColor = UIColor.black
        cell?.textLabel?.textColor = UIColor.red
        cell?.delegate = self
        
        let url = URL(string:"\(imagePath)\(favoriteList.productImage)")
        
        //let url = URL(string: image.url)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            if data != nil {
            //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                cell?.imageView?.image = UIImage(data: data!)
                 cell?.imageView?.contentMode = .scaleAspectFill
            }
            }
        }
        
       let thumb = URL(string:"\(imagePath)\(favoriteList.productThumb)")
        var productThumbnail = try? Data(contentsOf: thumb!)
         if productThumbnail == nil {
            let placeholderImage = URL(string:defaultproductThumb)
             productThumbnail = try? Data(contentsOf: placeholderImage!)
        }
    
       let itemSize:CGSize = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
        
        let imageRect : CGRect = CGRect(x: 0, y:0, width: itemSize.width, height: itemSize.height)

        cell?.imageView!.image?.draw(in: imageRect)
        cell?.imageView!.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

            cell?.rightButtons = [MGSwipeButton(title: "", icon: UIImage(named:"garbage (3).png"), backgroundColor: UIColor.clear)
                ,MGSwipeButton(title: "", icon: UIImage(named:"shopping-cart.png"), backgroundColor: UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)),MGSwipeButton(title: "", icon: UIImage(data:productThumbnail!), backgroundColor: UIColor.clear)]
        cell?.rightSwipeSettings.transition = MGSwipeTransition.rotate3D
        return cell!
     }

    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        print("Button \(index) tapped")
        let indexPath = favoriteTableView.indexPath(for: cell)
        
        print("Selected\(indexPath?.row)")
        switch index {
        case 0:
            deleteFavorite(index: (indexPath?.row)!)
            print("None")
        case 1:
            moveToCartList(index: (indexPath?.row)!)
        case 2:
             print("last")
            
        default:
            print("None")
        }
         return true
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 65.0
    }
    
    func moveToCartList(index:Int){
        
        let alertController = UIAlertController(title: "Enter Quantity", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let saveAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: {
            alert -> Void in
            
            let quantity = alertController.textFields![0] as UITextField
            if quantity.text?.length != 0 {
                let qty:Int = Int(quantity.text!)! as Int
                if qty != 0 && qty <= 999{
                    
                    let favoriteList = self.favoriteList[(index)]
                    self.updateCartDict.removeAll()
                    self.updateCartDict["ProductId"] =  favoriteList.productId as AnyObject
                    self.updateCartDict["ProductQty"] = qty as AnyObject
                    
                    self.checkOfferDetails(index: index,qty: qty)
                    //self.updateCart()
                    
                }
                else{
                     Commonhelper().showErrorMessage("Invalid quantity.",title: "Alert!")
                   
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
    
    func checkOfferDetails(index:Int,qty: Int){
        
        
        let products = favoriteList[index]
        
        print(getOffer+"productId="+String(products.productId)+"&qty="+String(qty))
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token"){
                let result = Api().callApi(token as NSString,url: getOffer+"productId="+String(products.productId)+"&qty="+String(qty))
                
                
                print(result.1)
                switch result.0 {
                case 200  :
                    let response :AnyObject = (result.1).value(forKey: "Result")! as AnyObject
                    if response.count > 0 {
                        let defaultID = UserDefaults.standard
                        defaultID.set(String(products.productId), forKey: "ProductId")
                        let defaultQty = UserDefaults.standard
                        defaultQty.set(String(qty), forKey: "ProductQty")
                        let defaultName = UserDefaults.standard
                        defaultName.set(String(products.productName), forKey: "productName")
                        performSegue(withIdentifier: "favoriteToOffer", sender: nil)
                    }
                    else{
                        updateCart()
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
    
   func updateCart(){
        do {
            print(updateCartDict)
            
            let jsonData = try JSONSerialization.data(withJSONObject: updateCartDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print(JSONString)
                
                if Reachability.isConnectedToNetwork() == true {
                    let defaults = UserDefaults.standard
                    if let token = defaults.string(forKey: "Token"){
                        let result = Api().callApi(token as NSString, post: JSONString as NSString,url: addProduct as NSString)
                        
                        switch result.0 {
                        case 200  :
                            //not working toast
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                                Commonhelper().showErrorMessage("Successfully added.",title: "Alert!")
                            
                            }
                            getProductCount()
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
    func getProductCount(){
        
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
                Commonhelper().showErrorMessage(internetError)
            }
        }
    }
   
    func deleteFavorite(index:Int) {
        
        if Reachability.isConnectedToNetwork() == true {
            self.view.makeToastActivity(.center)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token"){
            let favoriteArray =  self.favoriteList[index]
            let id = favoriteArray.favoriteId
            let url = removeFavorite+String(id)+""
            let result = Api().deleteById(token as NSString,url: url as NSString,method: "DELETE")
           if result.0 == 200{
             self.favoriteList.remove(at: (index))
             self.favoriteTableView.reloadData()
                
         }
                if  self.favoriteList.count == 0{
                    self.navigateToCategeory()
                }
            }
        }
            self.view.hideToastActivity()
        }
       else{
            Commonhelper().showErrorMessage(internetError)
        }
    }

}

