//
//  SaveData.swift
//  GyroArray
//
//  Created by SatanSatoh on 2015/06/07.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//

import Foundation

class SaverConnect{
    var json:NSData!
    
    func postsaverdata(DataObj : [Float], postURL : String){
        var myDict:NSMutableDictionary = NSMutableDictionary()
        myDict.setObject(DataObj, forKey: "GyroData")
        
        // 作成したdictionaryがJSONに変換可能かチェック.
        if NSJSONSerialization.isValidJSONObject(myDict){
            
            // DictionaryからJSON(NSData)へ変換.
            json = NSJSONSerialization.dataWithJSONObject(myDict, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
            
            // 生成したJSONデータの確認.
            println(NSString(data: json, encoding: NSUTF8StringEncoding)!)
            
        }
        // Http通信のリクエスト生成.
        let myCofig:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let myUrl:NSURL = NSURL(string : postURL)!
        
        let myRequest:NSMutableURLRequest = NSMutableURLRequest(URL: myUrl)
        
        let mySession:NSURLSession = NSURLSession(configuration: myCofig)
        
        myRequest.HTTPMethod = "POST"
        
        // jsonのデータを一度文字列にして、キーと合わせる.
        var myData:NSString = "json=\(NSString(data: json, encoding: NSUTF8StringEncoding)!)"
        
        // jsonデータのセット.
        myRequest.HTTPBody = myData.dataUsingEncoding(NSUTF8StringEncoding)
        
        let myTask:NSURLSessionDataTask = mySession.dataTaskWithRequest(myRequest, completionHandler: { (data, response, err) -> Void in
        })
        
        myTask.resume()
    }
}