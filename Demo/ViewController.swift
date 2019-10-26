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
    
    @IBOutlet weak var timeTextField: UILabel!
    
    let motionManager = CMMotionManager()
    
    let startTime = Date()
    
    var xData = [Double]()
    var yData = [Double]()
    var zData = [Double]()
    var tData = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                self.xData.append(data?.acceleration.x ?? 0)
                self.yData.append(data?.acceleration.y ?? 0)
                self.zData.append(data?.acceleration.z ?? 0)
                self.tData.append(Date().timeIntervalSince(self.startTime))
            }
        }
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self,
                             selector: #selector(ViewController.updateTime),
                             userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        self.timeTextField.text = String(format:"%.1f", self.tData.last ?? 0)
    }

    @IBAction func saveButton(_ sender: UIButton) {
        print(self.xData)
        print(self.yData)
        print(self.zData)
        print(self.tData)
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dateFormater = DateFormatter()
            dateFormater.locale = Locale(identifier: "ja_JP")
            dateFormater.dateFormat = "yyyyMMddHHmmss"
            let nowDate = dateFormater.string(from:Date())
            let filePath = dir.appendingPathComponent("data\(nowDate).csv")
            let text = motionDataArrayToCSVString(xData, yData, zData, tData)
            do {
               print("filePath: \(filePath)")
               try text.write(to: filePath, atomically: true, encoding: .utf8)
            } catch {
               print("error")
            }
        }
    }
    
    func motionDataArrayToCSVString( _ xData: [Double], _ yData: [Double], _ zData: [Double], _ tData: [Double])
        -> String {
            if xData.count == yData.count && tData.count == zData.count && xData.count == tData.count {
                var dist = "time,x,y,z\n"
                for i in 0..<tData.count {
                    dist += "\(tData[i]),"
                    dist += "\(xData[i]),"
                    dist += "\(yData[i]),"
                    dist += "\(zData[i])\n"
                }
                return dist
            } else {
                return "error"
            }
    }
}

