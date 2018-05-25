//
//  FoliageInspectorViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension FoliageInspectorViewController {
    
    enum ViewState: State {
        
        case empty
        case inspecting(Foliage)
        
        func shouldTransition(to newState: FoliageInspectorViewController.ViewState) -> Should<FoliageInspectorViewController.ViewState> {
            
            return .continue
        }
    }
    
    class FoliageInspectorViewModel: BaseViewModel<FoliageInspectorViewController.ViewState> {
        
    }
}
