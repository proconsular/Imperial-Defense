//
//  Book.m
//  Imperial Defense
//
//  Created by Chris Luttio on 1/6/15.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

#import "Bridge.h"
#import "DynamicText.h"
#import "TextureRepo.h"
#import "AudioLibrary.h"
#import "Imperial_Defense-Swift.h"

@implementation Bridge {
    MainGame *game;
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
    
    game = [MainGame new];
    
    return self;
}

-(void)update{
    [game update];
}

-(void)display {
    [game display];
}

@end
