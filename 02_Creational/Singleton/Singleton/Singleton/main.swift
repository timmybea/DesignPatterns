//
//  main.swift
//  Singleton
//
//  Created by Tim Beals on 2018-02-14.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

//DID YOU KNOW?? Command Line programs do not have a bundle? So you cannot put a file in your project and get it with Bundle.main.resource... Check out how to create tests in command line project using notes in Evernote.
/*

 A Singleton is: A component which can be instantiated only once.
 
 Singleton Rationale:
 It only makes sense to have one of the component in the system (prevent additional creation)
 Initializer call could be expensive - you don’t want to initialize more than once.
 You want to access your object from anywhere in your program.
 Take care of lazy instantiation and thread safety.
 
 Stateful v stateless
 Keeps track of state of interaction by setting and storing values. There is a record of previous interactions. A connection is made and then terminated. Property-less?? Static.

 
 ISSUES!
 Testability
*/


/*
let db1 = SingletonDatabase.shared
var city = "Beijing"
print("\(city) has a population of \(String(describing: db1.getPopulation(for: city)))")
print(SingletonDatabase.instanceCount)

let db2 = SingletonDatabase.shared
city = "New Delhi"
print("\(city) has a population of \(String(describing: db1.getPopulation(for: city))))")
print(SingletonDatabase.instanceCount)
*/

//SO WHAT'S THE PROBLEM??
//When we are testing the singleton, we have to(??) test 'live data' which can be manipulated and is therefore unreliable because we have to hard code values for testing purposes (or rewrite the test each time...)
//Is it possible to have a private test database built into the singleton??

var rf = ConfigurableRecordFinder(SingletonDatabase.shared)
print(rf.totalPopulation(for: ["Beijing", "New Delhi"]))

