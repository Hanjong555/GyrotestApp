//
//  SaveDataAll.swift
//  GyroArray
//
//  Created by SatanSatoh on 2015/06/17.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//

import Foundation
/*
class UserGyroDataClass{
    var DGX : String = "DGX"    //保存キー
    var DGY : String = "DGY"    //保存キー
    var DGZ : String = "DGZ"    //保存キー
    var AoC : String = "Amountofchange"
    let DGX_Format = "DGX"
    let DGY_Format = "DGY"
    let DGZ_Format = "DGZ"
    let AoC_Format = "Amountofchange"
    var Dataday : String?   //同
    var Datadays = [String]()
    var DatadGx = [Float]() //データを書き込むための配列・取り出すための配列
    var DatadGy = [Float]() //同
    var DatadGz = [Float]() //同
    var AmountofChange = [Float]()
    var gyrocount : Int = 0
    
    func UserGyroDataClass(datadGx : [Float],datadGy : [Float],datadGz : [Float],amountofChange : [Float], gyrocount : Int){
        DatadGx = datadGx
        DatadGy = datadGy
        DatadGz = datadGz
        AmountofChange = amountofChange
    }
    
    func SaveGyro(){
        DGX = DGX_Format
        DGY = DGY_Format
        DGZ = DGZ_Format
        AoC = AoC_Format
        
        Dataday = TodayString()
        let ud2 = NSUserDefaults.standardUserDefaults()
        /*
        for GD in gyroArray {
        DatadGx += [GD.dGx]
        DatadGy += [GD.dGy]
        DatadGz += [GD.dGz]
        }
        */
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
        ud2.setObject(AmountofChange, forKey: AoC)
        for(var i = 0 ; i < gyrocount ; i++){
            strDGX += [NSString(format:"%01.6f",DatadGx[i])]
            strDGY += [NSString(format:"%01.6f",DatadGy[i])]
            strDGZ += [NSString(format:"%01.6f",DatadGz[i])]
            if(i > 0){
                strAmo += [NSString(format:"%01.6f",AmountofChange[i-1])]
            }
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
        //println(AmountofChange)
        gyromotion?.AllGyromotion()
        //println("配列の初期化")
        ud2.synchronize()
        //println("保存完了")
    }
    
    func LoadGyro(){
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
}

func TodayString() -> String{
    let dateFormatter = NSDateFormatter()// フォーマットの取得
    dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")  // JPロケール
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"         // フォーマットの指定  HH:mm:ss
    let stringday = dateFormatter.stringFromDate(NSDate())
    return stringday
}
*/