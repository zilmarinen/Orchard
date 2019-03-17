//
//  TerrainInspectorViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 24/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

typealias TerrainInspectable = (grid: Terrain, chunk: TerrainChunk?, tile: TerrainTile?, node: TerrainNode<TerrainNodeEdge<TerrainNodeEdgeLayer>>?, edge: TerrainNodeEdge<TerrainNodeEdgeLayer>?, layer: TerrainNodeEdgeLayer?)

extension TerrainInspectorViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty
        case terrain(editor: Editor, inspectable: TerrainInspectable)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class TerrainInspectorViewModel: BaseViewModel<ViewState> {
        
    }
}

