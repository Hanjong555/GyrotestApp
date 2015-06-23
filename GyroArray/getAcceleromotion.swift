//
//  getAcceleromotion.swift
//  GyroArray
//
//  Created by SatanSatoh on 2015/06/22.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

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
class AllAcclemotion : NSObject{
    let myDevice : UIDevice = UIDevice.currentDevice()
    lazy var myMotionManager = CMMotionManager()
    internal var accleArray = [dataAccele]()
    var accleData = dataAccele()
    var acclemotionstopflag : Bool!
    
    func AllAcclemotion(){
        accleArray.removeAll()
    }
    
    func getAcclemotion() -> [dataAccele]{
        if myMotionManager.accelerometerAvailable{
            // MotionManagerを生成.
            myMotionManager = CMMotionManager()
            
            // 更新周期を設定.
            myMotionManager.accelerometerUpdateInterval = 1
            
            // 加速度の取得を開始.
            myMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(accelerometerData:CMAccelerometerData!, error:NSError!) -> Void in
                self.accleData.dAx = Float(accelerometerData.acceleration.x)
                self.accleData.dAy = Float(accelerometerData.acceleration.y)
                self.accleData.dAz = Float(accelerometerData.acceleration.z)
                self.accleArray.append(self.accleData)
            })
            if(myMotionManager.accelerometerActive){
                println("加速度センサーの取得を停止")
                myDevice.proximityMonitoringEnabled = false
                myMotionManager.stopAccelerometerUpdates()
            }
            else{
                println("加速度センサーの取得開始")
            }
        }
        else{
            println("加速度センサーが取得できません")
        }
        return accleArray
    }
}