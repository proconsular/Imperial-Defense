#version 300 es

precision mediump float;

in highp vec2 texCoord0_Varying;

uniform highp sampler2D Texture0;
uniform highp vec4 color;

out vec4 fragColor;

void main() {
    vec4 col;
    vec4 texel = texture(Texture0, texCoord0_Varying);
    
    if (texel.a > 0.0f) {
        col = texel;
    }else{
        int count = 6;
        for (int i = 0; i < count; i++) {
            col += texture(Texture0, texCoord0_Varying + vec2(0, i - count / 2) * 0.00125f);
        }
    }
    
    if (col.a > 0.0f) {
        col = color * 0.5f;
    }
    
    fragColor = col;
}
