//
//  ViewController.swift
//  Demo
//
//  Created by 鈴木大志 on 2019/10/26.
//  Copyright © 2019 鈴木大志. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let motionManager = CMMotionManager()
    
    var xData = [Double]()
    var yData = [Double]()
    var zData = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                self.xData.append(data?.acceleration.x ?? 0)
                self.yData.append(data?.acceleration.y ?? 0)
                self.zData.append(data?.acceleration.z ?? 0)
            }
        }
        
        
    }

    @IBAction func saveButton(_ sender: UIButton) {
        print(self.xData)
        print(self.yData)
        print(self.zData)
    }
}

