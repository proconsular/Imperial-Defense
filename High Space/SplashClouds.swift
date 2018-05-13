//
//  SplashClouds.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class SplashClouds {
    
    var clouds: [Display]
    
    init() {
        clouds = []
        for i in 0 ..< 4 {
            let m = 4 - i
            let cloud = Display(Rect(Camera.size / 2 + float2(random(-Camera.size.x / 2, Camera.size.x / 2), -GameScreen.size.y), Camera.size), GLTexture("Splash_Cloud_\(m)"))
            clouds.append(cloud)
        }
    }
    
    func update() {
        for n in 0 ..< clouds.count {
            let cloud = clouds[n]
            cloud.transform.location.x = cloud.transform.location.x + 0.001.m * Float(n + 1)
            if cloud.transform.location.x > Camera.size.x * 1.5 {
                cloud.transform.location.x = -Camera.size.x / 2
            }
        }
    }
    
    func render() {
        clouds.forEach{
            $0.refresh()
            $0.render()
        }
        
    }
    
}
