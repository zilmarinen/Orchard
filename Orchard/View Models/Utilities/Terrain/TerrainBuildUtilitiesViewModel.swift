//
//  TerrainBuildUtilitiesViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension TerrainBuildUtilitiesViewController {
    
    enum ViewState: State {
        
        case empty
        case inspecting(Terrain)
        
        func shouldTransition(to newState: TerrainBuildUtilitiesViewController.ViewState) -> Should<TerrainBuildUtilitiesViewController.ViewState> {
            
            return .continue
        }
        
        var sortOrder: Int {
            
            switch self {
                
            case .empty: return 0
                
            case .inspecting: return 1
            }
        }
    }
    
    class TerrainBuildUtilitiesViewModel: BaseViewModel<TerrainBuildUtilitiesViewController.ViewState> {
        
    }
}
