//
//  main.swift
//  DynamicDecorator
//
//  Created by Tim Beals on 2018-02-19.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

protocol Shape : CustomStringConvertible {
    var description: String { get }
}

class Circle : Shape {
    
    private var radius: Float = 0
    
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
    
    init(side: Float) {
        self.side = side
    }
    
    var description: String {
        return "A square with side \(side)"
    }
}


let s = Square(side: 1.23)
print(s)

//we want to be able to add additional traits to our original class.
//To do this we will use dynamic decorators.

class ColoredShape : Shape {
    
    var shape: Shape
    var color: String
    
    //This is called 'dynamic initialization'
    init(shape: Shape, color: String) {
        self.shape = shape
        self.color = color
    }
    
    var description: String {
        return "\(shape) and colored \(color)"
    }
}

class TransparentShape : Shape {
    
    private var shape: Shape
    private var alpha: Float
    
    
    init(shape: Shape, alpha: Float) {
        self.shape = shape
        self.alpha = alpha
    }
    
    var description: String {
        return "\(shape) with alpha \(alpha)"
    }
}

let redCircle = ColoredShape(shape: Circle(radius: 1.6), color: "red")
print(redCircle)



let greenSemiTransparentSquare = TransparentShape(shape: ColoredShape(shape: Square(side: 3.6), color: "Green"),
                                                  alpha: 0.5)
print(greenSemiTransparentSquare)
