//
//  Region.swift
//  Comm
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class Game: DisplayLayer {
    
    static let levelsize = 20.m
    
    let player: Player
    
    let level: Level
    
    init() {
        level = Level(0)
        
        let targetter = DreathTargetter(level)
        player = Player(float2(6.m, -30.m), Weapon(level, "dreath", targetter, Weapon.Stats(100, 12.5, 0.125, 65, 50)))
        targetter.player = player
        
        level.current.map.append(player)
        
        //Camera.transform.location = float2(1, -1) * 30.m / 2
        
        Camera.follow = player.transform
    }
    
    func victory() {
        UserInterface.setScreen(EndScreen(ending: .victory))
    }
    
    func death() {
        if player.shield.points.amount <= 0 {
            UserInterface.setScreen(EndScreen(ending: .lose))
        }
    }
    
    func use(_ command: Command) {
        player.use(command)
    }
    
    func update() {
        death()
        level.update()
    }
    
    func display() {
        level.render()
    }
}

class LevelMaker {
    var maker: MasterMaker!
    
    init() {
        let assm = Assembler()
        let floormaker = FloorSuperMaker(Game.levelsize)
        floormaker.characters.append(SpawnerMaker())
        assm.makers.append(floormaker)
        maker = MasterMaker(assm, Game.levelsize) { true }
    }
    
    func create(_ map: Map) {
        let count = Int(Game.levelsize / 10.m)
        for _ in 0 ..< count {
            maker.make().forEach(map.append)
        }
    }
    
}













