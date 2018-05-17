//
//  SoldierTerminator.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class SoldierTerminator: ActorTerminationDelegate {
    unowned let soldier: Soldier
    
    init(_ soldier: Soldier) {
        self.soldier = soldier
    }
    
    func terminate() {
        let a = Audio("enemy-death")
        a.volume = 0.005
        a.pitch = random(0.9, 1.1)
        //a.start()
    }
}
