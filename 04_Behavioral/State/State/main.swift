//
//  main.swift
//  State
//
//  Created by Tim Beals on 2018-03-06.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
 A pattern in which the object's behavior is determined by its state. An object transitions from one state to another when it is triggered. A formalized construct that manages state and construction is called a State Machine.
 
 eg: the behavior of a phone depends on it's state on the hook/ off the hook/ engaged/
 */

//provide states and triggers
enum State {
    case offHook
    case connecting
    case connected
    case onHold
}

enum Trigger {
    case callDialed
    case hungUp
    case leftMessage
    case placedOnHold
    case takenOffHold
    case callConnected
}

//THIS IS THE STATE MACHINE: Now you can create a dictionary that outlines the actions which are available for each state and the resulting state of those actions.

let rules = [
    State.offHook : [
        (Trigger.callDialed, State.connecting)
    ],
    State.connecting : [
        (Trigger.callConnected, State.connected),
        (Trigger.hungUp, State.offHook)
    ],
    State.connected : [
        (Trigger.placedOnHold, State.onHold),
        (Trigger.leftMessage, State.offHook),
        (Trigger.hungUp, State.offHook)
    ],
    State.onHold : [
        (Trigger.takenOffHold, State.connected),
        (Trigger.hungUp, State.offHook)
    ]
]

var state = State.offHook

while true {
    print("The phone is currently \(state)")
    print("Select next action (trigger):")
    
    for i in 0..<rules[state]!.count {
        let (t, _) = rules[state]![i] //get the trigger for the state
        print("\(i): \(t)")
    }
    
    if let input = Int(readLine()!) {
        let (_, s) = rules[state]![input]
        state = s
    }
}


//Here is an example of a state pattern within a class. The states are indicated by string so it is less type-safe

class CombinationLock
{
    var status = ""
    var combination: [Int]
    var inputCount = 0
    var fail = false
    
    init(_ combination: [Int])
    {
        self.combination = combination
        self.status = "LOCKED"
    }
    
    func enterDigit(_ digit: Int)
    {
        if self.status == "LOCKED" { self.status = "" }
        status.append(String(digit))
        if combination[inputCount] != digit { fail = true }
        inputCount += 1
        if combination.count == inputCount {
            status = fail ? "ERROR" : "OPEN"
        }
    }
}
