//
//  main.swift
//  DependencyInversion
//
//  Created by Tim Beals on 2018-02-07.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

//Dependency Inversion Principle:
//1) High level modules should not depend on low-level modules
//2) Both high and low level modules should depend on abstractions.
//3) Abstractions SHOULD NOT depend on details, but details SHOULD depend on abstractions.

enum Relationship {
    case parent
    case child
    case sibling
}

class Person {
    var name = ""
    init(name: String) {
        self.name = name
    }
}


//SOLUTION! This protocol introduces a layer of abstraction
protocol RelationshipBrowser {
    func findAllChildren(of name: String) -> [Person]
}



//low-level module: Specifies how to store the information
class Relationships : RelationshipBrowser {
    
    private var relations = [(Person, Relationship, Person)]()

    func addParentAndChild(p: Person, c: Person) {
        self.relations.append((p, .parent, c))
        self.relations.append((c, .child, p))
    }
    
    
//SOLUTION! implement the protocol
    func findAllChildren(of name: String) -> [Person] {
        return relations
            .filter() { $0.0.name == name && $0.1 == .parent }
            .map() { $0.2 }
    }
}





//high-level module: Uses the low-level data

class Research {
    
    //!PROBLEM! This is a violation of the Dependency Inversion Principle.
    //Why? Because we are not only passing in the low-level module, but we are accessing its internals (.relations should be marked private)
//    init(relationships: Relationships) {
//        let relations = relationships.relations
//        for r in relations where r.0.name == "Tara" && r.1 == .parent {
//            print("\(r.0.name) has a child called \(r.2.name)")
//        }
//    }
    
    //SOLUTION!
    init(relBrowser: RelationshipBrowser) {
        
        for child in relBrowser.findAllChildren(of: "Tara") {
            print("Tara has a child called \(child.name)")
        }
    }
    
}



let Tara = Person(name: "Tara")
let Silas = Person(name: "Silas")
let Ruby = Person(name: "Ruby")

let rels = Relationships()
rels.addParentAndChild(p: Tara, c: Ruby)
rels.addParentAndChild(p: Tara, c: Silas)

//let _ = Research(relationships: rels)

//Now the high-level module no longer depends on the low-level module, but the abstraction. This means you can pass in any module that conforms to RelationshipBrowser.
let _ = Research(relBrowser: rels)





