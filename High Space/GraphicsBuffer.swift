//
//  GraphicsBuffer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

protocol GraphicsBuffer {
    var data: [GraphicsInfo] { get set }
    var buffer: BufferSet { get }
    
    func refresh()
}
