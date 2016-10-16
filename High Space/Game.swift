//
//  Region.swift
//  Comm
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2015 FishyTale Digital, Inc. All rights reserved.
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
    
    init() {
        map = Map(float2(20.m, 40.m))
        Map.current = map
        
        let cs = 3.m
        castle = Display(Rect(float2(map.size.x / 2, -cs / 2), float2(map.size.x, cs)), GLTexture("stonefloor"))
        castle.scheme.layout.coordinates = [float2(0, 0), float2(0.5, 0), float2(0.5, 2.5), float2(0, 2.5)]
        castle.color = float4(0.75, 0.75, 0.75, 1)
        floor = Display(Rect(float2(map.size.x / 2, -map.size.y / 2), map.size), GLTexture("rockfloor"))
        floor.scheme.layout.coordinates = [float2(0, 0), float2(6, 0), float2(6, 3), float2(0, 3)]
        floor.color = float4(0.25, 0.25, 0.25, 1)
        
        player = Player(float2(map.size.x / 2, -1.m))
        
        map.append(player)
        
        map.append(Structure(float2(map.size.x / 2, 0), float2(map.size.x, 0.5.m)))
        map.append(Structure(float2(map.size.x / 2, -map.size.y), float2(map.size.x, 0.5.m)))
        map.append(Structure(float2(0, -map.size.y / 2), float2(0.5.m, map.size.y)))
        map.append(Structure(float2(map.size.x, -map.size.y / 2), float2(0.5.m, map.size.y)))
        
        //map.append(Soldier(float2(5.m, -10.m)))
        
        barriers = []
        
        let ba = 4
        
        for i in 0 ..< ba {
            let div = map.size.x / Float(ba)
            barriers.append(Barrier(float2(div / 2 + div * Float(i), -3.2.m), int2(10, 5)))
        }
        
        Camera.clip = false
        
        Camera.transform.location = float2(map.size.x / 2, 0) + float2(-Camera.size.x / 2, -Camera.size.y)
        
        physics = Simulation(map.grid)
        
        coordinator = Coordinator(1 * (Score.level + 1))
    }
    
    func victory() {
        UserInterface.space.push(WinScreen())
    }
    
    func death() {
        if player.shield.points.amount <= 0 {
            UserInterface.space.push(EndScreen(ending: .lose))
        }
        map.actors.forEach{
            if let s = $0 as? Soldier {
                if s.body.location.y >= -4.m {
                    UserInterface.space.push(EndScreen(ending: .lose))
                    return
                }
            }
        }
    }
    
    func use(_ command: Command) {
        player.use(command)
    }
    
    func update() {
        if coordinator.waves.count == 0 {
            victory()
        }
        death()
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












