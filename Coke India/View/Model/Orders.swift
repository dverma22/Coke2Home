//
//  Orders.swift
//  Coke India
//
//  Created by SSDB on 06/10/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

struct Orders {
    let orderId : Int
    let orderDate : String
    let grandTotal : Double
    let orderStatus : String
    let totalAmount : Double
    let erpInvoiceID : String
    init(dictionary : [String : AnyObject]) {
        orderId = dictionary["OrderId"] as? Int ?? 0
        orderDate = dictionary["OrderDate"] as? String ?? ""
        grandTotal = dictionary["GrandTotal"] as? Double ?? 0.0
        orderStatus = dictionary["OrderStatus"] as? String ?? ""
        totalAmount = dictionary["TotalAmount"] as? Double ?? 0.0
        erpInvoiceID = dictionary["ErpInvoiceId"] as? String ?? ""
    }
}
