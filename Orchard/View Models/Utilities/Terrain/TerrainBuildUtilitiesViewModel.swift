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
    
    enum ToolType: Int {
        
        case edge
        case tile
    }
    
    enum ViewState: THRUtilities.State {
        
        case empty(editor: Editor?)
        case build(editor: Editor, tool: (toolType: ToolType, terrainType: TerrainType))
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class TerrainBuildUtilitiesViewModel: BaseViewModel<ViewState> {
        
    }
}
