//
//  SceneInspectorViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension SceneInspectorViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty
        case inspecting(Meadow)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class SceneInspectorViewModel: BaseViewModel<ViewState> {
        
    }
}
