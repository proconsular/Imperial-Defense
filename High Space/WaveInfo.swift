//
//  WaveInfo.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

protocol WaveInfo {
    var depth: Int { get }
    var max: Int { get }
    var startWidth: Int { get }
}
