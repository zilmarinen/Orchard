//
//  WaterInspectorViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension FootpathInspectorViewController {
    
    enum ViewState: State {
        
        case empty
        case inspecting(Footpath)
        
        func shouldTransition(to newState: FootpathInspectorViewController.ViewState) -> Should<FootpathInspectorViewController.ViewState> {
            
            return .continue
        }
    }
    
    class FootpathInspectorViewModel: BaseViewModel<FootpathInspectorViewController.ViewState> {
        
    }
}
