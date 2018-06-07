//
//  Stack.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Stack<T> {
    var contents: LinkedList<T>
    
    init() {
        contents = LinkedList()
    }
    
    func wipe() {
        contents.clear()
    }
    
    func push(_ item: T) {
        contents.append(item)
    }
    
    func pop() {
        let _ = contents.popLast()
    }
    
    func peel() {
        let _ = contents.popFirst()
    }
    
    var peek: T? {
        return contents.tail.value
    }
}
