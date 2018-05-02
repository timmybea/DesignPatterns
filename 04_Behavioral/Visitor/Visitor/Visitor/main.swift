//
//  main.swift
//  Visitor
//
//  Created by Tim Beals on 2018-03-07.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
 A pattern where a component (visitor) is allowed to traverse the entire inheritance hierarchy. Implemented by propogating a single visit() method through out the entire hierarchy.
 
 WE ALSO NEED TO BE AWARE OF DISPATCH
 There can be questions of which function to call (naming issue??)
 Single dispatch: depends on the name of the request and type of the receiver. ef: 'foo()' on type 'bar' will be bar.foo()
 Double dispatch: depends on name of request and type of TWO receivers (type of visitor and type of element being visited)

 
 MOTIVATION:
 We want to create a new operation for an entire class hierarchy, BUT we don't want to have to modify every class in the hierarchy.
 Need to access the non-common aspects of classes in the hierarchy (extension will not do).
 Create an external component to handle something (avoid type checks) STRONG TYPING!
 
 */

//INTRUSIVE EXPRESSION PRINTING
//(1 + (2 + 3))
//We want to be able to format this equation to make it printable. The first instinct is an intrusive approach (below) where we modify our existing classes (but this breaks our open/close principle).

protocol Expression {
    func print(_ buffer: inout String)
}

class DoubleExpression : Expression {
    private var value: Double
    init(_ v: Double) {
        self.value = v
    }
    
    func print(_ buffer: inout String) {
        buffer.append(String(value))
    }
}

class AdditionExpression : Expression {
    private var left, right: Expression
    init(l: Expression, r: Expression) {
        self.left = l
        self.right = r
    }
    
    func print(_ buffer: inout String) { //recursively print within the expressions left and right.
        
        buffer.append("(")
        left.print(&buffer)
        buffer.append("+")
        right.print(&buffer)
        buffer.append(")")
    
    }
}



//(1 + (2 + 3))
let e = AdditionExpression(l: DoubleExpression(1),
                           r: AdditionExpression(l: DoubleExpression(2), r: DoubleExpression(3)))
//var s = ""
//e.print(&s)
//print(s)

//Note that this works fine, BUT we are assuming that we are able to go into the existing classes to modify them; furthermore, in this example we had to add the print method to two classes, but imagine a situation where you have to do this for a hundred classes. It's tedious and time-consuming.

//BETTER!! VISITOR PATTERN!!

/*
 What is dispatch?
 Figuring out how many pieces of information are required to effectively call a particular function. Unfortunately most languages do not support double dispatch.
 
 
 */

protocol Stuff {}
class Foo : Stuff {}
class Bar : Stuff {}

func f(_ foo: Foo) {}
func f(_ bar: Bar) {}

let x = Foo()
f(x) //This works fine

//but here's a problem
let y: Stuff = Foo()
//f(y)     ----- aside... this would be ok with label in the input and a cast (as! Foo) -----
//UH OH! compiler doesn't know which function to call!
//ERROR: Cannot invoke 'f' with an argument list of type '(Stuff)'



//SOLUTION: REFLECTION BASED PRINTING

protocol BExpression {
}

class BDoubleExpression : BExpression {
    var value: Double
    init(_ v: Double) {
        self.value = v
    }
}

class BAdditionExpression : BExpression {
    var left, right: BExpression
    init(l: BExpression, r: BExpression) {
        self.left = l
        self.right = r
    }
}

/*
//HERE IS THE DISPATCH ERROR!!

 class ExpressionPrinter {
    
    func print(_ e: BDoubleExpression, _ s: inout String) {
        s.append(String(e.value))
    }
    
    func print(_ e: BAdditionExpression, _ s: inout String) {
        s.append("(")
        self.print(left, &s)
        //left is Expression type - could be Double or Addition - and the compiler doesn't know which of the two print methods to call!
    }
}
*/

//Instead make the input type the protocol and then do your type checks inside the method.
class ExpressionPrinter {
    
    func print(_ e: BExpression, _ s: inout String) {
        
        if let de = e as? BDoubleExpression {
        
            s.append("\(de.value)")
            
        } else if let ae = e as? BAdditionExpression {
            
            s.append("(")
            self.print(ae.left, &s)
            s.append("+")
            self.print(ae.right, &s)
            s.append(")")
            
        }
    }
    
}

var s = ""
var ep = ExpressionPrinter()

let ex = BAdditionExpression(l: BDoubleExpression(1),
                           r: BAdditionExpression(l: BDoubleExpression(2), r: BDoubleExpression(3)))

ep.print(ex, &s)
print(s)

//WHAT IS THE COST OF THIS APPROACH? Breaks the open-close principle. If you created a new expression (MultiplicationExpression) then the function in the expression printer would be broken. We would have to modify it to type check for the new class. Also, we are only providing a print function. If we did something similar for an evaluate function we would now have two broken functions at the addition of a new expression.



