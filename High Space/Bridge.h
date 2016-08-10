//
//  Book.h
//  eMotion Book
//
//  Created by Chris Luttio on 1/6/15.
//  Copyright (c) 2015 FishyTale Digital, Inc. All rights reserved.
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
