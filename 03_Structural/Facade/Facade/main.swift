//
//  main.swift
//  Facade
//
//  Created by Tim Beals on 2018-02-19.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
 Facade
 Presents an easy to use interface over a large and sophisticated body of code. May provide default values in order to get a basic tool operational. May or may not expose the lower level modules to allow 'power users' to escalate customize the functionality further (case by case)
 
 
 The black box analogy. The end user doesn't necessarily want to know all the ins and outs about how something works. They simply want to push a button that makes it work. The end user doesn't need to be exposed to all of the internals.

 
 */

class Buffer {
    var width: Int
    var height: Int
    
    var buffer: [Character]

    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        buffer = [Character].init(repeating: " ", count: width*height)
    }
    
    subscript(_ index: Int) -> Character {
        return buffer[index]
    }
}

class ViewPort {
    var buffer: Buffer
    var offset = 0
    init(buffer: Buffer) {
        self.buffer = buffer
    }
    
    func getChar(at index: Int) -> Character {
        return self.buffer[offset + index]
    }
}

//These classes are modeling a command line, where the buffer is the space to insert text and the view port presents that text. Clearly, these are both very low level modules that the end user probably doesn't want to deal with (especially if they want to have only a typical single view port setup)


//THIS IS THE FACADE
class Console {
    
    //We still have the low-level modules exposed so that the user can customize the systems internals if they are a 'power user'
    
    var buffers = [Buffer]()
    var viewPorts = [ViewPort]()
    var offset = 0
    
    init() {
        let b = Buffer(width: 30, height: 20)
        let vp = ViewPort(buffer: b)
        buffers.append(b)
        viewPorts.append(vp)
    }
    
    func getCharacters(at index: Int) -> Character {
        return viewPorts[0].getChar(at: index)
    }
}

let c = Console()
c.getCharacters(at: 5)

//So notice that with one simple init call, the user now has a default tool with a working viewport and buffer. There is no setup, and the basic functionality is available without the user having to interact with the low level modules.




