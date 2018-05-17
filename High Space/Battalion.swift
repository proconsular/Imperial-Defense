//
//  Battalion.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

protocol Battalion {
    var health: Int { get }
    func update()
}
