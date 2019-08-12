//
//  Accountconfirmation.swift
//  Coke
//
//  Created by SSDB on 9/15/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

import UIKit

class Accountconfirmation: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Reachability.isConnectedToNetwork() == true {
            
            let defaults = UserDefaults.standard
            if let token = defaults.string(forKey: "Token"){
                //condition check(api calling) required or not confirm with ms.....
            let confirmationStatus = Api().callApi(token as NSString,url: isAcctConfirmed)
            let boolStatus = confirmationStatus.1.value(forKey: "Result") as! Bool
            if confirmationStatus.0 == 200 && boolStatus == true{
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
                let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = viewController
            }
            //show error
            }
        }
        else{
            Commonhelper().showErrorMessage(internetError)
        }
    }
    
}
