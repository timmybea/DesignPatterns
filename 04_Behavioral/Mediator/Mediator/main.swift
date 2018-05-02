//
//  main.swift
//  Mediator
//
//  Created by Tim Beals on 2018-03-02.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
 Facilitates communication between components
 Components may go in and out of a system at any time and it makaes no sense to have them hold references to one another.
 The solution is to have all of these components hold reference to a central object that facilitates communication.
 Mediator has bi-directional communication with its components. Components call methods on the mediator (send) and mediator calls methods on the components (receive)
 */


//Chat room: In this example the chat room holds reference to all of the people who can come and go as they wish. The methods that send messages in each person, in turn calls the broadcast or message method in the chat room.

class Person {
    var name: String
    var room: ChatRoom? = nil
    private var chatLog = [String]()
    
    init(name: String) {
        self.name = name
    }
    
    func receive(sender: String, message: String) {
        let s = "\(sender): `\(message)`"
        print("[\(name)'s chat session] \(s)")
        chatLog.append(s)
    }
    
    func say(message: String) {
        room?.broadcast(sender: self.name, message: message)
    }
    
    func pm(to target: String, message: String) {
        room?.message(sender: self.name, recipient: target, message: message)
    }
}

class ChatRoom {
    
    private var people = [Person]()
    
    func broadcast(sender: String, message: String) {
        for p in people {
            if p.name != sender {
                p.receive(sender: sender, message: message)
            }
        }
    }
    
    func join(person: Person) {
        let msg = "\(person.name) has joined the chat"
        broadcast(sender: "room", message: msg)
        person.room = self
        people.append(person)
    }
    
    func message(sender: String, recipient: String, message: String) {
        people.first { $0.name == recipient }?.receive(sender: sender, message: message)
    }
}

let chatRoom = ChatRoom()
let john = Person(name: "John")
let mary = Person(name: "Mary")
let peter = Person(name: "Peter")

chatRoom.join(person: john)
chatRoom.join(person: mary)

mary.say(message: "Hi everyone")
john.say(message: "Hello to you too")








