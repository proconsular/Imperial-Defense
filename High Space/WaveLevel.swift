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
            separate()
            enforceDrawOrder()
        }
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
    
    func enforceDrawOrder() {
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
    
}
