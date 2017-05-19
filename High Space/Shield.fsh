//
//  Shield.fsh
//  Imperial Defense
//
//  Created by Chris Luttio on 5/13/17.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//
#version 300 es

precision mediump float;

in highp vec2 texCoord0_Varying;

uniform highp sampler2D Texture0;
uniform highp vec4 color;
uniform highp vec2 location;
uniform highp vec2 level;

out vec4 fragColor;

vec4 computeColor(vec4 texel) {
    vec4 col = texel;
    if (texel.a > 0.0f && texel.r > 0.1f) {
        col = color;
    }else{
        col = vec4(0.0f);
    }
    if ((gl_FragCoord.y > level.y)) {
        return vec4(0.0f);
    }
    return col;
}

void main() {
    vec4 col;
    vec4 texel = computeColor(texture(Texture0, texCoord0_Varying));
    
    if (texel.a > 0.0f) {
        col = texel;
    }else{
        int count = 6;
        for (int i = 0; i < count; i++) {
            col += computeColor(texture(Texture0, texCoord0_Varying + vec2(i - count / 2, 0) * 0.00125f));
        }
        if (col.a > 0.0f) {
            col = color * 0.5f;
        }
    }
    
    fragColor = col;
}
