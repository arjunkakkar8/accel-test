varying vec2 vUv;
uniform vec2 uResolution;

void main() {
    vUv = uv;
    // vUv = (uv - vec2(0.5)) * (uResolution.y / uResolution.x) + vec2(0.5);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(position.xyz, 1.0);
}