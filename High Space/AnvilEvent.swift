//
//  AnvilEffect.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/6/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class AnvilEvent: Event {
    var frames: [Int]
    
    init(_ frames: [Int]) {
        self.frames = frames
    }
    
    func activate() {
        let thunder = Audio("forge-hit")
        thunder.pitch = random(0.9, 1.1)
        thunder.volume = sound_volume
        thunder.start()
    }
}
