//
//  Orderlist.swift
//  Coke
//
//  Created by Deepak on 18/04/17.
//  Copyright © 2017 IOS Development. All rights reserved.
//

import Foundation

struct Orderdetails {
    let productId : Int
    let quantity : Int
    let unitPrice : Double
    let totalAmount : Double
    let productName : String
    let imageUrl : String
    init(dictionary : [String : AnyObject]) {
        productId = dictionary["OrderId"] as? Int ?? 0
        quantity = dictionary["Quantity"] as? Int ?? 0
        unitPrice = dictionary["UnitPrice"] as? Double ?? 0.0
        totalAmount = dictionary["TotalAmount"] as? Double ?? 0.0
        productName = dictionary["ProductName"] as? String ?? ""
        imageUrl = dictionary["ImageUrl"] as? String ?? ""
    }
}
struct OffersOnOrder {
   
    let productName : String
     let quantity : Int
    init(dictionary : [String : AnyObject]) {
        
        productName = dictionary["OfferProductName"] as? String ?? ""
        quantity = dictionary["OfferProductQty"] as? Int ?? 0
    }
}

struct OrdersMaster {
    let orderId : Int
    let orderDate : String
    let grandTotal : Double
    let orderStatus : String
    let totalAmount : Double
    let deposit : Double
    let taxAmt : Double
    let due : Double
    let address : String
    let bottleReturn : Int
    let orderShippingID:Int
    let erpInvoiceID : String
    init(dictionary : [String : AnyObject]) {
        orderId = dictionary["OrderId"] as? Int ?? 0
        orderDate = dictionary["OrderDate"] as? String ?? ""
        grandTotal = dictionary["GrandTotal"] as? Double ?? 0.0
        orderStatus = dictionary["OrderStatus"] as? String ?? ""
        totalAmount = dictionary["TotalAmount"] as? Double ?? 0.0
        deposit = dictionary["DepositAmount"] as? Double ?? 0.0
        taxAmt = dictionary["TaxAmount"] as? Double ?? 0.0
        due = dictionary["PreviousDue"] as? Double ?? 0.0
        address = dictionary["OrderShippingAddressTitle"] as? String ?? ""
        bottleReturn = dictionary["NoOfBottlesReturn"] as? Int ?? 0
        orderShippingID = dictionary["OrderShippingAddressId"] as? Int ?? 0
        erpInvoiceID = dictionary["ErpInvoiceId"] as? String ?? ""
    }
}
