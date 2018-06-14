//
//  VictoryEvent.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation
import StoreKit

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
        
        if GameData.info.wave + 1 < 101 {
            GameData.info.wave += 1
            GameData.info.points += 1
            if GameData.info.wave == 20 && !AppData.main.reviewed {
                SKStoreReviewController.requestReview()
                AppData.main.reviewed = true
                AppData.persist()
            }
        }
        GameData.persist()
        
        Game.instance.playing = false
    }
}
