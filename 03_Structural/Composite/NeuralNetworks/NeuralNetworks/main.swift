//
//  main.swift
//  NeuralNetworks
//
//  Created by Tim Beals on 2018-02-17.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

class Neuron {
    var inputs = [Neuron]()
    var outputs = [Neuron]()
    
    func connect(to n: Neuron) {
        outputs.append(n)
        n.inputs.append(self)
    }
}

class NeuronLayer {
    private var neurons: [Neuron]
    
    init(_ count: Int) {
        self.neurons = Array(repeating: Neuron(), count: count)
    }
}

//var n1 = Neuron()
//var n2 = Neuron()
//var l1 = NeuronLayer(10)
//var l2 = NeuronLayer(20)
//
//n1.connect(to: n2)

 /*
Now we want to create a 'func connect' that can do the following.
 
 neuron to neuron *
 neuron to neuron layer
 neuron layer to neuron
 neuron layer to neuron layer
 
 The trick (as we've seen with composites) is to have scalar objects and composites with the same API.
So how can we treat a neuron as if it were a collection of neurons?
 Adopt the Sequence protocol and create an iterator.

 */


class NeuronLayerB : Sequence {
    
    private var neurons: [NeuronB]
    
    init(_ count: Int) {
        self.neurons = Array(repeating: NeuronB(), count: count)
    }
    
    func makeIterator() -> IndexingIterator<Array<NeuronB>>{
        return IndexingIterator(_elements: neurons)
    }
}

//Now that we have the makeIterator implemented, we can simply access the neurons in the array.
//let nl = NeuronLayerB(8)
//
//for neuron in nl {
//    print(String(describing: type(of: neuron)))
//}
//prints: NeuronB (eight times)


//So how can we do something similar for the single neuron?

class NeuronB : Sequence {
    
    var inputs = [NeuronB]()
    var outputs = [NeuronB]()
    
    func makeIterator() -> IndexingIterator<Array<NeuronB>> {
        return IndexingIterator(_elements: [self])
    }
}

//and having done this, we can now remove the connect(to:) function and refactor it more generally

extension Sequence {
    
    func connect<Seq: Sequence>(to other: Seq)
    where Self.Iterator.Element == NeuronB,
    Seq.Iterator.Element == NeuronB
    {
        for from in self {
            for to in other {
                from.outputs.append(to)
                to.inputs.append(from)
            }
        }
    }
    
}

var n1 = NeuronB()
var n2 = NeuronB()
var nl1 = NeuronLayerB(6)
var nl2 = NeuronLayerB(12)

//Now we can simply make the connections that we want.
n1.connect(to: n2)
n1.connect(to: nl1)
nl1.connect(to: n2)
nl2.connect(to: nl1)



