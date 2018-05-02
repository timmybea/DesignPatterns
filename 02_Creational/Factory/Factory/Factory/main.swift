//
//  main.swift
//  Factory
//
//  Created by Tim Beals on 2018-02-12.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
Factory
“A component responsible solely for the wholesale creation of objects.”

Why?
Object creation logic becomes too convoluted
Initializer is not descriptive



 FACTORY - METHOD, INNER, ABSTRACT
 rationale: wholesale creation of objects, especially in situations when you want to init them in different ways. Eg: poiint could be init'ed as cartesian or polar.
 
 method: create descriptive static methods withing the object class that returns the init call. make the init methods private.
 
 factory: place the same static methods in a separate factory class. Note that this will require the init methods to be exposed, so it's less good.
 
 inner factory static: place the factory class inside the object class. Now it is clear that the static methods are for the purpose of object creation.
 
 inner factory singleton: If for some reason you need to store values you could create an instance of the factory within the object class. Depending on the situation, you could also choose to make this a singleton.
 
 
*/


//FACTORY METHOD:
//We want to be able to build two different types of points. Cartesian and polar. We want to be descriptive in our creation of each type.

class Point: CustomStringConvertible {
    var x, y: Double
    
    //cartesian
    private init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    //polar point
    //in swift you can have an overload which takes exactly the same parameters but gives them different names, which helps, but this is not a feature of other OOP languages.
    private init(rho: Double, theta: Double) {
        self.x = rho * cos(theta)
        self.y = rho * sin(theta)
    }
    
    //factory method is a static method used to construct an object.
    static func createCartesian(x: Double, y: Double) -> Point {
        return Point(x: x, y: y)
    }
    
    static func createPolar(rho: Double, theta: Double) -> Point {
        return Point(rho: rho, theta: theta)
    }
    
    var description: String {
        return "x:\(x), y: \(y)"
    }
}

//var p = Point(rho: 4.0, theta: 6.0)
//Notice that init methods always have the class name as their naming convention. Sometimes we want our initialization to be more decsriptive and this is where factories come in...



//now you can have a more descriptive construction
var p = Point.createCartesian(x: 4.0, y: 6.0)


//FACTORY: Achieves the same goals as factory method but places the static methods in a new class.

class APoint: CustomStringConvertible {
    var x, y: Double
    
    //cartesian
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    //polar point
     init(rho: Double, theta: Double) {
        self.x = rho * cos(theta)
        self.y = rho * sin(theta)
    }
    
    var description: String {
        return "x:\(x), y: \(y)"
    }
}


class APointFactory {

    //you can choose whether to have instance or static methods.
    func createCartesian(x: Double, y: Double) -> APoint {
        return APoint(x: x, y: y)
    }
    
    func createPolar(rho: Double, theta: Double) -> APoint {
        return APoint(rho: rho, theta: theta)
    }
}


let apf = APointFactory()
let ap = apf.createCartesian(x: 4.0, y: 6.0)

//What is the cost? Factory Method allows you to encapsulate your point initializers, whereas Factory exposes them.


//INNER FACTORY
//Perhaps you don't want to use factory method, but you are dissatisfied with the exposed nature of your initializers. Then you can use an Inner Factory. Build the factory class within your Point class.


class BPoint: CustomStringConvertible {
    private var x, y: Double
    
    //cartesian
    private init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    //polar point
    private init(rho: Double, theta: Double) {
        self.x = rho * cos(theta)
        self.y = rho * sin(theta)
    }
    
    var description: String {
        return "x:\(x), y: \(y)"
    }
    
    class BPointFactory {
        
        static func createCartesian(x: Double, y: Double) -> BPoint {
            return BPoint(x: x, y: y)
        }
        
        static func createPolar(rho: Double, theta: Double) -> BPoint {
            return BPoint(rho: rho, theta: theta)
        }
    }
}


let bp = BPoint.BPointFactory.createCartesian(x: 4.0, y: 2.0)
print(bp)


//WITH A SINGLETON... greater encapsulation(?)

class CPoint: CustomStringConvertible {
    private var x, y: Double
    
    //cartesian
    private init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    //polar point
    private init(rho: Double, theta: Double) {
        self.x = rho * cos(theta)
        self.y = rho * sin(theta)
    }
    
    var description: String {
        return "x:\(x), y: \(y)"
    }
    
    
    static let factory = CPointFactory.instance
    
    class CPointFactory {
        
        private init() {}
        static let instance = CPointFactory()
        
        func createCartesian(x: Double, y: Double) -> CPoint {
            return CPoint(x: x, y: y)
        }
        
        func createPolar(rho: Double, theta: Double) -> CPoint {
            return CPoint(rho: rho, theta: theta)
        }
    }
}

let cp = CPoint.factory.createCartesian(x: 5.0, y: 3.0)
print(cp)



