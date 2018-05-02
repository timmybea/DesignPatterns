//
//  main.swift
//  Proxy
//
//  Created by Tim Beals on 2018-02-22.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
 PROXY
 
 A class that functions as an interface to a particular resource. That resource may be remote, expensive to construct, or may require logging or some other added functionality. Your interface is typically UNCHANGED while the behavior is different.
 
 Motivation:
You are calling "foo.bar()", this assumes that 'foo' is in the same process as 'bar()'. What if, later on, you want to put all of the foo-related operations into a separate process.
 You don't want to change your code - This is where you can use a proxy. Same interface but entirely different behavior
 Different types of Proxy: Communication, logging, virtual, guarding
 */

//PROTECTION PROXY: Guards access to certain functionality

protocol Vehicle {
    func drive()
}

class Car: Vehicle {
    
    func drive() {
        print("car being driven")
    }
    
}

//We want to build a proxy to guard against 'unlicensed people' being able to drive the car.
class Driver {
    var age: Int
    init(age: Int) {
        self.age = age
    }
}


class CarProxy: Vehicle {
    private let car = Car()
    private let driver: Driver
    
    init(driver: Driver) {
        self.driver = driver
    }
    
    func drive() {
        if driver.age >= 16 {
            car.drive()
        } else {
            print("driver is not old enough to perform drive action")
        }
    }
    
}

/*
 NOTICE: The proxy adopts the same protocol as the Car class, so the interface is the same 'drive()' However, the functionality that is provided is different. It looks a bit like the decorator pattern...
 
 Proxy v Decorator
 Proxy provides identical interface 'drive()' whereas decorator provides an enhanced interface (additional traits and operations)
 Decorator typically aggregates what it is decorating (often as a constructor argument) whereas Proxy doesn't have to.
 Proxy may not even be working with a materialized object. It could be lazy var and uninstantiated.
 */


var silverBullet = CarProxy(driver: Driver(age: 20))
silverBullet.drive()
