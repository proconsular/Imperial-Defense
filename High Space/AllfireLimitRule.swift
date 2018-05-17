//
//  AllfireLimitRule.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class AllfireLimitRule: BehaviorRule {
    var id = "allfire"
    var counter: Float = 0
    let rate: Float
    
    init(_ rate: Float) {
        self.rate = rate
    }
    
    func legal() -> Bool {
        if counter >= rate {
            counter = 0
            return true
        }
        return false
    }
    
    func update() {
        counter += Time.delta
    }
}
