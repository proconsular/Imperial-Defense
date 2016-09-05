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
    let grid: Grid
    
    let physics: Simulation
    let lighting: LightingSystem
    let levelmaker: LevelMaker
    let dreathmap: DreathMap
    
    init() {
        grid = Grid(10.m, float2(Game.levelsize, 10.m))
        
        lighting = LightingSystem(grid)
        physics = Simulation(grid)
        dreathmap = DreathMap(grid)
        levelmaker = LevelMaker(grid)
        
        let targetter = DreathTargetter(grid)
        player = Player(float2(Camera.size.x / 2, -2.m), Weapon(grid, "dreath", targetter))
        targetter.player = player
        
        let height = 10.m - 0.1.m
        
        grid.append(Structure(float2(0, -height / 2), float2(0.25.m, height)))
        grid.append(Structure(float2(Game.levelsize - 0.1.m, -height / 2), float2(0.25.m, height)))
        
        let count = Int(Game.levelsize / 10.m)
        for i in 0 ..< count {
            grid.append(Structure(float2(Float(i) * 10.m + 5.m, -height), float2(10.m, 0.25.m)))
        }
        
        grid.append(player)
        
        Camera.follow = player.transform
    }
    
    func victory() {
        UserInterface.setScreen(EndScreen(ending: .Victory))
    }
    
    func death() {
        if player.shield.points.amount <= 0 {
            UserInterface.setScreen(EndScreen(ending: .Lose))
        }
    }
    
    func use(command: Command) {
        player.use(command)
    }
    
    func update() {
        death()
        dreathmap.update()
        grid.update()
        physics.simulate()
        Camera.update()
    }
    
    func display() {
        //lighting.render()
        grid.render()
    }
}

class LevelMaker {
    var maker: MasterMaker!
    
    init(_ grid: Grid) {
        let assm = Assembler()
        let floormaker = FloorSuperMaker(Game.levelsize)
        floormaker.characters.append(SpawnerMaker())
        assm.makers.append(floormaker)
        
        maker = MasterMaker(assm, Game.levelsize) {
            true
        }
        
        let count = Int(Game.levelsize / 10.m)
        
        for _ in 0 ..< count {
            maker.make().forEach(grid.append)
        }
    }
    
}













