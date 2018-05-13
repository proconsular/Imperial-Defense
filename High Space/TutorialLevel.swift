//
//  TutorialLevel.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

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
