//
//  Director.swift
//  Comm
//
//  Created by Chris Luttio on 8/27/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

protocol Director {
    func update (processedTime: Float)
}

protocol Agent: class {
   var director: Director? { get set }
}