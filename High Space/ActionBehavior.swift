//
//  ActionBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ActionBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = false
    
    var action: () -> ()
    
    init(_ action: @escaping () -> ()) {
        self.action = action
    }
    
    func activate() {
        action()
    }
    
    func update() {
        
    }
}
