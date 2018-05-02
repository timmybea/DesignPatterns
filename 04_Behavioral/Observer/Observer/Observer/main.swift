//
//  main.swift
//  Observer
//
//  Created by Tim Beals on 2018-03-05.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
 Observer Pattern
 An OBSERVER is an object that wishes to be informed about events happening in the system. The entity generating the events is an OBSERVABLE.
 This is a pattern that is baked into other languages, but not swift. Swift does have property observers.
 */


//: AnyObject means that only classes (not structs) are able to adopt the protocol.
protocol Invocable : AnyObject {
    func invoke(_ data: Any)
}

protocol Disposable {
    func dispose()
}

class Event<T> {
    
    typealias eventHandler = (T) -> ()
    
    var eventHandlers = [Invocable]() //subscribers
    
    func raise(_ data: T) { // get all of the subscribers to do something on an event.
        for handler in eventHandlers {
            handler.invoke(data)
        }
    }
    
    //U -> (T) -> ()
    //U is the type of invoker
    //T is the type of data
    func addHandler<U: AnyObject>(target: U, handler: @escaping(U) -> eventHandler) -> Disposable {
        let s = Subscription(target: target, handler: handler, event: self)
        self.eventHandlers.append(s)
        return s
    }
    
}

class Subscription<T: AnyObject, U> : Invocable, Disposable {

    weak var target: T? //Any invocable type
    let handler: (T) -> (U) -> () // the action we want to take when we are notified
    let event: Event<U>
    
    init(target: T?, handler: @escaping (T) -> (U) -> (), event: Event<U>) {
        self.target = target
        self.handler = handler
        self.event = event
    }
    
    func invoke(_ data: Any) {
        if let t = target {
            handler(t)(data as! U)
        }
    }
    
    // remove ourselves from the handlers
    func dispose() {
        event.eventHandlers = event.eventHandlers.filter() { $0 as AnyObject? !== self }
    }
}

class Person {
    
    let fallsIll = Event<String>()
    
    init() {}
    
    func catchCold(address: String) {
        self.fallsIll.raise(address)
    }
    
}


class Nanny {
    
    var subscription: Disposable?
    
    func callDoctor(address: String) {
        print("We need a doctor at \(address)")
    }
    
}

let p = Person()
let nanny = Nanny()
nanny.subscription = p.fallsIll.addHandler(target: nanny, handler: Nanny.callDoctor)
//Why does this handler require Nanny (type) and then an instance func callDoctor?

p.catchCold(address: "765 Sunrise Avenue")

nanny.subscription?.dispose()

p.catchCold(address: "A different address") //This one should not get called
