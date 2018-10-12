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
    
    enum ViewState: THRUtilities.State {
        
        case empty(meadow: Meadow?)
        case terrain(meadow: Meadow)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class TerrainUtilitiesViewModel: BaseViewModel<ViewState> {
        
    }
}
