precision mediump float;
uniform sampler2D uTexture;
uniform float uAlpha;

varying vec2 vTexCoord;

void main() {
    vec4 color = texture2D(uTexture, vTexCoord).rgba;
    color.a*=uAlpha;
    gl_FragColor = color;
}