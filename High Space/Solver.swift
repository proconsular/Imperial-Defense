//
//  Solver.swift
//  Raeximu
//
//  Created by Chris Luttio on 9/13/15.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol Solver {
    static func solve (_ primary: Body, _ secondary: Body) -> Collision?
}
