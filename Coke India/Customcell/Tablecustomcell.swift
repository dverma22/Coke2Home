//
//  Tablecustomcell.swift
//  Coke
//
//  Created by SSDB on 8/8/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

import UIKit

class Remindercustomcell: UITableViewCell {

    @IBOutlet weak var reminderFrequency: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var deleteReminder: UIButton!
    @IBOutlet weak var editReminder: UIButton!

}

class Frequencycustomcell: UITableViewCell{
    
    @IBOutlet weak var Selectedcell: UIButton!
    @IBOutlet weak var Frequencytype: UILabel!
    
}

class Productdetailcustomcell:UITableViewCell{
    
    @IBOutlet weak var productThumbnail: UIImageView!
    @IBOutlet weak var name: UILabel!

}

class Ordersummarycustomcell: UITableViewCell {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var removeProduct: UIButton!
    @IBOutlet weak var quantityButton: UIButton!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var offerButton: UIButton!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var offers: UILabel!
    
}

class Productcustomcell: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var reminder: UIButton!
    
}
class Orderhistorycustomcell: UITableViewCell {
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    
}

class Addresscustomcell: UITableViewCell {
    
    @IBOutlet weak var addressTitle: UILabel!
    @IBOutlet weak var deleteAddress: UIButton!
    @IBOutlet weak var editAddress: UIButton!
    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var address2: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var addressType: UILabel!
    @IBOutlet weak var mobile: UILabel!
}

class Securitydepositcustomcell: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var amount: UILabel!
}

class Bottlereturncustomcell: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var qty: UILabel!
    
}

class Notificationcustomcell: UITableViewCell {
    
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var notificationIcon: UIImageView!
    @IBOutlet weak var customImage: UIImageView!
}

class Filtertableviewcell: UITableViewCell{
    
    @IBOutlet weak var filterCategory: UILabel!
}

class Orderlistcustomcell: UITableViewCell{
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var price: UILabel!
}
class offerCustomCell:UITableViewCell{
    
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var productName: UILabel!
}
