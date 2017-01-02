//
//  Shader.vsh
//  Imperial Defence
//
//  Created by Chris Luttio on 4/10/14.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//
#version 300 es

precision highp float;

in highp vec4 position;
in lowp vec4 color;
in lowp vec2 texCoord0;

out lowp vec4 colorVarying;
out lowp vec2 texCoord0_Varying;

uniform highp mat4 modelViewProjectionMatrix;

void main() {
    texCoord0_Varying   = texCoord0;
    colorVarying        = color;
    gl_Position         = modelViewProjectionMatrix * position;
}
