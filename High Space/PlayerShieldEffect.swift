//
//  PlayerShieldEffect.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class PlayerShieldEffect: ShieldDelegate {
    unowned let transform: Transform
    
    init(_ transform: Transform) {
        self.transform = transform
    }
    
    func recover(_ percent: Float) {
        if percent < 0.9 {
            Map.current.append(Halo(transform.location, 3.25.m))
        }
    }
    
    func damage() {
        
    }
}
