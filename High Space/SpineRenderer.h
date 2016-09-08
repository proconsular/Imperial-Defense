//
//  SpineRenderer.h
//  Sky's Melody
//
//  Created by Chris Luttio on 9/4/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "spine.h"

@class DisplayAdapter;

@interface SpineRenderer : NSObject

@property NSMutableArray<DisplayAdapter *> *displays;
@property spSkeleton *skeleton;

-(instancetype)initWithSkeleton:(spSkeleton *)skeleton;
-(void)setup;
-(DisplayAdapter *)makeDisplay:(spRegionAttachment *)regionAttachment;
-(void)render;

@end
