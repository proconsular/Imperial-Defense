//
//  BehaviorRequest.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class BehaviorRequest {
    let id: String
    let behavior: TriggeredBehavior
    
    init(_ id: String, _ behavior: TriggeredBehavior) {
        self.id = id
        self.behavior = behavior
    }
}
