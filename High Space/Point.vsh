//
//  Shader.vsh
//  Imperial Defense
//
//  Created by Chris Luttio on 4/10/14.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//
#version 300 es

precision highp float;

in highp vec4 position;
in lowp vec2 size;
in lowp vec4 color;

out lowp vec4 colorVarying;

uniform highp mat4 modelViewProjectionMatrix;

void main() {
    gl_PointSize = size.x;
    colorVarying = color;
    gl_Position = modelViewProjectionMatrix * position;
}
