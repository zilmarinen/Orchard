//
//  FoliageType.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Meadow

extension FoliageType {
    
    var description: String {
        
        switch self {
        
        case .bush: return "Bush"
        case .flower: return "Flower"
        case .tree: return "Tree"
        }
    }
    
    var color: Color {
        
        switch  self {
        case .bush: return Color(red: 0.16, green: 0.73, blue: 0.53, alpha: 0.7)
        case .flower: return Color(red: 0.92, green: 0.24, blue: 0.24, alpha: 0.7)
        case .tree: return Color(red: 0.09, green: 0.3, blue: 0.27, alpha: 0.7)
        }
    }
}
