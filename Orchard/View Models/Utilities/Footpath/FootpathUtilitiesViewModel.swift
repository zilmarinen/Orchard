//
//  FootpathUtilitiesViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 28/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension FootpathUtilitiesViewController {
    
    enum ViewState: State {
        
        case empty
        case inspecting(Terrain)
        
        func shouldTransition(to newState: FootpathUtilitiesViewController.ViewState) -> Should<FootpathUtilitiesViewController.ViewState> {
            
            return .continue
        }
    }
    
    class FootpathUtilitiesViewModel: BaseViewModel<FootpathUtilitiesViewController.ViewState> {
        
    }
}
