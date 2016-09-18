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
    var dir = 1
    
    init(_ name: String, _ transform: Transform, _ offset: float2 = float2()) {
        self.transform = transform
        self.offset = offset
        let atlas = spAtlas_createFromFile("\(name).atlas", nil)
        let json = spSkeletonJson_create(atlas)
        json?.pointee.scale = 0.5
        
        data = spSkeletonJson_readSkeletonData(json, readFileAtPath("\(name).json"))
        
        let skel = spSkeleton_create(data)
        skeleton = skel!
        
        skel?.pointee.flipY = 1
        
        spSkeleton_setToSetupPose(skeleton)
        spSkeleton_updateWorldTransform(skeleton)
        
        renderer = SpineRenderer(skeleton: skeleton)
        
        setAnimation("idle")
    }
    
    func setAnimation(_ name: String) {
        animation = spSkeletonData_findAnimation(data, name)
        if let last = lastAnimation {
            if last != name {
                counter = 0
            }
        }
        lastAnimation = name
    }
    
    func setDirection(_ dir: Int) {
        self.dir = dir
        skeleton.pointee.flipX = dir == 1 ? 0 : 1
    }
    
    func getBoneLocation(_ name: String) -> float2 {
        let bone = spSkeleton_findBone(skeleton, name)
        let vertex = float2((bone?.pointee.worldX)! + skeleton.pointee.x, (bone?.pointee.worldY)! + skeleton.pointee.y)
        return vertex
    }
    
    func rotateBone(_ name: String, _ amount: Float) {
        let bone = spSkeleton_findBone(skeleton, name)
        let value = -amount.toDegrees() - 5 + (dir == 1 ? 0 : 180)
        bone?.pointee.rotation = value
    }
    
    func update() {
        skeleton.pointee.x = transform.location.x + offset.x
        skeleton.pointee.y = transform.location.y + offset.y
        
        let last = counter
        counter += Time.time
        
        if let anim = animation {
            spAnimation_apply(anim, skeleton, last, counter, 1, nil, nil)
        }
        
        spSkeleton_update(skeleton, Time.time)
    }
    
    func updateWorld() {
        spSkeleton_updateWorldTransform(skeleton)
    }
    
    func render() {
        renderer.render()
    }
    
}
