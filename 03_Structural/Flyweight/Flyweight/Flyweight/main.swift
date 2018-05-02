//
//  main.swift
//  Flyweight
//
//  Created by Tim Beals on 2018-02-19.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
 Flywight
 This is a space optimization design pattern.
 
 Avoid redundancy when storing data.
 Lets us use less memory by storing externally the data associated with similar objects.
 */

//REPEATING USER NAMES EXAMPLE: (MASSIVELY MULTIPLAYER ONLINE GAME - MMORPG)

class User {
    var fullName: String
    
    init(fullName: String) {
        self.fullName = fullName
    }
    
    var charCount: Int {
        return fullName.utf8.count
    }
}
//
//let user1 = User(fullName: "John Smith")
//let user2 = User(fullName: "Jane Smith")
//let user3 = User(fullName: "Jane Doe")
//
////Notice how similar these names are...
//
//let totalCount = user1.charCount + user2.charCount + user3.charCount
//print("The total number of chars used is: \(totalCount)") //28



//The flyweight pattern: if you are going to have data duplication, why not store it efficiently so that you don't repeat the actual elements. This comes at the cost of additional complexity.

class User2 {
    
    static var strings = [String]()
    
    static var charCount: Int {
        return self.strings.map() { $0.utf8.count }.reduce(0, +)
    }
    
    private var names = [Int]()
    
    var fullName: String {
        var output = ""
        self.names.forEach() { output.append("\(type(of: self).strings[$0]) ")}
        return output
    }
    
    init(fullName: String) {
        
        func getOrAdd(s: String) -> Int {
            
            if let idx = type(of: self).strings.index(of: s) {
                return idx
            } else {
                type(of: self).strings.append(s)
                return type(of: self).strings.count - 1
            }
        }
        names = fullName.components(separatedBy: " ").map() { getOrAdd(s: $0) }
    }
}


let user1 = User2(fullName: "John Smith")
let user2 = User2(fullName: "Jane Smith")
let user3 = User2(fullName: "Jane Doe")



print("The total char count is \(User2.charCount)")
print(user2.fullName)



