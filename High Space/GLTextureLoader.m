//
//  TextureLoader.m
//  Imperial Defense
//
//  Created by Chris Luttio on 2/10/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

#import "GLTextureLoader.h"
#import "Imperial_Defense-Swift.h"
@import UIKit;
@import simd;

@implementation GLTextureLoader

static GLuint sampler;

+(void)setSampler:(GLuint)aSampler{
    sampler = aSampler;
}

+(Texture *)fetch:(NSString *)name{
    return [GLTextureLoader fetch:name :GL_RGBA8];
}

+(Texture *)fetch:(NSString *)name :(GLenum)format{
    GLuint texture = [GLTextureLoader createTexture];
    glBindTexture(GL_TEXTURE_2D, texture);
    //glBindSampler(1, sampler);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    
    int width, height;
    [GLTextureLoader storeImmutableTexture:[GLTextureLoader getImageData:name :&width :&height] :width :height :format];
    return [[Texture alloc] init:texture :vector2((float)width, (float)height)];
}

+(GLuint)createTexture{
    GLuint texture;
    glGenTextures(1, &texture);
    return texture;
}

+(void *)getImageData:(NSString *)name :(int *)widthp :(int *)heightp{
    CGImageRef image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"png"]].CGImage;
    long width = CGImageGetWidth(image), height = CGImageGetHeight(image);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    void *data = malloc(4 * width * height);
    CGContextRef context = CGBitmapContextCreate(data, width, height, 8, 4 * width, colorspace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorspace);
    
    CGContextClearRect(context, CGRectMake(0, 0, width, height));
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    CGContextRelease(context);
    
    *widthp = (int)width;
    *heightp = (int)height;
    return data;
}

+(void)storeImmutableTexture:(void *)data :(int)width :(int)height :(GLenum)format{
    if (format == GL_RGBA4) {
        data = [GLTextureLoader convertData:data :width :height];
        glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    }else{
        glPixelStorei(GL_UNPACK_ALIGNMENT, 4);
    }
    
    glTexStorage2D(GL_TEXTURE_2D, 1, format, width, height);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, width, height, GL_RGBA, format == GL_RGBA4 ? GL_UNSIGNED_SHORT_4_4_4_4 : GL_UNSIGNED_BYTE, data);
    free(data);
}

+(void *)convertData:(void *)data :(int)width :(int)height{
    void *tempData = malloc(2 * width * height);
    unsigned int *inPixel32 = (unsigned int *)data;
    unsigned short *outPixel16 = (unsigned short *)tempData;
    for(int i = 0; i < width * height; ++i, ++inPixel32)
        *outPixel16++ =
        ((((*inPixel32 >> 0) & 0xFF) >> 4) << 12) |
        ((((*inPixel32 >> 8) & 0xFF) >> 4) << 8) |
        ((((*inPixel32 >> 16) & 0xFF) >> 4) << 4) |
        ((((*inPixel32 >> 24) & 0xFF) >> 4) << 0);
    
    free(data);
    data = tempData;
    
    return data;
}

+(void)storeCompressedTexture:(void *)data :(int)size :(int)width :(int)height{
    glCompressedTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG, width, height, 0, size, data);
}

@end
