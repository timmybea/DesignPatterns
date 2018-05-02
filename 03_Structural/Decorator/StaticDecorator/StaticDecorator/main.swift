//
//  main.swift
//  StaticDecorator
//
//  Created by Tim Beals on 2018-02-19.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

protocol Shape : CustomStringConvertible {
    init()
    var description: String { get }
}

class Circle : Shape {
    
    private var radius: Float = 0
    
    required init() { }
    init(radius: Float) {
        self.radius = radius
    }
    
    func resize(factor: Float) {
        radius *= factor
    }
    var description: String {
        return "A circle of radius \(radius)"
    }
}


class Square: Shape {
    
    private var side: Float = 0
    
    required init() { }
    init(side: Float) {
        self.side = side
    }
    
    var description: String {
        return "A square with side \(side)"
    }
}

//we want to be able to add additional traits to our original class.
//To do this we will use static decorators. We specify the shape as a generic argument

class ColoredShape<T> : Shape where T : Shape {

    private var color: String = "black"
    private var shape: T = T() // eg: could be square or circle

    required init() { }
    init(color: String) {
        self.color = color
    }
    
    var description: String {
        return "\(shape) and colored \(color)"
    }
}

class TransparentShape<T> : Shape where T : Shape {
    
    private var shape: T = T()
    private var alpha: Float = 0.0
    
    required init() { }
    init(alpha: Float) {
        self.alpha = alpha
    }
    
    var description: String {
        return "\(shape) with alpha \(alpha)"
    }
}

let redCircle = ColoredShape<Circle>(color: "red")
print(redCircle)


let blackHalfSquare = TransparentShape<ColoredShape<Square>>(alpha: 0.50)
print(blackHalfSquare)

//You will notice that we can not specify the color or the side length as there is  no support for constructor forwarding (something that is possible in C++). We can however provide those values after initialization.
//Static approach is less flexible as you don't aren't able to pass in constructor arguments. It is a compile time only choice (can not be constructed at runtime.)



