////
//  Addresses.swift
//  Coke
//
//  Created by SSDB on 29/11/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

struct Addresses {
    let address1 : String
    let address2 : String
    let addressTitle : String
    let addressType : String
    let contactNumber : String
    let locationId : Int
    let locationText : String
    let addressId : Int
    
    init(dictionary : [String : AnyObject]) {
        address1 = dictionary["Address1"] as? String ?? ""
        address2 = dictionary["Address2"] as? String ?? ""
        addressTitle = dictionary["AddressTitle"] as? String ?? ""
        addressType = dictionary["AddressType"] as? String ?? ""
        contactNumber = dictionary["ContactNumber"] as? String ?? ""
        locationId = dictionary["LocationId"] as? Int ?? 0
        locationText = dictionary["LocationText"] as? String ?? ""
        addressId = dictionary["AddressId"] as? Int ?? 0
    }
}
