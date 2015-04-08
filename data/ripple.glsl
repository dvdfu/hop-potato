varying vec4 vpos;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position) {
    vpos = vertex_position;
    //vertex_position.xy += 100;
    return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    //texture_coords += vec2(cos(vpos.x), sin(vpos.y));
    vec4 texcolor = Texel(texture, texture_coords);
    return texcolor * color;
}
#endif