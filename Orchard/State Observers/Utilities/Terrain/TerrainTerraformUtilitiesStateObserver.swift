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
        
        case empty(editor: Editor?)
        case terraform(editor: Editor, tool: (toolType: ToolType, reticule: (width: Int, depth: Int)))
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class TerrainTerraformUtilitiesStateObserver: BaseViewModel<ViewState> {
        
    }
}
