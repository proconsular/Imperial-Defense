//
//  Broadphase.swift
//  Bot Bounce+
//
//  Created by Chris Luttio on 12/22/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class Broadphaser {
    
    var bodies: [Body] = []
    
    func prepare(inout objs: [Body]) {
        let sorted = objs.sort{ $0.substance.mass.mass > $1.substance.mass.mass }
        bodies = sorted
    }
    
    func getContacts () -> [Manifold] {
        return createContacts(bodies)
    }
    
    func createContacts (array: [Body]) -> [Manifold] {
        var contacts = [Manifold] ()
        
        array.match {
            guard $0.substance.mass.mass != 0 else { return }
            if let contact = validateContact($0, $1) {
                contact.solve()
                if contact.verify() {
                    contacts.append(contact)
                }
            }
        }
        
        return contacts
    }
    
    private func validateContact (prime: Body, _ secunde: Body) -> Manifold? {
        guard prime.layer == secunde.layer else { return nil }
        guard RawRect.isIntersected(prime.shape.getBounds(), secunde.shape.getBounds()) else { return nil }
        
        return Manifold(BodyPair(prime, secunde))
    }
    
}