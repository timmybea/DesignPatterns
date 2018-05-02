//
//  main.swift
//  SingleResponsibility
//
//  Created by Tim Beals on 2018-02-05.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

//Single responsibility principle states that a class should have a single reason to CHANGE.
//Instead of adding persistence functionality in my Journal class, I should instead have a Journal class and a Persistence class that I interact with separately.
//Separation of concerns allows for better maintainability. Now I can use the same persistence functionality for other classes and not just my Journal type.

let j = Journal()
_ = j.addEntry("First Entry")
let index = j.addEntry("Second Entry")

print(j)

j.removeEntry(index)
print("****")
print(j)


let persistence = Persistence()
let filename = "random/filename.txt"
persistence.save(journal: j, to: filename)




