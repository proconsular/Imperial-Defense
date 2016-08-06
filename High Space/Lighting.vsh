#version 300 es

precision lowp float;

in vec4 position;

uniform mat4 modelViewProjectionMatrix;

void main() {
    gl_Position = modelViewProjectionMatrix * position;
}
