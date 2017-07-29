//
//  SplashElements.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class SplashPlayer: Entity, Damagable {
    var reflective: Bool = false
    
    var player: Display
    var player_animation: Animator
    
    var direction: float2
    var shoot: ShootEvent
    
    let shield: Shield
    
    init() {
        player = Display(Rect(float2(Camera.size.x * 0.68, Camera.size.y * 0.72) + float2(0, -GameScreen.size.y), float2(48) * 5), GLTexture("Splash_Player"))
        player.coordinates = SheetLayout(0, 8, 1).coordinates
        
        let loc = player.transform.location + float2(0.5.m, -0.04.m)
        direction = float2(Camera.size.x, Camera.size.y) + float2(0, -GameScreen.size.y) - loc
        
        shoot = ShootEvent(loc, normalize(direction), [2])
        
        let anim = TextureAnimator(GLTexture("Splash_Player").id, SheetLayout(0, 8, 1))
        anim.append(SheetAnimator(0.05, [shoot], SheetAnimation(0, 3, 8, 1)))
       
        player_animation = Animator(TimedAnimationPlayer(anim))
        
        shield = Shield(Float(40), Float(1), Float(20))
        player.technique = ShieldTechnique(shield, player.transform, float4(48 / 255, 181 / 255, 206 / 255, 1), 48 * 5)
        
        super.init(Rect(player.transform, float2()), Rect(player.transform, float2(0.75.m, 2.m)), Substance.getStandard(0.1))
        
        body.tag = "player"
        body.mask = 0b10
        body.object = self
    }
    
    func damage(_ amount: Float) {
        shield.damage(amount)
        let hit = Audio("hit1")
        hit.volume = sound_volume * 0.1
        hit.start()
    }
    
    override func update() {
        shield.update()
        let angle = random(-Float.pi / 4, -Float.pi / 8) + atan2f(direction.x, direction.y)
        shoot.direction = float2(cosf(angle), sinf(angle))
        player_animation.update()
        player_animation.apply(player)
    }
    
    override func render() {
        player.refresh()
        player.render()
    }
    
}

class SplashFirer {
    
    var location, bounds: float2
    var target: Transform
    var counter, rate: Float
    
    init(_ location: float2, _ bounds: float2, _ target: Transform, _ rate: Float) {
        self.location = location
        self.bounds = bounds
        self.target = target
        self.rate = rate
        counter = 0
    }
    
    func update() {
        counter += Time.delta
        if counter >= rate {
            counter = 0
            let loc = (location + float2(random(-bounds.x / 2, bounds.x / 2), random(-bounds.y / 2, bounds.y / 2)))
            let direction = target.location + float2(random(-4.m, 4.m), random(-4.m, 4.m)) - loc
            let bullet = Bullet(loc, normalize(direction), Impact(5, 12.m), Casing(float2(0.5.m, 0.1.m), float4(1, 0, 0, 1), "player"))
            Map.current.append(bullet)
            let hit = Audio("shoot3")
            hit.volume = sound_volume * 0.1
            hit.start()
        }
    }
    
}

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

class SplashSky {
    
    let sky_color: float4
    let sky: Display
    var fade: Float
    
    
    init() {
        sky_color = float4(6 / 255, 14 / 255, 39 / 255, 1)
        sky = Display(Rect(Camera.size / 2 + float2(0, -GameScreen.size.y), Camera.size), GLTexture("white"))
        sky.color = sky_color
        fade = 1
    }
    
    func update() {
        if random(0, 1) < 0.001 {
            fade = 0
            let thunder = Audio("thunder")
            thunder.pitch = random(0.9, 1.1)
            thunder.volume = sound_volume * 0.5
            thunder.start()
        }
        
        fade = clamp(fade + 2 * Time.delta, min: 0, max: 1)
        sky.color = sky_color * fade + float4(1) * (1 - fade)
    }
    
    func render() {
        sky.refresh()
        sky.render()
        
    }
    
}

class SplashTitle {
    
    let title: Display
    let location: float2
    var velocity: float2
    var direction: Float
    
    init() {
        location = float2(Camera.size.x / 2, Camera.size.y / 2 - 150) + float2(0, -GameScreen.size.y)
        title = Display(Rect(location, float2(786, 128) * 2), GLTexture("Title"))
        velocity = float2()
        direction = 1
    }
    
    func update() {
        velocity.y += 0.015 * direction
        velocity.y *= 0.99
        title.transform.location.y += velocity.y
        let delta = title.transform.location.y - location.y
        if delta < -2 {
            direction = 1
        }
        if delta > 2 {
            direction = -1
        }
        title.refresh()
    }
    
    func render() {
        title.render()
    }
    
}
















