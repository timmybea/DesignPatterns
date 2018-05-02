//
//  main.swift
//  Decorator
//
//  Created by Tim Beals on 2018-02-18.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
 Decorator
 
 Adding behaviour without altering the class itself or using inheritance
 
 Do not want to rewrite or alter existing code (breaking the open-closed principle)
 
 Keep new functionality separate
 Need to be able to interact with existing structures
 
 Two options:
 Inherit from the required object (keep in mind some objects are passed by value and others could be marked final!)
 Build a decorator which simple references the decorated objects
 
 “Facilitates the addition of behaviours to an object without inheriting from them."
 
 
 A decorator holds reference to the decorated objects (holds an instance of the type)
 May or may not proxy over calls (use the same calls (functions, operators) as the type it is proxying to)
 Can be dynamic (using init arguments) or static (using generics)
 
 
 
 
 */

/*
 GOAL:
 To build a component that allows us to construct pieces of code as text, but there are a couple of issues:
 1. We don't want protocol extension, because we also want implementation to be stateful (eg: we could store the indentation level to increase and decrease it)
 2. Inheritance from String doesn't work because String passes by value.
 
 This is a simple decorator over a String. It has some of the same functionality of a string: append, appendLine and += but it is working for a stateful class. This is the simplest decorator that we can create.
 */


class CodeBuilder: CustomStringConvertible {
    
    private var buffer: String = ""

    init() {}
    init(buffer: String) {
        self.buffer = buffer
    }
    
    var description: String {
        return buffer
    }

    func append(_ s: String) -> CodeBuilder {
        buffer += s
        return self
    }
    
    func appendLine(_ s: String) -> CodeBuilder {
        buffer += "\(s)\n"
        return self
    }
    
    static func +=(cb: inout CodeBuilder, s: String) {
        cb.buffer.append(s)
    }
}


var cb = CodeBuilder()

cb.appendLine("class Foo")
    .appendLine("{")

cb += "this is my code\n"
cb.appendLine("}")



print(cb)


//MOST COMMONLY we use decorators when we are dealing with Multiple Inheritance. This is not allowed in Swift. In this example we want to have the fly and crawl functionality available in the dragon class.

protocol ICanFly {
    func fly()
}

class Bird: ICanFly {
    func fly() { }
}

protocol ICanCrawl {
    func crawl()
}

class Lizard: ICanCrawl {
    func crawl() { }
}

//class Dragon: Bird, Lizard { } Multiple Inheritance doesn't work!! XXXXX

//You create an aggregate object by having private instances of the types that we want. This is called delegation.

class Dragon {
    
    private let flier: ICanFly = Bird()
    private let crawler: ICanCrawl = Lizard()
    
    func fly() {
        flier.fly() //delegation
    }
    
    func crawl() {
        crawler.crawl()
    }
}

//NOTICE that in both of these examples, he have the decorator class calling a func name 'append' or 'fly' and then the super class 'String' or 'Bird' calling the same method.
