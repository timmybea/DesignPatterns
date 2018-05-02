//
//  main.swift
//  BrokerChain
//
//  Created by Tim Beals on 2018-02-25.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
 Industry strength approach: Chain of Responsibility, Observer Pattern, Mediator
 */

protocol Invocable : class {
    func invoke(_ data: Any)
}

public protocol Disposable {
    func dispose()
}

//Event realizes the observer pattern: Allows us to get notifications that something is happening in the system.

public class Event<T>
{
    public typealias EventHandler = (T) -> ()
    
    var eventHandlers = [Invocable]()
    
    public func raise(_ data: T)
    {
        for handler in self.eventHandlers
        {
            handler.invoke(data)
        }
    }
    
    public func addHandler<U: AnyObject>
        (target: U, handler: @escaping (U) -> EventHandler) -> Disposable
    {
        let subscription = Subscription(target: target, handler: handler, event: self)
        eventHandlers.append(subscription) // append as invokable
        return subscription // return as disposable
    }
}

class Subscription<T: AnyObject, U> : Invocable, Disposable
{
    weak var target: T?
    let handler: (T) -> (U) -> () //T: Creature Modifier U: Query
    let event: Event<U>
    
    init(target: T?, handler: @escaping (T) -> (U) -> (), event: Event<U>)
    {
        self.target = target
        self.handler = handler
        self.event = event
    }
    
    func invoke(_ data: Any) {
        if let t = target {
            handler(t)(data as! U) // handler -> hanle() (t -> creature modifier) (data -> query)
        }
    }
    
    func dispose()
    {
        event.eventHandlers = event.eventHandlers.filter { $0 as AnyObject? !== self }
    }
}

//END OF SETUP

//Command Query Separation (CQS) class
class Query {
    
    var creatureName: String
    
    enum Argument {
        case attack
        case defense
    }
    
    var whatToQuery: Argument
    
    var value: Int // This is the attack or defense value
    
    init(n: String, q: Argument, v: Int) {
        self.creatureName = n
        self.whatToQuery = q
        self.value = v
        //v is the baseline value that the creature starts with
    }
}

//A mediator class that all of the parts of the system are going to communicate through. It will be referenced by every single object.

class Game {

    //query gets sent to every object that is subscribed to the event. All will get a chance to modify it. This is how we will get the creature modifiers.
    let queries = Event<Query>() //One event is an array of 'invocable'
    
    func performQuery(_ q: Query) {
        queries.raise(q)
    }
    
}

class Creature : CustomStringConvertible {
    var name: String
    private let _attack: Int
    private let _defense: Int
    private let game: Game // every object holds a reference to the game
    
    init(n: String, a: Int, d: Int, g: Game) {
        self.name = n
        self._attack = a
        self._defense = d
        self.game = g
    }
    
    //computed properties for attack and defense using the 'broker'
    var attack: Int {
        get {
            let q = Query(n: self.name, q: .attack, v: self._attack)
            game.performQuery(q)
            return q.value
        }
    }
    
    var defense: Int {
        get {
            let q = Query(n: self.name, q: .defense, v: self._defense)
            game.performQuery(q)
            return q.value
        }
    }
    
    var description: String {
        return "n: \(name) a:\(attack) d:\(defense)"
    }
}

//Creature Modifiers is a base class that all specific modifiers will subclass. It provides a subscription to the event that is 'advertised' by games
class CreatureModifier : Disposable {
    
    let game: Game
    let creature: Creature
    var event: Disposable? = nil // this is the subscription to the queries event inside game
    
    init(g: Game, c: Creature) {
        self.game = g
        self.creature = c
        self.event = self.game.queries.addHandler(target: self, handler: CreatureModifier.handle) // this passes subscription (: disposable)
    }
    
    func handle(q: Query) {    } // we will override this method in our subclasses
    
    func dispose() {
         event?.dispose()
    }
}


class DoubleAttackModifier : CreatureModifier {
    
    override func handle(q: Query) {
        if q.creatureName == creature.name
            && q.whatToQuery == .attack {
            q.value *= 2
        }
    }
    
}

class IncreaseDefenseModifier : CreatureModifier {
    
    override func handle(q: Query) {
        if q.creatureName == creature.name
            && q.whatToQuery == .defense {
            q.value += 2
        }
    }
}

//MAIN

let game = Game()

let goblin = Creature(n: "Strong Goblin", a: 3, d: 3, g: game)
print("baseline goblin: \(goblin)")

let dam = DoubleAttackModifier(g: game, c: goblin)
//let _ = DoubleAttackModifier(g: game, c: goblin) SPECIAL NOTE: If you try to do this, then Swift compiler will use ARC (Automatic Reference Counting) and destroy the object.

print("goblin with 2x attack")
print("goblin now: \(goblin)")
//when you call describe on CustomStringConvertible you access it's attack and defense parameters which invokes game.performQuery. This sets of the chain: Event<Query> which checks each of its event handlers (Subscription) and performs its invoke method (Creature Modifier .handle())

//let idm = IncreaseDefenseModifier(g: game, c: goblin)


//The modifiers are disposible. You allow us to stop handling this modifier.
dam.dispose()
print("goblin now: \(goblin)")
