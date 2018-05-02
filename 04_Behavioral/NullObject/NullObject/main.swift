//
//  main.swift
//  NullObject
//
//  Created by Tim Beals on 2018-03-05.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
 Null Object
 A no-op object that conforms to the required interface satisfying a dependency requirement of some other object.
 
 A behavioral design pattern with no behaviors.
 When component A uses component B, it typically assumes that B is not nil (non-optional). We don't use optional binding to check it and there is no option of telling A not to use B
 Thus, we can build a non-optional, non-functioning inheritor of B and pass it into A
 
 */


//In this example, we have a non-optional log in our BankAccount.
class BankAccount {
    
    var log: Log
    var balance: Int = 0
    
    init(_ log: Log) {
        self.log = log
    }
    
    func deposit(amt: Int) {
        self.balance += amt
        log.info("Deposited: $\(amt), new balance: \(balance)")
    }
}

protocol Log {
    func info(_ msg: String)
    func warn(_ msg: String)
}

class Console : Log {
    
    func info(_ msg: String) {
        print("\(msg)")
    }
    
    func warn(_ msg: String) {
        print("WARNING: \(msg)")
    }
}

let log = Console()
let bankAccount = BankAccount(log)

bankAccount.deposit(amt: 50)

//This works fine, but what if a someone wants to build the bank account and wants NO logging. Notice that the log is a non-optional property.

class NullLog : Log {
    
    func info(_ msg: String) {    }
    func warn(_ msg: String) {    }
}

bankAccount.log = NullLog()

bankAccount.deposit(amt: 25) //Now the deposit does not log.

