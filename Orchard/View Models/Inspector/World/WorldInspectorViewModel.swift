//
//  WorldInspectorViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 16/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension WorldInspectorViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty
        case inspecting(World)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class WorldInspectorViewModel: BaseViewModel<ViewState> {
        
    }
}
