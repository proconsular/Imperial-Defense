//
//  StandardConfig.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/1/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class StandardConfig: GameConfig {
    func configure() {
        let main = ScreenSpace()
        main.push(Splash())
        UserInterface.set(space: main)
    }
}
