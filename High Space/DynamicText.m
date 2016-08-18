//
//  DynamicText.m
//  Bot Bounce
//
//  Created by Chris Luttio on 11/16/14.
//  Copyright (c) 2014 Evans Creative Studios. All rights reserved.
//

#import "DynamicText.h"
#import "Sky_s_Melody-Swift.h"

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

-(void)dealloc{
    glDeleteTextures(1, &_texture);
}

-(void)createWithAttributedString:(NSAttributedString *)attrString{
    
    if ([attrString isEqualToAttributedString:_attrString]) {
        return;
    }
    
    if (_attrString) {
        glDeleteTextures(1, &_texture);
    }
    
    _attrString = attrString;
    
    int width = [_attrString size].width;
    int height = [_attrString size].height;
    
    void *texture_data = malloc(width * height * 4);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(texture_data, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    CFRelease(colorSpace);
    
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetAllowsFontSmoothing(context, YES);
    CGContextSetAllowsFontSubpixelPositioning(context, YES);
    CGContextSetAllowsFontSubpixelQuantization(context, YES);
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextClearRect(context, CGRectMake(0, 0, width, height));

    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)_attrString);
    
    CGContextSetTextPosition(context, 0, height / 2.8);
    CTLineDraw(line, context);
    
    CFRelease(line);
    CFRelease(context);
    
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

-(void)createWithAttributedString:(NSAttributedString *)attrString bounds:(vector_float2)aBound{
    
    if ([attrString isEqualToAttributedString:_attrString]) {
        return;
    }
    
    if (_attrString) {
        glDeleteTextures(1, &_texture);
    }
    
    _attrString = attrString;
    _bounds = aBound;
    
    int width = _bounds.x * 4;
    int height = _bounds.y * 4;
    
    void *texture_data = malloc(width * height * 4);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(texture_data, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    CFRelease(colorSpace);
    
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetAllowsFontSmoothing(context, YES);
    CGContextSetAllowsFontSubpixelPositioning(context, YES);
    CGContextSetAllowsFontSubpixelQuantization(context, YES);
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextClearRect(context, CGRectMake(0, 0, width, height));
    
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, width, height), nil);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)_attrString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, _attrString.length), path, nil);
    
    CGContextSetTextPosition(context, 0, _attrString.size.height / 2.8);
    CTFrameDraw(frame, context);
    
    CFRelease(framesetter);
    CFRelease(frame);
    CFRelease(context);
    
    glGenTextures(1, &_texture);
    glBindTexture(GL_TEXTURE_2D, _texture);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, texture_data);
    
    free(texture_data);
    
    _display = [[DisplayAdapter alloc] init:_location :vector2((float)width, (float)height) :_texture];
}

-(void)attributedStringWithGradient:(NSAttributedString *)aString topColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor{
    return [self attributedStringWithGradient:aString topColor:topColor bottomColor:bottomColor range:NSMakeRange(0, aString.length)];
}

-(void)attributedStringWithGradient:(NSAttributedString *)aString topColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor range:(NSRange)aRange{
    
    if ([aString isEqualToAttributedString:_attrString]) {
        return;
    }
    
    if (_attrString) {
        glDeleteTextures(1, &_texture);
    }
    
    _attrString = aString;
    
    int width = [_attrString size].width;
    int height = [_attrString size].height;
    
    void *texture_data = malloc(width * height * 4);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(texture_data, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    CFRelease(colorSpace);
    
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetAllowsFontSmoothing(context, YES);
    CGContextSetAllowsFontSubpixelPositioning(context, YES);
    CGContextSetAllowsFontSubpixelQuantization(context, YES);
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, width, height));
    
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)_attrString);
    
    CGContextSetTextPosition(context, 0, height / 2.8);
    CTLineDraw(line, context);
    
    CGImageRef mask_image = CGBitmapContextCreateImage(context);
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(mask_image), CGImageGetHeight(mask_image), CGImageGetBitsPerComponent(mask_image), CGImageGetBitsPerPixel(mask_image), CGImageGetBytesPerRow(mask_image), CGImageGetDataProvider(mask_image), NULL, NO);
    
    CGContextClearRect(context, CGRectMake(0, 0, width, height));
    
    CGGradientRef myGradient;
    CGColorSpaceRef myColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    
    CGFloat tr,tg,tb,br,bg,bb;
    
    [topColor getRed:&tr green:&tg blue:&tb alpha:NULL];
    [bottomColor getRed:&br green:&bg blue:&bb alpha:NULL];
    
    CGFloat components[8] = {tr, tg, tb, 1.0,
                             br, bg, bb, 1.0};
    
    myColorspace = CGColorSpaceCreateDeviceRGB();
    myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, num_locations);
    
    CGPoint myStartPoint, myEndPoint;
    myStartPoint.x = width;
    myStartPoint.y = height;
    myEndPoint.x = width;
    myEndPoint.y = 0.0;
    CGContextDrawLinearGradient(context, myGradient, myStartPoint, myEndPoint, 0);
    
    CGImageRef image_effect = CGBitmapContextCreateImage(context);
    
    CGImageRef final_image = CGImageCreateWithMask(image_effect, mask);
    
    CGContextClearRect(context, CGRectMake(0, 0, width, height));
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), final_image);
    
    CFRelease(mask_image);
    CFRelease(mask);
    CFRelease(myGradient);
    CFRelease(myColorspace);
    CFRelease(image_effect);
    CFRelease(final_image);
    
    CFRelease(line);
    CFRelease(context);
    
    glGenTextures(1, &_texture);
    glBindTexture(GL_TEXTURE_2D, _texture);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, texture_data);
    
    free(texture_data);
    
    _display = [[DisplayAdapter alloc] init:_location :vector2((float)width, (float)height) :_texture];
}

+(CGImageRef)makeCGImageFromAttributedString:(NSAttributedString *)aString{
    int width = aString.size.width;
    int height = aString.size.height;
    
    void *texture_data = malloc(width * height * 4);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(texture_data, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    CFRelease(colorSpace);
    
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetAllowsFontSmoothing(context, YES);
    CGContextSetAllowsFontSubpixelPositioning(context, YES);
    CGContextSetAllowsFontSubpixelQuantization(context, YES);
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextClearRect(context, CGRectMake(0, 0, width, height));
    
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)aString);
    
    CGContextSetTextPosition(context, 0, height / 2.8);
    CTLineDraw(line, context);
    
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    CFRelease(line);
    CFRelease(context);
    
    free(texture_data);
    
    return image;
}

+(GLuint)textureFromCGImage:(CGImageRef)aCGImage{
    
    unsigned long width = CGImageGetWidth(aCGImage);
    unsigned long height = CGImageGetHeight(aCGImage);
    
    void *data = malloc(width * height * 4);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CFRelease(colorSpace);
    
    CGContextClearRect(context, CGRectMake(0, 0, width, height));
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), aCGImage);
    
    CFRelease(aCGImage);
    CFRelease(context);
    
    
    GLuint texture;
    
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)width, (int)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
    
    free(data);
    
    return texture;
}

-(void)setTexture:(GLuint)texture{
    
    glDeleteTextures(1, &_texture);
    
    _texture = texture;
    
//    if (!_display) {
//        _display = [[DisplayAdapter alloc] init:_location :vector2((float)width, (float)height) :_texture];
//    }else{
//        _image.texture = texture;
//    }
    
}

-(void)makeShadowWithOffset:(vector_float2)offset opacity:(float)opacity{
    _hasShadow = YES;
    _shadowOffset = offset;
    _shadowOpacity = opacity;
}

-(void)setLocation:(vector_float2)location{
    _location = location;
    _display.location = location;
}

-(void)render{
    [_display render];
}

@end
