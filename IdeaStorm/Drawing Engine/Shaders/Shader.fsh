uniform sampler2D Texture;

varying lowp vec4 OutColor;

void main() {
    lowp vec4 tex = texture2D(Texture, gl_PointCoord);
    
    gl_FragColor = vec4(OutColor.rgb, tex.a * OutColor.a);
}