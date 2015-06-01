//
//  ViewController.swift
//  Pusher
//
//  Created by Suleyman Calik on 28/05/15.
//  Copyright (c) 2015 Calik. All rights reserved.
//

import UIKit
import SweetHMAC
import CryptoSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func push(sender: UIButton) {
        pushMe(channelName:"test-channel", eventName:"test-event", data:"SELAM")
    }
    
    
    func pushMe(#channelName:String , eventName:String , data:String) {
        
        let appId = "YOUR_APP_ID"
        let authKey = "YOUR_ACCESS_TOKEN_KEY"
        let secretKey = "YOUR_ACCESS_TOKEN_SECRET"
        
        var body = ["name":eventName,"channels":[channelName],"data":data]
        var bodyData = NSJSONSerialization.dataWithJSONObject(body, options:.allZeros, error:nil)!
        var bodyStr = String(NSString(data:bodyData, encoding:NSUTF8StringEncoding)!)
        var md5 = bodyStr.md5()!.lowercaseString
        
        let method = "POST"
        
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        
        let baseUrl = "http://api.pusherapp.com"
        let endpoint = "/apps/\(appId)/events"
        let urlParams = "auth_key=\(authKey)&auth_timestamp=\(timeStamp)&auth_version=1.0&body_md5=\(md5)"

        let signatureStr = method + "\n" + endpoint + "\n" + urlParams
        var signature = signatureStr.HMAC(HMACAlgorithm.SHA256, secret:secretKey)
        
        var urlStr = baseUrl + endpoint + "?" + urlParams + "&auth_signature=" + signature
        
        var url = NSURL(string:urlStr)!
        var request = NSMutableURLRequest(URL:url)
        request.addValue("application/json", forHTTPHeaderField:"Content-Type")
        
        
        request.HTTPBody = bodyData
        request.HTTPMethod = "POST"
        
        NSURLConnection.sendAsynchronousRequest(request, queue:NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if let data = data {
                var dataStr = NSString(data:data, encoding:NSUTF8StringEncoding)
                println(dataStr)
            }
            else {
                println("ERROR: \(error)")
            }
            
        }
        
        
    }


}

