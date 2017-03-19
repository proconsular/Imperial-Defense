//
//  Game.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

class GameScreen {
    static var scale = float2()
    static var size = float2(2001, 1125)
    
    static func create() {
        scale = Camera.size / size
    }
}

class Game: DisplayLayer {
    
    let physics: Simulation
    let coordinator: Coordinator
    
    let player: Player
    let map: Map
    
    let player_interface: PlayerInterface
    
    let scenery: Scenery
    
    let points: Int
    
    var end_timer: Float = 0
    var wave_pause_timer: Float = 0
    var pausing: Bool = false
   
    var mode: Int
    
    var barriers: [Barrier]
    
    init(_ mode: Int) {
        Time.scale = 1
        self.mode = mode
        
        GameData.info.level = 0
        
        map = Map(float2(20.m, 40.m))
        
        Map.current = map
        Camera.current = Camera(map)
        physics = Simulation(map.grid)
        player = Player(float2(map.size.x / 2, -1.m))
        map.append(player)
        
        points = GameData.info.points
        coordinator = Coordinator(mode)
        coordinator.setWave(max(GameData.info.wave, 0))
        
        scenery = Scenery(map)
        
        barriers = []
        
        player_interface = PlayerInterface(player, 10.m, 7.m)
        
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
    
    func death() -> Bool {
        for actor in map.actorate.actors {
            if let s = actor as? Soldier {
                if s.body.location.y >= -4.m {
                    return true
                }
            }
        }
        return false
    }
    
    func use(_ command: Command) {
        player_interface.use(command)
    }
    
    func update() {
        if death() {
            play("death")
            UserInterface.space.push(EndScreen(false))
        }
        
        coordinator.update()
        map.update()
        physics.simulate()
        Camera.current.update()
        
        if coordinator.empty {
            GameData.info.wave += 1
            GameData.persist()
        }
    }
    
    func display() {
        scenery.render()
        map.render()
    }
}












