//
//  Api.swift
//  FlagOn
//
//  Created by SSDB on 7/20/16.
//  Copyright © 2016 SSDB. All rights reserved.
//

import Foundation

class Api{
    
 func callApi(_ token: NSString,post:NSString,url:NSString) -> (Int,AnyObject){
        do
        {
            let url:URL = URL(string: apiEndPoint.commonPart+(url as String))!
            let bearer = "bearer " as String
           
            let bearerWithToken = bearer + (token as String)
            let encodedData:Data = post.data(using: String.Encoding.ascii.rawValue)!
            
            let request:NSMutableURLRequest = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = encodedData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(bearerWithToken as String, forHTTPHeaderField: "authorization")
            var responseError: NSError?
            var response: URLResponse?
            var urlData: Data?
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response)
            } catch let error as NSError {
                responseError = error
                urlData = nil
            }
            if (urlData != nil ) {
                let res = response as! HTTPURLResponse?;
                var response = res?.statusCode
                let jsonData:NSDictionary = try JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary
                if response == nil{
                    response = 401
                }
                
                return (response!,jsonData)
            }
        } catch {
            
            print(error)
        }
        return (0,"" as AnyObject)
    }
    
 func callApi(_ token: NSString,url:String) -> (Int,NSDictionary){
        do
        {
            let hostName = url
            let url:URL = URL(string: apiEndPoint.commonPart+url)!
            let bearer = "bearer " as String
           // var token = "6jWRrETpTAeSWZEqTakc8t9y-rJBW5wTeJLEJCi3RkGcE3UAdWtxoAWO1LdTpYoisDtzKZiYaa_Tl4LHIfSTDAH0z0RtE3zVi0-M47tPckZOdn1pVve2uu0UnocMs-x9gIbhFK-0L6fpKCjK83Ks--sp7_MSuezIygyBt6AmbgEIJAMRf_xTbLcWiFrsdDj0ra5CsYnUUTI6sU_la6FhyIc7hdbHAxJo56WZuxUu5Y1Lx5h_nU_Gq9OopDKwQcxU1mmsPBtcLQ4EfDNOCrcToj2TmpRoUcdnvtqQLcp9-VTV4olAzRcZgxIUTPj_LznCXaBTrAVTonDEKdzTPTaGN2UCw8qr_tl_UclBt5Atlfpo6QCXPbJ0dIULO6-eWhsoP7x7p5zNF7F3pY2ZSJ0ZQG74Tp9Kbuix68JewyhwOYecDwnldLeWcAUl31Ij_aOs9Nic_BXPKO7uJZmQSZ-9ZtSvMW9t3TJZD1sbx8sy5S6Kscj8cmyIh4ZY66mOXYqc"
            let bearerWithToken = bearer + (token as String)
            let request:NSMutableURLRequest = NSMutableURLRequest(url: url)
            
            if hostName == generateOtp
            {
                request.httpMethod = "POST"
            }
            else{
                request.httpMethod = "GET"
            }
            request.setValue(bearerWithToken as String, forHTTPHeaderField: "authorization")
            var response: URLResponse?
            var urlData: Data?
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response)
            } catch let error as NSError {
                var responseError: NSError? = error
                urlData = nil
            }
            if (urlData != nil ) {
                let res = response as! HTTPURLResponse?;
                var response = res?.statusCode
                 let jsonData:NSDictionary = try JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary
               if response == nil{
                    response = 401
                }
                
                return (response!,jsonData)
            }
        } catch {
            print(error)
        }
        
        return (0,[:])
    }
    
 func postApiResponse(_ token: NSString,url:NSString,post:NSString,method:NSString)-> (Int,NSDictionary){
        do
        {
            let  stringUrl = url
            let  updateQuantity = url
            let addressUrlString = addAddress
            let url:URL = URL(string: apiEndPoint.commonPart+(url as String))!
            print(url)
            let bearer = "bearer " as String
            let bearerWithToken = bearer + (token as String)
            let request:NSMutableURLRequest = NSMutableURLRequest(url: url)
            let encodedData:Data = post.data(using: String.Encoding.ascii.rawValue)!
            request.httpMethod = method as String
            
            if stringUrl as String == addressUrlString || stringUrl as String == updateAddress || updateQuantity as String == updateShoppingCartList || stringUrl as String == makePayment || stringUrl as String == addBillOffer || stringUrl as String == addProduct {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            if (stringUrl as String == cancelOrderAPI){
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            }
            request.httpBody = encodedData
            request.setValue(bearerWithToken as String, forHTTPHeaderField: "authorization")
            var response: URLResponse?
            var urlData: Data?
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response)
            } catch let error as NSError {
                var responseError: NSError? = error
                urlData = nil
            }
            if (urlData != nil ) {
                let res = response as! HTTPURLResponse?;
                var response = res?.statusCode
               let jsonData:NSDictionary = try JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary
                
                if response == nil{
                     response = 401
                }
                
                return (response!,jsonData)
            }
        } catch {
            print(error)
        }
        
        return (0,[:])
    }
    
 func deleteById(_ token: NSString,url:NSString,method:NSString)-> (Int,NSDictionary){
        do
        {
            let url:URL = URL(string: apiEndPoint.commonPart+(url as String))!
            let bearer = "bearer " as String
            let bearerWithToken = bearer + (token as String)
            let request:NSMutableURLRequest = NSMutableURLRequest(url: url)
            request.httpMethod = method as String
            request.setValue(bearerWithToken as String, forHTTPHeaderField: "authorization")
            var response: URLResponse?
            var urlData: Data?
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response)
            } catch let error as NSError {
                var responseError: NSError? = error
                urlData = nil
            }
            if (urlData != nil ) {
                let res = response as! HTTPURLResponse?;
                var response = res?.statusCode
               
                let jsonData:NSDictionary = try JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary
                if response == nil{
                    response = 401
                }
               
                return (response!,jsonData)
            }
        } catch {
            print(error)
        }
        
        return (0,[:])
    }
    
    func generateAddress(substring: String) -> (NSDictionary)
    {
        
        let urlString = "\(googleMapUrl)?key=\(googleMapsKey)&input=\(substring)"
        
        do {
            //let urlStr : NSString = urlString.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
            let urlStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let searchURL : NSURL = NSURL(string: urlStr as! String)!
            
             let request:NSMutableURLRequest = NSMutableURLRequest(url: searchURL as URL)
            request.httpMethod = "POST"
            //two types same need to change
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: URLResponse?
            
            var urlData: NSData?
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response) as NSData?
            } catch let error as NSError {
                reponseError = error
                urlData = nil
            }
            if ( urlData != nil ) {
                
                let responseData:NSString  = NSString(data:urlData! as Data, encoding:String.Encoding.utf8.rawValue)!
                
                let jsonData:NSDictionary = try JSONSerialization.jsonObject(with: urlData! as Data, options:JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary
                print(responseData)
                
                return jsonData
            }
            
        }
        catch {
            
            print("Location api not working")
        }
        return [:]
    }
    
}

