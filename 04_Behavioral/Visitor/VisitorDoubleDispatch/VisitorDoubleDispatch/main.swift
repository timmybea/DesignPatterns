//
//  main.swift
//  VisitorDoubleDispatch
//
//  Created by Tim Beals on 2018-03-07.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

// This is the classic approach to a visitor pattern. Note that this demo does not require any type checks or type casts.

protocol Expression
{
    func accept(_ visitor: ExpressionVisitor)
}

protocol ExpressionVisitor
{
    func visit(_ de: DoubleExpression)
    func visit(_ ae: AdditionExpression)
}

class DoubleExpression : Expression {

    var value: Double
    init(_ v: Double)
    {
        self.value = v
    }

    func accept(_ visitor: ExpressionVisitor) //this will be the same everywhere
    {
        visitor.visit(self) // self tells the compiler which visit method to call in the ExpressionVisitor protocol
    }
}

class AdditionExpression : Expression
{

    var left, right: Expression
    init(_ l: Expression, _ r: Expression)
    {
        self.left = l
        self.right = r
    }

    func accept(_ visitor: ExpressionVisitor)
    {
        visitor.visit(self)
    }
}

class ExpressionPrinter : ExpressionVisitor, CustomStringConvertible
{
    private var buffer = ""

    func visit(_ de: DoubleExpression) {
        buffer.append(String(de.value))
    }

    func visit(_ ae: AdditionExpression) {
        buffer.append("(")
        ae.left.accept(self)
        buffer.append("+")
        ae.right.accept(self)
        buffer.append(")")

    }

    var description: String {
        return buffer
    }
}

class ExpressionCalculator: ExpressionVisitor, CustomStringConvertible
{
    private var result = 0.0
    
    func visit(_ de: DoubleExpression) {
        self.result = de.value
    }
    
    func visit(_ ae: AdditionExpression) {
        ae.left.accept(self)
        let a = result
        ae.right.accept(self)
        let b = result
        result = a + b
    }
    
    var description: String {
        return String(result)
    }
}

//(1 + (2 + 3))
let e = AdditionExpression(DoubleExpression(1),
                           AdditionExpression(DoubleExpression(2), DoubleExpression(3)))

let ep = ExpressionPrinter()
ep.visit(e)

let ec = ExpressionCalculator()
ec.visit(e)

print("\(ep) = \(ec)")


//This is by no means a perfect solution either. Each time you create a new expression type you will need to add it to the expression visitor protocol which will then mean that your visitor classes (expression printer and calculator) will also need to be extended. It really doesn't save you any coding, it simply moves the coding from the expression types to the expression visitor. It means modifying fewer classes.



