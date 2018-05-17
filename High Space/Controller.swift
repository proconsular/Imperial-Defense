//
//  Controller.swift
//  Relaci
//
//  Created by Chris Luttio on 9/16/14.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

protocol Controller {
    func apply (_ location: float2) -> Command?
}
