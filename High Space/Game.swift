//
//  Region.swift
//  Comm
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Game: DisplayLayer {
    
    let physics: Simulation
    let coordinator: Coordinator
    
    let player: Player
    let map: Map
    
    let castle: Display
    let floor: Display
    
    var barriers: [Barrier]
    
    let points: Int
    
    var win_timer: Float = 0
    
    init() {
        points = Data.info.points
        //Game.jump()
        
        //Data.level = 10
        //Data.points = 100
        map = Map(float2(20.m, 40.m))
        Map.current = map
        
        let cs = 2.5.m
        castle = Display(Rect(float2(map.size.x / 2, -cs / 2), float2(map.size.x, cs)), GLTexture("stonefloor"))
        let scale_c: Float = 2
        castle.scheme.layout.coordinates = [float2(0, 0), float2(0.5, 0) * scale_c, float2(0.5, 3) * scale_c, float2(0, 3) * scale_c]
        castle.color = float4(0.7, 0.7, 0.7, 1)
        
        floor = Display(Rect(float2(map.size.x / 2, -map.size.y / 2), map.size), GLTexture("rockfloor"))
        let scale_f: Float = 1
        floor.scheme.layout.coordinates = [float2(0, 0), float2(6, 0) * scale_f, float2(6, 3) * scale_f, float2(0, 3) * scale_f]
        floor.color = float4(0.5, 0.4, 0.4, 1)
        
        player = Player(float2(map.size.x / 2, -1.m))
        
        map.append(player)
        map.append(Structure(float2(map.size.x / 2, 0), float2(map.size.x, 0.5.m)))
        map.append(Structure(float2(map.size.x / 2, -map.size.y), float2(map.size.x, 0.5.m)))
        map.append(Structure(float2(0, -map.size.y / 2), float2(0.5.m, map.size.y)))
        map.append(Structure(float2(map.size.x, -map.size.y / 2), float2(0.5.m, map.size.y)))
        
        barriers = []
        
        let ba = 4
        
        for i in 0 ..< ba {
            let div = map.size.x / Float(ba)
            barriers.append(Barrier(float2(div / 2 + div * Float(i), -3.2.m), int2(10, 5)))
        }
        
        Camera.clip = false
        Camera.transform.location = float2(map.size.x / 2, 0) + float2(-Camera.size.x / 2, -Camera.size.y)
        
        physics = Simulation(map.grid)
        
        coordinator = Coordinator()
    }
    
    static func jump() {
        Data.info.level = 21
        Data.info.health.range.amount = 10
        Data.info.machine.range.amount = 10
        Data.info.movement.range.amount = 10
        //Upgrades.bombgun.range.amount = 10
        //Upgrades.sniper.range.amount = 10
        Data.info.barrier.range.amount = 10
    }
    
    func victory() {
        UserInterface.space.push(WinScreen())
        Data.persist()
    }
    
    func death() -> Bool {
        if player.shield.points.amount <= 0 {
            return true
        }
        for actor in map.actors {
            if let s = actor as? Soldier {
                if s.body.location.y >= -4.m {
                    return true
                }
            }
        }
        return false
    }
    
    func use(_ command: Command) {
        player.use(command)
    }
    
    func update() {
        if coordinator.waves.count == 0 {
            win_timer += Time.time
            if win_timer >= 2 {
                victory()
            }
        }
        if death() {
            Data.info.points = points
            UserInterface.space.push(EndScreen(ending: .lose))
        }
        coordinator.update()
        map.update()
        physics.simulate()
        Camera.update()
    }
    
    func display() {
        floor.render()
        castle.render()
        map.render()
    }
}












