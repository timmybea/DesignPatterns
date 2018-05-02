//
//  main.swift
//  Composite
//
//  Created by Tim Beals on 2018-02-17.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
 Composite
 Treating individual (scalar) and aggregate (composition) objects uniformly.
 
 Motivation
 Composition lets us make compound objects.
 Composite design pattern is used to treat both single (scalar) and composite objects uniformly.
 
 Provides identical interface for individual objects and groups of objects.
 */


//This class is using the composite design pattern as it can be an object with a name and color, but it can also contain objects of it's own type (and those objects can contain their own objects and so on...)
class GraphicObject: CustomStringConvertible {
    
    var name: String = "Group"
    var color: String = ""
    var children = [GraphicObject]()
    
    init() {}
    init(name: String) {
        self.name = name
    }
    
    private func print(_ buffer: inout String, _ depth: Int) {
        buffer.append(String(repeating: "*", count: depth))
        buffer.append(color.isEmpty ? "" : " \(color) ")
        buffer.append(" \(name)\n")
        
        for child in children {
            child.print(&buffer, depth + 1)
        }
    }
    
    var description: String {
        var buffer = ""
        print(&buffer, 0)
        return buffer
    }
}

class Square : GraphicObject {
    
    init(_ color: String) {
        super.init(name: "Square")
        self.color = color
    }
}

class Circle : GraphicObject {
    
    init(_ color: String) {
        super.init(name: "Circle")
        self.color = color
    }
}



let drawing = GraphicObject(name: "My drawing")

//these are scalar (individual) objects
drawing.children.append(Square("red"))
drawing.children.append(Circle("blue"))

let group = GraphicObject()
group.children.append(Square("green"))
group.children.append(Circle("green"))

//this is an aggregate (grouped) objects
drawing.children.append(group)

print(drawing)


//notice that even though we intend for the square and circle are to be scalar building blocks, we can technically still access their children...



