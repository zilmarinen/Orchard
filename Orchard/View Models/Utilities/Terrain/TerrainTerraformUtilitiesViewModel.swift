//
//  TerrainTerraformUtilitiesViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension TerrainTerraformUtilitiesViewController {
    
    enum ToolType: Int {
        
        case corner
        case edge
        case tile
    }
    
    enum ViewState: THRUtilities.State {
        
        case empty
        case inspecting(Terrain, ToolType, Bool)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
        
        var sortOrder: Int {
            
            switch self {
                
            case .empty: return 0
                
            case .inspecting: return 1
            }
        }
    }
    
    class TerrainTerraformUtilitiesViewModel: BaseViewModel<ViewState> {
        
    }
}
