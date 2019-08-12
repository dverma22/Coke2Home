//
//  Depositbar.swift
//  FlagOn
//
//  Created by SSDB on 8/4/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

import UIKit

class Depositbar: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var dueDate: UILabel!
    @IBOutlet weak var dueAmount: UILabel!
    @IBOutlet weak var bottleReturnTable: UITableView!
    @IBOutlet weak var depositTableView: UITableView!
    var loginScreen = false
    var depositData = [Deposit]()
    var bottleReturnData = [Emptybottles]()
    @IBOutlet weak var depositView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        depositView?.layer.cornerRadius = 10
        depositView?.layer.masksToBounds = true
        depositView?.layer.borderColor = UIColor.red.cgColor
        self.depositTableView.dataSource = self
        self.depositTableView.delegate = self
        depositTableView.estimatedRowHeight = 88
        depositTableView.rowHeight = UITableView.automaticDimension
        depositTableView.allowsSelection = false
        depositTableView.tableFooterView = UIView()
        bottleReturnTable.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if loginScreen == true{
            let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
            self.present(signinScreen, animated: true, completion: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Reachability.isConnectedToNetwork() == true {
            getDeposit()
            getBottleReturnCount()
        }
        else
        {
            Commonhelper().showErrorMessage(internetError)
        }
        
    }
    
    func getBottleReturnCount(){
        
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "Token"){
            let bottleReturnResult = Api().callApi(token as NSString,url:emptyBottlesCount)
            switch bottleReturnResult.0  {
            case 200:
                if bottleReturnResult.1.count > 0 {
                    self.bottleReturnData.removeAll()
                    if let items = bottleReturnResult.1["Result"] as? [[String:AnyObject]]
                    {
                        for item in items {
                            self.bottleReturnData.append(Emptybottles(dictionary:item))
                        }
                    }
                    bottleReturnTable.reloadData()
                }
                print(self.depositData)
            case 500:
                Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
            case 401:
                Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                loginScreen = true
            default:
                let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                self.present(signinScreen, animated: true, completion: nil)
            }
        }
    }
    
    func getDeposit(){
        
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "Token"){
            let depositResult = Api().callApi(token as NSString,url:depositSummary)
            
            switch depositResult.0  {
            case 200:
                if depositResult.1.count > 0 {
                    self.depositData.removeAll()
                    
                    let deposit = (depositResult.1).value(forKey: "Result") as! NSDictionary
                    
                    let data = deposit.value(forKey: "depositdetails")
                    for dict in data as! [NSDictionary]{
                        self.depositData.append(Deposit(dictionary:dict as! [String : AnyObject]))
                        
                        
                    }
                }
                 let deposit = (depositResult.1).value(forKey: "Result") as! NSDictionary
                if let due =  deposit["DueAmount"]{
                   
                    dueAmount.text = String(describing: due)
                    let  dueAmt = due as? Double
                    if dueAmt! > 0.0{
                        dueDate.isHidden = true
                    }
                }
                if let dueDateSt =  deposit["DueDate"]{
                    let date =  String(describing: dueDateSt).trimmingCharacters(in: .whitespaces).components(separatedBy: "T")
                    dueDate.text = date[0]
                }
                depositTableView.reloadData()
                
                print(self.depositData)
            case 500:
                Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
            case 401:
                Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                loginScreen = true
            case 0:
                Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
            default:
                let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                self.present(signinScreen, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (tableView == self.depositTableView ? depositData.count : bottleReturnData.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = (indexPath as NSIndexPath).row
        if(tableView == self.depositTableView){
            let cell:Securitydepositcustomcell = tableView.dequeueReusableCell(withIdentifier: "Depositcell", for: indexPath) as! Securitydepositcustomcell
            let deposit = depositData[row]
            cell.productName?.text = deposit.productName
            
            cell.qty?.text = "Qty: " + String(deposit.productQty)
            cell.amount?.text = String(deposit.depositAmount) + " M.V.R"
            return cell
        }
        else
        {
            let cell:Bottlereturncustomcell = tableView.dequeueReusableCell(withIdentifier: "cell") as! Bottlereturncustomcell
            let returnBottles = bottleReturnData[row]
            cell.productName?.text = returnBottles.productName
            cell.qty?.text = "Qty: " + String(returnBottles.bottleCount)
            return cell
        }
    }
    
}







