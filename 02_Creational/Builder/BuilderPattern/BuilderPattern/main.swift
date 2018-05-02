//
//  main.swift
//  BuilderPattern
//
//  Created by Tim Beals on 2018-02-08.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

//BUILDER
//Rationale: Sometimes initializing an object requires lots of arguments, and putting them all as arguments into a single init call is impractical.
//Builder provides an API that allows for piece-wise construction.


//LIFE WITHOUT BUILDER: Not type-safe at all.

let hello = "hello"
let par = "<p>\(hello)</p>"
print(par)

let words = ["hello", "world"]
var list = "<ul>\n"
for word in words {
    list.append("<li>\(word)</li>\n")
}
list.append("</ul>\n")

print(list)



//Create building block(s)
class HtmlElement: CustomStringConvertible {
    
    var name = ""
    var text = ""
    var elements = [HtmlElement]()
    
    private let indentSize = 2
    
    init() {}
    init(name: String, text: String) {
        self.name = name
        self.text = text
    }

    
    private func description(indent: Int) -> String {
        var result = ""
        let i = String(repeating: " ", count: indent)
        result += "\(i)<\(name)>\n"
        
        if !text.isEmpty {
            result += String(repeating: " ", count: indent + 1)
            result += text
            result += "\n"
        }
        
        for e in elements {
            result += e.description(indent: indent + 1)
        }
        
        result += "\(i)</\(name)>\n"
        
        return result
    }
    
    var description: String {
        return description(indent: 0)
    }
}

//And then the builder...
class HtmlElementBuilder: CustomStringConvertible {
    
    private let rootName: String
    var root = HtmlElement()
    
    init(rootName: String) {
        self.rootName = rootName
        self.root.name = rootName
    }
//Good...
//    func addChild(name: String, text: String) {
//        let e = HtmlElement(name: name, text: text)
//        self.root.elements.append(e)
//    }
    
    //Fluent Builder Interface... BETTER!
    //The fluent interface means you return self so that you can chain the creation calls and not have to keep
    //repeating the instance.

    func addChildFluent(name: String, text: String) -> HtmlElementBuilder {
        let e = HtmlElement(name: name, text: text)
        self.root.elements.append(e)
        return self
    }
    
    func clear() {
        root = HtmlElement(name: rootName, text: "")
    }
    
    var description: String {
        return self.root.description
    }
    
}

//...now we can build that same list above in an object oriented way:

let unorderedList = HtmlElementBuilder(rootName: "ul")
//unorderedList.addChild(name: "li", text: "Hello")
//unorderedList.addChild(name: "li", text: "World")
unorderedList.addChildFluent(name: "li", text: "Hello")
.addChildFluent(name: "li", text: "World,")
.addChildFluent(name: "li", text: "this")
.addChildFluent(name: "li", text: "is")
.addChildFluent(name: "li", text: "me")
//There will be a compiler complaint that the last builder call has an unused result

let htmlElement = unorderedList.root
print(htmlElement)


