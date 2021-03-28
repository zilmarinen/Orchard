//
//  SurfaceTileType.swift
//
//  Created by Zack Brown on 11/03/2021.
//

import Meadow

extension SurfaceTileType {
    
    var abbreviation: String {
        
        switch self {
        
        case .dirt: return "D"
        case .grass: return "G"
        case .sand: return "S"
        case .undergrowth: return "U"
        case .water: return "W"
        }
    }
    
    var description: String {
        
        switch self {
        
        case .dirt: return "Dirt"
        case .grass: return "Grass"
        case .sand: return "Sand"
        case .undergrowth: return "Undergrowth"
        case .water: return "Water"
        }
    }
    
    var color: Color {
        
        switch  self {
        case .dirt: return Color(red: 0.81, green: 0.68, blue: 0.51)
        case .grass: return Color(red: 0.85, green: 0.85, blue: 0.69)
        case .sand: return Color(red: 0.96, green: 0.84, blue: 0.52)
        case .undergrowth: return Color(red: 0.30, green: 0.55, blue: 0.48)
        case .water: return Color(red: 0.81, green: 0.90, blue: 0.94)
        }
    }
}
