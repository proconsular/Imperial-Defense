//
//  DynamicText.m
//  Imperial Defense
//
//  Created by Chris Luttio on 11/16/14.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

#import "DynamicText.h"
#import "Imperial_Defense-Swift.h"

@implementation DynamicText

-(instancetype)initWithAttributedString:(NSAttributedString *)attrStr{
    self = [super init];
    
    [self createWithAttributedString:attrStr];
    
    return self;
}

-(instancetype)initWithAttributedString:(NSAttributedString *)attrStr bounds:(vector_float2)aBound{
    self = [super init];
    
    [self createWithAttributedString:attrStr bounds:aBound];
    
    return self;
}

-(void)createWithAttributedString:(NSAttributedString *)attrString{
    if ([attrString isEqualToAttributedString:_attrString]) { return; }
    if (_attrString) { glDeleteTextures(1, &_texture); }
    
    _attrString = attrString;
    
    int width = [_attrString size].width;
    int height = [_attrString size].height;
    
    void *texture_data = malloc(width * height * 4);
    CGContextRef context = [self createContextForData:texture_data :width :height];
    [self drawText:_attrString :height :context];
    [self createTextureWithData:texture_data :width :height];
}

-(void)createWithAttributedString:(NSAttributedString *)attrString bounds:(vector_float2)aBound{
    if ([attrString isEqualToAttributedString:_attrString]) { return; }
    if (_attrString) { glDeleteTextures(1, &_texture); }
    
    _attrString = attrString;
    _bounds = aBound;
    
    int width = _bounds.x * 4;
    int height = _bounds.y * 4;
    
    void *texture_data = malloc(width * height * 4);
    CGContextRef context = [self createContextForData:texture_data :width :height];
    [self drawBoundedText:_attrString :width :height :context];
    [self createTextureWithData:texture_data :width :height];
}

-(CGContextRef)createContextForData:(void *)texture_data :(int)width :(int)height {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(texture_data, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    CFRelease(colorSpace);
    
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetAllowsFontSmoothing(context, YES);
    CGContextSetAllowsFontSubpixelPositioning(context, YES);
    CGContextSetAllowsFontSubpixelQuantization(context, YES);
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextClearRect(context, CGRectMake(0, 0, width, height));
    return context;
}

-(void)drawText:(NSAttributedString *)attributedString :(int)height :(CGContextRef)context {
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)_attrString);
    CGContextSetTextPosition(context, 0, height / 3.8);
    CTLineDraw(line, context);
    CFRelease(line);
    CFRelease(context);
}

-(void)createTextureWithData:(void *)texture_data :(int)width :(int)height {
    glGenTextures(1, &_texture);
    glBindTexture(GL_TEXTURE_2D, _texture);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, texture_data);
    
    free(texture_data);
    
    _display = [[DisplayAdapter alloc] init:_location :vector2((float)width, (float)height) :_texture];
}

-(void)drawBoundedText:(NSAttributedString *)attributedString :(int)width :(int)height :(CGContextRef)context {
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, width, height), nil);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)_attrString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, _attrString.length), path, nil);
    CGContextSetTextPosition(context, 0, _attrString.size.height / 3.8);
    CTFrameDraw(frame, context);
    CFRelease(framesetter);
    CFRelease(frame);
    CFRelease(context);
}

-(void)setTexture:(GLuint)texture{
    glDeleteTextures(1, &_texture);
    _texture = texture;
}

-(void)setLocation:(vector_float2)location{
    _location = location;
    _display.location = location;
}

-(void)render{
    [_display render];
}

-(void)dealloc{
    glDeleteTextures(1, &_texture);
}

@end
