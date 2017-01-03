//
//  Screen.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/2/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

open class Screen: Interface {
    var layers: [DisplayLayer] = []
    
    func update() {
        layers.forEach{$0.update()}
    }
    
    func display() {
        layers.forEach{$0.display()}
    }
    
    func use(_ command: Command) {
        Trigger.process(command) { [unowned self] (command) in
            self.layers.reversed().forEach{$0.use(command)}
        }
    }
}
