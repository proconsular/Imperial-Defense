//
//  LinkedList.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/6/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ListNode<Value> {
    var value: Value
    var previous: ListNode<Value>!
    var next: ListNode<Value>!
    
    init(_ value: Value) {
        self.value = value
    }
}

class LinkedList<T>: Sequence {
    var head, tail: ListNode<T>!
    
    init() {
        head = nil
        tail = nil
    }
    
    func prepend(_ value: T) {
        let node = ListNode(value)
        if head == nil {
            head = node
            tail = node
        }else{
            node.next = head
            head.previous = node
            head = node
        }
    }
    
    func append(_ value: T) {
        let node = ListNode(value)
        if tail == nil {
            head = node
            tail = node
        }else{
            tail.next = node
            node.previous = tail
            tail = node
        }
    }
    
    func popFirst() -> T? {
        let first = head
        if head != nil {
            head = head.next
            if head != nil {
                head.previous = nil
            }
        }
        return first?.value
    }
    
    func popLast() -> T? {
        let last = tail
        if tail != nil && tail.previous != nil {
            tail = tail.previous
            if tail != nil {
                tail.next = nil
            }
        }
        return last?.value
    }
    
    func print() {
        var current = head
        while current != nil {
            Swift.print(current!.value)
            current = current!.next
        }
    }
    
    func clear() {
        head = nil
        tail = nil
    }
    
    func makeIterator() -> LinkedListGenerator<T> {
        return LinkedListGenerator(self)
    }
}

struct LinkedListGenerator<T>: IteratorProtocol {
    typealias Element = T
    
    let list: LinkedList<T>
    var current: ListNode<T>?
    
    init(_ list: LinkedList<T>) {
        self.list = list
        current = list.head
    }
    
    mutating func next() -> T? {
        let value = current?.value
        current = current?.next
        return value
    }
}













