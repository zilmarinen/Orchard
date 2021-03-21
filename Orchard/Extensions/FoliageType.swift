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
}
