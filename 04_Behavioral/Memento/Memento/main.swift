//
//  main.swift
//  Memento
//
//  Created by Tim Beals on 2018-03-04.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
 MEMENTO
 Keeps a memento of an objects state in order to return to that state.
 'Command' records the change and can have functionality for undoing itself.
 Another technique it to take a snapshot of the system.
 
 A token/handle representing the system state. Let's us roll back to the state when the token was generated. Usually does not directly expose state information, but it is possible.
 
 */

class BankAccount : CustomStringConvertible {
    
    private var balance: Int
    
    init(balance: Int) {
        self.balance = balance
    }

    func deposit(amt: Int) -> Memento {
        balance += amt
        return Memento(balance: self.balance)
    }
    
    func reset(memento: Memento) {
        self.balance = memento.balance
    }
    
    var description: String {
        return "Bank account balance: \(self.balance)"
    }
}


class Memento { //Doesn't have any functionality but simply stores the values necessary to reset
    
    let balance: Int //note that the constant (let) makes the memento a snap shot.
    
    init(balance: Int) {
        self.balance = balance
    }
}

var ba = BankAccount(balance: 50)
let m1 = ba.deposit(amt: 100)
let m2 = ba.deposit(amt: 25)

//print(ba)


//restore account to memento 1
ba.reset(memento: m1)

//print(ba)


//Undo and Redo functionality

class UndoBankAccount : CustomStringConvertible {
    
    private var balance: Int
    private var changes = [Memento]()
    private var current = 0
    
    init(balance: Int) {
        self.balance = balance
        let m = Memento(balance: self.balance)
        changes.append(m)
    }
    
    func deposit(amt: Int) -> Memento {
        balance += amt
        let m = Memento(balance: self.balance)
        changes.append(m)
        current += 1
        return m
    }
    
    func restore(memento: Memento?) {
        
        if let m = memento {
            self.balance = m.balance
            changes.append(m)
            current = changes.count - 1
        }
    }

    func undo() -> Memento? {
        if current > 0 {
            current -= 1
            let m = changes[current]
            self.balance = m.balance
            return m
        }
        return nil
    }
    
    func redo() -> Memento? {
        if current + 1 < changes.count {
            current += 1
            let m = changes[current]
            self.balance = m.balance
            return m
        }
        return nil
    }
    
    
    var description: String {
        return "Bank account balance: \(self.balance)"
    }
}

let newAccount = UndoBankAccount(balance: 50)

_ = newAccount.deposit(amt: 50)

print(newAccount)

_ = newAccount.undo()

print(newAccount)

_ = newAccount.redo()

print(newAccount)

