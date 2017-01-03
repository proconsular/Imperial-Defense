//
//  Book.h
//  Imperial Defense
//
//  Created by Chris Luttio on 1/6/15.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

@import Foundation;

@class TextureRepo;

@interface Bridge : NSObject

@property bool ignore;

+(void)create;
+(instancetype)sharedInstance;

-(void)update;
-(void)display;

@end
