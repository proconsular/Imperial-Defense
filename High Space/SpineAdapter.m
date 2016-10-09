//
//  SpineAdapter.c
//  Sky's Melody
//
//  Created by Chris Luttio on 8/29/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

#include "SpineAdapter.h"
#include "spine.h"
#include "extension.h"
#import "Defender-Swift.h"

void _spAtlasPage_createTexture (spAtlasPage* self, const char* path) {
    NSString *name = [[NSString stringWithUTF8String:path] stringByDeletingPathExtension];
    [[TextureRepo sharedLibrary] prefetch:name];
    Texture *tex = [[TextureRepo sharedLibrary] descriptionWithName:name];
    self->width = tex.bounds.x;
    self->height = tex.bounds.y;
    self->rendererObject = (__bridge void *)(tex);
}

void _spAtlasPage_disposeTexture (spAtlasPage* self) {
    
}

char* _spUtil_readFile (const char* path, int* length) {
    return readFile(path, length);
}

char* readFile(const char* path, int* length) {
    NSString *formatted_path = [NSString stringWithUTF8String:path];
    NSString *name = [formatted_path stringByDeletingPathExtension];
    NSString *extension = [formatted_path pathExtension];
    NSString *real_path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    return _readFile([real_path cStringUsingEncoding:NSUTF8StringEncoding], length);
}

char* readFileAtPath(const char* path) {
    int length = 0;
    return readFile(path, &length);
}
