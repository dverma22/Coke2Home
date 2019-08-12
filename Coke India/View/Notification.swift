//
//  Notification.swift
//  FlagOn
//
//  Created by SSDB on 7/29/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

import UIKit
class Notification: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var notificationTableView: UITableView!
    var notificationList = [Notifications]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.notificationTableView.delegate = self
        self.notificationTableView.dataSource = self
        notificationTableView.estimatedRowHeight = 88
        notificationTableView.rowHeight = UITableView.automaticDimension
        notificationTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.moreNavigationController.navigationBar.isHidden = true
        if Reachability.isConnectedToNetwork() == true {
            
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token"){
                let result = Api().callApi(token as NSString,url:allNotification)
                
                switch result.0  {
                case 200:
                    if result.1.count > 0 {
                        self.notificationList.removeAll()
                        if let items = result.1["Result"] as? [[String:AnyObject]]
                        {
                            for item in items {
                                self.notificationList.append(Notifications(dictionary:item))
                            }
                        }
                        notificationTableView.reloadData()
                    }
                    print(self.notificationList)
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
        else
        {
            Commonhelper().showErrorMessage(internetError)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.moreNavigationController.navigationBar.isHidden = false
    }
    
    func tableView(_ notificationTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notificationList.count
    }
    
    func tableView(_ notificationTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:Notificationcustomcell = notificationTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Notificationcustomcell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let notifications = notificationList[(indexPath as NSIndexPath).row]
        
        
        let  message = NSMutableAttributedString(
            string: notifications.message,
            attributes: [NSAttributedString.Key.font:UIFont(name: "Arial",size: 12.0)!])
        
        let Heading = NSMutableAttributedString(
            string: notifications.title + " ",
            attributes: [NSAttributedString.Key.font:UIFont(
                name: "HelveticaNeue-Bold",
                size: 12.0)!])
        let combination = NSMutableAttributedString()
        combination.append(Heading)
        combination.append(message)
        cell.notification?.attributedText = combination
        let dateSplitted = String(notifications.notificationDate).trimmingCharacters(in: .whitespaces).components(separatedBy: "T")
        cell.date?.text = dateSplitted[0]
        cell.customImage.layer.cornerRadius = 20
        cell.customImage.clipsToBounds = true
        return cell
    }
    
}


