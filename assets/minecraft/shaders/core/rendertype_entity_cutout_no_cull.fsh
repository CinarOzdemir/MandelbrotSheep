// Creatse a mandelbrot fractal on top of every sheep

#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;
uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec4 lightMapColor;
in vec4 overlayColor;
in vec2 texCoord0;
in vec4 normal;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0);
    
    if (color.a < 0.1) {
        discard;
    }
    
    if (color.a == 254.0 / 255.0) {
        
        vec2 new = vec2((texCoord0.y), (texCoord0.x)) - vec2(0.8, 0.8125);
        new = 8 * vec2(new.x * 1, new.y * 2.4);
        vec2 c = new;
        
        int max_iter = 40;
        int iter;
        vec2 z = vec2(0.0);
        
        for(iter = 0; iter < max_iter; iter++) {
            float x = (z.x * z.x - z.y * z.y) + c.x;
            float y = (2.0 * z.x * z.y) + c.y;
            z = vec2(x, y);
            
            // Mathematically outside
            if((z.x * z.x + z.y * z.y) > 4.0) {
                break;
            }
        }
        
        if (iter != max_iter) {
            color = vec4(1 - float(iter) / 20);
        }
    }

    color = color * vertexColor * ColorModulator * lightMapColor;
    color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}