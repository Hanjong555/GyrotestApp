//
//  getGyro.swift
//  GyroArray
//
//  Created by SatanSatoh on 2015/06/07.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

struct dataGyro{
    var dGx : Float
    var dGy : Float
    var dGz : Float
    internal var NEGAERI : Float
    init(){
        dGx = 0.0
        dGy = 0.0
        dGz = 0.0
        NEGAERI = 0.0
    }
}

@objc
class AllGyromotion : NSObject{
    
    let myDevice : UIDevice = UIDevice.currentDevice()
    lazy var myMotionManager = CMMotionManager()
    //要素1:回数 要素2:x座標 要素3:y座標 要素4:z座標
    internal var gyroArray = [dataGyro]()
    var gyroData = dataGyro()
    var gyromotionstopflag : Bool!
    //var count : Int = 0
    
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
                    //寝返りチェッカー
                    self.NEGAERI()
                    self.gyroArray.append(self.gyroData)
                    //self.count = self.count + 1
                    
            })
            //if (myMotionManager.gyroActive || count <= 60) {
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
    
    func proximitySensorStateDidChange(noification:NSNotification){
        
        if myDevice.proximityState == true {
            //近づいた時
        }else{
            //離れた時
        }
    }
}
