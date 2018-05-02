//
//  Journal.swift
//  SingleResponsibility
//
//  Created by Tim Beals on 2018-02-05.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

class Journal: CustomStringConvertible {
    
    var entries = [String]()
    var count = 0
    
    func addEntry(_ text: String) -> Int {
        count += 1
        entries.append("\(count): \(text)")
        return count - 1
    }
    
    func removeEntry(_ index: Int) {
        entries.remove(at: index)
        count -= 1
    }
    
    var description: String {
        return self.entries.joined(separator: "\n")
    }
    
    //This functionality breaks the single responsibility principle which specifies that a class should have a single reason to CHANGE. You have to now modify the class if:
    //1. you want to change how you store your journal entries OR
    //2. you want to change how you persist data
    
//    func save(to file: String, override: Bool = false ) {
//        //functionality for save
//    }
//
//    func load(file: String) {
//        //functionality for load
//    }
}
