//
//  Book.m
//  eMotion Book
//
//  Created by Chris Luttio on 1/6/15.
//  Copyright (c) 2015 FishyTale Digital, Inc. All rights reserved.
//

#import "Bridge.h"
#import "DynamicText.h"
#import "TextureRepo.h"
#import "Texture.h"
#import "AudioLibrary.h"
#import "Sky_s_Melody-Swift.h"

@implementation Bridge {
    float average_delta;
    int count;
    
    core *swift;
}

static Bridge *sharedInstance;

+(void)create {
    sharedInstance = [Bridge new];
}

+(instancetype)sharedInstance {
    return sharedInstance;
}

-(instancetype)init {
    self = [super init];
    
    [TextureRepo sharedLibrary];
    [AudioLibrary sharedLibrary];
    
    swift = [core new];
    
    return self;
}

-(void)update{
    [swift update];
}

-(void)display {
    [swift display];
}

@end
