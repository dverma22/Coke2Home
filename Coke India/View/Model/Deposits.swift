//
//  Deposits.swift
//  Coke
//
//  Created by Deepak on 21/02/17.
//  Copyright © 2017 IOS Development. All rights reserved.
//

import Foundation

struct Deposit {
    let depositAmount : Int
    let productId : Int
    let productName : String
    let productQty : Int
    
    init(dictionary : [String : AnyObject]) {
        depositAmount = dictionary["DepositAmount"] as? Int ?? 0
        productId = dictionary["ProductId"] as? Int ?? 0
        productName = dictionary["ProductName"] as? String ?? ""
        productQty = dictionary["ProductQty"] as? Int ?? 0
    }
}

struct Emptybottles {
    let bottleCount : Int
    let productId : Int
    let productName : String
    
    
    init(dictionary : [String : AnyObject]) {
        bottleCount = dictionary["BottleCount"] as? Int ?? 0
        productId = dictionary["ProductId"] as? Int ?? 0
        productName = dictionary["ProductName"] as? String ?? ""
        
    }
    
}
