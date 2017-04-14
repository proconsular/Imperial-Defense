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

class Upgrader {
    
    let firepower: FirePowerUpgrade
    let shieldpower: ShieldUpgrade
    let barrier: BarrierUpgrade
    
    var upgrades: [Upgrade]
    
    init() {
        firepower = FirePowerUpgrade(Impact(15, 2.5.m))
        shieldpower = ShieldUpgrade(ShieldPower(140, 100))
        barrier = BarrierUpgrade(BarrierLayout(100, 2))
        
        upgrades = [firepower, shieldpower, barrier]
    }
    
}

let playgame: Bool = true

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
    
    var complete: Bool = false
   
    var mode: Int
    
    var barriers: [Wall]
    
    init(_ mode: Int) {
        Time.scale = 1
        self.mode = mode
        
        map = Map(float2(20.m, 40.m))
        
        Map.current = map
        Camera.current = Camera(map)
        physics = Simulation(map.grid)
        
        let shield = Shield(Float(40), Float(2), Float(20))
        shield.delegate = ShieldAudio()
        let health = Health(30, shield)
        upgrader.shieldpower.apply(shield)
        
        let firer = Firer(0.1075, Impact(15, 14.m), Casing(float2(0.4.m, 0.12.m) * 1.2, float4(0, 1, 0.5, 1), "enemy"))
        upgrader.firepower.apply(firer)
        
        player = Player(float2(map.size.x / 2, -1.5.m), health, firer)
        map.append(player)
        
        points = GameData.info.points
        coordinator = Coordinator(mode)
        coordinator.setWave(max(GameData.info.wave, 0))
        
        scenery = Scenery(map)
        
        end_timer = 2
        barriers = []
        
        player_interface = PlayerInterface(player, 10.m, 7.m)
        
        createWalls(0.15.m)
        
        let constructor = BarrierConstructor(BarrierLayout(10, 2))
        upgrader.barrier.apply(constructor)
        barriers = constructor.construct(-2.4.m, int2(10, 4))
        
//        let audio = Audio("2 Imperial")
//        if !audio.playing {
//            audio.loop = true
//            audio.volume = 0.5
//            audio.pitch = 1
//            audio.start()
//        }
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
        
        if playgame {
            if !complete {
                coordinator.update()
            }
        }
        
        map.update()
        physics.simulate()
        Camera.current.update()
        
        if playgame {
            if coordinator.empty {
                complete = true
            }
            if complete {
                end_timer -= Time.delta
                if end_timer <= 0 {
                    end()
                }
            }
        }
    }
    
    func end() {
        GameData.info.wave += 1
        GameData.persist()
        if GameData.info.wave >= 50 {
            UserInterface.space.push(EndScreen(true))
        }else{
            UserInterface.space.push(StoreScreen())
        }
    }
    
    func display() {
        scenery.render()
        map.render()
    }
}












