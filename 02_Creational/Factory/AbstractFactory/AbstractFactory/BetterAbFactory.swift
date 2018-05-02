//
//  BetterAbFactory.swift
//  AbstractFactory
//
//  Created by Tim Beals on 2018-03-14.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

//
////types of hot drink
//protocol HotDrink {
//    func consume()
//}
//
//protocol DrinkSpecifications {}
//
////types of factory
//protocol HotDrinkFactory {
//    func chooseSpecifications()
//    func prepareDrink() -> HotDrink
//}
//
//enum CoffeeGrindSpecs: String, DrinkSpecifications {
//    case coarseGrind = "Coarse Grind"
//    case fineGrind = "Fine Grind"
//    
//    static let all = [coarseGrind, fineGrind]
//}
//
//enum CoffeeRoastSpecs: String, DrinkSpecifications {
//    case lightRoast = "Light Roast"
//    case darkRoast = "Dark Roast"
//    
//    static let all = [lightRoast, darkRoast]
//}
//
//class Coffee: HotDrink {
//    
//    var grind: CoffeeGrindSpecs = .coarseGrind
//    var roast: CoffeeRoastSpecs = .lightRoast
//    
//    func consume() {
//        print("Mmmm that was a delicious \(grind), \(roast) coffee")
//    }
//}
//
//class CoffeeFactory: HotDrinkFactory {
//    
//    var options: [String : [DrinkSpecifications]] = ["Roast" : CoffeeRoastSpecs.all, "Grind" : CoffeeGrindSpecs.all]
//    
//    private var coffee = Coffee()
//    
//    func chooseSpecifications() {
//        for option in options {
//            print("Choose your \(option.key):")
//            for (index, spec) in option.value.enumerated() {
//                print("\(index): \(spec)")
//            }
//            guard let input = Int(readLine()!), input < option.value.count else { return }
//            switch option.key {
//            case "Roast": coffee.roast = option.value[input] as! CoffeeRoastSpecs
//            case "Grind": coffee.grind = option.value[input] as! CoffeeGrindSpecs
//            default:
//                print("error: something strange has happened")
//            }
//        }
//    }
//    
//    func prepareDrink() -> HotDrink {
//        print()
//        return self.coffee
//    }
//}
//
////The use of the classes
//
//let cf = CoffeeFactory()
//cf.chooseSpecifications()
//let coffee = cf.prepareDrink()
//coffee.consume()

