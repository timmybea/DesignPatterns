//
//  main.swift
//  FacetedBuilder
//
//  Created by Tim Beals on 2018-02-09.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

//Faceted Builder:
//Sometimes the object you are creating is so complex that you will need multiple builders to achieve its creation.
//The trick is to have the two sub-builders inherit from the same wrapper class (PersonBuilder)

//USE: Notice that PersonBuilder doesn't allow you to access the person property because it is labelled fileprivate

let pb = PersonBuilder()
pb.addName("Tim")
    .addAge(35)
pb.address.addStreet("765 Sunrise Ave")
    .addCity("Medford")
    .addCountry("USA")
    .employment.addPosition("iOS Developer")
    .addCompany("Tapp Creative")
    .addSalary(80_000)

let p = pb.createPerson()

print(p)
print(p.address)
print(p.employment)


