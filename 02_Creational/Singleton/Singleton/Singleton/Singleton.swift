//
//  Singleton.swift
//  Singleton
//
//  Created by Tim Beals on 2018-02-14.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

//Dependency Injection
//Instead of passing a class type into another class, have the class conform to a protocol and then pass that into your other class. That way you don't have to depend on a single class. Dependency Injection can be the strategy to meeting the Dependency Inversion Principle.

protocol Database {
    func getPopulation(for capital: String) -> Int?
}

class SingletonDatabase: Database
{
    
    private init()
    {
        type(of: self).instanceCount += 1 // should only ever be one instance.
        
        guard let contents = try? String(contentsOfFile: "Capitals.txt") else { return }
        let lines = contents.components(separatedBy: .newlines)
            .filter() { !$0.isEmpty }
            .map() { $0.trimmingCharacters(in: .whitespaces).lowercased() }
        
        for i in 0..<(lines.count / 2)  //pairs of strings.
        {
            capitals[String(lines[i*2])] = Int(lines[i*2+1])
        }
    }
    
    static let shared = SingletonDatabase()
    
    static var instanceCount = 0
    
    private var capitals = [String: Int]()
    
    func getPopulation(for capital: String) -> Int? {
        let a = capital.trimmingCharacters(in: .whitespaces).lowercased()
        return capitals[a]
    }
    
}


/*
 THIS RELIES ON THE SINGLETON CLASS. INSTEAD USE DEPENDENCY INJECTION
 
class SingletonRecordFinder
{
    func totalPopulation(for cities: [String]) -> Int {
        var pop = 0
        
        for c in cities {
            if let p = SingletonDatabase.shared.getPopulation(for: c) {
                pop += p
            }
        }
        return pop
    }
}
*/

class ConfigurableRecordFinder
{
    private let database: Database
    
    init(_ database: Database) {
        self.database = database
    }
    
    func totalPopulation(for cities: [String]) -> Int {
        var pop = 0
        
        for c in cities {
            if let p = self.database.getPopulation(for: c) {
                pop += p
            }
        }
        return pop
    }
}

class DummyDataBase: Database {
    
    private var capitals = ["alpha" : 1, "beta" : 2, "gamma" : 3]
    
    func getPopulation(for capital: String) -> Int? {
        let a = capital.trimmingCharacters(in: .whitespaces).lowercased()
        return capitals[a]
    }
}
