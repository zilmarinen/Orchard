//
//  TerrainInspectorViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 24/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension TerrainInspectorViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty
        case inspecting(Terrain, (TerrainChunk, TerrainTile, TerrainNode<TerrainLayer>, TerrainLayer, GridEdge)?)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class TerrainInspectorViewModel: BaseViewModel<ViewState> {
        
    }
}

