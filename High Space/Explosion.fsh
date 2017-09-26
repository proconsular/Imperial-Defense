//
//  Shader.fsh
//  Imperial Defense
//
//  Created by Chris Luttio on 4/10/14.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//
#version 300 es

precision mediump float;

uniform vec4 color;
uniform vec2 location;
uniform float radius;

out vec4 fragColor;

void main() {
    vec2 loc = location - gl_FragCoord.xy;
    float rad = 1.0f - length(loc) / 400.0f;
    vec4 col = vec4(rad, 0, 0, rad);
    fragColor = col;
}
