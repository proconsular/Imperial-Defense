//
//  WaveOrganizer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/6/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class WaveOrganizer {
    
    static func organize() {
        separate()
        enforceDrawOrder()
    }
    
    static func separate() {
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
    
    static func enforceDrawOrder() {
        var soldiers = Map.current.actorate.actors.filter{ $0 is Soldier }.map{ $0 as! Soldier }
        soldiers.sort{ $0.transform.location.y > $1.transform.location.y }
        for n in 0 ..< soldiers.count {
            let soldier = soldiers[n]
            soldier.material["order"] = -n - 10
        }
    }
    
}
