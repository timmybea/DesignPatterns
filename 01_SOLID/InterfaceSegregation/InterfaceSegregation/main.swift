//
//  main.swift
//  InterfaceSegregation
//
//  Created by Tim Beals on 2018-02-07.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

//Interface Segregation Principle: Don't put too much functionality into a single protocol because you don't want to force the clients to have to implement functionality that they might not even need.

class Document {
    //something
}

//PROBLEM: This protocol is too broad. Only parts of the functionality are required by some of the machines.
//protocol Machine {
//    func print(doc: Document)
//    func scan(doc: Document)
//    func fax(doc: Document)
//}

//SOLUTION: Break up the Machine protocol into smaller protocols.
protocol  Print {
    func print(doc: Document)
}

protocol Scan {
    func scan(doc: Document)
}

protocol Fax {
    func fax(doc: Document)
}


class TraditionalPrinter: Print /*Machine*/ {
    
    func print(doc: Document) {
        //This words
    }
}

class TraditionalScanner: Scan {
    
    func scan(doc: Document) {
        //This works
    }
}

class MultiFunctionPrinter: Print, Scan, Fax /*Machine*/ {
    
    func print(doc: Document) {
        //This works
    }
    
    func scan(doc: Document) {
        //This works
    }
    
    func fax(doc: Document) {
        //This works
    }
}

//And this works fine, BUT checkout how you can use protocol and class inheritance to bundle these things together using the 'Decorator Pattern'

protocol MultiFunction : Print, Scan { }


class Photocopier: MultiFunction {
    
    private let scanner: TraditionalScanner
    private let printer: TraditionalPrinter
    
    init(scanner: TraditionalScanner, printer: TraditionalPrinter) {
        self.scanner = scanner
        self.printer = printer
    }
    
    func print(doc: Document) {
        self.printer.print(doc: doc)
    }
    
    func scan(doc: Document) {
        self.scanner.scan(doc: doc)
    }
}
