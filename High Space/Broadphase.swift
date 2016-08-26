//
//  Broadphase.swift
//  Bot Bounce+
//
//  Created by Chris Luttio on 12/22/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class Broadphaser {
    
    let grid: Grid
    var contacts: [Manifold]
    
    init(_ grid: Grid) {
        self.grid = grid
        contacts = []
    }
    
    func getContacts () -> [Manifold] {
        return createContacts()
    }
    
    func createContacts() -> [Manifold] {
        var contacts: [Manifold] = []
        
        for cell in grid.cells {
            let tree = cell.getTree()
            grid.borderActors.forEach(tree.append)
            contacts += execute(tree)
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
            guard $0.substance.mass.mass != 0 else { return }
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
        if let contact = validateContact(prime, secunde) {
            contact.solve()
            if contact.verify() {
                return contact
            }
        }
        return nil
    }
    
    private func validateContact (prime: Body, _ secunde: Body) -> Manifold? {
        guard prime.layer == secunde.layer else { return nil }
        guard FixedRect.intersects(prime.shape.getBounds(), secunde.shape.getBounds()) else { return nil }
        return Manifold(BodyPair(prime, secunde))
    }
    
    private func collide(prime: Body, _ secunde: Body) -> Bool {
        return FixedRect.intersects(prime.shape.getBounds(), secunde.shape.getBounds())
    }
    
}











