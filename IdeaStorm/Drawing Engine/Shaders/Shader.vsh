attribute vec4 Position;
attribute vec4 Color;

uniform mat4 Projection;

varying vec4 OutColor;

void main() {
    OutColor = Color;
    gl_PointSize = 20.0;
    gl_Position = Projection * vec4(Position.xy, -4.0, 1.0);
}