//
//  Surface.fsh
//
//  Created by Zack Brown on 25/03/2021.
//

vec4 tileColorLookup(int value) {
    
    if (value == 0) {
        
        return vec4(0.81, 0.68, 0.51, 1);
    }
    else if (value == 1) {
        
        return vec4(0.85, 0.85, 0.69, 1);
    }
    else if (value == 2) {
        
        return vec4(0.96, 0.84, 0.52, 1);
    }
    else if (value == 3) {
        
        return vec4(0.30, 0.55, 0.48, 1);
    }
    else if (value == 4) {
        
        return vec4(0.81, 0.90, 0.94, 1);
    }
    
    return vec4(1, 1, 1, 1);
}

void main()
{
    vec4 color = texture2D(u_texture, v_tex_coord);
    vec4 grid = vec4(0.0, 0.0, 0.0, 1.0);
    
    float value = (color.r + color.g + color.b) / 3;

    if (value >= 0.1 && value <= 0.5) {

        color = tileColorLookup(a_color.r);
    }
    else if (value > 0.5 && value <= 0.9) {

        color = tileColorLookup(a_color.g);
    }
    
    vec2 fractional  = abs(fract(v_tex_coord));
    vec2 partial = fwidth(v_tex_coord);
    
    vec2 point = smoothstep(-partial, partial, fractional);
    
    float saturation = 1.0 - clamp(point.x * point.y, 0.0, 1.0);
    
    color = mix(color, grid, saturation);
    
    gl_FragColor = color * v_color_mix.a;
}
