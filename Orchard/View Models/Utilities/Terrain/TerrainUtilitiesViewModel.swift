//
//  TerrainUtilitiesViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension TerrainUtilitiesViewController {
    
    enum ViewState: State {
        
        case empty
        case inspecting(Terrain)
        
        func shouldTransition(to newState: TerrainUtilitiesViewController.ViewState) -> Should<TerrainUtilitiesViewController.ViewState> {
            
            return .continue
        }
    }
    
    class TerrainUtilitiesViewModel: BaseViewModel<TerrainUtilitiesViewController.ViewState> {
        
    }
}
