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
    let accelemotion : AllAcclemotion? = AllAcclemotion()
    var gyroArray = [dataGyro]() //Gyro構造体移動
    var acceleArray = [dataAccele]() //加速度構造体移動
    var savegyroArray = [dataGyro]()
    var Dataday : String?   //同
    var Datadays = [String]()
    var DGX : String = "DGX"    //保存キー
    var DGY : String = "DGY"    //保存キー
    var DGZ : String = "DGZ"    //保存キー
    
    var DAX : String = "DAX"    //保存キー
    var DAY : String = "DAY"    //保存キー
    var DAZ : String = "DAZ"    //保存キー
    
    var AoC : String = "Amountofchange"
    let DGX_Format = "DGX"
    let DGY_Format = "DGY"
    let DGZ_Format = "DGZ"
    let AoC_Format = "Amountofchange"
    
    @IBOutlet weak var StartButton: UIButton!
    @IBAction func StartbuttonPushed(sender:AnyObject){
        //33StartButton.setTitle("データ取得中…", forState: .Normal)
        //gyroArray = gyromotion!.getGyromotion()
        acceleArray = accelemotion!.getAcclemotion()
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
        //Gyro系
        var DatadGx = [Float]() //データを書き込むための配列・取り出すための配列
        var DatadGy = [Float]() //同
        var DatadGz = [Float]() //同
        var AmountofChange = [Float]()
        var result : Float
        //Accele系
        var DatadAx = [Float]() //データを書き込むための配列・取り出すための配列
        var DatadAy = [Float]() //同
        var DatadAz = [Float]() //同
        
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
        
        for(var i = 0; i < acceleArray.count ; i++){
            DatadAx += [acceleArray[i].dAx]
            DatadAy += [acceleArray[i].dAy]
            DatadAz += [acceleArray[i].dAz]
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
        var strDGX = [NSString]()
        var strDGY = [NSString]()
        var strDGZ = [NSString]()
        var strAmo = [NSString]()
        
        var strDAX = [NSString]()
        var strDAY = [NSString]()
        var strDAZ = [NSString]()
        
        ud2.setObject(AmountofChange, forKey: AoC)
        for(var i = 0 ; i < gyroArray.count ; i++){
            strDGX += [NSString(format:"%01.6f",DatadGx[i])]
            strDGY += [NSString(format:"%01.6f",DatadGy[i])]
            strDGZ += [NSString(format:"%01.6f",DatadGz[i])]
            if(i > 0){
                strAmo += [NSString(format:"%01.6f",AmountofChange[i-1])]
            }
        }
        for(var i = 0 ; i < acceleArray.count ; i++){
            strDAX += [NSString(format:"%01.6f",DatadAx[i])]
            strDAY += [NSString(format:"%01.6f",DatadAy[i])]
            strDAZ += [NSString(format:"%01.6f",DatadAz[i])]
        }
        println(Dataday!)
        println(DGX)
        println(strDGX)
        //println(DatadGx)
        println(DGY)
        println(strDGY)
        //println(DatadGy)
        println(DGZ)
        println(strDGZ)
        //println(DatadGz)
        println(AoC)
        println(strAmo)
        
        println(DAX)
        println(strDAX)
        println(DAY)
        println(strDAY)
        println(DAZ)
        println(strDAZ)
        //println(AmountofChange)
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
