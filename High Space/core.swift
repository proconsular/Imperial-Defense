//
//  core.swift
//  Comm
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation
import Accelerate

let funmode = false

@objc
class core: NSObject {
    
    override init() {
        srandom(UInt32(NSDate.timeIntervalSinceReferenceDate()))
        
        UserInterface.setScreen(PrincipalScreen())
        
        super.init()
    }
    
    func update() {
        UserInterface.update()
    }
    
    func display() {
        UserInterface.display()
    }
    
}
