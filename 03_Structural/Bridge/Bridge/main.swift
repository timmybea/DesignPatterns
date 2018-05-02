//
//  main.swift
//  Bridge
//
//  Created by Tim Beals on 2018-02-16.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
 Bridge
 A mechanism that decouples an interface (hierarchy) from an implementation (hierarchy)
 It does this with a combination of inheritance and 'aggregation' (holding references to other components)

 Rationale:
 Prevents 'Cartesian product' complexity explosion
 
 example:
 Base class is 'ThreadScheduler TS'. It can work for both Windows and Unix. It can be both preemptive and cooperative.
 so we need to build 4 classes:
 WindowsPTS, UnixPTS, WindowCTS, UnixCTS
 Bridge pattern helps to avoid this entity explosion.
 */


protocol Renderer {
    
    func renderCircle(_ radius: Float)
}

class VectorRenderer: Renderer {
    
    func renderCircle(_ radius: Float) {
        print("rendering circle with radius \(radius) from vectors.")
    }
}


class RasterRenderer: Renderer {
    
    func renderCircle(_ radius: Float) {
        print("rendering circle with radius \(radius) from pixels.")
    }
    
}


protocol Shape {
    func draw()
    func resize(_ factor: Float)
}

class Circle: Shape {
    
    var radius: Float
    var renderer: Renderer //This is the bridge. Is this a dependency injection??
    
    init(radius: Float, renderer: Renderer) {
        self.radius = radius
        self.renderer = renderer
    }
    
    //or you could put the renderer as an argument into the draw function
    func draw() {
        renderer.renderCircle(self.radius)
    }
    
    func resize(_ factor: Float) {
        self.radius *= factor
    }
}

let rr = RasterRenderer()
let vr = VectorRenderer()
let c = Circle(radius: 4.0, renderer: rr)

c.draw()




