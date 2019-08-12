//
//  Cancelorder.swift
//  Coke India
//
//  Created by IOS Development on 9/17/18.
//  Copyright © 2018 SSDB Tech Pvt Ltd. All rights reserved.
//

import UIKit

class Cancelorder: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    //Mark: Properties
    @IBOutlet weak var reasonLabel: UITextField!
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var selectFieldView: UIView!
    @IBOutlet weak var pickReasons: UIPickerView!
    @IBOutlet weak var commentRequired: UILabel!
    @IBOutlet weak var reasonIsRequired: UILabel!
    
    var cancelOrderDict = [String: AnyObject]()
    var orderDatailId: Int?
    
    private let reasons:[String] = ["Wrong Order Placed","Wrong Order Received","Incorrect Amount Payable","Insufficient empties","Insufficient funds","Not available during delivery","Leakage/Damage Received"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        selectFieldView.isHidden = true
        pickReasons.dataSource = self
        pickReasons.delegate = self
        commentText.layer.borderWidth = 1
        commentText.layer.borderColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1).cgColor
        commentText.layer.cornerRadius = 8
        Commonhelper().createPrefixLabel(textField: reasonLabel)
    }
    
    //Mark: Action
    @IBAction func notCancelOrderTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "placeOrderDetails", sender: nil)
    }
    
    @IBAction func cancelOrderTapped(_ sender: UIButton) {
        let reason = reasonLabel.text!
        let comment = commentText.text!
        if reason == "" {
            reasonIsRequired.isHidden = false
        } else if comment == "" {
            commentRequired.isHidden = false
        }else{
            reasonIsRequired.isHidden = true
            commentRequired.isHidden = true
            let post:NSString = "Reason=\(reason)&comment=\(comment)&orderId=\(self.orderDatailId!)" as NSString
            
            let jsonCancelData = try! JSONSerialization.data(withJSONObject: self.cancelOrderDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonCancelString = NSString(data: jsonCancelData, encoding: String.Encoding.utf8.rawValue)! as String
            print(jsonCancelString)
            if Reachability.isConnectedToNetwork() == true {
                let defaults = UserDefaults.standard
                if let token = defaults.string(forKey: "Token"){
                    let response = Api().postApiResponse(token as NSString, url: cancelOrderAPI as NSString, post: post, method: "POST")
                    print(response.0)
                    if let errors:NSArray = response.1.value(forKey: "Errors") as! NSArray?{
                        if response.0 == 200 && errors.count == 0{
                            print(comment)
                            performSegue(withIdentifier: "placeOrderDetails", sender: nil)
                        }
                        else{
                            for error in errors{
                                Commonhelper().showErrorMessage(error as! String)
                            }
                        }
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
    
    @IBAction func selectReasonTapped(_ sender: UIButton) {
        selectFieldView.isHidden = true
        reasonLabel.endEditing(true)
    }
    
    @IBAction func reasonTapped(_ sender: UITextField) {
        selectFieldView.isHidden = false
        reasonLabel.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reasons.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        reasonLabel.text = reasons[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reasons[row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "placeOrderDetails"
        {
            let placeOrder = segue.destination as! Placedorder
            placeOrder.orderID = orderDatailId
            
        }
       
    }

}
