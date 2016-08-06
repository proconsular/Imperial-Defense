#version 300 es

precision highp float;

struct Light {
    vec2 location;
    float brightness;
    float attenuation;
    float temperature;
    float dissipation;
    vec4 color;
};

struct Face {
    vec2 first, second, center;
};

uniform Light light;
uniform Face faces[10];
uniform int count;

out vec4 fragColor;

float cross2(vec2 a, vec2 b) {
    return a.x * b.y - a.y * b.x;
}

bool computeSide(vec2 vertex, Face f) {
    return cross2(f.second - f.first, vertex - f.center) < 0.0f;
}

bool isLit(vec2 location, Face f) {
    vec2 dif = gl_FragCoord.xy - location;
    if (cross2(f.first - location, dif) > 0.0f) { return true; }
    if (cross2(dif, f.second - location) > 0.0f) { return true; }
    return computeSide(location, f) == computeSide(gl_FragCoord.xy, f);
}

float computeBlue(float temperature) {
    float blue = 1.0f;
    if (temperature < 66.0f) {
        if (temperature <= 19.0f) {
            blue = 0.0f;
        }else{
            blue = 0.543206f * log(temperature - 10.0f) - 1.19625f;
        }
    }
    return blue;
}

float computeGreen(float temperature) {
    float green;
    if (temperature <= 66.0f) {
        green = 0.390081f * log(temperature) - 0.631841f;
    }else{
        green = 1.129890f * pow(temperature - 60.0f, -0.075514f);
    }
    return green;
}

float computeRed(float temperature) {
    float red = 1.0f;
    if (temperature > 66.0f) {
        red = 1.292936f * pow(temperature - 60.0f, -0.133204f);
    }
    return red;
}

vec3 computeColor(float temperature) {
    float reduced = temperature / 100.0f;
    vec3 color = vec3(computeRed(reduced), computeGreen(reduced), computeBlue(reduced));
    return clamp(color, vec3(0.0f), vec3(1.0f));
}

void main() {
    for (int i = 0; i < count; i++) {
        if (!isLit(light.location, faces[i])) { discard; }
    }
    float difference = distance(light.location, gl_FragCoord.xy);
    float amount = light.brightness * exp(light.attenuation * difference);
    float temp = light.temperature * exp(light.dissipation * difference);
    fragColor = vec4(computeColor(temp), 1) * light.color * amount;
}
















