//
//  main.swift
//  AbstractFactory
//
//  Created by Tim Beals on 2018-02-12.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation


/*
Abstract Factory
Used to build a family of objects by first building a corresponding family of factories.
 */


//Family of objects
protocol HotDrink {
    func consume()
}

class Tea: HotDrink {
    func consume() {
        print("This tea is delicious")
    }
}

class Coffee : HotDrink {
    func consume() {
        print("I love coffee")
    }
}

//Family of factories
protocol HotDrinkFactory {
    init()
    func prepare(amount: Int) -> HotDrink
}


class TeaFactory: HotDrinkFactory {
    required init() {}
    
    func prepare(amount: Int) -> HotDrink {
        print("boil \(amount) ml of water and put in a tea bag")
        return Tea()
    }
}


class CoffeeFactory: HotDrinkFactory {
    required init() {}
    
    func prepare(amount: Int) -> HotDrink {
        print("grind beans, and put in \(amount) ml of boiling water")
        return Coffee()
    }
}

enum AvailableDrinks: String {
    case coffee = "Coffee"
    case tea = "Tea"
    
    static let all = [coffee, tea]
}

class HotDrinkMachine {
    
    var availableDrinks = AvailableDrinks.all
    
    internal var factories = [AvailableDrinks: HotDrinkFactory]()
    
    init() {
        //You can get a class type using NSClassFromString... Notice that you need the name of your project as the prefix.
        for drink in availableDrinks {
            let type = NSClassFromString("AbstractFactory.\(drink.rawValue)Factory")
            factories[drink] = (type as! HotDrinkFactory.Type).init()
        }
    }
    
    func chooseDrink() -> HotDrink? {
        print("Choose your drink:")
        for (index, drink) in availableDrinks.enumerated() {
            print("\(index): \(drink.rawValue)")
        }
        let input = Int(readLine()!)! //unsafe but whatevs...
        let drink = availableDrinks[input]
        return self.makeDrink(drink, size: 500)
    }
    
    func makeDrink(_ d: AvailableDrinks, size: Int) -> HotDrink? {
        let f = self.factories[d]
        return f?.prepare(amount: size)
    }
    
}


//and the use...
let machine = HotDrinkMachine()
let d = machine.chooseDrink()
d?.consume()

