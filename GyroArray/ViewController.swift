//
//  ViewController.swift
//  ArraySample
//
//  Created by Satoh Wataru on 2015/05/15.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//

// (|X[(n-1)] - X[n]| + |Y[(n-1)] - Y[n]| + |Z[(n-1)] - Z[n]|)

import UIKit
import CoreMotion

class ViewController: UIViewController{
    
    let gyromotion  : AllGyromotion? = AllGyromotion()
    var gyroArray = [dataGyro]() //Gyro構造体移動
    var savegyroArray = [dataGyro]()
    var Dataday : String?   //同
    var Datadays = [String]()
    var DGX : String = "DGX"    //保存キー
    var DGY : String = "DGY"    //保存キー
    var DGZ : String = "DGZ"    //保存キー
    var AoC : String = "Amountofchange"
    let DGX_Format = "DGX"
    let DGY_Format = "DGY"
    let DGZ_Format = "DGZ"
    let AoC_Format = "Amountofchange"
    
    struct dataGyro{
        var dGx : Float
        var dGy : Float
        var dGz : Float
        init(){
            dGx = 0.0
            dGy = 0.0
            dGz = 0.0
        }
    }
    class AllGyromotion {
        
        lazy var myMotionManager = CMMotionManager()
        //要素1:回数 要素2:x座標 要素3:y座標 要素4:z座標
        internal var gyroArray = [dataGyro]()
        var gyroData = dataGyro()
        var gyromotionstopflag : Bool!
        
        func AllGyromotion(){
            gyroArray.removeAll()
            //println("Class配列初期化")
        }
        
        func getGyromotion() -> [dataGyro]{
            if myMotionManager.gyroAvailable{
                // 更新周期を設定.
                myMotionManager.gyroUpdateInterval = 1
                
                //ハンドラを設定し、加速度の取得開始
                let queue = NSOperationQueue()
                myMotionManager.startGyroUpdatesToQueue(queue, withHandler:
                    {(data: CMGyroData!, error: NSError!) -> Void in
                        /*
                        println("X = \(data.rotationRate.x)")
                        println("Y = \(data.rotationRate.y)")
                        println("Z = \(data.rotationRate.z)")
                        */
                        self.gyroData.dGx = Float(data.rotationRate.x)
                        self.gyroData.dGy = Float(data.rotationRate.y)
                        self.gyroData.dGz = Float(data.rotationRate.z)
                        self.gyroArray.append(self.gyroData)
                })
                if (myMotionManager.gyroActive) {
                    println("三軸データの取得を停止")
                    myMotionManager.stopGyroUpdates()
                }else{
                    println("三軸データの取得を開始")
                }
            }else{
                println("ジャイロセンサーを使用できません")
            }
            return gyroArray
        }
    
    
    
    }
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
    @IBOutlet weak var StartButton: UIButton!
    @IBAction func StartbuttonPushed(sender:AnyObject){
        //33StartButton.setTitle("データ取得中…", forState: .Normal)
        gyroArray = gyromotion!.getGyromotion()
    
    }
    
    @IBOutlet weak var StopGyro: UIButton!
    @IBAction func StopbuttonPushed(sender:AnyObject){
    
    }
    
    
    @IBOutlet weak var ReadDataButton: UIButton!
    @IBAction func display() {
        var savedGyroData = [[dataGyro]]()
        savedGyroData.append([dataGyro]())
        var gyroData = dataGyro()
        var udDataday : [String] = []
        var udDatadGx : [Float] = []
        var udDatadGy : [Float] = []
        var udDatadGz : [Float] = []
        var index : Int
        let ud = NSUserDefaults.standardUserDefaults()
        //println("読み込み準備完了")
        if let udDataday = ud.objectForKey("GetDataDay") as? [String] {
            //println(udDataday)
            for DayString in udDataday{
                DGX = DGX_Format
                DGY = DGY_Format
                DGZ = DGZ_Format
                DGX = DayString + DGX
                DGY = DayString + DGY
                DGZ = DayString + DGZ
                //println(DayString)
                if let udDatadGx = ud.objectForKey(DGX) as? [Float]{
                    if let udDatadGy = ud.objectForKey(DGY) as? [Float]{
                        if let udDatadGz = ud.objectForKey(DGZ) as? [Float]{
                            /*
                            println(udDatadGx)
                            println(udDatadGy)
                            println(udDatadGz)
                            */
                            for (var i = 0; i < udDatadGx.count; i++){
                                gyroData.dGx = udDatadGx[i]
                                gyroData.dGy = udDatadGy[i]
                                gyroData.dGz = udDatadGz[i]
                                //println("配列代入")
                                index = find(udDataday,DayString)!
                                //println(index)
                                savedGyroData.insert([dataGyro](), atIndex: index + 1)
                                savedGyroData[index].append(gyroData)
                            }
                        }
                    }
                }
            }
            println("読み込み完了")
        }
    
    }
    
    @IBOutlet weak var SaveDataButton: UIButton!
    @IBAction func put() {
        var DatadGx = [Float]() //データを書き込むための配列・取り出すための配列
        var DatadGy = [Float]() //同
        var DatadGz = [Float]() //同
        var AmountofChange = [Float]()
        var result : Float
        
        DGX = DGX_Format
        DGY = DGY_Format
        DGZ = DGZ_Format
        AoC = AoC_Format
        
        let dateFormatter = NSDateFormatter()// フォーマットの取得
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")  // JPロケール
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"         // フォーマットの指定  HH:mm:ss
        Dataday = dateFormatter.stringFromDate(NSDate())                // 現在日時
        let ud2 = NSUserDefaults.standardUserDefaults()
        /*
        for GD in gyroArray {
            DatadGx += [GD.dGx]
            DatadGy += [GD.dGy]
            DatadGz += [GD.dGz]
        }
        */
        for(var i = 0 ; i < gyroArray.count ; i++){
            DatadGx += [gyroArray[i].dGx]
            DatadGy += [gyroArray[i].dGy]
            DatadGz += [gyroArray[i].dGz]
            if(i > 0){
                result = fabs(gyroArray[i].dGx - gyroArray[i-1].dGx) + fabs(gyroArray[i].dGy - gyroArray[i-1].dGy) + fabs(gyroArray[i].dGz - gyroArray[i-1].dGz)
                AmountofChange += [result]
            }
        }
        DGX = Dataday! + DGX
        DGY = Dataday! + DGY
        DGZ = Dataday! + DGZ
        AoC = Dataday! + AoC
        
        Datadays.append(Dataday!)
        
        ud2.setObject(Datadays, forKey: "GetDataDay")
        ud2.setObject(DatadGx, forKey: DGX)
        ud2.setObject(DatadGy, forKey: DGY)
        ud2.setObject(DatadGz, forKey: DGZ)
        ud2.setObject(AmountofChange, forKey: AoC)
        println(Dataday!)
        println(DGX)
        println(DatadGx)
        println(DGY)
        println(DatadGy)
        println(DGZ)
        println(DatadGz)
        println(AoC)
        println(AmountofChange)
        DatadGx.removeAll()
        DatadGy.removeAll()
        DatadGz.removeAll()
        AmountofChange.removeAll()
        gyromotion?.AllGyromotion()
        //println("配列の初期化")
        ud2.synchronize()
        //println("保存完了")
    
    }
    
    @IBAction func delete() {
        let ud3 = NSUserDefaults.standardUserDefaults()
        ud3.removeObjectForKey("id")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    /*
    // リスト出力
    for (_var) in gyroArray {
    }
    */
    }
    
}
