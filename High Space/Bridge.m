//
//  Book.m
//  eMotion Book
//
//  Created by Chris Luttio on 1/6/15.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

#import "Bridge.h"
#import "DynamicText.h"
#import "TextureRepo.h"
#import "Texture.h"
#import "AudioLibrary.h"
#import "Imperial_Defense-Swift.h"

@implementation Bridge {
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
