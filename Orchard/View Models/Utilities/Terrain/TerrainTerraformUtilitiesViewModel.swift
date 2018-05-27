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
    
    enum ViewState: State {
        
        case empty
        case inspecting(Terrain, ToolType, Bool)
        
        func shouldTransition(to newState: TerrainTerraformUtilitiesViewController.ViewState) -> Should<TerrainTerraformUtilitiesViewController.ViewState> {
            
            return .continue
        }
        
        var sortOrder: Int {
            
            switch self {
                
            case .empty: return 0
                
            case .inspecting: return 1
            }
        }
    }
    
    class TerrainTerraformUtilitiesViewModel: BaseViewModel<TerrainTerraformUtilitiesViewController.ViewState> {
        
    }
}
