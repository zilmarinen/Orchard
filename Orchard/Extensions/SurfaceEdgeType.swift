//
//  SurfaceEdgeType.swift
//
//  Created by Zack Brown on 21/03/2021.
//

import Meadow

extension SurfaceEdgeType {
    
    var abbreviation: String {
        
        switch self {
        
        case .sloped: return "S"
        case .terraced: return "T"
        }
    }
    
    var description: String {
        
        switch self {
        
        case .sloped: return "Sloped"
        case .terraced: return "Terraced"
        }
    }
}
