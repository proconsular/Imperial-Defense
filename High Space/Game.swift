//
//  Region.swift
//  Comm
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

let clear = false

let kScale = Camera.size / float2(1136, 640)
let debug = false
let hasClaw = false

func measureTime(@autoclosure block: () -> ()) -> Double {
    let time = NSDate.timeIntervalSinceReferenceDate()
    block()
    return NSDate.timeIntervalSinceReferenceDate() - time
}

class GameInfo {
    
    let level: LevelInfo
    let enemygateway: BotInfoGateway
    let powerupgateway: PowerupInfoGateway
    
    var length: Float {
        return 500.m + Float(level.order) + 100.m
    }
    
    init(_ level: LevelInfo) {
        self.level = level
        enemygateway = BotInfoGateway(level.pack)
        powerupgateway = PowerupInfoGateway(level.pack)
    }
    
    var energy_rate: Float {
        return powerupgateway.retrieve(level.powerup).rate / 60.0
    }
    
}

class Game: DisplayLayer {
    
    var active = true
    
    let controller: GameController
    
    init (_ level: LevelInfo) {
        let info = GameInfo(level)
        controller = GameController(info)
    }
    
    func use(command: Command) {
        controller.cast.principal.use(command)
    }
    
    func resume() {
        active = true
        Simulation.unhalt()
    }
    
    func pause() {
        active = false
        Simulation.halt()
    }
    
    func update() {
        controller.update()
    }
    
    func display() {
        //environment.render()
        controller.render()
    }
    
}

















