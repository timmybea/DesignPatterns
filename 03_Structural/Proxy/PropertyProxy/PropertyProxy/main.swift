//
//  main.swift
//  PropertyProxy
//
//  Created by Tim Beals on 2018-02-24.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
 PROPERTY PROXY: You want to handle the complex functionality that occurs around the getting and setting of a simple property in its own class. It features a simple exposed property with the complexity in an internal class.
 */


//EXAMPLE: GAME. We want to have the complex logic around the getting/setting of an agility property in its own class. We want this property to be comparable.

class Property<T: Equatable> {
    private var _value: T
    
    //Notice that we store the value privately and we make our public var a computed property with functionality built into the getter and setter.
    public var value: T {
        get { return _value }
        set(value) {
            if value == _value { return  }
            print("Setting value to \(value)")
            self._value = value
        }
    }
    
    init(_ v: T) {
        self._value = v
    }
}

extension Property: Equatable {
    
    static func ==<T>(lhs: Property<T>, rhs: Property<T>) -> Bool {
        return lhs.value == rhs.value
    }
    
}


class Creature {
    //Now we can use the proxy class internally and all of the functionality that we've created in the proxy is separate from the class.
    private let _agility = Property<Int>(0)
    
    //MOST IMPORTANT!!!!
    //Now we can expose agility as an ordinary integer, but it has all the functionality of our class type Property
    var agility: Int {
        get { return _agility.value }
        set(val) { _agility.value = val }
    }
}


//USE:
let c = Creature()
c.agility = 10 //using the setter in the proxy

print(c.agility) //using the getter in the proxy

let d = Creature()
d.agility = 10

print(d.agility == c.agility) //and here is the equatable functionality.


/*
 Proxy v Decorator
 Proxy provides an identical interface whereas Decorator provides an enhanced interface
 */
