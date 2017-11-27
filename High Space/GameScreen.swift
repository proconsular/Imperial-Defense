//
//  GameScreen.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/26/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class GameScreen {
    static var scale = float2()
    static var size = float2(2001, 1125)
    
    static func create() {
        scale = Camera.size / size
    }
}
