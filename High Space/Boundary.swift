//
//  Boundary.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/19/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Boundary {
    static func checkPlayer() {
        if let player = Player.player {
            let transform = player.transform
            let size = 0.55.m
            if transform.location.x < size {
                transform.location.x = size
            }
            if transform.location.x > Camera.size.x - size {
                transform.location.x = Camera.size.x - size
            }
        }
    }
}
