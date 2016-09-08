//
//  SkeletonAdaptor.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 9/7/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation

class Skeleton {
    
    let renderer: SpineRenderer
    
    let skeleton: UnsafeMutablePointer<spSkeleton>
    var animation: UnsafeMutablePointer<spAnimation>?
    
    let transform: Transform
    let offset: float2
    
    var counter: Float = 0
    
    let data: UnsafeMutablePointer<spSkeletonData>
    
    var lastAnimation: String?
    
    init(_ name: String, _ transform: Transform, _ offset: float2 = float2()) {
        self.transform = transform
        self.offset = offset
        let atlas = spAtlas_createFromFile("\(name).atlas", nil)
        let json = spSkeletonJson_create(atlas)
        json.memory.scale = 0.5
        
        data = spSkeletonJson_readSkeletonData(json, readFileAtPath("\(name).json"))
        
        let skel = spSkeleton_create(data)
        skeleton = skel
        
        skel.memory.flipY = 1
        
        spSkeleton_setToSetupPose(skeleton)
        spSkeleton_updateWorldTransform(skeleton)
        
        renderer = SpineRenderer(skeleton: skeleton)
        
        setAnimation("idle")
    }
    
    func setAnimation(name: String) {
        animation = spSkeletonData_findAnimation(data, name)
        if let last = lastAnimation {
            if last != name {
                counter = 0
            }
        }
        lastAnimation = name
    }
    
    func setDirection(dir: Int) {
        skeleton.memory.flipX = dir == 1 ? 0 : 1
    }
    
    func update() {
        skeleton.memory.x = transform.location.x + offset.x
        skeleton.memory.y = transform.location.y + offset.y
        
        let last = counter
        counter += Time.time
        
        if let anim = animation {
             spAnimation_apply(anim, skeleton, last, counter, 1, nil, nil)
        }
        
        spSkeleton_update(skeleton, Time.time)
        spSkeleton_updateWorldTransform(skeleton)
    }
    
    func render() {
        renderer.render()
    }
    
}