//
//  CreationTypes.swift
//  Bot Bounce 2
//
//  Created by Chris Luttio on 1/19/16.
//  Copyright © 2016 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class Valve<Product> {
    var queue: Queue<Product> = Queue()
    var constraints: [Product -> Bool] = []
    var previous: Product?
    
    func supply(item: Product) {
        queue.push(item)
    }
    
    func release() -> Product? {
        previous = prerelease()
        return previous
    }
    
    private func prerelease() -> Product? {
        guard let peek = queue.peek else { return nil }
        for constraint in constraints where !constraint(peek) { return nil }
        return queue.pop()
    }
    
    func drain() {
        queue.clear()
        previous = nil
    }
    
    var reserve: Product? {
        return queue.peer ?? previous
    }
    
}

class Procedure<Type, Product>: State<Int> {
    var elements: [Type]
    
    init(_ name: Int = 0, _ types: [Type] = []) {
        self.elements = types
        super.init(name)
    }
    
    func construct(offset: float2) -> GeneratedProcedure<Product> {
        return GeneratedProcedure(offset)
    }
    
}

class GeneratedProcedure<Product> {
    var offset: float2
    var elements: [Product]
    
    init(_ offset: float2, _ objects: [Product] = []) {
        self.offset = offset
        self.elements = objects
    }
}