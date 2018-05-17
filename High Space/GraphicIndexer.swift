//
//  GraphicIndexer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 7/27/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol GraphicIndexer {
    func computeIndices(_ count: Int) -> [UInt16]
}
