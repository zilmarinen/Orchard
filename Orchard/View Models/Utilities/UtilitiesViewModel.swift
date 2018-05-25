//
//  UtilitiesViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension UtilitiesViewController {
    
    enum ViewState: State {
        
        case empty
        case inspecting(Meadow)
        
        func shouldTransition(to newState: UtilitiesViewController.ViewState) -> Should<UtilitiesViewController.ViewState> {
            
            return .continue
        }
    }

    class UtilitiesViewModel: BaseViewModel<UtilitiesViewController.ViewState> {
        
    }
}
