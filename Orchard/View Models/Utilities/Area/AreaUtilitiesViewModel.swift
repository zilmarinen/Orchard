//
//  AreaUtilitiesViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 28/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension AreaUtilitiesViewController {
    
    enum ViewState: State {
        
        case empty
        case inspecting(Area)
        
        func shouldTransition(to newState: AreaUtilitiesViewController.ViewState) -> Should<AreaUtilitiesViewController.ViewState> {
            
            return .continue
        }
    }
    
    class AreaUtilitiesViewModel: BaseViewModel<AreaUtilitiesViewController.ViewState> {
        
    }
}
