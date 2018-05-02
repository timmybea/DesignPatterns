//
//  main.swift
//  Iterator
//
//  Created by Tim Beals on 2018-03-02.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

/*
 Iterator (traversal)
usually an implicit construct (for X in Y) that facilitates traversal. It holds reference to the current element and knows how to access a different element (perhaps 'next')
 different ways of traversing a binary tree: in order, pre-order, post-order -
 */

class Node<T> : CustomStringConvertible {
    var value: T
    var left: Node<T>? = nil
    var right: Node<T>? = nil
    var parent: Node<T>? = nil
    
    init(val: T) {
        self.value = val
    }
    
    init(val: T, left: Node<T>, right: Node<T>) {
        self.value = val
        self.right = right
        self.left = left
        
        self.right?.parent = self
        self.left?.parent = self
    }
    
    var description: String {
        return "\(value)"
    }
}

//         6
//        / \
//       3   9
//      / \ / \
//     1  4 7  12

// DIFFERENT TRAVERSAL:
// 13467912 : in order (left, val, right)
// 63149712 : pre-order (val, left, right)
// : post-order (left, right, v)??


//GOAL: Make three different kinds of iterator and put them into a BinaryTree class

protocol NodeIterator: IteratorProtocol {
    associatedtype U
}

class InOrderIterator<T>: NodeIterator {
    
    typealias U = T
    
    var root: Node<T>
    var current: Node<T>?
    var yieldedStart = false
    
    init(root: Node<T>) {
        self.root = root
        self.current = root
        
        while current?.left != nil {
            current = current!.left!
        }
    }
    
    func reset() {
        current = root
        yieldedStart = false
    }
    
    func next() -> Node<U>? {
        if !yieldedStart {
            yieldedStart = true
            return current
        }

        if current!.right != nil {
            current = current!.right!
            while current!.left != nil {
                current = current!.left
            }
            return current
        } else {
            var p = current?.parent
            while p != nil && current === p!.right {
                current = p!
                p = p!.parent
            }
            current = p
            return current
        }
    }
}


class PreOrderIterator<T> : NodeIterator {
    
    typealias U = T
    
    var root: Node<T>
    var current: Node<T>?
    var yieldedStart = false
    
    init(root: Node<T>) {
        self.root = root
        self.current = root
        
        while current?.left != nil {
            current = current!.left!
        }
    }
    
    func next() -> Node<U>? {
        return current
    }
    
    //pre order functions
    private func traverse(node: Node<T>, buffer: inout [T]) {
        buffer.append(node.value)
        
        if let left = node.left {
            traverse(node: left, buffer: &buffer)
        }
        
        if let right = node.right {
            traverse(node: right, buffer: &buffer)
        }
    }
    
    var preOrder: [T]
    {
        var buffer = [T]()
        traverse(node: root, buffer: &buffer)
        return buffer
    }
    

}

class PostOrderIterator<T> : IteratorProtocol {
    
    typealias U = T
    
    var root: Node<T>
    var current: Node<T>?
    var yieldedStart = false
    
    init(root: Node<T>) {
        self.root = root
        self.current = root
        
        while current?.left != nil {
            current = current!.left!
        }
    }
    
    func next() -> Node<U>? {
        return current
    }
}

let n2 = Node<Int>(val: 3, left: Node<Int>(val: 1), right: Node<Int>(val: 4))
let n3 = Node<Int>(val: 9, left: Node<Int>(val: 7), right: Node<Int>(val: 12))
let root = Node<Int>(val: 6, left: n2, right: n3)

let ioi = InOrderIterator<Int>(root: root)

//you can initialize a sequence and have access to forEach, map, filter, reduce etc.
let nodes = AnySequence { InOrderIterator<Int>(root: root) }
nodes.forEach() { print($0) }

//You could also capture this iterator in a class conforming to sequence

class BinaryTree<T> : Sequence {

    private let root: Node<T>

    init(root: Node<T>) {
        self.root = root
    }

    func makeIterator() -> InOrderIterator<T> {
        return InOrderIterator<T>(root: root)
    }

}

let tree = BinaryTree<Int>(root: root)
//tree.forEach { print($0) }

let preOrder = PreOrderIterator(root: root)
print(preOrder.preOrder)

