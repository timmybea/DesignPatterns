//
//  main.swift
//  ArrayBackedProperties
//
//  Created by Tim Beals on 2018-03-02.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

//This is a good technique to use when you want to be able to create aggregate values such as an average of several property values.

class Creature: Sequence {
    
    private var stats = [Int](repeatElement(0, count: 3))
    
    private let _strength = 0
    private let _agility = 1
    private let _intelligence = 2
    
    var strength: Int {
        get { return stats[_strength] }
        set(v) { stats[_strength] = v }
    }
    
    var agility: Int {
        get { return stats[_agility] }
        set(v) { stats[_agility] = v }
    }
    
    var intelligence: Int {
        get { return stats[_intelligence] }
        set(v) { stats[_intelligence] = v }
    }
    
    var averageStat: Float {
        return Float(stats.reduce(0, +)) / Float(stats.count)
    }
    
    func makeIterator() -> IndexingIterator<Array<Int>> {
        return IndexingIterator(_elements: stats)
    }
}


let c = Creature()
c.agility = 5
c.intelligence = 8
c.strength = 7

print(c.averageStat)

for characteristic in c { // I can do this because Creature conforms to Sequence
    print(characteristic)
}

//You could also suscript...

class AnotherCreature: Sequence {
    
    private var stats = [Int](repeatElement(0, count: 3))
    
    enum Characteristic: Int {
        case strength = 0
        case agility
        case intelligence
    }
    
    subscript(_ c: Characteristic) -> Int {
        get { return stats[c.rawValue] }
        set(v) { stats[c.rawValue] = v }
    }
    
    var averageStat: Float {
        return Float(stats.reduce(0, +)) / Float(stats.count)
    }
    
    func makeIterator() -> IndexingIterator<Array<Int>> {
        return IndexingIterator(_elements: stats)
    }
}

let thisCreature = AnotherCreature()
thisCreature[.agility] = 4
thisCreature[.intelligence] = 5
thisCreature[.strength] = 6

print(thisCreature.averageStat)

for stat in thisCreature {
    print(stat)
}





