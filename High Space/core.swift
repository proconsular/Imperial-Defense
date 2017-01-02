//
//  core.swift
//  Comm
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

import Foundation

let funmode = false

let defaultStyle = FontStyle("Metropolis-ExtraLight", float4(1), 72)
let defaultFont = "Metropolis-ExtraLight"

@objc class core: NSObject {
    
    override init() {
        UserInterface.create()
        Data.create()
        
        let main = ScreenSpace()
        
        main.push(PrincipalScreen())
        //main.push(TitleScreen())
        //main.push(StoryScreen())
        
        UserInterface.set(space: main)
        
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
