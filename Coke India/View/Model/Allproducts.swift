//
//  Allproducts.swift
//  Coke
//
//  Created by SSDB on 9/16/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

struct products {
    
    let productName : String
    let unitPrice : Double
    let productId : Int
    let eRPProductId : String
    let productImage : String
    let productDescription : String
    let categoryId : Int
    let brandId : Int
    let taxId : Int
    let isActive : Bool
    let stock : Double
    let deposit : Double
    let bottleReturn : Int
    let taxPercentage : Double
    let taxAmount : Double
    let orderId : Int
    let offerDescription : [String]
    let favouriteId:Int
    let thumbnail:String
    
    init(dictionary : [String : AnyObject]) {
        productName = dictionary["ProductName"] as? String ?? ""
        unitPrice = dictionary["UnitPrice"] as? Double ?? 0.0
        productId = dictionary["ProductId"] as? Int ?? 0
        eRPProductId = dictionary["ERPProductId"] as? String ?? ""
        productImage = dictionary["ImageUrl"] as? String ?? ""
        productDescription = dictionary["ProductDescription"] as? String ?? ""
        offerDescription = dictionary["OfferDescription"] as? Array ?? []
        categoryId = dictionary["CategoryId"] as? Int ?? 0
        brandId = dictionary["BrandId"] as? Int ?? 0
        taxId = dictionary["TaxId"] as? Int ?? 0
        //Used false need to discuss
        isActive = dictionary["IsActive"] as? Bool ?? false
        stock = dictionary["Stock"] as? Double ?? 0
        deposit = dictionary["Deposit"] as? Double ?? 0
        //used false
        bottleReturn = dictionary["BootletoReturn"] as? Int ?? 0
        taxPercentage = dictionary["TaxPercentage"] as? Double ?? 0.0
        taxAmount = dictionary["TaxAmount"] as? Double ?? 0.0
        orderId = dictionary["OrderId"] as? Int ?? 0
        favouriteId = dictionary["FavouriteId"] as? Int ?? 0
        thumbnail = dictionary["ImageUrl"] as? String ?? ""
        
    }
}

struct Offer {
    let OfferId : Int
    let OfferType : String
    let OfferProductName : String
    let OfferQuantity : Int
    let OfferProductId : Int
    let ProductId : Int
    let ProductQty : Int
    let OfferTypeId : Int
    let defaultType :Bool
    let AppliedType : String
    
   init(dictionary : [String : AnyObject]) {
    
        OfferId = dictionary["OfferId"] as? Int ?? 0
        OfferType = dictionary["OfferType"] as? String ?? ""
        OfferProductName = dictionary["OfferProducName"] as? String ?? ""
        OfferQuantity = dictionary["OfferQuantity"] as? Int ?? 0
        OfferProductId = dictionary["OfferProductId"] as? Int ?? 0
        ProductId = dictionary["ProductId"] as? Int ?? 0
        ProductQty = dictionary["ProductQty"] as? Int ?? 0
        OfferTypeId = dictionary["OfferTypeId"] as? Int ?? 0
        defaultType = dictionary["DefaultApplied"] as? Bool ?? false
        AppliedType = dictionary["AppliedType"] as? String ?? ""
    }
}

