//
//  main.swift
//  Strategy
//
//  Created by Tim Beals on 2018-03-06.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
 Strategy
 Enables the exact behavior of a system to be selected either at runtime (dynamic) or compile-time (static). Also known as Policy (esp in C++)
 
 Many algorithms can break a task into higher and lower level parts in order to reuse them in similar cases. For example a tea making algorithm will be decomposed into some high level functions like boiling and adding water, and then some lower level tea specific functions like adding a tea bag etc. This means that the higher level parts can be used to make other hot beverages like hot chocolate.
 
 */


enum OutputFormat {
    case markdown
    //* one
    //* two
    case html
    //<ul>
    //  <li>one</li>
    //</ul>
}

protocol ListStrategy {
    init()
    func start(_ buffer: inout String)
    func end(_ buffer: inout String)
    func addListItem(buffer: inout String, item: String)
}


//These are the strategies.
class MarkDownListStrategy : ListStrategy {
    
    required init() { }
    
    func start(_ buffer: inout String) { }
    
    func end(_ buffer: inout String) { }
    
    func addListItem(buffer: inout String, item: String) {
        buffer += " * \(item)\n"
    }

}

class HTMLListStrategy : ListStrategy {
    
    required init() { }
    
    func start(_ buffer: inout String) {
        buffer += "<ul>\n"
    }
    
    func end(_ buffer: inout String) {
        buffer += "</ul>\n"
    }
    
    func addListItem(buffer: inout String, item: String) {
        buffer += "  <li>\(item)</li>\n"
    }
}

//DYNAMIC APPROACH
class DynamicTextProcessor: CustomStringConvertible {
    
    private var buffer = ""
    private var listStrategy: ListStrategy = MarkDownListStrategy()
    
    init() { }
    init(_ outputFormat: OutputFormat) {
        self.setOutputFormat(outputFormat)
    }
    
    //This is a dynamic strategy because we can change the strategy after initialization.
    func setOutputFormat(_ outputFormat: OutputFormat) {
        switch outputFormat {
        case .markdown: listStrategy = MarkDownListStrategy()
        case .html: listStrategy = HTMLListStrategy()
        }
    }
    
    func appendList(_ items: [String]) {
        listStrategy.start(&buffer)
        for i in items {
            listStrategy.addListItem(buffer: &buffer, item: i)
        }
        listStrategy.end(&buffer)
    }
    
    var description: String {
        return buffer
    }
}


let t = DynamicTextProcessor()
t.setOutputFormat(.html)
t.appendList(["this", "is", "the", "story", "all", "about", "how..."])
//print(t)


//STATIC APPROACH: If you know that you don't need the strategy to change, this is more efficient because it is being set in compile time as opposed to run-time
class StaticTextProcessor<LS>: CustomStringConvertible where LS: ListStrategy {
    
    private var buffer = ""
    private var listStrategy = LS() //We can do this because we have declared a protocol initializer.
    
    init() { }
    
    func appendList(_ items: [String]) {
        listStrategy.start(&buffer)
        for i in items {
            listStrategy.addListItem(buffer: &buffer, item: i)
        }
        listStrategy.end(&buffer)
    }
    
    var description: String {
        return buffer
    }
}

let s = StaticTextProcessor<MarkDownListStrategy>()
s.appendList(["heeeeey", "yaaaaaa!"])
print(s)
