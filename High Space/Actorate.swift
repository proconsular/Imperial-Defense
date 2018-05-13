//
//  Actorate.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 2/20/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Actorate {
    
    var actors: [Entity]
    
    init() {
        actors = []
    }
    
    func append(_ actor: Entity) {
        actors.append(actor)
    }
    
    func remove(_ actor: Entity) {
        actors.removeObject(actor)
    }
    
}
