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
#import "Sky_s_Melody-Swift.h"

void _spAtlasPage_createTexture (spAtlasPage* self, const char* path) {
    
}

void _spAtlasPage_disposeTexture (spAtlasPage* self) {
    
}

char* _spUtil_readFile (const char* path, int* length) {
    return _readFile(path, length);
}