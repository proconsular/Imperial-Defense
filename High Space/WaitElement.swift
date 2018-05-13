//
//  WaitElement.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class WaitElement: GameElement {
    var counter, limit: Float
    
    init(_ limit: Float) {
        self.limit = limit
        counter = 0
    }
    
    var complete: Bool {
        return counter >= limit
    }
    
    func activate() {
        counter = 0
    }
    
    func update() {
        counter += Time.delta
    }
}
