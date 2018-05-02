//
//  main.swift
//  AdapterCaching
//
//  Created by Tim Beals on 2018-02-16.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

//ADAPTER CACHING
//When we execute the draw function twice, we are generating lots of temporary data. It's a waste of computational resources and memory.

/* How to:
 1. create hash values and == operation for points and lines
 2. In the adapter: create static cache as type dictionary and store the array of points for each line as the value and the hash value for each line as the key.
*/


//adopt hashable
class Point: CustomStringConvertible, Hashable
{
    var x, y: Int
    
    init(x: Int, y: Int)
    {
        self.x = x
        self.y = y
    }
    
    //CustomStringConvertible
    var description: String {
        return "(\(x), \(y))"
    }
    
    //Hashable: Create an algorithm that generates a sufficiently unique number
    var hashValue: Int {
        return (x * 397) ^ y
    }

    static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

class Line: CustomStringConvertible, Hashable
{
    var start, end: Point
    
    init(s: Point, e: Point)
    {
        self.start = s
        self.end = e
    }
    
    var description: String {
        return "line from \(start) to \(end)"
    }
    
    var hashValue: Int {
        return (start.hashValue * 397) ^ end.hashValue
    }
    
    static func ==(lhs: Line, rhs: Line) -> Bool {
        return lhs.start == rhs.start && lhs.end == rhs.end
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
    
    //var points = [Point]()
    
    static var cache = [Int: [Point]]()
    var hash: Int
    
    init(line: Line) {
        type(of: self).count += 1 // Track how many instances of your class have been made.
        
        hash = line.hashValue
        if type(of: self).cache[hash] != nil { return }
        
        print("\(type(of: self).count): Generating points of line ", "[\(line.start.x), \(line.start.y)]-[\(line.end.x), \(line.end.y)]")
        
        let left = Swift.min(line.start.x, line.end.x)
        let right = Swift.max(line.start.x, line.end.x)
        let top = Swift.min(line.start.y, line.end.y)
        let bottom = Swift.max(line.start.y, line.end.y)
        let dx = right - left
        let dy = bottom - top // line.end.y - line.start.y
        
        var points = [Point]()
        
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
        type(of: self).cache[hash] = points
    }
    
    func makeIterator() -> IndexingIterator<Array<Point>> {
        let points = type(of: self).cache[hash]
        return IndexingIterator(_elements: points!)
    }
}


//Now we can use the adapter in a draw function
func draw() {
    for vo in vectorObjects {
        for line in vo.lines {
            let adapter = LineToPointAdapter(line: line)
            adapter.forEach() { drawPoint($0) } //can do this because of the iterator
            print("\n")
        }
    }
}

draw()
draw()

/*
 Notice in the print out, that we only generate each line once and the second time we draw() we are pulling those points out of the array.
  
1: Generating points of line  [1, 1]-[11, 1]
...........

2: Generating points of line  [11, 1]-[11, 6]
......

3: Generating points of line  [11, 6]-[1, 6]
...........

4: Generating points of line  [1, 6]-[1, 1]
......

5: Generating points of line  [3, 3]-[9, 3]
.......

6: Generating points of line  [9, 3]-[9, 9]
.......

7: Generating points of line  [9, 9]-[3, 9]
.......

8: Generating points of line  [3, 9]-[3, 3]
.......

...........

......

...........

......
*/





