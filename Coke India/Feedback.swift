//
//  Feedback.swift
//  FlagOn
//
//  Created by SSDB on 24/01/17.
//  Copyright © 2017 IOS Development. All rights reserved.
//

import UIKit

class Feedback: UIViewController,UITextViewDelegate{

   var placeholderLabel : UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var complientTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        complientTextView.layer.borderWidth = 1
        complientTextView.layer.borderColor = UIColor.red.cgColor
        Commonhelper().buttonCornerRadius(submitButton)
        complientTextView.layer.cornerRadius = 5
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Feedback.handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        
        complientTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Type your feedback..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (complientTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        complientTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (complientTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !complientTextView.text.isEmpty
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ratingView.rating = 0.0
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if  complientTextView.text == ""
        {
            placeholderLabel.isHidden = false
        }
        else
        {
            placeholderLabel.isHidden = true
        }
        
    }
    
    @IBAction func submitExperience(_ sender: AnyObject) {
        
        if ratingView.rating != 0.0{
            if Reachability.isConnectedToNetwork() == true {
                let defaults = UserDefaults.standard
                let complient = complientTextView.text!
                
                let postData = "Rating=\(String(Int(ratingView.rating)))&FeedBackType=\(0)&Message=\(complient)"
                self.view.makeToastActivity(.center)
                print(postData)
                
                if let token = defaults.string(forKey: "Token"){
                    let response = Api().postApiResponse(token as NSString, url: submitFeedback as NSString, post: postData as NSString, method: "POST")
                    print(token)
                    switch response.0 {
                    case 200:
                        self.view.hideToastActivity()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                        self.view.makeToast("Thank you for your feedback.")
                        }
                    case 400:
                        self.view.hideToastActivity()
                         Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                    case 500:
                        self.view.hideToastActivity()
                        //
                        Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                    case 401:
                        let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                        self.present(signinScreen, animated: true, completion: nil)
                    case 0:
                        self.view.hideToastActivity()
                        Commonhelper().showErrorMessage(internalError as String,title: errorTitle)
                    default:
                        self.view.hideToastActivity()
                        let signinScreen : SignIn = mainStoryboard.instantiateViewController(withIdentifier: "Signin") as! SignIn
                        self.present(signinScreen, animated: true, completion: nil)
                    }
                    
                }
            }
                
           else{
                self.view.hideToastActivity()
                Commonhelper().showErrorMessage(internetError)
            }
        }
        else{
            //required
            self.view.makeToast("Please rate our service.")
            print("Required")
        
        }
        
    }
    
}
