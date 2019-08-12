//
//  Notification.swift
//  Coke
//
//  Created by Deepak on 21/02/17.
//  Copyright © 2017 IOS Development. All rights reserved.
//

import Foundation

struct Notifications {
    let title : String
    let message : String
    let type : String
    let notificationDate : String
    
    init(dictionary : [String : AnyObject]) {
        title = dictionary["Title"] as? String ?? ""
        message = dictionary["Message"] as? String ?? ""
        type = dictionary["Type"] as? String ?? ""
        notificationDate = dictionary["NotificationDate"] as? String ?? ""
    }
}
