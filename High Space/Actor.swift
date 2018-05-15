//
//  Actor.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol Actor: class {
    var alive: Bool { get set }
    func update()
}
