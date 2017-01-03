//
//  DynamicText.h
//  Imperial Defense
//
//  Created by Chris Luttio on 11/16/14.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

@import GLKit;
@import CoreGraphics;
@import CoreText;

@class DisplayAdapter;

@interface DynamicText : NSObject

@property NSAttributedString* attrString;
@property(nonatomic) vector_float2 location;
@property(nonatomic) vector_float2 bounds;
@property(nonatomic) GLuint texture;
@property(nonatomic) DisplayAdapter* display;

-(instancetype)initWithAttributedString:(NSAttributedString*)attrStr;
-(instancetype)initWithAttributedString:(NSAttributedString *)attrStr bounds:(vector_float2)aBound;

-(void)createWithAttributedString:(NSAttributedString*)attrString;
-(void)createWithAttributedString:(NSAttributedString *)attrString bounds:(vector_float2)aBound;

-(void)render;

@end
