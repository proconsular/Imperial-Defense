//
//  BossMarchEvent.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/28/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class BossMarchEvent: MarchEvent {
    
    override func activate() {
        super.activate()
        Audio.play("boss_step", 0.25)
    }
    
}
