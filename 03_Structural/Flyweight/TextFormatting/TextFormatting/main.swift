//
//  main.swift
//  TextFormatting
//
//  Created by Tim Beals on 2018-02-21.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

//GOAL: Create a class that can take text and specify which characters should be upper or lower cased.

extension String {
    
    func substring(location: Int, length: Int) -> String? {
        guard count >= location + length else { return nil }
        let start = index(startIndex, offsetBy: location)
        let end = index(start, offsetBy: length)
        return String(self[start..<end])
    }
}

class FormattedText: CustomStringConvertible {
    
    private var text: String
    private var capitalize: [Bool]
    
    init(text: String) {
        
        self.text = text
        capitalize = [Bool](repeatElement(false, count: text.utf8.count))
        
    }
    
    func capitalize(start: Int, end: Int) {
        guard start < end && end < text.utf8.count else { return }
        for i in start...end {
            capitalize[i] = true
        }
    }
    
    var description: String {
        var buffer = ""
        for i in 0..<text.count {
            let c = Array(text)[i]
            buffer += capitalize[i] ? String(c).uppercased() : String(c).lowercased()
        }
        return buffer
    }
}


let ft = FormattedText(text: "hello world")
ft.capitalize(start: 6, end: 10)
print(ft)

//This totally works, but you can see that now the line of text is being held twice which is a waste of memory. Once as a String and again as an array of bool. Let's use the flyweight design pattern to remedy this.

class BetterFormattedText: CustomStringConvertible {
    
    private var text: String
    private var formatting = [TextRange]()
    
    init(text: String) {
        self.text = text
    }
    
    func getRange(start: Int, end: Int) -> TextRange {
        let range = TextRange(start: start, end: end)
        formatting.append(range)
        return range
    }
    
    class TextRange {
        var start: Int
        var end: Int
        var capitalize = false
        
        init(start: Int, end: Int) {
            self.start = start
            self.end = end
        }
        
        func covers(position: Int) -> Bool {
            return position >= start && position <= end
        }
    }
    
    var description: String {
        var buffer = ""
        for i in 0..<text.count {
            let c = Array(text)[i]
            for range in formatting {
                if range.covers(position: i) && range.capitalize {
                    buffer += String(c).uppercased()
                } else {
                    buffer += String(c).lowercased()
                }
            }
        }
        return buffer
    }
}

let bft = BetterFormattedText(text: "This is a brave new world")
//notice that even though you are setting capitalize value after adding the range to the array, this still works.
bft.getRange(start: 10, end: 15).capitalize = true
print(bft)
