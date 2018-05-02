//
//  main.swift
//  TemplateMethod
//
//  Created by Tim Beals on 2018-03-07.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
 TEMPLATE METHOD
 Allows us to define the 'skeleton' of the algorithm with concrete implementation defined in the subclasses
 
 A high level blueprint for an algorithm to be completed by inheritors
 
 Algorithms can be decomposed into common parts and specifics. Strategy pattern does this through composition.
 High-level algorithm uses an interface
 concreate implementations implement the interface.
 
 Template method does the same thing but using inheritance. Algorithm makes use of abstract member
 Inheritors override the abstract members
 Parent template method invoked.
 
 */

//describe the algorithm at a relatively high level, but leave the details to the implementor that inherits from the base class

//HERE IS THE BASECLASS IMPLEMENTATION

class Game {
    
    func run() {
        start()
        
        while !haveWinner {
            takeTurn()
        }
        print("Player \(winningPlayer) wins!")
    }
    
    //preconditions are important because they can stop the forward progress of the method. We don't want the client to call methods on this base class.
    internal func start() {
        precondition(false, "start() needs to be overridden.")
    }
    
    internal func takeTurn() {
        precondition(false, "takeTurn() needs to be overridden.")
    }
    
    internal var winningPlayer: Int {
        get {
            precondition(false, "winningPlayer needs to be overridden.")
        }
    }
    
    internal var haveWinner: Bool {
        get {
            precondition(false, "haveWinner needs to be overridden.")
        }
    }
    
    internal var currentPlayer = 0
    internal let numberOfPlayers: Int
    
    init(_ numberOfPlayers: Int) {
        self.numberOfPlayers = numberOfPlayers
    }
}


class Chess : Game {

    //this is just for simulation purposes
    private let maxTurns = 10
    private var turn = 1
    
    init() {
        super.init(2)
    }
    

    override var haveWinner: Bool {
        return turn == maxTurns
    }
    
    override func start() {
        print("starting a game with \(numberOfPlayers) players")
    }
    
    override func takeTurn() {
        print("turn taken by player \(currentPlayer)")
        turn += 1
        currentPlayer = (currentPlayer + 1) % numberOfPlayers
    }

    override var winningPlayer: Int {
        return currentPlayer
    }
}

let chess = Chess()
chess.run()


//


class Creature
{
    public var attack, health: Int
    
    init(_ attack: Int, _ health: Int)
    {
        self.attack = attack
        self.health = health
    }
}

class CardGame
{
    var creatures: [Creature]
    
    init(_ creatures: [Creature])
    {
        self.creatures = creatures
    }
    
    func combat(_ creature1: Int, _ creature2: Int) -> Int
    {
        guard creature1 < creatures.count && creature2 < creatures.count else { return -1 }
        
        let c1 = creatures[creature1]
        let c2 = creatures[creature2]
        
        hit(c1, c2)
        hit(c2, c1)
        
        let alive1 = c1.health > 0
        let alive2 = c2.health > 0
        
        if alive1 == alive2 { //no clear winner
            return -1
        }
        
        return alive1 ? creature1 : creature2
    }
    
    internal func hit(_ attacker: Creature, _ other: Creature)
    {
        precondition(false, "this method needs to be overridden")
    }
}

class TemporaryCardDamageGame : CardGame
{
    override func hit(_ attacker: Creature, _ other: Creature)
    {
        let cachedHealth = other.health
        other.health -= attacker.attack
        if other.health > 0 {
            other.health = cachedHealth
        }
    }
}

class PermanentCardDamage : CardGame
{
    override func hit(_ attacker: Creature, _ other: Creature)
    {
        other.health -= attacker.attack
    }
}




