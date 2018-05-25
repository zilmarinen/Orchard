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
    
    enum ViewState: State {
        
        case empty
        case inspecting(Meadow)
        
        func shouldTransition(to newState: SceneInspectorViewController.ViewState) -> Should<SceneInspectorViewController.ViewState> {
            
            return .continue
        }
    }
    
    class SceneInspectorViewModel: BaseViewModel<SceneInspectorViewController.ViewState> {
        
    }
}
