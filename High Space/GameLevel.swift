//
//  GameLevel.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/26/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol GameEvent {
    var complete: Bool { get }
    func activate()
}

protocol GameElement: GameEvent {
    func update()
}

protocol GameLayer: GameElement {
    func use(_ command: Command)
    func render()
}

class WaitElement: GameElement {
    var counter, limit: Float
    
    init(_ limit: Float) {
        self.limit = limit
        counter = 0
    }
    
    var complete: Bool {
        return counter >= limit
    }
    
    func activate() {
        counter = 0
    }
    
    func update() {
        counter += Time.delta
    }
    
}

class TutorialLevel: GameLayer {
    let tutorial: Tutorial
    
    init(_ interface: PlayerInterface) {
        tutorial = Tutorial(interface)
    }
    
    func activate() {
        let music = Audio("Tutorial")
        music.loop = true
        music.start()
    }
    
    var complete: Bool {
        return tutorial.isComplete
    }
    
    func use(_ command: Command) {
        tutorial.use(command)
    }
    
    func update() {
        tutorial.update()
    }
    
    func render() {
        tutorial.render()
    }
    
    deinit {
        Audio.stop("Tutorial")
        GameData.info.tutorial = false
        GameData.persist()
    }
}

class WaveLevel: GameElement {
    let coordinator: Coordinator
    
    init() {
        coordinator = Coordinator(GameData.info.wave)
    }
    
    func activate() {
        coordinator.next()
        
        let audio = Audio("1 Battle")
        if !audio.playing {
            audio.loop = true
            audio.volume = 1
            audio.start()
        }
        
        let wind = Audio("wind")
        if !wind.playing {
            wind.loop = true
            wind.volume = 0.25
            wind.start()
        }
    }
    
    var complete: Bool {
        return coordinator.empty
    }
    
    func update() {
        if isLevelFailed() {
            showFailScreen()
        }
        coordinator.update()
        separate()
        computeDrawOrder()
    }
    
    func separate() {
        let solver = RectSolver()
        let soldiers = Map.current.actorate.actors.filter{ $0 is Soldier }.map{ $0 as! Soldier }
        for n in 0 ..< soldiers.count {
            let a = soldiers[n]
            for m in n + 1 ..< soldiers.count {
                let b = soldiers[m]
                let dl = b.transform.location - a.transform.location
                if dl.length >= 2.m { continue }
                let a_rect = Rect(a.transform.location, float2(75, 50))
                let b_rect = Rect(b.transform.location, float2(75, 50))
                if a_rect.getBounds().intersects(b_rect.getBounds()) {
                    if let collision = solver.solve(a_rect, b_rect) {
                        a.body.velocity += collision.penetration * -collision.normal * 0.05
                        b.body.velocity += collision.penetration * collision.normal * 0.05
                    }
                }
            }
        }
    }
    
    func computeDrawOrder() {
        var soldiers = Map.current.actorate.actors.filter{ $0 is Soldier }.map{ $0 as! Soldier }
        soldiers.sort{ $0.transform.location.y > $1.transform.location.y }
        for n in 0 ..< soldiers.count {
            let soldier = soldiers[n]
            soldier.material["order"] = -n - 10
        }
    }
    
    func isLevelFailed() -> Bool {
        for actor in Map.current.actorate.actors {
            if let s = actor as? Soldier {
                if s.body.location.y >= -4.m {
                    return true
                }
            }
        }
        return false
    }
    
    func showFailScreen() {
        Audio.stop("1 Battle")
        UserInterface.fade {
            UserInterface.space.push(EndScreen(false))
        }
        Game.instance.playing = false
    }
    
}

class VictoryEvent: GameEvent {
    var complete: Bool = true
    
    func activate() {
        var screen: Screen = EndPrompt()
        if GameData.info.wave >= 100 {
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
        
        Game.instance.playing = false
    }
    
}

class DebugLevel: GameLayer {
    var buttons: [TextButton]
    var mapper: SoldierMapper
    
    var army = false
    
    init() {
        mapper = SoldierMapper()
        buttons = []
        for i in 0 ..< 7 {
            let button = TextButton(Text("\(i + 2)"), float2(Float(i) * 1.5.m + 4.5.m, -Camera.size.y * 0.875)) { [unowned self] in
                let loc = float2(Camera.size.x / 2 + random(-2.m, 2.m), -Camera.size.y * 0.85)
                Map.current.append(self.mapper[i + 2].produce(loc))
                if self.army {
                    self.generateArmy(loc)
                }
            }
            buttons.append(button)
        }
        
        let loc = float2(Camera.size.x * 0.85, -Camera.size.y * 0.875)
        let text = Text("Army: \(army ? "On" : "Off")", FontStyle(defaultFont, float4(1), 48))
        buttons.append(ToggleTextButton(text, loc) { [unowned self] (active) in
            self.army = active
            text.setString("Army: \(self.army ? "On" : "Off")")
        })
    }
    
    func generateArmy(_ location: float2) {
        let sp_x: Float = 0.75.m
        let sp_y: Float = 1.m
        for x in 0 ..< 3 {
            let sx = Float(x - 1) * sp_x
            for y in 0 ..< 3 {
                if x == 1 && y == 1 { continue }
                let sy = Float(y - 1) * sp_y
                Map.current.append(Infrantry(float2(sx, sy) + location))
            }
        }
    }
    
    var complete: Bool {
        return false
    }
    
    func activate() {
        
    }
    
    func use(_ command: Command) {
        Trigger.process(command) { (command) in
            buttons.forEach{ $0.use(command) }
        }
    }
    
    func update() {
        
        if let player = Player.player {
            if let shield = player.health.shield {
                shield.points.amount = shield.points.limit
            }
        }
        
        removeSoldiers()
    }
    
    func removeSoldiers() {
        for actor in Map.current.actorate.actors {
            if let s = actor as? Soldier {
                if s.body.location.y >= -4.m {
                    s.alive = false
                }
            }
        }
    }
    
    func render() {
        buttons.forEach{ $0.render() }
    }
    
}
























