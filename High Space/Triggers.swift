//
//  Triggers.swift
//  Bot Bounce 2
//
//  Created by Chris Luttio on 3/13/16.
//  Copyright © 2016 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class GameTrigger {
    unowned let cast: MainCast
    
    init (_ cast: MainCast) {
        self.cast = cast
    }
    
    final func evaluate() {
        if verify() {
            trigger()
        }
    }
    
    func verify() -> Bool { return false; }
    func trigger() {}
}