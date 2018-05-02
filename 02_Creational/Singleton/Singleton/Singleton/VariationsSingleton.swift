//
//  VariationsSingleton.swift
//  Singleton
//
//  Created by Tim Beals on 2018-03-15.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation


//Basic: exists once throughout the lifecycle of your app.

class OneAndOnly {
    
    private init() {}
    
    static let sharedInstance = OneAndOnly()
    
    func sayHello() -> String {
        return "I'm so unique."
    }
    
    deinit {
        print("I will only be called when the application closes.")
    }
}


//Internal optional: Specify when you want to init and deinit.

class God {
    
    private init() {}
    
    private struct Static {
        static var instance: God?
    }
    
    static var sharedInstance: God {
        if Static.instance == nil {
            Static.instance = God()
        }
        return Static.instance!
    }
    
    func sayHello() -> String {
        return "Hey, don't look now, but there goes God."
    }
    
    func destroy() {
        Static.instance = nil
    }
    
    deinit {
        print("Goodbye y'all")
    }
}

//print(God.sharedInstance.sayHello()) //initialized here (first time access shared)
//God.sharedInstance.destroy() //instance method sets itself to nil



