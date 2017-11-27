//
//  Types.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol PlayerEvent {
    func isActive() -> Bool
    func trigger()
}

protocol PlayerAnimation {
    func update()
}
