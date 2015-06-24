//
//  getGyro.swift
//  GyroArray
//
//  Created by SatanSatoh on 2015/06/07.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//
//(|X[(n-1)] - X[n]| + |Y[(n-1)] - Y[n]| + |Z[(n-1)] - Z[n]|)

/*
println("X = \(data.rotationRate.x)")
println("Y = \(data.rotationRate.y)")
println("Z = \(data.rotationRate.z)")
*/

import Foundation
import UIKit
import CoreMotion

struct dataGyro{
    var dGx : Float
    var dGy : Float
    var dGz : Float
    var Amount : Float
    internal var NEGAERI : Float
    init(){
        dGx = 0.0
        dGy = 0.0
        dGz = 0.0
        Amount = 0.0
        NEGAERI = 0.0
    }
}

struct dataAccele {
    var dAx : Float
    var dAy : Float
    var dAz : Float
    init(){
        dAx = 0.0
        dAy = 0.0
        dAz = 0.0
    }
}

@objc
class AllMotionSensor : NSObject{
    
    //センサーの利用を設定
    let myDevice : UIDevice = UIDevice.currentDevice()
    lazy var myMotionManager = CMMotionManager()
    
    //ジャイロ系
    internal var gyroArray = [dataGyro]()
    var gyroData = dataGyro()
    var gyromotionstopflag : Bool!
    //httpのセット
    var SendHTTP = HTTPControl(tryURL: "https://awake-test.herokuapp.com/static_pages/about/",ToRequestMethod: "GET" )
    //var count : Int = 0
    
    //加速度系
    internal var AcceleArray = [dataAccele]()
    var AcceleData = dataAccele()
    var Accelemotionstopflag : Bool!
    
    //動作するもの
    func RunMotionSensor(){
        formatGyromotion()
        formatGyromotion()
        getGyromotion()
        getAccelemotion()
    }
    
    func FormatMotion(){
        formatGyromotion()
        formatAccelemotion()
    }
    
    //配列初期化用
    func formatGyromotion(){
        gyroArray.removeAll()
    }
    //配列初期化用
    func formatAccelemotion(){
        AcceleArray.removeAll()
    }
    
    //Gyroセンサーの取得関数 -> ジャイロ配列を戻す
    func getGyromotion() -> [dataGyro]{
        if myMotionManager.gyroAvailable{
            // 更新周期を設定.
            myMotionManager.gyroUpdateInterval = 1
    
            //ハンドラを設定し、加速度の取得開始
            let queue = NSOperationQueue()
            myMotionManager.startGyroUpdatesToQueue(queue, withHandler:
            {(data: CMGyroData!, error: NSError!) -> Void in
                self.gyroData.dGx = Float(data.rotationRate.x)
                self.gyroData.dGy = Float(data.rotationRate.y)
                self.gyroData.dGz = Float(data.rotationRate.z)
                //寝返りチェッカー
                self.NEGAERI()
                //変化量の抽出
                if(!self.gyroArray.isEmpty){
    
                    self.gyroData.Amount = self.AmountCalculator()
    
                    //self.SendHTTP.makeDataHTTP(30, dataID: 1, data: self.gyroData.Amount)
                    //self.SendHTTP.HTTPCheck()
    
                    self.gyroArray.append(self.gyroData)
                }else{
                    self.gyroArray.append(self.gyroData)
                }
            })
                if ( myMotionManager.gyroActive ) {
                    println("三軸データの取得を停止")
                    //近接センサーのOFF
                    myDevice.proximityMonitoringEnabled = false
    
                    //近接センサーの監視を解除
                    NSNotificationCenter.defaultCenter().removeObserver(self, name:UIDeviceProximityStateDidChangeNotification,object: nil)
    
                    myMotionManager.stopGyroUpdates()
    
                }else{
                    //近接センサーのON
                    myDevice.proximityMonitoringEnabled = true
                    NSNotificationCenter.defaultCenter().addObserver(self,selector:"proximitySensorStateDidChange:",name:UIDeviceProximityStateDidChangeNotification,object: nil)
    
                    println("三軸データの取得を開始")
                }
            }else{
                println("ジャイロセンサーを使用できません")
            }
        return gyroArray
    }
    
    //寝返りチェッカー
    func NEGAERI(){
        //if(){
        self.gyroData.NEGAERI = 1.0
        //}
    }
    
    func AmountCalculator() -> Float{
        return fabs(self.gyroArray[self.gyroArray.count - 1].dGx - self.gyroData.dGx) + fabs(self.gyroArray[self.gyroArray.count - 1].dGy - self.gyroData.dGy) - fabs(self.gyroArray[self.gyroArray.count - 1].dGz - self.gyroData.dGz)
    }
    
    func getAccelemotion() -> [dataAccele]{
        if myMotionManager.accelerometerAvailable{
    
            // 更新周期を設定.
            myMotionManager.accelerometerUpdateInterval = 1
    
            // 加速度の取得を開始.
            myMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(accelerometerData:CMAccelerometerData!, error:NSError!) -> Void in
                self.AcceleData.dAx = Float(accelerometerData.acceleration.x)
                self.AcceleData.dAy = Float(accelerometerData.acceleration.y)
                self.AcceleData.dAz = Float(accelerometerData.acceleration.z)
                self.AcceleArray.append(self.AcceleData)
            })
            if(myMotionManager.accelerometerActive){
                println("加速度センサーの取得を停止")
                myDevice.proximityMonitoringEnabled = false
                myMotionManager.stopAccelerometerUpdates()
            }else{
                println("加速度センサーの取得開始")
            }
        }else{
            println("加速度センサーが取得できません")
        }
        return AcceleArray
    }
    
    
    func proximitySensorStateDidChange(noification:NSNotification){
    
        if myDevice.proximityState == true {
        //近づいた時
        }else{
        //離れた時
        }
    }
}
