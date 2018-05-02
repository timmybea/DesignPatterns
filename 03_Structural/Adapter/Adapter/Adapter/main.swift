//
//  main.swift
//  Adapter
//
//  Created by Tim Beals on 2018-02-15.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

//ADAPTER
//Adapts an existing interface X to conform to the required interface Y
//Think of adapter as plug adapter for an electrical device that allows you to use the device in different places.

//VECTOR/RASTER demo

class Point: CustomStringConvertible
{
    var x, y: Int
    
    init(x: Int, y: Int)
    {
        self.x = x
        self.y = y
    }
    
    var description: String {
        return "(\(x), \(y))"
    }
}

class Line
{
    var start, end: Point
    
    init(s: Point, e: Point)
    {
        self.start = s
        self.end = e
    }
}

class VectorObject: Sequence
{
    var lines = [Line]()
    
    //Sequence protocol method
    func makeIterator() -> IndexingIterator<Array<Line>>
    {
        return IndexingIterator(_elements: lines)
    }
}


class RectangleVector: VectorObject
{
    var x: Int
    var y: Int
    var width: Int
    var height: Int
    
    init(x: Int, y: Int, width: Int, height: Int)
    {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        
        super.init()

        lines.append(Line(s: Point(x: x, y: y), e: Point(x: x + width, y: y)))
        lines.append(Line(s: Point(x: x + width, y: y), e: Point(x: x + width, y: y + height)))
        lines.append(Line(s: Point(x: x + width, y: y + height), e: Point(x: x, y: y + height)))
        lines.append(Line(s: Point(x: x, y: y + height), e: Point(x: x, y: y)))
    }
}


//NOW WE NEED AN ADAPTER TO BE ABLE TO FORM LINES FROM AN API THAT ONLY PROVIDES POINTS... This is what we have:

func drawPoint(_ p: Point)
{
    print(".", terminator: "")
}

//pretty shit.



let vectorObjects: [VectorObject] = [
    RectangleVector(x: 1, y: 1, width: 10, height: 5),
    RectangleVector(x: 3, y: 3, width: 6, height: 6)
]

//Here is the adapter
class LineToPointAdapter: Sequence
{
    private static var count = 0

    var points = [Point]()
    
    init(line: Line) {
        type(of: self).count += 1 // Track how many instances of your class have been made.
        
        print("\(type(of: self).count): Generating points of line ", "[\(line.start.x), \(line.start.y)]-[\(line.end.x), \(line.end.y)]")
        
        let left = Swift.min(line.start.x, line.end.x)
        let right = Swift.max(line.start.x, line.end.x)
        let top = Swift.min(line.start.y, line.end.y)
        let bottom = Swift.max(line.start.y, line.end.y)
        let dx = right - left
        let dy = bottom - top // line.end.y - line.start.y
        
        if dx == 0 {
            for y in top...bottom {
                //vertical line
                points.append(Point(x: left, y: y))
            }
        } else if dy == 0 {
            for x in left...right {
                //horizontal line
                points.append(Point(x: x, y: bottom))
            }
        }
    }
    
    func makeIterator() -> IndexingIterator<Array<Point>> {
        return IndexingIterator(_elements: self.points)
    }
}


//Now we can use the adapter in a draw function
func draw() {
    for vo in vectorObjects {
        for line in vo.lines {
            let adapter = LineToPointAdapter(line: line)
            adapter.forEach() { drawPoint($0) } //can do this because of the iterator
        }
    }
}

draw()
