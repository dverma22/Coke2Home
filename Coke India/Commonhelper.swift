//
//  Commonhelper.swift
//  Coke
//
//  Created by IOS Development on 8/14/16.
//  Copyright © 2016 IOS Development. All rights reserved.
//

import UIKit

class Commonhelper: UIViewController {
    
    func buttonCornerRadius(_ button: UIButton){
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
    }
 
    func addBorderToTextField(_ fields : [UITextField],color:String) {
        for textField in fields {
            let border = CALayer()
            let borderBottomWidth = CGFloat(30.0)
            
            border.frame = CGRect(x: CGFloat(0.0),y: textField.frame.size.height - 1, width: textField.frame.size.width, height: CGFloat(1.0));
            border.borderWidth = borderBottomWidth
            textField.layer.addSublayer(border)
            textField.layer.masksToBounds = true
            let borderLeft = CALayer()
            let borderLeftWidth = CGFloat(20.0)
            
            borderLeft.frame = CGRect(x: CGFloat(0.0), y: CGFloat(30.0), width: CGFloat(1.0),
                                      height: textField.frame.size.height-20);
            borderLeft.borderWidth = borderLeftWidth
            textField.layer.addSublayer(borderLeft)
            textField.layer.masksToBounds = true
            let borderRight = CALayer()
            let borderRightWidth = CGFloat(20.0)
            
            borderRight.frame = CGRect(x: textField.frame.size.width-1, y: CGFloat(30.0), width: CGFloat(1.0),height: textField.frame.size.height-20);
            borderRight.borderWidth = borderRightWidth
            textField.layer.addSublayer(borderRight)
            textField.layer.masksToBounds = true
            switch color {
            case "white":
                borderLeft.borderColor = UIColor.white.cgColor
                border.borderColor = UIColor.white.cgColor
                borderRight.borderColor = UIColor.white.cgColor
             case "red":
                borderLeft.borderColor = UIColor.red.cgColor
                border.borderColor = UIColor.red.cgColor
                borderRight.borderColor = UIColor.red.cgColor
            default:
                borderLeft.borderColor = UIColor.black.cgColor
                border.borderColor = UIColor.black.cgColor
                borderRight.borderColor = UIColor.black.cgColor
            }
            
        }
    }
    
    func stringToDate(dateString:String) -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: dateString)
        return (date!)
    }
    
    func paddingView(_ textFields:[UITextField]){
        for textField in textFields{
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
            textField.leftView = paddingView
            textField.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    func removeAutoSuggestion(_ textFields:[UITextField]){
        for textField in textFields{
            textField.autocorrectionType = .no
        }
    }
    
    func getDate() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: date)
        let year = components.year
        let month = components.month
        let day = components.day
        let formatter = "-"
        let todayDate = String(describing: year)+formatter+String(describing: month)+formatter+String(describing: day)
        return todayDate
    }
    
    func textFieldPlaceholder(_ signupFields : [UITextField],placeholdersText:[String]) {
        for (index,textField) in signupFields.enumerated(){
            let font = UIFont(name: "Gill Sans", size: 17)!
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font : font]
            textField.attributedPlaceholder = NSAttributedString(string: " "+placeholdersText[index]+"",attributes:attributes)
        }
    }
    
    func textFieldPlaceholderProfile(_ fields : [UITextField],placeholdersText:[String]) {
        for (index,textField) in fields.enumerated(){
            let font = UIFont(name: "Gill Sans", size: 13)!
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.red,
                NSAttributedString.Key.font : font]
            textField.attributedPlaceholder = NSAttributedString(string: " "+placeholdersText[index]+"",attributes:attributes)
        }
    }
    //can be removed same type two methods
    func animateAndRequired(_ textField:UITextField,errorMeaage:String){
        textField.attributedPlaceholder = NSAttributedString(string:errorMeaage,attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        Commonhelper().animateObject(textField)
    }
    
    func animateAndRequiredWithRed(_ textField:UITextField,errorMeaage:String){
        
        textField.attributedPlaceholder = NSAttributedString(string:errorMeaage,attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        textField.font = UIFont.systemFont(ofSize: 12)
          Commonhelper().animateObject(textField)
    }
    
    func showErrorMessage(_ error:String)  {
        let alertView:UIAlertView = UIAlertView()
        alertView.title = "Alert !"
        alertView.message = error
        alertView.delegate = self
        alertView.addButton(withTitle: "OK")
        alertView.show()
    }
    
    func showErrorMessage(_ error:String,title:String)  {
        let alertView:UIAlertView = UIAlertView()
        alertView.title = title
        alertView.message = error
        alertView.delegate = self
        alertView.addButton(withTitle: "OK")
        alertView.show()
    }
    
    func labelCornerRadius(_ labels: [UILabel]){
        for label in labels{
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 8
        }
    }
    
    func hideLabels(_ labels: [UILabel]){
        for label in labels{
            label.isHidden = true
        }
    }
    
    func countScreenSize() -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        return CGSize(width: screenSize.width, height: screenSize.height)
    }
    
    func appendLocationsInDictionary(_ jsontokenData: NSDictionary)
    {
        locationTextArray.removeAll(keepingCapacity: false)
        if let predictions = jsontokenData["Result"] as? NSArray{
            for dict in predictions as! [NSDictionary]{
                //dict["Description"] as! String
                locationIdArray.append(dict["LocationId"] as! Int)
                locationTextArray.append(dict["Description"] as! String)
            }
        }
    }
    
    func createPrefixLabel( textField:UITextField){
        
        //let textField = textField
        let countryCode = UILabel()
        countryCode.text = "+960 - "
        countryCode.textColor = UIColor.white
        countryCode.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(15))
        countryCode.sizeToFit()
        textField.leftView = countryCode
        textField.leftViewMode = UITextField.ViewMode.always
    }
    
    func createPrefixCountryCode( textField:UITextField){
        
        //let textField = textField
        let countryCode = UILabel()
        countryCode.text = "+960 - "
        countryCode.textColor = UIColor.black
        countryCode.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(13))
        countryCode.sizeToFit()
        textField.leftView = countryCode
        textField.leftViewMode = UITextField.ViewMode.always
    }
    
    func animateObject(_ textField : UITextField) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 10, y: textField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 10, y: textField.center.y))
        textField.layer.add(animation, forKey: "position")
        
    }
    
}

func getweekday(day:String) ->Int
{
    switch day {
    case "Sun":
        return 1
    case "Mon":
        return 2
    case "Tue":
        return 3
    case "Wed":
        return 4
    case "Thu":
        return 5
    case "Fri":
        return 6
    case "Sat":
        return 7
    default:
        return 0
        
    }
}

func convertAMPMHourClock(time:String)->String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "H:mm:ss"
    let date = dateFormatter.date(from: time)!
    
    dateFormatter.dateFormat = "h:mm a"
    let timeWtithAMPM = dateFormatter.string(from: date)
    return timeWtithAMPM
}

func customTimeFormat(time:String) ->String{
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a"
    
    let date = dateFormatter.date(from: time)
    dateFormatter.dateFormat = "HH:mm"
    let time24HourFormat = dateFormatter.string(from: date!)
    return time24HourFormat
}
  func validateEmail(_ email: String) -> Bool {
    let emailRegex = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"
        + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
}
func validateName(_ name: String) -> Bool {
    let nameRegex = "^[A-Za-z\\s]{6,200}+$"
    return NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: name)
}


func getDaysInMonth(_ month: Int, year: Int) -> Int
    
{
    let calendar = Calendar.current
    var startComps = DateComponents()
    startComps.day = 1
    startComps.month = month
    startComps.year = year
    var endComps = DateComponents()
    endComps.day = 1
    endComps.month = month == 12 ? 1 : month + 1
    endComps.year = month == 12 ? year + 1 : year
    let startDate = calendar.date(from: startComps)!
    let endDate = calendar.date(from: endComps)!
    let diff = (calendar as NSCalendar).components(NSCalendar.Unit.day, from: startDate, to: endDate, options: NSCalendar.Options.matchFirst)
    return diff.day!
    
}
 func storeSignupData(_ tokenData:String,mobile:String){
    
    let token = UserDefaults.standard
    token.set(tokenData, forKey: "Token")
    let mobileNumber = UserDefaults.standard
    mobileNumber.set(mobile, forKey: "mobileNumber")
//    let location = UserDefaults.standard
//    location.setValue(locationId, forKey: "locationId")
    
}

func updateToken(_ tokenData:String){
    
    let token = UserDefaults.standard
    token.set(tokenData, forKey: "Token")
    
}

func deleteToken(){
    
    let token = UserDefaults.standard
    token.removeObject(forKey: "Token")
    print(token)
}

struct apiEndPoint {
    static let commonPart = baseUrl
}
let defaults = UserDefaults.standard
let storedMobile = defaults.string(forKey: "mobileNumber")
let storedlocation = defaults.string(forKey: "locationId")

let font = UIFont(name: "Arial", size: 16)!
var locationTextArray = [String]()
var locationIdArray = [Int]()
var placeholdersText = [String]()
var textFields=[UITextField]()
var productList = [products]()
let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)

extension String {
    var length: Int { return count }
}
let internalError = "Something went wrong.please try again later."
let errorTitle = "Alert!"
let internetError = "Please check your internet connection."

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}
