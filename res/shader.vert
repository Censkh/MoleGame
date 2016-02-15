attribute vec2 aPosition;
attribute vec2 aUv;
uniform vec2 uOffset;
uniform vec2 uScale;
varying vec2 vTexCoord;

void main() {
    vTexCoord = aUv;
    gl_Position = vec4((aPosition * uScale) + uOffset, 0, 1);
}