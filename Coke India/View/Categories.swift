//
//  Categories.swift
//  FlagOn
//
//  Created by SSDB on 20/12/16.
//  Copyright © 2016 IOS Development. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift
class Categories: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet weak var searchProducts: UIButton!
    var favoriteList = [Favorites]()
    var productName:String!
    var categoryNames = [String]()
    var categoryIds = [Int]()
    var categoryImage = [String]()
    var productDescription:String!
    var id = 0
    var listOfproductName = [String]()
    var listOfproductId = [Int]()
    var loginScreen = false
    var name = ""
    var cartButton : MIBadgeButton!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchProducts.isHidden = false
        let tabArray: [UITabBarItem] = (self.tabBarController?.tabBar.items)!
        for item in tabArray {
            item.image = item.image?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            item.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        }
        let screenSize = UIScreen.main.bounds
        cartButton  = MIBadgeButton(frame: CGRect(x: screenSize.width/1.17, y: 14, width: 35, height: 30))
        cartButton.setImage(UIImage(named: "empty-shopping-cart"), for: UIControl.State.normal)
        cartButton.badgeTextColor = UIColor.black
        
        cartButton.badgeBackgroundColor = UIColor.yellow
        cartButton.addTarget(self, action: #selector(Categories.navigateToSummary(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(cartButton)
        //searchProducts.imageEdgeInsets = UIEdgeInsets(top: 6, left: 2, bottom: 2, right: 2)
        // passDeviceToken()
        
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.makeToastActivity(.center)
       tabBarController?.customizableViewControllers=nil;
        self.tabBarController?.moreNavigationController.navigationBar.topItem?.title = "More"
        UserDefaults.standard.removeObject(forKey: "idSearch")
        
        UserDefaults.standard.removeObject(forKey: "nameSearch")
   //self.tabBarController?.moreNavigationController.topViewController?.view.tintColor = UIColor.red
        let view = self.tabBarController?.moreNavigationController.topViewController?.view
        view?.tintColor = UIColor.red
        //view.separatorStyle = .none
        //view.rowHeight = 25
        
        self.tabBarController?.moreNavigationController.navigationBar.tintColor = UIColor.red
        //self.tabBarController?.moreNavigationController.navigationBar.isHidden = false
    //self.tabBarController?.moreNavigationController.topViewController?.view.font = UIColor.redColor()
        //fetchCategory()
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
                //2times so commented
               // Commonhelper().showErrorMessage(internetError)
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if loginScreen == true{
            let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
            self.present(signinScreen, animated: true, completion: nil)
        }
        fetchCategory()
        setProductCount()
         self.view.hideToastActivity()
    }
   
    func fetchCategory(){
        
        let defaults = UserDefaults.standard
        print(defaults.string(forKey: "Token"))
        
        if let token = defaults.string(forKey: "Token"){
            if Reachability.isConnectedToNetwork() == true {
            if categoryIds.count == 0 || categoryNames.count == 0 || categoryImage.count == 0{
                let response = Api().callApi(token as NSString, url: category)
                let jsonData = response.1
                print("empty")
                switch response.0{
                case 200:
                    if let categoryData = jsonData["Result"] as? NSArray{
                        categoryIds.removeAll()
                        categoryNames.removeAll()
                        categoryImage.removeAll()
                        for dict in categoryData as! [NSDictionary]{
                            
                            categoryIds.append(dict["CategoryId"] as! Int)
                            categoryNames.append(dict["Name"] as! String)
                            if let image = dict["ImageUrl"] as? NSString {
                            categoryImage.append(dict["ImageUrl"] as! String)
                            }
                        }
                    }
                    
                    fetchProducts()
                    print(categoryNames)
                    self.categoryCollectionView.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5)
                    categoryCollectionView.reloadData()
                    
                case 401:
                    Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                     loginScreen = true
                    
                case 500:
                    
                    Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                case 0:
                    Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                default:
                    print("")
                }

                }
            }
            else{
                Commonhelper().showErrorMessage(internetError)
            }
        }
        else{
            
            loginScreen = true
        }
    }
    
    func fetchProducts(){
        //ask to ms condition should be there or not?
        if listOfproductName.count == 0{
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "Token"){
        let productApiResponse = Api().callApi(token as NSString,url: getProducts)
        
            switch productApiResponse.0{
            case 200:
                if (productApiResponse.1.value(forKey: "Result") as! NSArray).count > 0{
                if let response = productApiResponse.1["Result"] as? NSArray{
                    
                    for dict in response as! [NSDictionary]{
                        
                        listOfproductName.append(dict["ProductName"] as! String)
                        listOfproductId.append(dict["ProductId"] as! Int)
                        
                    }
                    let names = UserDefaults.standard
                    names.setValue(listOfproductName, forKey: "names")
                    let id = UserDefaults.standard
                    id.setValue(listOfproductId, forKey: "id")
                  }
                }
                
            case 401:
                Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                loginScreen = true
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
    func passDeviceToken()
    {
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token")
            {
                if let deviceToken = UserDefaults.standard.string(forKey: "tokenForFirebase"){
                    let tokenForFCM = "DeviceType=\(1)&DeviceId=\(deviceToken)"
                    let deviceTokenResponse = Api().postApiResponse(token as NSString, url: addDevice as NSString, post: tokenForFCM as NSString, method: "POST")
                    print(deviceTokenResponse)
                    print("devicetoken")
                }
            }
            else{
                print()
                print("token not generated")
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         self.view.makeToastActivity(.center)
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [],
                       animations: {
                        cell!.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                        
            },
                       completion: { finished in
                        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseInOut,
                                       animations: {
                                        cell!.transform = CGAffineTransform(scaleX: 1, y: 1)
                            },
                                       completion: nil
                        )
                        
            }
        )
       
        let selectedItem = (indexPath as NSIndexPath).item
        id = categoryIds[selectedItem]
        name = categoryNames[selectedItem]
        
        performSegue(withIdentifier: "NavigateToDetail", sender: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.hideToastActivity()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "NavigateToDetail"
        {
            let productDetail = segue.destination as! Productdetail
            productDetail.id = id
            productDetail.selectedCategory = name
            
        }
        
    }
    
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
       return categoryNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: Categorycustomcell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Categorycustomcell
        cell.categoryName.text = categoryNames[(indexPath as NSIndexPath).row]
        if categoryImage.count  > (indexPath as NSIndexPath).row{
            print(categoryImage.count)
                         let imageUrl = self.categoryImage[(indexPath as NSIndexPath).row]
        let url = URL(string:"\(imagePath)\(imageUrl)")
        let data = try? Data(contentsOf: url!)
        if data != nil {
            cell.categoryImage.image = UIImage(data:data!)
            cell.categoryImage.contentMode = .scaleAspectFill
            
         }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
         collectionView.backgroundColor = UIColor.white
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        var cellSize:CGFloat = 2.4
        var cellheight:CGFloat = 140.0
        if screenSize.height == 480.0{
        cellSize = 2.7
        cellheight = 140.0
        }
        else if screenSize.height == 736.0{
            cellSize = 2.5
            cellheight = 190.0
        }
        else{
            cellSize = 2.7
            cellheight = 190.0
            
        }
        let cellSquareSize: CGFloat = screenWidth / cellSize
        return CGSize(width: cellSquareSize, height: cellheight);
    }
   
    @IBAction func unwindToCategory(segue: UIStoryboardSegue) {
        self.tabBarController?.selectedIndex = 1
    }
    @IBAction func searchProduct(_ sender: AnyObject) {
        self.view.makeToastActivity(.center)
        let searchScreen : Searchproduct = mainStoryboard.instantiateViewController(withIdentifier: "searchProduct") as! Searchproduct
        self.present(searchScreen, animated: true, completion: nil)
    }

}
