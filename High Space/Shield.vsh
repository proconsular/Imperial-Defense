//
//  Shield.vsh
//  Imperial Defense
//
//  Created by Chris Luttio on 5/13/17.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//
#version 300 es

precision highp float;

in highp vec4 position;
in lowp vec2 texCoord0;

out highp vec2 texCoord0_Varying;

uniform highp mat4 modelViewProjectionMatrix;

void main() {
    texCoord0_Varying   = texCoord0;
    gl_Position         = modelViewProjectionMatrix * position;
}
