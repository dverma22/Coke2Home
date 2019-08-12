//
//  Setreminder.swift
//  Coke
//
//  Created by SSDB on 8/5/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

import UIKit
import CZPicker
import Foundation
import  UserNotifications
import UserNotificationsUI
import QuartzCore
import MGSwipeTableCell
class Setreminder: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,MGSwipeTableCellDelegate{
    
    
    @IBOutlet weak var frequencyTableView: UITableView!
    @IBOutlet weak var remindertable: UITableView!
    @IBOutlet weak var frequencyButton: UIButton!
    @IBOutlet weak var saveReminderButton: UIButton!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var product: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var CustomDatePicker: UIDatePicker!
    @IBOutlet weak var sun: UILabel!
    @IBOutlet weak var mon: UILabel!
    @IBOutlet weak var tue: UILabel!
    @IBOutlet weak var wed: UILabel!
    @IBOutlet weak var thu: UILabel!
    @IBOutlet weak var fri: UILabel!
    @IBOutlet weak var sat: UILabel!
    @IBOutlet weak var custom: UILabel!
    @IBOutlet weak var specificDate: UILabel!
    var dayLabelArray:[UILabel]!
    var reminderData:[String: AnyObject]!
    var datePicker: UIDatePicker = UIDatePicker()
    var timePicker : UIDatePicker!
    let toolbarforDatePicker: UIToolbar! = UIToolbar()
    
    var weekdays = [String]()
    var days = [String]()
    var selectedProductName: String!
    var products = [String]()
    var productId = [Int]()
    var selectedDays = [String]()
    var Frequency:[String] = ["Specific Date","Custom/Days"]
    var reminderProduct = [Allreminders]()
    var reminderFrequency =  [String]()
    var reminderTime =  [String]()
    var setBool = true
    var daysString = ""
    var selectedProductId = 0
    var toggleState = 1
    var openPicker = ""
    var productID:Int?
    let requestIdentifier = "SampleRequest"
    var localNotificationData:[AnyObject] = []
    var editReminderFlag = false
    var loginScreen = false
    let openingBracks = "{"
    let closingBracks = "}"
    var editCellTag:Int?
    var setFavoriteFromPrductDetail = false
    var index = 0
    var reminderdata =
        [
            "days": "",
            "hour": "",
            "min":""
    ]
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        days = ["Sunday", "Monday","Tuesday", "Wednesday", "Thursday", "Friday","Saturday"]
        self.remindertable.delegate = self
        self.remindertable.dataSource = self
        remindertable.estimatedRowHeight = 100
        remindertable.rowHeight = UITableView.automaticDimension
        frequencyTableView.isHidden = true
        dayLabelArray = [sun,mon,tue,wed,thu,fri,sat]
        cornerRadius(dayLabelArray)
        createPickerView()
        
        let name = UserDefaults.standard
        //issue check if let
        products = (name.object(forKey: "names") as? [String])!
        let id = UserDefaults.standard
        productId = (id.object(forKey: "id") as? [Int])!
        custom.isHidden = true
        //specificDateText.isHidden = true
        specificDate.isHidden = true
        saveReminderButton.addTarget(self, action: #selector(Setreminder.callSavereminder(_:)), for: UIControl.Event.touchUpInside)
        remindertable.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        frequencyTableView.isHidden = true
        clearColor(dayLabelArray)
        if let id = productID{
            index = productID!
            
        }
        
    }
    
    func showAndHideDayLabels(_ dayLabelArray:[UILabel],setBool:Bool){
        
        for labels in dayLabelArray{
            if setBool == true{
                labels.isHidden = true
            }
            else{
                labels.isHidden = false
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchReminder()
        
        if loginScreen == true{
            let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
            self.present(signinScreen, animated: true, completion: nil)
        }
        
        
        if let name = (UserDefaults.standard.value(forKey: "nameSearch")){
            product.text = String(describing: name)
            
        }
        
        if let ID = (UserDefaults.standard.value(forKey: "idSearch")){
            print(ID)
            print("getting id")
            index = ID as! Int
            
            
        }
        clearSearchProductData()
        
    }
    
    func clearSearchProductData(){
        UserDefaults.standard.removeObject(forKey: "idSearch")
        
        UserDefaults.standard.removeObject(forKey: "nameSearch")
    }
    
    func fetchReminder() {
        
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token"){
                
                let response = Api().callApi(token as NSString,url: getAllReminder)
                
                switch response.0{
                case 200:
                    reminderProduct.removeAll()
                    let result:AnyObject = (response.1).value(forKey: "Result")! as! NSDictionary
                    let data = (result).value(forKey: "ReminerProductList")
                    for dict in data as! [NSDictionary]{
                        self.reminderProduct.append(Allreminders(dictionary:dict as! [String : AnyObject]))
                    }
                    self.remindertable.reloadData()
                    self.reminderForCoke()
                    
                    print(reminderProduct)
                case 401:
                    
                    loginScreen = true
                    
                case 500:
                    
                    Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                default:
                    
                    Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                    
                }
                
            }
        }
        else{
            Commonhelper().showErrorMessage(internetError)
        }
    }
    
    func createPickerView(){
        
        let productPicker: UIPickerView
        productPicker = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 100))
        productPicker.backgroundColor = UIColor.white
        productPicker.showsSelectionIndicator = true
        productPicker.delegate = self
        productPicker.dataSource = self
        self.product.delegate = self
        productPicker.tag = 2
        self.time.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.red
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(Setreminder.DonePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        product.inputView = productPicker
        product.inputAccessoryView = toolBar
        toolBar.backgroundColor = UIColor.black
        
        let doneButtonForToolbar = [UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(Setreminder.donemyDatePicker))]
        toolbarforDatePicker.frame = CGRect(x: 0, y: view.frame.height/1.58, width: view.frame.width, height: 70)
        toolbarforDatePicker.sizeToFit()
        toolbarforDatePicker.setItems(doneButtonForToolbar, animated: true)
        toolbarforDatePicker.backgroundColor = UIColor.black
        self.view.addSubview(toolbarforDatePicker)
        datePicker.frame = CGRect(x: 0, y: view.frame.height/1.4, width: view.frame.width, height: 160)
        datePicker.backgroundColor = UIColor.clear
        datePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        self.view.addSubview(datePicker)
        
        datePicker.isHidden = true
        datePicker.minimumDate = Date()
        toolbarforDatePicker.isHidden = true
        Commonhelper().buttonCornerRadius(frequencyButton)
        Commonhelper().buttonCornerRadius(saveReminderButton)
        Commonhelper().buttonCornerRadius(cancel)
        time.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 27, height: 27))
        let image = UIImage(named:"watch.png")
        imageView.image = image
        time.rightView = imageView
        remindertable.allowsSelection = false
        if selectedProductName != nil{
            product.text = selectedProductName
        }
        
    }
    
    @IBAction func resetReminder(_ sender: AnyObject) {
        clearAllReminderFeilds()
        
    }
    
    func clearAllReminderFeilds(){
        clearColor(dayLabelArray)
        selectedDays.removeAll()
        productID = 0
        product.text = ""
        time.text = ""
        editReminderFlag = false
    }
    
    @objc func donemyDatePicker(){
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        print(selectedDate)
        specificDate.text = selectedDate
        toolbarforDatePicker.isHidden = true
        datePicker.isHidden = true
        frequencyTableView.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == time {
            openPicker = "Time"
            self.pickUpDate(self.time)
        }
        else if textField == product{
            openPicker = "Products"
        }
    }
    
    @objc func callSavereminder(_ sender:UIButton!){
        
        
        var url = ""
        if self.editReminderFlag == false{
            url = createReminder
            if self.product.text?.length == 0 || self.time.text?.length == 0 || self.selectedDays.count == 0{
                Commonhelper().showErrorMessage("All fields are required.Product,Day and Time.")
            }
            else{
                newReminder(url: url)
            }
        }
        else{
            url = updateReminder
            
            
            if self.product.text?.length == 0 || self.time.text?.length == 0 || self.selectedDays.count == 0{
                Commonhelper().showErrorMessage("All fields are required.Product,Day and Time.")
            }
            else{
                updateReminderData(url: url)
            }
        }
        
        
        //createAndUpdateReminder()
        
    }
    
    func newReminder(url:String){
        
        
        print(productId)
        print(products)
        print(selectedProductId)
        
        createAndUpdateReminder(url: url)
        
    }
    
    func updateReminderData(url:String){
        
        
        createAndUpdateReminder(url: url)
    }
    
    func createAndUpdateReminder(url:String){
        self.view.makeToastActivity(.center)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            
            print(self.productID)
            
            
            self.daysString = ""
            for data in self.selectedDays{
                self.daysString += "\(data) "
            }
            self.reminderFrequency.removeAll()
            self.reminderFrequency.append(self.daysString+self.time.text!)
            self.reminderData =
                [
                    "ProductId": 0 as AnyObject,
                    "ReminderDays": "" as AnyObject,
                    "ReminderTime":0 as AnyObject,
            ]
            print(self.index)
            let customTime = customTimeFormat(time: self.time.text!)
            self.reminderData.updateValue(self.index as AnyObject, forKey: "ProductId")
            self.reminderData.updateValue(self.daysString as AnyObject, forKey: "ReminderDays")
            self.reminderData.updateValue(customTime as AnyObject, forKey: "ReminderTime")
            
            print(self.reminderData)
            print(self.editReminderFlag)
            if self.editReminderFlag == true{
                self.reminderData["ReminderId"] = 0 as AnyObject?
                print(self.selectedProductId)
                print(self.reminderProduct)
                print(self.index)
                print(self.reminderProduct[self.editCellTag!].reminderId)
                self.reminderData.updateValue(self.reminderProduct[self.editCellTag!].reminderId as AnyObject, forKey: "ReminderId")
            }
            
            
            let jsonData = try! JSONSerialization.data(withJSONObject: self.reminderData, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            var jsonDataInArray = [AnyObject]()
            jsonDataInArray.append(jsonString as AnyObject)
            let post = self.openingBracks+"ReminerProductList:\(jsonDataInArray)\(self.closingBracks)\(self.closingBracks)"
            let defaults = UserDefaults.standard
            
            if let token = defaults.string(forKey: "Token"){
                
                print(post)
                
                let response = Api().callApi(token as NSString,post: post as NSString,url: url as NSString)
                //check other things also add success string in result-Api
                switch response.0{
                case 200:
                    print("Created successfully")
                    self.selectedDays.removeAll()
                    self.fetchReminder()
                    self.remindertable.reloadData()
                    self.reminderForCoke()
                    self.editReminderFlag = false
                    self.clearAllReminderFeilds()
                case 401:
                    
                    let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                    self.present(signinScreen, animated: true, completion: nil)
                    
                case 500:
                    
                    Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                    
                default:
                    print("")
                }
                
            }
            
        }
        self.view.hideToastActivity()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        product.resignFirstResponder()
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return products.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return products[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        product.text = products[row]
        print(row)
        selectedProductId = row
        index = self.productId[row]
        // productID = index
        print(index)
    }
    
    @objc func DonePicker(_ pickerView: UIPickerView) {
        
        if openPicker == "Category"{
            datePicker.isHidden = true
        }
        if openPicker == "Products" {
            datePicker.isHidden = true
            product.resignFirstResponder()
            var selected = self.productId[self.selectedProductId]
            index = selected
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.red
        pickerLabel.text = products[row]
        pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 12)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView == self.remindertable) {
            
            return reminderProduct.count
        }
        else{
            return Frequency.count
        }
    }
    
    @IBAction func unwindFromProductDetail(sender: UIStoryboardSegue) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = (indexPath as NSIndexPath).row
        if(tableView == self.remindertable){
            
            let reuseIdentifier = "programmaticCell"
            var cell = self.remindertable.dequeueReusableCell(withIdentifier: reuseIdentifier) as! MGSwipeTableCell?
            if cell == nil
            {
                cell = MGSwipeTableCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
            }
            
            
            let data = reminderProduct[(indexPath as NSIndexPath).row]
            let convertedTime = convertAMPMHourClock(time: data.reminderTime)
            cell?.textLabel!.text = data.productName
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
            cell?.detailTextLabel!.text = String(data.reminderDays)+String(describing: convertedTime)
            cell?.detailTextLabel?.textColor = UIColor.black
            cell?.textLabel?.textColor = UIColor.red
            cell?.delegate = self
            
            cell?.rightButtons = [MGSwipeButton(title: "", icon: UIImage(named:"garbage (6)_25x25.png"), backgroundColor: UIColor.clear),MGSwipeButton(title: "", icon: UIImage(named:"pencil (3)_25x25.png"), backgroundColor: UIColor.clear)
            ]
            cell?.rightSwipeSettings.transition = MGSwipeTransition.clipCenter
            
            return cell!
        }
        else
        {
            let cell:Frequencycustomcell = tableView.dequeueReusableCell(withIdentifier: "Frequencycell") as! Frequencycustomcell
            cell.Frequencytype?.text = Frequency[row]
            return cell
        }
    }
    
    func deleteReminder(index:Int){
        
        if Reachability.isConnectedToNetwork() == true {
            self.view.makeToastActivity(.center)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                let reminderArray =  self.reminderProduct[index]
                let id = reminderArray.reminderId
                let url = deleteProductReminder+String(id)
                let defaults = UserDefaults.standard
                if let token = defaults.string(forKey: "Token"){
                    let result = Api().deleteById(token as NSString,url: url as NSString,method: "DELETE")
                    
                    switch result.0{
                    case 200:
                        print(result.0)
                        
                        self.reminderProduct.remove(at: (index))
                        self.remindertable.reloadData()
                        // convertTimeTo24Hour(time: "6:30 PM")
                        self.reminderForCoke()
                        self.clearAllReminderFeilds()
                        
                    case 401:
                        
                        let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                        self.present(signinScreen, animated: true, completion: nil)
                        
                    case 500:
                        
                        Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                        
                    default:
                        print("")
                    }
                    
                }
            }
            self.view.hideToastActivity()
        }
        else{
            Commonhelper().showErrorMessage(internetError)
        }
        
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        print("Button \(index) tapped")
        let indexPath = remindertable.indexPath(for: cell)
        
        switch index {
        case 0:
            deleteReminder(index: (indexPath?.row)!)
            print("None")
        case 1:
            editCellTag = indexPath?.row
            print("Selected cell \(indexPath?.row)")
            editReminder(indexpath: (indexPath?.row)!)
        default:
            print("None")
        }
        
        return true
    }
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        TipInCellAnimator.animate(cell: cell)
        // use as? or as! to cast UITableViewCell to your desired type
    }
    func editReminder(indexpath:Int)
    {
        
        print(index)
        let reminder =  reminderProduct[indexpath]
        print(reminder.reminderId)
        print(reminder.productId)
        let splitedDays = reminder.reminderDays.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
        product.text = reminder.productName
        let convertedTime = convertAMPMHourClock(time: reminder.reminderTime)
        time.text = convertedTime
        
        index = reminder.productId
        custom.isHidden = false
        clearColor(dayLabelArray)
        showAndHideDayLabels(dayLabelArray,setBool: false)
        for day in splitedDays{
            if day == "Sun"{
                changeSelectedLabelColor(sun,name: "Sun")
            }
            if day == "Mon"{
                changeSelectedLabelColor(mon,name: "Mon")
            }
            if day == "Tue"{
                changeSelectedLabelColor(tue,name: "Tue")
                
            }
            if day == "Wed"{
                changeSelectedLabelColor(wed,name: "Wed")
                
            }
            if day == "Thu"{
                changeSelectedLabelColor(thu,name: "Thu")
                
            }
            if day == "Fri"{
                changeSelectedLabelColor(fri,name: "Fri")
                
            }
            if day == "Sat"{
                changeSelectedLabelColor(sat,name: "Sat")
                
            }
        }
        editReminderFlag = true
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        editCellTag = (indexPath as NSIndexPath).row
        if tableView == self.frequencyTableView {
            let selected  = tableView.cellForRow(at: indexPath)! as! Frequencycustomcell
            selected.contentView.backgroundColor = UIColor.red
            if (indexPath as NSIndexPath).row == 0
            {
                remindertable.isHidden = true
                self.frequencyTableView.isHidden = true
                specificDate.isHidden = false
                setBool = true
                
                custom.isHidden = true
                showAndHideDayLabels(dayLabelArray,setBool: setBool)
                datePicker.isHidden = false
                toolbarforDatePicker.isHidden = false
            }
            else{
                specificDate.isHidden = true
                custom.isHidden = false
                showCustomDays()
            }
            
        }
        
    }
    
    func showCustomDays(){
        
        let picker = CZPickerView(headerTitle: "Select Days", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        picker?.delegate = self
        picker?.dataSource = self
        picker?.needFooterView = false
        picker?.allowMultipleSelection = true
        picker?.show()
        setBool = false
        showAndHideDayLabels(dayLabelArray,setBool: setBool)
        
    }
    
    @IBAction func showFrequencyTable(_ sender: AnyObject) {
        
        specificDate.isHidden = true
        custom.isHidden = false
        showCustomDays()
        
    }
    
    func pickUpDate(_ textField : UITextField){
        
        self.timePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100))
        self.timePicker.backgroundColor = UIColor.white
        self.timePicker.datePickerMode = UIDatePicker.Mode.time
        //self.timePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        time.inputView = self.timePicker
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.red
        toolBar.sizeToFit()
        let doneButtonForTimePicker = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(Setreminder.doneTimePicker))
        let cancelButtonForTimePicker = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(Setreminder.cancelTimePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButtonForTimePicker,spaceButton, doneButtonForTimePicker], animated: false)
        toolBar.isUserInteractionEnabled = true
        time.inputAccessoryView = toolBar
        toolBar.backgroundColor = UIColor.black
        
    }
    
    @objc func cancelTimePicker(){
        time.resignFirstResponder()
    }
    
    @objc func doneTimePicker() {
        
        let myDateFormatter: DateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "h:mm a"
        myDateFormatter.amSymbol = "AM"
        myDateFormatter.pmSymbol = "PM"
        //print(timePicker.locale)
        reminderTime = [myDateFormatter.string(from: timePicker.date)]
        time.text = myDateFormatter.string(from: timePicker.date)
        time.resignFirstResponder()
    }
    
}

extension Setreminder: CZPickerViewDelegate, CZPickerViewDataSource {
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        
        return days.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        
        return days[row]
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        print(days[row])
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [AnyObject]!) {
        
        clearColor(dayLabelArray)
        if selectedDays.count>0{
            selectedDays.removeAll()
        }
        for row in rows {
            if let row = row as? Int {
                print(days[row])
                if (days[row]) == "Sunday"{
                    changeSelectedLabelColor(sun,name: "Sun")
                }
                if (days[row]) == "Monday"{
                    changeSelectedLabelColor(mon,name: "Mon")
                }
                if (days[row]) == "Tuesday"{
                    changeSelectedLabelColor(tue,name: "Tue")
                }
                if (days[row]) == "Wednesday"{
                    changeSelectedLabelColor(wed,name: "Wed")
                    
                }
                if (days[row]) == "Thursday"{
                    changeSelectedLabelColor(thu,name: "Thu")
                }
                if (days[row]) == "Friday"{
                    changeSelectedLabelColor(fri,name: "Fri")
                }
                if (days[row]) == "Saturday"{
                    changeSelectedLabelColor(sat,name: "Sat")
                }
                
            }
        }
        
    }
    
    func clearColor(_ dayLabelArray:[UILabel]){
        
        for label in dayLabelArray{
            label.textColor = UIColor.black
        }
    }
    
    func changeSelectedLabelColor(_ label:UILabel,name:String){
        
        label.textColor = UIColor.red
        selectedDays.append(name)
    }
    
    @IBAction func ProductDropdownbutton(_ sender: AnyObject) {
        
        if toggleState == 1
        {
            toggleState = 2
            product.becomeFirstResponder()
        }
        else{
            toggleState = 1
            product.resignFirstResponder()
        }
    }
    
    func cornerRadius(_ dayLabelArray:[UILabel]){
        
        for label in dayLabelArray{
            label.layer.cornerRadius = 7
            label.layer.masksToBounds = true
        }
    }
    
    func removeNotification(){
        
        if #available(iOS 10.0, *) {
            var initvalue = 0
            for anItem in localNotificationData as! [Dictionary<String, AnyObject>] {
                let center = UNUserNotificationCenter.current()
                center.removePendingNotificationRequests(withIdentifiers: [requestIdentifier+String(initvalue)])
                initvalue = initvalue+1
            }
            //notify()
        } else {
            //TO DO : Top Priority
            // Fallback on earlier versions
        }
        
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func reminderForCoke()
    {
        
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.title = "Its time to order !"
            
            content.body = "Reminder for Coke"
            content.sound = UNNotificationSound.default
            //change image
            if let path = Bundle.main.path(forResource: "cokeProductReminder_83x83", ofType: "png") {
                let url = URL(fileURLWithPath: path)
                
                do {
                    let attachment = try UNNotificationAttachment(identifier: "sampleImage", url: url, options: nil)
                    content.attachments = [attachment]
                } catch {
                    print("attachment not found.")
                }
            }
            localNotificationData.removeAll()
            for reminder in reminderProduct{
                
                let splitedDays = reminder.reminderDays.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
                
                let timeSplitedSpace =  reminder.reminderTime.trimmingCharacters(in: .whitespaces).components(separatedBy: ":")
                
                for days in splitedDays{
                    let day = getweekday(day: days)
                    reminderdata.updateValue(String(day), forKey: "days")
                    reminderdata.updateValue(timeSplitedSpace[0], forKey: "hour")
                    reminderdata.updateValue(timeSplitedSpace[1], forKey: "min")
                    let jsonReminderData = try! JSONSerialization.data(withJSONObject: reminderdata, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonReminderString = NSString(data: jsonReminderData, encoding: String.Encoding.utf8.rawValue)! as String?
                    
                    let dict = convertToDictionary(text: jsonReminderString!)
                    print(dict)
                    localNotificationData.append(dict as AnyObject)
                }
                
                print(reminderdata)
                print(localNotificationData)
            }
            
            removeNotification()
            
            var initvalue = 0
            let dateComponents = NSDateComponents()
            
            for anItem in localNotificationData as! [Dictionary<String, AnyObject>] {
                let day = anItem["days"] as! String
                let hour = anItem["hour"] as! String
                let min = anItem["min"] as! String
                
                
                dateComponents.hour = Int(hour)!
                dateComponents.minute = Int(min)!
                dateComponents.weekday = Int(day)!
                
                
                print(hour)
                print(day)
                print(initvalue)
                let request = UNNotificationRequest(identifier:requestIdentifier+String(initvalue), content: content, trigger: UNCalendarNotificationTrigger(dateMatching: dateComponents as DateComponents, repeats: true))
                
                UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().add(request){(error) in
                    print(request)
                    if (error != nil){
                        
                        print(error?.localizedDescription)
                    }
                }
                
                initvalue = initvalue+1
                print(initvalue)
            }
        } else {
            // To Do: Top priority
            // Fallback on earlier versions
        }
        
        
    }
    
    
}
//@available(iOS 10.0, *)
extension Setreminder:UNUserNotificationCenterDelegate{
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler( [.alert,.sound,.badge])
        
    }
}

class TipInCellAnimator {
    class func animate(cell:UITableViewCell) {
        let view = cell.contentView
        let rotationDegrees: CGFloat = -15.0
        let rotationRadians: CGFloat = rotationDegrees * (CGFloat(M_PI)/180.0)
        
        let offset = CGPoint(x: -20, y:-20)
        var startTransform = CATransform3DIdentity // 2
        startTransform = CATransform3DRotate(CATransform3DIdentity,
                                             rotationRadians, 0.0, 0.0, 1.0) // 3
        startTransform = CATransform3DTranslate(startTransform, offset.x, offset.y, 0.0) // 4
        
        // 5
        view.layer.transform = startTransform
        view.layer.opacity = 0.8
        
        // 6
        UIView.animate(withDuration: 0.4) {
            view.layer.transform = CATransform3DIdentity
            view.layer.opacity = 1
        }
    }
}
