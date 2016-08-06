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
        Platform.atlas.act()
        
        srandom(UInt32(NSDate.timeIntervalSinceReferenceDate()))
        
        GameState.levelgateway = LevelInfoGateway(pack: "default")
        
        let gateway = ProfileGateway()
        gateway.createDirectory()
        
        if gateway.exists(gateway.getPath("user.plist")) {
            GameState.profile = gateway.retrieve("user")
        }else{
            GameState.profile = UserProfile(name: "user")
        }
        
        UserInterface.switchScreen(.Title)
        
        super.init()
        
        loadLevel("Factory")
    }
    
    func loadLevel(name: String) {
        UserInterface.setScreen(PrincipalScreen(GameState.levelgateway.retrieve(name)))
    }
    
    func update(processedTime: Float) {
        UserInterface.update()
    }
    
    func display() {
        UserInterface.display()
    }
    
}
