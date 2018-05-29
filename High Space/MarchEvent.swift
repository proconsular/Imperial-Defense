//
//  MarchEvent.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class MarchEvent: Event {
    unowned var body: Body
    var amount: Float
    var frames: [Int]
    
    init(_ body: Body, _ amount: Float, _ frames: [Int]) {
        self.body = body
        self.amount = amount
        self.frames = frames
    }
    
    func activate() {
        body.velocity.y += amount * (0.016666)
    }
}
