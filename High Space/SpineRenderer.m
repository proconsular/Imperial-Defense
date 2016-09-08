//
//  SpineRenderer.m
//  Sky's Melody
//
//  Created by Chris Luttio on 9/4/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

#import "SpineRenderer.h"
#import "Sky_s_Melody-Swift.h"

@implementation SpineRenderer

-(instancetype)initWithSkeleton:(spSkeleton *)skeleton {
    self = [super init];
    _skeleton = skeleton;
    _displays = [NSMutableArray new];
    [self setup];
    return self;
}

-(void)setup {
    for (int n = 0; n < _skeleton->slotsCount; n++) {
        spSlot *slot = _skeleton->drawOrder[n];
        if (!slot->attachment) continue;
        spAttachment *attachment = slot->attachment;
        if (attachment->type == SP_ATTACHMENT_REGION) {
            spRegionAttachment *regionAttachment = (spRegionAttachment *)attachment;
            [_displays addObject:[self makeDisplay:regionAttachment]];
        }
    }
}

-(DisplayAdapter *)makeDisplay:(spRegionAttachment *)regionAttachment {
    DisplayAdapter *display = [DisplayAdapter new];
    spAtlasRegion *region = (spAtlasRegion *)regionAttachment->rendererObject;
    spAtlasPage *page = region->page;
    Texture *tex = (__bridge Texture *)(page->rendererObject);
    display.bounds = vector2(regionAttachment->width, regionAttachment->height);
    display.texture = tex.texture;
    [display setCoordinates:regionAttachment->uvs :8];
    [display refresh];
    [display clearParent];
    return display;
}

-(void)render {
    int i = 0;
    for (int n = 0; n < _skeleton->slotsCount; n++) {
        spSlot *slot = _skeleton->drawOrder[n];
        if (!slot->attachment) continue;
        spAttachment *attachment = slot->attachment;
        if (attachment->type == SP_ATTACHMENT_REGION) {
            spRegionAttachment *regionAttachment = (spRegionAttachment *)attachment;
            float *vertices = malloc(sizeof(float) * 8);
            DisplayAdapter *display = _displays[i];
            
            spRegionAttachment_computeWorldVertices(regionAttachment, slot->bone, vertices);
            
            [display setVertices:vertices :8];
            [display setCoordinates:regionAttachment->uvs :8];
            [display refresh];
            
            //display.location = vector2((float)700, (float)700);
            //[display setMatrix:vector2(slot->bone->a, slot->bone->b) :vector2(slot->bone->c, slot->bone->d)];
            
            [display render];
            //NSLog(@"%f, %f", display.location.x, display.location.y);
            i++;
            
            free(vertices);
        }
    }
}

@end
