//
//  ScreenSpace.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/2/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class ScreenSpace: Stack<Screen>, Interface {
    
    func use(_ command: Command) {
        peek?.use(command)
    }
    
    func update() {
        peek?.update()
    }
    
    func display() {
        for screen in contents {
            screen.display()
        }
    }
    
}
