//
//  Footpath2D.fsh
//
//  Created by Zack Brown on 25/03/2021.
//

void main()
{
    vec4 color = texture2D(u_texture, v_tex_coord);
    
    if (color.a == 0.0) {
        
        discard;
    }
    
    gl_FragColor = color * v_color_mix.a;
}
