//
//  Building2D.fsh
//
//  Created by Zack Brown on 31/03/2021.
//

void main()
{
    vec4 color = a_color;
    vec4 grid = vec4(0.0, 0.0, 0.0, 1.0);
    
    vec2 fractional  = abs(fract(v_tex_coord));
    vec2 partial = fwidth(v_tex_coord);
    
    vec2 point = smoothstep(-partial, partial, fractional);
    
    float saturation = 1.0 - clamp(point.x * point.y, 0.0, 1.0);
    
    color = mix(color, grid, saturation);
    
    gl_FragColor = color * v_color_mix.a;
}
