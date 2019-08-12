//
//  Favorite.swift
//  Coke India
//
//  Created by SSDB on 04/10/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

struct Favorites {
    let productId : Int
    let favoriteId : Int
    let productName : String
    let unitPrice : Double
    
    let productImage : String
    let categoryID : Int
    let productThumb : String
    let categoryName :String
    init(dictionary : [String : AnyObject]) {
        favoriteId = dictionary["FavoriteId"] as? Int ?? 0
        productId = dictionary["ProductId"] as? Int ?? 0
        categoryID = dictionary["CategoryId"] as? Int ?? 0
        productName = dictionary["ProductName"] as? String ?? ""
        unitPrice = dictionary["UnitPrice"] as? Double ?? 0.0
        productImage = dictionary["ImageUrl"] as? String ?? ""
        productThumb = dictionary["ThumbnailUrl"] as? String ?? ""
        categoryName = dictionary["CategoryName"] as? String ?? ""
     }
}
