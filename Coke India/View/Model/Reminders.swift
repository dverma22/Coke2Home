//
//  Allreminders.swift
//  Coke
//
//  Created by SSDB on 08/10/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

struct Allreminders {
    let productId : Int
    let reminderDays : String
    let reminderTime : String
    let productName : String
    let reminderId : Int
    
    init(dictionary : [String : AnyObject]) {
        productId = dictionary["ProductId"] as? Int ?? 0
        reminderDays = dictionary["ReminderDays"] as? String ?? ""
        reminderTime = dictionary["ReminderTime"] as? String ?? ""
        productName = dictionary["ProductName"] as? String ?? ""
        reminderId = dictionary["ReminderId"] as? Int ?? 0
    }
}
