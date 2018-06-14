//
//  AppData.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class AppData {
    static var main: AppData!
    
    var reviewed: Bool
    
    init() {
        reviewed = false
    }
    
    static func persist() {
        let defaults = UserDefaults.standard
        defaults.set(main.reviewed, forKey: "reviewed")
    }
    
    static func retrieve() {
        main = AppData()
        let defaults = UserDefaults.standard
        main.reviewed = defaults.bool(forKey: "reviewed")
    }
}
