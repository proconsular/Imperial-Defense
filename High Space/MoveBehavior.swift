//
//  MoveBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class MoveBehavior: Behavior {
    var alive: Bool = true
    
    unowned let body: Body
    var vector: float2
    
    init(_ body: Body, _ vector: float2) {
        self.body = body
        self.vector = vector
    }
    
    func update() {
        body.location += vector * Time.delta
    }
}
