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
    
    enum ViewState: State {
        
        case empty
        case inspecting(Terrain, (TerrainTile, TerrainNode, TerrainLayer)?)
        
        func shouldTransition(to newState: TerrainInspectorViewController.ViewState) -> Should<TerrainInspectorViewController.ViewState> {
            
            return .continue
        }
    }
    
    class TerrainInspectorViewModel: BaseViewModel<TerrainInspectorViewController.ViewState> {
        
    }
}

