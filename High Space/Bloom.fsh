//
//  Blur.fsh
//  Imperial Defense
//
//  Created by Chris Luttio on 5/16/17.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//
#version 300 es

precision mediump float;

in highp vec2 texCoord0_Varying;

uniform highp sampler2D Texture0;
uniform highp vec4 color;

out vec4 fragColor;

uniform int size;
uniform float quality;

void main() {
    vec4 colored = texture(Texture0, texCoord0_Varying) * color;
    
    int sizei = int(size);
    int dif = sizei / 2;
    
    vec4 sam = vec4(0);
    for (int i = -dif; i <= dif; i++) {
        for (int j = -dif; j <= dif; j++) {
            vec2 offset = vec2 (i, j) * quality;
            vec4 newcolor = texture(Texture0, texCoord0_Varying + offset);
            sam += newcolor;
        }
    }
    vec4 blurred = sam / float(sizei * sizei);
    blurred *= color;
    
    fragColor = (blurred + colored) * color;
}
