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
        MusicSystem.instance.flush()
        MusicSystem.instance.append(MusicEvent("Tutorial", true))
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
        GameData.info.tutorial = false
        GameData.persist()
    }
}
