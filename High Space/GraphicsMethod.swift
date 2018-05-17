//
//  RenderFactory.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 7/28/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol GraphicsMethod {
    func create(_ info: GraphicsInfo)
    func clear()
    
    func update()
    func render()
}














