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
    let ship: Structure
    
    let level: Level
    
    init(_ level: Level) {
        self.level = level
        
        let targetter = DreathTargetter(level)
        player = Player(float2(6.m, -30.m), Weapon(level, "dreath", targetter, Weapon.Stats(100, 12.5, 0.125, 65, 50)))
        targetter.player = player
        
        level.current.map.append(player)
        
        let size = float2(3.m, 1.m)
        ship = Structure(float2(6.m, -level.current.size.y + 3.m - size.y / 2), size)
        ship.display.color = float4(1, 1, 1, 1)
        ship.body.hidden = true
        ship.body.tag = "ship"
        ship.display.texture = GLTexture("starship").id
        level.current.map.append(ship)
        
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
    
    deinit {
        level.current.map.remove(player)
        level.current.map.remove(ship)
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













