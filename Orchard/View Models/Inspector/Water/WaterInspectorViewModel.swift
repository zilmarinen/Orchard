//
//  WaterInspectorViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension WaterInspectorViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty
        case inspecting(Water, (WaterChunk, WaterTile, WaterNode)?)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class WaterInspectorViewModel: BaseViewModel<ViewState> {
        
    }
}
