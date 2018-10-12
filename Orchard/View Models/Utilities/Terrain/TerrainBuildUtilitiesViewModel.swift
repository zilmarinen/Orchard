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
    
    enum ViewState: THRUtilities.State {
        
        case empty(meadow: Meadow?)
        case build(meadow: Meadow, terrainType: TerrainType)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class TerrainBuildUtilitiesViewModel: BaseViewModel<ViewState> {
        
    }
}
