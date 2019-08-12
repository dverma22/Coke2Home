//
//  Searchproduct.swift
//  Coke
//
//  Created by Deepak on 01/07/17.
//  Copyright © 2017 IOS Development. All rights reserved.
//

import UIKit

class Searchproduct: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var productGallery: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var search: UITextField!
     var autocompleteSearch = [String]()
    @IBOutlet weak var searchTable: UITableView!
    var listOfproductName = [String]()
    var listOfCategoryId = [Int]()
    var listOfproductId = [Int]()
    var listOfCategoryNames = [String]()
    var selectedIndex:Int?
    var productId:Int?
    var category:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let id = defaults.string(forKey: "ProductIdFromSearch")
        {
            print("got id")
            print(id)
            
        }
        if let name = defaults.string(forKey: "CategoryNameFromSearch")
        {
            print("got name")
            print(name)
        }
        
        searchTable.delegate = self
        searchTable.dataSource = self
        search.delegate = self
        Commonhelper().removeAutoSuggestion([search])
        search.textAlignment = .center
        search.textColor = UIColor.red
        search.font = UIFont.boldSystemFont(ofSize: 12)
        search.layer.cornerRadius = 13.0
        search.layer.borderWidth = 1.0
        search.layer.borderColor = UIColor.red.cgColor
        doneButton.layer.cornerRadius = 13
        doneButton.layer.borderWidth = 1.0
        doneButton.layer.borderColor = UIColor.red.cgColor
        productGallery.layer.cornerRadius = 13
        productGallery.layer.borderWidth = 1.0
        productGallery.layer.borderColor = UIColor.red.cgColor
        searchTable.tableFooterView = UIView()
        
        searchTable.layer.shadowColor = UIColor.black.cgColor
        searchTable.layer.shadowOpacity = 1
        searchTable.layer.shadowOffset = CGSize.zero
        searchTable.layer.shadowRadius = 2
        //self.searchTable.separatorStyle = .none
        searchTable.isHidden = true
        
        
        
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        searchTable.isHidden = false
       let substring = (self.search.text! as NSString).replacingCharacters(in: range, with: string)
            searchAutocompleteEntriesWithSubstring(substring)
        
        return true
    }
    
    func searchAutocompleteEntriesWithSubstring(_ substring: String)
    {
        autocompleteSearch.removeAll(keepingCapacity: false)
        
        for curString in listOfproductName
        {
            let myString:NSString! = curString as NSString
            
            let range = (myString as NSString).range(of: substring, options:[.caseInsensitive])
            if range.location == 0 {
                autocompleteSearch.append(curString)
            }
        }
        
        searchTable.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.makeToastActivity(.center)
        fetchProducts()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
//        
//        let view = UIView()
//        view.backgroundColor = UIColor(red:244/255,green:0/255,blue:0/255 ,alpha:0.80)
//        cell.selectedBackgroundView = view
//        
//        cell.contentView.backgroundColor =  UIColor.clear
//        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 5, y: 8, width: self.view.frame.size.width-5, height: 44))
//        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.8])
//        whiteRoundedView.layer.masksToBounds = false
//        whiteRoundedView.layer.cornerRadius = 1.0
//        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
//        whiteRoundedView.layer.shadowOpacity = 0.1
//        cell.contentView.addSubview(whiteRoundedView)
//        cell.contentView.sendSubview(toBack: whiteRoundedView)
//        
//         cell.contentView.backgroundColor =  UIColor.clear
        let row = (indexPath as NSIndexPath).row
       
        
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let index = (indexPath as NSIndexPath).row as Int
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 11.0)
        //cell.textLabel!.font = UIFont.systemFont(ofSize: 11.0)
        cell.textLabel!.textColor = UIColor.black
        cell.textLabel!.text =  " "+autocompleteSearch[index]
        
       return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        search.text = autocompleteSearch[selectedIndex!]
        
        
        let autosearchIndex = self.autocompleteSearch[selectedIndex!]
        let selectedProductIndex = listOfproductName.index(of: autosearchIndex)
        let productID = String(listOfproductId[selectedProductIndex!])
        let categoryID = String(listOfCategoryId[selectedProductIndex!])
        //let categoryName = String(listOfCategoryNames[selectedProductIndex!])
        //let favoriteList = self.favoriteList[selectedIndex]
       
        productId = Int(productID)!
        //category = Int(categoryID)!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.hideToastActivity()
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "searchProductsSegue"
        {
            let autosearchIndex = self.autocompleteSearch[selectedIndex!]
            let selectedProductIndex = listOfproductName.index(of: autosearchIndex)
            let productID = String(listOfproductId[selectedProductIndex!])
            let categoryID = String(listOfCategoryId[selectedProductIndex!])
            let categoryName = String(listOfCategoryNames[selectedProductIndex!])
            //let favoriteList = self.favoriteList[selectedIndex]
            let productDetail = segue.destination as! Productdetail
            productDetail.defaultIndex = Int(productID)!
            productId = Int(productID)!
            category = Int(categoryID)!
            print(productID)
            print(categoryID)
            productDetail.id = Int(categoryID)
            productDetail.selectedProductName = search.text!
            productDetail.selectedCategory = categoryName
        }
       self.view.hideToastActivity()
        
    }
    
    @IBAction func navigateToProductGallery(_ sender: AnyObject) {
        self.view.makeToastActivity(.center)
        //UserDefaults.standard.removeObject(forKey: "idSearch")
        
        //UserDefaults.standard.removeObject(forKey: "nameSearch")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
                let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = viewController
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func doneSearch(_ sender: AnyObject) {
        
        if selectedIndex != nil{
        self.view.makeToastActivity(.center)
            
                    UserDefaults.standard.removeObject(forKey: "idSearch")
            
                    UserDefaults.standard.removeObject(forKey: "nameSearch")
            
            
            
            UserDefaults.standard.set(productId!, forKey: "idSearch")
            print(String(describing: productId!))
            print(search.text!)
            UserDefaults.standard.setValue(String(describing: search.text!), forKey: "nameSearch")
            print("\(UserDefaults.standard.value(forKey: "idSearch")!)")
            print("\(UserDefaults.standard.value(forKey: "nameSearch")!)")
//            let defaultID = UserDefaults.standard
//            defaultID.set(String(describing: productId), forKey: "ProductIdFromSearch")
//            let defaultCategoryName = UserDefaults.standard
//            defaultCategoryName.set(search.text, forKey: "CategoryNameFromSearch")
//            //defaultCategoryName.synchronize()
//            if let id = defaults.string(forKey: "ProductIdFromSearch")
//            {
//                print("got id")
//                print(id)
//                
//            }
//            if let name = defaults.string(forKey: "CategoryNameFromSearch")
//            {
//                print("got name")
//                print(name)
//            }
            
            
        performSegue(withIdentifier: "searchProductsSegue", sender: nil)
        }
        else{
            self.view.makeToast("Please select product.")
        }
    }
    func fetchProducts(){
        
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
                                listOfCategoryId.append(dict["CategoryId"] as! Int)
                                listOfCategoryNames.append(dict["CategoryName"] as! String)
                            }
//
                        }
                    }
                    
                case 401:
                    Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                   // loginScreen = true
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


