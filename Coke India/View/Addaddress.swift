//
//  Addaddress.swift
//  FlagOn
//
//  Created by SSDB on 8/4/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

import UIKit

class Addaddress: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var addAddressTableView: UITableView!
    var addressList = [Addresses]()
    var selectedAddress = 0
    var editPressed:Bool!
    var buttonName:String!
    var billingEdit:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addAddressTableView.delegate = self
        self.addAddressTableView.dataSource = self
        addAddressTableView.estimatedRowHeight = 180
        addAddressTableView.rowHeight = UITableView.automaticDimension
        addAddressTableView.allowsSelection = false
        
     }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return addressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:Addresscustomcell = tableView.dequeueReusableCell(withIdentifier: "Addresscell", for: indexPath) as! Addresscustomcell
        cell.deleteAddress.addTarget(self, action: #selector(Addaddress.deleteAddress(_:)), for: UIControl.Event.touchUpInside)
        cell.deleteAddress.tag = (indexPath as NSIndexPath).row
        cell.editAddress.addTarget(self, action: #selector(Addaddress.editAddress(_:)), for: UIControl.Event.touchUpInside)
        cell.editAddress.tag = (indexPath as NSIndexPath).row
        let address = addressList[(indexPath as NSIndexPath).row]
       if address.addressType == "BillingAddress"{
        cell.deleteAddress.isHidden = true
        cell.editAddress.isUserInteractionEnabled = false
        cell.editAddress.isHidden = true
        billingEdit = (indexPath as NSIndexPath).row
        
        }
       else{
        cell.deleteAddress.isHidden = false
        cell.editAddress.isUserInteractionEnabled = true
        cell.editAddress.isHidden = false
        }
        
        let  addTitle = NSMutableAttributedString(
            string: address.addressTitle,
            attributes: [NSAttributedString.Key.font:UIFont(name: "Arial",size: 12.0)!])
        
        let titleHeading = NSMutableAttributedString(
            string: "Addresstitle :" + " ",
            attributes: [NSAttributedString.Key.font:UIFont(
                name: "HelveticaNeue-Bold",
                size: 11.0)!])
        let combination = NSMutableAttributedString()
        combination.append(titleHeading)
        combination.append(addTitle)
        cell.addressTitle?.attributedText = combination
        
        let  add1 = NSMutableAttributedString(
            string: address.address1,
            attributes: [NSAttributedString.Key.font:UIFont(name: "Arial",size: 12.0)!])
        
        let add1Heading = NSMutableAttributedString(
            string: "Full address :" + " ",
            attributes: [NSAttributedString.Key.font:UIFont(
                name: "HelveticaNeue-Bold",
                size: 11.0)!])
        let combinationadd1 = NSMutableAttributedString()
        combinationadd1.append(add1Heading)
        combinationadd1.append(add1)
        
        cell.address1?.attributedText = combinationadd1
        
        let  add2 = NSMutableAttributedString(
            string: address.address2,
            attributes: [NSAttributedString.Key.font:UIFont(name: "Arial",size: 12.0)!])
        
        let add2Heading = NSMutableAttributedString(
            string: "Floor number :" + " ",
            attributes: [NSAttributedString.Key.font:UIFont(
                name: "HelveticaNeue-Bold",
                size: 11.0)!])
        let combinationadd2 = NSMutableAttributedString()
        combinationadd2.append(add2Heading)
        combinationadd2.append(add2)
        
        cell.address2?.attributedText = combinationadd2
        
        let  loc = NSMutableAttributedString(
            string: address.locationText,
            attributes: [NSAttributedString.Key.font:UIFont(name: "Arial",size: 12.0)!])
        
        let locHeading = NSMutableAttributedString(
            string: "Location :" + " ",
            attributes: [NSAttributedString.Key.font:UIFont(
                name: "HelveticaNeue-Bold",
                size: 11.0)!])
        let combinationaloc = NSMutableAttributedString()
        combinationaloc.append(locHeading)
        combinationaloc.append(loc)
        
        
        
        cell.location?.attributedText = combinationaloc
        
        let  num = NSMutableAttributedString(
            string: address.contactNumber,
            attributes: [NSAttributedString.Key.font:UIFont(name: "Arial",size: 12.0)!])
        
        let numHeading = NSMutableAttributedString(
            string: "Mobile :" + " ",
            attributes: [NSAttributedString.Key.font:UIFont(
                name: "HelveticaNeue-Bold",
                size: 11.0)!])
        let combinationanum = NSMutableAttributedString()
        combinationanum.append(numHeading)
        combinationanum.append(num)
        
        cell.mobile?.attributedText = combinationanum
        cell.addressType?.text = address.addressType
        return cell
    
    }
    
    @objc func editAddress(_ sender: UIButton){
        
        let sender: UIButton = sender
        let index : IndexPath = IndexPath(row: sender.tag, section: 0)
        selectedAddress = (index as NSIndexPath).row
        editPressed = true
        buttonName = "Update Address"
        performSegue(withIdentifier: "UpdateAddress", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "UpdateAddress"
        {
            
            let addressViewController = segue.destination as! Addressbar
            if Reachability.isConnectedToNetwork() == true {
                if addressList.count > 0 {
                    //sometimes issue adding address control comes here
                let address = addressList[selectedAddress]
                  addressViewController.addressTitleEdit  = address.addressTitle
                    
                    if billingEdit == selectedAddress{
                    addressViewController.type = address.addressType
                    }
                   addressViewController.addressIdEdit  = address.addressId
                addressViewController.updateAddress1  = address.address1
                addressViewController.updateAddress2  = address.address2
                addressViewController.updateLocation  = String(address.locationId)
                 addressViewController.updateLocationText  = String(address.locationText)
                    addressViewController.updateMobile  = String(address.contactNumber)
                addressViewController.editTag = editPressed
                addressViewController.buttonText = buttonName
                    print(address.addressType)
                    
                    
                }
            }
            else {
                Commonhelper().showErrorMessage(internetError)
            }
        }
        
    }
    
    @objc func deleteAddress(_ sender: UIButton){
        
        self.view.makeToastActivity(.center)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
        let sender: UIButton = sender
        let index : IndexPath = IndexPath(row: sender.tag, section: 0)
        print((index as NSIndexPath).row)
        let address = self.addressList[(index as NSIndexPath).row]
        let addressId =  String(address.addressId)
        let post = deleteAddressById+addressId+""
        print(post)
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token"){
                if address.addressType == "ShippingAddress"
                {
            let result = Api().deleteById(token as NSString, url: post as NSString,method: "DELETE")
                    switch result.0{
                    case 200:
                        self.addressList.remove(at: (index as NSIndexPath).row)
                        self.addAddressTableView.reloadData()
                    case 400:
                            let errors:NSArray = result.1.value(forKey: "Errors") as! NSArray
                            for error in errors{
                                Commonhelper().showErrorMessage(error as! String)
                        }
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
                else{
                    //discuss to ms
                     Commonhelper().showErrorMessage("Billing address can not be deleted." as String)
                }
            }
        }
    
    }
      self.view.hideToastActivity()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaults.standard.set(nil, forKey: "selectedAdd")
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token"){
            let response = Api().callApi(token as NSString,url: getAllAddress)
            appendAddresses(response)
            }
        } else {
            Commonhelper().showErrorMessage(internetError)
        }
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        textField.resignFirstResponder()
        return true
    }
    
    func appendAddresses(_ response:(Int,NSDictionary)){
        
        if response.0 == 200 && response.1.count > 0
        {
            addressList.removeAll()
            if let items = response.1["Result"] as? [[String:AnyObject]]
            {
                for item in items {
                    self.addressList.append(Addresses(dictionary:item))
                }
            }
        }
        addAddressTableView.reloadData()
    }
    
    @IBAction func addNewAddress(_ sender: AnyObject) {
        
        editPressed = false
        buttonName = "Add New Address"
    }

}

