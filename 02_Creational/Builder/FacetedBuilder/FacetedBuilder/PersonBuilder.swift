//
//  PersonBuilder.swift
//  FacetedBuilder
//
//  Created by Tim Beals on 2018-02-09.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

class Person : CustomStringConvertible {
    
    var age: Int = 0
    var name: String = ""
    
    //address
    var street = "", city = "", country = ""
    //employmeny
    var position = "", company = "", salary: Int = 0
    
    init() {}
    
    var description: String {
        return "\(name) is \(age) years old"
    }
    
    var address: String {
        return "\(street), \(city), \(country)"
    }
    
    var employment: String {
        return "I am a \(position) at \(company), earning $\(salary)"
    }
}

class PersonBuilder {
    
    fileprivate var person = Person()
    
    lazy var address: PersonAddressBuilder = {
        return PersonAddressBuilder(person: self.person)
    }()
    
    lazy var employment: PersonEmploymentBuilder = {
        return PersonEmploymentBuilder(person: self.person)
    }()
    
    func addName(_ n: String) -> PersonBuilder {
        person.name = n
        return self
    }
    
    func addAge(_ a: Int) -> PersonBuilder {
        person.age = a
        return self
    }
    
    func createPerson() -> Person {
        return self.person // you could perform checks here.
    }
}

class PersonAddressBuilder: PersonBuilder {
    
    init(person: Person) {
        super.init()
        self.person = person
    }
    
    func addStreet(_ s: String) -> PersonAddressBuilder {
        self.person.street = s
        return self
    }
    
    func addCity(_ c: String) -> PersonAddressBuilder {
        self.person.city = c
        return self
    }
    
    func addCountry(_ c: String) -> PersonAddressBuilder {
        self.person.country = c
        return self
    }
    
}

class PersonEmploymentBuilder: PersonBuilder {
    
    init(person: Person) {
        super.init()
        self.person = person
    }
    
    func addPosition(_ p: String) -> PersonEmploymentBuilder {
        self.person.position = p
        return self
    }
    
    func addCompany(_ c: String) -> PersonEmploymentBuilder {
        self.person.company = c
        return self
    }
    
    func addSalary(_ s: Int) -> PersonEmploymentBuilder {
        self.person.salary = s
        return self
    }
}

