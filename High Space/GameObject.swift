//
//  GameObject.swift
//  Comm
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

protocol Displayable {
    func display ()
}

protocol GameObject: Displayable {
    
    func update (processedTime: Float)
    func display ()
    
}