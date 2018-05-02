//
//  main.swift
//  Prototype
//
//  Created by Tim Beals on 2018-02-13.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*Prototype
Is used to make complicated objects. It is the reiteration of an existing design that is copied and then customized. Requires support for ‘deep copy’. Not simply a copy of the references but the recursive replication of everything in the dependency graph. Cloning environment can be created using factory pattern (initialization from fac method etc)
 
 WE WILL LOOK AT TWO COPY APPROACHES:
 1. Copying with initializer
 2. Copying with method
 */


/*
 Use case for prototype pattern...
 
 let tim = Employee(name: "Tim", address: Address(streetAdd: "765 Sunrise Ave", city: "Medford"))
 print(tim)
 
 let chris = tim
 chris.name = "Chris"
 
 Obviously I can't copy like this because I am copying the reference and only one employee exists in memory. I could change the classes to structs and it would work, but that isn't always an option
 */



//Copy Constructors (init):

protocol Copying {
    
    //Copy Constructor. Use 'required' in the class
    init(copyFrom other: Self)
}

class Address : CustomStringConvertible, Copying
{
    var streetAdd: String
    var city: String
    
    init(streetAdd: String, city: String) {
        self.streetAdd = streetAdd
        self.city = city
    }
    
    required init(copyFrom other: Address) {
        self.streetAdd = other.streetAdd
        self.city = other.city
    }
    
    var description: String {
        return "\(streetAdd), \(city)"
    }

}

class Employee : CustomStringConvertible, Copying
{
    var name: String
    var address: Address
    
    init(name: String, address: Address) {
        self.name = name
        self.address = address
    }
    
    required init(copyFrom other: Employee) {
        self.name = other.name
        self.address = Address(copyFrom: other.address)
    }
    
    var description: String {
        return "My name is \(name) and I live at \(address)"
    }
}

let tim = Employee(name: "Tim", address: Address(streetAdd: "765 Sunrise Ave", city: "Medford"))

let chris = Employee(copyFrom: tim)
chris.name = "Chris"

print(tim)
print(chris)


//Deep Copying (method)
//NOTE: In this example address is a class and employee is a struct. Note the return of 'Self' v 'struct name'

protocol BCopying {
    func clone() -> Self
}

class BAddress : CustomStringConvertible, BCopying
{
    var streetAdd: String
    var city: String
    
    init(streetAdd: String, city: String) {
        self.streetAdd = streetAdd
        self.city = city
    }
    
//    func clone() -> Self { //Self is a type!!! You want to return an instance!!
//        return BAddress(streetAdd: self.streetAdd, city: self.city)
//    }
    
    func clone() -> Self {
        return cloneImpl()
    }
    
    private func cloneImpl<T>() -> T {
        return BAddress(streetAdd: self.streetAdd, city: self.city) as! T
    }
    
    var description: String {
        return "\(streetAdd), \(city)"
    }
    
}

struct BEmployee : CustomStringConvertible, BCopying
{
    var name: String
    var address: BAddress
    
    init(name: String, address: BAddress) {
        self.name = name
        self.address = address
    }
    
    func clone() -> BEmployee {
        return BEmployee(name: self.name, address: self.address.clone())
    }
    
    var description: String {
        return "My name is \(name) and I live at \(address)"
    }
}
