//
//  GraphicsRenderer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

protocol GraphicsRenderer {
    func append(_ info: GraphicsInfo)
    func compile()
    func update()
    func render()
}
