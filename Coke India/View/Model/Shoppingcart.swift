//
//  Shoppingcart.swift
//  Coke
//
//  Created by SSDB on 09/12/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

struct Cart {
    
    let deposit : Double
    let discountAmount : String
    let displayName : String
    let eRPProductId : String
    let imageUrl : String
    let offerDescription : String
    let offers : String
    let productId : Int
    let productName : String
    let productQty : Int
    //Not used camel case need to change
    let returnBottle : Int
    let stock : Int
    let unitPrice : Double
    let totalAmount:Double
    //let appliedOffer:[String:[String:AnyObject]]
    init(dictionary : [String : AnyObject]) {
        deposit = dictionary["Deposit"] as? Double ?? 0.0
        discountAmount = dictionary["DiscountAmount"] as? String ?? ""
        displayName = dictionary["DisplayName"] as? String ?? ""
        eRPProductId = dictionary["ERPProductId"] as? String ?? ""
        imageUrl = dictionary["ImageUrl"] as? String ?? ""
        offerDescription = dictionary["OfferDescription"] as? String ?? ""
        offers = dictionary["Offers"] as? String ?? ""
        productId = dictionary["ProductId"] as? Int ?? 0
        productName = dictionary["ProductName"] as? String ?? ""
        productQty = dictionary["Qty"] as? Int ?? 0
        returnBottle = dictionary["Return"] as? Int ?? 0
        stock = dictionary["Stock"] as? Int ?? 0
        unitPrice = dictionary["UnitPrice"] as? Double ?? 0.0
        totalAmount = dictionary["TotalAmount"] as? Double ?? 0.0
        //appliedOffer = dictionary["OffersApplied"] as? [String:[String:AnyObject]] ?? ["":["":"" as AnyObject]]
    }
}
struct commonDataForCart{
    
    let billAmount : Double
    let discountAmount : Double
    let billAmountBeforeDiscount : Double
    let totalTaxAmount : Double
    let depositAmount : Double
    let noOfBottlesReturn : Int
    let offerDescription : String
    
    init(dictionary : [String : AnyObject]) {
        billAmount = dictionary["BillAmount"] as? Double ?? 0.0
        discountAmount = dictionary["DiscountAmount"] as? Double ?? 0.0
        billAmountBeforeDiscount = dictionary["BillAmountBeforeDiscount"] as? Double ?? 0.0
        totalTaxAmount = dictionary["TotalTaxAmount"] as? Double ?? 0.0
        depositAmount = dictionary["DepositAmount"] as? Double ?? 0.0
        noOfBottlesReturn = dictionary["NoOfBottlesReturn"] as? Int ?? 0
        offerDescription = dictionary["OfferDescription"] as? String ?? ""
        
    }

}
