//
//  PointController.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class PointController: Controller {
    let id: Int
    
    init(_ id: Int) {
        self.id = id
    }
    
    func apply(_ location: float2) -> Command? {
        var command = Command(id)
        command.vector = location * 1 / GameScreen.scale.y
        return command
    }
    
}
