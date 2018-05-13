//
//  VictoryEvent.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

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
        
        let audio = Audio("Battle")
        audio.stop()
        
        let s = Audio("Emperor")
        s.stop()
        
        GameData.info.wave += 1
        GameData.info.points += 1
        GameData.persist()
        
        Game.instance.playing = false
    }
}
