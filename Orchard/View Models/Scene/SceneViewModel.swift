//
//  SceneViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 31/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension SceneViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty
        case editor(Meadow, SceneView.CursorModel)
        
        func shouldTransition(to newState: SceneViewController.ViewState) -> THRUtilities.Should<SceneViewController.ViewState> {
            
            return .continue
        }
    }
    
    class SceneViewModel: BaseViewModel<ViewState> {
        
    }
}
