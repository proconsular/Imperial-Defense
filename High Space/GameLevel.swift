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
            audio.volume = 0.5
            audio.start()
        }
        
        let wind = Audio("wind")
        if !wind.playing {
            wind.loop = true
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
        
        Game.instance.playing = false
    }
    
}
























