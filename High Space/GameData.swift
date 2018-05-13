//
//  Data.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class GameData {
    static var info = GameInfo.Default
    
    private static var gateway: Gateway<GameInfo> = GameDefaultsGateway()
    
    static func create() {
        if let loadedInfo = gateway.retrieve(name: "default") {
            info = loadedInfo
        }
    }
    
    static func persist() {
        gateway.persist(item: info)
    }
    
    static func reset() {
        info = GameInfo.Default
        upgrader = Upgrader()
        persist()
    }
    
}



