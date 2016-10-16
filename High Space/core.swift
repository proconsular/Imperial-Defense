//
//  core.swift
//  Comm
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

let funmode = false

@objc class core: NSObject {
    
    override init() {
        UserInterface.create()
        
        let shipspace = ScreenSpace()
        
        shipspace.push(PrincipalScreen())
        
        UserInterface.set(space: shipspace)
        
        super.init()
    }
    
    func update() {
        UserInterface.update()
    }
    
    func display() {
        UserInterface.display()
    }
    
}

@objc class Time: NSObject {
    static var time: Float = 0
    
    static func set(_ time: Float) {
        self.time = time
    }
}
