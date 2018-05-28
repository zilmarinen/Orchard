//
//  FoliageUtilitiesViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 28/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension FoliageUtilitiesViewController {
    
    enum ViewState: State {
        
        case empty
        case inspecting(Terrain)
        
        func shouldTransition(to newState: FoliageUtilitiesViewController.ViewState) -> Should<FoliageUtilitiesViewController.ViewState> {
            
            return .continue
        }
    }
    
    class FoliageUtilitiesViewModel: BaseViewModel<FoliageUtilitiesViewController.ViewState> {
        
    }
}
