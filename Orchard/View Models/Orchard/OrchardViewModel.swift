//
//  OrchardViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 31/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension OrchardViewController {
    
    enum ViewState: THRUtilities.State {
        
        case editor(Meadow)
        
        func shouldTransition(to newState: OrchardViewController.ViewState) -> THRUtilities.Should<OrchardViewController.ViewState> {
            
            return .continue
        }
    }
    
    class OrchardViewModel: BaseViewModel<ViewState> {
        
    }
}
