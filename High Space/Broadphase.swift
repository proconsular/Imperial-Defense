//
//  Broadphase.swift
//  Bot Bounce+
//
//  Created by Chris Luttio on 12/22/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class BitmaskTester {
    
    let max_objects: Int32
    let max_pairs: Int32
    var bitflags: [Int32]
    
    init(_ count: Int) {
        max_objects = Int32(count)
        max_pairs = max_objects * (max_objects - 1) / 2
        bitflags = Array<Int32>(count: Int((max_pairs + 31) / 32), repeatedValue: 0)
    }
    
    private func testPair(index0: Int32, _ index1: Int32) -> Bool {
        guard index0 != index1 else { return false }
        
        var min = index0, max = index1
        if index1 < index0 {
            min = index1
            max = index0
        }
        
        let bitindex: Int32 = min * (2 * max_objects - min - 3) / 2 + max - 1
        let mask = 1 << (bitindex & 31)
        let flagindex = Int(bitindex >> 5)
        if (bitflags[flagindex] & mask) == 0 {
            bitflags[flagindex] |= mask
            return true
        }
        return false
    }
    
    func clear() {
        bitflags = Array<Int32>(count: Int((max_pairs + 31) / 32), repeatedValue: 0)
    }
    
}

class Broadphaser {
    let grid: Grid
    var contacts: [Manifold]
    
    init(_ grid: Grid) {
        self.grid = grid
        contacts = []
    }
    
    func getContacts() -> [Manifold] {
        var contacts: [Manifold] = []
        
        for cell in grid.cells {
            contacts += execute(cell.getTree())
        }
        
        return contacts
    }
    
    private func execute(tree: Quadtree) -> [Manifold] {
        var contacts: [Manifold] = []
        
        contacts += process(tree.elements.map{ $0.body })
        
        for sector in tree.sectors {
            contacts += execute(sector)
        }
        
        return contacts
    }
    
    private func process(bodies: [Body]) -> [Manifold] {
        var contacts: [Manifold] = []
        
        bodies.sort(sortBodies).match {
            if let contact = verify($0, $1) {
                contacts.append(contact)
            }
        }
        
        return contacts
    }
    
    private func sortBodies(prime: Body, _ secunde: Body) -> Bool {
        return prime.substance.mass.mass > secunde.substance.mass.mass
    }
    
    private func verify(prime: Body, _ secunde: Body) -> Manifold? {
        guard prime.substance.mass.mass != 0 else { return nil }
        if let contact = validateContact(prime, secunde) {
            contact.solve()
            if contact.verify() {
                return contact
            }
        }
        return nil
    }
    
    private func validateContact (prime: Body, _ secunde: Body) -> Manifold? {
        guard !prime.hidden && !secunde.hidden else { return nil }
        guard prime.mask & secunde.mask > 0 else { return nil }
        guard collide(prime, secunde) else { return nil }
        return Manifold(BodyPair(prime, secunde))
    }
    
    private func collide(prime: Body, _ secunde: Body) -> Bool {
        return FixedRect.intersects(prime.shape.getBounds(), secunde.shape.getBounds())
    }
    
}











