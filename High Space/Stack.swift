//
//  Stack.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Stack<T> {
    var contents: [T]
    
    init() {
        contents = []
    }
    
    func wipe() {
        contents.removeAll()
    }
    
    func push(_ item: T) {
        contents.append(item)
    }
    
    func pop() {
        contents.removeLast()
    }
    
    func peel() {
        contents.removeFirst()
    }
    
    var peek: T? {
        return contents.last
    }
}
