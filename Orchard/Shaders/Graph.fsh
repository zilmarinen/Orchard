//
//  Graph.fsh
//
//  Created by Zack Brown on 25/03/2021.
//

void main()
{
    float offset = 0.1;
    
    vec4 grid = vec4(clamp(v_color_mix.r + offset, 0.0, 1.0),
                     clamp(v_color_mix.g + offset, 0.0, 1.0),
                     clamp(v_color_mix.b + offset, 0.0, 1.0), v_color_mix.a);
    
    bool x = mod(u_size.x * v_tex_coord.x, 2.0) < 1.0;
    bool y = mod(u_size.y * v_tex_coord.y, 2.0) < 1.0;
    
    if ((x == true && y == false) || (x == false && y == true)) {
            
        gl_FragColor = grid * v_color_mix.a;
        
    } else {
        
        gl_FragColor = v_color_mix * v_color_mix.a;
    }
}
