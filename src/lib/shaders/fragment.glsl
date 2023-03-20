varying vec2 vUv;
uniform sampler2D uTexture;
uniform float uTime;

float NOISE_LEVEL = 0.15;
float LINE_COUNT = 1000.0;
float LINE_STRENGTH = 0.5;
float LINE_SPEED = 10.0;

vec4 black = vec4(0.0, 0.0, 0.0, 1.0);

float rand(vec2 vec) {
    return fract(sin(dot(vec.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec4 texture = texture2D(uTexture, vUv);
    
    float blackMix = abs(sin(vUv.y * LINE_COUNT + uTime * LINE_SPEED) * LINE_STRENGTH);
    vec4 textureScanned = mix(texture, black, blackMix);

    float randomValue = rand(vec2(vUv.x + sin(uTime), vUv.y + cos(uTime)));
    vec4 noiseColor = vec4(randomValue, randomValue, randomValue, 1.0);
    
    gl_FragColor = mix(textureScanned, noiseColor, NOISE_LEVEL);
    // gl_FragColor = texture;
    // gl_FragColor = vec4(vUv.xy, 1.0, 1.0);
}