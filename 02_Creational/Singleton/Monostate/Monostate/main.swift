//
//  main.swift
//  Monostate
//
//  Created by Tim Beals on 2018-02-15.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

//MONOSTATE!
//instead of storing values in a single instance, store your values privately in the class and access them from any number of instances

//THE ISSUE...
//A Monostate works like a singleton, but it doesn't communicate that it is a singleton to the consumer. It looks like it should work like a class (because a Singleton has a 'shared' property and a monostate doesn't) CONFUSING TO THE USER!
//DON'T USE IT, BUT RECOGNIZE IT IF SOMEONE ELSE USES IT.

class CEO: CustomStringConvertible {
    
    private static var _name: String = ""
    private static var _age: Int = 0
    
    var name: String {
        get { return type(of: self)._name }
        set(val) { type(of: self)._name = val }
    }
    
    var age: Int {
        get { return type(of: self)._age }
        set(val) { type(of: self)._age = val }
    }
    
    
    public var description: String {
        return "I am the CEO. My name is \(name) and my age is \(age)"
    }
}


let ceo1 = CEO()
ceo1.name = "Adam Smith"
ceo1.age = 44
print(ceo1)

let ceo2 = CEO()
ceo2.age = 56
print(ceo2)


