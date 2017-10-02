//
//  ViewController.swift
//  TestfulApp
//
//  Created by Home on 2/10/17.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loadingImageView: UIImageView!
    
    var timer: DispatchSourceTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.startTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startTimer() {
        var count = 0
        
        let queue = DispatchQueue(label: "com.domain.app.timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.scheduleRepeating(deadline: .now(), interval: .seconds(1))
        timer!.setEventHandler { [weak self] in
            // do whatever you want here
            //let diff = Int64(Date().timeIntervalSince1970 * 1000)
            //let diff = Date().timeIntervalSince1970
            //print(diff)
            count = count + 1
            var mod = 0
            //print("count=\(count)")
            
            if count > 6 {
                mod = count%6
            } else {
                mod = count
            }
            
            if mod == 0 {
                mod = 6
            }
            
            print("count=\(mod)")
            
            DispatchQueue.main.async(execute: {
                self?.loadingImageView.image = UIImage(named: "loading\(mod)")
            })
            
        }
        
        timer!.resume()
    }

    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    deinit {
        self.stopTimer()
    }
    

}

