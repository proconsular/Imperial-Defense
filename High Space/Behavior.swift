//
//  Behavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 4/26/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol Behavior {
    var alive: Bool { get set }
    func update()
}
