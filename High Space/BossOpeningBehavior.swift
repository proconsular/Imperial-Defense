//
//  BossOpeningBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class BossOpeningBehavior: BossBehavior {
    override func replace() {
        if index + 1 >= behaviors.count {
            alive = false
        }
        super.replace()
    }
}
