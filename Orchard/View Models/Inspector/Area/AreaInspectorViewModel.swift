//
//  AreaInspectorViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension AreaInspectorViewController {
    
    enum ViewState: State {
        
        case empty
        case inspecting(Area)
        
        func shouldTransition(to newState: AreaInspectorViewController.ViewState) -> Should<AreaInspectorViewController.ViewState> {
            
            return .continue
        }
    }
    
    class AreaInspectorViewModel: BaseViewModel<AreaInspectorViewController.ViewState> {
        
    }
}
