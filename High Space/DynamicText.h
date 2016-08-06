//
//  DynamicText.h
//  Bot Bounce
//
//  Created by Chris Luttio on 11/16/14.
//  Copyright (c) 2014 Evans Creative Studios. All rights reserved.
//

@import GLKit;
@import CoreGraphics;
@import CoreText;

@class Image, Gradient;

@interface DynamicText : NSObject

@property NSAttributedString* attrString;
@property(nonatomic) vector_float2 location;
@property(nonatomic) vector_float2 bounds;
@property Image *image;
@property(nonatomic) GLuint texture;

@property vector_float2 shadowOffset;
@property float shadowOpacity;
@property bool hasShadow;

-(instancetype)initWithAttributedString:(NSAttributedString*)attrStr;
-(instancetype)initWithAttributedString:(NSAttributedString *)attrStr bounds:(vector_float2)aBound;

-(void)createWithAttributedString:(NSAttributedString*)attrString;
-(void)createWithAttributedString:(NSAttributedString *)attrString bounds:(vector_float2)aBound;

-(void)attributedStringWithGradient:(NSAttributedString*)aString topColor:(UIColor*)topColor bottomColor:(UIColor*)bottomColor;

-(void)attributedStringWithGradient:(NSAttributedString*)aString topColor:(UIColor*)topColor bottomColor:(UIColor*)bottomColor range:(NSRange)aRange;

-(void)makeShadowWithOffset:(vector_float2)offset opacity:(float)opacity;

+(CGImageRef)makeCGImageFromAttributedString:(NSAttributedString*)aString;

+(CGImageRef)applyGradientOnCGImage:(CGImageRef)aCGImage gradient:(Gradient*)aGradient string:(NSAttributedString*)aString range:(NSRange)aRange;

+(GLuint)textureFromCGImage:(CGImageRef)aCGImage;

-(void)display;

@end
