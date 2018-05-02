//
//  main.swift
//  VisitorEx
//
//  Created by Tim Beals on 2018-03-07.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

//EXERCISE:

protocol ExpressionVisitor
{
    func visit(_ v: Value)
    func visit(_ ae: AdditionExpression)
    func visit(_ me: MultiplicationExpression)
}

protocol Expression
{
    func visit(_ ev: ExpressionVisitor)
}

class Value : Expression
{
    let value: Int
    init(_ value: Int)
    {
        self.value = value
    }
    func visit(_ ev: ExpressionVisitor)
    {
        ev.visit(self)
    }
}

class AdditionExpression : Expression
{
    let lhs, rhs: Expression
    init(_ lhs: Expression, _ rhs: Expression)
    {
        self.lhs = lhs
        self.rhs = rhs
    }
    func visit(_ ev: ExpressionVisitor)
    {
        ev.visit(self)
    }
}

class MultiplicationExpression : Expression
{
    let lhs, rhs: Expression
    init(_ lhs: Expression, _ rhs: Expression)
    {
        self.lhs = lhs
        self.rhs = rhs
    }
    func visit(_ ev: ExpressionVisitor)
    {
        ev.visit(self)
    }
}

class ExpressionPrinter : ExpressionVisitor, CustomStringConvertible
{
    
    private var buffer = ""
    
    func visit(_ v: Value) {
        buffer.append(String(v.value))
    }
    
    func visit(_ ae: AdditionExpression) {
        buffer.append("(")
        ae.lhs.visit(self)
        buffer.append("+")
        ae.rhs.visit(self)
        buffer.append(")")
    }
    
    func visit(_ me: MultiplicationExpression) {
        buffer.append("(")
        me.lhs.visit(self)
        buffer.append("*")
        me.rhs.visit(self)
        buffer.append(")")
    }
    
    var description: String
    {
        return buffer
    }
}

