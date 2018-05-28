//
//  WaterUtilitiesViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 28/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension WaterUtilitiesViewController {
    
    enum ViewState: State {
        
        case empty
        case inspecting(Water)
        
        func shouldTransition(to newState: WaterUtilitiesViewController.ViewState) -> Should<WaterUtilitiesViewController.ViewState> {
            
            return .continue
        }
    }
    
    class WaterUtilitiesViewModel: BaseViewModel<WaterUtilitiesViewController.ViewState> {
        
    }
}
