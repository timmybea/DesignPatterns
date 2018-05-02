//
//  main.swift
//  LiskovSubstitution
//
//  Created by Tim Beals on 2018-02-07.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

//Liskov Substitution Principle
//You should always be able to substitute a base-type for a sub-type

class Rectangle: CustomStringConvertible {
    
    //NOTICE that the get and set keywords means that the value is NOT stored in the variable. Instead the value is stored in a private variable which is prefixed by an underscore.
    fileprivate var _width = 0
    fileprivate var _height = 0
    
    var width: Int {
        get { return _width}
        set(val) { _width = val }
    }
    
    var height: Int {
        get { return _height }
        set(val) { _height = val }
    }
    
    var area: Int {
        return _width * _height
    }
    
    init() {}
    
    init(width: Int, height: Int) {
        _width = width
        _height = height
    }
    
    var description: String {
        return "rectangle: width \(_width), height \(_height)"
    }
}


class Square: Rectangle {
    
    override var width: Int {
        get { return _width }
        set(val) {
            _width = val
            _height = val
        }
    }
    
    override var height: Int {
        get { return _height }
        set(val) {
            _width = val
            _height = val
        }
    }
}

//HERE'S THE IMPORTANT BIT:
//Functions that take base classes should not have their functionality broken when a derived class is passed in.
//This function behaves differently when we pass a square and a rectangle into it. This
//means that it violates the Liskov substitution principle.

func setAndMeasure(rc: Rectangle) {
    rc.width = 4
    rc.height = 3
    print("expected area: 12, \(rc.area)")
}


let rc = Rectangle()
setAndMeasure(rc: rc)

let sq = Square()
setAndMeasure(rc: sq)


//WHAT IS A BETTER WAY?? The major issue with the previous example is that you can pass a square into a rectangle function. Instead of square subclassing from rectangle, you could create a base class called FourSides and have both rectangle and square inherit from it. Then Square will no longer be a subclass of rectangle and you won't be able to accidentally pass a square into a function that has a rectangle in the overload.

//class FourSides {
//
//    var width: Int = 0
//    var height: Int = 0
//
//
//}
//
//
//class Rectangle: FourSides {
//
//    private var _width: Int = 0
//    private var _height: Int = 0
//
//    override var width: Int {
//        get {
//            return _width
//        }
//        set {
//            _width = newValue
//        }
//    }
//
//    override var height: Int {
//        get {
//            return _height
//        }
//        set {
//            _height = newValue
//        }
//    }
//
//    override init() {    }
//    init(width: Int, height: Int) {
//        super.init()
//        self.width = width
//        self.height = height
//    }
//
//}
//
//
//class Square: FourSides {
//
//    private var _sideLength: Int
//
//    override var width: Int {
//        get {
//            return _sideLength
//        }
//        set {
//            _sideLength = newValue
//        }
//    }
//
//    override var height: Int {
//        get {
//            return _sideLength
//        }
//        set {
//            _sideLength = newValue
//        }
//    }
//
//    init(sideLength: Int) {
//        _sideLength = sideLength
//        super.init()
//    }
//}
//
//
//func setAndArea(_ rectangle: Rectangle) -> Int {
//    rectangle.height = 5
//    rectangle.width = 3
//    return rectangle.height * rectangle.width
//}
//
//func setAndArea(_ square: Square) -> Int {
//    square.height = 6
//    return square.height * square.width
//}
//
//
//let r = Rectangle(width: 4, height: 6)
//let s = Square(sideLength: 5)
//
//print(setAndArea(r))
//print(setAndArea(s))

