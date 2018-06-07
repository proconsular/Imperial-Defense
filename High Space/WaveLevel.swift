//
//  WaveLevel.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class WaveLevel: GameElement {
    let coordinator: Coordinator
    var timer: Counter
    
    init() {
        coordinator = Coordinator(GameData.info.wave)
        timer = Counter(0.05)
    }
    
    func activate() {
        coordinator.next()
        setDebugBoss()
        startMusic()
    }
    
    private func setDebugBoss() {
        if debugBoss {
            var amount: Float = 0
            if bossStage == 1 {
                amount = 0.25
            }else if bossStage == 2 {
                amount = 0.5
            }else if bossStage == 3 {
                amount = 0.75
            }else if bossStage == 4 {
                amount = 0.9
            }
            Emperor.instance.health.stamina.damage(Emperor.instance.health.stamina.points.amount * amount)
        }
    }
    
    private func startMusic() {
        MusicSystem.instance.flush()
        if GameData.info.wave + 1 >= 101 {
            MusicSystem.instance.append(MusicEvent("Boss_intro"))
            MusicSystem.instance.append(MusicEvent("Boss_main", true))
        }else{
            MusicSystem.instance.append(MusicEvent("Battle_intro"))
            MusicSystem.instance.append(MusicEvent("Battle_main", true))
        }
    }
    
    var complete: Bool {
        return coordinator.empty
    }
    
    func update() {
        if isLevelFailed() {
            Game.showFailScreen()
        }
        coordinator.update()
        timer.update(Time.delta) {
            WaveOrganizer.organize()
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
    
}
