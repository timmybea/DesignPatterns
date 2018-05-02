//
//  main.swift
//  PropertyObservers
//
//  Created by Tim Beals on 2018-03-06.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

//MARK: START OBSERVER CODE
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
    
    func dispose() {
        event.eventHandlers = event.eventHandlers.filter() { $0 as AnyObject? !== self }
    }
}
//MARK: END OBSERVER CODE


//Handling dependent observable properties: We want to notify observers when canVote changes. The problem is that canVote is a computed property and it doesn't change every time age changes.

class Person {

    private var _oldCanVote = false
    
    var age: Int = 0 {
        willSet {
            _oldCanVote = canVote
        }
        didSet {
            if oldValue != age {
                propertyChanged.raise(("age", age))
            }
            if _oldCanVote != canVote {
                propertyChanged.raise(("canVote", canVote))
            }
        }
    }
    
    let propertyChanged = Event<(String, Any)>() // the name of the property and the value that has been assigned

//    var canVote: Bool {
//        return age >= 18
//    }

    var canVote: Bool {
        return age >= 18
    }

}

class Narrator {
    
    var subscriptions = [Disposable]()
    
    func handlePersonChange(_ args: (String, Any)) {
        switch args.0 {
        case "age":
            ageChanged(args.1 as! Int)
        case "canVote":
            voteChanged(args.1 as! Bool)
        default:
            print("unknown change")
        }
    }
    
    private func voteChanged(_ data: Bool) {
        if data {
            print("Congratulations! You can vote")
        } else {
            print("You will be able to vote when you are older")
        }
    }
    
    private func ageChanged(_ data: Int) {
        print("Happy birthday! You are now, \(data)")
    }
    
}


//let n = Narrator()
//let p = Person()
//let sub = p.propertyChanged.addHandler(target: n, handler: Narrator.handlePersonChange)
//
//p.age = 14
//p.age = 15
//p.age = 18
//
//sub.dispose()

//This works fine, but there is another approach that doesn't use property observers at all. Instead we can use a computed property

//A reference wrapper for the bool type.
final class RefBool {
    var value: Bool
    
    init(_ v: Bool) {
        self.value = v
    }
}


class Person2 {
    
    let propertyChanging = Event<(String, Any, RefBool)>() //like willSet
    let propertyChanged = Event<(String, Any)>() //like didSet
    
    private var _age = 0
    
    var age: Int {
        get { return _age }
        set(value) {
            if value == _age { return } //no change
            
            //cache properties dependent on age
            let oldCanVote = canVote
            
            //Allow other parts of the system to cancel our set.
            let cancelSet = RefBool(false)
            propertyChanging.raise(("age", value, cancelSet))
            if cancelSet.value { //one of the observers cancelled the set.
                return
            } else {
                _age = value
                propertyChanged.raise(("age", _age))
                
                if oldCanVote != canVote {
                    propertyChanged.raise(("canVote", canVote))
                }
            }
        }
    }
    
    var canVote: Bool {
        return _age >= 18
    }
}


class OtherSystem {
    
    func handlePersonAgeChanging(_ args: (String, Any, RefBool)) {
        if args.0 == "age", args.1 as! Int == 20 {
            args.2.value = true
        }
    }
}

class Responder {
    
    func respondToAge(_ args: (String, Any)) {
        if args.0 == "age" {
            if let n = args.1 as? Int {
                print("Person age changed to \(n)")
            }
        }
    }
    
    func respondToCanVote(_ args: (String, Any)) {
        if args.0 == "canVote" {
            if let bool = args.1 as? Bool {
                print("Person voting status changed to \(bool)")
            }
        }
    }
}


let other = OtherSystem()
let responder = Responder()
let p2 = Person2()
let sub1 = p2.propertyChanging.addHandler(target: other, handler: OtherSystem.handlePersonAgeChanging)


//or instead of subscribing twice, you could have one method in responder that determines what  kind of notification it is.
let sub2 = p2.propertyChanged.addHandler(target: responder, handler: Responder.respondToCanVote)
let sub3 = p2.propertyChanged.addHandler(target: responder, handler: Responder.respondToAge)

p2.age = 14
p2.age = 20 //does not change! gets cancelled by other system
p2.age = 21


