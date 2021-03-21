//
//  SurfaceEdgeType.swift
//  Orchard
//
//  Created by Zack Brown on 21/03/2021.
//

import Meadow

extension SurfaceEdgeType {
    
    var description: String {
        
        switch self {
        
        case .sloped: return "Sloped"
        case .terraced: return "Terraced"
        }
    }
}
