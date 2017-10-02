//
//  DataManager.swift
//  TestfulApp
//
//  Created by Home on 2/10/17.
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    var data: AnyObject!
    
    typealias HelperCompletionHandler = (_ success: Bool, _ info: AnyObject?) -> Void
    typealias NilCompletionHanlder = () -> Void
    
    func getDataRequest(completionHandler: HelperCompletionHandler?) {
        if let path = Bundle.main.path(forResource: "data", ofType: "plist") {
            var isSuccess = false
            //If your plist contain root as Array
            if let array = NSArray(contentsOfFile: path) as? [[String: Any]] {
                print(array)
                isSuccess = true
                data = array as AnyObject
            }
            
            ////If your plist contain root as Dictionary
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                print(dic)
                isSuccess = true
                data = dic as AnyObject
            }
            
            DispatchQueue.main.async (execute: { () -> Void in
                if let handler = completionHandler {
                    handler(isSuccess, self.data as AnyObject?)
                }
            })
        }
    }
    
}
