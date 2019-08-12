//
//  Orderhistory.swift
//  FlagOn
//
//  Created by SSDB on 7/28/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

import UIKit

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    
    switch (lhs, rhs) {
    case let (l?, r?):
        
        return l < r
    case (nil, _?):
        return true
    default:
        return false
        
    }
}
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    
    switch (lhs, rhs) {
    case let (l?, r?):
        
        return l > r
    default:
        return rhs < lhs
        
    }
}
class Orderhistory: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    var customDateView:UIView!
    var filterTableView: UITableView!
    @IBOutlet weak var orderHistoryLabel: UILabel!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var startDate:String!
    var endDate:String!
    var toggleState = 1
    var orderList = [Orders]()
    var filterData:[String] = ["Today","This month","Past 6 month","Custom"]
    var startTextField : UITextField!
    var endTextField: UITextField!
    var okButton : UIButton!
    var cancelButton : UIButton!
    var datePicker: UIDatePicker = UIDatePicker()
    var selectedField = ""
    var rowNumber:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        customDateView=UIView(frame: CGRect(x: screenSize.width*0.098, y: screenSize.height*0.23, width: screenSize.width*0.8, height: 160))
        customDateView.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 255.0/255.0, alpha: 1)
        self.view.addSubview(customDateView)
        
        customDateView.layer.shadowColor = UIColor.black.cgColor
        customDateView.layer.shadowOpacity = 0.50
        customDateView.layer.shadowOffset = CGSize.zero
        customDateView.layer.shadowRadius = 1
        
        startTextField = UITextField(frame: CGRect(x: screenSize.width*0.13, y: 20, width: screenSize.width*0.56, height: 30.0))
        endTextField = UITextField(frame: CGRect(x: screenSize.width*0.13, y: 63, width: screenSize.width*0.56, height: 30.0))
        
        okButton = UIButton(frame: CGRect(x:screenSize.width*0.22, y: 115, width: 70.00, height: 33.00))
        cancelButton = UIButton(frame: CGRect(x:screenSize.width*0.41, y: 115, width: 70.00, height: 33.00))
        textFieldStyle([startTextField,endTextField])
        startTextField.placeholder = " Start date"
        endTextField.placeholder = " End date"
        okButton.setImage(UIImage(named: "check-mark"), for: UIControl.State.normal)
        cancelButton.setImage(UIImage(named: "delete-cross"), for: UIControl.State.normal)
        
        okButton.addTarget(self, action:#selector(Orderhistory.okButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(Orderhistory.cancelButtonTapped), for: .touchUpInside)
        
        customDateView.addSubview(okButton)
        customDateView.addSubview(cancelButton)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        filterTableView = UITableView(frame: CGRect(x: screenSize.width*0.71, y: 83, width: 108, height: 100))
        filterTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Filtercell")
        filterTableView.dataSource = self
        filterTableView.delegate = self
        self.view.addSubview(filterTableView)
       
        
        self.customDateView.alpha = 0
        createDatePicker()
        tableView.tableFooterView = UIView()
        filterTableView.isHidden = true
        filterTableView.rowHeight = 25
        
    }
    
    func createDatePicker()
    {
        let inputView = UIView(frame: CGRect(x: 0,y: 0, width: self.view.frame.width, height: 200))
        let size = Commonhelper().countScreenSize()
        var xAxisPosition = CGFloat(0)
        if size.width == 320.0{
            xAxisPosition = CGFloat(0)
            print(xAxisPosition)
        }
        else{
            xAxisPosition = CGFloat((size.width-320)/2)
        }
        datePicker = UIDatePicker(frame: CGRect(x: xAxisPosition, y: 40, width: 0, height: 0))
        datePicker.backgroundColor = UIColor.white
        inputView.addSubview(datePicker)
        datePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MMM dd"
        let doneButton = UIButton(frame: CGRect(x: (self.view.frame.size.width/2) - (100/2), y: 0, width: 100, height: 50))
        doneButton.setTitleColor(UIColor.brown, for: UIControl.State())
        doneButton.setTitle("Done", for: UIControl.State())
        inputView.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(Orderhistory.donePressed(_:)), for: .touchUpInside)
        startTextField.inputView = inputView
        endTextField.inputView = inputView
        datePicker.maximumDate = Date()
    }
    
    @objc func okButtonTapped(){
        
        startDate = startTextField.text
        endDate = endTextField.text
        if startDate.length == 0{
            
            Commonhelper().animateAndRequiredWithRed(startTextField,errorMeaage: "Required.")
        }
        else if endDate.length == 0
        {
            Commonhelper().animateAndRequiredWithRed(endTextField,errorMeaage: "Required.")
        }
        else{
            //datePicker.maximumDate = Date()
            getOrderByDate(String(startDate),EndDate: String(endDate))
            customDateView.alpha = 0
            datePicker.isHidden = true
        }
    }
    
    @objc func cancelButtonTapped(){
        
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseIn, animations: {
            self.customDateView.alpha = 0
            
        }) { _ in
            
            self.datePicker.isHidden = true
            self.startTextField.resignFirstResponder()
            self.endTextField.resignFirstResponder()
            //self.customDateView.removeFromSuperview()
        }
        
    }
    
    @objc func donePressed(_ sender: UIBarButtonItem) {
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM/dd/yyyy"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        if selectedField == "startTextField"{
            startTextField.text = selectedDate
            startTextField.textAlignment = .center
            datePicker.isHidden = true
            startTextField.resignFirstResponder()
        }
        if selectedField == "endTextField"{
            endTextField.text = selectedDate
            datePicker.isHidden = true
            endTextField.resignFirstResponder()
        }
    }
    
    func textFieldStyle(_ textFields: [UITextField])
    {
        for textField in textFields{
            textField.textAlignment = .center
            textField.textColor = UIColor.red
            textField.font = UIFont.boldSystemFont(ofSize: 12)
            textField.layer.cornerRadius = 13.0
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.red.cgColor
            textField.delegate = self
            customDateView.addSubview(textField)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == startTextField{
            selectedField = "startTextField"
            datePicker.isHidden = false
            if !((endTextField.text?.isEmpty)!){
                let splittedDate = endTextField.text?.components(separatedBy: "/")
                let date = (splittedDate?[1])! + " " + (splittedDate?[0])! + " " + (splittedDate?[2])!
                let result = Commonhelper().stringToDate(dateString: date)
                //datePicker.maximumDate = result
            }
            
        }
        
        if textField == endTextField{
            selectedField = "endTextField"
            datePicker.isHidden = false
            if !((startTextField.text?.isEmpty)!){
                let splittedDate = startTextField.text?.components(separatedBy: "/")
                let date = (splittedDate?[1])! + " " + (splittedDate?[0])! + " " + (splittedDate?[2])!
                let result = Commonhelper().stringToDate(dateString: date)
                //datePicker.minimumDate = result
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let url = "Orders/GetAllOrders"
        print("Last\(url)")
        getHistory(url as NSString)
        self.view.hideToastActivity()
        
    }
    
    func getHistory(_ url:NSString)
    {
        
        if Reachability.isConnectedToNetwork() == true {
            
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token"){
                let response = Api().callApi(token as NSString,url: url as String)
                switch response.0{
                case 200:
                    orderList.removeAll()
                    let result:AnyObject = (response.1).value(forKey: "Result")! as AnyObject
                    let allOrders:AnyObject = (result).value(forKey: "OrderList")! as AnyObject
                    
                    if let items = allOrders as? [AnyObject]
                    {
                        for item in items {
                            orderList.append(Orders(dictionary:item as! [String : AnyObject]))
                            print(orderList)
                            self.tableView.reloadData()
                            
                        }
                    }
                    self.view.hideToastActivity()
                case 400:
                    let errors:NSArray = (response.1).value(forKey: "Errors") as! NSArray
                    for error in errors{
                        
                        Commonhelper().showErrorMessage(error as! String)
                    }
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
        else{
            
            Commonhelper().showErrorMessage(internetError)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (tableView == self.tableView) ? orderList.count : filterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = (indexPath as NSIndexPath).row
        if(tableView == self.tableView){
            
            var orders:Orders!
            if orderList.count > 0
                
            {
                orders  = self.orderList[(indexPath as NSIndexPath).row]
                
            }
            
            let cell: Orderhistorycustomcell = tableView.dequeueReusableCell(withIdentifier: "cell") as! Orderhistorycustomcell
            
            cell.orderId?.text = "Order id :"+" #"+String(orders.orderId)
            let dateSplitted = String(orders.orderDate).trimmingCharacters(in: .whitespaces).components(separatedBy: "T")
            cell.orderDate.text = String(dateSplitted[0])
            cell.amount.text = String(orders.grandTotal)+" M.V.R "
            
            if orders.erpInvoiceID == "" && orders.orderStatus == "Ready for Delivery"{
                cell.status.text = "Confirmed"
                
            }
            else{
                cell.status.text = String(orders.orderStatus)
            }
            
            cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
            UIView.animate(withDuration: 0.3, animations: {
                cell.layer.transform = CATransform3DMakeScale(1.05, 1.05, 1)
                },completion: { finished in
                    UIView.animate(withDuration: 0.1, animations: {
                        cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    })
            })
            cell.textLabel?.backgroundColor = UIColor.red
            return cell
            
        }
            
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Filtercell", for: indexPath as IndexPath)
            cell.textLabel!.text = filterData[row]
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 11)
            cell.textLabel?.textAlignment = .left
            cell.backgroundColor = UIColor.black
            cell.textLabel?.textColor = UIColor.white
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView == self.filterTableView){
            let date = Date()
            let calendar = Calendar.current
            let components = (calendar as NSCalendar).components([.day , .month , .year], from: date)
            let year =  components.year
            let month = components.month
            let day = components.day
            
            var pastMonth:Int=0
            var getMonth: Int {
                let cal = Calendar.autoupdatingCurrent
                return (cal as NSCalendar).component(.month, from: (cal as NSCalendar).date(byAdding: .month, value: -pastMonth, to: Date(), options: [])!)
                
            }
            
            if (indexPath as NSIndexPath).row == 0{
                
                //Api issue not handled for same date
                startDate = String(describing: month!)+"/"+String(describing: day!)+"/"+String(describing: year!)
                endDate   = String(describing: month!)+"/"+String(describing: day!)+"/"+String(describing: year!)
                print(startDate)
                getOrderByDate(startDate!,EndDate: endDate!)
                filterTableView.isHidden = true
                
            }
            
            if (indexPath as NSIndexPath).row == 1{
                
                let format = String(describing: month!)+"/"
                let days = getDaysInMonth(month!, year: year!)
                pastMonth = month!
                startDate = format+String(01)+"/"+String(describing: year!)
                endDate =   format+String(days)+"/"+String(describing: year!)
                getOrderByDate(startDate!,EndDate: endDate!)
                filterTableView.isHidden = true
                
            }
            
            if (indexPath as NSIndexPath).row == 2{
                
                var components = DateComponents()
                components.setValue(-6, for: .month)
                let date: Date = Date()
                let pastDate = Calendar.current.date(byAdding: components, to: date)
                
                let dateString =  String(describing: pastDate!).trimmingCharacters(in: .whitespaces).components(separatedBy: "-")
                let format = String(dateString[1])+"/"
                let day = dateString[2].trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
                startDate = format+String(day[0])+"/"+String(describing: dateString[0])
                
                endDate   = String(describing: month!)+"/"+String(describing: day[0])+"/"+String(describing: year!)
                
                getOrderByDate(startDate!,EndDate: endDate!)
                filterTableView.isHidden = true
                
            }
            
            if (indexPath as NSIndexPath).row == 3{
                
                UIView.animate(withDuration: 0.60, delay: 1, options: .autoreverse, animations: {
                    self.customDateView.alpha = 1
                }) { _ in
                    self.startTextField.text == ""
                    self.endTextField.text == ""
                }
            }
            filterTableView.isHidden = true
        }
        else{
            rowNumber = (indexPath as NSIndexPath).row
            performSegue(withIdentifier: "Orderdetail", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.makeToastActivity(.center)
        orderList.removeAll()
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "Orderdetail"
        {
            let orderDetail = segue.destination as! Orderdetail
            print(orderList)
            let orders  = self.orderList[rowNumber!]
            print(orders.orderId)
            orderDetail.orderDetailID = orders.orderId
            
        }
        
    }
    
    @IBAction func unwindToHistory(segue: UIStoryboardSegue) {
        self.tabBarController?.selectedIndex = 4
    }
    
    @IBAction func sortButtonAction(_ sender: AnyObject) {
        
        if toggleState == 1
        {
            toggleState = 2
            filterTableView.isHidden = false
            
        }
        else{
            
            toggleState = 1
            filterTableView.isHidden = true
        }
        
    }
    
    func getOrderByDate(_ StartDate:String,EndDate:String)
    {
        
        let url = orderHistory+StartDate+"&EndDate="+EndDate+""
        print("Last\(url)")
        getHistory(url as NSString)
        
    }
    
}
