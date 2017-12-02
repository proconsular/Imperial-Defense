//
//  Game.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

class Game: DisplayLayer {
    static weak var instance: Game!
    
    let level: Level
    let sequence: EventSequence
    let interface: PlayerInterface
    
    var layers: [GameDisplayLayer] = []
    var playing: Bool = true
    
    init() {
        GameSystem.start()
        
        level = Level()
        sequence = EventSequence()
        
        Map.current.append(GameCreator.createPlayer())
        interface = GameCreator.createInterface()
        
        Game.instance = self
    }
    
    func use(_ command: Command) {
        interface.use(command)
        sequence.use(command)
    }
    
    func update() {
        if !playing { return }
        level.update()
        sequence.update()
        layers.forEach{ $0.update() }
        GameSystem.update()
    }
    
    func display() {
        level.render()
        GameSystem.render()
        sequence.render()
        layers.forEach{ $0.render() }
    }
    
    deinit {
        Audio.stop("1 Battle")
        Audio.stop("3 Emperor")
        Audio.stop("wind")
    }
}












