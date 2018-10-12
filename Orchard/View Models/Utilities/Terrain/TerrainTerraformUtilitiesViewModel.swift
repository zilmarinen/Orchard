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
        
        case empty(meadow: Meadow?)
        case terraform(meadow: Meadow, toolType: ToolType, smooth: Bool)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class TerrainTerraformUtilitiesViewModel: BaseViewModel<ViewState> {
        
    }
}
