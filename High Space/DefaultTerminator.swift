//
//  DefaultTerminator.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class DefaultTerminator: ActorTerminationDelegate {
    unowned let actor: Actor
    
    init(_ actor: Actor) {
        self.actor = actor
    }
    
    func terminate() {
        actor.alive = false
    }
}
