//
//  TerrainPaintUtilitiesViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension TerrainPaintUtilitiesViewController {
    
    enum ToolType: Int {
        
        case edge
        case tile
    }
    
    enum ViewState: THRUtilities.State {
        
        case empty(editor: Editor?)
        case paint(editor: Editor, tool: (toolType: ToolType, terrainType: TerrainType))
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class TerrainPaintUtilitiesViewModel: BaseViewModel<ViewState> {
        
    }
}
