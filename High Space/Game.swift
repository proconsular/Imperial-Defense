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
    //let grid: Grid
    
    let physics: Simulation
    let lighting: LightingSystem
    let levelmaker: LevelMaker
    let dreathmap: DreathMap
    
    let map: Map
    
    let roommap: RoomMap
    let room: Room
    
    var old = false
    
    init() {
        levelmaker = LevelMaker()
        roommap = RoomMap(8, float2(30.m))
        roommap.generate()
        let gen = RoomGenerator()
        room = gen.generate(roommap)
        var start = float2()
        
        if old {
            start = float2(Camera.size.x / 2, -2.m)
            map = Map(float2(Game.levelsize, 10.m))
            levelmaker.create(map)
            let height = 10.m - 0.1.m
            
            map.append(Structure(float2(0, -height / 2), float2(0.25.m, height)))
            map.append(Structure(float2(Game.levelsize - 0.1.m, -height / 2), float2(0.25.m, height)))
            
            let count = Int(Game.levelsize / 10.m)
            for i in 0 ..< count {
                map.append(Structure(float2(Float(i) * 10.m + 5.m, -height), float2(10.m, 0.25.m)))
            }
            Camera.clip = true
        }else{
            map = room.map
            start = float2(6.m, -30.m)
            Camera.clip = true
        }
        
        lighting = LightingSystem(map.grid)
        physics = Simulation(map.grid)
        dreathmap = DreathMap(map)
        
        let targetter = DreathTargetter(map)
        player = Player(start, Weapon(map, "dreath", targetter, Weapon.Stats(100, 15, 0.15, 65, 50)))
        targetter.player = player
        
        map.append(player)
        
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
        dreathmap.update()
        map.update()
        physics.simulate()
        Camera.update()
    }
    
    func display() {
        //lighting.render()
        map.render()
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













