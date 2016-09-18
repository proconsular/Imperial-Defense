//
//  StateDevice.swift
//  Bot Bounce
//
//  Created by Chris Luttio on 11/10/15.
//  Copyright © 2015 Evans Creative Studios. All rights reserved.
//

import Foundation

func == <Node: Hashable> (prime: Link<Node>, secunde: Link<Node>) -> Bool {
    return prime.hashValue == secunde.hashValue
}

class Link <Node: Hashable>: Hashable {
    let node: Node
    let strength: Float
    
    var hashValue: Int { return node.hashValue }
    
    init (_ node: Node, _ strength: Float) {
        self.node = node
        self.strength = strength
    }
}

enum StateLinkerError: Error {
    case noLinks
}

struct Linker<Node: Hashable> {
    typealias Linking = [Link<Node>]
    
    var links: Linking = []
    var totalStrength: Float = 0
    
    mutating func append (_ newLink: Link<Node>) {
        links.append(newLink)
        totalStrength += newLink.strength
    }
    
    mutating func appendAll (_ links: [Link<Node>]) {
        links.forEach{append($0)}
    }
    
    func omit (_ omittions: [Node]) -> Linker<Node> {
        var filtered: Linker<Node> = Linker()
        for link in links where !omittions.contains(link.node) {
            filtered.append(link)
        }
        return filtered
    }
    
    func next() throws -> Node {
        let random_number = Float(Float(arc4random() % 1000) / 1000)
        var sum: Float = 0
        
        for link in links {
            sum += link.strength / totalStrength
            if random_number <= sum {
                return link.node
            }
        }
        
        throw StateLinkerError.noLinks
    }
}

func == <Reference: Hashable> (prime: State<Reference>, secunde: State<Reference>) -> Bool {
    return prime.hashValue == secunde.hashValue
}

class State<Reference: Hashable>: Hashable {
    let name: Reference
    var hashValue: Int { return name.hashValue }
    
    var connections: Linker<State>
    
    init (_ name: Reference) {
        self.name = name
        self.connections = Linker()
    }
    
}

class StateDevice<Reference: Hashable> {
    typealias CompoundState = State<Reference>
    
    fileprivate var states: [Reference: CompoundState] = [:]
    fileprivate var state: CompoundState!
    fileprivate var previous: CompoundState!
    
    var omittions: [Reference] = []
    
    func omit (_ omittions: [Reference]) {
        self.omittions.append(contentsOf: omittions)
    }
    
    func set(_ ref: Reference) {
        state = states[ref]
    }
    
    func get () -> CompoundState {
        return state
    }
    
    func getAll (_ refs: [Reference]) -> [CompoundState] {
        var states: [CompoundState] = []
        for (ref, state) in self.states where refs.contains(ref) {
            states.append(state)
        }
        return states
    }
    
    func link(_ alpha: Reference, _ beta: Reference, _ strength: Float) {
        states[alpha]?.connections.append(Link(states[beta]!, strength))
    }
    
    func link(_ alpha: Reference, _ links: [Reference: Float]) {
        for (beta, strength) in links {
            link(alpha, beta, strength)
        }
    }
    
    func append (_ state: CompoundState) {
        states.updateValue(state, forKey: state.name)
    }
    
    func appendAll (_ newStates: [CompoundState]) {
        for newState in newStates {
            append(newState)
        }
    }
    
    subscript(name: Reference) -> CompoundState {
        return states[name]!
    }
    
    func next() throws {
        previous = state
        let omits = getAll(omittions)
        state = try state.connections.omit(omits).next() as CompoundState
    }
    
    func rewind () {
        state = previous
    }
    
    func replay() throws {
        rewind()
        try next()
    }
    
}
