//
//  main.swift
//  Interpreter
//
//  Created by Tim Beals on 2018-02-26.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
 A component that processes structured text data. It does so by turning it into separate logical tokens (lexing) and then interpreting sequences of these tokens (parsing).
 
 Textual input that needs to be processed.
 Compilers, interpreters, IDEs
 Numeric expressions (3 + 4 / 5)
 Regular expressions
 Turning strings into OOP based structures in a complicated process
 Compiler theory
 */


let input = "(13+4)-(12-1)"
//GOAL: We want to interpret this string to be able to evaluate it.

//WE WILL DO THIS IN TWO STAGES:
//1. LEXER: Takes the string and splits it into individual tokens.

//2. PARSER: AssembleS the tokens into an object oriented representation that we can then use (with the visitor pattern) to evaluate it.

extension String {
    
    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    var isNumber: Bool {
        get {
            return !self.isEmpty &&
            self.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
        }
    }
}



struct Token : CustomStringConvertible {
    enum TokenType {
        case integer
        case plusOperation
        case minusOperation
        case lParenthesis
        case rParenthesis
    }
    
    var tokenType: TokenType
    var text: String
    
    init(tokenType: TokenType, text: String) {
        self.tokenType = tokenType
        self.text = text
    }
    
    var description: String {
        return "`\(text)`"
    }
}

func lex(input: String) -> [Token] {
    var result = [Token]()
    
    var i = 0
    while i < input.count {
        switch input[i] {
        case "+":
            result.append(Token(tokenType: .plusOperation, text: "+"))
        case "-":
            result.append(Token(tokenType: .minusOperation, text: "-"))
        case "(":
            result.append(Token(tokenType: .lParenthesis, text: "("))
        case ")":
            result.append(Token(tokenType: .rParenthesis, text: ")"))
        default:
            var s = String(input[i])
            for j in i+1..<input.count {
                if String(input[j]).isNumber {
                    s.append(input[j])
                    i += 1
                } else {
                    result.append(Token(tokenType: .integer, text: s))
                    break
                }
            }
        }
        i += 1
    }
    return result
}






let tokens = lex(input: input)
print(tokens)


//PARSER
protocol Element {
    var value: Int { get }
}

class Integer : Element {
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
}

class BinaryOperation : Element {
    
    enum OpType {
        case addition
        case subtraction
    }
    
    var opType: OpType = .addition
    //Note that you can have an integer OR an expression on the left and right sides.
    var left: Element = Integer(value: 0)
    var right: Element = Integer(value: 0)
    
    init() {}
    init(l: Element, opType: OpType, r: Element) {
        self.left = l
        self.opType = opType
        self.right = r
    }
    
    var value: Int {
        switch opType {
        case .addition:
            return left.value + right.value
        case .subtraction:
            return left.value - right.value
        }
    }
}

func parse(tokens: [Token]) -> Element {
    
    let result = BinaryOperation()
    var haveLHS = false

    var i = 0
    while i < tokens.count {
        let token = tokens[i]
        switch token.tokenType {
        case .integer :
            let integer = Integer(value: Int(token.text)!)
            if !haveLHS {
                result.left = integer
                haveLHS = true
            } else {
                result.right = integer
            }
        case .plusOperation :
            result.opType = .addition
        case .minusOperation :
            result.opType = .subtraction
        case .lParenthesis :
            //get index of right parenthesis token
            var j = i
            while j < tokens.count {
                if tokens[j].tokenType == Token.TokenType.rParenthesis {
                    break
                }
                j += 1
            }
            //process subexpression without left parenthesis
            let subexpression = tokens[(i+1)..<j]
            let element = parse(tokens: Array(subexpression))
            if !haveLHS {
                result.left = element
                haveLHS = true
            } else {
                result.right = element
            }
            i = j
        default: break
        }
        i += 1
    }
    return result
}


let i = "(13+4)-(12-1)"
let t = lex(input: i)
let r = parse(tokens: t)
print("The result of \(i) is: \(r.value)")



