//
//  SKShader.swift
//
//  Created by Zack Brown on 02/04/2021.
//

import SpriteKit

extension SKShader {
    
    enum Shader: String {
        
        case building = "Building2D"
        case foliage = "Foliage2D"
        case footpath = "Footpath2D"
        case graph = "Graph2D"
        case surface = "Surface2D"
        case water = "Water2D"
    }
    
    convenience init(shader: Shader) {
        
        self.init(fileNamed: "\(shader.rawValue).fsh")
    }
}
