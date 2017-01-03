//
//  Shader.fsh
//  Imperial Defense
//
//  Created by Chris Luttio on 4/10/14.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//
#version 300 es

precision mediump float;

in lowp vec4 colorVarying;
in lowp vec2 texCoord0_Varying;

uniform lowp sampler2D Texture0;

out vec4 fragColor;

void main() {
    fragColor = colorVarying * texture(Texture0, texCoord0_Varying);
}
