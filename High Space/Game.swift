//
//  Region.swift
//  Comm
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class Game: DisplayLayer {
    
    let player: Player
    
    init() {
        
        player = Player(float2(6.m, -30.m))
        
        //Camera.transform.location = float2(1, -1) * 30.m / 2
        
        Camera.follow = player.transform
    }
    
    func victory() {
        UserInterface.space.push(EndScreen(ending: .victory))
    }
    
    func death() {
        if player.shield.points.amount <= 0 {
            UserInterface.space.push(EndScreen(ending: .lose))
        }
    }
    
    func use(_ command: Command) {
        player.use(command)
    }
    
    func update() {
        death()
    }
    
    func display() {
        
    }
}












