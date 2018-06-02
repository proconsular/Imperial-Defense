//
//  ScreenDebugConfig.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/1/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ScreenDebugConfig: GameConfig {
    let screen: Screen
    
    init(_ screen: Screen) {
        self.screen = screen
    }
    
    func configure() {
        let main = ScreenSpace()
        main.push(screen)
        UserInterface.set(space: main)
    }
}
