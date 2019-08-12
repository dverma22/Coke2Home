//
//  Makepayment.swift
//  FlagOn
//
//  Created by Deepak on 31/01/17.
//  Copyright © 2017 IOS Development. All rights reserved.
//

import UIKit
import WebKit
class Makepayment: UIViewController,UIWebViewDelegate,WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var paymentWebView: UIWebView!
    var globalOrderID:String?
    weak var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentWebView.delegate = self
        let url = URL (string: baseFlagOnUrl+onlinePayment+(globalOrderID)!)
        print(url)
        let requestObj = URLRequest(url: url!)
        paymentWebView.loadRequest(requestObj)
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        let strUrl = request.url?.absoluteString
        print("changedURL")
        print(strUrl!)
        print(baseFlagOnSecureUrl+responseUrl)
        
        switch strUrl! {
        case baseFlagOnSecureUrl + responseUrl:
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Makepayment.paymentDone), userInfo: nil, repeats: false)
        case baseFlagOnDevSecureUrl + responseUrl:
              timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Makepayment.paymentDone), userInfo: nil, repeats: false)
        default:
            print("NO")
        }
        
        
        
        return true
    }
    //
    //
    
    @IBAction func dismissView(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "Token"){
            print(globalOrderID!)
            let response = Api().callApi(token as NSString, url: paymentStatusOnline+globalOrderID!)
            print(response.1)
            if response.0 == 200{
                let paymentStatus = (response.1).value(forKey: "Result") as! NSDictionary
                for (key, value) in paymentStatus {
                    if key as! String == "PaymentStatus" {
                        if value as! Bool {
                            print("Success")
                        }
                    }
                }
            }
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //let defaults = UserDefaults.standard
        //defaults.set("OnllinePaymentFailed", forKey: "paymentFailureCase")
        
    }
    @objc func paymentDone()
    {
        
        self.dismiss(animated: false, completion: nil)
        let placedOrderView : Placedorder = mainStoryboard.instantiateViewController(withIdentifier: "PlacedOrder") as! Placedorder
        
        
    }
    
}
