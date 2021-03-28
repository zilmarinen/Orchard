//
//  WaterTileType.swift
//
//  Created by Zack Brown on 21/03/2021.
//

import Meadow

extension WaterTileType {
    
    var description: String {
        
        switch self {
        
        case .water: return "Water"
        }
    }
    
    var color: Color {
        
        switch self {
        
        case .water: return Color(red: 0.73, green: 0.94, blue: 0.98, alpha: 0.7)
        }
    }
}
