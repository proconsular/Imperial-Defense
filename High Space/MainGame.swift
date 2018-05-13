//
//  core.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol GameInterface {
    func update()
    func render()
}

@objc class MainGame: NSObject {
    let interface: GameInterface
    
    override init() {
        GameScreen.create()
        interface = GameBase()
        super.init()
    }
    
    @objc func update() {
        interface.update()
    }
    
    @objc func display() {
        interface.render()
    }
}
