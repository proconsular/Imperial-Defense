//
//  Game.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

class Game: DisplayLayer {
    
    let physics: Simulation
    let coordinator: Coordinator
    
    let player: Player
    let map: Map
    
    let scenery: Scenery
    
    let points: Int
    
    var end_timer: Float = 0
    var wave_pause_timer: Float = 0
    var pausing: Bool = false
    
    var mode: Int
    
    var barriers: [Barrier]
    
    init(_ mode: Int) {
        self.mode = mode
        
        Data.info.level = 0
        
        map = Map(float2(20.m, 40.m))
        
        Camera.create(map)
        physics = Simulation(map.grid)
        player = Player(float2(map.size.x / 2, -1.m))
        map.append(player)
        
        points = Data.info.points
        coordinator = Coordinator(mode)
        coordinator.setWave(max(Data.info.wave - 1, 0))
        
        scenery = Scenery(map)
        
        barriers = []
        
        createWalls(0.15.m)
        createBarriers(3, -2.8.m, int2(10, 4))
    }
    
    func createBarriers(_ amount: Int, _ height: Float, _ size: int2) {
        for i in 0 ..< amount {
            let div = map.size.x / Float(amount)
            barriers.append(Barrier(float2(div / 2 + div * Float(i), height), size))
        }
    }
    
    func createWalls(_ width: Float) {
        map.append(Structure(float2(map.size.x / 2, 0), float2(map.size.x, width)))
        map.append(Structure(float2(map.size.x / 2, -map.size.y), float2(map.size.x, width)))
        map.append(Structure(float2(0, -map.size.y / 2), float2(width, map.size.y)))
        map.append(Structure(float2(map.size.x, -map.size.y / 2), float2(width, map.size.y)))
    }
    
    func victory() {
        UserInterface.space.push(EndScreen(true))
        Data.info.level += 1
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
            end_timer += Time.time
            if end_timer >= 2 {
                victory()
            }
        }
        if death() {
            play("death")
            UserInterface.space.push(EndScreen(false))
        }
        
        if coordinator.empty {
            Data.info.wave += 1
            Data.persist()
            if Data.info.points >= 50 {
                wave_pause_timer = 1
                pausing = true
            }
        }
        
        if pausing {
            wave_pause_timer -= Time.time
            if wave_pause_timer <= 0 {
                UserInterface.push(BonusScreen(self))
                pausing = false
            }
        }
        
        coordinator.update()
        map.update()
        physics.simulate()
        Camera.update()
    }
    
    func display() {
        scenery.render()
        map.render()
    }
}












