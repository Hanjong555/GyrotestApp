//
//  httpgets.swift
//  GyroArray
//
//  Created by SatanSatoh on 2015/06/23.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//

import Foundation

class HTTPControl{
    var urlString : String
    var addURL : String
    var RequestMethod : String
    var request : NSMutableURLRequest
    
    init(tryURL:String,ToRequestMethod:String){
        urlString = tryURL
        request = NSMutableURLRequest()
        RequestMethod = ToRequestMethod
        addURL = ""
    }
    
    func makeDataHTTP(userID:Int ,dataID : Int, data : Float){
        var Amount = String(stringInterpolationSegment: data)
        Amount = Amount.stringByReplacingOccurrencesOfString(".", withString: "_", options: nil, range: nil)
        addURL = urlString + "/" + String(userID) + "/" + String(dataID) + "/" + Amount
        formatHTTP()
    }
    
    
    func formatHTTP(){
        request = NSMutableURLRequest(URL: NSURL(string: addURL)!)
        request.HTTPMethod = RequestMethod
    }
    
    func HTTPCheck(){
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { data, response, error in
            if (error == nil) {
                var result = NSString(data : data, encoding: NSUTF8StringEncoding)!
                println(result)
            } else {
                println(error)
            }
        })
        task.resume()
    }
}