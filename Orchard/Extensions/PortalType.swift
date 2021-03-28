//
//  PortalType.swift
//
//  Created by Zack Brown on 28/03/2021.
//

import Meadow

extension PortalType {
    
    var description: String {
        
        switch self {
        
        case .door: return "Door"
        case .seam: return "Seam"
        case .spawn: return "Spawn"
        }
    }
}
