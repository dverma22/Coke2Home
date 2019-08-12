//
//  Forgotpassword.swift
//  Coke
//
//  Created by SSDB on 29/11/16.
//  Copyright © 2016 IOS Development. All rights reserved.
//

import UIKit

class Forgotpassword: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: forgotPassword)
        let requestObj = URLRequest(url: url!)
        webView.loadRequest(requestObj)
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.makeToastActivity(.center)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.hideToastActivity()
    }
    
    @objc func backPressed(_ button: UIButton){
     
        self.dismiss(animated: true, completion: nil)
    }
 }
