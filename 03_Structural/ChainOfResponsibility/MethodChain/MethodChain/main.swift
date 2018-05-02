//
//  main.swift
//  MethodChain
//
//  Created by Tim Beals on 2018-02-25.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
 A sequence of handlers processing one event after another.
 A chain of components who all get a chance to process a command or query, optionally having default processing implementation and an ability to terminate the processing chain.
 
 */


//Command Query Separation (CQS): Whenever we operate on objects we sepearate the invocations into two categories: Query and Command.
//Query: Asking for information without necessarily changing anything 'get'
//Command: Asking for a change or an action (eg: change a stored value) 'set'


//Method Chain:

class Creature: CustomStringConvertible {
    
    var name: String
    var attack: Int
    var defense: Int
    
    init(n: String, a: Int, d: Int) {
        self.name = n
        self.attack = a
        self.defense = d
    }
    
    var description: String {
        return "\(name), \(attack), \(defense)"
    }
}

class CreatureModifier {
    
    let creature: Creature
    var next: CreatureModifier?
    
    init(c: Creature) {
        self.creature = c
    }
    
    //notice that this add function chains the creature modifiers
    func add(cm: CreatureModifier) {
        if next != nil {
            next!.add(cm: cm)
        } else {
            self.next = cm
        }
    }
    
    func handle() {
        next?.handle() //This is the execution on the next modifier
    }
}

class DoubleAttackModifier : CreatureModifier {
    
    override func handle() {
        print("Doubling \(creature.name)'s attack")
        creature.attack *= 2
        super.handle() //Now we can perform the operation in an override
    }
}


class IncreaseDefenseModifier : CreatureModifier {
   
    override func handle() {
        print("Increasing \(creature.name)'s defense +3")
        creature.defense += 3
        super.handle()
    }
}

//This class shows how you can break the chain at any point.
class NoBonusesModifier : CreatureModifier {
    
    override func handle() {
        print("You cannot have any bonuses")
        
        //NO SUPER.HANDLE!
    }
    
}

let goblin = Creature(n: "Goblin", a: 2, d: 2)
let  root = CreatureModifier(c: goblin)

print("Double attack added")
root.add(cm: DoubleAttackModifier(c: goblin))
print(goblin)

//print("NO BONUSES!!")
//root.add(cm: NoBonusesModifier(c: goblin))

print("Increase defense added")
root.add(cm: IncreaseDefenseModifier(c: goblin))
print(goblin)

//Notice that none of the values of goblin have actually been performed yet. We are simply adding them to the chain

//Now let's execute the changes.
root.handle()
print(goblin)

