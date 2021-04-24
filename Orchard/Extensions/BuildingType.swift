//
//  BuildingType.swift
//  Orchard
//
//  Created by Zack Brown on 09/04/2021.
//

import Meadow

extension BuildingType {
    
    var description: String {
        
        switch self {
        
        case .house: return "House"
        }
    }
    
    var color: Color {
        
        switch  self {
        case .house: return Color(red: 0.73, green: 0.53, blue: 0.16, alpha: 0.7)
        }
    }
}
