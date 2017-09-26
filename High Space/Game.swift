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
        firepower = FirePowerUpgrade(Power(175, 250, 0))
        shieldpower = ShieldUpgrade(ShieldPower(140, 100))
        barrier = BarrierUpgrade(BarrierLayout(2000, 2))
        
        upgrades = [firepower, shieldpower, barrier]
    }
    
}

let playgame: Bool = true

class Game: DisplayLayer {
    
    static weak var instance: Game!
    
    let physics: Simulation
    let coordinator: Coordinator
    
    let map: Map
    
    let player_interface: PlayerInterface
    
    let scenery: Scenery
    
    let points: Int
    
    let enforcer: BehaviorRuleEnforcer
    
    var end_timer: Float = 0
    var wave_pause_timer: Float = 0
    var pausing: Bool = false
    
    var complete: Bool = false
   
    var mode: Int
    
    var start_timer: Float = 0
    var starting: Bool = true
    
    var final_battle: FinalBattle?
    
    var playing = true
    
    init(_ mode: Int) {
        Graphics.method.clear()
        ParticleSystem.current.clear()
        BulletSystem.current.clear()
        
        Time.scale = 1
        self.mode = mode
        
        BehaviorQueue.instance = BehaviorQueue()
        enforcer = BehaviorRuleEnforcer()
        
        map = Map(float2(20.m, 40.m))
        
        Map.current = map
        Camera.current = Camera()
        physics = Simulation(map.grid)
        
        let shield = PlayerShield(Float(40), Float(2), Float(20))
        shield.delegate = ShieldAudio()
        let health = Health(30, shield)
        upgrader.shieldpower.apply(shield)
        
        let green_fire = float4(0, 1, 0.5, 1)
        let purple_fire = float4(1, 1, 0.5, 1)
        let blend_fire = green_fire * (1 - upgrader.firepower.range.percent) + purple_fire * upgrader.firepower.range.percent
        
        let small_fire = float2(0.48.m, 0.144.m)
        let big_fire = float2(0.8.m, 0.16.m)
        let blend_size_fire = small_fire * (1 - upgrader.firepower.range.percent) + big_fire * upgrader.firepower.range.percent
        
        let firer = Firer(0.1075, Impact(15, 14.m + 2.m * upgrader.firepower.range.percent), Casing(blend_size_fire, blend_fire, "enemy"))
        
        var power = Power(175, 235, 30)
        upgrader.firepower.apply(&power)
        
        let player = Player(float2(map.size.x / 2, -1.5.m), health, firer, power)
        map.append(player)
        
        points = GameData.info.points
        coordinator = Coordinator(mode)
        coordinator.setWave(max(GameData.info.wave, 0))
        coordinator.next()
        
        start_timer = 2.5
        physics.halt()
        
        scenery = Scenery(map)
        
        end_timer = 2
       
        let sh = upgrader.shieldpower.range.percent
        player_interface = PlayerInterface(player, 10.m + 4.m * sh, 7.m + 1.m * sh)
        //player_interface.canFire = false
        
        scenery.castle.player = player
        
        createWalls(0.15.m)
        
        let constructor = BarrierConstructor(BarrierLayout(500, 2))
        upgrader.barrier.apply(constructor)
        scenery.castle.barriers = constructor.construct(-2.4.m)
        
        Game.instance = self
        
        if GameData.info.wave >= 50 {
            let audio = Audio("3 Emperor")
            audio.start()
            
            end_timer = 15
            
            final_battle = FinalBattle(Emperor.instance)
        }
        
        if let method = Graphics.method as? SortedRendererMethod {
            print(method.rootNode.describe())
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
    
    func endGame() {
        GameData.info.points = points
        
        let audio = Audio("1 Battle")
        audio.stop()
        
        UserInterface.fade {
            UserInterface.space.push(EndScreen(false))
        }
        playing = false
    }
    
    func update() {
        if !playing { return }
        
        let wind = Audio("wind")
        if !wind.playing {
            wind.loop = true
            wind.start()
        }
        
        let battle = Audio("1 Battle")
        if !battle.playing {
            battle.loop = true
            battle.volume = 0.75
            battle.start()
        }
        
        if death() {
            endGame()
        }
        
        if playgame {
            if !complete {
                coordinator.update()
            }
        }
        
        enforcer.update()
        map.update()
        physics.simulate()
        //Camera.current.update()
        
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
        
        if starting {
            start_timer += Time.delta
            if start_timer >= 2.5 {
                physics.unhalt()
                starting = false
                player_interface.canFire = true
            }
        }
        
        scenery.update()
        
        ParticleSystem.current.update()
        BulletSystem.current.update()
    }
    
    func start() {
        let audio = Audio("1 Battle")
        if !audio.playing {
            audio.loop = true
            audio.volume = 0.1
            audio.pitch = 1
            audio.start()
        }
    }
    
    deinit {
        let audio = Audio("1 Battle")
        audio.stop()
        let s = Audio("3 Emperor")
        s.stop()
        
        let wind = Audio("wind")
        wind.stop()
    }
    
    func end() {
        var screen: Screen = EndPrompt()
        if GameData.info.wave >= 50 {
            screen = GameCompleteScreen()
        }
        
        UserInterface.fade {
            UserInterface.space.wipe()
            UserInterface.space.push(screen)
        }
        
        let audio = Audio("1 Battle")
        audio.stop()
        
        let s = Audio("3 Emperor")
        s.stop()
        
        GameData.info.wave += 1
        GameData.info.points += 1
        GameData.persist()
        
        playing = false
    }
    
    func display() {
        scenery.render()
        Graphics.render()
        
        ParticleSystem.current.render()
        BulletSystem.current.render()
        
        if GameData.info.wave >= 50 {
            Emperor.instance?.render()
        }
        
//        if let method = Graphics.method as? SortedRendererMethod {
//            print(method.rootNode.describe())
//            //            for node in method.rootNode.nodes[0].nodes {
//            //                print(node.property.name + ": \(node.property.value)")
//            //            }
//        }
    }
}












