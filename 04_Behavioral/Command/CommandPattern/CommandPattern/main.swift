//
//  main.swift
//  CommandPattern
//
//  Created by Tim Beals on 2018-02-25.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
 CommandPattern
 Encapsulates all of the details of an operation in an object.
 Define instruction for applying the command (call, perform, execute) either in itself or in the object that it is being applied to.
 Optionally you can define the steps for 'undoing' the command.
 Create composite commands (sequences of commands) known as macros
 
 Motivation:
 There is no tracking of your operations. You might change the value of something but have no record of what that change was or what the previous value was.
 Ordinary statements are perishable - eg: cannot undo a property assignment.
 Cannot directly serialize a sequence of actions (calls)
 We want an audit trail to roll back changes, so we want an object that represents an operation (suitable for GUI commands, multi-level undo/redo, macro recording and others....
 
 */


class BankAccount : CustomStringConvertible {
    
    private var balance = 0
    private let overdraftLimit = -500
    
    func deposit(_ amt: Int) {
        balance += amt
        print("deposit \(amt), balance is now \(balance)")
    }
    
    func withdraw(_ amt: Int) -> Bool {
        if (balance - amt >= overdraftLimit) {
            balance -= amt
            print("Withdraw \(amt), balance is now: \(balance)")
            return true
        }
        return false
    }
    
    var description: String {
        return "Account with balance: \(balance) and overdraft: \(overdraftLimit)"
    }
}

//Instead of calling deposit and withdraw directly, we are going to do it through the command object
protocol Command {
    func call()
    func undo()
}

class BankAccountCommand : Command {
    
    private var account : BankAccount
    
    enum Action {
        case deposit
        case withdraw
    }
    
    private var action: Action
    private var amount: Int
    private var succeeded: Bool = false
    
    init(account: BankAccount, action: Action, amount: Int) {
        self.account = account
        self.action = action
        self.amount = amount
    }
    
    func call() {
        switch action {
        case .deposit:
            account.deposit(amount)
            succeeded = true
        case .withdraw:
            succeeded = account.withdraw(amount)
        }
    }
    
    func undo() {
        if !succeeded { return }
        
        switch action {
        case .deposit:
            _ = account.withdraw(amount)
        case .withdraw:
            account.deposit(amount)
        }
    }
}


let ba = BankAccount()

//The point is that these commands are able to be stored and audited for roll back...
let commands = [
    BankAccountCommand(account: ba, action: .deposit, amount: 100),
    BankAccountCommand(account: ba, action: .withdraw, amount: 60),
    BankAccountCommand(account: ba, action: .withdraw, amount: 50)
]

print(ba)

commands.forEach() { $0.call() }

print(ba)

//UNDO OPERATIONS

commands.reversed().forEach() { $0.undo() }

print(ba)






//Another variation sees the command being passed to the account which then processes the command. This makes the command more reusable, you could pass the same command to a number of accounts (HOWEVER!) without one object holding reference to the other, you cannot undo the action.

/*
class Command
{
    enum Action
    {
        case deposit
        case withdraw
    }
    
    var action: Action
    var amount: Int
    var success = false
    
    init(_ action: Action, _ amount: Int)
    {
        self.action = action
        self.amount = amount
    }
}

class Account
{
    var balance = 0
    
    func process(_ c: Command)
    {
        switch c.action {
        case .deposit:
            deposit(c.amount)
            c.success = true
        case .withdraw:
            c.success = withdraw(c.amount)
        }
    }
    
    func deposit(_ amount: Int) {
        self.balance += amount
    }
    
    func withdraw(_ amount: Int) -> Bool {
        if balance >= amount {
            balance -= amount
            return true
        } else {
            return false
        }
    }
}
 
 */
